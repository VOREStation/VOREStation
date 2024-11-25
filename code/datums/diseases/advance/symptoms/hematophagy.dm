/*
//////////////////////////////////////

Hematophagy

	Little bit hidden.
	Decreases resistance slightly.
	Decreases stage speed tremendously.
	Slightly increased transmittablity.
	Intense level.

BONUS
	The host must feed on BLOOD

//////////////////////////////////////
*/

/datum/symptom/hematophagy
	name = "Hematophagy"
	stealth = 1
	resistance = -1
	resistance = -4
	transmittable = 1
	level = 4

/datum/symptom/hematophagy/Start(datum/disease/advance/A)
	if(ishuman(A.affected_mob))
		var/mob/living/carbon/human/H = A.affected_mob

		H.species.organic_food_coeff = 0
		H.species.bloodsucker = TRUE

		add_verb(H, /mob/living/carbon/human/proc/bloodsuck)

/datum/symptom/hematophagy/End(datum/disease/advance/A)
	if(ishuman(A.affected_mob))
		var/mob/living/carbon/human/H = A.affected_mob

		H.species.organic_food_coeff = initial(H.species.organic_food_coeff)
		H.species.bloodsucker = initial(H.species.bloodsucker)

		remove_verb(H, /mob/living/carbon/human/proc/bloodsuck)
