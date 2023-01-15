/datum/artifact_effect/common/extinguisher
	name = "Extinguisher"
	effect_color = "#AAAABB"
	effect_state = "splashes"
	effect_type = EFFECT_UNKNOWN


/datum/artifact_effect/common/extinguisher/New()
	. = ..()
	effect = pick(EFFECT_PULSE, EFFECT_TOUCH)


/datum/artifact_effect/common/extinguisher/DoEffectTouch(mob/living/user)
	if(user)
		user.ExtinguishMob()
		user.fire_stacks = clamp(user.fire_stacks - 1, -25, 25)


/datum/artifact_effect/common/sweating/UpdateMove()
	DoEffectPulse()


/datum/artifact_effect/common/extinguisher/DoEffectPulse()
	for(var/turf/simulated/T in range(1, get_turf(get_master_holder())))
		if(prob(10))
			T.wet_floor()
		for(var/atom/movable/AM in T)
			AM.water_act(2)
