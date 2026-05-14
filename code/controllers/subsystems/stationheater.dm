#define THERMAL_ENERGY_CHANGE 12000

SUBSYSTEM_DEF(stationheater)
	name = "Station Boiler"
	wait = 8 SECOND
	runlevels = RUNLEVEL_GAME
	priority = FIRE_PRIORITY_CRYOPLANETS
	flags = SS_BACKGROUND // Extremely low priority

	dependencies = list(
		/datum/controller/subsystem/planets,
		/datum/controller/subsystem/air
	)

	var/list/boilers = list()
	var/list/radiators = list()
	VAR_PRIVATE/list/current_run = list()
	VAR_PRIVATE/datum/weakref/current_loop_heater

	// Radiator power
	var/static/target_heat_temperature = T20C //The temperature the radiator wants the room to reach

/datum/controller/subsystem/stationheater/Initialize()
	for(var/datum/planet/check in SSplanets.planets)
		if(check.cryogenic_temp_shift)
			return SS_INIT_SUCCESS
	flags |= SS_NO_FIRE
	return SS_INIT_NO_NEED // No cryoplanets to deal with!

/datum/controller/subsystem/stationheater/stat_entry(msg)
	msg = " Cr: [length(current_run)] | Br: [length(boilers)] | Rs: [length(radiators)]"
	. = ..()

/datum/controller/subsystem/stationheater/fire(resumed)
	if(!length(boilers)) // No boilers? No point, but keep running incase we get one
		return

	// Get current run of all radiators on station
	if(!resumed)
		current_run = radiators.Copy()
		current_loop_heater = WEAKREF(pick(boilers))

	// Process the current run until all raditors are done heating
	var/obj/structure/stationboiler/current_heater = get_current_boiler()
	while(length(current_run))
		var/obj/machinery/stationboiler_radiator/rad = current_run[length(current_run)]
		current_run.len--
		if(!QDELETED(rad))
			handle_radiate(rad, current_heater)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/stationheater/proc/get_current_boiler()
	return current_loop_heater?.resolve()

/datum/controller/subsystem/stationheater/proc/handle_radiate(obj/machinery/stationboiler_radiator/radiator, obj/structure/stationboiler/assigned_boiler)
	// Check if this boiler is OUR boiler..... And by that just see if it's in the same zlevel complex.
	if(!assigned_boiler?.is_on_same_planet(radiator))
		return

	// Update radiator icon if the main boiler is functioning or not
	radiator.set_state(assigned_boiler?.is_heating())
	radiator.update_icon()

	// Remove us if we are in an invalid radiator turf
	var/turf/radiator_turf = get_turf(radiator)
	if(!SScryoplanets.is_station_temp_change_turf(radiator_turf))
		return

	// If the temp is colder than the radiator, begin heating!
	var/datum/gas_mixture/environment = radiator_turf.return_air()
	var/neededEnergy = environment.get_thermal_energy_change(target_heat_temperature)
	if(neededEnergy > 0)
		neededEnergy = min(neededEnergy, THERMAL_ENERGY_CHANGE)
		environment.add_thermal_energy(neededEnergy)

#undef THERMAL_ENERGY_CHANGE
