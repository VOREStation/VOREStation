// Self contained file for all things TGUI
/obj/item/device/pda/tgui_state(mob/user)
	return GLOB.tgui_inventory_state

/obj/item/device/pda/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Pda", "Personal Data Assistant")
		ui.open()

/obj/item/device/pda/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["owner"] = owner					// Who is your daddy...
	data["ownjob"] = ownjob					// ...and what does he do?

	// update list of shortcuts, only if they changed
	if(!shortcut_cache.len)
		shortcut_cache = list()
		shortcut_cat_order = list()
		var/prog_list = programs.Copy()
		if(cartridge)
			prog_list |= cartridge.programs

		for(var/A in prog_list)
			var/datum/data/pda/P = A

			if(P.hidden)
				continue
			var/list/cat
			if(P.category in shortcut_cache)
				cat = shortcut_cache[P.category]
			else
				cat = list()
				shortcut_cache[P.category] = cat
				shortcut_cat_order += P.category
			cat |= list(list(name = P.name, icon = P.icon, notify_icon = P.notify_icon, ref = "\ref[P]"))

		// force the order of a few core categories
		shortcut_cat_order = list("General") \
			+ sortList(shortcut_cat_order - list("General", "Scanners", "Utilities")) \
			+ list("Scanners", "Utilities")

	data["idInserted"] = (id ? 1 : 0)
	data["idLink"] = (id ? text("[id.registered_name], [id.assignment]") : "--------")

	data["useRetro"] = retro_mode

	data["cartridge_name"] = cartridge ? cartridge.name : ""
	data["stationTime"] = worldtime2stationtime(world.time)

	data["app"] = list(
		"name" = current_app.title,
		"icon" = current_app.icon,
		"template" = current_app.template,
		"has_back" = current_app.has_back)
	current_app.update_ui(user, data)

	return data