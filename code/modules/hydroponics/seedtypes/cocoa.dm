/datum/seed/cocoa
	name = PLANT_COCOA
	seed_name = "cacao"
	display_name = "cacao tree"
	kitchen_tag = PLANT_COCOA
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10), REAGENT_ID_COCO = list(4,5))

/datum/seed/cocoa/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#CCA935")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
