#define SHEATER_OFF 0
#define SHEATER_STANDBY 1
#define SHEATER_HEAT 2
#define SHEATER_COOL 3

#define DEFAULT_MIN_TEMP T0C
#define DEFAULT_MAX_TEMP T0C + 90
#define DEFAULT_HEATING_POWER 40000

/obj/machinery/space_heater
	anchored = FALSE
	density = TRUE
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater0"
	name = "space heater"
	desc = "Made by Space Amish using traditional space techniques, this heater is guaranteed not to set the station on fire."

	light_system = MOVABLE_LIGHT
	light_range = 3
	light_power = 1
	light_on = FALSE

	var/obj/item/cell/cell
	var/cell_type = /obj/item/cell/high
	var/state = 0
	var/set_temperature = T0C + 20	//K
	var/min_temperature = DEFAULT_MIN_TEMP
	var/max_temperature = DEFAULT_MAX_TEMP
	var/heating_power = 40000
	var/power_efficiency = 1 //Inverse. The lower, the more power efficient we are.
	clicksound = "switch"
	interact_offline = TRUE
	bubble_icon = "engineering"
	circuit = /obj/item/circuitboard/space_heater

/obj/machinery/space_heater/Initialize(mapload)
	. = ..()
	if(cell_type)
		cell = new cell_type(src)
	default_apply_parts()
	update_icon()

/obj/machinery/space_heater/RefreshParts(var/limited = 0)
	min_temperature = DEFAULT_MIN_TEMP
	max_temperature = DEFAULT_MAX_TEMP
	heating_power = DEFAULT_HEATING_POWER
	power_efficiency = 1
	for(var/obj/item/stock_parts/P in component_parts)
		if(P.rating <= 1) //We don't care about calculating if the rating is 1
			continue
		if(istype(P, /obj/item/stock_parts/micro_laser))
			heating_power += ((P.rating-1) * 25000) // Increases the maximum heating/cooling possible. Doesn't affect the heat it pumps out/sucks in. That depends on the difference between the thermostat and the environment. This just clamps that temp change.
		else if(istype(P, /obj/item/stock_parts/manipulator)) //Nothing really fits this so w/e. Capacitor it is.
			min_temperature -= ((P.rating-1) * 23)	//min_temperature starts at 273. A level 5 (omni) will decrease it by 92. -92 x 3 = 276, which we clamp to 0. It still sucks cooling down normal temp areas, but whatever it's a heater. Get a temp pump if you want to cool.
			max_temperature += ((P.rating-1) * 121)	//max_temperature starts at 363. A level 5 (omni) will increase it by 484. 484 x 3 = 1936. Giving us a total of 2299K/2026C.
		else if(istype(P, /obj/item/stock_parts/capacitor))
			power_efficiency -= ((P.rating-1) * 0.06) //Four T2 parts = 24% more efficient. Four T5 parts = 96% more efficient
	min_temperature = max(1, min_temperature)
/obj/machinery/space_heater/update_icon()
	cut_overlays()
	icon_state = "sheater[state]"
	if(panel_open)
		add_overlay("sheater-open")
	switch(state)
		if(SHEATER_OFF)
			set_light_on(FALSE)
		if(SHEATER_STANDBY)
			set_light_on(FALSE)
		if(SHEATER_HEAT)
			set_light_color("#FFCC00")
			set_light_on(TRUE)
		if(SHEATER_COOL)
			set_light_color("#00ccff")
			set_light_on(TRUE)

/obj/machinery/space_heater/examine(mob/user)
	. = ..()

	. += "The heater is [state ? "on" : "off"] and the hatch is [panel_open ? "open" : "closed"]."
	if(panel_open)
		. += "The power cell is [cell ? "installed" : "missing"]."
	else
		. += "The charge meter reads [cell ? round(cell.percent(),1) : 0]%"
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
	if(istype(I, /obj/item/cell))
		if(panel_open)
			if(cell)
				to_chat(user, "There is already a power cell inside.")
				return
			else
				// insert cell
				var/obj/item/cell/C = user.get_active_hand()
				if(istype(C))
					user.drop_item()
					cell = C
					C.loc = src
					C.add_fingerprint(user)

					user.visible_message(span_notice("[user] inserts a power cell into [src]."), span_notice("You insert the power cell into [src]."))
					power_change()
		else
			to_chat(user, "The hatch must be open to insert a power cell.")
			return
	else if(default_part_replacement(user, I))
		return
	else if(I.has_tool_quality(TOOL_SCREWDRIVER))
		panel_open = !panel_open
		playsound(src, I.usesound, 50, 1)
		user.visible_message(span_notice("[user] [panel_open ? "opens" : "closes"] the hatch on the [src]."), span_notice("You [panel_open ? "open" : "close"] the hatch on the [src]."))
		update_icon()
		if(!panel_open && user.machine == src)
			user << browse(null, "window=spaceheater")
			user.unset_machine()
	else
		..()
	return

