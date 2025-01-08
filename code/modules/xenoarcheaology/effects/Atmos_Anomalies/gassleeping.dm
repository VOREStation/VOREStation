/// Verified to work with the Artifact Harvester
/datum/artifact_effect/gassleeping
	name = "N2O creation"

/datum/artifact_effect/gassleeping/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = EFFECT_GAS_SLEEPING

/datum/artifact_effect/gassleeping/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_N2O, rand(2, 15))

/datum/artifact_effect/gassleeping/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_N2O, rand(2, 15))
