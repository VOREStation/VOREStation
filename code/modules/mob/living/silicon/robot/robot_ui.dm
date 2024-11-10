/mob/living/silicon/robot
	var/datum/tgui_module/robot_ui/robotact

// Major Control UI for all things robots can do.
/datum/tgui_module/robot_ui
	name = "Robotact"
	tgui_id = "Robotact"

/datum/tgui_module/robot_ui/tgui_state(mob/user)
	return GLOB.tgui_self_state

/datum/tgui_module/robot_ui/tgui_static_data()
	var/list/data = ..()

	var/mob/living/silicon/robot/R = host

	if(!R.module)
		return data

	var/list/modules = list()
	for(var/obj/item/I as anything in R.module.modules)
		if(!I)
			continue

		UNTYPED_LIST_ADD(modules, list(
			"ref" = REF(I),
			"name" = "[I]",
			"icon" = "[I.icon]",
			"icon_state" = "[I.icon_state]",
		))
	data["modules_static"] = modules

	var/list/emag_modules = list()
	if(R.emagged || R.emag_items)
		for(var/obj/item/I as anything in R.module.emag)
			if(!I)
				continue

			UNTYPED_LIST_ADD(emag_modules, list(
				"ref" = REF(I),
				"name" = "[I.name]",
				"icon" = "[I.icon]",
				"icon_state" = "[I.icon_state]",
			))
	data["emag_modules_static"] = emag_modules

	return data

/datum/tgui_module/robot_ui/tgui_data()
	var/list/data = ..()

	var/mob/living/silicon/robot/R = host

	data["module_name"] = R.module ? "[R.module]" : null

	if(!R.module)
		return data

	data["name"] = R.name
	data["ai"] = "[R.connected_ai]"
	data["charge"] = R.cell?.charge
	data["max_charge"] = R.cell?.maxcharge
	data["health"] = R.health
	data["max_health"] = R.getMaxHealth()
	data["light_color"] = R.robot_light_col
	if(R.emagged)
		data["theme"] = "syndicate"
	else if (R.ui_theme)
		data["theme"] = R.ui_theme

	data["weapon_lock"] = R.weapon_lock

	var/list/modules = list()
	for(var/obj/item/I as anything in R.module.modules)
		if(!I)
			continue

		LAZYSET(modules, REF(I), R.get_slot_from_module(I))
	data["modules"] = modules

	var/list/emag_modules = list()
	if(R.emagged || R.emag_items)
		for(var/obj/item/I as anything in R.module.emag)
			if(!I)
				continue

			LAZYSET(emag_modules, REF(I), R.get_slot_from_module(I))
	data["emag_modules"] = emag_modules

	var/diagnosis_functional = R.is_component_functioning("diagnosis unit")
	data["diag_functional"] = diagnosis_functional

	var/list/components = list()
	for(var/V in R.components)
		var/datum/robot_component/comp = R.components[V]

		UNTYPED_LIST_ADD(components, list(
			"key" = V,
			"name" = "[comp]",
			"brute_damage" = comp.brute_damage,
			"electronics_damage" = diagnosis_functional ? comp.electronics_damage : -1,
			"max_damage" = diagnosis_functional ? comp.max_damage : -1,
			"idle_usage" = diagnosis_functional ? comp.idle_usage : -1,
			"is_powered" = diagnosis_functional ? comp.is_powered() : 0,
			"toggled" = comp.toggled,
		))
	data["components"] = components

	return data

/datum/tgui_module/robot_ui/tgui_act(action, params)
	. = ..()
	if(.)
		return

	var/mob/living/silicon/robot/R = host

	switch(action)
		if("set_light_col")
			var/new_color = params["value"]
			if(findtext(new_color, GLOB.is_color))
				R.robot_light_col = new_color
			. = TRUE
		if("select_module")
			R.pick_module()
			. = TRUE
		if("toggle_component")
			var/component = params["component"]
			var/datum/robot_component/C = LAZYACCESS(R.components, component)
			if(istype(C))
				C.toggled = !C.toggled
				if(C.toggled)
					to_chat(usr, span_notice("You enable [C]."))
				else
					to_chat(usr, span_warning("You disable [C]."))
			. = TRUE
		if("toggle_module")
			if(R.weapon_lock)
				to_chat(usr, span_danger("Error: Modules locked."))
				return
			var/obj/item/module = locate(params["ref"])
			if(istype(module))
				if(R.activated(module))
					R.uneq_specific(module)
				else
					R.activate_module(module)
			. = TRUE
		if("activate_module")
			var/obj/item/module = locate(params["ref"])
			if(istype(module) && module.loc == R)
				module.attack_self(R)
			. = TRUE

		// Quick actions
		if("quick_action_comm")
			R.communicator?.attack_self(R)
			. = TRUE
		if("quick_action_pda")
			R.rbPDA?.tgui_interact(R)
			. = TRUE
		if("quick_action_crew_manifest")
			R.subsystem_crew_manifest()
			. = TRUE
		if("quick_action_law_manager")
			R.subsystem_law_manager()
			. = TRUE
		if("quick_action_alarm_monitoring")
			R.subsystem_alarm_monitor()
			. = TRUE
		if("quick_action_power_monitoring")
			R.subsystem_power_monitor()
			. = TRUE
		if("quick_action_take_image")
			R.take_image()
			. = TRUE
		if("quick_action_view_images")
			R.view_images()
			. = TRUE
		if("quick_action_delete_images")
			R.delete_images()
			. = TRUE
		if("quick_action_flashlight")
			R.toggle_lights()
			. = TRUE
		if("quick_action_sensors")
			R.sensor_mode()
			. = TRUE
		if("quick_action_sparks")
			R.spark_plug()
			. = TRUE
