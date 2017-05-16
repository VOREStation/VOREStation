/datum/reagent/adranol
	name = "Adranol"
	id = "adranol"
	description = "A mild sedative that calms the nerves and relaxes the patient."
	taste_description = "milk"
	reagent_state = SOLID
	color = "#d5e2e5"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/adranol/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	if(M.confused)
		M.Confuse(-8*removed)
	if(M.eye_blurry)
		M.eye_blurry = max(M.eye_blurry - 8*removed, 0)
	if(M.jitteriness)
		M.make_jittery(max(M.jitteriness - 8*removed,0))