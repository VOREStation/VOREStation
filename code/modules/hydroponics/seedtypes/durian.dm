/datum/seed/durian
	name = PLANT_DURIAN
	seed_name = PLANT_DURIAN
	seed_noun = "pits"
	display_name = PLANT_DURIAN
	kitchen_tag = PLANT_DURIAN
	chems = list(REAGENT_ID_NUTRIMENT = list(1,5), REAGENT_ID_DURIANPASTE = list(1, 20))

/datum/seed/durian/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"spinefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#757631")
	set_trait(TRAIT_PLANT_COLOUR,"#87C969")
	set_trait(TRAIT_PLANT_ICON,"tree")
	set_trait(TRAIT_IDEAL_LIGHT, 8)
	set_trait(TRAIT_WATER_CONSUMPTION, 8)
