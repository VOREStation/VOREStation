/datum/seed/vanilla
	name = "vanilla"
	seed_name = "vanilla"
	display_name = "vanilla"
	kitchen_tag = "vanilla"
	chems = list("nutriment" = list(1,10), "vanilla" = list(2,8), "sugar" = list(1, 4))

/datum/seed/vanilla/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_ICON,"chili")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B57EDC")
	set_trait(TRAIT_PLANT_COLOUR,"#6B8C5E")
	set_trait(TRAIT_PLANT_ICON,"bush5")
	set_trait(TRAIT_IDEAL_LIGHT, 8)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.3)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)
