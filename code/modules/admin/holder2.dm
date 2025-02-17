GLOBAL_VAR_INIT(href_token, GenerateToken())
GLOBAL_PROTECT(href_token)

var/list/admin_datums = list()

/datum/admins
	var/datum/admin_rank/rank

	var/client/owner	= null
	var/fakekey			= null

	var/datum/marked_datum

	var/admincaster_screen = 0	//See newscaster.dm under machinery for a full description
	var/datum/feed_message/admincaster_feed_message = new /datum/feed_message   //These two will act as holders.
	var/datum/feed_channel/admincaster_feed_channel = new /datum/feed_channel
	var/admincaster_signature	//What you'll sign the newsfeeds as

	var/href_token


/datum/admins/New(datum/admin_rank/R, ckey)
	if(!ckey)
		error("Admin datum created without a ckey argument. Datum has been deleted")
		qdel(src)
		return
	if(!istype(R))
		error("Admin datum created without a rank. Datum has been deleted")
		del(src)
		return
	rank = R
	admincaster_signature = "[using_map.company_name] Officer #[rand(0,9)][rand(0,9)][rand(0,9)]"
	href_token = GenerateToken()
	admin_datums[ckey] = src
	if(check_rights(R_DEBUG)) //grant profile access
		world.SetConfig("APP/admin", ckey, "role=admin")

/datum/admins/Destroy()
	. = ..()

/datum/admins/proc/associate(client/client)
	if(!istype(client))
		return

	owner = client
	owner.holder = src
	owner.add_admin_verbs()
	owner.init_verbs() //re-initialize the verb list
	GLOB.admins |= client

/datum/admins/proc/disassociate()
	if(owner)
		GLOB.admins -= owner
		owner.remove_admin_verbs()
		owner.init_verbs() //re-initialize the verb list
		owner.deadmin_holder = owner.holder
		owner.holder = null

/datum/admins/proc/reassociate()
	if(owner)
		GLOB.admins += owner
		owner.holder = src
		owner.deadmin_holder = null
		owner.add_admin_verbs()

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
	if(usr && usr.client)
		if(usr.client.holder)
			if(!other || !other.holder)
				return 1
			if(usr.client.holder.rank.rights != other.holder.rank.rights)	//Check values smaller than 65536
				if( (usr.client.holder.rank.rights & other.holder.rank.rights) == other.holder.rank.rights )
					return 1	//we have all the rights they have and more
		to_chat(usr, span_filter_adminlog(span_warning("Error: Cannot proceed. They have greater or equal rights to us.")))
	return 0

//This proc checks whether subject has at least ONE of the rights specified in rights_required.
/proc/check_rights_for(client/subject, rights_required)
	if(subject && subject?.holder && subject.holder.rank)
		if(rights_required && !(rights_required & subject.holder.rank.rights))
			return 0
		return 1
	return 0

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

/client/proc/deadmin()
	if(holder)
		holder.disassociate()
		//qdel(holder)
	return 1

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
