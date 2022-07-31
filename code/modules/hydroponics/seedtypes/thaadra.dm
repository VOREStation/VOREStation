/datum/seed/thaadra
	name = "thaadra"
	seed_name = "thaa'dra"
	display_name = "thaa'dra lichen"
	kitchen_tag = "thaadra"
	chems = list("frostoil" = list(1,5),"nutriment" = list(1,5))

/datum/seed/thaadra/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"grass")
	set_trait(TRAIT_PLANT_COLOUR,"#ABC7D2")
	set_trait(TRAIT_ENDURANCE,10)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,9)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,5)
