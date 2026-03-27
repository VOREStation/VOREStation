/client/proc/add_admin_verbs()
	// NEW ADMIN VERBS SYSTEM
	SSadmin_verbs.assosciate_admin(src)

/client/proc/remove_admin_verbs()
	// NEW ADMIN VERBS SYSTEM
	SSadmin_verbs.deassosciate_admin(src)

ADMIN_VERB(hide_verbs, R_HOLDER, "Adminverbs - Hide All", "Hide all admin verbs.", ADMIN_CATEGORY_MISC)
	SSadmin_verbs.deassosciate_admin(user)
	add_verb(user, /client/proc/show_verbs)

	to_chat(user, span_filter_system(span_interface("Almost all of your adminverbs have been hidden.")))
	feedback_add_details("admin_verb","TAVVH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/show_verbs()
	set name = "Adminverbs - Show"
	set category = "Admin.Misc"

	if(!check_rights_for(src, R_HOLDER))
		return

	remove_verb(src, /client/proc/show_verbs)
	add_admin_verbs()

	to_chat(src, span_filter_adminlog(span_interface("All of your adminverbs are now visible.")))
	feedback_add_details("admin_verb","TAVVS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


ADMIN_VERB(admin_ghost, R_HOLDER, "Aghost", "Ghost out of your body with the option to return at any time.", ADMIN_CATEGORY_GAME)
	var/build_mode
	if(user.buildmode)
		build_mode = tgui_alert(user, "You appear to be currently in buildmode. Do you want to re-enter buildmode after aghosting?", "Buildmode", list("Yes", "No"))
		if(build_mode != "Yes")
			to_chat(user, "Will not re-enter buildmode after switch.")

	var/mob/mob = user.mob
	if(isobserver(mob))
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

	else if(isnewplayer(mob))
		to_chat(user, span_filter_system(span_warning("Error: Aghost: Can't admin-ghost whilst in the lobby. Join or Observe first.")))
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
		user.init_verbs()
		if(body)
			body.teleop = ghost
			if(!body.key)
				body.key = "@[user.key]"	//Haaaaaaaack. But the people have spoken. If it breaks; blame adminbus
		feedback_add_details("admin_verb","O") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(invisimin, R_ADMIN|R_MOD|R_EVENT, "Invisimin", "Toggles ghost-like invisibility (Don't abuse this).", ADMIN_CATEGORY_GAME)
	var/mob/mob = user.mob
	if(mob.invisibility > INVISIBILITY_OBSERVER)
		to_chat(user, span_warning("You can't use this, your current invisibility level ([mob.invisibility]) is above the observer level ([INVISIBILITY_OBSERVER])."))
		return

	if(mob.invisibility == INVISIBILITY_OBSERVER)
		mob.invisibility = initial(mob.invisibility)
		to_chat(mob, span_filter_system(span_danger("Invisimin off. Invisibility reset.")))
		mob.alpha = max(mob.alpha + 100, 255)
		return

	mob.invisibility = INVISIBILITY_OBSERVER
	to_chat(mob, span_filter_system(span_boldnotice("Invisimin on. You are now as invisible as a ghost.")))
	mob.alpha = max(mob.alpha - 100, 0)

ADMIN_VERB(list_bombers, R_ADMIN, "List Bombers", "Look at all bombs and their likely culprit.", ADMIN_CATEGORY_GAME)
	user.holder.list_bombers()
	//BLACKBOX_LOG_ADMIN_VERB("List Bombers")

ADMIN_VERB(list_signalers, R_ADMIN, "List Signalers", "View all signalers.", ADMIN_CATEGORY_GAME)
	user.holder.list_signalers()
	//BLACKBOX_LOG_ADMIN_VERB("List Signalers")

ADMIN_VERB(list_law_changes, R_ADMIN, "List Law Changes", "View all AI law changes.", ADMIN_CATEGORY_DEBUG_INVESTIGATE)
	user.holder.list_law_changes()
	//BLACKBOX_LOG_ADMIN_VERB("List Law Changes")

ADMIN_VERB(show_manifest, R_ADMIN, "Show Manifest", "View the shift's Manifest.", ADMIN_CATEGORY_DEBUG_GAME)
	user.holder.show_manifest()
	//BLACKBOX_LOG_ADMIN_VERB("Show Manifest")

ADMIN_VERB(player_panel, R_HOLDER, "Player Panel", "Open the player panel.", ADMIN_CATEGORY_GAME)
	user.holder.player_panel_old(user)
	feedback_add_details("admin_verb","PP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(player_panel_new, R_HOLDER, "Player Panel New", "Open the player panel.", ADMIN_CATEGORY_GAME)
	user.holder.player_panel_new(user)
	feedback_add_details("admin_verb","PPN") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(check_antagonists, R_HOLDER, "Check Antagonists", "Open the antagonist panel.", ADMIN_CATEGORY_INVESTIGATE)
	user.holder.check_antagonists(user)
	log_admin("[key_name(user)] checked antagonists.")	//for tsar~
	feedback_add_details("admin_verb","CHA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(jobbans, R_BAN, "Display Job bans", "View job bans here.", ADMIN_CATEGORY_INVESTIGATE)
	if(CONFIG_GET(flag/ban_legacy_system))
		user.holder.Jobbans()
	else
		user.holder.DB_ban_panel(user)
	feedback_add_details("admin_verb","VJB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(unban_panel, R_BAN, "Unbanning Panel", "Unban players here.", ADMIN_CATEGORY_GAME)
	if(CONFIG_GET(flag/ban_legacy_system))
		user.holder.unbanpanel()
	else
		user.holder.DB_ban_panel(user)
	feedback_add_details("admin_verb","UBP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(game_panel, R_ADMIN|R_SERVER|R_FUN, "Game Panel", "Look at the state of the game.", ADMIN_CATEGORY_GAME)
	user.holder.Game()
	feedback_add_details("admin_verb","GP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/// Returns this client's stealthed ckey
/client/proc/getStealthKey()
	return GLOB.stealthminID[ckey]

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

ADMIN_VERB(stealth, R_STEALTH, "Stealth Mode", "Toggle stealth.", ADMIN_CATEGORY_GAME)
	if(user.holder.fakekey)
		user.holder.fakekey = null
		if(isnewplayer(user.mob))
			user.mob.name = capitalize(user.ckey)
	else
		var/new_key = ckeyEx(tgui_input_text(user, "Enter your desired display name.", "Fake Key", user.key))
		if(!new_key)
			return
		if(length(new_key) >= 26)
			new_key = copytext(new_key, 1, 26)
		user.holder.fakekey = new_key
		user.createStealthKey()
		if(isnewplayer(user.mob))
			user.mob.name = new_key
	log_and_message_admins("has turned stealth mode [user.holder.fakekey ? "ON" : "OFF"]", usr)
	feedback_add_details("admin_verb","SM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

#define MAX_WARNS 3
#define AUTOBANTIME 10

/client/proc/warn(warned_ckey)
	if(!check_rights(R_ADMIN))	return

	if(!warned_ckey || !istext(warned_ckey))	return
	if(warned_ckey in GLOB.admin_datums)
		to_chat(usr, span_warning("Error: warn(): You can't warn admins."))
		return

	var/datum/preferences/D
	var/client/C = GLOB.directory[warned_ckey]
	if(C)	D = C.prefs
	else	D = GLOB.preferences_datums[warned_ckey]

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

ADMIN_VERB(drop_bomb, R_FUN, "Drop Bomb", "Cause an explosion of varying strength at your location.", ADMIN_CATEGORY_FUN_DO_NOT) // Some admin dickery that can probably be done better -- TLE
	var/turf/epicenter = user.mob.loc
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Maxcap Bomb", "SM Blast", "Custom Bomb", "Cancel")
	var/choice = tgui_input_list(user, "What size explosion would you like to produce?", "Explosion Choice", choices)
	switch(choice)
		if(null)
			return FALSE
		if("Cancel")
			return FALSE
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)
		if("Maxcap Bomb") // Being able to test what players can legally make themselves sounds good, no?~
			explosion(epicenter, BOMBCAP_DVSTN_RADIUS, BOMBCAP_HEAVY_RADIUS, BOMBCAP_LIGHT_RADIUS, BOMBCAP_FLASH_RADIUS)
		if("SM Blast")
			explosion(epicenter, 8, 16, 24, 32)
		if("Custom Bomb")
			var/devastation_range = tgui_input_number(user, "Devastation range (in tiles):")
			var/heavy_impact_range = tgui_input_number(user, "Heavy impact range (in tiles):")
			var/light_impact_range = tgui_input_number(user, "Light impact range (in tiles):")
			var/flash_range = tgui_input_number(user, "Flash range (in tiles):")
			explosion(epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range)
	message_admins(span_blue("[user.ckey] creating an admin explosion at [epicenter.loc]."))
	feedback_add_details("admin_verb","DB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(admin_give_modifier, R_EVENT, "Give Modifier", "Makes a mob weaker or stronger by adding a specific modifier to them.", ADMIN_CATEGORY_DEBUG_GAME, mob/living/living_target)
	if(!living_target)
		to_chat(user, span_warning("Looks like you didn't select a mob."))
		return

	var/list/possible_modifiers = subtypesof(/datum/modifier)

	var/new_modifier_type = tgui_input_list(user, "What modifier should we add to [living_target]?", "Modifier Type", possible_modifiers)
	if(!new_modifier_type)
		return
	var/duration = tgui_input_number(user, "How long should the new modifier last, in seconds.  To make it last forever, write '0'.", "Modifier Duration")
	if(duration == 0)
		duration = null
	else
		duration = duration SECONDS

	living_target.add_modifier(new_modifier_type, duration)
	log_and_message_admins("has given [key_name(living_target)] the modifer [new_modifier_type], with a duration of [duration ? "[duration / 600] minutes" : "forever"].", user)

ADMIN_VERB_AND_CONTEXT_MENU(make_sound, R_FUN, "Make Sound", "Display a message to everyone who can hear the target.", ADMIN_CATEGORY_FUN_SOUNDS, obj/target_object in world)
	if(!target_object)
		return

	var/message = tgui_input_text(user, "What do you want the message to be?", "Make Sound", "", MAX_MESSAGE_LEN)
	if(!message)
		return
	target_object.audible_message(message)
	log_admin("[key_name(user)] made [target_object] at [target_object.x], [target_object.y], [target_object.z]. make a sound")
	message_admins(span_blue("[key_name_admin(user)] made [target_object] at [target_object.x], [target_object.y], [target_object.z]. make a sound."))
	feedback_add_details("admin_verb","MS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB_AND_CONTEXT_MENU(togglebuildmodeself, R_BUILDMODE, "Toggle Build Mode Self", "Toggles buildmode on oneself.", ADMIN_CATEGORY_DEBUG_EVENTS)
	togglebuildmode(user.mob)
	feedback_add_details("admin_verb","TBMS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(object_talk, R_FUN, "oSay", "Display a message to everyone who can hear the target.", ADMIN_CATEGORY_FUN_NARRATE, msg as text)
	var/mob/user_mob = user.mob
	if(!user_mob.control_object)
		return

	if(!msg)
		return
	for(var/mob/V in hearers(user_mob.control_object))
		V.show_message(span_filter_say(span_bold("[user_mob.control_object.name]") + " says: \"[msg]\""), 2)
	feedback_add_details("admin_verb","OT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(kill_air, R_SERVER, "Kill Air", "Toggle Air Processing.", ADMIN_CATEGORY_DEBUG_DANGEROUS)
	SSair.can_fire = !SSair.can_fire
	to_chat(user, span_filter_system(span_bold("[SSair.can_fire ? "En" : "Dis"]abled air processing.")))
	feedback_add_details("admin_verb","KA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_and_message_admins("used 'kill air'.", user)

ADMIN_VERB(deadmin, R_NONE, "DeAdmin", "Shed your admin powers.", ADMIN_CATEGORY_MISC)
	user.holder.deactivate()
	to_chat(user, span_interface("You are now a normal player."))
	log_admin("[key_name(user)] deadminned themselves.")
	message_admins("[key_name_admin(user)] deadminned themselves.")
	//BLACKBOX_LOG_ADMIN_VERB("Deadmin")
	feedback_add_details("admin_verb","DAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	if(isobserver(user.mob))
		var/mob/observer/dead/our_mob = user.mob
		our_mob.visualnet?.removeVisibility(our_mob, user)

ADMIN_VERB(toggle_log_hrefs, R_SERVER, "Toggle href logging", "Allows to toggle the logging of used hrefs.", ADMIN_CATEGORY_SERVER_CONFIG)
	if(!config)
		return
	CONFIG_SET(flag/log_hrefs, !CONFIG_GET(flag/log_hrefs))
	message_admins(span_bold("[key_name_admin(user)] [CONFIG_GET(flag/log_hrefs) ? "started" : "stopped"] logging hrefs"))

ADMIN_VERB(check_ai_laws, R_ADMIN|R_FUN|R_EVENT, "Check AI Laws", "Display the current AI laws.", ADMIN_CATEGORY_SILICON)
	user.holder.output_ai_laws()

ADMIN_VERB(rename_silicon, R_ADMIN|R_FUN|R_EVENT, "Rename Silicon", "Rename a silicon mob.", ADMIN_CATEGORY_SILICON)
	var/mob/living/silicon/silicon_target = tgui_input_list(user, "Select silicon.", "Rename Silicon.", GLOB.silicon_mob_list)
	if(!silicon_target)
		return

	var/new_name = sanitizeSafe(tgui_input_text(user, "Enter new name. Leave blank or as is to cancel.", "[silicon_target.real_name] - Enter new silicon name", silicon_target.real_name, encode = FALSE))
	if(new_name && new_name != silicon_target.real_name)
		log_and_message_admins("has renamed the silicon '[silicon_target.real_name]' to '[new_name]'")
		silicon_target.SetName(new_name)
	feedback_add_details("admin_verb","RAI") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(manage_silicon_laws, R_ADMIN|R_EVENT, "Manage Silicon Laws", "Allows to modify silicon laws.", ADMIN_CATEGORY_SILICON)
	var/mob/living/silicon/selected_silicon = tgui_input_list(user, "Select silicon.", "Manage Silicon Laws", GLOB.silicon_mob_list)
	if(!selected_silicon)
		return

	var/datum/tgui_module/law_manager/admin/law_interface = new(selected_silicon)
	law_interface.tgui_interact(user.mob)
	log_and_message_admins("has opened [selected_silicon]'s law manager.")
	feedback_add_details("admin_verb","MSL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(change_security_level, R_ADMIN|R_EVENT, "Set security level", "Sets the station security level.", ADMIN_CATEGORY_EVENTS)
	var/sec_level = tgui_input_list(user, "It's currently code [get_security_level()].", "Select Security Level", (list("green","yellow","violet","orange","blue","red","delta")-get_security_level()))
	if(!sec_level)
		return
	if(tgui_alert(user, "Switch from code [get_security_level()] to code [sec_level]?","Change security level?",list("Yes","No")) == "Yes")
		set_security_level(sec_level)
		log_admin("[key_name(user)] changed the security level to code [sec_level].")

ADMIN_VERB(shuttle_panel, R_ADMIN|R_EVENT, "Shuttle Control Panel", "Access the shuttle control panel.", ADMIN_CATEGORY_EVENTS)
	var/datum/tgui_module/admin_shuttle_controller/A = new(src)
	A.tgui_interact(user.mob)
	log_and_message_admins("has opened the shuttle panel.", user)
	feedback_add_details("admin_verb","SHCP")

ADMIN_VERB(free_slot, R_ADMIN|R_FUN|R_EVENT, "Free Job Slot", "Frees another job slot.", ADMIN_CATEGORY_EVENTS)
	var/list/jobs = list()
	for (var/datum/job/current_job in GLOB.job_master.occupations)
		if (current_job.current_positions >= current_job.total_positions && current_job.total_positions != -1)
			jobs += current_job.title
	if (!length(jobs))
		to_chat(user, "There are no fully staffed jobs.")
		return
	var/job = tgui_input_list(user, "Please select job slot to free", "Free job slot", jobs)
	if (!job)
		return
	GLOB.job_master.FreeRole(job)
	message_admins("A job slot for [job] has been opened by [key_name_admin(user)]")

ADMIN_VERB(toggleghostwriters, R_ADMIN|R_FUN|R_EVENT, "Toggle ghost writers", "Toggles ghost writing.", ADMIN_CATEGORY_SERVER_GAME)
	if(!config)
		return
	CONFIG_SET(flag/cult_ghostwriter, !CONFIG_GET(flag/cult_ghostwriter))
	message_admins("Admin [key_name_admin(user)] has [CONFIG_GET(flag/cult_ghostwriter) ? "en" : "dis"]abled ghost writers.")

ADMIN_VERB(toggledrones, R_ADMIN|R_FUN|R_EVENT, "Toggle maintenance drones", "Toggles maintenance drone.", ADMIN_CATEGORY_SERVER_GAME)
	if(!config)
		return
	CONFIG_SET(flag/allow_drone_spawn, !CONFIG_GET(flag/allow_drone_spawn))
	message_admins("Admin [key_name_admin(user)] has [CONFIG_GET(flag/allow_drone_spawn) ? "en" : "dis"]abled maintenance drones.")

ADMIN_VERB(man_up, R_ADMIN|R_FUN, "Man Up", "Tells mob to man up and deal with it.", ADMIN_CATEGORY_FUN_DO_NOT)
	var/mob/living/living_target = tgui_input_list(user, "Who to tell to man up and deal with it.", "Man up", GLOB.mob_list)
	if(!living_target)
		return

	if(tgui_alert(user, "Are you sure you want to tell them to man up?", "Confirmation", list("Deal with it","No")) != "Deal with it")
		return

	to_chat(living_target, span_filter_system(span_boldnotice(span_large("Man up and deal with it."))))
	to_chat(living_target, span_filter_system(span_notice("Move along.")))

	log_admin("[key_name(user)] told [key_name(living_target)] to man up and deal with it.")
	message_admins(span_blue("[key_name_admin(user)] told [key_name(living_target)] to man up and deal with it."), 1)

ADMIN_VERB(global_man_up, R_ADMIN|R_FUN, "Man Up Global", "Tells everyone to man up and deal with it.", ADMIN_CATEGORY_FUN_DO_NOT)
	if(tgui_alert(user, "Are you sure you want to tell the whole server up?","Confirmation",list("Deal with it","No")) != "Deal with it")
		return

	for (var/mob/target_mob in GLOB.mob_list)
		to_chat(target_mob, "<br><center>" + span_filter_system(span_notice(span_bold(span_huge("Man up.<br> Deal with it.")) + "<br>Move along.")) + "</center><br>")
		DIRECT_OUTPUT(target_mob, 'sound/voice/manup1.ogg')

	log_and_message_admins("told everyone to man up and deal with it.", user)

ADMIN_VERB(give_spell, R_FUN, "Give Spell", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/spell_recipient)
	var/datum/spell/S = tgui_input_list(user, "Choose the spell to give to that guy", "ABRAKADABRA", typesof(/datum/spell))
	if(!S)
		return
	spell_recipient.spell_list += new S
	feedback_add_details("admin_verb","GS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_admin("[key_name(usr)] gave [key_name(spell_recipient)] the spell [S].")
	message_admins(span_blue("[key_name_admin(usr)] gave [key_name(spell_recipient)] the spell [S]."), 1)

ADMIN_VERB(remove_spell, R_FUN, "Remove Spell", ADMIN_VERB_NO_DESCRIPTION, ADMIN_CATEGORY_HIDDEN, mob/removal_target)
	var/list/target_spell_list = list()
	for(var/datum/spell/spell in removal_target.spell_list)
		target_spell_list[spell.name] = spell

	if(!length(target_spell_list))
		return

	var/chosen_spell = tgui_input_list(user, "Choose the spell to remove from [removal_target]", "ABRAKADABRA", sortList(target_spell_list))
	if(isnull(chosen_spell))
		return
	var/datum/spell/to_remove = target_spell_list[chosen_spell]
	if(!istype(to_remove))
		return

	qdel(to_remove)
	log_admin("[key_name(user)] removed the spell [chosen_spell] from [key_name(removal_target)].")
	message_admins("[key_name_admin(user)] removed the spell [chosen_spell] from [key_name_admin(removal_target)].")
	feedback_add_details("admin_verb","RS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	//BLACKBOX_LOG_ADMIN_VERB("Remove Spell")

ADMIN_VERB(debug_statpanel, R_DEBUG, "Debug Stat Panel", "Toggles local debug of the stat panel.", ADMIN_CATEGORY_DEBUG_MISC)
	user.stat_panel.send_message("create_debug")

ADMIN_VERB(spawn_reagent, R_DEBUG|R_EVENT, "Spawn Reagent", "Spawn any reagent.", ADMIN_CATEGORY_DEBUG_GAME)
	var/datum/reagent/new_reagent = tgui_input_list(user, "Select a reagent to spawn", "Reagent Spawner", subtypesof(/datum/reagent))
	if(!new_reagent)
		return

	var/mob/user_mob = user.mob
	var/obj/item/reagent_containers/glass/bottle/new_bottle = new(user_mob.loc)

	new_bottle.icon_state = "bottle-1"
	new_bottle.reagents.add_reagent(new_reagent.id, 60)
	new_bottle.name = "[new_bottle.name] of [new_reagent.name]"

ADMIN_VERB(add_hidden_area, R_ADMIN|R_FUN, "Add Ghostsight Block Area", "Blocks ghost sight in the taget area.", ADMIN_CATEGORY_GAME)
	var/list/blocked_areas = list()
	for(var/type, value in GLOB.areas_by_type)
		var/area/current_area = value
		if(!current_area.flag_check(AREA_BLOCK_GHOST_SIGHT))
			blocked_areas[current_area.name] = current_area
	blocked_areas = sortTim(blocked_areas, GLOBAL_PROC_REF(cmp_text_asc))
	var/selected_area = tgui_input_list(user, "Pick an area to hide from ghost", "Select Area to hide", blocked_areas)
	var/area/target_area = blocked_areas[selected_area]
	if(!target_area)
		return
	target_area.flags |= AREA_BLOCK_GHOST_SIGHT
	GLOB.ghostnet.addArea(target_area)

ADMIN_VERB(remove_hidden_area, R_ADMIN|R_FUN, "Remove Ghostsight Block Area", "Unblocks ghost sight in the taget area.", ADMIN_CATEGORY_GAME)
	var/list/blocked_areas = list()
	for(var/type, value in GLOB.areas_by_type)
		var/area/current_area = value
		if(current_area.flag_check(AREA_BLOCK_GHOST_SIGHT))
			blocked_areas[current_area.name] = current_area
	blocked_areas = sortTim(blocked_areas, GLOBAL_PROC_REF(cmp_text_asc))
	var/selected_area = tgui_input_list(user, "Pick a from ghost hidden area to let them see it again", "Select Hidden Area", blocked_areas)
	var/area/target_area = blocked_areas[selected_area]
	if(!target_area)
		return
	target_area.flags &= ~(AREA_BLOCK_GHOST_SIGHT)
	GLOB.ghostnet.removeArea(target_area)

ADMIN_VERB(hide_motion_tracker_feedback, R_ADMIN|R_EVENT, "Toggle Motion Echos", "Hides or reveals motion tracker echos globally.", ADMIN_CATEGORY_EVENTS)
	SSmotiontracker.hide_all = !SSmotiontracker.hide_all
	log_admin("[key_name(user)] changed the motion echo visibility to [SSmotiontracker.hide_all ? "hidden" : "visible"].")

ADMIN_VERB(adminorbit, R_FUN, "Orbit Things", "Makes something orbit around something else.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/center
	var/atom/movable/orbiter
	var/input

	var/datum/marked_datum = user.holder.marked_datum
	if(marked_datum)
		input = tgui_alert(user, "You have \n[marked_datum] marked, should this be the center of the orbit, or the orbiter?", "Orbit", list("Center", "Orbiter", "Neither"))
		switch(input)
			if("Center")
				center = marked_datum
			if("Orbiter")
				orbiter = marked_datum
	var/list/possible_things = list()
	for(var/T as mob in view(user.view))	//Let's do mobs before objects
		if(ismob(T))
			possible_things |= T
	for(var/T as obj in view(user.view))
		if(isobj(T))
			possible_things |= T
	if(!center)
		center = tgui_input_list(user, "What should act as the center of the orbit?", "Center", possible_things)
		possible_things -= center
	if(!orbiter)
		orbiter = tgui_input_list(user, "What should act as the orbiter of the orbit?", "Orbiter", possible_things)
	if(!center || !orbiter)
		to_chat(user, span_warning("A center of orbit and an orbiter must be configured. You can also do this by marking a target."))
		return
	if(center == orbiter)
		to_chat(user, span_warning("The center of the orbit cannot also be the orbiter."))
		return
	if(isturf(orbiter))
		to_chat(user, span_warning("The orbiter cannot be a turf. It can only be used as a center."))
		return
	var/distance = tgui_input_number(user, "How large will their orbit radius be? (In pixels. 32 is 'near around a character)", "Orbit Radius", 32)
	var/speed = tgui_input_number(user, "How fast will they orbit (negative numbers spin clockwise)", "Orbit Speed", 20)
	var/segments = tgui_input_number(user, "How many segments will they have in their orbit? (3 is a triangle, 36 is a circle, etc)", "Orbit Segments", 36)
	var/clock = FALSE
	if(!distance)
		distance = 32
	if(!speed)
		speed = 20
	else if (speed < 0)
		clock = TRUE
		speed *= -1
	if(!segments)
		segments = 36
	if(tgui_alert(user, "\The [orbiter] will orbit around [center]. Is this okay?", "Confirm Orbit", list("Yes", "No")) == "Yes")
		orbiter.orbit(center, distance, clock, speed, segments)

ADMIN_VERB(removetickets, R_ADMIN, "Security Tickets", "Allows one to remove tickets from the global list.", ADMIN_CATEGORY_INVESTIGATE)
	if(GLOB.security_printer_tickets.len >= 1)
		var/input = tgui_input_list(user, "Which message?", "Security Tickets", GLOB.security_printer_tickets)
		if(!input)
			return
		if(tgui_alert(user, "Do you want to remove the following message from the global list? \"[input]\"", "Remove Ticket", list("Yes", "No")) == "Yes")
			GLOB.security_printer_tickets -= input
			log_and_message_admins("removed a security ticket from the global list: \"[input]\"", user)

	else
		tgui_alert_async(user, "The ticket list is empty.","Empty")

ADMIN_VERB(delbook, R_ADMIN, "Delete Book", "Permamently deletes a book from the database.", ADMIN_CATEGORY_GAME)
	var/obj/machinery/librarycomp/our_comp
	for(var/obj/machinery/librarycomp/l in world)
		our_comp = l
		break

	if(!our_comp)
		to_chat(user, span_warning("Unable to locate a library computer to use for book deleting."))
		return

	var/dat = "<HEAD><TITLE>Book Inventory Management</TITLE></HEAD><BODY>\n"
	dat += "<h3>ADMINISTRATIVE MANAGEMENT</h3>"

	if(!SSdbcore.IsConnected())
		dat += span_red(span_bold("ERROR") + ": Unable to contact External Archive. Please contact your system administrator for assistance.")
	else
		dat += {"<A href='byond://?our_comp=\ref[our_comp];[HrefToken()];orderbyid=1'>(Order book by SS<sup>13</sup>BN)</A><BR><BR>
		<table>
		<tr><td><A href='byond://?our_comp=\ref[our_comp];[HrefToken()];sort=author>AUTHOR</A></td><td><A href='byond://?our_comp=\ref[our_comp];[HrefToken()];sort=title>TITLE</A></td><td><A href='byond://?our_comp=\ref[our_comp];[HrefToken()];sort=category>CATEGORY</A></td><td></td></tr>"}
		var/datum/db_query/query = SSdbcore.NewQuery("SELECT id, author, title, category FROM library ORDER BY [our_comp.sortby]")
		query.Execute()

		while(query.NextRow())
			var/id = query.item[1]
			var/author = query.item[2]
			var/title = query.item[3]
			var/category = query.item[4]
			dat += "<tr><td>[author]</td><td>[title]</td><td>[category]</td><td>"
			dat += "<A href='byond://?our_comp=\ref[our_comp];[HrefToken()];delid=[id]'>\[Del\]</A>"
			dat += "</td></tr>"
		dat += "</table>"

		qdel(query)

	var/datum/browser/popup = new(user, "library", "Delete Book")
	popup.set_content(dat)
	popup.open()

ADMIN_VERB(toggle_spawning_with_recolour, R_ADMIN|R_EVENT|R_FUN, "Toggle Simple/Robot recolour verb", "Makes it so new robots/simple_mobs spawn with a verb to recolour themselves for this round. You must set them separately.", ADMIN_CATEGORY_SERVER_GAME)
	var/which = tgui_alert(user, "Which do you want to toggle?", "Choose Recolour Toggle", list("Robot", "Simple Mob"))
	switch(which)
		if("Robot")
			CONFIG_SET(flag/allow_robot_recolor, !CONFIG_GET(flag/allow_robot_recolor))
			to_chat(user, "You have [CONFIG_GET(flag/allow_robot_recolor) ? "enabled" : "disabled"] newly spawned cyborgs to spawn with the recolour verb")
		if("Simple Mob")
			CONFIG_SET(flag/allow_simple_mob_recolor, !CONFIG_GET(flag/allow_simple_mob_recolor))
			to_chat(user, "You have [CONFIG_GET(flag/allow_simple_mob_recolor) ? "enabled" : "disabled"] newly spawned simple mobs to spawn with the recolour verb")

ADMIN_VERB(modify_shift_end, (R_ADMIN|R_EVENT|R_SERVER), "Modify Shift End", "Modifies the hard shift end time.", ADMIN_CATEGORY_SERVER_GAME)
	SStransfer.modify_hard_end(user)
