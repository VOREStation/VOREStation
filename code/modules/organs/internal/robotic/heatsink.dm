
/obj/item/organ/internal/robotic/heatsink
	name = "heatsink"
	icon_state = "heatsink"

	organ_tag = O_HEATSINK

/obj/item/organ/internal/robotic/heatsink/handle_organ_proc_special()
	if(owner && owner.stat != DEAD)
		owner.bodytemperature += round(owner.robobody_count * 0.75, 0.1)

		var/thermostat = owner.species.body_temperature
		var/turf/T = get_turf(src)
		var/datum/gas_mixture/environment = T.return_air()
		var/efficiency = max(0,(1 - owner.get_pressure_weakness(environment.return_pressure())) * (1 - damage / max_damage))
		var/temp_adj = 0
		var/env_temp = get_environment_temperature()
		var/thermal_protection = owner.get_heat_protection(env_temp)

		if(thermal_protection < 1)
			temp_adj = min(owner.bodytemperature - max(thermostat, env_temp), owner.robobody_count * 2)
		else
			temp_adj = min(owner.bodytemperature - thermostat, owner.robobody_count * 2)

		if(temp_adj < 0)
			return

		owner.bodytemperature -= temp_adj*efficiency

		if(owner.bodytemperature > owner.species.heat_level_2)	// If you're already overheating to the point of melting, the heatsink starts causing problems.
			owner.adjustToxLoss(2 * damage / max_damage)
			take_damage(max(0.5,round(damage / max_damage, 0.1)))

	return

/obj/item/organ/internal/robotic/heatsink/proc/get_environment_temperature()
	if(istype(owner.loc, /obj/mecha))
		var/obj/mecha/M = owner.loc
		return M.return_temperature()
	else if(istype(owner.loc, /obj/machinery/atmospherics/unary/cryo_cell))
		var/obj/machinery/atmospherics/unary/cryo_cell/cc = owner.loc
		return cc.air_contents.temperature

	var/turf/T = get_turf(src)

	var/datum/gas_mixture/environment = T.return_air()

	var/efficiency = 1

	if(environment)
		efficiency = (1 - owner.get_pressure_weakness(environment.return_pressure())) * (1 - damage / max_damage)

	if(istype(T, /turf/space))
		return owner.species.heat_level_2 * efficiency

	if(!environment)
		return owner.species.heat_level_2 * efficiency

	return environment.temperature
