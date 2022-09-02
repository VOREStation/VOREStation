/datum/artifact_effect/gasphoron
	name = "phoron creation"
	effect_color = "#c408ba"

<<<<<<< HEAD
/datum/artifact_effect/gasphoron/New()
=======

/datum/artifact_effect/uncommon/gasphoron/New()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = pick(EFFECT_BLUESPACE, EFFECT_SYNTH)

<<<<<<< HEAD
/datum/artifact_effect/gasphoron/DoEffectTouch(var/mob/user)
=======

/datum/artifact_effect/uncommon/gasphoron/DoEffectTouch(mob/living/user)
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/holder_loc = holder.loc
		if (istype(holder_loc))
			holder_loc.assume_gas("phoron", rand(2, 15))

<<<<<<< HEAD
/datum/artifact_effect/gasphoron/DoEffectAura()
=======

/datum/artifact_effect/uncommon/gasphoron/DoEffectAura()
>>>>>>> 37cfcfc45fa... Merge pull request #8685 from Spookerton/spkrtn/cng/tweak-effect-aura
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/holder_loc = holder.loc
		if (istype(holder_loc))
			holder_loc.assume_gas("phoron", pick(0, 0, 0.1, rand()))
