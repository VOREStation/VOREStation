/datum/seed/amauri
	name = "amauri"
	seed_name = "amauri"
	display_name = "amauri plant"
	kitchen_tag = "amauri"
	chems = list("zombiepowder" = list(1,10),"condensedcapsaicin" = list(1,5),REAGENT_ID_NUTRIMENT = list(1,5))

/datum/seed/amauri/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"bush4")
	set_trait(TRAIT_ENDURANCE,10)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,9)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
