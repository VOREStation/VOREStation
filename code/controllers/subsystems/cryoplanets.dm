SUBSYSTEM_DEF(cryoplanets)
	name = "Cryogenic Planets"
	wait = 6 SECOND
	runlevels = RUNLEVEL_GAME
	dependencies = list(
		/datum/controller/subsystem/planets,
		/datum/controller/subsystem/air
	)
	var/static/thermal_energy_change = 4000
	var/list/current_run = list()

/datum/controller/subsystem/cryoplanets/Initialize()
	for(var/datum/planet/check in SSplanets.planets)
		if(check.cryogenic_temp_shift)
			return SS_INIT_SUCCESS
	return SS_INIT_NO_NEED // No cryoplanets to deal with!

/datum/controller/subsystem/cryoplanets/stat_entry(msg)
	msg = " Cr: [length(current_run)] | Zs: [length(SSair.zones)] | Tp: [thermal_energy_change]"
	return ..()

/datum/controller/subsystem/cryoplanets/fire(resumed)
	if(!resumed)
		current_run = SSair.zones.Copy() // We need the list of zones anyway, just use the air controller's instead of duplicating another massive list

	while(length(current_run))
		if(MC_TICK_CHECK)
			return

		var/datum/zone/zone = current_run[current_run.len]
		current_run.len--
		if(zone.invalid || QDELETED(zone)) // Zone stopped existing so don't bother.
			zones_planet_temperature_to_update.Remove(zone)
			continue

		var/turf/T = pick(zone.contents)
		if(!is_station_temp_change_turf(T)) // Invalid temp shifting zone
			zones_planet_temperature_to_update.Remove(zone)
			continue

		equalize_temperature_to_planet(T, zone, thermal_energy_change)

/datum/controller/subsystem/cryoplanets/proc/equalize_temperature_to_planet(turf/T, datum/zone/zone, max_thermal_change)
	var/datum/gas_mixture/currentAir = zone.air
	if(!currentAir)
		return

	// Get the temperature energy needed to shift the zones' temp toward our goal... Maxes out at thermal_energy_change per subsystem tick
	var/datum/planet/P = SSplanets.z_to_planet[T.z]
	var/target_temp = P.weather_holder.temperature
	var/neededEnergy = currentAir.get_thermal_energy_change(target_temp)
	if(neededEnergy > 0)
		neededEnergy = min(neededEnergy, max_thermal_change)
	else
		neededEnergy = max(neededEnergy, -max_thermal_change)

	// Check if this would be affected by the station mainboiler's radiators.
	if(target_temp < SSstationheater.target_heat_temperature)
		var/area/check_area = get_area(T) // If we have an active radiator in the area, then there is no point in starting a temperature war....
		var/obj/machinery/stationboiler_radiator/radiator = locate() in check_area
		if(radiator && radiator.actively_radiating)
			return

	//testing("Energy: [neededEnergy]")
	currentAir.add_thermal_energy(neededEnergy)

/datum/controller/subsystem/cryoplanets/proc/is_station_temp_change_turf(turf/T)
	if(!T || !(T.z in SSplanets.z_to_planet)) // Not even on a planet
		return FALSE

	var/datum/planet/P = SSplanets.z_to_planet[T.z]
	if(!P || !P.cryogenic_temp_shift) // Not on a temp shifting planet
		return FALSE

	var/area/area_check = get_area(T) //Do not freeze dorms
	if(!area_check || (area_check.flags & AREA_CRYOPLANET_SHIELDED))
		return FALSE

	if(T.is_outdoors()) // Outdoors is already affected by weather from the border walls
		return FALSE

	return TRUE
