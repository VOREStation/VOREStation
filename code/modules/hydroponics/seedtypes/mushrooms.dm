//Mushrooms/varieties.
/datum/seed/mushroom
	name = PLANT_MUSHROOMS
	seed_name = "chanterelle"
	seed_noun = "spores"
	display_name = "chanterelle mushrooms"
	mutants = list(PLANT_REISHI,PLANT_AMANITA,PLANT_PLUMPHELMET)
	chems = list(REAGENT_ID_NUTRIMENT = list(1,25))
	splat_type = /obj/effect/plant
	kitchen_tag = "mushroom"

/datum/seed/mushroom/New()
	..()
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_YIELD,5)
	set_trait(TRAIT_POTENCY,1)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom4")
	set_trait(TRAIT_PRODUCT_COLOUR,"#DBDA72")
	set_trait(TRAIT_PLANT_COLOUR,"#D9C94E")
	set_trait(TRAIT_PLANT_ICON,"mushroom")
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_IDEAL_HEAT, 288)
	set_trait(TRAIT_LIGHT_TOLERANCE, 6)

/datum/seed/mushroom/mold
	name = PLANT_MOLD
	seed_name = "brown mold"
	display_name = "brown mold"
	mutants = null

/datum/seed/mushroom/mold/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_YIELD,-1)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom5")
	set_trait(TRAIT_PRODUCT_COLOUR,"#7A5F20")
	set_trait(TRAIT_PLANT_COLOUR,"#7A5F20")
	set_trait(TRAIT_PLANT_ICON,"mushroom9")

/datum/seed/mushroom/plump
	name = PLANT_PLUMPHELMET
	seed_name = "plump helmet"
	display_name = "plump helmet mushrooms"
	mutants = list("walkingmushroom",PLANT_TOWERCAP)
	chems = list(REAGENT_ID_NUTRIMENT = list(2,10))
	kitchen_tag = PLANT_PLUMPHELMET

/datum/seed/mushroom/plump/New()
	..()
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,0)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom10")
	set_trait(TRAIT_PRODUCT_COLOUR,"#B57BB0")
	set_trait(TRAIT_PLANT_COLOUR,"#9E4F9D")
	set_trait(TRAIT_PLANT_ICON,"mushroom2")

/datum/seed/mushroom/hallucinogenic
	name = PLANT_REISHI
	seed_name = PLANT_REISHI
	display_name = PLANT_REISHI
	mutants = list(PLANT_LIBERTYCAP,PLANT_GLOWSHROOM)
	chems = list(REAGENT_ID_NUTRIMENT = list(1,50), REAGENT_ID_PSILOCYBIN = list(3,5))

/datum/seed/mushroom/hallucinogenic/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom11")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FFB70F")
	set_trait(TRAIT_PLANT_COLOUR,"#F58A18")
	set_trait(TRAIT_PLANT_ICON,"mushroom6")

/datum/seed/mushroom/hallucinogenic/strong
	name = PLANT_LIBERTYCAP
	seed_name = "liberty cap"
	display_name = "liberty cap mushrooms"
	mutants = null
	chems = list(REAGENT_ID_NUTRIMENT = list(1), REAGENT_ID_STOXIN = list(3,3), REAGENT_ID_BLISS = list(1,25))

/datum/seed/mushroom/hallucinogenic/strong/New()
	..()
	set_trait(TRAIT_PRODUCTION,1)
	set_trait(TRAIT_POTENCY,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom8")
	set_trait(TRAIT_PRODUCT_COLOUR,"#F2E550")
	set_trait(TRAIT_PLANT_COLOUR,"#D1CA82")
	set_trait(TRAIT_PLANT_ICON,"mushroom3")

/datum/seed/mushroom/poison
	name = PLANT_AMANITA
	seed_name = "fly amanita"
	display_name = "fly amanita mushrooms"
	mutants = list(PLANT_DESTROYINGANGEL,PLANT_PLASTIC)
	chems = list(REAGENT_ID_NUTRIMENT = list(1), REAGENT_ID_AMATOXIN = list(3,3), REAGENT_ID_PSILOCYBIN = list(1,25))

/datum/seed/mushroom/poison/New()
	..()
	set_trait(TRAIT_MATURATION,10)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom")
	set_trait(TRAIT_PRODUCT_COLOUR,"#FF4545")
	set_trait(TRAIT_PLANT_COLOUR,"#E0DDBA")
	set_trait(TRAIT_PLANT_ICON,"mushroom4")

/datum/seed/mushroom/poison/death
	name = PLANT_DESTROYINGANGEL
	seed_name = "destroying angel"
	display_name = "destroying angel mushrooms"
	mutants = null
	chems = list(REAGENT_ID_NUTRIMENT = list(1,50), REAGENT_ID_AMATOXIN = list(13,3), REAGENT_ID_PSILOCYBIN = list(1,25))

/datum/seed/mushroom/poison/death/New()
	..()
	set_trait(TRAIT_MATURATION,12)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,35)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom3")
	set_trait(TRAIT_PRODUCT_COLOUR,"#EDE8EA")
	set_trait(TRAIT_PLANT_COLOUR,"#E6D8DD")
	set_trait(TRAIT_PLANT_ICON,"mushroom5")

