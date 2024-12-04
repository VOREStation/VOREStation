/obj/machinery/portable_atmospherics/canister
	name = "canister"
	icon = 'icons/obj/atmos.dmi'
	icon_state = "yellow"
	density = TRUE
	var/health = 100.0
	w_class = ITEMSIZE_HUGE

	layer = TABLE_LAYER	// Above catwalks, hopefully below other things

	var/valve_open = 0
	var/release_pressure = ONE_ATMOSPHERE
	var/release_flow_rate = ATMOS_DEFAULT_VOLUME_PUMP //in L/s

	var/canister_color = "yellow"
	var/can_label = 1
	start_pressure = 45 * ONE_ATMOSPHERE
	pressure_resistance = 7 * ONE_ATMOSPHERE
	var/temperature_resistance = 1000 + T0C
	volume = 1000
	use_power = USE_POWER_OFF
	interact_offline = 1 // Allows this to be used when not in powered area.
	var/release_log = ""
	var/update_flag = 0

/obj/machinery/portable_atmospherics/canister/drain_power()
	return -1

/obj/machinery/portable_atmospherics/canister/nitrous_oxide
	name = "Canister: \[N2O\]"
	icon_state = "redws"
	canister_color = "redws"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/nitrogen
	name = "Canister: \[N2\]"
	icon_state = "red"
	canister_color = "red"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/oxygen
	name = "Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/oxygen/prechilled
	name = "Canister: \[O2 (Cryo)\]"

/obj/machinery/portable_atmospherics/canister/phoron
	name = "Canister \[Phoron\]"
	icon_state = "orangeps"
	canister_color = "orangeps"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/carbon_dioxide
	name = "Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air
	name = "Canister \[Air\]"
	icon_state = "grey"
	canister_color = "grey"
	can_label = 0

/obj/machinery/portable_atmospherics/canister/air/airlock
	start_pressure = 3 * ONE_ATMOSPHERE

/obj/machinery/portable_atmospherics/canister/empty/
	start_pressure = 0
	can_label = 1

/obj/machinery/portable_atmospherics/canister/empty/oxygen
	name = "Canister: \[O2\]"
	icon_state = "blue"
	canister_color = "blue"
/obj/machinery/portable_atmospherics/canister/empty/phoron
	name = "Canister \[Phoron\]"
	icon_state = "orangeps"
	canister_color = "orangeps"
/obj/machinery/portable_atmospherics/canister/empty/nitrogen
	name = "Canister \[N2\]"
	icon_state = "red"
	canister_color = "red"
/obj/machinery/portable_atmospherics/canister/empty/carbon_dioxide
	name = "Canister \[CO2\]"
	icon_state = "black"
	canister_color = "black"
/obj/machinery/portable_atmospherics/canister/empty/nitrous_oxide
	name = "Canister \[N2O\]"
	icon_state = "redws"
	canister_color = "redws"




/obj/machinery/portable_atmospherics/canister/proc/check_change()
	var/old_flag = update_flag
	update_flag = 0
	if(holding)
		update_flag |= 1
	if(connected_port)
		update_flag |= 2

	var/tank_pressure = air_contents.return_pressure()
	if(tank_pressure < 10)
		update_flag |= 4
	else if(tank_pressure < ONE_ATMOSPHERE)
		update_flag |= 8
	else if(tank_pressure < 15*ONE_ATMOSPHERE)
		update_flag |= 16
	else
		update_flag |= 32

	if(update_flag == old_flag)
		return 1
	else
		return 0

