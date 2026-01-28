/datum/trait/colour_changing_eyes
	name = "Colour changing eyes"
	desc = "You can change your eye color at will using an intuitive mental process."
	cost = 0
	custom_only = FALSE
	category = TRAIT_TYPE_NEUTRAL
	banned_species = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)

/datum/trait/colour_changing_eyes/apply(var/datum/species/S, var/mob/living/carbon/human/H, var/list/trait_prefs)
	..()
	add_verb(H, /mob/living/carbon/human/proc/shapeshifter_select_eye_colour)
