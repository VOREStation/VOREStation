// Wurmwoad, the Space Spice maker. Totally is actually, 100% literal worms.

/datum/seed/wurmwoad
	name = "wurmwoad"
	seed_name = "wurmwoad"
	display_name = "wurmwoad growth"
	chems = list("nutriment" = list(1,10), "spacespice" = list(5,15))
	kitchen_tag = "wurmwoad"

/datum/seed/wurmwoad/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,8)
	set_trait(TRAIT_PRODUCT_ICON,"eyepod")
	set_trait(TRAIT_PRODUCT_COLOUR,"#e08702")
	set_trait(TRAIT_PLANT_COLOUR,"#f1d1d2")
	set_trait(TRAIT_PLANT_ICON,"worm")
	set_trait(TRAIT_IDEAL_LIGHT, 1)
	set_trait(TRAIT_WATER_CONSUMPTION, 8)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)