/datum/seed/mushroom/towercap
	name = PLANT_TOWERCAP
	seed_name = "tower cap"
	display_name = "tower caps"
	chems = list(REAGENT_ID_WOODPULP = list(10,1))
	mutants = list(PLANT_REDCAP)
	has_item_product = /obj/item/stack/material/log

/datum/seed/mushroom/towercap/New()
	..()
	set_trait(TRAIT_MATURATION,15)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom7")
	set_trait(TRAIT_PRODUCT_COLOUR,"#79A36D")
	set_trait(TRAIT_PLANT_COLOUR,"#857F41")
	set_trait(TRAIT_PLANT_ICON,"mushroom8")

/datum/seed/mushroom/towercap/red
	name = PLANT_REDCAP
	seed_name = "red cap"
	display_name = "red caps"
	chems = list(REAGENT_ID_WOODPULP = list(10,1), REAGENT_ID_TANNIN = list(1,10))
	mutants = null
	has_item_product = null

/datum/seed/mushroom/towercap/red/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#b81414")

/datum/seed/mushroom/glowshroom
	name = PLANT_GLOWSHROOM
	seed_name = PLANT_GLOWSHROOM
	display_name = "glowshrooms"
	mutants = null
	chems = list(REAGENT_ID_RADIUM = list(1,20))

/datum/seed/mushroom/glowshroom/New()
	..()
	set_trait(TRAIT_SPREAD,1)
	set_trait(TRAIT_MATURATION,15)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,30)
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#006622")
	set_trait(TRAIT_PRODUCT_ICON,"mushroom2")
	set_trait(TRAIT_PRODUCT_COLOUR,"#DDFAB6")
	set_trait(TRAIT_PLANT_COLOUR,"#EFFF8A")
	set_trait(TRAIT_PLANT_ICON,"mushroom7")

/datum/seed/mushroom/plastic
	name = PLANT_PLASTIC
	seed_name = "plastellium"
	display_name = "plastellium"
	mutants = null
	chems = list(REAGENT_ID_PLASTICIDE = list(1,10))

/datum/seed/mushroom/plastic/New()
	..()
	set_trait(TRAIT_MATURATION,5)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom6")
	set_trait(TRAIT_PRODUCT_COLOUR,"#E6E6E6")
	set_trait(TRAIT_PLANT_COLOUR,"#E6E6E6")
	set_trait(TRAIT_PLANT_ICON,"mushroom10")

/datum/seed/mushroom/spore
	name = PLANT_SPORESHROOM
	seed_name = "corpellian"
	display_name = "corpellian"
	mutants = null
	chems = list(REAGENT_ID_SEROTROTIUM = list(5,10), REAGENT_ID_MOLD = list(1,10))

/datum/seed/mushroom/spore/New()
	..()
	set_trait(TRAIT_MATURATION,15)
	set_trait(TRAIT_PRODUCTION,5)
	set_trait(TRAIT_YIELD,4)
	set_trait(TRAIT_POTENCY,20)
	set_trait(TRAIT_PRODUCT_ICON,"mushroom5")
	set_trait(TRAIT_PRODUCT_COLOUR,"#e29cd2")
	set_trait(TRAIT_PLANT_COLOUR,"#f8e6f4")
	set_trait(TRAIT_PLANT_ICON,"mushroom9")
	set_trait(TRAIT_SPORING, TRUE)
