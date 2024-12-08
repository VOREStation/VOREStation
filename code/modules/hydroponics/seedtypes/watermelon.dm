/datum/seed/watermelon
	name = "watermelon"
	seed_name = "watermelon"
	display_name = "watermelon vine"
	kitchen_tag = "watermelon"
	chems = list(REAGENT_ID_NUTRIMENT = list(1,6), REAGENT_ID_WATERMELONJUICE = list(10,6))

/datum/seed/watermelon/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"vine")
	set_trait(TRAIT_PRODUCT_COLOUR,"#3D8C3A")
	set_trait(TRAIT_PLANT_COLOUR,"#257522")
	set_trait(TRAIT_PLANT_ICON,"vine2")
	set_trait(TRAIT_FLESH_COLOUR,"#F22C2C")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
