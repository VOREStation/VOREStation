/datum/tgui_module/gyrotron_control
	name = "Gyrotron Control"
	tgui_id = "GyrotronControl"

	var/gyro_tag = ""
	var/scan_range = 25

/datum/tgui_module/gyrotron_control/tgui_act(action, params)
	if(..())
		return TRUE

	// If the command requires a gyrotron, and we can't find it, we don't need to check any further
	var/obj/machinery/power/emitter/gyrotron/G = null
	if(params["gyro"])
		G = locate(params["gyro"]) in GLOB.gyrotrons
		if(!istype(G))
			return FALSE

	switch(action)
		if("set_tag")
			var/new_ident = sanitize_text(input(usr, "Enter a new ident tag.", "Gyrotron Control", gyro_tag) as null|text)
			if(new_ident)
				gyro_tag = new_ident
			return TRUE

		if("toggle_active")
			G.activate(usr)
			return TRUE

		if("set_str")
			var/new_strength = params["str"]
			if(istext(new_strength))
				new_strength = text2num(new_strength)
			if(new_strength)
				G.set_beam_power(new_strength)
			return TRUE

		if("set_rate")
			var/new_delay = params["rate"]
			if(istext(new_delay))
				new_delay = text2num(new_delay)
			if(new_delay)
				G.rate = new_delay
			return TRUE

/datum/tgui_module/gyrotron_control/tgui_data(mob/user)
	var/list/data = list()
	var/list/gyros = list()

	for(var/obj/machinery/power/emitter/gyrotron/G in GLOB.gyrotrons)
		if(G.id_tag == gyro_tag)// && (get_dist(get_turf(G), get_turf(src)) <= scan_range))
			gyros.Add(list(list(
				"name" = G.name,
				"active" = G.active,
				"strength" = G.mega_energy,
				"fire_delay" = G.rate,
				"deployed" = (G.state == 2),
				"x" = G.x,
				"y" = G.y,
				"z" = G.z,
				"ref" = "\ref[G]"
			)))

	data["gyros"] = gyros
	return data

/datum/tgui_module/gyrotron_control/ntos
	ntos = TRUE