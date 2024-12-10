/datum/seed/telriis
	name = PLANT_TELRIIS
	seed_name = PLANT_TELRIIS
	display_name = "telriis grass"
	kitchen_tag = PLANT_TELRIIS
	chems = list(REAGENT_ID_PWINE = list(1,5), REAGENT_ID_NUTRIMENT = list(1,6))

/datum/seed/telriis/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"ambrosia")
	set_trait(TRAIT_PRODUCT_ICON,"ambrosia")
	set_trait(TRAIT_ENDURANCE,50)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,5)
