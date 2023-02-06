/datum/seed/guami
	name = "guami"
	seed_name = "guami fruit"
	display_name = "guami vine"
	mutants = null
	chems = list("nutriment" = list(5, 9))
	kitchen_tag = "guami"

/datum/seed/guami/New()
	..()
	set_trait(TRAIT_MATURATION, 15)
	set_trait(TRAIT_YIELD, 3)
	set_trait(TRAIT_POTENCY, 30)
	set_trait(TRAIT_BIOLUM, 1)
	set_trait(TRAIT_BIOLUM_COLOUR,"#1F8DBA")
	set_trait(TRAIT_FLESH_COLOUR, "#1F8DBA")
	set_trait(TRAIT_PRODUCT_ICON,"alien")
	set_trait(TRAIT_PRODUCT_COLOUR,"#E8F1Fa")
	set_trait(TRAIT_PLANT_COLOUR,"#4790DA")
	set_trait(TRAIT_PLANT_ICON,"alien")
	set_trait(TRAIT_WATER_CONSUMPTION, 10)