// Self contained file for all things TGUI
/obj/item/pda/tgui_state(mob/user)
	return GLOB.tgui_inventory_state

/obj/item/pda/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Pda", "Personal Data Assistant", parent_ui)
		ui.open()

/obj/item/pda/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
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

		for(var/datum/data/pda/P as anything in prog_list)

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
	data["touch_silent"] = touch_silent

	data["cartridge_name"] = cartridge ? cartridge.name : ""
	data["stationTime"] = stationtime2text() //worldtime2stationtime(world.time) // Aaa which fucking one is canonical there's SO MANY

	data["app"] = list(
		"name" = current_app.title,
		"icon" = current_app.icon,
		"template" = current_app.template,
		"has_back" = current_app.has_back)

	current_app.update_ui(user, data)

	return data

/obj/item/pda/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(ui.user)
	ui.user.set_machine(src)

	if(!touch_silent)
		playsound(src, 'sound/machines/pda_click.ogg', 20)

	. = TRUE
	switch(action)
		if("Home") //Go home, largely replaces the old Return
			var/datum/data/pda/app/main_menu/A = find_program(/datum/data/pda/app/main_menu)
			if(A)
				start_program(A)
		if("StartProgram")
			if(params["program"])
				var/datum/data/pda/app/A = locate(params["program"])
				if(A)
					start_program(A)
		if("Eject")//Ejects the cart, only done from hub.
			if(!isnull(cartridge))
				var/turf/T = loc
				if(ismob(T))
					T = T.loc
				var/obj/item/cartridge/C = cartridge
				C.forceMove(T)
				if(scanmode in C.programs)
					scanmode = null
				if(current_app in C.programs)
					start_program(find_program(/datum/data/pda/app/main_menu))
				if(C.radio)
					C.radio.hostpda = null
				for(var/datum/data/pda/P in notifying_programs)
					if(P in C.programs)
						P.unnotify()
				cartridge = null
				update_shortcuts()
		if("Authenticate")//Checks for ID
			id_check(ui.user, 1)
		if("Retro")
			retro_mode = !retro_mode
		if("TouchSounds")
			touch_silent = !touch_silent
		if("Ringtone")
			return set_ringtone()
		else
			if(current_app)
				. = current_app.tgui_act(action, params, ui, state)

	if((honkamt > 0) && (prob(60)))//For clown virus.
		honkamt--
		playsound(loc, 'sound/items/bikehorn.ogg', 30, 1)
