//Eggplants/varieties.
/datum/seed/eggplant
	name = PLANT_EGGPLANT
	seed_name = PLANT_EGGPLANT
	display_name = "eggplants"
	kitchen_tag = PLANT_EGGPLANT
	mutants = list(PLANT_EGGPLANT)
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10))

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
	name = PLANT_EGGPLANT
	seed_name = PLANT_EGGPLANT
	display_name = "egg-plants"
	kitchen_tag = PLANT_EGGPLANT
	mutants = null
	chems = list(REAGENT_ID_NUTRIMENT = list(1,5), REAGENT_ID_EGG = list(3,12))
	has_item_product = /obj/item/reagent_containers/food/snacks/egg/purple
