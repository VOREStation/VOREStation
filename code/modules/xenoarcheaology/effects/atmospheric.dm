/// Verified to work with the Artifact Harvester
/datum/artifact_effect/gas
	name = "Gas creation"
	var/gas_type = GAS_O2 //O2 by default. Changed in /New(). Do NOT MODIFY THIS TO SOMETHING
	var/random = TRUE
	effect_type = EFFECT_GAS
	effect = EFFECT_AURA

	effect_color = "#a5a5a5"


/datum/artifact_effect/gas/New()
	..()
	if(random)
		effect = pick(EFFECT_TOUCH, EFFECT_AURA)
		gas_type = pick(GAS_CO2, GAS_N2, GAS_N2O, GAS_O2, GAS_PHORON, GAS_VOLATILE_FUEL) //the only way you will EVER see volatile fuel.

/datum/artifact_effect/gas/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(isturf(holder_loc))
			holder_loc.assume_gas(gas_type, rand(2, 15)) //You can spam touch this, so it's lesser.

/datum/artifact_effect/gas/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/holder_loc = holder.loc
		if(isturf(holder_loc))
			holder_loc.assume_gas(gas_type, rand(25, 50))

/datum/artifact_effect/gas/sleeping
	random = FALSE
	gas_type = GAS_N2O

/datum/artifact_effect/gas/oxy
	random = FALSE
	gas_type = GAS_O2

/datum/artifact_effect/gas/phoron
	random = FALSE
	gas_type = GAS_PHORON

/datum/artifact_effect/gas/carbondiox
	random = FALSE
	gas_type = GAS_CO2

/datum/artifact_effect/gas/nitro
	random = FALSE
	gas_type = GAS_N2

/datum/artifact_effect/gas/fuel
	random = FALSE
	gas_type = GAS_VOLATILE_FUEL
