/mob/living/carbon/human/proc/weightgain()
	if (nutrition >= 0 && stat != 2)
		if (nutrition > MIN_NUTRITION_TO_GAIN && weight < MAX_MOB_WEIGHT && weight_gain)
			weight += species.metabolism*(0.01*weight_gain)

		else if (nutrition <= MAX_NUTRITION_TO_LOSE && stat != 2 && weight > MIN_MOB_WEIGHT && weight_loss)
			weight -= species.metabolism*(0.01*weight_loss) // starvation weight loss

/mob/living/carbon/human/proc/process_weaver_silk()
	if(!species || !(species.is_weaver))
		return

	if(species.silk_reserve < species.silk_max_reserve && species.silk_production == TRUE && nutrition > 100)
		species.silk_reserve = min(species.silk_reserve + 2, species.silk_max_reserve)
		adjust_nutrition(-0.4)

//Our call for the NIF to do whatever
/mob/living/carbon/human/proc/handle_nif()
	if(!nif) return

	//Process regular life stuff
	nif.life()

//Overriding carbon move proc that forces default hunger factor
/mob/living/carbon/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()

	// Technically this does mean being dragged takes nutrition
	if(stat != DEAD)
		adjust_nutrition(hunger_rate/-10)
		if(m_intent == I_RUN)
			adjust_nutrition(hunger_rate/-10)

	// Moving around increases germ_level faster
	if(germ_level < GERM_LEVEL_MOVE_CAP && prob(8))
		germ_level++


/mob/living/carbon
	var/synth_cosmetic_pain = FALSE
