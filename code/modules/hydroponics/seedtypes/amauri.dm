/datum/seed/amauri
	name = PLANT_AMAURI
	seed_name = PLANT_AMAURI
	display_name = "amauri plant"
	kitchen_tag = PLANT_AMAURI
	chems = list(REAGENT_ID_ZOMBIEPOWDER = list(1,10),REAGENT_ID_CONDENSEDCAPSAICIN = list(1,5),REAGENT_ID_NUTRIMENT = list(1,5))

/datum/seed/amauri/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"bush4")
	set_trait(TRAIT_ENDURANCE,10)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,9)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
