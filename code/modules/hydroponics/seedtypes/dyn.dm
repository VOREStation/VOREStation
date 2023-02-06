/datum/seed/dyn
	name = "dyn"
	seed_name = "dyn"
	display_name = "dyn bush"
	mutants = null
	chems = list("nutriment" = list(1,10), "dynjuice" = list(10,10))
	kitchen_tag = "dyn leaf"

/datum/seed/dyn/New()
	..()
	set_trait(TRAIT_MATURATION, 10)
	set_trait(TRAIT_PRODUCTION, 10)
	set_trait(TRAIT_YIELD, 3)
	set_trait(TRAIT_POTENCY, 10)
	set_trait(TRAIT_PRODUCT_ICON,"leaves")
	set_trait(TRAIT_PRODUCT_COLOUR,"#00e0e0")
	set_trait(TRAIT_PLANT_ICON,"bush8")