/datum/artifact_effect/gasco2
	name = "CO2 creation"
	effect_color = "#a5a5a5"

<<<<<<< HEAD
/datum/artifact_effect/gasco2/New()
=======

/datum/artifact_effect/common/gasco2/New()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)

<<<<<<< HEAD
/datum/artifact_effect/gasco2/DoEffectTouch(var/mob/user)
=======

/datum/artifact_effect/common/gasco2/DoEffectTouch(mob/living/user)
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/holder_loc = holder.loc
		if (istype(holder_loc))
			holder_loc.assume_gas("carbon_dioxide", rand(2, 15))

<<<<<<< HEAD
/datum/artifact_effect/gasco2/DoEffectAura()
=======

/datum/artifact_effect/common/gasco2/DoEffectAura()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/holder_loc = holder.loc
		if (istype(holder_loc))
			holder_loc.assume_gas("carbon_dioxide", pick(0, 0, 0.1, rand()))
