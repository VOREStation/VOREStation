/datum/seed/eki
	name = "eki"
	seed_name = "eki"
	display_name = "eki"
	mutants = null
	chems = list("nutriment" = list(7, 11))
	kitchen_tag = "eki"

/datum/seed/eki/New()
	..()
	set_trait(TRAIT_SPREAD, 1)
	set_trait(TRAIT_MATURATION, 10)
	set_trait(TRAIT_PRODUCTION, 5)
	set_trait(TRAIT_YIELD, 4)
	set_trait(TRAIT_POTENCY, 15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom11")
	set_trait(TRAIT_BIOLUM_COLOUR,"#F0EEE9")
	set_trait(TRAIT_PRODUCT_COLOUR,"#F1EAD9")
	set_trait(TRAIT_PLANT_COLOUR,"#F1EAD9")
	set_trait(TRAIT_PLANT_ICON,"mushroom6")