//Tobacco/varieties.
/datum/seed/tobacco
	name = "tobacco"
	seed_name = "tobacco"
	display_name = "tobacco"
	kitchen_tag = "tobacco"
	mutants = list("stimbush")
	chems = list(REAGENT_ID_NUTRIMENT = list(1,15), REAGENT_ID_NICOTINE = list(1,20))

/datum/seed/tobacco/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"leafy")
	set_trait(TRAIT_PRODUCT_COLOUR,"#6f5648")
	set_trait(TRAIT_PLANT_ICON,"ambrosia")
	set_trait(TRAIT_IDEAL_LIGHT, 8)

/datum/seed/tobacco/stimbush
	name = "stimbush"
	seed_name = "stim-bush"
	display_name = "stim-bush"
	chems = list(REAGENT_ID_NUTRIMENT = list(1,10), REAGENT_ID_HYPERZINE = list(1,10), REAGENT_ID_SYNAPTIZINE = list(1,5))

/datum/seed/tobacco/stimbush/New()
	..()
	set_trait(TRAIT_HARVEST_REPEAT,1)
	set_trait(TRAIT_MATURATION,6)
	set_trait(TRAIT_PRODUCTION,6)
	set_trait(TRAIT_YIELD,6)
	set_trait(TRAIT_POTENCY,5)
	set_trait(TRAIT_PRODUCT_ICON,"leafy")
	set_trait(TRAIT_PRODUCT_COLOUR,"#e08a1e")
	set_trait(TRAIT_PLANT_ICON,"ambrosia")
	set_trait(TRAIT_IDEAL_LIGHT, 10)
