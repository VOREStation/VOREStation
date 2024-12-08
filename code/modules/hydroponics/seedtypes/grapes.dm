//Grapes/varieties
/datum/seed/grapes
	name = PLANT_GRAPES
	seed_name = "grape"
	display_name = "grapevines"
	kitchen_tag = PLANT_GRAPES
	mutants = list(PLANT_GREENGRAPES)
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10), REAGENT_ID_SUGAR = list(1,5), REAGENT_ID_GRAPEJUICE = list(10,10))

/datum/seed/grapes/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"grapes")
	set_trait(TRAIT_PRODUCT_COLOUR,"#BB6AC4")
	set_trait(TRAIT_PLANT_COLOUR,"#378F2E")
	set_trait(TRAIT_PLANT_ICON,"vine")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/grapes/green
	name = PLANT_GREENGRAPES
	seed_name = "green grape"
	display_name = "green grapevines"
	mutants = null
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10), REAGENT_ID_KELOTANE = list(3,5), REAGENT_ID_GRAPEJUICE = list(10,10))

/datum/seed/grapes/green/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"42ed2f")
