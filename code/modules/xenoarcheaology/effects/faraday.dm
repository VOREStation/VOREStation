/datum/artifact_effect/uncommon/faraday
	name = "faraday"
	effect_color = "#31f5f5"
	effect_type = EFFECT_ELECTRO


/datum/artifact_effect/uncommon/faraday/DoEffectTouch(mob/living/user)
	if (user && isliving(user))
		user.add_modifier(/datum/modifier/faraday, 2 MINUTES)


/datum/artifact_effect/uncommon/faraday/DoEffectAura()
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/L in range(src.effectrange,T))
			if (prob(10))
				L.add_modifier(/datum/modifier/faraday, 10 SECONDS)


/datum/artifact_effect/uncommon/faraday/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/L in range(src.effectrange,T))
			L.add_modifier(/datum/modifier/faraday, 30 SECONDS)
