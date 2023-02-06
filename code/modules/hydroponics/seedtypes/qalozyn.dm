/datum/seed/qalozyn
	name = "qalozyn"
	seed_name = "qa'lozyn"
	display_name = "qa'lozyn"
	mutants = null
	chems = list("nutriment" = list(3, 5), "toxin" = list(2, 3))
	kitchen_tag = "qalozyn"

/datum/seed/qalozyn/New()
	..()
	set_trait(TRAIT_MATURATION, 8)
	set_trait(TRAIT_PRODUCTION, 3)
	set_trait(TRAIT_POTENCY, 5)
	set_trait(TRAIT_PRODUCT_ICON,"qalozyn")
	set_trait(TRAIT_PRODUCT_COLOUR,"#990000")
	set_trait(TRAIT_PLANT_COLOUR,"#993333")
	set_trait(TRAIT_PLANT_ICON,"skrellvines")
	set_trait(TRAIT_YIELD, 6)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#990033")
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_WATER_CONSUMPTION, 10)