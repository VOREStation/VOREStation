/// Verified to work with the Artifact Harvester
/datum/artifact_effect/gasoxy
	name = "O2 creation"

/datum/artifact_effect/gasoxy/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = EFFECT_GAS_OXY

/datum/artifact_effect/gasoxy/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_O2, rand(2, 15))

/datum/artifact_effect/gasoxy/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_O2, rand(2, 15))
