/datum/artifact_effect/gassleeping
	name = "N2O creation"

/datum/artifact_effect/gassleeping/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)

/datum/artifact_effect/gassleeping/DoEffectTouch(var/mob/user)
<<<<<<< HEAD
=======
	var/atom/holder = get_master_holder()
>>>>>>> a186da160f9... Merge pull request #8339 from Mechoid/AnomBattery
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("nitrous_oxide", rand(2, 15))

/datum/artifact_effect/gassleeping/DoEffectAura()
<<<<<<< HEAD
=======
	var/atom/holder = get_master_holder()
>>>>>>> a186da160f9... Merge pull request #8339 from Mechoid/AnomBattery
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("nitrous_oxide", pick(0, 0, 0.1, rand()))
