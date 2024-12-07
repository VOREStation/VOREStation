//Wabback / varieties.
/datum/seed/wabback
	name = "whitewabback"
	seed_name = "white wabback"
	seed_noun = "nodes"
	display_name = "white wabback"
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10), "protein" = list(1,5), "enzyme" = list(0,3))
	kitchen_tag = "wabback"
	mutants = list("blackwabback","wildwabback")
	has_item_product = /obj/item/stack/material/cloth

/datum/seed/wabback/New()
	..()
	set_trait(TRAIT_IDEAL_LIGHT, 5)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"carrot2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#E6EDFA")
	set_trait(TRAIT_PLANT_ICON,"chute")
	set_trait(TRAIT_PLANT_COLOUR, "#0650ce")
	set_trait(TRAIT_WATER_CONSUMPTION, 10)
	set_trait(TRAIT_ALTER_TEMP, -1)
	set_trait(TRAIT_CARNIVOROUS,1)
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_SPREAD,1)

/datum/seed/wabback/vine
	name = "blackwabback"
	seed_name = "black wabback"
	display_name = "black wabback"
	mutants = null
	chems = list(REAGENT_ID_NUTRIMENT = list(1,3), "protein" = list(1,10), REAGENT_ID_SEROTROTIUMV = list(0,1))

/datum/seed/wabback/vine/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#2E2F32")
	set_trait(TRAIT_CARNIVOROUS,2)

/datum/seed/wabback/wild
	name = "wildwabback"
	seed_name = "wild wabback"
	display_name = "wild wabback"
	mutants = list("whitewabback")
	has_item_product = null
	chems = list(REAGENT_ID_NUTRIMENT = list(1,15), "protein" = list(0,2), "enzyme" = list(0,1))

/datum/seed/wabback/wild/New()
	..()
	set_trait(TRAIT_IDEAL_LIGHT, 3)
	set_trait(TRAIT_WATER_CONSUMPTION, 7)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.1)
	set_trait(TRAIT_YIELD,5)
