// Robot module selection
/datum/tgui_module/robot_ui_module
	name = "Robot Module Configurator"
	tgui_id = "RobotChoose"
	var/selected_module
	var/datum/robot_sprite/sprite_datum

/datum/tgui_module/robot_ui_module/tgui_state(mob/user)
	return GLOB.tgui_self_state

/datum/tgui_module/robot_ui_module/tgui_static_data()
	var/list/data = ..()

	var/mob/living/silicon/robot/R = host

	var/list/modules = list()
	if(R.module)
		modules = list(R.module)
		selected_module = R.module
	else
		if(LAZYLEN(R.restrict_modules_to) > 0)
			modules.Add(R.restrict_modules_to)
		else if(R.shell)
			modules.Add(shell_module_types)
		else
			modules.Add(robot_module_types)
			if(R.crisis || security_level == SEC_LEVEL_RED || R.crisis_override)
				to_chat(R, span_red("Crisis mode active. Combat module available."))
				modules |= emergency_module_types
			for(var/module_name in whitelisted_module_types)
				if(is_borg_whitelisted(R, module_name))
					modules |= module_name
	data["possible_modules"] = modules

	return data

/datum/tgui_module/robot_ui_module/tgui_data()
	var/list/data = ..()

	var/mob/living/silicon/robot/R = host

	if(selected_module)
		if(!SSrobot_sprites)
			to_chat(R, span_warning("Robot Sprites have not been initialized yet. How are you choosing a sprite? Harass a coder."))
			selected_module = null
			return

		var/list/module_sprites = SSrobot_sprites.get_module_sprites(selected_module, R)
		if(!module_sprites || !module_sprites.len)
			to_chat(R, span_warning("Your module appears to have no sprite options. Harass a coder."))
			selected_module = null
			return

		data["possible_sprites"] = module_sprites

	return data

/datum/tgui_module/robot_ui_module/tgui_act(action, params)
	. = ..()
	if(.)
		return

	var/mob/living/silicon/robot/R = host

	switch(action)
		if("pick_module")
			if(R.module)
				return
			var/new_module = params["value"]
			if(!(new_module in robot_modules))
				return
			if(!is_borg_whitelisted(R, new_module))
				return
			selected_module = new_module
			. = TRUE
		if("pick_icon")
			var/sprite = params["value"]
			if(!sprite)
				return
			var/list/module_sprites = SSrobot_sprites.get_module_sprites(selected_module, R)
			sprite_datum = module_sprites[sprite]
			. = TRUE
		if("confirm")
			R.icon_selected = 1
			var/module_type = robot_modules[selected_module]
			R.module = new module_type(R)
			R.hands.icon_state = R.get_hud_module_icon()
			feedback_inc("cyborg_[lowertext(selected_module)]",1)
			R.updatename()
			R.hud_used.update_robot_modules_display()
			R.notify_ai(ROBOT_NOTIFICATION_NEW_MODULE, R.module.name)
			R.robotact?.update_static_data_for_all_viewers()
			if(!istype(R,/mob/living/silicon/robot/drone))
				R.sprite_type = sprite_datum.name
			R.transform_with_anim()
			var/tempheight = R.vis_height
			R.update_icon()
			// This is bad but I dunno other way to 'reset' our resize offset based on vis_height changes other than resizing to normal and back.
			if(tempheight != R.vis_height)
				var/tempsize = R.size_multiplier
				R.resize(1)
				R.resize(tempsize)
			if(R.hands)
				R.update_hud()
			to_chat(R, span_filter_notice("Your icon has been set. You now require a module reset to change it."))
			tgui_close()
