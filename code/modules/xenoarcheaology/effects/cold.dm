//inverse of /datum/artifact_effect/heat, the two effects split up for neatness' sake
/datum/artifact_effect/cold
	name = "cold"
	var/target_temp

	effect_color = "#b3f6ff"

/datum/artifact_effect/cold/New()
	..()
	target_temp = rand(0, 250)
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_ORGANIC, EFFECT_BLUESPACE, EFFECT_SYNTH)

/datum/artifact_effect/cold/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	if(holder)
		to_chat(user, "<font color='blue'>A chill passes up your spine!</font>")
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env)
			env.temperature = max(env.temperature - rand(5,50), 0)

<<<<<<< HEAD
/datum/artifact_effect/cold/DoEffectAura()
=======
	var/turf/simulated/T = get_turf(holder)
	if(istype(T))
		T.freeze_floor()

/datum/artifact_effect/common/cold/DoEffectAura()
>>>>>>> f473ed9717a... Moves blob chunk effects to artifact effects. (#8783)
	var/atom/holder = get_master_holder()
	if(holder)
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env && env.temperature > target_temp)
			env.temperature -= pick(0, 0, 1)
	var/turf/simulated/T = get_turf(holder)
	if(istype(T))
		T.freeze_floor()
