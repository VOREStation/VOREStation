/datum/seed/gelthi
	name = PLANT_GELTHI
	seed_name = PLANT_GELTHI
	display_name = "gelthi plant"
	kitchen_tag = PLANT_GELTHI
	chems = list(REAGENT_ID_STOXIN = list(1,5),REAGENT_ID_CAPSAICIN = list(1,5),REAGENT_ID_NUTRIMENT = list(1,5))

/datum/seed/gelthi/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"mushroom3")
	set_trait(TRAIT_ENDURANCE,15)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,1)
