/*
//////////////////////////////////////

Bone Dysplasia

	Normal stealth.
	Slightly decreased resistance.
	Normal stage speed.
	Normal stage speed.
	Moderate Level.

Bonus
	Causes the host to form denser bones at max stage.
	If at max stage and cured, all of the host's bones break

//////////////////////////////////////
*/

/datum/symptom/bone_dysplasia
	name = "Bone Dysplasia"
	desc = "Causes rapid bone growth, resulting in increased bone density at maximum stage. If cured, will result in spontaneous "
	stealth = 0
	resistance = -1
	stage_speed = 0
	transmission = 0
	level = 3
	severity = 1

	var/triggered = FALSE

/datum/symptom/bone_dysplasia/Start(datum/disease/advance/A)
	if(!..())
		return

/datum/symptom/bone_dysplasia/End(datum/disease/advance/A)
	. = ..()
	var/mob/living/carbon/human/infectee = A.affected_mob
	if(infectee && . && triggered)
		for(var/obj/item/organ/external/organ in infectee.organs)
			if(organ.cannot_break)
				continue
			organ.min_broken_damage = initial(organ.min_broken_damage)
			organ.fracture()
			organ.take_damage(rand(3,5), sharp = TRUE, used_weapon = "Spontaneous Bone Rupture")
			infectee.adjustHalLoss(25) //that HURTS
		to_chat(infectee, span_huge(span_danger("You feel every bone in your body rupture all at once!")))

/datum/symptom/bone_dysplasia/Activate(var/datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/infectee = A.affected_mob
	if(!istype(infectee))
		return
	if(A.stage < 5)
		return
	if(!triggered)
		triggered = TRUE
		to_chat(infectee, span_notice("You feel a strange sensation in your bones as they harden and thicken."))
		for(var/obj/item/organ/external/organ in infectee.organs)
			if(organ.cannot_break)
				continue
			organ.min_broken_damage *= 1.5
