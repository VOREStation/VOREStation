// Chili plants/variants.
/datum/seed/chili
	name = PLANT_CHILI
	seed_name = PLANT_CHILI
	display_name = "chili plants"
	kitchen_tag = PLANT_CHILI
	chems = list(REAGENT_ID_CAPSAICIN = list(3,5), REAGENT_ID_NUTRIMENT = list(1,25))
	mutants = list(PLANT_ICECHILI, PLANT_GHOSTCHILI)

/datum/seed/chili/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"chili")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ED3300")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)

/datum/seed/chili/ice
	name = PLANT_ICECHILI
	seed_name = "ice pepper"
	display_name = "ice-pepper plants"
	kitchen_tag = PLANT_ICECHILI
	mutants = null
	chems = list(REAGENT_ID_FROSTOIL = list(3,5), REAGENT_ID_NUTRIMENT = list(1,50))

/datum/seed/chili/ice/New()
	..()
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_PRODUCT_COLOUR,"#00EDC6")

/datum/seed/chili/ghost
	name = PLANT_GHOSTCHILI
	seed_name = "ghost chili"
	display_name = "ghost chili plants"
	kitchen_tag = PLANT_GHOSTCHILI
	mutants = null
	chems = list(REAGENT_ID_CONDENSEDCAPSAICIN = list (3,10), REAGENT_ID_NUTRIMENT = list (1,25))

/datum/seed/chili/ghost/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_PRODUCT_COLOUR,"#eaecec")
