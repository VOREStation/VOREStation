/datum/seed/vale
	name = PLANT_VALE
	seed_name = PLANT_VALE
	display_name = "vale bush"
	kitchen_tag = PLANT_VALE
	chems = list(REAGENT_ID_PARACETAMOL = list(1,5),REAGENT_ID_DEXALIN = list(1,2),REAGENT_ID_NUTRIMENT= list(1,5))

/datum/seed/vale/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"flower4")
	set_trait(TRAIT_ENDURANCE,15)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,3)
