/datum/artifact_effect/gasoxy
	name = "O2 creation"

<<<<<<< HEAD
/datum/artifact_effect/gasoxy/New()
=======

/datum/artifact_effect/common/gasoxy/New()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)

<<<<<<< HEAD
/datum/artifact_effect/gasoxy/DoEffectTouch(var/mob/user)
=======

/datum/artifact_effect/common/gasoxy/DoEffectTouch(mob/living/user)
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/holder_loc = holder.loc
		if (istype(holder_loc))
			holder_loc.assume_gas("oxygen", rand(2, 15))

<<<<<<< HEAD
/datum/artifact_effect/gasoxy/DoEffectAura()
=======

/datum/artifact_effect/common/gasoxy/DoEffectAura()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/holder_loc = holder.loc
		if (istype(holder_loc))
			holder_loc.assume_gas("oxygen", pick(0, 0, 0.1, rand()))
