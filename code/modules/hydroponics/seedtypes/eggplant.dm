//Eggplants/varieties.
/datum/seed/eggplant
	name = "eggplant"
	seed_name = "eggplant"
	display_name = "eggplants"
	kitchen_tag = "eggplant"
	mutants = list("egg-plant")
	chems = list("nutriment" = list(1,10))

/datum/seed/eggplant/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"eggplant")
	set_trait(TRAIT_PRODUCT_COLOUR,"#892694")
	set_trait(TRAIT_PLANT_ICON,"bush4")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)

// Return of Eggy. Just makes purple eggs. If the reagents are separated from the egg production by xenobotany or RNG, it's still an Egg plant.
/datum/seed/eggplant/egg
	name = "egg-plant"
	seed_name = "egg-plant"
	display_name = "egg-plants"
	kitchen_tag = "egg-plant"
	mutants = null
	chems = list("nutriment" = list(1,5), "egg" = list(3,12))
	has_item_product = /obj/item/reagent_containers/food/snacks/egg/purple
