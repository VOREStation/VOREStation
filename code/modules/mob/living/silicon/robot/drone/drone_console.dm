/obj/machinery/computer/drone_control
	name = "Maintenance Drone Control"
	desc = "Used to monitor the station's drone population and the assembler that services them."
	icon_keyboard = "power_key"
	icon_screen = "generic" //VOREStation Edit
	req_access = list(access_engine_equip)
	circuit = /obj/item/circuitboard/drone_control

	//Used when pinging drones.
	var/drone_call_area = "Engineering"
	//Used to enable or disable drone fabrication.
	var/obj/machinery/drone_fabricator/dronefab

/obj/machinery/computer/drone_control/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/drone_control/tgui_status(mob/user)
	if(!allowed(user))
		return STATUS_CLOSE
	return ..()

/obj/machinery/computer/drone_control/attack_hand(var/mob/user as mob)
	if(..())
		return

	tgui_interact(user)

/obj/machinery/computer/drone_control/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DroneConsole", name)
		ui.open()

/obj/machinery/computer/drone_control/tgui_data(mob/user)
	var/list/data = list()

	var/list/drones = list()
	for(var/mob/living/silicon/robot/drone/D in mob_list)
		//VOREStation Edit - multiz lol
		if(!(D.z in using_map.get_map_levels(z, TRUE, 0)))
			continue
		//VOREStation Edit - multiz lol
		if(D.foreign_droid)
			continue
				
		drones.Add(list(list(
			"name" = D.real_name,
			"active" = D.stat != 2,
			"charge" = D.cell.charge,
			"maxCharge" = D.cell.maxcharge,
			"loc" = "[get_area(D)]",
			"ref" = "\ref[D]",
		)))
	data["drones"] = drones

	data["fabricator"] = dronefab
	data["fabPower"] = dronefab?.produce_drones

	data["areas"] = GLOB.tagger_locations
	data["selected_area"] = "[drone_call_area]"

	return data

/obj/machinery/computer/drone_control/tgui_act(action, params)
	if(..())
		return TRUE

	switch(action)
		if("set_dcall_area")
			var/t_area = params["area"]
			if(!t_area || !(t_area in GLOB.tagger_locations))
				return

			drone_call_area = t_area
			to_chat(usr, "<span class='notice'>You set the area selector to [drone_call_area].</span>")

		if("ping")
			to_chat(usr, "<span class='notice'>You issue a maintenance request for all active drones, highlighting [drone_call_area].</span>")
			for(var/mob/living/silicon/robot/drone/D in player_list)
				if(D.stat == 0)
					to_chat(D, "-- Maintenance drone presence requested in: [drone_call_area].")

		if("resync")
			var/mob/living/silicon/robot/drone/D = locate(params["ref"])

			if(D.stat != 2)
				to_chat(usr, "<span class='danger'>You issue a law synchronization directive for the drone.</span>")
				D.law_resync()

		if("shutdown")
			var/mob/living/silicon/robot/drone/D = locate(params["ref"])

			if(D.stat != 2)
				to_chat(usr, "<span class='danger'>You issue a kill command for the unfortunate drone.</span>")
				message_admins("[key_name_admin(usr)] issued kill order for drone [key_name_admin(D)] from control console.")
				log_game("[key_name(usr)] issued kill order for [key_name(src)] from control console.")
				D.shut_down()

		if("search_fab")
			if(dronefab)
				return

			for(var/obj/machinery/drone_fabricator/fab in oview(3,src))
				if(fab.stat & NOPOWER)
					continue

				dronefab = fab
				to_chat(usr, "<span class='notice'>Drone fabricator located.</span>")
				return

			to_chat(usr, "<span class='danger'>Unable to locate drone fabricator.</span>")

		if("toggle_fab")
			if(!dronefab)
				return

			if(get_dist(src,dronefab) > 3)
				dronefab = null
				to_chat(usr, "<span class='danger'>Unable to locate drone fabricator.</span>")
				return

			dronefab.produce_drones = !dronefab.produce_drones
			to_chat(usr, "<span class='notice'>You [dronefab.produce_drones ? "enable" : "disable"] drone production in the nearby fabricator.</span>")
