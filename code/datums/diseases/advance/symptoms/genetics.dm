/datum/symptom/genetic
	name = "Basic Genetic Symptom (does nothing)"
	stealth = 0
	resistance = 0
	stage_speed = 0
	transmission = 0
	level = -1
	base_message_chance = 20
	symptom_delay_min = 1
	symptom_delay_max = 1
	var/datum/gene/trait/mutation
	var/passive_message
	var/preset = FALSE

/datum/symptom/genetic/Start(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/H = A.affected_mob
	if(mutation)
		preset = H.dna.GetSEState(mutation.block)

/datum/symptom/genetic/OnAdd(datum/disease/advance/A)
	. = ..()
	if(mutation && !preset)
		var/mob/living/carbon/human/H = A.affected_mob
		H.dna.SetSEState(mutation.block, TRUE)
		domutcheck(H, null, TRUE)
		H.UpdateAppearance()

/datum/symptom/genetic/OnRemove(datum/disease/advance/A)
	. = ..()
	if(mutation && !preset)
		var/mob/living/carbon/human/H = A.affected_mob
		H.dna.SetSEState(mutation.block, FALSE)
		domutcheck(H, null, TRUE)
		H.UpdateAppearance()

/datum/symptom/genetic/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/carbon/human/H = A.affected_mob
	switch(A.stage)
		if(4, 5)
			if(passive_message && prob(2))
				to_chat(H, passive_message)

/*
//////////////////////////////////////

Telepathy

	Hidden.
	Decreases resistance.
	Decreases stage speed significantly.
	Decreases transmittablity tremendously.
	Critical Level.

Bonus
	The user gains telepathy.

//////////////////////////////////////
*/

/datum/symptom/genetic/telepathy
	name = "Pineal Gland Decalcification"
	stealth = 2
	resistance = -2
	stage_speed = -3
	transmission = -4
	level = 5
	severity = 0

/datum/symptom/genetic/telepathy/New()
	. = ..()
	mutation = get_gene_from_trait(/datum/trait/positive/superpower_remotetalk)

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

/datum/symptom/genetic/hematophagy
	name = "Hematophagy"
	stealth = 1
	resistance = -1
	resistance = -4
	transmission = 1
	severity = 1

/datum/symptom/genetic/hematophagy/New()
	. = ..()
	mutation = get_gene_from_trait(/datum/trait/positive/superpower_remotetalk)

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

/datum/symptom/genetic/pica
	name = "Pica"
	stealth = 0
	resistance = -2
	stage_speed = 3
	transmission = 1
	level = 1
	severity = 0

/datum/symptom/genetic/pica/New()
	. = ..()
	mutation = get_gene_from_trait(/datum/trait/neutral/trashcan)
