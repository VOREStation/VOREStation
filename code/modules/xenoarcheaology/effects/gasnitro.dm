/datum/artifact_effect/gasnitro
	name = "N2 creation"
	effect_color = "#c2d3d8"

<<<<<<< HEAD
/datum/artifact_effect/gasnitro/New()
=======

/datum/artifact_effect/common/gasnitro/New()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)

<<<<<<< HEAD
/datum/artifact_effect/gasnitro/DoEffectTouch(var/mob/user)
=======

/datum/artifact_effect/common/gasnitro/DoEffectTouch(mob/living/user)
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/holder_loc = holder.loc
		if (istype(holder_loc))
			holder_loc.assume_gas("nitrogen", rand(2, 15))

<<<<<<< HEAD
/datum/artifact_effect/gasnitro/DoEffectAura()
=======

/datum/artifact_effect/common/gasnitro/DoEffectAura()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/holder_loc = holder.loc
		if (istype(holder_loc))
			holder_loc.assume_gas("nitrogen", pick(0, 0, 0.1, rand()))
