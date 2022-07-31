/datum/seed/durian
	name = "durian"
	seed_name = "durian"
	seed_noun = "pits"
	display_name = "durian"
	kitchen_tag = "durian"
	chems = list("nutriment" = list(1,5), "durianpaste" = list(1, 20))

/datum/seed/durian/Initialize()
	. = ..()
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
