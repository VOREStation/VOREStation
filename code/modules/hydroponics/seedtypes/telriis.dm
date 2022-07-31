/datum/seed/telriis
	name = "telriis"
	seed_name = "telriis"
	display_name = "telriis grass"
	kitchen_tag = "telriis"
	chems = list("pwine" = list(1,5), "nutriment" = list(1,6))

/datum/seed/telriis/Initialize()
	. = ..()
	set_trait(TRAIT_PLANT_ICON,"ambrosia")
	set_trait(TRAIT_PRODUCT_ICON,"ambrosia")
	set_trait(TRAIT_ENDURANCE,50)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,5)
