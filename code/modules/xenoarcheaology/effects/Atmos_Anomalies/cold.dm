/// Verified to work with the Artifact Harvester
//inverse of /datum/artifact_effect/heat, the two effects split up for neatness' sake
/datum/artifact_effect/cold
	name = "Atmospheric Cooling"
	var/target_temp

	effect_color = "#b3f6ff"

/datum/artifact_effect/cold/New()
	..()
	target_temp = rand(0, 250)
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	effect_type = EFFECT_COLD

/datum/artifact_effect/cold/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	if(holder)
		to_chat(user, span_blue("A chill passes up your spine!"))
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env)
			env.temperature = max(env.temperature - rand(5,50), 0)

/datum/artifact_effect/cold/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env && env.temperature > target_temp)
			env.temperature -= pick(0, 0, 1)
