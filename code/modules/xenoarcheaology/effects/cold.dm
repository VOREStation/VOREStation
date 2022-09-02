<<<<<<< HEAD
//inverse of /datum/artifact_effect/heat, the two effects split up for neatness' sake
/datum/artifact_effect/cold
=======
/datum/artifact_effect/common/cold
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	name = "cold"
	effect_color = "#b3f6ff"
	var/target_temp


/datum/artifact_effect/cold/New()
	..()
	target_temp = rand(0, 250)
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_ORGANIC, EFFECT_BLUESPACE, EFFECT_SYNTH)

<<<<<<< HEAD
/datum/artifact_effect/cold/DoEffectTouch(var/mob/user)
=======

/datum/artifact_effect/common/cold/DoEffectTouch(mob/living/user)
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		to_chat(user, "<font color='blue'>A chill passes up your spine!</font>")
		var/datum/gas_mixture/env = holder.loc.return_air()
		if (env)
			env.temperature = max(env.temperature - rand(5,50), 0)

<<<<<<< HEAD
/datum/artifact_effect/cold/DoEffectAura()
=======

/datum/artifact_effect/common/cold/DoEffectAura()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/datum/gas_mixture/env = holder.loc.return_air()
		if (env && env.temperature > target_temp)
			env.temperature -= pick(0, 0, 1)
