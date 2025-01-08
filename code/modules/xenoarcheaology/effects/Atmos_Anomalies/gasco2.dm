/// Verified to work with the Artifact Harvester
/datum/artifact_effect/gasco2
	name = "CO2 creation"

	effect_color = "#a5a5a5"

/datum/artifact_effect/gasco2/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = EFFECT_GAS_C02

/datum/artifact_effect/gasco2/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_CO2, rand(2, 15))

/datum/artifact_effect/gasco2/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(istype(holder_loc))
			holder_loc.assume_gas(GAS_CO2, rand(2, 15))
