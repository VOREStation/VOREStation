/datum/artifact_effect/emp
	name = "emp"
	effect_type = EFFECT_ELECTRO

/datum/artifact_effect/emp/New()
	..()
	effect = EFFECT_PULSE

/datum/artifact_effect/emp/DoEffectPulse()
<<<<<<< HEAD
=======
	var/atom/holder = get_master_holder()
>>>>>>> a186da160f9... Merge pull request #8339 from Mechoid/AnomBattery
	if(holder)
		var/turf/T = get_turf(holder)
		empulse(T, effectrange/4, effectrange/3, effectrange/2, effectrange)
		return 1
