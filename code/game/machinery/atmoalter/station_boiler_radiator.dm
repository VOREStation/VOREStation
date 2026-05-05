/obj/machinery/stationboiler_radiator
	name = "Station Radiator"
	desc = "A radiator pipe connected to the station boiler, used to keep the rooms warm"
	icon = 'modular_chomp/icons/obj/machines/floor_radiator_yw.dmi'

	plane = PLATING_PLANE
	layer = FLOOR_HEATER_LAYER

	icon_state = "off"
	use_power = USE_POWER_OFF
	bullet_vulnerability = 0 //Invincible machine
	anchored = TRUE
	density = FALSE
	var/target_heat_temperature = T20C //The temperature we want the room to reach
	var/thermal_energy_change = 4000 //How much energy we can process
	var/obj/machinery/atmospherics/binary/stationboiler/assignedBoiler

/obj/machinery/stationboiler_radiator/process()
	..()
	if(!assignedBoiler && stationboilers)
		assignedBoiler = pick(stationboilers)
	if(!assignedBoiler || !assignedBoiler.is_active)
		if(icon_state != "off")
			icon_state = "off"
		return

	if(icon_state != "on")
		icon_state = "on"
	if(istype(loc, /turf/simulated/))
		var/datum/gas_mixture/environment = loc.return_air()
		var/neededEnergy = environment.get_thermal_energy_change(target_heat_temperature)
		if(neededEnergy > 0)
			neededEnergy = min(neededEnergy, thermal_energy_change)
			environment.add_thermal_energy(neededEnergy)

/obj/machinery/atmospherics/binary/stationboiler/fall_apart(var/severity = 3, scatter = TRUE)
	return //Invincible machine
