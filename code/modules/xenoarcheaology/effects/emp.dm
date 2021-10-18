/datum/artifact_effect/emp
	name = "emp"
	effect_type = EFFECT_ELECTRO

	effect_state = "empdisable"

/datum/artifact_effect/emp/New()
	..()
	effect = EFFECT_PULSE

/datum/artifact_effect/emp/DoEffectPulse()
	var/atom/holder = master.holder
	if(holder)
		var/turf/T = get_turf(holder)
		empulse(T, effectrange/4, effectrange/3, effectrange/2, effectrange)
		return 1
