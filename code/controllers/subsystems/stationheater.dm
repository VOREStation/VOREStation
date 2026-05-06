SUBSYSTEM_DEF(stationheater)
	name = "Cryogenic Planets"
	wait =  6 SECOND
	runlevels = RUNLEVEL_GAME
	dependencies = list(
		/datum/controller/subsystem/planets,
		/datum/controller/subsystem/air
	)

	var/list/boilers = list()
	var/list/radiators = list()
	var/list/current_run = list()
	var/datum/weakref/current_loop_heater

	// Radiator power
	var/static/target_heat_temperature = T20C //The temperature the radiator wants the room to reach
	var/static/thermal_energy_change = 4000 //How much energy a radiator can produce a tick

/datum/controller/subsystem/stationheater/Initialize()
	for(var/datum/planet/check in SSplanets.planets)
		if(check.cryogenic_temp_shift)
			return SS_INIT_SUCCESS
	return SS_INIT_NO_NEED // No cryoplanets to deal with!

/datum/controller/subsystem/stationheater/stat_entry(msg)
	msg = " Cr: [length(current_run)] | Br: [length(boilers)] | Rs: [length(radiators)] | Tp: [thermal_energy_change]"
	return ..()

/datum/controller/subsystem/stationheater/fire(resumed)
	if(!length(boilers)) // No boilers? No point, but keep running incase we get one
		return

	// Get current run of all radiators on station
	if(!resumed)
		current_run = radiators.Copy()
		current_loop_heater = WEAKREF(pick(boilers))

	// Process the current run until all raditors are done heating
	var/obj/machinery/atmospherics/binary/stationboiler/current_heater = current_loop_heater?.resolve()
	while(length(current_run))
		var/obj/machinery/stationboiler_radiator/rad = current_run[current_run.len]
		current_run.len--
		if(!QDELETED(rad))
			handle_radiate(rad, current_heater)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/stationheater/proc/handle_radiate(obj/machinery/stationboiler_radiator/radiator, obj/machinery/atmospherics/binary/stationboiler/assigned_boiler)
	// Update radiator icon
	radiator.actively_radiating = assigned_boiler?.is_active
	radiator.update_icon()

	// Do nothing in unsimmed, infact remove us from the potential processing list. this is stupid.
	var/turf/radiator_turf = get_turf(radiator)
	if(!issimulatedturf(radiator_turf))
		radiators -= radiator
		return

	// If the temp is colder than the radiator, begin heating!
	var/datum/gas_mixture/environment = radiator_turf.return_air()
	var/neededEnergy = environment.get_thermal_energy_change(target_heat_temperature)
	if(neededEnergy > 0)
		neededEnergy = min(neededEnergy, thermal_energy_change)
		environment.add_thermal_energy(neededEnergy)
