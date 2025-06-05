/datum/artifact_effect/dnaswitch
	name = "DNA Mutator"
	effect_type = EFFECT_DNASWITCH
	var/effect_strength //This is the % chance PER GENE to MUTATE IT.
	can_start_activated = FALSE

	effect_state = "smoke"
	effect_color = "#77ff83"

/datum/artifact_effect/dnaswitch/New()
	..()
	effect = pick(EFFECT_TOUCH, EFFECT_AURA, EFFECT_PULSE)
	if(effect == EFFECT_AURA) //Quite dangerous.
		effect_strength = rand(2,5)
	else if(effect == EFFECT_PULSE) //This only happens every 40 to 240 seconds.
		effect_strength = rand(1,10)
	else
		effect_strength = rand(10,20) //This one is SUPER beneficial to the geneticist, as they can mutate monkeys.

/datum/artifact_effect/dnaswitch/DoEffectTouch(var/mob/toucher)
	var/weakness = GetAnomalySusceptibility(toucher)
	if(ishuman(toucher) && prob(weakness * 100))
		if(prob(effect_strength))
			to_chat(toucher, span_notice(span_green("[pick(
			"You feel a little different.",
			"You feel very strange.",
			"Your stomach churns.",
			"Your skin feels loose.",
			"You feel a stabbing pain in your head.",
			"You feel a tingling sensation in your chest.",
			"Your entire body vibrates.")]")))
		scramble(1, toucher, weakness * effect_strength)
	return 1

/datum/artifact_effect/dnaswitch/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		holder = holder.loc
	if(isliving(holder.loc))
		holder = holder.loc
	if(holder)
		var/turf/T = get_turf(holder)
		if(isturf(T))
			for(var/mob/living/carbon/human/H in range(src.effectrange,T))
				var/weakness = GetAnomalySusceptibility(H)
				if(prob(weakness * 100))
					if(prob(effect_strength))
						to_chat(H, span_notice(span_green("[pick(
						"You feel a little different.",
						"You feel very strange.",
						"Your stomach churns.",
						"Your skin feels loose.",
						"You feel a stabbing pain in your head.",
						"You feel a tingling sensation in your chest.",
						"Your entire body vibrates.")]")))
					scramble(1, H, weakness * effect_strength)

/datum/artifact_effect/dnaswitch/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		holder = holder.loc
	if(isliving(holder.loc))
		holder = holder.loc
	if(holder)
		var/turf/T = get_turf(holder)
		if(isturf(T))
			for(var/mob/living/carbon/human/H in range(200, T))
				var/weakness = GetAnomalySusceptibility(H)
				if(prob(weakness * 100))
					if(prob(effect_strength))
						to_chat(H, span_notice(span_green("[pick(
						"You feel a little different.",
						"You feel very strange.",
						"Your stomach churns.",
						"Your skin feels loose.",
						"You feel a stabbing pain in your head.",
						"You feel a tingling sensation in your chest.",
						"Your entire body vibrates.")]")))
					if(prob(25))
						scramble(1, H, weakness * effect_strength)
