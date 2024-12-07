/datum/seed/jurlmah
	name = "jurlmah"
	seed_name = "jurl'mah"
	display_name = "jurl'mah reeds"
	kitchen_tag = "jurlmah"
	chems = list(REAGENT_ID_SEROTROTIUM = list(1,5),REAGENT_ID_NUTRIMENT = list(1,5))

/datum/seed/jurlmah/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"mushroom9")
	set_trait(TRAIT_ENDURANCE,12)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,9)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