/obj/machinery/space_heater/attack_hand(mob/user as mob)
	add_fingerprint(user)
	interact(user)

/obj/machinery/space_heater/interact(mob/user as mob)
	if(panel_open)
		tgui_interact(user)
	else
		state = state ? SHEATER_OFF : SHEATER_STANDBY
		user.visible_message(span_notice("[user] switches [state ? "on" : "off"] the [src]."),span_notice("You switch [state ? "on" : "off"] the [src]."))
		update_icon()
	return

/obj/machinery/space_heater/tgui_state(mob/user)
	return GLOB.tgui_physical_state

/obj/machinery/space_heater/tgui_status(mob/user)
	if(!panel_open)
		return STATUS_CLOSE
	return ..()

/obj/machinery/space_heater/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpaceHeater", name)
		ui.open()

/obj/machinery/space_heater/tgui_data(mob/user)
	var/list/data = list()

	data["cell"] = !!cell
	data["power"] = round(cell?.percent(), 1)
	data["temp"] = set_temperature
	data["minTemp"] = min_temperature
	data["maxTemp"] = max_temperature

	return data

/obj/machinery/space_heater/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	if(!panel_open)
		return FALSE

	switch(action)
		if("temp")
			// limit to 0-90 degC
			set_temperature = clamp(text2num(params["newtemp"]), min_temperature, max_temperature)
			. = TRUE

		if("cellremove")
			if(cell && !ui.user.get_active_hand())
				ui.user.visible_message(span_notice("[ui.user] removes [cell] from [src]."), span_notice("You remove [cell] from [src]."))
				cell.update_icon()
				ui.user.put_in_hands(cell)
				cell.add_fingerprint(ui.user)
				cell = null
				power_change()
				. = TRUE


		if("cellinstall")
			if(!cell)
				var/obj/item/cell/C = ui.user.get_active_hand()
				if(istype(C))
					ui.user.drop_item()
					cell = C
					C.loc = src
					C.add_fingerprint(ui.user)
					power_change()
					ui.user.visible_message(span_notice("[ui.user] inserts \the [C] into \the [src]."), span_notice("You insert \the [C] into \the [src]."))
				. = TRUE

/obj/machinery/space_heater/process()
	if(!state)
		return

	if(cell && cell.charge)
		var/datum/gas_mixture/env = loc.return_air()
		if(env && abs(env.temperature - set_temperature) > 0.1)
			var/transfer_moles = 0.25 * env.total_moles
			var/datum/gas_mixture/removed = env.remove(transfer_moles)
			if(removed)
				var/heat_transfer = removed.get_thermal_energy_change(set_temperature)
				if(heat_transfer > 0)	//heating air
					if(state == SHEATER_STANDBY)
						state = SHEATER_HEAT
						update_icon()
					heat_transfer = min(heat_transfer , heating_power) //limit by the power rating of the heater

					removed.add_thermal_energy(heat_transfer)
					cell.use(heat_transfer*CELLRATE*power_efficiency)
				else	//cooling air
					if(state == SHEATER_STANDBY)
						state = SHEATER_COOL
						update_icon()
					heat_transfer = abs(heat_transfer)

					//Assume the heat is being pumped into the hull which is fixed at 20 C
					var/cop = removed.temperature/T20C	//coefficient of performance from thermodynamics -> power used = heat_transfer/cop
					heat_transfer = min(heat_transfer, cop * heating_power)	//limit heat transfer by available power
					heat_transfer = removed.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

					var/power_used = abs(heat_transfer)/cop
					cell.use(power_used*CELLRATE*power_efficiency)

			env.merge(removed)
	else
		state = SHEATER_OFF
		power_change()
		update_icon()

#undef SHEATER_OFF
#undef SHEATER_STANDBY
#undef SHEATER_HEAT
#undef SHEATER_COOL
#undef DEFAULT_MIN_TEMP
#undef DEFAULT_MAX_TEMP
#undef DEFAULT_HEATING_POWER
