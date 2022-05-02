//todo
/datum/artifact_effect/sleepy
	name = "sleepy"
	effect_color = "#a36fa1"

/datum/artifact_effect/sleepy/New()
	..()
	effect_type = pick(EFFECT_PSIONIC, EFFECT_ORGANIC)

/datum/artifact_effect/sleepy/DoEffectTouch(var/mob/toucher)
	if(toucher)
		var/weakness = GetAnomalySusceptibility(toucher)
		if(ishuman(toucher) && prob(weakness * 100))
			var/mob/living/human/H = toucher
			to_chat(H, pick("<font color='blue'>You feel like taking a nap.</font>","<font color='blue'> You feel a yawn coming on.</font>","<font color='blue'> You feel a little tired.</font>"))
			H.drowsyness = min(H.drowsyness + rand(5,25) * weakness, 50 * weakness)
			H.eye_blurry = min(H.eye_blurry + rand(1,3) * weakness, 50 * weakness)
			return 1
		else if(isrobot(toucher))
			to_chat(toucher, "<font color='red'>SYSTEM ALERT: CPU cycles slowing down.</font>")
			return 1

/datum/artifact_effect/sleepy/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for (var/mob/living/human/H in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(H)
			if(prob(weakness * 100))
				if(prob(10))
					to_chat(H, pick("<font color='blue'>You feel like taking a nap.</font>","<font color='blue'> You feel a yawn coming on.</font>","<font color='blue'> You feel a little tired.</font>"))
				H.drowsyness = min(H.drowsyness + 1 * weakness, 25 * weakness)
				H.eye_blurry = min(H.eye_blurry + 1 * weakness, 25 * weakness)
		for (var/mob/living/silicon/robot/R in range(src.effectrange,holder))
			to_chat(R, "<font color='red'>SYSTEM ALERT: CPU cycles slowing down.</font>")
		return 1

/datum/artifact_effect/sleepy/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/human/H in range(src.effectrange, T))
			var/weakness = GetAnomalySusceptibility(H)
			if(prob(weakness * 100))
				to_chat(H, pick("<font color='blue'>You feel like taking a nap.</font>","<font color='blue'> You feel a yawn coming on.</font>","<font color='blue'> You feel a little tired.</font>"))
				H.drowsyness = min(H.drowsyness + rand(5,15) * weakness, 50 * weakness)
				H.eye_blurry = min(H.eye_blurry + rand(5,15) * weakness, 50 * weakness)
		for (var/mob/living/silicon/robot/R in range(src.effectrange,holder))
			to_chat(R, "<font color='red'>SYSTEM ALERT: CPU cycles slowing down.</font>")
		return 1
