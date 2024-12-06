//pineapple and variants

/datum/seed/pineapple
	name = "pineapple"
	seed_name = "pineapple"
	display_name = "pineapple"
	kitchen_tag = "pineapple"
	mutants = list("spineapple")
	chems = list(REAGENT_ID_NUTRIMENT = list(1,5), "pineapplejuice" = list(1, 20))

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
	name = "spineapple"
	seed_name = "spineapple"
	display_name = "spineapple"
	kitchen_tag = "spineapple"
	chems = list(REAGENT_ID_NUTRIMENT = list(1,5), "enzyme" = list(1,5), "pineapplejuice" = list(1, 20))

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
