/datum/seed/gauli
	name = "gauli"
	seed_name = "ga'uli"
	display_name = "ga'uli plant"
	kitchen_tag = "gauli"
	mutants = null
	chems = list("nutriment" = list(1,10),"gauli_juice" = list(10,20))

/datum/seed/gauli/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"gauli")
	set_trait(TRAIT_PRODUCT_COLOUR,"null")
	set_trait(TRAIT_PLANT_ICON,"gauli")
	set_trait(TRAIT_FLESH_COLOUR,"null")
	set_trait(TRAIT_IDEAL_LIGHT, 4)