/datum/artifact_effect/gassleeping
	name = "N2O creation"


/datum/artifact_effect/gassleeping/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)

<<<<<<< HEAD
/datum/artifact_effect/gassleeping/DoEffectTouch(var/mob/user)
=======

/datum/artifact_effect/rare/gassleeping/DoEffectTouch(mob/living/user)
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/holder_loc = holder.loc
		if (istype(holder_loc))
			holder_loc.assume_gas("nitrous_oxide", rand(2, 15))

<<<<<<< HEAD
/datum/artifact_effect/gassleeping/DoEffectAura()
=======

/datum/artifact_effect/rare/gassleeping/DoEffectAura()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/holder_loc = holder.loc
		if (istype(holder_loc))
			holder_loc.assume_gas("nitrous_oxide", pick(0, 0, 0.1, rand()))
