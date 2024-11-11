// Robot module selection
/datum/tgui_module/robot_ui_module
	name = "Robot Module Configurator"
	tgui_id = "RobotChoose"
	var/selected_module
	var/newName
	var/datum/robot_sprite/sprite_datum

/datum/tgui_module/robot_ui_module/tgui_state(mob/user)
	return GLOB.tgui_self_state

/datum/tgui_module/robot_ui_module/tgui_close(mob/user)
	. = ..()
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		R.selecting_module = FALSE

/datum/tgui_module/robot_ui_module/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()
	if(isrobot(user) && ui)
		var/mob/living/silicon/robot/R = user
		R.selecting_module = TRUE

/datum/tgui_module/robot_ui_module/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/robot_icons)
	)

/datum/tgui_module/robot_ui_module/tgui_static_data()
	var/list/data = ..()

	var/mob/living/silicon/robot/R = host

	var/list/modules = list()
	if(R.module)
		modules = list(R.modtype)
		selected_module = R.modtype
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
	if(R.emagged)
		data["theme"] = "syndicate"
	else if (R.ui_theme)
		data["theme"] = R.ui_theme

	return data

/datum/tgui_module/robot_ui_module/tgui_data()
	var/list/data = ..()

	var/mob/living/silicon/robot/R = host
	var/datum/asset/spritesheet/robot_icons/spritesheet = get_asset_datum(/datum/asset/spritesheet/robot_icons)

	data["currentName"] = newName ? newName : R.name
	data["isDefaultName"] = !newName

	if(selected_module)
		data["selected_module"]  = selected_module
		if(!SSrobot_sprites)
			to_chat(R, span_warning("Robot Sprites have not been initialized yet. How are you choosing a sprite? Harass a coder."))
			selected_module = null
			return

		var/list/module_sprites = SSrobot_sprites.get_module_sprites(selected_module, R)
		if(!module_sprites || !module_sprites.len)
			to_chat(R, span_warning("Your module appears to have no sprite options. Harass a coder."))
			selected_module = null
			return
		var/list/available_sprites = list()
		for(var/datum/robot_sprite/S in module_sprites)
			var/model_type = "def"
			if(istype(S, /datum/robot_sprite/dogborg))
				model_type = "wide"
			if(istype(S, /datum/robot_sprite/dogborg/tall))
				model_type = "tall"
			available_sprites += list(list("sprite" = S.name, "belly" = S.has_vore_belly_sprites, "type" = model_type))

		data["possible_sprites"] = available_sprites
		data["sprite_datum"] = sprite_datum
		data["sprite_datum_class"] = null
		data["sprite_datum_size"] = null
		if(sprite_datum)
			data["sprite_datum_class"] = sanitize_css_class_name("[sprite_datum.type]")
			data["sprite_datum_size"] = spritesheet.icon_size_id(data["sprite_datum_class"] + "S") // just get the south icon's size, the rest will be the same

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
			var/list/module_sprites = SSrobot_sprites.get_module_sprites(selected_module, R)
			if(!(sprite_datum in module_sprites))
				sprite_datum = null
			. = TRUE
		if("pick_icon")
			var/sprite = params["value"]
			if(!sprite)
				return
			var/list/module_sprites = SSrobot_sprites.get_module_sprites(selected_module, R)
			for(var/datum/robot_sprite/S in module_sprites)
				if(S.name == sprite)
					sprite_datum = S
					break
			. = TRUE
		if("rename")
			var/name = params["value"]
			if(name)
				newName = sanitizeSafe(name, MAX_NAME_LEN)
			. = TRUE
		if("confirm")
			if(!R.custom_name)
				if (newName)
					R.custom_name = newName
					R.sprite_name = newName
			R.icon_selected = 1
			var/module_type = robot_modules[selected_module]
			R.modtype = selected_module
			R.module = new module_type(R)
			feedback_inc("cyborg_[lowertext(selected_module)]",1)
			R.updatename()
			R.hud_used.update_robot_modules_display()
			R.notify_ai(ROBOT_NOTIFICATION_NEW_MODULE, R.module.name)
			R.robotact?.update_static_data_for_all_viewers()
			R.sprite_datum = sprite_datum
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
			R.sprite_datum.do_equipment_glamour(R.module)
			to_chat(R, span_filter_notice("Your icon has been set. You now require a module reset to change it."))
			close_ui()
			. = TRUE
