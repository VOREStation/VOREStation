/datum/seed/soybean
	name = "soybean"
	seed_name = "soybean"
	display_name = "soybeans"
	kitchen_tag = "soybeans"
	mutants = list("boibean")
	chems = list("nutriment" = list(1,20), "soymilk" = list(10,20))

/datum/seed/soybean/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,4)
	set_trait(TRAIT_PRODUCTION,4)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"bean")
	set_trait(TRAIT_PRODUCT_COLOUR,"#EBE7C0")
	set_trait(TRAIT_PLANT_ICON,"stalk")

/datum/seed/soybean/boibean
	name = "boibean"
	seed_name = "boibean"
	display_name = "boibeans"
	kitchen_tag = "boibean"
	chems = list("nutriment" = list(1,20), "boimilk" = list(10,20))



/datum/seed/soybean/boibean/New()
	..()
	set_trait(TRAIT_MATURATION,3)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,7)
	set_trait(TRAIT_PRODUCT_COLOUR,"#C2C0AE")
