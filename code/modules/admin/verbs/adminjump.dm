/mob/proc/on_mob_jump()
	return

/mob/observer/dead/on_mob_jump()
	following = null

/client/proc/Jump(areaname as null|anything in return_sorted_areas())
	set name = "Jump to Area"
	set desc = "Area to jump to"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_EVENT))
		return

	if(!CONFIG_GET(flag/allow_admin_jump))
		tgui_alert_async(usr, "Admin jumping disabled")
		return

	var/area/A

	if(areaname)
		A = return_sorted_areas()[areaname]
	else
		A = tgui_input_list(usr, "Pick an area:", "Jump to Area", return_sorted_areas())

	if(!A)
		return

	usr.on_mob_jump()
	usr.forceMove(pick(get_area_turfs(A)))
	log_admin("[key_name(usr)] jumped to [A]")
	message_admins("[key_name_admin(usr)] jumped to [A]", 1)
	feedback_add_details("admin_verb","JA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/jumptoturf(var/turf/T in world)
	set name = "Jump to Turf"
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_EVENT))
		return
	if(CONFIG_GET(flag/allow_admin_jump))
		log_admin("[key_name(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]")
		message_admins("[key_name_admin(usr)] jumped to [T.x],[T.y],[T.z] in [T.loc]", 1)
		usr.on_mob_jump()
		usr.forceMove(T)
		feedback_add_details("admin_verb","JT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		tgui_alert_async(usr, "Admin jumping disabled")
	return

/// Verb wrapper around do_jumptomob()
/client/proc/jumptomob(mob as null|anything in mob_list)
	set category = "Admin"
	set name = "Jump to Mob"
	set popup_menu = FALSE //VOREStation Edit - Declutter.

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_EVENT))
		return

	do_jumptomob(mob)

/// Performs the jumps, also called from admin Topic() for JMP links
/client/proc/do_jumptomob(var/mob/M)
	if(!CONFIG_GET(flag/allow_admin_jump))
		tgui_alert_async(usr, "Admin jumping disabled")
		return

	if(!M)
		M = tgui_input_list(usr, "Pick a mob:", "Jump to Mob", mob_list)
	if(!M)
		return

	var/mob/A = src.mob // Impossible to be unset, enforced by byond
	var/turf/T = get_turf(M)
	if(isturf(T))
		A.on_mob_jump()
		A.forceMove(T)
		log_admin("[key_name(usr)] jumped to [key_name(M)]")
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
		feedback_add_details("admin_verb","JM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		to_chat(A, span_filter_adminlog("This mob is not located in the game world."))

/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = "Admin"
	set name = "Jump to Coordinate"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_EVENT))
		return

	if (CONFIG_GET(flag/allow_admin_jump))
		if(src.mob)
			var/mob/A = src.mob
			A.on_mob_jump()
			var/turf/T = locate(tx, ty, tz)
			if(!T)
				to_chat(usr, span_warning("Those coordinates are outside the boundaries of the map."))
				return
			A.forceMove(T)
			feedback_add_details("admin_verb","JC") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		message_admins("[key_name_admin(usr)] jumped to coordinates [tx], [ty], [tz]")

	else
		tgui_alert_async(usr, "Admin jumping disabled")

/client/proc/jumptokey()
	set category = "Admin"
	set name = "Jump to Key"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_EVENT))
		return

	if(CONFIG_GET(flag/allow_admin_jump))
		var/list/keys = list()
		for(var/mob/M in player_list)
			keys += M.client
		var/selection = tgui_input_list(usr, "Select a key:", "Jump to Key", sortKey(keys))
		if(!selection)
			return
		var/mob/M = selection:mob
		log_admin("[key_name(usr)] jumped to [key_name(M)]")
		message_admins("[key_name_admin(usr)] jumped to [key_name_admin(M)]", 1)
		usr.on_mob_jump()
		usr.forceMove(get_turf(M))
		feedback_add_details("admin_verb","JK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		tgui_alert_async(usr, "Admin jumping disabled")

/client/proc/Getmob(mob/living/M as null|anything in mob_list)	//VOREStation Edit
	set category = "Admin"
	set name = "Get Mob"
	set desc = "Mob to teleport"
	set popup_menu = TRUE	//VOREStation Edit

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_EVENT))
		return
	if(CONFIG_GET(flag/allow_admin_jump))
		if(!M)	//VOREStation Edit
			M = tgui_input_list(usr, "Pick a mob:", "Get Mob", mob_list)	//VOREStation Edit
		if(!M)
			return
		log_admin("[key_name(usr)] jumped [key_name(M)] to them")
		var/msg = "[key_name_admin(usr)] jumped [key_name_admin(M)] to them"
		message_admins(msg)
		admin_ticket_log(M, msg)
		M.on_mob_jump()
		M.forceMove(get_turf(usr))
		feedback_add_details("admin_verb","GM") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		tgui_alert_async(usr, "Admin jumping disabled")

/client/proc/Getkey()
	set category = "Admin"
	set name = "Get Key"
	set desc = "Key to teleport"

	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_EVENT))
		return

	if(CONFIG_GET(flag/allow_admin_jump))
		var/list/keys = list()
		for(var/mob/M in player_list)
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
			M.forceMove(get_turf(usr))
			feedback_add_details("admin_verb","GK") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		tgui_alert_async(usr, "Admin jumping disabled")

/client/proc/sendmob()
	set category = "Admin"
	set name = "Send Mob"
	if(!check_rights(R_ADMIN|R_MOD|R_DEBUG|R_EVENT))
		return

	if(CONFIG_GET(flag/allow_admin_jump))
		var/area/A = tgui_input_list(usr, "Pick an area:", "Send Mob", return_sorted_areas())
		if(!A)
			return
		var/mob/M = tgui_input_list(usr, "Pick a mob:", "Send Mob", mob_list)
		if(!M)
			return
		M.on_mob_jump()
		M.forceMove(pick(get_area_turfs(A)))
		feedback_add_details("admin_verb","SMOB") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

		log_admin("[key_name(usr)] teleported [key_name(M)]")
		var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(M)]"
		message_admins(msg)
		admin_ticket_log(M, msg)
	else
		tgui_alert_async(usr, "Admin jumping disabled")

/client/proc/cmd_admin_move_atom(var/atom/movable/AM, tx as num, ty as num, tz as num)
	set category = "Admin"
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
		AM.forceMove(T)
		feedback_add_details("admin_verb", "MA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
		message_admins("[key_name_admin(usr)] jumped [AM] to coordinates [tx], [ty], [tz]")
	else
		tgui_alert_async(usr, "Admin jumping disabled")
