// Gnomes
/datum/seed/gnomes
	name = PLANT_GNOMES
	seed_name = PLANT_GNOMES
	display_name = PLANT_GNOMES
	force_layer = 3
	chems = list(REAGENT_ID_MAGICDUST = list(5,20))

/datum/seed/gnomes/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_PLANT_ICON,"gnomes")
	set_trait(TRAIT_PRODUCT_ICON,"gnomes")
	set_trait(TRAIT_PRODUCT_COLOUR,"")
	set_trait(TRAIT_FLESH_COLOUR,"")
	set_trait(TRAIT_PLANT_COLOUR,"")
	set_trait(TRAIT_BIOLUM_COLOUR,"#fff200")
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_REQUIRES_NUTRIENTS,0)
	set_trait(TRAIT_REQUIRES_WATER,0)
