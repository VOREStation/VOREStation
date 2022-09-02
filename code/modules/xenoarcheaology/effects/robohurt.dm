/datum/artifact_effect/robohurt
	name = "robotic harm"
	effect_color = "#5432cf"
	var/last_message


/datum/artifact_effect/robohurt/New()
	..()
	effect_type = pick(EFFECT_ELECTRO, EFFECT_PARTICLE)


/datum/artifact_effect/robohurt/DoEffectTouch(mob/living/user)
	if (user)
		if (istype(user, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = user
			to_chat(R, "<font color='red'>Your systems report severe damage has been inflicted!</font>")
			R.adjustBruteLoss(rand(10,50))
			R.adjustFireLoss(rand(10,50))


/datum/artifact_effect/robohurt/DoEffectAura()
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/silicon/robot/M in range(src.effectrange,T))
			if (world.time - last_message > 200)
				to_chat(M, "<font color='red'>SYSTEM ALERT: Harmful energy field detected!</font>")
				last_message = world.time
			M.adjustBruteLoss(1)
			M.adjustFireLoss(1)
			M.updatehealth()


/datum/artifact_effect/robohurt/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if (holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/silicon/robot/M in range(src.effectrange,T))
			if (world.time - last_message > 200)
				to_chat(M, "<font color='red'>SYSTEM ALERT: Structural damage inflicted by energy pulse!</font>")
				last_message = world.time
			M.adjustBruteLoss(10)
			M.adjustFireLoss(10)
			M.updatehealth()
