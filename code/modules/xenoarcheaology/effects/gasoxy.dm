/datum/artifact_effect/gasoxy
	name = "O2 creation"

/datum/artifact_effect/gasoxy/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)

/datum/artifact_effect/gasoxy/DoEffectTouch(var/mob/user)
<<<<<<< HEAD
=======
	var/atom/holder = get_master_holder()
>>>>>>> a186da160f9... Merge pull request #8339 from Mechoid/AnomBattery
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("oxygen", rand(2, 15))

/datum/artifact_effect/gasoxy/DoEffectAura()
<<<<<<< HEAD
=======
	var/atom/holder = get_master_holder()
>>>>>>> a186da160f9... Merge pull request #8339 from Mechoid/AnomBattery
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas("oxygen", pick(0, 0, 0.1, rand()))
