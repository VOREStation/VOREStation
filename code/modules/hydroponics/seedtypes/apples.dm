//Apples/varieties.
/datum/seed/apple
	name = "apple"
	seed_name = "apple"
	display_name = "apple tree"
	kitchen_tag = "apple"
	mutants = list("poisonapple","goldapple")
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10),"applejuice" = list(10,20))

/datum/seed/apple/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"apple")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FF540A")
	set_trait(TRAIT_PLANT_ICON,"tree2")
	set_trait(TRAIT_FLESH_COLOUR,"#E8E39B")
	set_trait(TRAIT_IDEAL_LIGHT, 4)

/datum/seed/apple/poison
	name = "poisonapple"
	mutants = null
	chems = list("cyanide" = list(1,5))

/datum/seed/apple/gold
	name = "goldapple"
	seed_name = "golden apple"
	display_name = "gold apple tree"
	kitchen_tag = "goldapple"
	mutants = null
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10), REAGENT_ID_GOLD = list(1,5))

/datum/seed/apple/gold/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFDD00")
	set_trait(TRAIT_PLANT_COLOUR,"#D6B44D")

/datum/seed/apple/sif
	name = "sifbulb"
	seed_name = "sivian pod"
	display_name = "sivian pod"
	kitchen_tag = "apple"
	chems = list(REAGENT_ID_NUTRIMENT = list(1,5),"sifsap" = list(10,20))

/datum/seed/apple/sif/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,10)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,12)
	set_trait(TRAIT_PRODUCT_ICON,"alien3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#0720c3")
	set_trait(TRAIT_PLANT_ICON,"tree5")
	set_trait(TRAIT_FLESH_COLOUR,"#05157d")
	set_trait(TRAIT_IDEAL_LIGHT, 1)
