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
	var/datum/sprite_accessory/hair_accessory/hair_accessory_style = null
	var/r_acc = 30
	var/g_acc = 30
	var/b_acc = 30
	var/r_acc2 = 30
	var/g_acc2 = 30
	var/b_acc2 = 30
	var/r_acc3 = 30
	var/g_acc3 = 30
	var/b_acc3 = 30
	var/datum/sprite_accessory/ears/ear_style = null
	var/r_ears = 30
	var/g_ears = 30
	var/b_ears = 30
	var/r_ears2 = 30
	var/g_ears2 = 30
	var/b_ears2 = 30
	var/r_ears3 = 30 //Trust me, we could always use more colour. No japes.
	var/g_ears3 = 30
	var/b_ears3 = 30
	var/datum/sprite_accessory/tail/tail_style = null
	var/r_tail = 30
	var/g_tail = 30
	var/b_tail = 30
	var/r_tail2 = 30
	var/g_tail2 = 30
	var/b_tail2 = 30
	var/r_tail3 = 30
	var/g_tail3 = 30
	var/b_tail3 = 30
	var/datum/sprite_accessory/wing/wing_style = null
	var/r_wing = 30
	var/g_wing = 30
	var/b_wing = 30
	var/r_wing2 = 30
	var/g_wing2 = 30
	var/b_wing2 = 30
	var/r_wing3 = 30
	var/g_wing3 = 30
	var/b_wing3 = 30

	// Custom Species Name
	var/custom_species
