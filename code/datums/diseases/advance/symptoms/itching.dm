/*
//////////////////////////////////////

Itching

	Not noticable or unnoticable.
	Resistant.
	Increases stage speed.
	Little transmittable.
	Low Level.

BONUS
	Displays an annoying message.

//////////////////////////////////////
*/

/datum/symptom/itching
	name = "Itching"
	desc = "The virus irritates the skin, causing itching."
	stealth = 0
	resistance = 3
	stage_speed = 3
	transmission = 1
	level = 1
	severity = 0
	symptom_delay_min = 15 SECONDS
	symptom_delay_max = 35 SECONDS

	var/scratch = FALSE

	threshold_descs = list(
		"Transmission 6" = "Increases frequency of itching.",
		"Stage Speed 7" = "The host will scratch itself when itchin, causing superficial damage."
	)

/datum/symptom/itching/Start(datum/disease/advance/A)
	if(!..())
		return
	if(A.transmission >= 6)
		symptom_delay_min = 5 SECONDS
		symptom_delay_max = 10 SECONDS
	if(A.stage >= 7)
		scratch = TRUE

/datum/symptom/itching/Activate(datum/disease/advance/A)
	if(!..())
		return

	var/mob/living/carbon/M = A.affected_mob
	if(M.stat >= DEAD)
		return
	var/picked_bodypart = pick(BP_HEAD, BP_TORSO, BP_R_ARM, BP_L_ARM, BP_R_LEG, BP_L_LEG)
	var/obj/item/organ/bodypart = M.get_organ(picked_bodypart)
	var/can_scratch = scratch && !M.incapacitated()
	if(bodypart && !bodypart.robotic)
		M.visible_message("[can_scratch ? span_warning("[M] scratches their [bodypart.name].") : ""]", span_notice("Your [bodypart.name] itches. [can_scratch ? " You scratch it." : ""]"))
		if(can_scratch)
			bodypart.take_damage(0.5)
