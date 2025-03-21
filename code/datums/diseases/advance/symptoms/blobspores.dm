/*
//////////////////////////////////////
Blob Spores

	Slightly hidden
	Major Increases to resistance.
	Reduces stage speed.
	Slight boost to transmission
	Admin Level.

BONUS
	The host coughs up blob spores

//////////////////////////////////////
*/
/datum/symptom/blobspores
	name = "Blob Spores"
	desc = "This symptom causes the host to produce blob spores, which will leave the host at the later stages, and if the host dies, all of the spores will erupt from the host at the same time, while also producing a blob tile."
	stealth = 1
	resistance = 6
	stage_speed = -2
	transmission = 1
	level = 9
	severity = 3
	naturally_occuring = FALSE
	symptom_delay_min = 20 SECONDS
	symptom_delay_max = 40 SECONDS

	threshold_descs = list(
		"Resistance 8" = "Spawns a strong blob instead of a normal blob",
		"Resistance 11" = "There is a chance to spawn a factory blob, instead of a normal blob.",
		"Resistance 14" = "Has a chance to spawn a blob node instead of a normal blob"
	)

	var/ready_to_pop
	var/factory_blob
	var/strong_blob
	var/node_blob

/datum/symptom/blobspores/severityset(datum/disease/advance/A)
	. = ..()
	if(A.resistance >= 14)
		severity += 1

/datum/symptom/blobspores/Start(datum/disease/advance/A)
	if(!..())
		return

	if(A.resistance >= 11)
		factory_blob = TRUE
	if(A.resistance >= 8)
		strong_blob = TRUE
		if(A.resistance >= 14)
			node_blob = TRUE

/datum/symptom/blobspores/Activate(datum/disease/advance/A)
	if(!..())
		return
	var/mob/living/M = A.affected_mob

	switch(A.stage)
		if(1)
			to_chat(M, span_notice("You feel bloated."))

			if(!M.jitteriness)
				to_chat(M, span_notice("You feel a bit jittery."))
				M.jitteriness = 10

		if(2)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				H.vomit(TRUE, FALSE)
		if(3, 4)
			to_chat(M, span_notice("You feel blobby?"))

		if(5)
			M.audible_emote("coughs up a small amount of blood!")
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				var/bleeding_rng = rand(1, 2)
				H.drip(bleeding_rng)

/datum/symptom/blobspores/OnStageChange(datum/disease/advance/A)
	if(!..())
		return
	if(A.stage == 5)
		ready_to_pop = TRUE

/datum/symptom/blobspores/OnDeath(datum/disease/advance/A)
	if(neutered)
		return
	var/mob/living/M = A.affected_mob
	M.visible_message(span_danger("[M] starts swelling grotesquely!"))
	addtimer(CALLBACK(src, PROC_REF(pop), A, M), 10 SECONDS)

/datum/symptom/blobspores/proc/pop(datum/disease/advance/A, mob/living/M)
	if(!A || !M)
		return
	var/list/blob_options = list(/obj/structure/blob/normal)
	if(factory_blob)
		blob_options += /obj/structure/blob/factory
	if(strong_blob)
		blob_options += /obj/structure/blob/shield
	if(node_blob)
		blob_options += /obj/structure/blob/node
	var/pick_blob = pick(blob_options)
	if(ready_to_pop)
		for(var/i in 1 to rand(1, 6))
			new /mob/living/simple_mob/blob/spore(M.loc)
		new pick_blob(M.loc)

	M.visible_message(span_danger("A huge mass of blob and blob spores burst out of [M]!"))
