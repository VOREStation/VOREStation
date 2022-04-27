/datum/artifact_effect/rare/emp
	name = "emp"
	effect_type = EFFECT_ELECTRO

	effect_state = "empdisable"

/datum/artifact_effect/rare/emp/New()
	..()
	effect = EFFECT_PULSE

/datum/artifact_effect/rare/emp/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		empulse(T, effectrange/4, effectrange/3, effectrange/2, effectrange)
		return 1
