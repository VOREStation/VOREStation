/datum/seed/nutmeg
	name = "nutmeg"
	seed_name = "nutmeg"
	display_name = "nutmeg"
	kitchen_tag = "nutmeg"
	chems = list("nutriment" = list(1,15), "dmt" = list(1,2))

/datum/seed/nutmeg/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,8)
	set_trait(TRAIT_PRODUCT_ICON,"nutmeg")
	set_trait(TRAIT_PRODUCT_COLOUR,"#5a382f")
	set_trait(TRAIT_PLANT_COLOUR,"#397437")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)