/datum/seed/onion
	name = "onion"
	seed_name = "onion"
	display_name = "onions"
	kitchen_tag = "onion"
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10))

/datum/seed/onion/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"onion")
	set_trait(TRAIT_PRODUCT_COLOUR,"#E0C367")
	set_trait(TRAIT_PLANT_ICON,"carrot")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
