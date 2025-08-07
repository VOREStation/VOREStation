//TODO: Put this under a common parent type with freezers to cut down on the copypasta
#define HEATER_PERF_MULT 2.5
#define REAGENT_COOLING_CONSUMED 0.1
#define REAGENT_COOLING_MINMOD 0.15
#define REAGENT_COOLING_MAXMOD 5

/obj/machinery/atmospherics/unary/heater
	name = "gas heating system"
	desc = "Heats gas when connected to a pipe network. Can be filled by hose with coolant to increase efficiency."
	icon = 'icons/obj/Cryogenic2_vr.dmi'
	icon_state = "heater_0"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_OFF
	idle_power_usage = 5			//5 Watts for thermostat related circuitry
	circuit = /obj/item/circuitboard/unary_atmos/heater

	var/max_temperature = T20C + 680
	var/internal_volume = 600	//L
	var/heating_efficiency = 1

	var/max_power_rating = 20000	//power rating when the usage is turned up to 100
	var/power_setting = 100

	var/set_temperature = T20C	//thermostat
	var/heating = 0		//mainly for icon updates
	var/reagent_cooling = 0

/obj/machinery/atmospherics/unary/heater/Initialize(mapload)
	. = ..()
	default_apply_parts()
	create_reagents(120)
	AddComponent(/datum/component/hose_connector/input)
	AddComponent(/datum/component/hose_connector/output)

/obj/machinery/atmospherics/unary/heater/atmos_init()
	if(node)
		return

	var/node_connect = dir

	//check that there is something to connect to
	for(var/obj/machinery/atmospherics/target in get_step(src, node_connect))
		if(can_be_node(target, 1))
			node = target
			break

	if(check_for_obstacles())
		node = null

	if(node)
		update_icon()


/obj/machinery/atmospherics/unary/heater/update_icon()
	if(node)
		if(use_power && heating)
			icon_state = "heater_1"
		else
			icon_state = "heater"
	else
		icon_state = "heater_0"
	return


/obj/machinery/atmospherics/unary/heater/process()
	..()

	reagent_cooling = 1 + (reagents.machine_cooling_power(reagents) / reagents.maximum_volume)
	if(stat & (NOPOWER|BROKEN) || !use_power)
		heating = 0
		update_icon()
		return

	if(network && air_contents.total_moles && air_contents.temperature < set_temperature)
		air_contents.add_thermal_energy(power_rating * CLAMP(reagent_cooling,REAGENT_COOLING_MINMOD,REAGENT_COOLING_MAXMOD) * HEATER_PERF_MULT * heating_efficiency)
		use_power(power_rating)

		// Process coolant
		reagents.remove_any(REAGENT_COOLING_CONSUMED)

		heating = 1
		network.update = 1
	else
		heating = 0

	update_icon()

/obj/machinery/atmospherics/unary/heater/attack_ai(mob/user as mob)
	tgui_interact(user)

/obj/machinery/atmospherics/unary/heater/attack_hand(mob/user as mob)
	tgui_interact(user)

/obj/machinery/atmospherics/unary/heater/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "GasTemperatureSystem", name)
		ui.open()

/obj/machinery/atmospherics/unary/heater/tgui_data(mob/user)
	// this is the data which will be sent to the ui
	var/data[0]
	data["on"] = use_power ? 1 : 0
	data["gasPressure"] = round(air_contents.return_pressure())
	data["gasTemperature"] = round(air_contents.temperature)
	data["minGasTemperature"] = 0
	data["maxGasTemperature"] = round(max_temperature)
	data["targetGasTemperature"] = round(set_temperature)
	data["powerSetting"] = power_setting

	data["reagentVolume"] = reagents.total_volume
	data["reagentMaximum"] = reagents.maximum_volume
	data["reagentPower"] = reagent_cooling

	var/temp_class = "average"
	if(air_contents.temperature > (T20C+40))
		temp_class = "bad"
	data["gasTemperatureClass"] = temp_class

	return data

/obj/machinery/atmospherics/unary/heater/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	. = TRUE
	switch(action)
		if("toggleStatus")
			update_use_power(!use_power)
			update_icon()
		if("setGasTemperature")
			var/amount = text2num(params["temp"])
			if(amount > 0)
				set_temperature = min(amount, max_temperature)
			else
				set_temperature = max(amount, 0)
		if("setPower") //setting power to 0 is redundant anyways
			var/new_setting = between(0, text2num(params["value"]), 100)
			set_power_level(new_setting)

	add_fingerprint(ui.user)

//upgrading parts
/obj/machinery/atmospherics/unary/heater/RefreshParts()
	..()
	var/cap_rating = 0
	var/bin_rating = 0
	var/laser_rating = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/capacitor))
			cap_rating += P.rating
		if(istype(P, /obj/item/stock_parts/matter_bin))
			bin_rating += P.rating
		if(istype(P, /obj/item/stock_parts/micro_laser))
			laser_rating += (P.rating * 0.25)


	max_power_rating = initial(max_power_rating) * cap_rating / 2
	max_temperature = max(initial(max_temperature) - T20C, 0) * ((bin_rating * 4 + cap_rating) / 5) + T20C
	air_contents.volume = max(initial(internal_volume) - 200, 0) + 200 * bin_rating
	heating_efficiency = max(initial(heating_efficiency), (laser_rating-1))
	set_power_level(power_setting)

/obj/machinery/atmospherics/unary/heater/proc/set_power_level(var/new_power_setting)
	power_setting = new_power_setting
	power_rating = max_power_rating * (power_setting/100)

/obj/machinery/atmospherics/unary/heater/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

	..()

/obj/machinery/atmospherics/unary/heater/examine(mob/user)
	. = ..()
	if(panel_open)
		. += "The maintenance hatch is open."

#undef REAGENT_COOLING_MINMOD
#undef REAGENT_COOLING_MAXMOD
#undef REAGENT_COOLING_CONSUMED
#undef HEATER_PERF_MULT