/obj/machinery/portable_atmospherics/canister/update_icon()
/*
update_flag
1 = holding
2 = connected_port
4 = tank_pressure < 10
8 = tank_pressure < ONE_ATMOS
16 = tank_pressure < 15*ONE_ATMOS
32 = tank_pressure go boom.
*/

	if (src.destroyed)
		src.overlays = 0
		src.icon_state = text("[]-1", src.canister_color)
		return

	if(icon_state != "[canister_color]")
		icon_state = "[canister_color]"

	if(check_change()) //Returns 1 if no change needed to icons.
		return

	cut_overlays()

	if(update_flag & 1)
		add_overlay("can-open")
	if(update_flag & 2)
		add_overlay("can-connector")
	if(update_flag & 4)
		add_overlay("can-o0")
	if(update_flag & 8)
		add_overlay("can-o1")
	else if(update_flag & 16)
		add_overlay("can-o2")
	else if(update_flag & 32)
		add_overlay("can-o3")
	return

/obj/machinery/portable_atmospherics/canister/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > temperature_resistance)
		health -= 5
		healthcheck()

/obj/machinery/portable_atmospherics/canister/proc/healthcheck()
	if(destroyed)
		return 1

	if (src.health <= 10)
		var/atom/location = src.loc
		location.assume_air(air_contents)

		src.destroyed = 1
		playsound(src, 'sound/effects/spray.ogg', 10, 1, -3)
		src.density = FALSE
		update_icon()

		if (src.holding)
			src.holding.loc = src.loc
			src.holding = null

		return 1
	else
		return 1

/obj/machinery/portable_atmospherics/canister/process()
	if (destroyed)
		return

	..()

	if(valve_open)
		var/datum/gas_mixture/environment
		if(holding)
			environment = holding.air_contents
		else
			environment = loc.return_air()

		var/env_pressure = environment.return_pressure()
		var/pressure_delta = release_pressure - env_pressure

		if((air_contents.temperature > 0) && (pressure_delta > 0))
			var/transfer_moles = calculate_transfer_moles(air_contents, environment, pressure_delta)
			transfer_moles = min(transfer_moles, (release_flow_rate/air_contents.volume)*air_contents.total_moles) //flow rate limit

			var/returnval = pump_gas_passive(src, air_contents, environment, transfer_moles)
			if(returnval >= 0)
				src.update_icon()

	if(air_contents.return_pressure() < 1)
		can_label = 1
	else
		can_label = 0

	air_contents.react() //cooking up air cans - add phoron and oxygen, then heat above PHORON_MINIMUM_BURN_TEMPERATURE

/obj/machinery/portable_atmospherics/canister/return_air()
	return air_contents

/obj/machinery/portable_atmospherics/canister/proc/return_temperature()
	var/datum/gas_mixture/GM = src.return_air()
	if(GM && GM.volume>0)
		return GM.temperature
	return 0

/obj/machinery/portable_atmospherics/canister/proc/return_pressure()
	var/datum/gas_mixture/GM = src.return_air()
	if(GM && GM.volume>0)
		return GM.return_pressure()
	return 0

