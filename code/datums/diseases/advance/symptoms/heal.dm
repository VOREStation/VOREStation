/datum/symptom/heal
	name = "Basic Healing (does nothing)"
	stealth = 0
	resistance = 0
	stage_speed = 0
	transmission = 0
	level = -1
	base_message_chance = 20
	symptom_delay_min = 1
	symptom_delay_max = 1
	var/passive_message = ""
	threshold_descs = list(
		"Stealth 4" = "Healing will no longer be visible to onlookers."
	)

/datum/symptom/heal/Start(datum/disease/advance/A)
	if(!..())
		return FALSE
	return TRUE

/datum/symptom/heal/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob
	switch(A.stage)
		if(4, 5)
			var/effectiveness = CanHeal(A)
			if(!effectiveness)
				if(passive_message && prob(2) && passive_message_condition(M))
					to_chat(M, passive_message)
				return
			else
				Heal(M, A, effectiveness)
	return

/datum/symptom/heal/proc/CanHeal(datum/disease/advance/A)
	return power

/datum/symptom/heal/proc/Heal(mob/living/M, /datum/disease/advance/A, actual_power = 1)
	return TRUE

/datum/symptom/heal/proc/passive_message_condition(mob/living/M)
	return TRUE

/datum/symptom/heal/chem
	name = "Toxolysis"
	desc = "The virus rapidly breaks down any foreign chemicals in the bloodstream."
	stealth = 0
	resistance = -2
	stage_speed = 2
	transmission = -2
	level = 6
	power = 2
	var/food_conversion = FALSE

	threshold_descs = list(
		"Resistance 7" = "Increases chem removal speed.",
		"Stage Speed 6" = "Consumed chemicals nourish the host."
	)

/datum/symptom/heal/chem/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stage >= 6)
		food_conversion = TRUE
	if(A.resistance >= 7)
		power = 4

/datum/symptom/heal/chem/Heal(mob/living/carbon/human/H, datum/disease/advance/A, actual_power)
	for(var/datum/reagent/R in H.bloodstr.reagent_list)
		H.reagents.remove_reagent(R.type, actual_power)
		if(food_conversion)
			H.adjust_nutrition(2)
		if(prob(2) && H.stat != DEAD)
			to_chat(H, span_notice("You feel a mild warmth as your blood purifies itself."))


/datum/symptom/growth
	name = "Pituitary Disruption"
	desc = "Causes uncontrolled growth in the subject."
	stealth = -3
	resistance = -2
	stage_speed = 1
	transmission = -2
	level = 8
	severity = 1
	symptom_delay_min = 10 SECONDS
	symptom_delay_max = 20 SECONDS

	var/current_size = 1
	var/tetsuo = FALSE
	var/bruteheal = FALSE

	var/datum/mind/ownermind

	threshold_descs = list(
		"Stage Speed 6" = "The disease heals brute damage at a fast rate, but causes expulsion of benign tumors.",
		"Stage Speed 12" = "The disease heals brute damage incredibly fast, but deteriorates cell health and causes tumors to become more advanced. The disease will also regenerate lost limbs."
	)

/datum/symptom/growth/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stage_rate >= 6)
		bruteheal = TRUE
		if(A.stage_rate >= 12)
			tetsuo = TRUE
			power = 3

	var/mob/living/carbon/human/H = A.affected_mob
	ownermind = H.mind

