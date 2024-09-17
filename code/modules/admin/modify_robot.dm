/client/proc/modify_robot(var/mob/living/silicon/robot/target in silicon_mob_list)
	set name = "Modify Robot"
	set desc = "Allows to add or remove modules to/from robots."
	set category = "Admin"
	if(!check_rights(R_ADMIN|R_FUN|R_VAREDIT|R_EVENT))
		return

	var/datum/eventkit/modify_robot/modify_robot = new()
	modify_robot.target = target
	modify_robot.tgui_interact(src.mob)

/datum/eventkit/modify_robot
	var/mob/living/silicon/robot/target

/datum/eventkit/modify_robot/New()
	. = ..()

/datum/eventkit/modify_robot/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ModifyRobot", "Modify Robot")
		ui.open()

/datum/eventkit/modify_robot/Destroy()
	. = ..()

/datum/eventkit/modify_robot/tgui_data()
	. = list()
	if(target)
		.["target"] = list()
		.["target"]["name"] = target.name
		.["target"]["ckey"] = target.ckey
		.["target"]["module"] = target.module
		.["target"]["crisis_override"] = target.crisis_override
		.["target"]["active_restrictions"] = target.restrict_modules_to
		var/list/possible_restrictions = list()
		for(var/entry in robot_modules)
			if(!target.restrict_modules_to.Find(entry))
				possible_restrictions += entry
		.["target"]["possible_restrictions"] = possible_restrictions
		if(target.module)
			.["target"]["front"] = icon2base64(get_flat_icon(target,dir=SOUTH,no_anim=TRUE))
			.["target"]["side"] = icon2base64(get_flat_icon(target,dir=WEST,no_anim=TRUE))
			.["target"]["back"] = icon2base64(get_flat_icon(target,dir=NORTH,no_anim=TRUE))
	var/list/all_players = list()
	for(var/mob/living/silicon/robot/R in silicon_mob_list)
		var/list/info = list("displayText" = "[R]", "value" = "\ref[R]")
		all_players.Add(list(info))
	.["all_players"] = all_players


/datum/eventkit/modify_robot/tgui_state(mob/user)
	return GLOB.tgui_admin_state

/datum/eventkit/modify_robot/tgui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("select_target")
			target = locate(params["new_target"])
			return TRUE
		if("toggle_crisis")
			target.crisis_override = !target.crisis_override
			return TRUE
		if("add_restriction")
			target.restrict_modules_to += params["new_restriction"]
		if("remove_restriction")
			target.restrict_modules_to -= params["rem_restriction"]
