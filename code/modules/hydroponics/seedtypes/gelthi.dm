/datum/seed/gelthi
	name = "gelthi"
	seed_name = "gelthi"
	display_name = "gelthi plant"
	kitchen_tag = "gelthi"
	chems = list(REAGENT_ID_STOXIN = list(1,5),"capsaicin" = list(1,5),REAGENT_ID_NUTRIMENT = list(1,5))

/datum/seed/gelthi/New()
	..()
	set_trait(TRAIT_PLANT_ICON,"mushroom3")
	set_trait(TRAIT_ENDURANCE,15)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,1)
