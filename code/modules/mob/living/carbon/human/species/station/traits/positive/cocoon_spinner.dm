/datum/trait/cocoon_tf
	name = "Cocoon Spinner"
	desc = "Allows you to build a cocoon around yourself, using it to transform your body if you desire."
	cost = 1
	allowed_species = list(SPECIES_HANNER, SPECIES_CUSTOM) //So it only shows up for custom species and hanner
	custom_only = FALSE
	excludes = list(/datum/trait/weaver)
	category = TRAIT_TYPE_POSITIVE

/datum/trait/cocoon_tf/apply(var/datum/species/S,var/mob/living/carbon/human/H)
	..()
	add_verb(H, /mob/living/carbon/human/proc/enter_cocoon)
