/*
 * This defines the global UI for RIGSuits.
 * It has all of the relevant TGUI procs, but it's entry point is in rig_verbs.dm
 * as part of rig/proc/hardsuit_interface().
 */

/*
 * tgui_interact() is the proc that opens the UI. It doesn't really do anything else, unlike NanoV1.
 * We add an extra argument, custom_state, for the things that want a custom state for their UI.
 */
/obj/item/rig/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui, datum/tgui_state/custom_state)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, (loc != usr ? ai_interface_path : interface_path), interface_title)
		ui.open()
	if(custom_state)
		ui.set_state(custom_state)

/*
 * tgui_state() gives the UI the state to use by default.
 */
/obj/item/rig/tgui_state()
	return GLOB.tgui_inventory_state

/*
 * tgui_status() is middlewere for objects to add little exceptions or special cases to the state they use.
 * In this case, we're using it in order to make the UI refuse to let the user press any buttons if they're
 * not authorized to do so.
 * This saves us two lines of code in tgui_act().
 */
/obj/item/rig/tgui_status(mob/user, datum/tgui_state/state)
	. = ..()
	if(!check_suit_access(user, FALSE)) // don't send a message to the user, this is a UI thing
		// Forces the UI to never go interactive,
		// but doesn't interfere with state saying to close.
		. = min(., STATUS_UPDATE)

/*
 * tgui_data() is the heavy lifter, it gives the UI it's relevant datastructure every SStgui tick.
 */
/obj/item/rig/tgui_data(mob/user)
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
 * tgui_act() is the TGUI equivelent of Topic(). It's responsible for all of the "actions" you can take in the UI.
 */
/obj/item/rig/tgui_act(action, params)
	// This parent call is very important, as it's responsible for invoking tgui_status and checking our state's rules.
	if(..())
		return TRUE

	add_fingerprint(usr)

	switch(action)
		if("toggle_seals")
			toggle_seals(usr)
			. = TRUE
		if("toggle_cooling")
			toggle_cooling(usr) // cooling toggles have its own to_chats, tbf
			. = TRUE
		if("toggle_ai_control")
			ai_override_enabled = !ai_override_enabled
			notify_ai("Synthetic suit control has been [ai_override_enabled ? "enabled" : "disabled"].")
			. = TRUE
		if("toggle_suit_lock")
			locked = !locked
			. = TRUE
		if("toggle_piece")
			if(ishuman(usr) && (usr.stat || usr.stunned || usr.lying))
				return FALSE
			toggle_piece(params["piece"], usr)
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
		if("tank_settings")
			air_supply?.attack_self(usr)
			. = TRUE
