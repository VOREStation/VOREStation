/obj/machinery/space_heater
	anchored = 0
	density = 1
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater0"
	name = "space heater"
	desc = "Made by Space Amish using traditional space techniques, this heater/cooler is guaranteed not to set the station on fire."
	var/obj/item/weapon/cell/cell
	var/cell_type = /obj/item/weapon/cell/high
	var/on = 0
	var/set_temperature = T20C
	var/heating_power = 40000
	var/settableTemperatureMedian = 30 + T0C
	var/settableTemperatureRange = 30

/obj/machinery/space_heater/New()
	..()
	if (cell_type)
		src.cell = new cell_type(src)
	update_icon()

/obj/machinery/space_heater/update_icon()
	overlays.Cut()
	icon_state = "sheater[on]"
	if(panel_open)
		overlays  += "sheater-open"

/obj/machinery/space_heater/examine(mob/user)
	..(user)

	user << "The heater is [on ? "on" : "off"] and the hatch is [panel_open ? "open" : "closed"]."
	if(panel_open)
		user << "The power cell is [cell ? "installed" : "missing"]."
	else
		user << "The charge meter reads [cell ? round(cell.percent(),1) : 0]%"
	return

/obj/machinery/space_heater/powered()
	if(cell && cell.charge)
		return 1
	return 0

/obj/machinery/space_heater/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(cell)
		cell.emp_act(severity)
	..(severity)

/obj/machinery/space_heater/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/cell))
		if(panel_open)
			if(cell)
				user << "There is already a power cell inside."
				return
			else
				// insert cell
				var/obj/item/weapon/cell/C = usr.get_active_hand()
				if(istype(C))
					user.drop_item()
					cell = C
					C.loc = src
					C.add_fingerprint(usr)

					user.visible_message("<span class='notice'>[user] inserts a power cell into [src].</span>", "<span class='notice'>You insert the power cell into [src].</span>")
					power_change()
		else
			user << "The hatch must be open to insert a power cell."
			return
	else if(istype(I, /obj/item/weapon/screwdriver))
		panel_open = !panel_open
		user.visible_message("<span class='notice'>[user] [panel_open ? "opens" : "closes"] the hatch on the [src].</span>", "<span class='notice'>You [panel_open ? "open" : "close"] the hatch on the [src].</span>")
		update_icon()
		if(!panel_open && user.machine == src)
			user << browse(null, "window=spaceheater")
			user.unset_machine()
	else
		..()
	return

/obj/machinery/space_heater/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	tg_ui_interact(user)

/obj/machinery/space_heater/tg_ui_interact(mob/user, ui_key = "main", datum/tgui/ui = null, force_open = 0, datum/tgui/master_ui = null, datum/ui_state/state = tg_physical_state)
	ui = tgui_process.try_update_ui(user, src, ui_key, ui, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "space_heater", name, 400, 305, master_ui, state)
		ui.open()

/obj/machinery/space_heater/ui_data(mob/user)
	var/list/data = list()
	data["open"] = panel_open
	data["hasPowercell"] = cell
	data["on"] = on
	data["powerLevel"] = cell ? round(cell.percent(), 1) : 0
	data["targetTemp"] = round(set_temperature - T0C, 1)
	data["minTemp"] = max(settableTemperatureMedian - settableTemperatureRange - T0C, TCMB)
	data["maxTemp"] = settableTemperatureMedian + settableTemperatureRange - T0C
	var/turf/L = get_turf(loc)
	var/curTemp
	if(istype(L))
		var/datum/gas_mixture/env = L.return_air()
		curTemp = env.temperature
	else if(isturf(L))
		curTemp = L.temperature
	if(isnull(curTemp))
		data["currentTemp"] = "N/A"
	else
		data["currentTemp"] = round(curTemp - T0C, 1)

	return data

/obj/machinery/space_heater/ui_act(action, params)
	if(..())
		return TRUE
	if(usr.stat)
		return TRUE
	if((in_range(src, usr) && istype(src.loc, /turf)) || (istype(usr, /mob/living/silicon)))
		switch(action)
			if("power")
				on = !on
				usr.visible_message("[usr] switches [on ? "on" : "off"] \the [src].", "<span class='notice'>You switch [on ? "on" : "off"] \the [src].</span>")

			if("target")
				if(!panel_open)
					return
				var/target = params["target"]
				var/adjust = text2num(params["adjust"])
				if(target == "input")
					target = input("New target temperature:", name, round(set_temperature - T0C, 1)) as num|null
					if(!isnull(target) && !..())
						target += T0C
				else if(adjust)
					target = set_temperature + adjust
				else if(text2num(target) != null)
					target = text2num(target) + T0C
				if(.)
					set_temperature = Clamp(round(target),
						max(settableTemperatureMedian - settableTemperatureRange, TCMB),
						settableTemperatureMedian + settableTemperatureRange)

			if("eject")
				if(panel_open && cell)
					cell.loc = get_turf(src)
					cell = null

	src.update_icon()
	return TRUE

/obj/machinery/space_heater/process()
	if(!on)
		return
	if(cell && cell.charge > 0)
		var/datum/gas_mixture/env = loc.return_air()
		if(env && abs(env.temperature - set_temperature) > 0.1)
			var/transfer_moles = 0.25 * env.total_moles
			var/datum/gas_mixture/removed = env.remove(transfer_moles)

			if(removed)
				var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
				if(heat_transfer > 0)	//heating air
					heat_transfer = min( heat_transfer , heating_power ) //limit by the power rating of the heater

					removed.add_thermal_energy(heat_transfer)
					cell.use(heat_transfer*CELLRATE)
				else	//cooling air
					heat_transfer = abs(heat_transfer)

					//Assume the heat is being pumped into the hull which is fixed at 20 C
					var/cop = removed.temperature/T20C	//coefficient of performance from thermodynamics -> power used = heat_transfer/cop
					heat_transfer = min(heat_transfer, cop * heating_power)	//limit heat transfer by available power

					heat_transfer = removed.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

					var/power_used = abs(heat_transfer)/cop
					cell.use(power_used*CELLRATE)

			env.merge(removed)
	else
		on = 0
		power_change()
		update_icon()
