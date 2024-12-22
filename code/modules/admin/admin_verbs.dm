/client/proc/hide_most_verbs()//Allows you to keep some functionality while hiding some verbs
	set name = "Adminverbs - Hide Most"
	set category = "Admin.Misc"

	remove_verb(src, list(/client/proc/hide_most_verbs, admin_verbs_hideable))
	add_verb(src, /client/proc/show_verbs)

	to_chat(src, span_filter_system(span_interface("Most of your adminverbs have been hidden.")))
	feedback_add_details("admin_verb","HMV") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/hide_verbs()
	set name = "Adminverbs - Hide All"
	set category = "Admin.Misc"

	remove_admin_verbs()
	add_verb(src, /client/proc/show_verbs)

	to_chat(src, span_filter_system(span_interface("Almost all of your adminverbs have been hidden.")))
	feedback_add_details("admin_verb","TAVVH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Admin.Misc"

	remove_verb(src, /client/proc/show_verbs)
	add_admin_verbs()

	to_chat(src, span_filter_adminlog(span_interface("All of your adminverbs are now visible.")))
	feedback_add_details("admin_verb","TAVVS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/admin_ghost()
	set category = "Admin.Game"
	set name = "Aghost"
	if(!holder)	return

	var/build_mode
	if(src.buildmode)
		build_mode = tgui_alert(src, "You appear to be currently in buildmode. Do you want to re-enter buildmode after aghosting?", "Buildmode", list("Yes", "No"))
		if(build_mode != "Yes")
			to_chat(src, "Will not re-enter buildmode after switch.")

	if(istype(mob,/mob/observer/dead))
		//re-enter
		var/mob/observer/dead/ghost = mob
		if(ghost.can_reenter_corpse)
			if(build_mode)
				togglebuildmode(mob)
				ghost.reenter_corpse()
				if(build_mode == "Yes")
					togglebuildmode(mob)
			else
				ghost.reenter_corpse()
		else
			to_chat(ghost, span_filter_system(span_warning("Error:  Aghost:  Can't reenter corpse.")))
			return

		feedback_add_details("admin_verb","P") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	else if(istype(mob,/mob/new_player))
		to_chat(src, span_filter_system(span_warning("Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.")))
	else
		//ghostize
		var/mob/body = mob
		var/mob/observer/dead/ghost
		if(build_mode)
			togglebuildmode(body)
			ghost = body.ghostize(1, TRUE)
			if(build_mode == "Yes")
				togglebuildmode(ghost)
		else
			ghost = body.ghostize(1, TRUE)
		init_verbs()
		if(body)
			body.teleop = ghost
			if(!body.key)
				body.key = "@[key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		feedback_add_details("admin_verb","O") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/invisimin()
	set name = "Invisimin"
	set category = "Admin.Game"
	set desc = "Toggles ghost-like invisibility (Don't abuse this)"
	if(holder && mob)
		if(mob.invisibility == INVISIBILITY_OBSERVER)
			mob.invisibility = initial(mob.invisibility)
			to_chat(mob, span_filter_system(span_danger("Invisimin off. Invisibility reset.")))
			mob.alpha = max(mob.alpha + 100, 255)
		else
			mob.invisibility = INVISIBILITY_OBSERVER
			to_chat(mob, span_filter_system(span_boldnotice("Invisimin on. You are now as invisible as a ghost.")))
			mob.alpha = max(mob.alpha - 100, 0)


/client/proc/player_panel()
	set name = "Player Panel"
	set category = "Admin.Game"
	if(holder)
		holder.player_panel_old()
	feedback_add_details("admin_verb","PP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/player_panel_new()
	set name = "Player Panel New"
	set category = "Admin.Game"
	if(holder)
		holder.player_panel_new()
	feedback_add_details("admin_verb","PPN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/check_antagonists()
	set name = "Check Antagonists"
	set category = "Admin.Investigate"
	if(holder)
		holder.check_antagonists()
		log_admin("[key_name(usr)] checked antagonists.")	//for tsar~
	feedback_add_details("admin_verb","CHA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/jobbans()
	set name = "Display Job bans"
	set category = "Admin.Investigate"
	if(holder)
		if(CONFIG_GET(flag/ban_legacy_system))
			holder.Jobbans()
		else
			holder.DB_ban_panel()
	feedback_add_details("admin_verb","VJB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/unban_panel()
	set name = "Unban Panel"
	set category = "Admin.Game"
	if(holder)
		if(CONFIG_GET(flag/ban_legacy_system))
			holder.unbanpanel()
		else
			holder.DB_ban_panel()
	feedback_add_details("admin_verb","UBP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/game_panel()
	set name = "Game Panel"
	set category = "Admin.Game"
	if(holder)
		holder.Game()
	feedback_add_details("admin_verb","GP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/secrets()
	set name = "Secrets"
	set category = "Admin.Secrets"
	if (holder)
		holder.Secrets()
	feedback_add_details("admin_verb","S") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/colorooc()
	set category = "Admin.Misc"
	set name = "OOC Text Color"
	if(!holder)	return
	var/response = tgui_alert(src, "Please choose a distinct color that is easy to read and doesn't mix with all the other chat and radio frequency colors.", "Change own OOC color", list("Pick new color", "Reset to default", "Cancel"))
	if(response == "Pick new color")
		prefs.ooccolor = input(src, "Please select your OOC colour.", "OOC colour") as color
	else if(response == "Reset to default")
		prefs.ooccolor = initial(prefs.ooccolor)
	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","OC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/findStealthKey(txt)
	if(txt)
		for(var/P in GLOB.stealthminID)
			if(GLOB.stealthminID[P] == txt)
				return P
	txt = GLOB.stealthminID[ckey]
	return txt

/client/proc/createStealthKey()
	var/num = (rand(0,1000))
	var/i = 0
	while(i == 0)
		i = 1
		for(var/P in GLOB.stealthminID)
			if(num == GLOB.stealthminID[P])
				num++
				i = 0
	GLOB.stealthminID["[ckey]"] = "@[num2text(num)]"

/client/proc/stealth()
	set category = "Admin.Game"
	set name = "Stealth Mode"
	if(holder)
		if(holder.fakekey)
			holder.fakekey = null
			if(istype(src.mob, /mob/new_player))
				mob.name = capitalize(ckey)
		else
			var/new_key = ckeyEx(tgui_input_text(usr, "Enter your desired display name.", "Fake Key", key))
			if(!new_key)
				return
			if(length(new_key) >= 26)
				new_key = copytext(new_key, 1, 26)
			holder.fakekey = new_key
			createStealthKey()
			if(istype(mob, /mob/new_player))
				mob.name = new_key
		log_and_message_admins("[key_name(usr)] has turned stealth mode [holder.fakekey ? "ON" : "OFF"]")
	feedback_add_details("admin_verb","SM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

#define MAX_WARNS 3
#define AUTOBANTIME 10

/client/proc/warn(warned_ckey)
	if(!check_rights(R_ADMIN))	return

	if(!warned_ckey || !istext(warned_ckey))	return
	if(warned_ckey in admin_datums)
		to_chat(usr, span_warning("Error: warn(): You can't warn admins."))
		return

	var/datum/preferences/D
	var/client/C = GLOB.directory[warned_ckey]
	if(C)	D = C.prefs
	else	D = preferences_datums[warned_ckey]

	if(!D)
		to_chat(src, span_warning("Error: warn(): No such ckey found."))
		return

	if(++D.warns >= MAX_WARNS)					//uh ohhhh...you'reee iiiiin trouuuubble O:)
		ban_unban_log_save("[ckey] warned [warned_ckey], resulting in a [AUTOBANTIME] minute autoban.")
		if(C)
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)] resulting in a [AUTOBANTIME] minute ban.")
			to_chat(C, span_filter_system(span_danger("<BIG>You have been autobanned due to a warning by [ckey].</BIG><br>This is a temporary ban, it will be removed in [AUTOBANTIME] minutes.")))
			del(C)
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] resulting in a [AUTOBANTIME] minute ban.")
		AddBan(warned_ckey, D.last_id, "Autobanning due to too many formal warnings", ckey, 1, AUTOBANTIME)
		feedback_inc("ban_warn",1)
	else
		if(C)
			to_chat(C, span_filter_system(span_danger("<BIG>You have been formally warned by an administrator.</BIG><br>Further warnings will result in an autoban.")))
			message_admins("[key_name_admin(src)] has warned [key_name_admin(C)]. They have [MAX_WARNS-D.warns] strikes remaining.")
		else
			message_admins("[key_name_admin(src)] has warned [warned_ckey] (DC). They have [MAX_WARNS-D.warns] strikes remaining.")

	feedback_add_details("admin_verb","WARN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

#undef MAX_WARNS
#undef AUTOBANTIME

/client/proc/drop_bomb() // Some admin dickery that can probably be done better -- TLE
	set category = "Fun.Do Not"
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."

	var/turf/epicenter = mob.loc
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb", "Cancel")
	var/choice = tgui_input_list(usr, "What size explosion would you like to produce?", "Explosion Choice", choices)
	switch(choice)
		if(null)
			return 0
		if("Cancel")
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)
		if("Custom Bomb")
			var/devastation_range = tgui_input_number(usr, "Devastation range (in tiles):")
			var/heavy_impact_range = tgui_input_number(usr, "Heavy impact range (in tiles):")
			var/light_impact_range = tgui_input_number(usr, "Light impact range (in tiles):")
			var/flash_range = tgui_input_number(usr, "Flash range (in tiles):")
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	message_admins(span_blue("[ckey] creating an admin explosion at [epicenter.loc]."))
	feedback_add_details("admin_verb","DB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/admin_give_modifier(var/mob/living/L)
	set category = "Debug.Game"
	set name = "Give Modifier"
	set desc = "Makes a mob weaker or stronger by adding a specific modifier to them."
	set popup_menu = FALSE //VOREStation Edit - Declutter.

	if(!L)
		to_chat(usr, span_warning("Looks like you didn't select a mob."))
		return

	var/list/possible_modifiers = subtypesof(/datum/modifier)

	var/new_modifier_type = tgui_input_list(usr, "What modifier should we add to [L]?", "Modifier Type", possible_modifiers)
	if(!new_modifier_type)
		return
	var/duration = tgui_input_number(usr, "How long should the new modifier last, in seconds.  To make it last forever, write '0'.", "Modifier Duration")
	if(duration == 0)
		duration = null
	else
		duration = duration SECONDS

	L.add_modifier(new_modifier_type, duration)
	log_and_message_admins("has given [key_name(L)] the modifer [new_modifier_type], with a duration of [duration ? "[duration / 600] minutes" : "forever"].")

/client/proc/make_sound(var/obj/O in world) // -- TLE
	set category = "Fun.Sounds"
	set name = "Make Sound"
	set desc = "Display a message to everyone who can hear the target"
	if(O)
		var/message = sanitize(tgui_input_text(usr, "What do you want the message to be?", "Make Sound"))
		if(!message)
			return
		O.audible_message(message)
		log_admin("[key_name(usr)] made [O] at [O.x], [O.y], [O.z]. make a sound")
		message_admins(span_blue("[key_name_admin(usr)] made [O] at [O.x], [O.y], [O.z]. make a sound."), 1)
		feedback_add_details("admin_verb","MS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/togglebuildmodeself()
	set name = "Toggle Build Mode Self"
	set category = "Debug.Events"
	if(src.mob)
		togglebuildmode(src.mob)
	feedback_add_details("admin_verb","TBMS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/object_talk(var/msg as text) // -- TLE
	set category = "Fun.Narrate"
	set name = "oSay"
	set desc = "Display a message to everyone who can hear the target"
	if(mob.control_object)
		if(!msg)
			return
		for (var/mob/V in hearers(mob.control_object))
			V.show_message(span_filter_say(span_bold("[mob.control_object.name]") + " says: \"[msg]\""), 2)
	feedback_add_details("admin_verb","OT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/kill_air() // -- TLE
	set category = "Debug.Dangerous"
	set name = "Kill Air"
	set desc = "Toggle Air Processing"
	SSair.can_fire = !SSair.can_fire
	to_chat(usr, span_filter_system(span_bold("[SSair.can_fire ? "En" : "Dis"]abled air processing.")))
	feedback_add_details("admin_verb","KA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] used 'kill air'.")
	message_admins(span_blue("[key_name_admin(usr)] used 'kill air'."), 1)

/client/proc/readmin_self()
	set name = "Re-Admin self"
	set category = "Admin.Misc"

	if(deadmin_holder)
		deadmin_holder.reassociate()
		log_admin("[src] re-admined themself.")
		message_admins("[src] re-admined themself.", 1)
		to_chat(src, span_filter_system(span_interface("You now have the keys to control the planet, or at least a small space station")))
		remove_verb(src, /client/proc/readmin_self)
		if(isobserver(mob))
			var/mob/observer/dead/our_mob = mob
			our_mob.visualnet?.addVisibility(our_mob, src)

/client/proc/deadmin_self()
	set name = "De-admin self"
	set category = "Admin.Misc"

	if(holder)
		if(tgui_alert(usr, "Confirm self-deadmin for the round? You can't re-admin yourself without someone promoting you.","Deadmin",list("Yes","No")) == "Yes")
			log_admin("[src] deadmined themself.")
			message_admins("[src] deadmined themself.", 1)
			deadmin()
			to_chat(src, span_filter_system(span_interface("You are now a normal player.")))
			add_verb(src, /client/proc/readmin_self)
			if(isobserver(mob))
				var/mob/observer/dead/our_mob = mob
				our_mob.visualnet?.removeVisibility(our_mob, src)
	feedback_add_details("admin_verb","DAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/toggle_log_hrefs()
	set name = "Toggle href logging"
	set category = "Server.Config"
	if(!holder)	return
	if(config)
		CONFIG_SET(flag/log_hrefs, !CONFIG_GET(flag/log_hrefs))
		message_admins(span_bold("[key_name_admin(usr)] [CONFIG_GET(flag/log_hrefs) ? "started" : "stopped"] logging hrefs"))

/client/proc/check_ai_laws()
	set name = "Check AI Laws"
	set category = "Admin.Silicon"
	if(holder)
		src.holder.output_ai_laws()

/client/proc/rename_silicon()
	set name = "Rename Silicon"
	set category = "Admin.Silicon"

	if(!check_rights(R_ADMIN|R_FUN|R_EVENT)) return

	var/mob/living/silicon/S = tgui_input_list(usr, "Select silicon.", "Rename Silicon.", silicon_mob_list)
	if(!S) return

	var/new_name = sanitizeSafe(tgui_input_text(src, "Enter new name. Leave blank or as is to cancel.", "[S.real_name] - Enter new silicon name", S.real_name))
	if(new_name && new_name != S.real_name)
		log_and_message_admins("has renamed the silicon '[S.real_name]' to '[new_name]'")
		S.SetName(new_name)
	feedback_add_details("admin_verb","RAI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/manage_silicon_laws()
	set name = "Manage Silicon Laws"
	set category = "Admin.Silicon"

	if(!check_rights(R_ADMIN|R_EVENT)) return

	var/mob/living/silicon/S = tgui_input_list(usr, "Select silicon.", "Manage Silicon Laws", silicon_mob_list)
	if(!S) return

	var/datum/tgui_module/law_manager/admin/L = new(S)
	L.tgui_interact(usr)
	log_and_message_admins("has opened [S]'s law manager.")
	feedback_add_details("admin_verb","MSL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/change_security_level()
	set name = "Set security level"
	set desc = "Sets the station security level"
	set category = "Admin.Events"

	if(!check_rights(R_ADMIN|R_EVENT))	return
	var/sec_level = tgui_input_list(usr, "It's currently code [get_security_level()].", "Select Security Level", (list("green","yellow","violet","orange","blue","red","delta")-get_security_level()))
	if(!sec_level)
		return
	if(tgui_alert(usr, "Switch from code [get_security_level()] to code [sec_level]?","Change security level?",list("Yes","No")) == "Yes")
		set_security_level(sec_level)
		log_admin("[key_name(usr)] changed the security level to code [sec_level].")

/client/proc/shuttle_panel()
	set name = "Shuttle Control Panel"
	set category = "Admin.Events"

	if(!check_rights(R_ADMIN | R_EVENT))
		return

	var/datum/tgui_module/admin_shuttle_controller/A = new(src)
	A.tgui_interact(usr)
	log_and_message_admins("has opened the shuttle panel.")
	feedback_add_details("admin_verb","SHCP")

//---- bs12 verbs ----

/client/proc/mod_panel()
	set name = "Moderator Panel"
	set category = "Admin.Moderation"
/*	if(holder)
		holder.mod_panel()*/
//	feedback_add_details("admin_verb","MP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/playernotes()
	set name = "Show Player Info"
	set category = "Admin.Moderation"
	if(holder)
		holder.PlayerNotes()
	return

/client/proc/free_slot()
	set name = "Free Job Slot"
	set category = "Admin.Game"
	if(holder)
		var/list/jobs = list()
		for (var/datum/job/J in job_master.occupations)
			if (J.current_positions >= J.total_positions && J.total_positions != -1)
				jobs += J.title
		if (!jobs.len)
			to_chat(usr, "There are no fully staffed jobs.")
			return
		var/job = tgui_input_list(usr, "Please select job slot to free", "Free job slot", jobs)
		if (job)
			job_master.FreeRole(job)
			message_admins("A job slot for [job] has been opened by [key_name_admin(usr)]")
			return

/client/proc/toggleghostwriters()
	set name = "Toggle ghost writers"
	set category = "Server.Game"
	if(!holder)	return
	if(config)
		CONFIG_SET(flag/cult_ghostwriter, !CONFIG_GET(flag/cult_ghostwriter))
		message_admins("Admin [key_name_admin(usr)] has [CONFIG_GET(flag/cult_ghostwriter) ? "en" : "dis"]abled ghost writers.", 1)

/client/proc/toggledrones()
	set name = "Toggle maintenance drones"
	set category = "Server.Game"
	if(!holder)	return
	if(config)
		CONFIG_SET(flag/allow_drone_spawn, !CONFIG_GET(flag/allow_drone_spawn))
		message_admins("Admin [key_name_admin(usr)] has [CONFIG_GET(flag/allow_drone_spawn) ? "en" : "dis"]abled maintenance drones.", 1)

/client/proc/man_up(mob/T as mob in mob_list)
	set category = "Fun.Do Not"
	set name = "Man Up"
	set desc = "Tells mob to man up and deal with it."
	set popup_menu = FALSE //VOREStation Edit - Declutter.

	if(tgui_alert(usr, "Are you sure you want to tell them to man up?","Confirmation",list("Deal with it","No")) != "Deal with it") return

	to_chat(T, span_filter_system(span_boldnotice(span_large("Man up and deal with it."))))
	to_chat(T, span_filter_system(span_notice("Move along.")))

	log_admin("[key_name(usr)] told [key_name(T)] to man up and deal with it.")
	message_admins(span_blue("[key_name_admin(usr)] told [key_name(T)] to man up and deal with it."), 1)

/client/proc/global_man_up()
	set category = "Fun.Do Not"
	set name = "Man Up Global"
	set desc = "Tells everyone to man up and deal with it."

	if(tgui_alert(usr, "Are you sure you want to tell the whole server up?","Confirmation",list("Deal with it","No")) != "Deal with it") return

	for (var/mob/T as mob in mob_list)
		to_chat(T, "<br><center>" + span_filter_system(span_notice(span_bold(span_huge("Man up.<br> Deal with it.")) + "<br>Move along.")) + "</center><br>")
		T << 'sound/voice/ManUp1.ogg'

	log_admin("[key_name(usr)] told everyone to man up and deal with it.")
	message_admins(span_blue("[key_name_admin(usr)] told everyone to man up and deal with it."), 1)

/client/proc/give_spell(mob/T as mob in mob_list) // -- Urist
	set category = "Fun.Event Kit"
	set name = "Give Spell"
	set desc = "Gives a spell to a mob."
	var/spell/S = tgui_input_list(usr, "Choose the spell to give to that guy", "ABRAKADABRA", spells)
	if(!S) return
	T.spell_list += new S
	feedback_add_details("admin_verb","GS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(T)] the spell [S].")
	message_admins(span_blue("[key_name_admin(usr)] gave [key_name(T)] the spell [S]."), 1)

/client/proc/debugstatpanel()
	set name = "Debug Stat Panel"
	set category = "Debug.Misc"

	src.stat_panel.send_message("create_debug")

/client/proc/spawn_reagent()
	set name = "Spawn Reagent"
	set category = "Debug.Game"

	if(!check_rights(R_ADMIN|R_EVENT))	return
	var/datum/reagent/R = tgui_input_list(usr, "Select a reagent to spawn", "Reagent Spawner", subtypesof(/datum/reagent))
	if(!R)
		return

	var/obj/item/reagent_containers/glass/bottle/B = new(usr.loc)

	B.icon_state = "bottle-1"
	B.reagents.add_reagent(R.id, 60)
	B.name = "[B.name] of [R.name]"

/client/proc/add_hidden_area()
	set name = "Add Ghostsight Block Area"
	set category = "Admin.Game"

	var/list/blocked_areas = list()
	for(var/area/A in world)
		if(!A.flag_check(AREA_BLOCK_GHOST_SIGHT))
			blocked_areas[A.name] = A
	blocked_areas = sortTim(blocked_areas, GLOBAL_PROC_REF(cmp_text_asc))
	var/selected_area = tgui_input_list(usr, "Pick an area to hide from ghost", "Select Area to hide", blocked_areas)
	var/area/A = blocked_areas[selected_area]
	if(!A)
		return
	A.flags |= AREA_BLOCK_GHOST_SIGHT
	ghostnet.addArea(A)

/client/proc/remove_hidden_area()
	set name = "Remove Ghostsight Block Area"
	set category = "Admin.Game"

	var/list/blocked_areas = list()
	for(var/area/A in world)
		if(A.flag_check(AREA_BLOCK_GHOST_SIGHT))
			blocked_areas[A.name] = A
	blocked_areas = sortTim(blocked_areas, GLOBAL_PROC_REF(cmp_text_asc))
	var/selected_area = tgui_input_list(usr, "Pick a from ghost hidden area to let them see it again", "Select Hidden Area", blocked_areas)
	var/area/A = blocked_areas[selected_area]
	if(!A)
		return
	A.flags &= ~(AREA_BLOCK_GHOST_SIGHT)
	ghostnet.removeArea(A)
