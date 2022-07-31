
//Vore Originals

/datum/seed/size
	name = "microm"
	seed_name = "Shrinking Mushroom"
	display_name = "Shrinking mushroom trees"
	mutants = list("megam")
	kitchen_tag = "microm"
	chems = list("microcillin" = list(1,20))

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
	name = "megam"
	seed_name = "Mega Mushroom"
	display_name = "Mega mushroom trees"
	mutants = list("microm")
	kitchen_tag = "megam"
	chems = list("macrocillin" = list(1,20))

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
