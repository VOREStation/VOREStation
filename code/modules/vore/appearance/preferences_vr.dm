/**
 * Additional variables that must be defined on /mob/living/carbon/human
 * for use in code that is part of the vore modules.
 *
 * These variables are declared here (separately from the normal human_defines.dm)
 * in order to isolate VOREStation changes and ease merging of other codebases.
 */

// Additional vars
/mob/living/carbon/human

	// Horray Furries!
	var/datum/sprite_accessory/ears/ear_style = null
	var/datum/sprite_accessory/tail/tail_style = null
	var/r_tail = 30
	var/g_tail = 30
	var/b_tail = 30

	// Custom Species Name
	var/custom_species
