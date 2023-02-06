/datum/seed/qlort
	name = "qlort"
	seed_name = "q'lort bulb"
	display_name = "q'lort"
	mutants = null
	chems = list("nutriment" = list(3, 5))
	kitchen_tag = "qlort"

/datum/seed/qlort/New()
	..()
	set_trait(TRAIT_MATURATION, 10)
	set_trait(TRAIT_PRODUCTION, 1)
	set_trait(TRAIT_YIELD, 5)
	set_trait(TRAIT_POTENCY, 10)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom9")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B1E4BE")
	set_trait(TRAIT_FLESH_COLOUR, "#9FE4B0")
	set_trait(TRAIT_PLANT_ICON,"mushroom9")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)