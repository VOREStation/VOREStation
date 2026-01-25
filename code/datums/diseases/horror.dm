/datum/disease/fleshy_spread
	name = "Vastantes Carnes"
	medical_name = "Idiopathic Cellular Infestation"
	form = "Unknown Disease"
	max_stages = 5
	spread_text = "UNKNOWN BIOLOGICAL AGENT"
	spread_flags = DISEASE_SPREAD_BLOOD
	virus_modifiers = BYPASSES_IMMUNITY | SPREAD_DEAD
	cure_text = REAGENT_ID_HOLYWATER
	cures = list(REAGENT_ID_HOLYWATER)
	agent = "Infectious Cellular Growth"
	viable_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/human/monkey)
	desc = "Unknown infection only known to be present in specific regions of space. \
	The host's cells are slowly rewritten and replaced. Unknown effects if left untreated."
	danger = DISEASE_BIOHAZARD
	disease_flags = CAN_NOT_POPULATE
	stage_prob = 1

/datum/disease/fleshy_spread/stage_act()
	if(!..())
		return FALSE
	var/mob/living/carbon/human/infected = affected_mob
	switch(stage)
		if(2)
			if(prob(2))
				to_chat(infected, span_danger(pick("You feel a strange tingling under your skin", "Your flesh feels tingly", "You feel as if your blood vessels are crawling", "You see a tendril slithering across your eye.")))
				if(infected.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(infected)
			else if(prob(1))
				infected.visible_message(span_cult("The skin of [infected] shifts, as if something is moving within."))
			else if(prob(1))
				to_chat(infected, span_danger("You feel as though something is trying to displace your consciousness"))
				infected.AdjustConfused(5)

		if(3)
			if(prob(2))
				to_chat(infected, span_danger(pick("You feel warmth spreading throughout your body.", "You feel as if your body is burning up.", "Your skin feels like it's trying to pull away from your body.")))
				if(infected.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
					fever(infected)
			else if(prob(1))
				infected.visible_message(span_cult("The flesh of [infected] bulges and shifts unnaturally, a weeping sore appearing on [infected.p_their()] skin."))
				infected.adjustBruteLossByPart(2, BP_HEAD, "Fleshy Rupture")
				infected.drip(1)
			else if(prob(1))
				to_chat(infected, span_danger("You hear whispers speaking to you in the back of your mind, your throat closing up."))
				infected.emote("gasp")
				infected.AdjustConfused(10)
				infected.silent = max(10, infected.silent)
		if(4)
			if(!infected.has_modifier_of_type(/datum/modifier/redspace_drain))
				infected.add_modifier(/datum/modifier/redspace_drain/lesser)
			var/datum/modifier/redspace_drain/drain_modifier = infected.get_modifier_of_type(/datum/modifier/redspace_drain/lesser)
			if(drain_modifier && prob(5))
				drain_modifier.choose_organs(1)
		if(5)
			//You waited WAY too long to get this cured. You're permanently infected now. Technically, this means you're now 'infectious'
			if(infected.mind?.assigned_role == JOB_CHAPLAIN)
				to_chat(infected, span_cult("An alien presence attempts to prod at your mind, but your faith shields you from its full effects, purging the corruption."))
				cure()
				return
			if(infected.species.flags & NO_SLEEVE)
				to_chat(infected, span_cult("An alien presence attempts to prod at your mind, but at the final hour the effects of the corruption subsides."))
				cure()
				return
			if(!infected.has_modifier_of_type(/datum/modifier/redspace_corruption))
				infected.add_modifier(/datum/modifier/redspace_corruption)
				to_chat(infected, span_cult("You feel something latch into your mind, something melding with every fiber of your being."))
				to_chat(infected, span_cult("Every one of your cells scream out in agony as they're individually overtaken by a foreign entity."))
				to_chat(infected, span_cult("Your body feels foreign, like you're an invader in another's body."))
				to_chat(infected, span_cult("In the back of your mind, you can hear a voice reaching out to you, pleading for you to come back. To come and never leave."))
			cure()

		else
			return

/datum/disease/fleshy_spread/cure()
	var/mob/living/carbon/human/infected = affected_mob
	if(infected.has_modifier_of_type(/datum/modifier/redspace_drain/lesser))
		infected.remove_modifiers_of_type(/datum/modifier/redspace_drain/lesser)
	..()

/datum/disease/fleshy_spread/proc/fever(var/mob/living/M)
	M.bodytemperature = min(M.bodytemperature + (2 * stage), BODYTEMP_HEAT_DAMAGE_LIMIT - 1)
	return TRUE
