//pineapple and variants

/datum/seed/pineapple
	name = PLANT_PINEAPPLE
	seed_name = PLANT_PINEAPPLE
	display_name = PLANT_PINEAPPLE
	kitchen_tag = PLANT_PINEAPPLE
	mutants = list(PLANT_SPINEAPPLE)
	chems = list(REAGENT_ID_NUTRIMENT = list(1,5), REAGENT_ID_PINEAPPLEJUICE = list(1, 20))

/datum/seed/pineapple/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_POTENCY,13)
	set_trait(TRAIT_PRODUCT_ICON,"pineapple")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFF23B")
	set_trait(TRAIT_PLANT_COLOUR,"#87C969")
	set_trait(TRAIT_PLANT_ICON,"corn")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 4)
	set_trait(TRAIT_WATER_CONSUMPTION, 8)

//A pineapple that stings and produces enzymes.

/datum/seed/spineapple
	name = PLANT_SPINEAPPLE
	seed_name = PLANT_SPINEAPPLE
	display_name = PLANT_SPINEAPPLE
	kitchen_tag = PLANT_SPINEAPPLE
	chems = list(REAGENT_ID_NUTRIMENT = list(1,5), REAGENT_ID_ENZYME = list(1,5), REAGENT_ID_PINEAPPLEJUICE = list(1, 20))

/datum/seed/spineapple/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_POTENCY,13)
	set_trait(TRAIT_PRODUCT_ICON,"pineapple")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFF23B")
	set_trait(TRAIT_PLANT_COLOUR,"#87C969")
	set_trait(TRAIT_PLANT_ICON,"corn")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 4)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_STINGS,1)
