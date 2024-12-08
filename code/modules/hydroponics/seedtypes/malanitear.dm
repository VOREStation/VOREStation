/datum/seed/mtear
	name = PLANT_MTEAR
	seed_name = "Malani's tear"
	display_name = "Malani's tear leaves"
	kitchen_tag = PLANT_MTEAR
	chems = list(REAGENT_ID_HONEY = list(1,10), REAGENT_ID_KELOTANE = list(3,5))

/datum/seed/mtear/New()
	..()
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"alien4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#4CC5C7")
	set_trait(TRAIT_PLANT_COLOUR,"#4CC789")
	set_trait(TRAIT_PLANT_ICON,"bush7")
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)
