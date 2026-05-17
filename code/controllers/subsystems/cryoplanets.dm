#define THERMAL_ENERGY_CHANGE 12000

SUBSYSTEM_DEF(cryoplanets)
	name = "Cryogenic Planets"
	wait = 8 SECOND
	runlevels = RUNLEVEL_GAME
	priority = FIRE_PRIORITY_STATIONBOILER
	flags = SS_BACKGROUND // Extremely low priority

	dependencies = list(
		/datum/controller/subsystem/planets,
		/datum/controller/subsystem/air
	)

	var/list/cryo_zones = list()
	VAR_PRIVATE/list/current_run = list()

/datum/controller/subsystem/cryoplanets/Initialize()
	for(var/datum/planet/check in SSplanets.planets)
		if(check.cryogenic_temp_shift)
			return SS_INIT_SUCCESS
	flags |= SS_NO_FIRE
	cryo_zones.Cut() // Populated by Zone/add_zone() which is done by SSair before this. Clear those hardrefs if we are not gonna use them!
	return SS_INIT_NO_NEED // No cryoplanets to deal with!

/datum/controller/subsystem/cryoplanets/stat_entry(msg)
	msg = " Cr: [length(current_run)] | Zs: [length(cryo_zones)]"
	. = ..()

/datum/controller/subsystem/cryoplanets/fire(resumed)
	if(!resumed)
		current_run = cryo_zones.Copy()

	while(length(current_run))
		var/datum/zone/zone = current_run[length(current_run)]
		current_run.len--
		if(QDELETED(zone) || zone.invalid)
			cryo_zones.Remove(zone)
			continue

		var/turf/T = pick(zone.contents)
		if(!SScryoplanets.is_station_temp_change_turf(T))
			cryo_zones.Remove(zone)
			continue

		equalize_temperature_to_planet(T, zone, THERMAL_ENERGY_CHANGE)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/cryoplanets/proc/equalize_temperature_to_planet(turf/T, datum/zone/zone, max_thermal_change)
	var/datum/gas_mixture/currentAir = zone.air
	if(!currentAir)
		return

	// Get the temperature energy needed to shift the zones' temp toward our goal... Maxes out at THERMAL_ENERGY_CHANGE per subsystem tick
	var/datum/planet/P = SSplanets.z_to_planet[T.z]
	var/target_temp = P.weather_holder.temperature
	var/neededEnergy = currentAir.get_thermal_energy_change(target_temp)
	if(neededEnergy > 0)
		neededEnergy = min(neededEnergy, max_thermal_change)
	else
		neededEnergy = max(neededEnergy, -max_thermal_change)

	// Check if this would be affected by the station mainboiler's radiators.
	var/area/check_area = get_area(T) // If we have an active radiator in the area, then there is no point in starting a temperature war....
	if(check_area && length(SSstationheater.radiators) && target_temp < SSstationheater.target_heat_temperature)
		var/obj/structure/stationboiler/current_heater = SSstationheater.get_current_boiler()
		if(current_heater?.is_heating()) // If the current boiler isn't on... It won't matter.
			for(var/obj/machinery/stationboiler_radiator/radiator in SSstationheater.radiators)
				CHECK_TICK
				if(get_area(radiator) != check_area)
					continue
				return // Area had an active radiator, we'll drop out!
	//testing("Energy: [neededEnergy]")
	currentAir.add_thermal_energy(neededEnergy)

/datum/controller/subsystem/cryoplanets/proc/is_station_temp_change_turf(turf/T)
	if(!issimulatedturf(T)) // What are you even doing?
		return FALSE

	if(T.is_outdoors()) // Radiators can't help you outside
		return FALSE

	if(T.z > length(SSplanets.z_to_planet)) // Not even on a planet
		return FALSE

	var/datum/planet/P = SSplanets.z_to_planet[T.z]
	if(!P || !P.cryogenic_temp_shift) // Not on a temp shifting planet
		return FALSE

	var/area/area_check = get_area(T) //Do not freeze dorms
	if(!area_check || (area_check.flags & AREA_CRYOPLANET_SHIELDED))
		return FALSE

	return TRUE

#undef THERMAL_ENERGY_CHANGE
