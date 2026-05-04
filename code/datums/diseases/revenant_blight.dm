/datum/disease/revblight
	name = "Unnatural Wasting"
	medical_name = "Chameleonic Acute Depression"
	desc = "A strange condition which causes the victim to feel as if they were wasting away, despite being otherwise (almost) perfectly healthy."
	form = "Condition"
	max_stages = 5
	stage_prob = 5
	spread_flags = DISEASE_SPREAD_NON_CONTAGIOUS
	cure_text = REAGENT_HOLYWATER + " or rest"
	spread_text = "None"
	cures = list(REAGENT_ID_HOLYWATER)
	cure_chance = 30
	agent = "Unholy Forces"
	viable_mobtypes = list(/mob/living/carbon/human)
	disease_flags = CURABLE | CAN_NOT_POPULATE
	permeability_mod = 1
	danger = DISEASE_HARMFUL
	var/stagedamage = 0
	var/finalstage = 0
	var/list/original_hair_colour

/datum/disease/revblight/cure(add_resistance = FALSE)
	if(affected_mob)
		affected_mob.remove_atom_colour(TEMPORARY_COLOUR_PRIORITY, "#1d2953")
		if(original_hair_colour)
			var/mob/living/carbon/human/human = affected_mob
			human.change_hair_color(original_hair_colour[1], original_hair_colour[2], original_hair_colour[3])
		to_chat(affected_mob, span_notice("You feel better"))
	..()

/datum/disease/revblight/stage_act(seconds_per_tick)
	. = ..()
	if(!.)
		return

	if(!finalstage)
		if(affected_mob.lying && SPT_PROB(3 * stage, seconds_per_tick))
			cure()
			return FALSE
		if(SPT_PROB(1.5 * stage, seconds_per_tick))
			to_chat(affected_mob, span_danger("You suddenly feel [pick("sick and tired", "disoriented", "tired and confused", "nauseated", "faint", "dizzy")]..."))
			affected_mob.Confuse(10)
			new /obj/effect/temp_visual/revenant(affected_mob.loc)
		if(stagedamage < stage)
			stagedamage++
			affected_mob.adjustToxLoss(1 * stage * seconds_per_tick)
			new /obj/effect/temp_visual/revenant(affected_mob.loc)

	switch(stage)
		if(2)
			if(prob(5))
				affected_mob.emote("pale")
		if(3)
			if(prob(10))
				affected_mob.emote(pick("pale", "shiver"))
		if(4)
			if(prob(15))
				affected_mob.emote(pick("pale", "shiver", "cry"))
		if(5)
			if(!finalstage)
				finalstage = TRUE
				to_chat(affected_mob, span_danger("You feel like [pick("nothing's worth it anymore", "nobody ever needed your help", "nothing you did mattered", "everything you did was worthless.")]."))
				new /obj/effect/temp_visual/revenant(affected_mob.loc)
				if(ishuman(affected_mob))
					var/mob/living/carbon/human/human = affected_mob
					original_hair_colour = list(human.r_hair, human.g_hair, human.b_hair)
					human.change_hair_color(255, 255, 255)
				affected_mob.visible_message(span_warning("[affected_mob] looks terrifyingly gaunt..."), span_danger("You suddenly feel like your skin is <i>wrong</i>..."))
				affected_mob.add_atom_colour("#1d2953", TEMPORARY_COLOUR_PRIORITY)
				addtimer(CALLBACK(src, PROC_REF(cure)), 10 SECONDS)
