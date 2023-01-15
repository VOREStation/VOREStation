/datum/artifact_effect/uncommon/fortify
	name = "fortify"
	effect_color = "#84ad87"
	effect_type = EFFECT_ENERGY


/datum/artifact_effect/uncommon/fortify/DoEffectTouch(mob/living/user)
	if (user && isliving(user))
		user.add_modifier(/datum/modifier/fortify, 2 MINUTES)


/datum/artifact_effect/uncommon/fortify/DoEffectAura()
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/L in range(src.effectrange,T))
			if (prob(10))
				L.add_modifier(/datum/modifier/fortify, 10 SECONDS)


/datum/artifact_effect/uncommon/fortify/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/L in range(src.effectrange,T))
			L.add_modifier(/datum/modifier/fortify, 30 SECONDS)
