/// Verified to work with the Artifact Harvester
/datum/artifact_effect/gas
	name = "Gas creation"
	var/GAS_TYPE = GAS_O2 //O2 by default. Changed in /New(). Do NOT MODIFY THIS TO SOMETHING
	effect_type = EFFECT_GAS

	effect_color = "#a5a5a5"


/datum/artifact_effect/gas/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	GAS_TYPE = pick(GAS_CO2, GAS_N2, GAS_N2O, GAS_O2, GAS_PHORON, GAS_VOLATILE_FUEL) //the only way you will EVER see volatile fuel.

/datum/artifact_effect/gas/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(isturf(holder_loc))
			holder_loc.assume_gas(GAS_TYPE, rand(2, 15)) //You can spam touch this, so it's lesser.

/datum/artifact_effect/gas/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(isturf(holder_loc))
			holder_loc.assume_gas(GAS_TYPE, rand(25, 50))
