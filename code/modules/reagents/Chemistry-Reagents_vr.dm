/datum/reagent/advmutationtoxin
	name = "Advanced Mutation Toxin"
	id = "advmutationtoxin"
	description = "A corruptive toxin produced by slimes. Turns the subject of the chemical into a Promethean."
	reagent_state = LIQUID
	color = "#13BC5E"

/datum/reagent/advmutationtoxin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species.name != "Promethean")
			M << "<span class='danger'>Your flesh rapidly mutates!</span>"
			H.set_species("Promethean")
			H.verbs +=  /mob/living/carbon/human/proc/shapeshifter_select_shape
			H.verbs +=  /mob/living/carbon/human/proc/shapeshifter_select_colour
			H.verbs +=  /mob/living/carbon/human/proc/shapeshifter_select_hair
			H.verbs +=  /mob/living/carbon/human/proc/shapeshifter_select_gender
			H.verbs +=  /mob/living/carbon/human/proc/regenerate
			H.verbs +=  /mob/living/proc/set_size
			H.shapeshifter_set_colour("#05FF9B") //They can still change their color.

/datum/chemical_reaction/slime/sapphire_mutation
	name = "Slime Mutation Toxins"
	id = "slime_mutation_tox"
	result = "mutationtoxin"
	required_reagents = list("blood" = 5)
	result_amount = 30
	required = /obj/item/slime_extract/sapphire

/datum/reagent/nif_repair_nanites
	name = "Programmed Nanomachines"
	id = "nifrepairnanites"
	description = "A thick grey slurry of NIF repair nanomachines."
	taste_description = "metallic"
	reagent_state = LIQUID
	color = "#333333"
	scannable = 1

/datum/reagent/nif_repair_nanites/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.nif)
			var/obj/item/device/nif/nif = H.nif //L o c a l
			if(nif.stat == NIF_TEMPFAIL)
				nif.stat = NIF_INSTALLING
			nif.durability = min(nif.durability + removed, initial(nif.durability))
