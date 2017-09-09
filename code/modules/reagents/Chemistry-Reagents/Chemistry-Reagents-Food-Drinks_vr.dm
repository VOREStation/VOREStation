/datum/reagent/nutriment
	nutriment_factor = 10

/datum/reagent/lipozine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.nutrition = max(M.nutrition - 20 * removed, 0)
	M.overeatduration = 0
	if(M.nutrition < 0)
		M.nutrition = 0

////////////// special drinks
/datum/reagent/drink/grubshake
	name = "Grub Protein Shake"
	id = "grubshake"
	description = "A thick brothy shake that tastes like primal insect protein, healthy!"
	taste_description = "meaty and sparkly on the tongue"
	color = "#ebf442"

	glass_name = "grub shake"
	glass_desc = "A brothy mess with grub bits floating in it."
