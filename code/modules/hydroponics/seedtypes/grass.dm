/datum/seed/grass
	name = "grass"
	seed_name = "grass"
	display_name = "grass"
	kitchen_tag = "grass"
	mutants = list("carpet")
	chems = list(REAGENT_ID_NUTRIMENT = list(1,20))

/datum/seed/grass/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,2)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"grass")
	set_trait(TRAIT_PRODUCT_COLOUR,"#09FF00")
	set_trait(TRAIT_PLANT_COLOUR,"#07D900")
	set_trait(TRAIT_PLANT_ICON,"grass")
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/grass/carpet
	name = "carpet"
	seed_name = "carpet"
	display_name = "carpet"
	kitchen_tag = "carpet"
	mutants = null
	chems = list("liquidcarpet" = list(5,10))

/datum/seed/grass/carpet/New()
	..()
	set_trait(TRAIT_YIELD,7)
	set_trait(TRAIT_PRODUCT_ICON,"grass")
	set_trait(TRAIT_PRODUCT_COLOUR,"#9e2500")
	set_trait(TRAIT_PLANT_COLOUR,"#ee4401")
	set_trait(TRAIT_PLANT_ICON,"grass")
