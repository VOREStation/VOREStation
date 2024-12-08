/datum/seed/whitebeets
	name = PLANT_WHITEBEET
	seed_name = "white-beet"
	display_name = "white-beets"
	kitchen_tag = PLANT_WHITEBEET
	chems = list(REAGENT_ID_NUTRIMENT = list(0,20), REAGENT_ID_SUGAR = list(1,5))

/datum/seed/whitebeets/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"carrot2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#EEF5B0")
	set_trait(TRAIT_PLANT_COLOUR,"#4D8F53")
	set_trait(TRAIT_PLANT_ICON,"carrot2")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
