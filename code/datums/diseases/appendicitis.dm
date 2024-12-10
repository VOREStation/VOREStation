/datum/disease/appendicitis
	form = "Condition"
	name = "Appendicitis"
	max_stages = 3
	spread_text = "Non-contagius"
	spread_flags = NON_CONTAGIOUS
	cure_text = "Surgery"
	agent = "Shitty Appendix"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "If left untreated the subject will become very weak, and may vomit often."
	severity = MINOR
	disease_flags = CAN_CARRY|CAN_RESIST
	visibility_flags = HIDDEN_PANDEMIC
	required_organs = list(/obj/item/organ/internal/appendix)
	bypasses_immunity = TRUE
	virus_heal_resistant = TRUE

/datum/disease/appendicitis/stage_act()
	if(!..())
		return
	switch(stage)
		if(1)
			if(prob(5))
				affected_mob.adjustToxLoss(1)
		if(2)
			var/obj/item/organ/internal/appendix/A = affected_mob.internal_organs_by_name[O_APPENDIX]
			if(A)
				A.inflamed = TRUE
			if(prob(3))
				to_chat(affected_mob, span_warning("You feel a stabbing pain in your abdomen!"))
				affected_mob.custom_emote(VISIBLE_MESSAGE, "winces painfully.")
				affected_mob.Stun(rand(4, 6))
				affected_mob.adjustToxLoss(1)
		if(3)
			if(prob(1))
				to_chat(affected_mob, span_danger("Your abdomen is a world of pain!"))
				affected_mob.custom_emote(VISIBLE_MESSAGE, "winces painfully.")
				affected_mob.Weaken(10)
			if(prob(1))
				affected_mob.vomit(95)
			if(prob(5))
				to_chat(affected_mob, span_warning("You feel a stabbing pain in your abdomen!"))
				affected_mob.custom_emote(VISIBLE_MESSAGE, "winces painfully.")
				affected_mob.Stun(rand(4, 6))
				affected_mob.adjustToxLoss(2)
