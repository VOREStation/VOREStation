//////////////////////////////
// The zone control console, fluffed ingame as
// a scanner console for the asteroid belt
//////////////////////////////

/obj/machinery/computer/roguezones
	name = "asteroid belt scanning computer"
	desc = "Used to monitor the nearby asteroid belt and detect new areas."
	icon_keyboard = "tech_key"
	icon_screen = "request"
	light_color = "#315ab4"
	use_power = 1
	idle_power_usage = 250
	active_power_usage = 500
	circuit = /obj/item/weapon/circuitboard/roguezones

	var/debug = 0
	var/debug_scans = 0
	var/scanning = 0
	var/legacy_zone = 0 //Disable scanning and whatnot.
	var/obj/machinery/computer/shuttle_control/belter/shuttle_control

/obj/machinery/computer/roguezones/initialize()
	..()
	shuttle_control = locate(/obj/machinery/computer/shuttle_control/belter)

/obj/machinery/computer/roguezones/attack_ai(mob/user as mob)
	return attack_hand(user)

/obj/machinery/computer/roguezones/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(stat & (BROKEN|NOPOWER))
		return
	user.set_machine(src)
	ui_interact(user)

/obj/machinery/computer/roguezones/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)


	var/chargePercent = min(100, ((((world.time - rm_controller.last_scan) / 10) / 60) / rm_controller.scan_wait) * 100)
	/*
	world.time - rm_controller.last_scan = deciseconds since last scan
	/10 = seconds since last scan
	/60 = minutes since last scan
	/scan_wait = decimal percentage recharged
	*100 = percentage recharged
	*/
	var/list/data = list()
	data["timeout_percent"] = chargePercent
	data["diffstep"] = rm_controller.diffstep
	data["difficulty"] = rm_controller.diffstep_strs[rm_controller.diffstep]
	data["occupied"] = rm_controller.current_zone ? rm_controller.current_zone.is_occupied() : 0
	data["scanning"] = scanning
	data["updated"] = world.time - rm_controller.last_scan < 200 //Very recently scanned (20 seconds)
	data["debug"] = debug


	var/obj/machinery/computer/shuttle_control/belter/belter = locate()
	if(belter.z == 5)
		data["shuttle_location"] = "Landed"
		data["shuttle_at_station"] = 1
	else if(belter.z == 2)
		data["shuttle_location"] = "In-transit"
		data["shuttle_at_station"] = 0
	else if(belter.z == 7)
		data["shuttle_location"] = "Belt"
		data["shuttle_at_station"] = 0

	var/can_scan = 0
	if(chargePercent >= 100) //Keep having weird problems with these in one 'if' statement
		if(belter.z == 5) //Even though I put them all in parens to avoid OoO problems...
			if(!rm_controller.current_zone || !rm_controller.current_zone.is_occupied()) //Not sure why.
				if(!scanning)
					can_scan = 1

	if(debug_scans) can_scan = 1

	data["scan_ready"] = can_scan

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "zone_console.tmpl", src.name, 600, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(5)

/obj/machinery/computer/roguezones/Topic(href, href_list)
	if(..())
		return 1
	usr.set_machine(src)
	if (href_list["action"])
		switch(href_list["action"])
			if ("scan_for_new")
				scan_for_new_zone()
			if ("point_at_old")
				point_at_old_zone()

	src.add_fingerprint(usr)
	nanomanager.update_uis(src)

/obj/machinery/computer/roguezones/proc/scan_for_new_zone()
	if(scanning) return

	//Set some kinda scanning var to pause UI input on console
	rm_controller.last_scan = world.time
	scanning = 1
	sleep(60)

	//Break the shuttle temporarily.
	shuttle_control.shuttle_tag = null

	//Build and get a new zone.
	var/datum/rogue/zonemaster/ZM_target = rm_controller.prepare_new_zone()

	//Update shuttle destination.
	var/datum/shuttle/ferry/S = shuttle_controller.shuttles["Belter"]
	S.area_offsite = ZM_target.myshuttle

	//Re-enable shuttle.
	shuttle_control.shuttle_tag = "Belter"

	//Update rm_previous
	rm_controller.previous_zone = rm_controller.current_zone

	//Update rm_current
	rm_controller.current_zone = ZM_target

	//Unset scanning
	scanning = 0

	return

/obj/machinery/computer/roguezones/proc/point_at_old_zone()

	return


/obj/item/weapon/circuitboard/roguezones
	name = T_BOARD("asteroid belt scanning computer")
	build_path = /obj/machinery/computer/roguezones
	origin_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 1)
