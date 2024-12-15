/datum/seed/surik
	name = PLANT_SURIK
	seed_name = PLANT_SURIK
	display_name = "surik vine"
	kitchen_tag = PLANT_SURIK
	chems = list(REAGENT_ID_IMPEDREZENE = list(1,3),REAGENT_ID_SYNAPTIZINE = list(1,2),REAGENT_ID_NUTRIMENT = list(1,5))

/datum/seed/surik/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"bush6")
	set_trait(TRAIT_ENDURANCE,18)
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,7)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,3)
