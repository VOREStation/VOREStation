/// Verified to work with the Artifact Harvester
#define ROBO_HEAL 1
#define ROBO_HARM 2
/datum/artifact_effect/robohealth
	name = "Robotic Healing"
	var/last_message
	effect_type = EFFECT_ROBOT_HEALTH
	effect_color = "#3879ad"
	var/health_type = ROBO_HEAL

/datum/artifact_effect/robohealth/New()
	..()
	health_type = pick(ROBO_HEAL, ROBO_HARM)
	if(health_type == ROBO_HARM)
		effect_color = "#5432cf"
	else
		effect_color = "#3879ad"

/datum/artifact_effect/robohealth/DoEffectTouch(var/mob/user)
	if(user)
		if(isrobot(user))
			var/mob/living/silicon/robot/R = user
			if(health_type == ROBO_HEAL)
				to_chat(R, span_blue("Your systems report damaged components mending by themselves!"))
				R.adjustBruteLoss(rand(-10,-30))
				R.adjustFireLoss(rand(-10,-30))
			else
				to_chat(R, span_red("Your systems report severe damage has been inflicted!"))
				R.adjustBruteLoss(rand(10,50))
				R.adjustFireLoss(rand(10,50))
			return 1

/datum/artifact_effect/robohealth/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/silicon/robot/M in range(src.effectrange,T))
			if(health_type == ROBO_HEAL)
				if(world.time - last_message > 200)
					to_chat(M, span_blue("SYSTEM ALERT: Beneficial energy field detected!"))
					last_message = world.time
				M.adjustBruteLoss(-1)
				M.adjustFireLoss(-1)
				M.updatehealth()
			else
				if(world.time - last_message > 200)
					to_chat(M, span_red("SYSTEM ALERT: Harmful energy field detected!"))
					last_message = world.time
				M.adjustBruteLoss(1)
				M.adjustFireLoss(1)
				M.updatehealth()
		return 1

/datum/artifact_effect/robohealth/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/silicon/robot/M in range(src.effectrange,T))
			if(health_type == ROBO_HEAL)
				if(world.time - last_message > 200)
					to_chat(M, span_blue("SYSTEM ALERT: Structural damage has been repaired by energy pulse!"))
					last_message = world.time
				M.adjustBruteLoss(-10)
				M.adjustFireLoss(-10)
				M.updatehealth()
			else
				if(world.time - last_message > 200)
					to_chat(M, span_red("SYSTEM ALERT: Structural damage inflicted by energy pulse!"))
					last_message = world.time
				M.adjustBruteLoss(10)
				M.adjustFireLoss(10)
				M.updatehealth()
		return 1

#undef ROBO_HEAL
#undef ROBO_HARM
