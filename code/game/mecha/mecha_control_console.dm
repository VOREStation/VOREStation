/obj/machinery/computer/mecha
	name = "Exosuit Control"
	desc = "Used to track exosuits, as well as view their logs and activate EMP beacons."
	icon_keyboard = "rd_key"
	icon_screen = "mecha"
	light_color = "#a97faa"
	req_access = list(access_robotics)
	circuit = /obj/item/weapon/circuitboard/mecha_control
	var/list/located = list()
	var/screen = 0
<<<<<<< HEAD
	var/list/stored_data
=======
	var/stored_data

/obj/machinery/computer/mecha/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/computer/mecha/attack_hand(var/mob/user as mob)
	if(..())
		return
	user.set_machine(src)
	var/dat = "<html><head><title>[src.name]</title><style>h3 {margin: 0px; padding: 0px;}</style></head><body>"
	if(screen == 0)
		dat += "<h3>Tracking beacons data</h3>"
		for(var/obj/item/mecha_parts/mecha_tracking/TR in world)
			var/answer = TR.get_mecha_info()
			if(answer)
				dat += {"<hr>[answer]<br/>
							<a href='?src=\ref[src];send_message=\ref[TR]'>Send message</a><br/>
							<a href='?src=\ref[src];get_log=\ref[TR]'>Show exosuit log</a> | <a style='color: #f00;' href='?src=\ref[src];shock=\ref[TR]'>(EMP pulse)</a><br>"}

	if(screen==1)
		dat += "<h3>Log contents</h3>"
		dat += "<a href='?src=\ref[src];return=1'>Return</a><hr>"
		dat += "[stored_data]"

	dat += "<A href='?src=\ref[src];refresh=1'>(Refresh)</A><BR>"
	dat += "</body></html>"

	user << browse(dat, "window=computer;size=400x500")
	onclose(user, "computer")
	return

/obj/machinery/computer/mecha/Topic(href, href_list)
	if(..())
		return
	var/datum/topic_input/top_filter = new /datum/topic_input(href,href_list)
	if(href_list["send_message"])
		var/obj/item/mecha_parts/mecha_tracking/MT = top_filter.getObj("send_message")
		var/message = sanitize(input(usr,"Input message","Transmit message") as text)
		var/obj/mecha/M = MT.in_mecha()
		if(message && M)
			M.occupant_message(message)
		return
	if(href_list["shock"])
		var/obj/item/mecha_parts/mecha_tracking/MT = top_filter.getObj("shock")
		MT.shock()
	if(href_list["get_log"])
		var/obj/item/mecha_parts/mecha_tracking/MT = top_filter.getObj("get_log")
		stored_data = MT.get_mecha_log()
		screen = 1
	if(href_list["return"])
		screen = 0
	src.updateUsrDialog()
	return
>>>>>>> 593246b... Linter diagnostics + bans non-var relative pathing (#8150)

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
				var/message = sanitize(input(usr, "Input message", "Transmit message") as text)
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
	icon_state = "motion2"
	origin_tech = list(TECH_DATA = 2, TECH_MAGNET = 2)

<<<<<<< HEAD
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
=======
/obj/item/mecha_parts/mecha_tracking/proc/get_mecha_info()
	if(!in_mecha())
		return 0
	var/obj/mecha/M = src.loc
	var/cell_charge = M.get_charge()
	var/answer = {"<b>Name:</b> [M.name]<br>
						<b>Integrity:</b> [M.health/initial(M.health)*100]%<br>
						<b>Cell charge:</b> [isnull(cell_charge)?"Not found":"[M.cell.percent()]%"]<br>
						<b>Airtank:</b> [M.return_pressure()]kPa<br>
						<b>Pilot:</b> [M.occupant||"None"]<br>
						<b>Location:</b> [get_area(M)||"Unknown"]<br>
						<b>Active equipment:</b> [M.selected||"None"]"}
	if(istype(M, /obj/mecha/working/ripley))
		var/obj/mecha/working/ripley/RM = M
		answer += "<b>Used cargo space:</b> [RM.cargo.len/RM.cargo_capacity*100]%<br>"

	return answer
>>>>>>> 593246b... Linter diagnostics + bans non-var relative pathing (#8150)

/obj/item/mecha_parts/mecha_tracking/emp_act()
	qdel(src)
	return

/obj/item/mecha_parts/mecha_tracking/ex_act()
	qdel(src)
	return

/obj/item/mecha_parts/mecha_tracking/proc/in_mecha()
<<<<<<< HEAD
	if(istype(loc, /obj/mecha))
		return loc
=======
	if(istype(src.loc, /obj/mecha))
		return src.loc
>>>>>>> 593246b... Linter diagnostics + bans non-var relative pathing (#8150)
	return 0

/obj/item/mecha_parts/mecha_tracking/proc/shock()
	var/obj/mecha/M = in_mecha()
	if(M)
		M.emp_act(4)
	qdel(src)

/obj/item/mecha_parts/mecha_tracking/proc/get_mecha_log()
<<<<<<< HEAD
	if(!in_mecha())
		return list()
	var/obj/mecha/M = loc
	return M.get_log_tgui()
=======
	if(!src.in_mecha())
		return 0
	var/obj/mecha/M = src.loc
	return M.get_log_html()
>>>>>>> 593246b... Linter diagnostics + bans non-var relative pathing (#8150)


/obj/item/weapon/storage/box/mechabeacons
	name = "Exosuit Tracking Beacons"
<<<<<<< HEAD

/obj/item/weapon/storage/box/mechabeacons/New()
	..()
	new /obj/item/mecha_parts/mecha_tracking(src)
	new /obj/item/mecha_parts/mecha_tracking(src)
	new /obj/item/mecha_parts/mecha_tracking(src)
	new /obj/item/mecha_parts/mecha_tracking(src)
	new /obj/item/mecha_parts/mecha_tracking(src)
	new /obj/item/mecha_parts/mecha_tracking(src)
	new /obj/item/mecha_parts/mecha_tracking(src)
=======
	starts_with = list(/obj/item/mecha_parts/mecha_tracking = 7)
>>>>>>> 593246b... Linter diagnostics + bans non-var relative pathing (#8150)
