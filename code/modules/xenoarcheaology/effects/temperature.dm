/// Verified to work with the Artifact Harvester
//inverse of /datum/artifact_effect/heat, the two effects split up for neatness' sake
#define COLD 1
#define HOT 2
/datum/artifact_effect/temperature
	name = "Atmospheric Temperature Change"
	var/target_temp
	var/temp_change = COLD

	effect_color = "#b3f6ff"

/datum/artifact_effect/temperature/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA)
	temp_change = pick(COLD, HOT)
	if(temp_change == HOT)
		target_temp = rand(300, 3000)
	else
		target_temp = rand (0, 150)
	effect_type = EFFECT_TEMPERATURE

/datum/artifact_effect/temperature/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	if(holder)
		to_chat(user, span_blue("A chill passes up your spine!"))
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env)
			var/temp_coef = 1 //The closer they are, the harder it is to cause a change.
			if(temp_change == HOT && env.temperature < target_temp)
				temp_coef = ((target_temp)/(env.temperature+1)) //TT = 300. ET = 250. TC = ~1 || TT = 3000. ET = 300 TT = 10. We multiply by 10 below to speed it up.
				env.temperature = max(env.temperature + temp_coef*10, 0)
			else if(temp_change == COLD && env.temperature > target_temp)
				temp_coef = (env.temperature/(target_temp+1)) //ET = 300, TT = 25. TC = 12. Next: ET=288 TT = 25, TC = 11.52. ETC.
				env.temperature = max(env.temperature - temp_coef, 0)

/datum/artifact_effect/temperature/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/datum/gas_mixture/env = holder.loc.return_air()
		if(env)
			var/temp_coef = 1 //The closer they are, the harder it is to cause a change.
			if(temp_change == HOT && env.temperature < target_temp)
				temp_coef = ((target_temp)/(env.temperature+1)) //TT = 300. ET = 250. TC = ~1 || TT = 3000. ET = 300 TT = 10. We multiply by 10 below to speed it up.
				env.temperature = max(env.temperature + temp_coef*10, 0)
			else if(temp_change == COLD && env.temperature > target_temp)
				temp_coef = (env.temperature/(target_temp+1)) //ET = 300, TT = 25. TC = 12. Next: ET=288 TT = 25, TC = 11.52. ETC.
				env.temperature = max(env.temperature - temp_coef, 0)

#undef COLD
#undef HOT
