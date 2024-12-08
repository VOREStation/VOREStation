/datum/seed/corn
	name = PLANT_CORN
	seed_name = PLANT_CORN
	display_name = "ears of corn"
	kitchen_tag = PLANT_CORN
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10), REAGENT_ID_CORNOIL = list(3,15))
	trash_type = /obj/item/corncob

/datum/seed/corn/New()
	..()
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"corn")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFF23B")
	set_trait(TRAIT_PLANT_COLOUR,"#87C969")
	set_trait(TRAIT_PLANT_ICON,"corn")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
