/datum/seed/rhubarb
	name = PLANT_RHUBARB
	seed_name = PLANT_RHUBARB
	display_name = PLANT_RHUBARB
	kitchen_tag = PLANT_RHUBARB
	chems = list(REAGENT_ID_NUTRIMENT = list(1,15))

/datum/seed/rhubarb/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,6)
	set_trait(TRAIT_PRODUCT_ICON,"stalk")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FD5656")
	set_trait(TRAIT_PLANT_ICON,"stalk3")
