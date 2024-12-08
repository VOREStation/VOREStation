/datum/seed/potato
	name = PLANT_POTATO
	seed_name = PLANT_POTATO
	display_name = "potatoes"
	kitchen_tag = PLANT_POTATO
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10), REAGENT_ID_POTATOJUICE = list(10,10))

/datum/seed/potato/New()
	..()
	set_trait(TRAIT_PRODUCES_POWER,1)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"potato")
	set_trait(TRAIT_PRODUCT_COLOUR,"#D4CAB4")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
