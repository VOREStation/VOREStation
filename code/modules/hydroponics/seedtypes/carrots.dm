/datum/seed/carrots
	name = "carrot"
	seed_name = "carrot"
	display_name = "carrots"
	kitchen_tag = "carrot"
	chems = list(REAGENT_ID_NUTRIMENT = list(1,20), REAGENT_ID_IMIDAZOLINE = list(3,5), "carrotjuice" = list(10,20))

/datum/seed/carrots/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"carrot")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFDB4A")
	set_trait(TRAIT_PLANT_ICON,"carrot")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