/datum/symptom/growth/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/H = A.affected_mob
	switch(A.stage)
		if(4, 5)
			if(prob(5) && bruteheal)
				if(H.stat != DEAD)
					to_chat(H, span_userdanger("You retch, and a splatter of gore escapes your gullet!"))
					H.vomit(lost_nutrition = 0, blood = TRUE, stun = FALSE)
					// Spitting tumors go here! IF they get up-ported.
				if(tetsuo)
					var/list/missing = H.get_missing_limbs()
					if(prob(35) && H.mind && ishuman(H) && H.stat != DEAD)
						new /obj/effect/decal/cleanable/blood/gibs(H.loc)
					if(missing.len)
						for(var/Z in missing)
							if(H.regenerate_limb(Z, TRUE))
								playsound(H, 'sound/effects/blobattack.ogg', 50, 1)
								H.visible_message(span_warning("[H]'s missing limbs reform, making a loud, grotesque sound!"), span_userdanger("You limbs regrow, making a loud, crunchy sound and giving you great pain!"))
								H.emote("scream")
								if(Z == BP_HEAD)
									if(isliving(ownermind.current))
										var/mob/living/owner = ownermind.current
										if(owner.stat != DEAD)
											ownermind = null
											break
									ownermind.transfer_to(H)
									H.grab_ghost()
								break
			if(bruteheal)
				H.heal_overall_damage(2 * power)
				if(prob(33) && tetsuo)
					H.adjustCloneLoss(1)
		else
			if(prob(base_message_chance) && H.stat != DEAD)
				to_chat(H, span_notice(pick("You feel bloated.", "The station seems small.", "You are the strongest.")))
	return

/datum/symptom/heal/metabolism
	name = "Metabolic Boost"
	desc = "The virus causes the host's metabolism to accelerate rapidly, making them process chemicals twice as fast, but also causing increased hunger."
	stealth = -1
	resistance = -2
	stage_speed = 2
	transmission = 1
	level = 6
	var/triple_metabolism = FALSE
	var/reduced_hunger = FALSE

	threshold_descs = list(
		"Stealth 3" = "Reduces hunger rate.",
		"Stage Speed 10" = "Chemical metabolization is tripled instead of doubled."
	)

/datum/symptom/heal/metabolism/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.stage_rate >= 10)
		triple_metabolism = TRUE
	if(A.stealth >= 3)
		reduced_hunger = TRUE

/datum/symptom/heal/metabolism/Heal(mob/living/carbon/human/H, datum/disease/advance/A, actual_power)
	if(!istype(H))
		return
	if(H.ingested)
		H.ingested.metabolize()
	if(triple_metabolism)
		H.ingested.metabolize()
	var/lost_nutrition = 9 - (reduced_hunger * 5)
	H.adjust_nutrition(-lost_nutrition * 0.1)
	if(prob(2) && H.stat != DEAD)
		to_chat(H, span_notice("You feel an odd gurgle in your stomach, as if it was working much faster than normal."))
	return TRUE

/datum/symptom/heal/oxygen
	name = "Oxygenation"
	desc = "The virus causes the host's body to produce oxygen, allowing self-respiration."
	stealth = 1
	resistance = -3
	stage_speed = -3
	transmission = -4
	level = 8
	base_message_chance = 5
	symptom_delay_min = 5 SECONDS
	symptom_delay_max = 20 SECONDS
	var/regenerate_blood = FALSE

	threshold_descs = list(
		"Resistance 8" = "Additionally regenerates lost blood."
	)

/datum/symptom/heal/oxygen/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.resistance >= 8)
		regenerate_blood = TRUE

/datum/symptom/heal/oxygen/Heal(mob/living/carbon/human/H, datum/disease/advance/A, actual_power)
	if(!istype(H))
		return
	if(H.getOxyLoss() > 0)
		H.adjustOxyLoss(3 * power)
	if(regenerate_blood && H.vessel.get_reagent_amount(REAGENT_ID_BLOOD) < H.species.blood_volume)
		H.add_chemical_effect(CE_BLOODRESTORE, 1)


/*
//////////////////////////////////////

	DNA Restoration

	Not well hidden.
	Lowers resistance minorly.
	Does not affect stage speed.
	Decreases transmittablity greatly.
	Very high level.

Bonus
	Heals clone damage, treats radiation.

//////////////////////////////////////

/datum/symptom/heal/dna
	name = "Deoxyribonucleic Acid Restoration"
	stealth = -1
	resistance = -1
	stage_speed = 0
	transmission = -3
	level = 5
	severity = 0

/datum/symptom/heal/dna/Heal(var/mob/living/carbon/M, var/datum/disease/advance/A)
	var/amt_healed = max(0, (sqrtor0(20+A.stage_rate*(3+rand())))-(sqrtor0(16+A.stealth*rand())))
	M.adjustBrainLoss(-amt_healed)
	M.radiation = max(M.radiation - 3, 0)
	return TRUE
*/
