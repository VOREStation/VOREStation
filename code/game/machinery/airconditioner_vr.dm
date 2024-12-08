#define MODE_IDLE 0
#define MODE_HEATING 1
#define MODE_COOLING 2

/obj/machinery/power/thermoregulator
	name = "thermal regulator"
	desc = "A massive machine that can either add or remove thermal energy from the surrounding environment. Must be secured onto a powered wire node to function."
	icon = 'icons/obj/machines/thermoregulator_vr.dmi'
	icon_state = "lasergen"
	density = TRUE
	anchored = FALSE

	use_power = USE_POWER_OFF //is powered directly from cables
	active_power_usage = 150 KILOWATTS  //BIG POWER
	idle_power_usage = 500

	circuit = /obj/item/circuitboard/thermoregulator

	var/on = 0
	var/target_temp = T20C
	var/mode = MODE_IDLE

/obj/machinery/power/thermoregulator/New()
	..()
	default_apply_parts()

/obj/machinery/power/thermoregulator/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		. += "There is a small display that reads \"[convert_k2c(target_temp)]C\"."

/obj/machinery/power/thermoregulator/attackby(obj/item/I, mob/user)
	if(I.has_tool_quality(TOOL_SCREWDRIVER))
		if(default_deconstruction_screwdriver(user,I))
			return
	if(I.has_tool_quality(TOOL_CROWBAR))
		if(default_deconstruction_crowbar(user,I))
			return
	if(I.has_tool_quality(TOOL_WRENCH))
		anchored = !anchored
		visible_message(span_notice("\The [src] has been [anchored ? "bolted to the floor" : "unbolted from the floor"] by [user]."))
		playsound(src, I.usesound, 75, 1)
		if(anchored)
			connect_to_network()
		else
			disconnect_from_network()
			turn_off()
		return
	if(istype(I, /obj/item/multitool))
		var/new_temp = tgui_input_number(user, "Input a new target temperature, in degrees C.","Target Temperature", convert_k2c(target_temp), min_value=convert_k2c(TCMB), round_value = FALSE)
		if(!Adjacent(user) || user.incapacitated())
			return
		new_temp = convert_c2k(new_temp)
		target_temp = max(new_temp, TCMB)
		return
	..()

/obj/machinery/power/thermoregulator/attack_hand(mob/user)
	add_fingerprint(user)
	interact(user)

/obj/machinery/power/thermoregulator/interact(mob/user)
	if(!anchored)
		return
	on = !on
	user.visible_message(span_notice("[user] [on ? "activates" : "deactivates"] \the [src]."),span_notice("You [on ? "activate" : "deactivate"] \the [src]."))
	if(!on)
		change_mode(MODE_IDLE)
	update_icon()

/obj/machinery/power/thermoregulator/process()
	if(!on)
		return
	if(!powernet)
		turn_off()
		return

	if(draw_power(idle_power_usage) < idle_power_usage)
		visible_message(span_infoplain(span_bold("\The [src]") + " shuts down."))
		turn_off()
		return

	var/datum/gas_mixture/env = loc.return_air()
	if(!env || abs(env.temperature - target_temp) < 1)
		change_mode(MODE_IDLE)
		return

	var/datum/gas_mixture/removed = env.remove_ratio(0.99)
	if(!removed)
		change_mode(MODE_IDLE)
		return

	var/heat_transfer = removed.get_thermal_energy_change(target_temp)
	var/power_avail
	if(heat_transfer == 0) //just in case
		change_mode(MODE_IDLE)
	else if(heat_transfer > 0)
		change_mode(MODE_HEATING)
		power_avail = draw_power(min(heat_transfer, active_power_usage))
		removed.add_thermal_energy(min(power_avail*5,heat_transfer))
	else
		change_mode(MODE_COOLING)
		heat_transfer = abs(heat_transfer)
		var/cop = removed.temperature/TN60C
		var/actual_heat_transfer = heat_transfer
		heat_transfer = min(heat_transfer, active_power_usage*cop)
		power_avail = draw_power(heat_transfer/cop)
		removed.add_thermal_energy(-min(power_avail*5*cop,actual_heat_transfer))
	env.merge(removed)

/obj/machinery/power/thermoregulator/update_icon()
	cut_overlays()
	if(on)
		add_overlay("lasergen-on")
		switch(mode)
			if(MODE_HEATING)
				add_overlay("lasergen-heat")
			if(MODE_COOLING)
				add_overlay("lasergen-cool")

/obj/machinery/power/thermoregulator/proc/turn_off()
	on = 0
	change_mode(MODE_IDLE)
	update_icon()

/obj/machinery/power/thermoregulator/proc/change_mode(new_mode = MODE_IDLE)
	if(mode == new_mode)
		return
	mode = new_mode
	update_icon()

/obj/machinery/power/thermoregulator/emp_act(severity)
	if(!on)
		on = 1
	target_temp += rand(0, 1000)
	update_icon()
	..(severity)

/obj/machinery/power/thermoregulator/overload(var/obj/machinery/power/source)
	if(!anchored || !powernet)
		return
	var/power_avail = draw_power(active_power_usage*10)
	var/datum/gas_mixture/env = loc.return_air()
	if(env)
		var/datum/gas_mixture/removed = env.remove_ratio(0.99)
		if(removed)
			removed.add_thermal_energy(power_avail*5)
			env.merge(removed)
	var/turf/T = get_turf(src)
	new /obj/effect/decal/cleanable/liquid_fuel(T, 5)
	T.assume_gas(GAS_VOLATILE_FUEL, 5, T20C)
	T.hotspot_expose(700,400)
	var/datum/effect/effect/system/spark_spread/s = new
	s.set_up(5, 0, T)
	s.start()
	visible_message(span_warning("\The [src] bursts into flame!"))

#undef MODE_IDLE
#undef MODE_HEATING
#undef MODE_COOLING
