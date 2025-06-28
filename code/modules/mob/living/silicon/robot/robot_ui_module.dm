// Robot module selection
/datum/tgui_module/robot_ui_module
	name = "Robot Module Configurator"
	tgui_id = "RobotChoose"
	var/selected_module
	var/new_name
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
		get_asset_datum(/datum/asset/spritesheet_batched/robot_icons)
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
			modules.Add(GLOB.shell_module_types)
		else
			modules.Add(GLOB.robot_module_types)
			if(R.crisis || GLOB.security_level >= SEC_LEVEL_RED || R.crisis_override)
				to_chat(R, span_red("Crisis mode active. Combat module available."))
				modules |= GLOB.emergency_module_types
			for(var/module_name in GLOB.whitelisted_module_types)
				if(is_borg_whitelisted(R, module_name))
					modules |= module_name
	data["possible_modules"] = modules
	data["mind_name"] = R.mind.name
	if(R.emagged)
		data["theme"] = "syndicate"
	else if (R.ui_theme)
		data["theme"] = R.ui_theme

	return data

/datum/tgui_module/robot_ui_module/tgui_data()
	var/list/data = ..()

	var/mob/living/silicon/robot/R = host
	var/datum/asset/spritesheet_batched/robot_icons/spritesheet = get_asset_datum(/datum/asset/spritesheet_batched/robot_icons)

	data["currentName"] = new_name ? new_name : R.name
	data["isDefaultName"] = !new_name

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
			if(sprite_datum)
				var/new_datum
				var/list/module_sprites = SSrobot_sprites.get_module_sprites(selected_module, R)
				for(var/datum/robot_sprite/S in module_sprites)
					if(S.name == sprite_datum.name)
						new_datum = S
						break
				sprite_datum = new_datum
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
				new_name = sanitizeSafe(name, MAX_NAME_LEN)
				R.sprite_name = new_name
			. = TRUE
		if("confirm")
			R.apply_name(new_name)
			R.apply_module(sprite_datum, selected_module)
			R.update_multibelly()
			R.transform_module()
			close_ui()
			. = TRUE

/mob/living/silicon/robot/proc/apply_name(var/new_name)
	if(!custom_name)
		if (new_name)
			custom_name = new_name
			sprite_name = new_name

/mob/living/silicon/robot/proc/apply_module(var/datum/robot_sprite/new_datum, var/new_module)
	icon_selected = TRUE
	var/module_type = robot_modules[new_module]
	if(modtype != new_module || !module)
		if(module)
			qdel(module)
		modtype = new_module
		module = new module_type(src)
		feedback_inc("cyborg_[lowertext(new_module)]",1)
	updatename()
	hud_used.update_robot_modules_display()
	notify_ai(ROBOT_NOTIFICATION_NEW_MODULE, module.name)
	robotact?.update_static_data_for_all_viewers()
	sprite_datum = new_datum
	if(!istype(src,/mob/living/silicon/robot/drone))
		sprite_type = sprite_datum.name

/mob/living/silicon/robot/proc/transform_module()
	resize(size_multiplier, animate = FALSE) //Gets the size down to a normal size.
	transform_with_anim()
	var/tempheight = vis_height
	update_icon()
	// This is bad but I dunno other way to 'reset' our resize offset based on vis_height changes other than resizing to normal and back.
	if(tempheight != vis_height)
		var/tempsize = size_multiplier
		resize(1)
		resize(tempsize)
	if(hands)
		update_hud()
	sprite_datum.do_equipment_glamour(module)
	to_chat(src, span_filter_notice("Your icon has been set. You now require a module reset to change it."))
