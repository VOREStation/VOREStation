//Tomatoes/variants.
/datum/seed/tomato
	name = "tomato"
	seed_name = "tomato"
	display_name = "tomato plant"
	mutants = list("bluetomato","bloodtomato")
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10), REAGENT_ID_TOMATOJUICE = list(10,10))
	kitchen_tag = "tomato"

/datum/seed/tomato/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_JUICY,1)
	set_trait(TRAIT_MATURATION,8)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_POTENCY,10)
	set_trait(TRAIT_PRODUCT_ICON,"tomato")
	set_trait(TRAIT_PRODUCT_COLOUR,"#D10000")
	set_trait(TRAIT_PLANT_ICON,"bush3")
	set_trait(TRAIT_IDEAL_LIGHT, 6)
	set_trait(TRAIT_WATER_CONSUMPTION, 6)
	set_trait(TRAIT_NUTRIENT_CONSUMPTION, 0.25)

/datum/seed/tomato/blood
	name = "bloodtomato"
	seed_name = "blood tomato"
	display_name = "blood tomato plant"
	mutants = list("killertomato")
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10), REAGENT_ID_BLOOD = list(1,5))
	splat_type = /obj/effect/decal/cleanable/blood/splatter

/datum/seed/tomato/blood/New()
	..()
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_PRODUCT_COLOUR,"#FF0000")

/datum/seed/tomato/killer
	name = "killertomato"
	seed_name = "killer tomato"
	display_name = "killer tomato plant"
	mutants = null
	can_self_harvest = 1
	has_mob_product = /mob/living/simple_mob/tomato

/datum/seed/tomato/killer/New()
	..()
	set_trait(TRAIT_YIELD,2)
	set_trait(TRAIT_PRODUCT_COLOUR,"#A86747")

/datum/seed/tomato/blue
	name = "bluetomato"
	seed_name = "blue tomato"
	display_name = "blue tomato plant"
	mutants = list("bluespacetomato")
	chems = list(REAGENT_ID_NUTRIMENT = list(1,20), REAGENT_ID_LUBE = list(1,5))

/datum/seed/tomato/blue/New()
	..()
	set_trait(TRAIT_PRODUCT_COLOUR,"#4D86E8")
	set_trait(TRAIT_PLANT_COLOUR,"#070AAD")

/datum/seed/tomato/blue/teleport
	name = "bluespacetomato"
	seed_name = "bluespace tomato"
	display_name = "bluespace tomato plant"
	mutants = null
	chems = list(REAGENT_ID_NUTRIMENT = list(1,20), "singulo" = list(10,5))

/datum/seed/tomato/blue/teleport/New()
	..()
	set_trait(TRAIT_TELEPORTING,1)
	set_trait(TRAIT_PRODUCT_COLOUR,"#00E5FF")
	set_trait(TRAIT_BIOLUM,1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#4DA4A8")
