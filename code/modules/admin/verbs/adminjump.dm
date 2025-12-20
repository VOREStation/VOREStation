/mob/proc/on_mob_jump()
	return

/mob/observer/dead/on_mob_jump()
	following = null

ADMIN_VERB(jump_to_area, (R_ADMIN|R_MOD|R_DEBUG|R_EVENT), "Jump To Area", "Jumps to the specified area.", ADMIN_CATEGORY_GAME, area/target in return_sorted_areas())
	var/turf/drop_location
	top_level:
		for(var/list/zlevel_turfs as anything in target.get_zlevel_turf_lists())
			for(var/turf/area_turf as anything in zlevel_turfs)
				if(area_turf.density)
					continue
				drop_location = area_turf
				break top_level

	if(isnull(drop_location))
		to_chat(user, span_warning("No valid drop location found in the area!"))
		return

	user.mob.abstract_move(drop_location)
	log_admin("[key_name(user)] jumped to [AREACOORD(drop_location)]")
	message_admins("[key_name_admin(user)] jumped to [AREACOORD(drop_location)]")
	//BLACKBOX_LOG_ADMIN_VERB("Jump To Area")
	feedback_add_details("admin_verb","JA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB_AND_CONTEXT_MENU(jump_to_turf, (R_ADMIN|R_MOD|R_DEBUG|R_EVENT), "Jump To Turf", "Jump to any turf in the game. This will lag your client.", ADMIN_CATEGORY_GAME, turf/locale in world)
	log_admin("[key_name(user)] jumped to [AREACOORD(locale)]")
	message_admins("[key_name_admin(user)] jumped to [AREACOORD(locale)]")
	user.mob.abstract_move(locale)
	//BLACKBOX_LOG_ADMIN_VERB("Jump To Turf")
	feedback_add_details("admin_verb","JT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB_AND_CONTEXT_MENU(jump_to_mob, (R_ADMIN|R_MOD|R_DEBUG|R_EVENT), "Jump To Mob", "Jump to any mob in the game.", ADMIN_CATEGORY_GAME, mob/target in world)
	user.mob.abstract_move(target.loc)
	log_admin("[key_name(user)] jumped to [key_name(target)]")
	message_admins("[key_name_admin(user)] jumped to [ADMIN_LOOKUPFLW(target)] at [AREACOORD(target)]")
	//BLACKBOX_LOG_ADMIN_VERB("Jump To Mob")
	feedback_add_details("admin_verb","JM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(jump_to_coord, (R_ADMIN|R_MOD|R_DEBUG|R_EVENT), "Jump To Coordinate", "Jump to a specific coordinate in the game world.", ADMIN_CATEGORY_GAME, cx as num, cy as num, cz as num)
	var/turf/where_we_droppin = locate(cx, cy, cz)
	if(isnull(where_we_droppin))
		to_chat(user, span_warning("Invalid coordinates."))
		return

	user.mob.abstract_move(where_we_droppin)
	message_admins("[key_name_admin(user)] jumped to coordinates [cx], [cy], [cz]")
	//BLACKBOX_LOG_ADMIN_VERB("Jump To Coordiate")
	feedback_add_details("admin_verb","JC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(jump_to_key, (R_ADMIN|R_MOD|R_DEBUG|R_EVENT), "Jump To Key", "Jump to a specific player.", ADMIN_CATEGORY_GAME)
	if(!isobserver(user.mob))
		SSadmin_verbs.dynamic_invoke_verb(user, /datum/admin_verb/admin_ghost)

	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys += M.client
	var/client/selection = input(user, "Please, select a player!", "Admin Jumping") as null|anything in sortKey(keys)
	if(!selection)
		to_chat(user, "No keys found.", confidential = TRUE)
		return
	var/mob/M = selection.mob
	log_admin("[key_name(user)] jumped to [key_name(M)]")
	message_admins("[key_name_admin(user)] jumped to [ADMIN_LOOKUPFLW(M)]")
	user.mob.abstract_move(M.loc)
	//BLACKBOX_LOG_ADMIN_VERB("Jump To Key")
	feedback_add_details("admin_verb","JK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB_AND_CONTEXT_MENU(get_mob, (R_ADMIN|R_MOD|R_DEBUG|R_EVENT), "Get Mob", "Teleport a mob to your location.", ADMIN_CATEGORY_GAME, mob/target in world)
	var/atom/loc = get_turf(user.mob)
	target.admin_teleport(loc)
	//BLACKBOX_LOG_ADMIN_VERB("Get Mob")
	feedback_add_details("admin_verb","GM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/// Proc to hook user-enacted teleporting behavior and keep logging of the event.
/atom/movable/proc/admin_teleport(atom/new_location)
	if(isnull(new_location))
		log_admin("[key_name(usr)] teleported [key_name(src)] to nullspace")
		moveToNullspace()
	else
		var/turf/location = get_turf(new_location)
		log_admin("[key_name(usr)] teleported [key_name(src)] to [AREACOORD(location)]")
		forceMove(new_location)

/mob/admin_teleport(atom/new_location)
	var/turf/location = get_turf(new_location)
	var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(src)] to [isnull(new_location) ? "nullspace" : ADMIN_VERBOSEJMP(location)]"
	message_admins(msg)
	admin_ticket_log(src, msg)
	return ..()

/client/proc/Getkey()
	set category = "Admin.Game"
	set name = "Get Key"
	set desc = "Key to teleport"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_EVENT))
		return

	if(CONFIG_GET(flag/allow_admin_jump))
		var/list/keys = list()
		for(var/mob/M in GLOB.player_list)
			keys += M.client
		var/selection = tgui_input_list(usr, "Pick a key:", "Get Key", sortKey(keys))
		if(!selection)
			return
		var/mob/M = selection:mob

		if(!M)
			return
		log_admin("[key_name(usr)] teleported [key_name(M)]")
		var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(M)]"
		message_admins(msg)
		admin_ticket_log(M, msg)
		if(M)
			M.on_mob_jump()
			M.reset_perspective(M) // Force reset to self before teleport
			M.forceMove(get_turf(usr))
			feedback_add_details("admin_verb","GK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		tgui_alert_async(usr, "Admin jumping disabled")

/client/proc/sendmob()
	set category = "Admin.Game"
	set name = "Send Mob"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_EVENT))
		return

	if(CONFIG_GET(flag/allow_admin_jump))
		var/area/A = tgui_input_list(usr, "Pick an area:", "Send Mob", return_sorted_areas())
		if(!A)
			return
		var/mob/M = tgui_input_list(usr, "Pick a mob:", "Send Mob", GLOB.mob_list)
		if(!M)
			return
		M.on_mob_jump()
		M.reset_perspective(M) // Force reset to self before teleport
		M.forceMove(pick(get_area_turfs(A)))
		feedback_add_details("admin_verb","SMOB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		log_admin("[key_name(usr)] teleported [key_name(M)]")
		var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(M)]"
		message_admins(msg)
		admin_ticket_log(M, msg)
	else
		tgui_alert_async(usr, "Admin jumping disabled")

/client/proc/cmd_admin_move_atom(var/atom/movable/AM, tx as num, ty as num, tz as num)
	set category = "Admin.Game"
	set name = "Move Atom to Coordinate"

	if(!check_rights(R_ADMIN|R_DEBUG|R_EVENT))
		return

	if(CONFIG_GET(flag/allow_admin_jump))
		if(isnull(tx))
			tx = tgui_input_number(usr, "Select X coordinate", "Move Atom", null, null)
			if(!tx) return
		if(isnull(ty))
			ty = tgui_input_number(usr, "Select Y coordinate", "Move Atom", null, null)
			if(!ty) return
		if(isnull(tz))
			tz = tgui_input_number(usr, "Select Z coordinate", "Move Atom", null, null)
			if(!tz) return
		var/turf/T = locate(tx, ty, tz)
		if(!T)
			to_chat(usr, span_warning("Those coordinates are outside the boundaries of the map."))
			return
		if(ismob(AM))
			var/mob/M = AM
			M.on_mob_jump()
			M.reset_perspective(M) // Force reset to self before teleport
		AM.forceMove(T)
		feedback_add_details("admin_verb", "MA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		message_admins("[key_name_admin(usr)] jumped [AM] to coordinates [tx], [ty], [tz]")
	else
		tgui_alert_async(usr, "Admin jumping disabled")
