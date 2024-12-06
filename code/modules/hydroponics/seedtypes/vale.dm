/datum/seed/vale
	name = "vale"
	seed_name = "vale"
	display_name = "vale bush"
	kitchen_tag = "vale"
	chems = list("paracetamol" = list(1,5),"dexalin" = list(1,2),REAGENT_ID_NUTRIMENT= list(1,5))

/datum/seed/vale/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"flower4")
	set_trait(TRAIT_ENDURANCE,15)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,3)
