//Flowers/varieties
/datum/seed/flower
	name = PLANT_HAREBELLS
	seed_name = PLANT_HAREBELLS
	display_name = PLANT_HAREBELLS
	kitchen_tag = PLANT_HAREBELLS
	chems = list(REAGENT_ID_NUTRIMENT = list(1,20))

/datum/seed/flower/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_ICON,"flower5")
	set_trait(TRAIT_PRODUCT_COLOUR,"#C492D6")
	set_trait(TRAIT_PLANT_COLOUR,"#6B8C5E")
	set_trait(TRAIT_PLANT_ICON,"flower")
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/flower/poppy
	name = PLANT_POPPIES
	seed_name = PLANT_POPPIES
	display_name = PLANT_POPPIES
	kitchen_tag = PLANT_POPPIES
	chems = list(REAGENT_ID_NUTRIMENT = list(1,20), REAGENT_ID_BICARIDINE = list(1,10))

/datum/seed/flower/poppy/New()
	..()
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_PRODUCT_ICON,"flower3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B33715")
	set_trait(TRAIT_PLANT_ICON,"flower3")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/flower/sunflower
	name = PLANT_SUNFLOWERS
	seed_name = PLANT_SUNFLOWERS
	display_name = PLANT_SUNFLOWERS
	kitchen_tag = PLANT_SUNFLOWERS

/datum/seed/flower/sunflower/New()
	..()
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCT_ICON,"flower2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFF700")
	set_trait(TRAIT_PLANT_ICON,"flower2")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.15)

/datum/seed/flower/lavender
	name = PLANT_LAVENDER
	seed_name = PLANT_LAVENDER
	display_name = PLANT_LAVENDER
	kitchen_tag = PLANT_LAVENDER
	chems = list(REAGENT_ID_NUTRIMENT = list(1,20), REAGENT_ID_BICARIDINE = list(1,10))

/datum/seed/flower/lavender/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_PRODUCT_ICON,"flower6")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B57EDC")
	set_trait(TRAIT_PLANT_COLOUR,"#6B8C5E")
	set_trait(TRAIT_PLANT_ICON,"flower4")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.05)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)

/datum/seed/flower/rose
	name = PLANT_ROSE
	seed_name = PLANT_ROSE
	display_name = PLANT_ROSE
	kitchen_tag = PLANT_ROSE
	mutants = list(PLANT_BLOODROSE)
	chems = list(REAGENT_ID_NUTRIMENT = list(1,5), REAGENT_ID_STOXIN = list(0,2))

/datum/seed/flower/rose/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_ICON,"flowers")
	set_trait(TRAIT_PRODUCT_COLOUR,"#ce0e0e")
	set_trait(TRAIT_PLANT_COLOUR,"#6B8C5E")
	set_trait(TRAIT_PLANT_ICON,"bush5")
	set_trait(TRAIT_IDEAL_LIGHT, 7)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.1)
	set_trait(TRAIT_WATER_CONSUMPTION, 0.5)
	set_trait(TRAIT_STINGS,1)

/datum/seed/flower/rose/blood
	name = PLANT_BLOODROSE
	display_name = "bleeding rose"
	mutants = null
	chems = list(REAGENT_ID_NUTRIMENT = list(1,5), REAGENT_ID_STOXIN = list(1,5), REAGENT_ID_BLOOD = list(0,2))

/datum/seed/flower/rose/blood/New()
	..()
	set_trait(TRAIT_IDEAL_LIGHT, 1)
	set_trait(TRAIT_PLANT_COLOUR,"#5e0303")
	set_trait(TRAIT_CARNIVOROUS,1)
