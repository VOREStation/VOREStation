
//Vore Originals

/datum/seed/size
	name = PLANT_MICROM
	seed_name = "Shrinking Mushroom"
	display_name = "Shrinking mushroom trees"
	mutants = list(PLANT_MEGAM)
	kitchen_tag = PLANT_MICROM
	chems = list(REAGENT_ID_MICROCILLIN = list(1,20))

/datum/seed/size/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#DA00DA")
	set_trait(TRAIT_PLANT_ICON,"tree")


/datum/seed/size/megam
	name = PLANT_MEGAM
	seed_name = "Mega Mushroom"
	display_name = "Mega mushroom trees"
	mutants = list(PLANT_MICROM)
	kitchen_tag = PLANT_MEGAM
	chems = list(REAGENT_ID_MACROCILLIN = list(1,20))

/datum/seed/size/megam/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom6")
	set_trait(TRAIT_PLANT_ICON,"tree")
	set_trait(TRAIT_PRODUCT_COLOUR,"#DADA00")

/datum/seed/gnomes
	harvest_sound = 'sound/items/hooh.ogg'
