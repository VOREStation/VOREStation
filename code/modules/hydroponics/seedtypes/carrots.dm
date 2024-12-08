/datum/seed/carrots
	name = PLANT_CARROT
	seed_name = PLANT_CARROT
	display_name = "carrots"
	kitchen_tag = PLANT_CARROT
	chems = list(REAGENT_ID_NUTRIMENT = list(1,20), REAGENT_ID_IMIDAZOLINE = list(3,5), REAGENT_ID_CARROTJUICE = list(10,20))

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
