/mob/proc/on_mob_jump()
	return

/mob/observer/dead/on_mob_jump()
	following = null

ADMIN_VERB(Jump, R_ADMIN|R_MOD|R_DEBUG|R_EVENT, "Jump to Area", "Area to jump to.", ADMIN_CATEGORY_GAME, areaname as null|anything in return_sorted_areas())
	if(!CONFIG_GET(flag/allow_admin_jump))
		tgui_alert_async(user, "Admin jumping disabled")
		return

	var/area/target_area

	if(areaname)
		target_area = return_sorted_areas()[areaname]
	else
		target_area = return_sorted_areas()[tgui_input_list(user, "Pick an area:", "Jump to Area", return_sorted_areas())]

	if(!target_area)
		return

	user.mob.on_mob_jump()
	user.mob.reset_perspective(user.mob)
	var/turf/target = pick(get_area_turfs(target_area))
	if(!target)
		to_chat(user, span_warning("Selected area [target_area] has no turfs!"))
		return
	user.mob.forceMove(target)
	log_and_message_admins("jumped to [target_area]", user)
	feedback_add_details("admin_verb","JA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB_AND_CONTEXT_MENU(jumptoturf, R_ADMIN|R_MOD|R_DEBUG|R_EVENT, "Jump to Turf", "Jump to a specific turf in the game.", ADMIN_CATEGORY_GAME, turf/T in world)
	if(CONFIG_GET(flag/allow_admin_jump))
		log_and_message_admins("jumped to [T.x],[T.y],[T.z] in [T.loc]", user)
		user.mob.on_mob_jump()
		user.mob.reset_perspective(user)
		user.mob.forceMove(T)
		feedback_add_details("admin_verb","JT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		return
	tgui_alert_async(user, "Admin jumping disabled")

/// Verb wrapper around do_jumptomob()
ADMIN_VERB_AND_CONTEXT_MENU(jumptomob, R_ADMIN|R_MOD|R_DEBUG|R_EVENT, "Jump to Mob", "Jump to the selected mob.", ADMIN_CATEGORY_GAME, mob/M in GLOB.mob_list)
	user.do_jumptomob(M)

/// Performs the jumps, also called from admin Topic() for JMP links
/client/proc/do_jumptomob(var/mob/M)
	if(!CONFIG_GET(flag/allow_admin_jump))
		tgui_alert_async(usr, "Admin jumping disabled")
		return

	if(!M)
		M = tgui_input_list(usr, "Pick a mob:", "Jump to Mob", GLOB.mob_list)
	if(!M)
		return

	var/mob/A = src.mob // Impossible to be unset, enforced by byond
	var/turf/T = get_turf(M)
	if(isturf(T))
		A.on_mob_jump()
		A.reset_perspective(A)
		A.forceMove(T)
		log_admin("[key_name(usr)] jumped to [key_name(M)]")
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
		feedback_add_details("admin_verb","JM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		to_chat(A, span_filter_adminlog("This mob is not located in the game world."))

ADMIN_VERB(jumptocoord, R_ADMIN|R_MOD|R_DEBUG|R_EVENT,"Jump to Coordinate", "Jump to the target coordinates.", ADMIN_CATEGORY_GAME, tx, ty, tz)
	if(!CONFIG_GET(flag/allow_admin_jump))
		tgui_alert_async(user, "Admin jumping disabled")
		return
	if(!tx || !ty || !tz)
		tx = tgui_input_number(user, "Select the target x coordinate", "X Loc", 1, world.maxx, 1)
		ty = tgui_input_number(user, "Select the target y coordinate", "Y Loc", 1, world.maxy, 1)
		tz = tgui_input_number(user, "Select the target z coordinate", "Z Loc", 1, world.maxz, 1)

	var/mob/user_mob = user.mob
	user_mob.on_mob_jump()
	var/turf/target_turf = locate(tx, ty, tz)
	if(!target_turf)
		to_chat(user, span_warning("Those coordinates are outside the boundaries of the map."))
		return
	user_mob.reset_perspective(user_mob)
	user_mob.forceMove(target_turf)
	feedback_add_details("admin_verb","JC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	message_admins("[key_name_admin(user)] jumped to coordinates [tx], [ty], [tz]")

ADMIN_VERB(jumptokey, R_ADMIN|R_MOD|R_DEBUG|R_EVENT, "Jump to Key", "Jump to a player.", ADMIN_CATEGORY_GAME)
	if(!CONFIG_GET(flag/allow_admin_jump))
		tgui_alert_async(user, "Admin jumping disabled")
		return

	var/list/keys = list()
	for(var/mob/player_mob in GLOB.player_list)
		keys += player_mob.client
	var/client/selection = tgui_input_list(user, "Select a key:", "Jump to Key", sortKey(keys))
	if(!selection)
		return
	var/mob/selected_mob = selection.mob
	var/turf/target_turf = get_turf(selected_mob)
	if(!target_turf)
		return
	log_and_message_admins("jumped to [key_name(selected_mob)]", user)
	user.mob.on_mob_jump()
	user.mob.reset_perspective(user.mob)
	user.mob.forceMove(target_turf)
	feedback_add_details("admin_verb","JK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB_AND_CONTEXT_MENU(Getmob, R_ADMIN|R_MOD|R_DEBUG|R_EVENT, "Get Mob",  "Mob to teleport.", ADMIN_CATEGORY_GAME, mob/living/living_mob in GLOB.mob_list)
	if(!CONFIG_GET(flag/allow_admin_jump))
		tgui_alert_async(user, "Admin jumping disabled")
		return

	if(!living_mob)
		living_mob = tgui_input_list(user, "Pick a mob:", "Get Mob", GLOB.mob_list)
	if(!living_mob)
		return
	var/msg = "jumped [key_name(living_mob)] to them."
	log_and_message_admins(msg, user)
	admin_ticket_log(living_mob, "[key_name_admin(user)] " + msg)
	living_mob.on_mob_jump()
	living_mob.reset_perspective(living_mob)
	living_mob.forceMove(get_turf(user.mob))
	feedback_add_details("admin_verb","GM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(Getkey, R_ADMIN|R_MOD|R_DEBUG|R_EVENT, "Get Key",  "Key to teleport.", ADMIN_CATEGORY_GAME)
	if(!CONFIG_GET(flag/allow_admin_jump))
		tgui_alert_async(user, "Admin jumping disabled")
		return

	var/list/keys = list()
	for(var/mob/curernt_mob in GLOB.player_list)
		keys += curernt_mob.client
	var/client/selection = tgui_input_list(user, "Pick a key:", "Get Key", sortKey(keys))
	if(!selection)
		return

	var/mob/selected_mob = selection.mob
	if(!selected_mob)
		return

	log_admin("[key_name(user)] teleported [key_name(selected_mob)]")
	var/msg = "[key_name_admin(user)] teleported [ADMIN_LOOKUPFLW(selected_mob)]"
	message_admins(msg)
	admin_ticket_log(selected_mob, msg)
	selected_mob.on_mob_jump()
	selected_mob.reset_perspective(selected_mob) // Force reset to self before teleport
	selected_mob.forceMove(get_turf(user))
	feedback_add_details("admin_verb","GK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

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
