/datum/seed/cherries
	name = PLANT_CHERRY
	seed_name = PLANT_CHERRY
	seed_noun = "pits"
	display_name = "cherry tree"
	kitchen_tag = "cherries"
	chems = list(REAGENT_ID_NUTRIMENT = list(1,15), REAGENT_ID_SUGAR = list(1,15), REAGENT_ID_CHERRYJELLY = list(10,15))

/datum/seed/cherries/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"cherry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#A80000")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_PLANT_COLOUR,"#2F7D2D")
