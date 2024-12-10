/datum/seed/kudzu
	name = PLANT_KUDZU
	seed_name = PLANT_KUDZU
	display_name = "kudzu vines"
	kitchen_tag = PLANT_KUDZU
	chems = list(REAGENT_ID_NUTRIMENT = list(1,50), REAGENT_ID_ANTITOXIN = list(1,25))

/datum/seed/kudzu/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_SPREAD,2)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#96D278")
	set_trait(TRAIT_PLANT_COLOUR,"#6F7A63")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)
