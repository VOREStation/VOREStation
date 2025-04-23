/*
//////////////////////////////////////

Alopecia

	Noticable.
	Decreases resistance slightly.
	Reduces stage speed slightly.
	transmission.
	Intense Level.

BONUS
	Makes the mob lose hair.

//////////////////////////////////////
*/

/datum/symptom/shedding
	name = "Alopecia"
	desc = "The virus attacks hair follicles, making hair thin and brittle."
	stealth = 0
	resistance = 3
	stage_speed = 2
	transmission = 2
	level = 5
	severity = 0
	base_message_chance = 50
	symptom_delay_min = 45
	symptom_delay_max = 90

/datum/symptom/shedding/Activate(datum/disease/advance/A)
	if(!..())
		return
	if(ishuman(A.affected_mob))
		return
	var/mob/living/carbon/human/H = A.affected_mob
	var/obj/item/organ/external/head/head_organ = H.get_organ(BP_HEAD)
	if(!istype(head_organ))
		return
	to_chat(H, span_warning("[pick("Your scalp itches.", "Your skin feels flakey.")]"))

	switch(A.stage)
		if(3, 4)
			if(H.h_style != "Bald" && H.h_style != "Balding Hair")
				to_chat(H, span_warning("Your hair starts to fall out in clumps..."))
				addtimer(CALLBACK(src, PROC_REF(change_hair), H, null, "Balding Hair"), 5 SECONDS)
		if(5)
			if(H.h_style != "Shaved" && H.h_style != "Bald")
				to_chat(H, span_warning("Your hair starts to fall out in clumps..."))
				addtimer(CALLBACK(src, PROC_REF(change_hair), H, "Shaved", "Bald"), 5 SECONDS)
	return

/datum/symptom/shedding/proc/change_hair(var/mob/living/carbon/human/H, f_style, h_style)
	if(!H)
		return
	if(f_style)
		H.f_style = f_style
	if(h_style)
		H.h_style = h_style
	return