/obj/machinery/portable_atmospherics/canister/bullet_act(var/obj/item/projectile/Proj)
	if(!(Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		return

	if(Proj.damage)
		src.health -= round(Proj.damage / 2)
		healthcheck()
	..()

/obj/machinery/portable_atmospherics/canister/attackby(var/obj/item/W as obj, var/mob/user as mob)
	if(W.has_tool_quality(TOOL_WELDER)) //Vorestart: Deconstructable Canisters
		var/obj/item/weldingtool/WT = W.get_welder()
		if(!WT.remove_fuel(0, user))
			to_chat(user, "The welding tool must be on to complete this task.")
			return
		if(air_contents.return_pressure() > 1 && !destroyed) // Empty or broken cans are able to be deconstructed
			to_chat(user, span_warning("\The [src]'s internal pressure is too high! Empty the canister before attempting to weld it apart."))
			return
		playsound(src, WT.usesound, 50, 1)
		if(do_after(user, 20 * WT.toolspeed))
			if(!src || !WT.isOn()) return
			to_chat(user, span_notice("You deconstruct the [src]."))
			new /obj/item/stack/material/steel( src.loc, 10)
			qdel(src)
			return
	//Voreend
	if(!W.has_tool_quality(TOOL_WRENCH) && !istype(W, /obj/item/tank) && !istype(W, /obj/item/analyzer) && !istype(W, /obj/item/pda))
		visible_message(span_warning("\The [user] hits \the [src] with \a [W]!"))
		src.health -= W.force
		src.add_fingerprint(user)
		healthcheck()

	if(istype(user, /mob/living/silicon/robot) && istype(W, /obj/item/tank/jetpack))
		var/datum/gas_mixture/thejetpack = W:air_contents
		var/env_pressure = thejetpack.return_pressure()
		var/pressure_delta = min(10*ONE_ATMOSPHERE - env_pressure, (air_contents.return_pressure() - env_pressure)/2)
		//Can not have a pressure delta that would cause environment pressure > tank pressure
		var/transfer_moles = 0
		if((air_contents.temperature > 0) && (pressure_delta > 0))
			transfer_moles = pressure_delta*thejetpack.volume/(air_contents.temperature * R_IDEAL_GAS_EQUATION)//Actually transfer the gas
			var/datum/gas_mixture/removed = air_contents.remove(transfer_moles)
			thejetpack.merge(removed)
			to_chat(user, "You pulse-pressurize your jetpack from the tank.")
		return

	..()

	SStgui.update_uis(src) // Update all NanoUIs attached to src

/obj/machinery/portable_atmospherics/canister/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/portable_atmospherics/canister/attack_hand(var/mob/user as mob)
	return tgui_interact(user)

/obj/machinery/portable_atmospherics/canister/tgui_state(mob/user)
	return GLOB.tgui_physical_state

/obj/machinery/portable_atmospherics/canister/tgui_interact(mob/user, datum/tgui/ui)
	if(destroyed)
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Canister", name)
		ui.open()

/obj/machinery/portable_atmospherics/canister/tgui_data(mob/user)
	var/list/data = list()
	data["can_relabel"] = can_label ? 1 : 0
	data["connected"] = connected_port ? 1 : 0
	data["pressure"] = round(air_contents.return_pressure() ? air_contents.return_pressure() : 0)
	data["releasePressure"] = round(release_pressure ? release_pressure : 0)
	data["defaultReleasePressure"] = round(initial(release_pressure))
	data["minReleasePressure"] = round(ONE_ATMOSPHERE/10)
	data["maxReleasePressure"] = round(10*ONE_ATMOSPHERE)
	data["valveOpen"] = valve_open ? 1 : 0

	if(holding)
		data["holding"] = list()
		data["holding"]["name"] = holding.name
		data["holding"]["pressure"] = round(holding.air_contents.return_pressure())
	else
		data["holding"] = null

	return data

/obj/machinery/portable_atmospherics/canister/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	switch(action)
		if("relabel")
			if(can_label)
				var/list/colors = list(\
					"\[N2O\]" = "redws", \
					"\[N2\]" = "red", \
					"\[O2\]" = "blue", \
					"\[Phoron\]" = "orangeps", \
					"\[CO2\]" = "black", \
					"\[Air\]" = "grey", \
					"\[CAUTION\]" = "yellow", \
				)
				var/label = tgui_input_list(ui.user, "Choose canister label", "Gas canister", colors)
				if(label)
					canister_color = colors[label]
					icon_state = colors[label]
					name = "Canister: [label]"
		if("pressure")
			var/pressure = params["pressure"]
			if(pressure == "reset")
				pressure = initial(release_pressure)
				. = TRUE
			else if(pressure == "min")
				pressure = ONE_ATMOSPHERE/10
				. = TRUE
			else if(pressure == "max")
				pressure = 10*ONE_ATMOSPHERE
				. = TRUE
			else if(pressure == "input")
				pressure = tgui_input_number(ui.user, "New release pressure ([ONE_ATMOSPHERE/10]-[10*ONE_ATMOSPHERE] kPa):", name, release_pressure, 10*ONE_ATMOSPHERE, ONE_ATMOSPHERE/10)
				if(!isnull(pressure) && !..())
					. = TRUE
			else if(text2num(pressure) != null)
				pressure = text2num(pressure)
				. = TRUE
			if(.)
				release_pressure = clamp(round(pressure), ONE_ATMOSPHERE/10, 10*ONE_ATMOSPHERE)
		if("valve")
			if(valve_open)
				if(holding)
					release_log += "Valve was " + span_bold("closed") + " by [ui.user] ([ui.user.ckey]), stopping the transfer into the [holding]<br>"
				else
					release_log += "Valve was " + span_bold("closed") + " by [ui.user] ([ui.user.ckey]), stopping the transfer into the " + span_red(span_bold("air")) + "<br>"
			else
				if(holding)
					release_log += "Valve was " + span_bold("opened") + " by [ui.user] ([ui.user.ckey]), starting the transfer into the [holding]<br>"
				else
					release_log += "Valve was " + span_bold("opened") + " by [ui.user] ([ui.user.ckey]), starting the transfer into the " + span_red(span_bold("air")) + "<br>"
					log_open()
			valve_open = !valve_open
			. = TRUE
		if("eject")
			if(holding)
				if(valve_open)
					valve_open = 0
					release_log += "Valve was " + span_bold("closed") + " by [ui.user] ([ui.user.ckey]), stopping the transfer into the [holding]<br>"
				if(istype(holding, /obj/item/tank))
					holding.manipulated_by = ui.user.real_name
				holding.loc = loc
				holding = null
			. = TRUE

	add_fingerprint(ui.user)
	update_icon()

/obj/machinery/portable_atmospherics/canister/phoron/New()
	..()

	src.air_contents.adjust_gas("phoron", MolesForPressure())
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/oxygen/New()
	..()

	src.air_contents.adjust_gas("oxygen", MolesForPressure())
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/oxygen/prechilled/New()
	..()

	src.air_contents.adjust_gas("oxygen", MolesForPressure())
	src.air_contents.temperature = 80
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/nitrous_oxide/New()
	..()

	air_contents.adjust_gas("nitrous_oxide", MolesForPressure())
	src.update_icon()
	return 1

//Dirty way to fill room with gas. However it is a bit easier to do than creating some floor/engine/n2o -rastaf0
/obj/machinery/portable_atmospherics/canister/nitrous_oxide/roomfiller/Initialize()
	. = ..()
	air_contents.gas["nitrous_oxide"] = 9*4000
	var/turf/simulated/location = src.loc
	if (istype(src.loc))
		location.assume_air(air_contents)
		air_contents = new
	return 1

/obj/machinery/portable_atmospherics/canister/nitrogen/New()

	..()

	src.air_contents.adjust_gas("nitrogen", MolesForPressure())
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/New()
	..()
	src.air_contents.adjust_gas("carbon_dioxide", MolesForPressure())
	src.update_icon()
	return 1


/obj/machinery/portable_atmospherics/canister/air/New()
	..()
	var/list/air_mix = StandardAirMix()
	src.air_contents.adjust_multi("oxygen", air_mix["oxygen"], "nitrogen", air_mix["nitrogen"])

	src.update_icon()
	return 1

//R-UST port
// Special types used for engine setup admin verb, they contain double amount of that of normal canister.
/obj/machinery/portable_atmospherics/canister/nitrogen/engine_setup/New()
	..()
	src.air_contents.adjust_gas("nitrogen", MolesForPressure())
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/carbon_dioxide/engine_setup/New()
	..()
	src.air_contents.adjust_gas("carbon_dioxide", MolesForPressure())
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/phoron/engine_setup/New()
	..()
	src.air_contents.adjust_gas("phoron", MolesForPressure())
	src.update_icon()
	return 1

/obj/machinery/portable_atmospherics/canister/take_damage(var/damage)
	src.health -= damage
	healthcheck()
