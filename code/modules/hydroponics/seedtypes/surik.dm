/datum/seed/surik
	name = "surik"
	seed_name = "surik"
	display_name = "surik vine"
	kitchen_tag = "surik"
	chems = list("impedrezene" = list(1,3),"synaptizine" = list(1,2),"nutriment" = list(1,5))

/datum/seed/surik/Initialize()
	. = ..()
	set_trait(TRAIT_PLANT_ICON,"bush6")
	set_trait(TRAIT_ENDURANCE,18)
	set_trait(TRAIT_MATURATION,7)
	set_trait(TRAIT_PRODUCTION,7)
	set_trait(TRAIT_YIELD,3)
	set_trait(TRAIT_POTENCY,3)
