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
			H.shapeshifter_set_colour("#05FF9B") //They can still change their color.