/datum/tgui_module/gyrotron_control
	name = "Gyrotron Control"
	tgui_id = "GyrotronControl"

	var/gyro_tag = ""

/datum/tgui_module/gyrotron_control/tgui_act(action, params)
	if(..())
		return TRUE

	for(var/parameter in params)
		to_world("[parameter] - [params[parameter]]")

	switch(action)
		if("toggle_active")
			var/obj/machinery/power/emitter/gyrotron/G = locate(params["gyro"])
			if(!istype(G))
				return 0
			
			G.activate(usr)

			return 1

		if("set_tag")
			var/new_ident = sanitize_text(input("Enter a new ident tag.", "Gyrotron Control", gyro_tag) as null|text)
			if(new_ident)
				gyro_tag = new_ident

		if("set_str")
			var/obj/machinery/power/emitter/gyrotron/G = locate(params["gyro"])
			if(!istype(G))
				return 0

			var/new_strength = params["str"]

			G.mega_energy = new_strength

			return 1

		if("set_rate")
			var/obj/machinery/power/emitter/gyrotron/G = locate(params["gyro"])
			if(!istype(G))
				return 0

			var/new_delay = params["rate"]

			G.rate = new_delay

			return 1

/datum/tgui_module/gyrotron_control/tgui_data(mob/user)
	var/list/data = list()
	var/list/gyros = list()

	for(var/obj/machinery/power/emitter/gyrotron/G in GLOB.gyrotrons)
		if(G.id_tag == gyro_tag)
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