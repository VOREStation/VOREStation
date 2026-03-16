
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

// Tea plants/variants.
/datum/seed/tea
	name = PLANT_TEA
	seed_name = PLANT_TEA
	display_name = "tea plant"
	chems = list(REAGENT_ID_TEAMUSH = list(3,10))
	mutants = null
	kitchen_tag = PLANT_TEA

/datum/seed/tea/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"tea")
	set_trait(TRAIT_PRODUCT_COLOUR,"#b7e496")
	set_trait(TRAIT_PLANT_COLOUR,"#b7e496")
	set_trait(TRAIT_PLANT_ICON,"bush4")
	set_trait(TRAIT_IDEAL_HEAT, 298)
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/datum/seed/hardlightseed    //WIP: havent ported the mob and such yet, best someone more keen on these mobs does it - Jack
	name = PLANT_NULLHARDLIGHT
	seed_name = "Biomechanical Hardlight generator seed"
	display_name = "Biomechanical Hardlight stem"
	mutants = null
	can_self_harvest = 1
	has_mob_product = /mob/living/simple_mob/animal/synx/ai/pet/holo
	ai_mob_product = 1

/datum/seed/hardlightseed/New()
	..()
	set_trait(TRAIT_IMMUTABLE,1) //Normal genetics wont be able to do much with the mechanical parts, its more a machine than a real plant
	set_trait(TRAIT_MATURATION,1)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,1)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"alien4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#00FFFF")
	set_trait(TRAIT_PLANT_COLOUR,"#00FFFF")
	set_trait(TRAIT_PLANT_ICON,"alien4") //spooky pods
	set_trait(TRAIT_IDEAL_HEAT, 283)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0)
	set_trait(TRAIT_WATER_CONSUMPTION, 0)
