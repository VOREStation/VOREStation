/datum/artifact_effect/emp
	name = "emp"
	effect_type = EFFECT_ELECTRO
	effect_state = "empdisable"

<<<<<<< HEAD
/datum/artifact_effect/emp/New()
	..()
	effect = EFFECT_PULSE

/datum/artifact_effect/emp/DoEffectPulse()
=======

/datum/artifact_effect/rare/emp/New()
	..()
	effect = EFFECT_PULSE


/datum/artifact_effect/rare/emp/DoEffectPulse()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		empulse(T, effectrange/4, effectrange/3, effectrange/2, effectrange)
