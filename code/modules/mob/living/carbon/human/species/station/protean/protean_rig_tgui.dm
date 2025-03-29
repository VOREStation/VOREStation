/*
It's a bit snowflake, but some rigsuit rewriting was necessary to achieved what I wanted
for protean rigsuits, and rolling these changes into the base RIGsuit code would definitely create
merge conflicts down the line.
So here it sits, snowflake code for a single item.
*/

/obj/item/rig/protean/tgui_state(mob/user)
	return GLOB.tgui_always_state

/obj/item/rig/protean/tgui_data(mob/user)
	var/list/data = list()

	if(selected_module)
		data["primarysystem"] = "[selected_module.interface_name]"
	else
		data["primarysystem"] = null

	if(loc != user)
		data["ai"] = TRUE
	else
		data["ai"] = FALSE

	data["cooling"] = cooling_on
	data["sealed"] = !canremove
	data["sealing"] = sealing
	data["helmet"] = (helmet ? "[helmet.name]" : "None.")
	data["gauntlets"] = (gloves ? "[gloves.name]" : "None.")
	data["boots"] = (boots ?  "[boots.name]" :  "None.")
	data["chest"] = (chest ?  "[chest.name]" :  "None.")

	data["helmetDeployed"] = (helmet && helmet.loc == loc)
	data["gauntletsDeployed"] = (gloves && gloves.loc == loc)
	data["bootsDeployed"] = (boots && boots.loc == loc)
	data["chestDeployed"] = (chest && chest.loc == loc)

	data["charge"] = cell ? round(cell.charge,1) : 0
	data["maxcharge"] = cell ? cell.maxcharge : 0
	data["chargestatus"] = cell ? FLOOR((cell.charge/cell.maxcharge)*50, 1) : 0

	data["emagged"] = subverted
	data["coverlock"] = locked
	data["interfacelock"] = interface_locked
	data["aicontrol"] = control_overridden
	data["aioverride"] = ai_override_enabled
	data["securitycheck"] = security_check_enabled
	data["malf"] = malfunction_delay

	var/list/module_list = list()
	if(!canremove && !sealing)
		var/i = 1
		for(var/obj/item/rig_module/module in installed_modules)
			var/list/module_data = list(
				"index" = i,
				"name" = "[module.interface_name]",
				"desc" = "[module.interface_desc]",
				"can_use" = module.usable,
				"can_select" = module.selectable,
				"can_toggle" = module.toggleable,
				"is_active" = module.active,
				"engagecost" = module.use_power_cost*10,
				"activecost" = module.active_power_cost*10,
				"passivecost" = module.passive_power_cost*10,
				"engagestring" = module.engage_string,
				"activatestring" = module.activate_string,
				"deactivatestring" = module.deactivate_string,
				"damage" = module.damage
				)

			if(module.charges && module.charges.len)
				module_data["charges"] = list()
				var/datum/rig_charge/selected = module.charges["[module.charge_selected]"]
				module_data["realchargetype"] = module.charge_selected
				module_data["chargetype"] = selected ? "[selected.display_name]" : "none"

				for(var/chargetype in module.charges)
					var/datum/rig_charge/charge = module.charges[chargetype]
					module_data["charges"] += list(list("caption" = "[charge.display_name] ([charge.charges])", "index" = "[chargetype]"))

			module_list += list(module_data)
			i++

	if(module_list.len)
		data["modules"] = module_list
	else
		data["modules"] = list()

	return data
/*
/obj/item/rig/protean/tgui_act(action, params, datum/tgui/ui)
	switch(action)
		if("toggle_seals")
			toggle_seals(wearer)
			. = TRUE
		if("toggle_cooling")
			toggle_cooling(wearer)
			. = TRUE
		if("toggle_ai_control")
			to_chat(ui.user, span_notice("Proteans cannot be AI controlled."))
			. = TRUE
		if("toggle_suit_lock")
			locked = !locked
			. = TRUE
		if("toggle_piece")
			toggle_piece(params["piece"], wearer)
			. = TRUE
		if("interact_module")
			var/module_index = text2num(params["module"])

			if(module_index > 0 && module_index <= installed_modules.len)
				var/obj/item/rig_module/module = installed_modules[module_index]
				switch(params["module_mode"])
					if("select")
						selected_module = module
						. = TRUE
					if("engage")
						module.engage()
						. = TRUE
					if("toggle")
						if(module.active)
							module.deactivate()
						else
							module.activate()
						. = TRUE
					if("select_charge_type")
						module.charge_selected = params["charge_type"]
						. = TRUE
*/
