// Smoles
/datum/seed/smoles
	name = PLANT_SMOLES
	seed_name = PLANT_SMOLES
	display_name = PLANT_SMOLES
	force_layer = 3
	chems = list(REAGENT_ID_PROTEIN = list(5,20))

/datum/seed/smoles/New()
	..()
	set_trait(TRAIT_FLESH_COLOUR,         "")
	set_trait(TRAIT_BIOLUM,               0)
	set_trait(TRAIT_POTENCY,              10)
	set_trait(TRAIT_IMMUTABLE,            1)
	set_trait(TRAIT_HARVEST_REPEAT,       1)
	set_trait(TRAIT_PRODUCES_POWER,       1)
	set_trait(TRAIT_CARNIVOROUS,          1)
	set_trait(TRAIT_PARASITE,             1)
	set_trait(TRAIT_YIELD,                2)
	set_trait(TRAIT_SPREAD,               1)
	set_trait(TRAIT_MATURATION,           8)
	set_trait(TRAIT_PRODUCTION,           6)
	set_trait(TRAIT_PRODUCT_ICON,         "gnomes")
	set_trait(TRAIT_PLANT_ICON,           "gnomes")
	set_trait(TRAIT_PRODUCT_COLOUR,       "")
	set_trait(TRAIT_BIOLUM_COLOUR,        "")
	set_trait(TRAIT_REQUIRES_NUTRIENTS,   0)
	set_trait(TRAIT_REQUIRES_WATER,       0)
	set_trait(TRAIT_WATER_CONSUMPTION,    0)
	set_trait(TRAIT_LIGHT_TOLERANCE,      10)
	set_trait(TRAIT_TOXINS_TOLERANCE,     10)
	set_trait(TRAIT_PEST_TOLERANCE,       10)
	set_trait(TRAIT_WEED_TOLERANCE,       10)
	set_trait(TRAIT_IDEAL_LIGHT,          7)
	set_trait(TRAIT_HEAT_TOLERANCE,       451)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0)
	set_trait(TRAIT_PLANT_COLOUR,         "")
