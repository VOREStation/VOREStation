// Chili plants/variants.
/datum/seed/chili
	name = "chili"
	seed_name = "chili"
	display_name = "chili plants"
	kitchen_tag = "chili"
	chems = list("capsaicin" = list(3,5), "nutriment" = list(1,25))
	mutants = list("icechili", "ghostchili")

/datum/seed/chili/Initialize()
	. = ..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"chili")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ED3300")
	set_trait(TRAIT_PLANT_ICON,"bush2")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)

/datum/seed/chili/ice
	name = "icechili"
	seed_name = "ice pepper"
	display_name = "ice-pepper plants"
	kitchen_tag = "icechili"
	mutants = null
	chems = list("frostoil" = list(3,5), "nutriment" = list(1,50))

/datum/seed/chili/ice/Initialize()
	. = ..()
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_PRODUCT_COLOUR,"#00EDC6")

/datum/seed/chili/ghost
	name = "ghostchili"
	seed_name = "ghost chili"
	display_name = "ghost chili plants"
	kitchen_tag = "ghostchili"
	mutants = null
	chems = list("condensedcapsaicin" = list (3,10), "nutriment" = list (1,25))

/datum/seed/chili/ghost/Initialize()
	. = ..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,3)
	set_trait(TRAIT_PRODUCT_COLOUR,"#eaecec")
