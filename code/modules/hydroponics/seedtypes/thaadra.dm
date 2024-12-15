/datum/seed/thaadra
	name = PLANT_THAADRA
	seed_name = "thaa'dra"
	display_name = "thaa'dra lichen"
	kitchen_tag = PLANT_THAADRA
	chems = list(REAGENT_ID_FROSTOIL = list(1,5),REAGENT_ID_NUTRIMENT = list(1,5))

/datum/seed/thaadra/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"grass")
	set_trait(TRAIT_PLANT_COLOUR,"#ABC7D2")
	set_trait(TRAIT_ENDURANCE,10)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,9)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,5)
