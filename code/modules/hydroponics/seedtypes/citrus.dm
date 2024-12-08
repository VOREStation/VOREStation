/datum/seed/citrus
	name = PLANT_LIME
	seed_name = PLANT_LIME
	display_name = "lime trees"
	kitchen_tag = PLANT_LIME
	chems = list(REAGENT_ID_NUTRIMENT = list(1,20), REAGENT_ID_LIMEJUICE = list(10,20))

/datum/seed/citrus/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"treefruit")
	set_trait(TRAIT_PRODUCT_COLOUR,"#3AF026")
	set_trait(TRAIT_PLANT_ICON,"tree")
	set_trait(TRAIT_FLESH_COLOUR,"#3AF026")

/datum/seed/citrus/lemon
	name = PLANT_LEMON
	seed_name = PLANT_LEMON
	display_name = "lemon trees"
	kitchen_tag = PLANT_LEMON
	chems = list(REAGENT_ID_NUTRIMENT = list(1,20), REAGENT_ID_LEMONJUICE = list(10,20))

/datum/seed/citrus/lemon/New()
	..()
	set_trait(TRAIT_PRODUCES_POWER,1)
	set_trait(TRAIT_PRODUCT_ICON,"lemon")
	set_trait(TRAIT_PRODUCT_COLOUR,"#F0E226")
	set_trait(TRAIT_FLESH_COLOUR,"#F0E226")
	set_trait(TRAIT_IDEAL_LIGHT, 6)

/datum/seed/citrus/orange
	name = PLANT_ORANGE
	seed_name = PLANT_ORANGE
	display_name = "orange trees"
	kitchen_tag = PLANT_ORANGE
	chems = list(REAGENT_ID_NUTRIMENT = list(1,20), REAGENT_ID_ORANGEJUICE = list(10,20))

/datum/seed/citrus/orange/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFC20A")
	set_trait(TRAIT_FLESH_COLOUR,"#FFC20A")
