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
	Should be used for buffing your disease.

//////////////////////////////////////
*/

/datum/symptom/spyndrome
	name = "Spyndrome"
	stealth = 2
	resistance = 0
	stage_speed = 3
	transmittable = 1
	level = 1
	severity = 1
	var/list/directions = list(2,4,1,8,2,4,1,8,2,4,1,8,2,4,1,8,2,4,1,8)

/datum/symptom/spyndrome/Activate(var/datum/disease/advance/A)
	..()

	if(prob(SYMPTOM_ACTIVATION_PROB))
		if(A.affected_mob.buckled())
			to_chat(viewers(A.affected_mob), span_warning("[A.affected_mob.name] struggles violently against their restraints!"))
		else
			to_chat(viewers(A.affected_mob), span_warning("[A.affected_mob.name] spins around violently!"))
			for(var/D in directions)
				A.affected_mob.dir = D
			A.affected_mob.dir = pick(2,4,1,8)
	return
