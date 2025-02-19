GLOBAL_LIST_EMPTY(admin_datums)
GLOBAL_PROTECT(admin_datums)
GLOBAL_LIST_EMPTY(protected_admins)
GLOBAL_PROTECT(protected_admins)

GLOBAL_VAR_INIT(href_token, GenerateToken())
GLOBAL_PROTECT(href_token)

/datum/admins
	var/list/datum/admin_rank/ranks

	var/target
	var/name = "nobody's admin datum (no rank)" //Makes for better runtimes
	var/client/owner = null
	var/fakekey = null

	var/datum/marked_datum

	var/admincaster_screen = 0	//See newscaster.dm under machinery for a full description
	var/datum/feed_message/admincaster_feed_message = new /datum/feed_message   //These two will act as holders.
	var/datum/feed_channel/admincaster_feed_channel = new /datum/feed_channel
	var/admincaster_signature	//What you'll sign the newsfeeds as

	var/href_token

	/// Link from the database pointing to the admin's feedback forum
	var/cached_feedback_link

	var/deadmined

	var/given_profiling = FALSE


/datum/admins/New(list/datum/admin_rank/ranks, ckey, force_active = FALSE, protected)
	if(IsAdminAdvancedProcCall())
		alert_to_permissions_elevation_attempt(usr)
		if (!target) //only del if this is a true creation (and not just a New() proc call), other wise trialmins/coders could abuse this to deadmin other admins
			QDEL_IN(src, 0)
			CRASH("Admin proc call creation of admin datum")
		return
	if(!ckey)
		QDEL_IN(src, 0)
		CRASH("Admin datum created without a ckey")
	if(!istype(ranks))
		QDEL_IN(src, 0)
		CRASH("Admin datum created with invalid ranks: [ranks] ([json_encode(ranks)])")
	target = ckey
	name = "[ckey]'s admin datum ([join_admin_ranks(ranks)])"
	src.ranks = ranks
	admincaster_signature = "[using_map.company_name] Officer #[rand(0,9)][rand(0,9)][rand(0,9)]"
	href_token = GenerateToken()
	if(protected)
		GLOB.protected_admins[target] = src
	activate()

/datum/admins/Destroy()
	if(IsAdminAdvancedProcCall())
		alert_to_permissions_elevation_attempt(usr)
		return QDEL_HINT_LETMELIVE
	. = ..()

/datum/admins/proc/activate()
	if(IsAdminAdvancedProcCall())
		alert_to_permissions_elevation_attempt(usr)
		return
	GLOB.deadmins -= target
	GLOB.admin_datums[target] = src
	deadmined = FALSE
	//plane_debug = new(src)
	if (GLOB.directory[target])
		associate(GLOB.directory[target]) //find the client for a ckey if they are connected and associate them with us

/datum/admins/proc/deactivate()
	if(IsAdminAdvancedProcCall())
		alert_to_permissions_elevation_attempt(usr)
		return
	GLOB.deadmins[target] = src
	GLOB.admin_datums -= target
	//QDEL_NULL(plane_debug)
	deadmined = TRUE

	var/client/client = owner || GLOB.directory[target]

	if (!isnull(client))
		disassociate()
		add_verb(client, /client/proc/readmin)
		//client.disable_combo_hud()
		//client.update_special_keybinds()

/datum/admins/proc/associate(client/client)
	if(IsAdminAdvancedProcCall())
		alert_to_permissions_elevation_attempt(usr)
		return

	if(!istype(client))
		return

	if(client?.ckey != target)
		var/msg = " has attempted to associate with [target]'s admin datum"
		message_admins("[key_name_admin(client)][msg]")
		log_admin("[key_name(client)][msg]")
		return

	if (deadmined)
		activate()

	owner = client
	owner.holder = src
	owner.add_admin_verbs()
	remove_verb(owner, /client/proc/readmin)
	owner.init_verbs() //re-initialize the verb list
	//owner.update_special_keybinds()
	GLOB.admins |= client

	try_give_profiling()

/datum/admins/proc/disassociate()
	if(IsAdminAdvancedProcCall())
		alert_to_permissions_elevation_attempt(usr)
		return
	if(owner)
		GLOB.admins -= owner
		owner.remove_admin_verbs()
		// owner.init_verbs() //re-initialize the verb list
		owner.holder = null
		owner = null

/// Returns the feedback forum thread for the admin holder's owner, as according to DB.
/datum/admins/proc/feedback_link()
	// This intentionally does not follow the 10-second maximum TTL rule,
	// as this can be reloaded through the Reload-Admins verb.
	if (cached_feedback_link == NO_FEEDBACK_LINK)
		return null

	if (!isnull(cached_feedback_link))
		return cached_feedback_link

	if (!SSdbcore.IsConnected())
		return FALSE

	var/datum/db_query/feedback_query = SSdbcore.NewQuery("SELECT feedback FROM [format_table_name("admin")] WHERE ckey = '[owner.ckey]'")

	if(!feedback_query.Execute())
		log_sql("Error retrieving feedback link for [src]")
		qdel(feedback_query)
		return FALSE

	if(!feedback_query.NextRow())
		qdel(feedback_query)
		return FALSE // no feedback link exists

	cached_feedback_link = feedback_query.item[1] || NO_FEEDBACK_LINK
	qdel(feedback_query)

	if (cached_feedback_link == NO_FEEDBACK_LINK) // Because we don't want to send fake clickable links.
		return null

	return cached_feedback_link

