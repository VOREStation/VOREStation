/*
//////////////////////////////////////

Anaerobic Resuscitation

	Extremely noticable.
	High resistance.
	Significant increase in stage speed.
	Massively reduced transmission.
	Fatal Level.

Bonus
	Deals brain damage over time.

//////////////////////////////////////
*/

/datum/symptom/anaerobic_resuscitation
	name = "Anaerobic Resuscitation"
	desc = "Causes brain cells to begin to perform anaerobic respiration, resulting in high but non-fatal levels of brain damage."
	stealth = -3
	resistance = 3
	stage_speed = 2
	transmission = -3
	level = 7
	severity = 4

	threshold_descs = list(
		"Resistance 10" = "Allows for brain damage to be fatal."
	)

	var/fatal = FALSE

/datum/symptom/anaerobic_resuscitation/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.resistance >= 10)
		fatal = TRUE

/datum/symptom/anaerobic_resuscitation/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/infectee = A.affected_mob
	if(!istype(infectee))
		return

	switch(A.stage)
		if(1)
			if(prob(1))
				to_chat(infectee, span_warning("You feel a slight headache."))
				check_and_deal_damage(infectee, 1)
		if(2)
			if(prob(1))
				to_chat(infectee, span_warning("Your head aches painfully and you feel lightheaded."))
				check_and_deal_damage(infectee, 1)
				infectee.Weaken(3)
		if(3)
			if(prob(1))
				to_chat(infectee, span_warning("Your hands go limp and your head feels fuzzy."))
				check_and_deal_damage(infectee, 2)
				infectee.drop_both_hands()
		if(4)
			if(prob(1))
				to_chat(infectee, span_warning("You feel disoriented and have trouble focusing."))
				infectee.Confuse(5)
				check_and_deal_damage(infectee, 3)

		if(5)
			if(prob(1))
				to_chat(infectee, span_warning("Your head feels numb and you feel dizzy."))
				infectee.Confuse(5)
				infectee.drop_both_hands()
				check_and_deal_damage(infectee, 4)
	check_and_deal_damage(0.01) //Minor brain damage over time.

///Proc that checks to see if dealing damage would put someone past thee 'death threshold' and either stops the damage or allows it to continue if it's fatal.
/datum/symptom/anaerobic_resuscitation/proc/check_and_deal_damage(mob/living/carbon/human/infectee, amount)
	var/obj/item/organ/internal/brain/sponge = infectee.internal_organs_by_name[O_BRAIN]
	if(!sponge) //no brain, don't continue.
		return
	if(!fatal && (sponge.damage + amount) >= sponge.max_damage * 0.95) //Allow us to get a LOT of damage, but never enough to die unless it's fatal.
		return
	infectee.adjustBrainLoss(amount)
