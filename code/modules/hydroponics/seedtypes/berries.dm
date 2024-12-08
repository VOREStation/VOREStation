// Berry plants/variants.
/datum/seed/berry
	name = "berries"
	seed_name = "berry"
	display_name = "berry bush"
	kitchen_tag = "berries"
	mutants = list("glowberries","poisonberries")
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10), REAGENT_ID_BERRYJUICE = list(10,10))

/datum/seed/berry/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"berry")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FA1616")
	set_trait(TRAIT_PLANT_ICON,"bush")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/berry/glow
	name = "glowberries"
	seed_name = "glowberry"
	display_name = "glowberry bush"
	mutants = null
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10), REAGENT_ID_URANIUM = list(3,5))

/datum/seed/berry/glow/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#006622")
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_COLOUR,"#c9fa16")
	set_trait(TRAIT_WATER_CONSUMPTION, 3)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/datum/seed/berry/poison
	name = "poisonberries"
	seed_name = "poison berry"
	kitchen_tag = "poisonberries"
	display_name = "poison berry bush"
	mutants = list("deathberries")
	chems = list(REAGENT_ID_NUTRIMENT = list(1), REAGENT_ID_TOXIN = list(3,5), REAGENT_ID_POISONBERRYJUICE = list(10,5))

/datum/seed/berry/poison/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#6DC961")
	set_trait(TRAIT_WATER_CONSUMPTION, 3)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/datum/seed/berry/poison/death
	name = "deathberries"
	seed_name = "death berry"
	display_name = "death berry bush"
	mutants = null
	chems = list(REAGENT_ID_NUTRIMENT = list(1), REAGENT_ID_TOXIN = list(3,3), REAGENT_ID_LEXORIN = list(1,5))

/datum/seed/berry/poison/death/New()
	..()
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,50)
	set_trait(TRAIT_PRODUCT_COLOUR,"#7A5454")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.35)

/datum/seed/berry/peppercorn
	name = "peppercorns"
	seed_name = "peppercorn berry"
	kitchen_tag = "peppercorns"
	display_name = "peppercorn bush"
	chems = list(REAGENT_ID_BLACKPEPPER = list(5,10))

/datum/seed/berry/peppercorn/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#303030")
	set_trait(TRAIT_WATER_CONSUMPTION, 2)