/datum/admins/proc/check_for_rights(rights_required)
	if(rights_required && !(rights_required & rank_flags()))
		return FALSE
	return TRUE

/datum/admins/proc/check_if_greater_rights_than_holder(datum/admins/other)
	if(!other)
		return TRUE //they have no rights
	if(rank_flags() == R_EVERYTHING)
		return TRUE //we have all the rights
	if(src == other)
		return TRUE //you always have more rights than yourself
	if(rank_flags() != other.rank_flags())
		if( (rank_flags() & other.rank_flags()) == other.rank_flags() )
			return TRUE //we have all the rights they have and more
	return FALSE

/// Get the rank name of the admin
/datum/admins/proc/rank_names()
	return join_admin_ranks(ranks)

/// Get the rank flags of the admin
/datum/admins/proc/rank_flags()
	var/combined_flags = NONE

	for (var/datum/admin_rank/rank as anything in ranks)
		combined_flags |= rank.rights

	return combined_flags

/// Get the permissions this admin is allowed to edit on other ranks
/datum/admins/proc/can_edit_rights_flags()
	var/combined_flags = NONE

	for (var/datum/admin_rank/rank as anything in ranks)
		combined_flags |= rank.can_edit_rights

	return combined_flags

/datum/admins/proc/try_give_profiling()
	if (CONFIG_GET(flag/forbid_admin_profiling))
		return

	if (given_profiling)
		return

	if (!(rank_flags() & R_DEBUG))
		return

	given_profiling = TRUE
	world.SetConfig("APP/admin", owner.ckey, "role=admin")

/datum/admins/vv_edit_var(var_name, var_value)
	return FALSE //nice try trialmin

/*
checks if usr is an admin with at least ONE of the flags in rights_required. (Note, they don't need all the flags)
if rights_required == 0, then it simply checks if they are an admin.
if it doesn't return 1 and show_msg=1 it will prints a message explaining why the check has failed
generally it would be used like so:

/proc/admin_proc()
	if(!check_rights(R_ADMIN))
		return
	to_chat(world, "you have enough rights!", confidential = TRUE)

NOTE: it checks usr! not src! So if you're checking somebody's rank in a proc which they did not call
you will have to do something like if(client.rights & R_ADMIN) yourself.
*/
/proc/check_rights(rights_required, show_msg=1)
	if(usr?.client)
		if (check_rights_for(usr.client, rights_required))
			return TRUE
		else
			if(show_msg)
				to_chat(usr, "<font color='red'>Error: You do not have sufficient rights to do that. You require one of the following flags:[rights2text(rights_required," ")].</font>", confidential = TRUE)
	return FALSE

//probably a bit iffy - will hopefully figure out a better solution
/proc/check_if_greater_rights_than(client/other)
	if(usr?.client)
		if(usr.client.holder)
			if(!other || !other.holder)
				return TRUE
			return usr.client.holder.check_if_greater_rights_than_holder(other.holder)
	return FALSE

//This proc checks whether subject has at least ONE of the rights specified in rights_required.
/proc/check_rights_for(client/subject, rights_required)
	if(subject?.holder)
		return subject.holder.check_for_rights(rights_required)
	return FALSE

/client/proc/mark_datum(datum/D)
	if(!holder)
		return
	if(holder.marked_datum)
		vv_update_display(holder.marked_datum, "marked", "")
	holder.marked_datum = D
	vv_update_display(D, "marked", VV_MSG_MARKED)

/client/proc/mark_datum_mapview(datum/D as mob|obj|turf|area in view(view))
	set category = "Debug.Game"
	set name = "Mark Object"
	mark_datum(D)

/proc/GenerateToken()
	. = ""
	for(var/I in 1 to 32)
		. += "[rand(10)]"

/proc/RawHrefToken(forceGlobal = FALSE)
	var/tok = GLOB.href_token
	if(!forceGlobal && usr)
		var/client/C = usr.client
		if(!C)
			CRASH("No client for HrefToken()!")
		var/datum/admins/holder = C.holder
		if(holder)
			tok = holder.href_token
	return tok

/proc/HrefToken(forceGlobal = FALSE)
	return "admin_token=[RawHrefToken(forceGlobal)]"

/proc/HrefTokenFormField(forceGlobal = FALSE)
	return "<input type='hidden' name='admin_token' value='[RawHrefToken(forceGlobal)]'>"
