/*
////////////////////////////
/  =--------------------=  /
/  == Wing Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/wing
	name = DEVELOPER_WARNING_NAME
	icon = 'icons/mob/human_races/sprite_accessories/wings.dmi'
	do_colouration = 0 //Set to 1 to enable coloration using the tail color.

	color_blend_mode = ICON_ADD // Only appliciable if do_coloration = 1
	em_block = TRUE
	var/extra_overlay // Icon state of an additional overlay to blend in.
	var/extra_overlay2 //Tertiary.
	var/clothing_can_hide = 1 // If true, clothing with HIDETAIL hides it. If the clothing is bulky enough to hide a tail, it should also hide wings.
	// var/show_species_tail = 1 // Just so // TODO - Seems not needed ~Leshana
	var/desc = DEVELOPER_WARNING_NAME
	var/ani_state // State when flapping/animated
	var/extra_overlay_w // Flapping state for extra overlay
	var/extra_overlay2_w

	//species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files

/datum/sprite_accessory/wing/featheredlarge //Made by Natje!
	name = "large feathered wings (colorable)"
	desc = ""
	icon_state = "feathered2"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/spider_legs //Not really /WINGS/ but they protrude from the back, kinda. Might as well have them here.
	name = "spider legs"
	desc = ""
	icon_state = "spider-legs"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/moth
	name = "moth wings"
	desc = ""
	icon_state = "moth"

/datum/sprite_accessory/wing/mothc
	name = "moth wings, colorable"
	desc = ""
	icon_state = "moth"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/dragonfly
	name = "dragonfly"
	desc = ""
	icon_state = "dragonfly"
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/feathered
	name = "feathered wings, colorable"
	desc = ""
	icon_state = "feathered"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/feathered_medium
	name = "medium feathered wings, colorable" // Keekenox made these feathery things with a little bit more shape to them than the other wings. They are medium sized wing boys.
	desc = ""
	icon_state = "feathered3"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/bat_black
	name = "bat wings, black"
	desc = ""
	icon_state = "bat-black"

/datum/sprite_accessory/wing/bat_color
	name = "bat wings, colorable"
	desc = ""
	icon_state = "bat-color"
	do_colouration = 1

/datum/sprite_accessory/wing/bat_red
	name = "bat wings, red"
	desc = ""
	icon_state = "bat-red"

/datum/sprite_accessory/wing/harpywings
	name = "harpy wings, colorable"
	desc = ""
	icon_state = "harpywings"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/feathered
	name = "feathered wings, colorable"
	desc = ""
	icon_state = "feathered"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/beewings
	name = "bee wings"
	desc = ""
	icon_state = "beewings"

/datum/sprite_accessory/wing/liquidfirefly_gazer //I g-guess this could be considered wings?
	name = "gazer eyestalks"
	desc = ""
	icon_state = "liquidfirefly-eyestalks"
	//ckeys_allowed = list("liquidfirefly","seiga") //At request.

/datum/sprite_accessory/wing/moth_full
	name = "moth antenna and wings"
	desc = ""
	icon_state = "moth_full"

/datum/sprite_accessory/wing/moth_full_gray
	name = "moth antenna and wings, colorable"
	desc = ""
	icon_state = "moth_full_gray"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/snag
	name = "xenomorph backplate"
	desc = ""
	icon_state = "snag-backplate"

/datum/sprite_accessory/wing/sepulchre_c_yw
	name = "demon wings (colorable)"
	desc = ""
	icon_state = "sepulchre_wingsc"
	do_colouration = 1

/datum/sprite_accessory/wing/cyberdragon
	name = "Cyber dragon wing (colorable)"
	desc = ""
	icon_state = "cyberdragon_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/wing/cyberdragon_red
	name = "Cyber dragon wing (red)"
	desc = ""
	icon_state = "cyberdragon_red_s"
	do_colouration = 0

/datum/sprite_accessory/wing/cyberdoe
	name = "Cyber doe wing"
	desc = ""
	icon_state = "cyberdoe_s"
	do_colouration = 0

/datum/sprite_accessory/wing/mantisarms
	name = "Mantis arms"
	desc = ""
	icon_state = "mantisarms_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
