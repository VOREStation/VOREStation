/obj/machinery/computer/mecha
	name = "Exosuit Control"
	desc = "Used to track exosuits, as well as view their logs and activate EMP beacons."
	icon_keyboard = "rd_key"
	icon_screen = "mecha"
	light_color = "#a97faa"
	req_access = list(access_robotics)
	circuit = /obj/item/circuitboard/mecha_control
	var/list/located = list()
	var/screen = 0
	var/list/stored_data

/obj/machinery/computer/mecha/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/computer/mecha/attack_hand(mob/user)
	if(..())
		return
	tgui_interact(user)

/obj/machinery/computer/mecha/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MechaControlConsole", name)
		ui.open()

/obj/machinery/computer/mecha/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	
	
	var/list/beacons = list()
	for(var/obj/item/mecha_parts/mecha_tracking/TR in world)
		var/list/tr_data = TR.tgui_data(user)
		if(tr_data)
			beacons.Add(list(tr_data))
	data["beacons"] = beacons
	
	LAZYINITLIST(stored_data)
	data["stored_data"] = stored_data

	return data

/obj/machinery/computer/mecha/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	
	switch(action)
		if("send_message")
			var/obj/item/mecha_parts/mecha_tracking/MT = locate(params["mt"])
			if(istype(MT))
				var/message = sanitize(tgui_input_text(usr, "Input message", "Transmit message"))
				var/obj/mecha/M = MT.in_mecha()
				if(message && M)
					M.occupant_message(message)
			return TRUE

		if("shock")
			var/obj/item/mecha_parts/mecha_tracking/MT = locate(params["mt"])
			if(istype(MT))
				MT.shock()
			return TRUE

		if("get_log")
			var/obj/item/mecha_parts/mecha_tracking/MT = locate(params["mt"])
			if(istype(MT))
				stored_data = MT.get_mecha_log()
			return TRUE
		
		if("clear_log")
			stored_data = null
			return TRUE

/obj/item/mecha_parts/mecha_tracking
	name = "Exosuit tracking beacon"
	desc = "Device used to transmit exosuit data."
	icon = 'icons/obj/device.dmi'
	pickup_sound = 'sound/items/pickup/device.ogg'
	drop_sound = 'sound/items/drop/device.ogg'
	icon_state = "motion2"
	origin_tech = list(TECH_DATA = 2, TECH_MAGNET = 2)

/obj/item/mecha_parts/mecha_tracking/tgui_data(mob/user)
	var/list/data = ..()
	if(!in_mecha())
		return FALSE

	var/obj/mecha/M = loc
	data["ref"] = REF(src)
	data["charge"] = M.get_charge()
	data["name"] = M.name
	data["health"] = M.health
	data["maxHealth"] = initial(M.health)
	data["cell"] = M.cell
	if(M.cell)
		data["cellCharge"] = M.cell.charge
		data["cellMaxCharge"] = M.cell.charge
	data["airtank"] = M.return_pressure()
	data["pilot"] = M.occupant
	data["location"] = get_area(M)
	data["active"] = M.selected
	if(istype(M, /obj/mecha/working/ripley))
		var/obj/mecha/working/ripley/RM = M
		data["cargoUsed"] = RM.cargo.len
		data["cargoMax"] = RM.cargo_capacity

	return data

/obj/item/mecha_parts/mecha_tracking/emp_act()
	qdel(src)
	return

/obj/item/mecha_parts/mecha_tracking/ex_act()
	qdel(src)
	return

/obj/item/mecha_parts/mecha_tracking/proc/in_mecha()
	if(istype(loc, /obj/mecha))
		return loc
	return 0

/obj/item/mecha_parts/mecha_tracking/proc/shock()
	var/obj/mecha/M = in_mecha()
	if(M)
		M.emp_act(4)
	qdel(src)

/obj/item/mecha_parts/mecha_tracking/proc/get_mecha_log()
	if(!in_mecha())
		return list()
	var/obj/mecha/M = loc
	return M.get_log_tgui()


/obj/item/storage/box/mechabeacons
	name = "Exosuit Tracking Beacons"
	starts_with = list(/obj/item/mecha_parts/mecha_tracking = 7)
