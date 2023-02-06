/datum/seed/kirani
	name = "kirani"
	seed_name = "kirani"
	display_name = "kirani plant"
	kitchen_tag = "kirani"
	mutants = null
	chems = list("nutriment" = list(1,10),"kirani_jelly" = list(10,20))

/datum/seed/kirani/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"kirani")
	set_trait(TRAIT_PRODUCT_COLOUR,"null")
	set_trait(TRAIT_PLANT_ICON,"kirani")
	set_trait(TRAIT_FLESH_COLOUR,"null")
	set_trait(TRAIT_IDEAL_LIGHT, 4)