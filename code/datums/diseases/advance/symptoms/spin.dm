/*
//////////////////////////////////////

Spyndrome

	Slightly hidden.
	No change to resistance.
	Increases stage speed.
	Little transmittable.
	Low Level.

BONUS
	Makes the host spin.

//////////////////////////////////////
*/

/datum/symptom/spyndrome
	name = "Spyndrome"
	stealth = 2
	resistance = 0
	stage_speed = 3
	transmittable = 1
	level = 1
	severity = 0

/datum/symptom/spyndrome/Activate(var/datum/disease/advance/A)
	..()

	if(prob(SYMPTOM_ACTIVATION_PROB))
		if(A.affected_mob.buckled())
			to_chat(viewers(A.affected_mob), span_warning("[A.affected_mob.name] struggles violently against their restraints!"))
		else
			to_chat(viewers(A.affected_mob), span_warning("[A.affected_mob.name] spins around violently!"))
			A.affected_mob.emote("spin")
	return
