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

	var/chargePercent = max(100, (world.time - rm_controller.last_scan) / (10 MINUTES) * 100)

	var/list/data = list()
	data["timeout_percent"] = chargePercent
	data["diffstep"] = rm_controller.diffstep
	data["difficulty"] = rm_controller.diffstep_strs[rm_controller.diffstep]
	data["occupied"] = rm_controller.current == null ? 0 : rm_controller.current.is_occupied()

	var/obj/machinery/computer/shuttle_control/belter/belter = locate()
	if(belter.z == 5)
		data["shuttle_location"] = "outpost"
		data["shuttle_at_station"] = 1
	else if(belter.z == 2)
		data["shuttle_location"] = "transit"
		data["shuttle_at_station"] = 0
	else if(belter.z == 7)
		data["shuttle_location"] = "belt"
		data["shuttle_at_station"] = 0

	// Check this stuff
 	if(data["shuttle_at_station"] == 1 && data["occupied"] == 0 && chargePercent >= 100)
 		data["scan_ready"] = 1
 	else
 		data["scan_ready"] = 0

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "zone_console.tmpl", src.name, 400, 450)
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
	// TODO - Actually do something
	return

/obj/machinery/computer/roguezones/proc/point_at_old_zone()
	// TODO - Actually do something
	return


/obj/item/weapon/circuitboard/roguezones
	name = T_BOARD("asteroid belt scanning computer")
	build_path = /obj/machinery/computer/roguezones
	origin_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 1)
