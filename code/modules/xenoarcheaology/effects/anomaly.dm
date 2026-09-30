/datum/artifact_effect/anomaly
	name = "Anomalous Energies"
	effect_type = EFFECT_ANOMALY

	effect_color = "#d400ff"
	can_start_activated = FALSE // Oops!
	var/active = TRUE
	var/delay = 2 MINUTES

/datum/artifact_effect/anomaly/DoEffectTouch(mob/user)
	var/atom/holder = get_master_holder()
	if(!active)
		return
	if(holder)
		var/turf/holder_loc
		if(istype(holder, /obj/item/anobattery))
			holder = holder.loc
			if(istype(holder, /obj/item/anodevice))
				holder = holder.loc
		holder_loc = holder.loc
		if(isturf(holder_loc))
			generate_anomaly(holder_loc, pick(ANOMALY_ALL), 2, FALSE)
	active = FALSE
	VARSET_IN(src, active, TRUE, delay * 5)

/datum/artifact_effect/anomaly/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(!active)
		return
	if(holder)
		var/turf/holder_loc
		if(istype(holder, /obj/item/anobattery))
			holder = holder.loc
			if(istype(holder, /obj/item/anodevice))
				holder = holder.loc
		holder_loc = holder.loc
		if(isturf(holder_loc))
			for(var/i = 1, i <= 2, i++)
				generate_anomaly(holder_loc, pick(ANOMALY_ALL), 15, FALSE)
	active = FALSE
	VARSET_IN(src, active, TRUE, delay *4 )

/datum/artifact_effect/anomaly/DoEffectPulse()
	if(!active)
		return

	var/datum/anomaly_placer/placer = new()
	for(var/i = 1, i <= 4, i++)
		var/area/chosen_area = placer.find_valid_area()
		generate_anomaly(placer.find_valid_turf(chosen_area), pick(ANOMALY_ALL), 1, FALSE) // EGG HUNT!!
	active = FALSE
	VARSET_IN(src, active, TRUE, delay * 2.5)
