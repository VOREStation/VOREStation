// Lettuce/varieties.
/datum/seed/lettuce
	name = PLANT_LETTUCE
	seed_name = PLANT_LETTUCE
	display_name = PLANT_LETTUCE
	kitchen_tag = PLANT_LETTUCE
	chems = list(REAGENT_ID_NUTRIMENT = list(1,15))

/datum/seed/lettuce/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,8)
	set_trait(TRAIT_PRODUCT_ICON,"lettuce")
	set_trait(TRAIT_PRODUCT_COLOUR,"#A8D0A7")
	set_trait(TRAIT_PLANT_COLOUR,"#6D9C6B")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 8)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.13)

/datum/seed/lettuce/ice
	name = PLANT_SIFLETTUCE
	seed_name = "glacial lettuce"
	display_name = "glacial lettuce"
	kitchen_tag = "icelettuce"
	chems = list(REAGENT_ID_NUTRIMENT = list(1,5), REAGENT_ID_PARACETAMOL = list(0,2))

/datum/seed/lettuce/ice/New()
	..()
	set_trait(TRAIT_ALTER_TEMP, -5)
	set_trait(TRAIT_PRODUCT_COLOUR,"#9ABCC9")
