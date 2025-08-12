
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

/datum/seed/pitcher_plant //Pitcher plant
	name = PLANT_PITCHERPLANT
	seed_name = PLANT_PITCHERPLANT
	seed_noun = "pits"
	display_name = "pitcher shoots"
	can_self_harvest = 1
	apply_color_to_mob = FALSE
	has_mob_product = /mob/living/simple_mob/vore/pitcher_plant
	ai_mob_product = 1

/datum/seed/pitcher_plant/New() //No custom icons yet. No spread trait yet even though pitcher fruit can be planted outside of a tray as I've not tied that to hydroponics code.
	..()
	set_trait(TRAIT_IMMUTABLE,1)
	set_trait(TRAIT_CARNIVOROUS,1)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_WATER_CONSUMPTION,6)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"corn")
	set_trait(TRAIT_PRODUCT_COLOUR,"#a839a2")
	set_trait(TRAIT_PLANT_COLOUR,"#5b6f43")
	set_trait(TRAIT_PLANT_ICON,"ambrosia")
