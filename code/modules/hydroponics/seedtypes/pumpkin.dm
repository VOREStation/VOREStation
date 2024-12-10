/datum/seed/pumpkin
	name = PLANT_PUMPKIN
	seed_name = PLANT_PUMPKIN
	display_name = "pumpkin vine"
	kitchen_tag = PLANT_PUMPKIN
	chems = list(REAGENT_ID_NUTRIMENT = list(1,6))

/datum/seed/pumpkin/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"vine2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#DBAC02")
	set_trait(TRAIT_PLANT_COLOUR,"#21661E")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
