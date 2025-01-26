/datum/artifact_effect/dnaswitch
	name = "dnaswitch"
	effect_type = EFFECT_ORGANIC
	var/severity

	effect_state = "smoke"
	effect_color = "#77ff83"

/datum/artifact_effect/dnaswitch/New()
	..()
	if(effect == EFFECT_AURA)
		severity = rand(5,30)
	else
		severity = rand(25,95)

/datum/artifact_effect/dnaswitch/DoEffectTouch(var/mob/toucher)
	var/weakness = GetAnomalySusceptibility(toucher)
	if(ishuman(toucher) && prob(weakness * 100))
		to_chat(toucher,pick(span_green("You feel a little different."),
		span_green("You feel very strange."),
		span_green("Your stomach churns."),
		span_green("Your skin feels loose."),
		span_green("You feel a stabbing pain in your head."),
		span_green("You feel a tingling sensation in your chest."),
		span_green("Your entire body vibrates.")))
		if(prob(75))
			scramble(1, toucher, weakness * severity)
		else
			scramble(0, toucher, weakness * severity)
	return 1

/datum/artifact_effect/dnaswitch/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/human/H in range(src.effectrange,T))
			var/weakness = GetAnomalySusceptibility(H)
			if(prob(weakness * 100))
				if(prob(30))
					to_chat(H, pick(span_green("You feel a little different."),
					span_green("You feel very strange."),
					span_green("Your stomach churns."),
					span_green("Your skin feels loose."),
					span_green("You feel a stabbing pain in your head."),
					span_green("You feel a tingling sensation in your chest."),
					span_green("Your entire body vibrates.")))
				if(prob(50))
					scramble(1, H, weakness * severity)
				else
					scramble(0, H, weakness * severity)

/datum/artifact_effect/dnaswitch/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(holder)
		var/turf/T = get_turf(holder)
		for(var/mob/living/carbon/human/H in range(200, T))
			var/weakness = GetAnomalySusceptibility(H)
			if(prob(weakness * 100))
				if(prob(75))
					to_chat(H, pick(span_green(" You feel a little different."),
					span_green(" You feel very strange."),
					span_green(" Your stomach churns."),
					span_green(" Your skin feels loose."),
					span_green(" You feel a stabbing pain in your head."),
					span_green(" You feel a tingling sensation in your chest."),
					span_green(" Your entire body vibrates.")))
				if(prob(25))
					if(prob(75))
						scramble(1, H, weakness * severity)
					else
						scramble(0, H, weakness * severity)
