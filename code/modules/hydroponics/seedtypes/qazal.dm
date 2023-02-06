/datum/seed/qazal
	name = "qazal"
	seed_name = "qa'zal"
	display_name = "qa'zal plant"
	mutants = null
	chems = list("nutriment" = list(1,25), "qazal_flour" = list(10,30))
	kitchen_tag = "qazal"

/datum/seed/qazal/New()
	..()
	set_trait(TRAIT_MATURATION, 10)
	set_trait(TRAIT_PRODUCTION, 5)
	set_trait(TRAIT_YIELD, 4)
	set_trait(TRAIT_POTENCY, 15)
	set_trait(TRAIT_PRODUCT_ICON,"qazal")
	set_trait(TRAIT_PRODUCT_COLOUR,"null")
	set_trait(TRAIT_PLANT_COLOUR,"null")
	set_trait(TRAIT_PLANT_ICON,"qazal")