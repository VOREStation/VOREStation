/datum/disease/cold9
	name = "The Cold"
	medical_name = "ICE9 Cold"
	max_stages = 3
	spread_text = "On contact"
	spread_flags = CONTACT_GENERAL
	cure_text = "Spaceacillin"
	cures = list("spaceacillin")
	agent = "ICE9-rhinovirus"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "If left untreated the subject will slow, as if partly frozen."
	severity = HARMFUL

/datum/disease/cold9/stage_act()
	if(!..())
		return FALSE
	if(stage < 2)
		return

	var/stage_factor = stage - 1
	affected_mob.bodytemperature -= 7.5 * stage_factor
	if(prob(2 * stage_factor))
		affected_mob.say("*sneeze")
	if(prob(2 * stage_factor))
		affected_mob.say("*cough")
	if(prob(3 * stage_factor))
		to_chat(affected_mob, span_danger("Your throat feels sore."))
	if(prob(5 * stage_factor))
		to_chat(affected_mob, span_danger("You feel stiff."))
		affected_mob.adjustFireLoss(1)
