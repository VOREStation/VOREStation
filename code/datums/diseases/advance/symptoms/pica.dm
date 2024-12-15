/*
//////////////////////////////////////

Pica

	Not noticable or unnoticable.
	Decreases resistance.
	Increases stage speed.
	Little transmittable.
	Low Level.

BONUS
	The host gains hunger for any kind of object.

//////////////////////////////////////
*/

/datum/symptom/pica
	name = "Pica"
	stealth = 0
	resistance = -2
	stage_speed = 3
	transmittable = 1
	level = 1
	severity = 0

/datum/symptom/pica/Start(datum/disease/advance/A)
	add_verb(A.affected_mob, /mob/living/proc/eat_trash)
	add_verb(A.affected_mob, /mob/living/proc/toggle_trash_catching)

/datum/symptom/pica/End(datum/disease/advance/A)
	remove_verb(A.affected_mob, /mob/living/proc/eat_trash)
	remove_verb(A.affected_mob, /mob/living/proc/toggle_trash_catching)

/datum/symptom/pica/Activate(datum/disease/advance/A)
	..()

	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/list/nearby = oview(5, A.affected_mob)
		to_chat(A.affected_mob, span_warning("You could go fo a bite of [pick(nearby)]..."))
	else if (prob(SYMPTOM_ACTIVATION_PROB))
		if(ishuman(A.affected_mob))
			var/mob/living/carbon/human/H = A.affected_mob
			var/list/item = H.get_equipped_items()
			to_chat(H, span_warning("[pick(item)] looks oddly [pick("delicious", "tasty", "scrumptious", "inviting")]..."))
		return
