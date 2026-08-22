/*
////////////////////////////
/  =--------------------=  /
/  == Tail Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/tail
	name = DEVELOPER_WARNING_NAME
	var/desc = DEVELOPER_WARNING_NAME
//	icon = 'icons/mob/human_races/sprite_accessories/tails.dmi'
	do_colouration = TRUE //Set to FALSE to disable coloration using the tail color.
	/// Only appliciable if do_coloration = TRUE, ICON_MULTIPLY is a white bias, ICON_ADD is a black bias for colorations of sprites.
	/// Virtually all sprites now are white-biased greyscale. The ones that aren't are pre-colored, typically donator snowflake.
	color_blend_mode = ICON_MULTIPLY
	em_block = TRUE
	var/extra_overlay // Icon state of an additional overlay to blend in.
	var/extra_overlay2 //Tertiary.
	var/show_species_tail = FALSE // If false, do not render species' tail.
	var/clothing_can_hide = TRUE // If true, clothing with HIDETAIL hides it
	var/ani_state // State when wagging/animated
	var/extra_overlay_w // Wagging state for extra overlay
	var/extra_overlay2_w // Tertiary wagging.
	var/icon/clip_mask_icon = null //Icon file used for clip mask.
	var/clip_mask_state = null //Icon state to generate clip mask. Clip mask is used to 'clip' off the lower part of clothing such as jumpsuits & full suits.
	var/icon/clip_mask = null //Instantiated clip mask of given icon and state
	var/offset_x = 0
	var/offset_y = 0
	var/mob_offset_x = 0
	var/mob_offset_y = 0

	// Taur Loafing - IMPORTANT, READ BELOW.
	///IF SET TO TRUE, THE icon_state, extra_overlay, and extra_overlay2 MUST BE IN WHATEVER YOU SET icon_loaf to!
	///ADDITIONALLY, IF YOU ADD A SPECIAL VWAG, YOU NEED TO INCLUDE ani_state, extra_overlay_w, and extra_overlay2_w INTO icon_loaf TOO!
	var/can_loaf = FALSE
	var/loaf_offset = 0
	var/list/lower_layer_dirs = list(SOUTH, WEST, EAST)
	var/icon_loaf = null

	// Taur Vore
	var/vore_tail_sprite_variant = ""
	var/belly_variant_when_loaf = FALSE
	var/fullness_icons = 0
	var/struggle_anim = FALSE
	var/bellies_icon_path = 'icons/mob/vore/Taur_Bellies.dmi'

/datum/sprite_accessory/tail/New()
	. = ..()
	if(clip_mask_state)
		clip_mask = icon(icon = (clip_mask_icon ? clip_mask_icon : icon), icon_state = clip_mask_state)

// Default invis tail
/datum/sprite_accessory/tail/invisible
	name = "hide species-sprite tail"
	icon = null
	icon_state = null

//For all species tails. Includes haircolored tails.
/datum/sprite_accessory/tail/special
	name = DEVELOPER_WARNING_NAME
	icon = 'icons/effects/species_tails.dmi'

/datum/sprite_accessory/tail/special/unathi
	name = "unathi tail"
	desc = ""
	icon_state = "sogtail_s"

/datum/sprite_accessory/tail/special/tajaran
	name = "tajaran tail"
	desc = ""
	icon_state = "tajtail_s"

/datum/sprite_accessory/tail/special/sergal
	name = "sergal tail"
	desc = ""
	icon_state = "sergtail_s"

/datum/sprite_accessory/tail/special/akula
	name = "akula tail"
	desc = ""
	icon_state = "sharktail_s"

/datum/sprite_accessory/tail/special/nevrean
	name = "nevrean tail"
	desc = ""
	icon_state = "nevreantail_s"

/datum/sprite_accessory/tail/special/armalis
	name = "armalis tail"
	desc = ""
	icon_state = "armalis_tail_humanoid_s"

/datum/sprite_accessory/tail/special/xenodrone
	name = "xenomorph drone tail"
	desc = ""
	icon_state = "xenos_drone_tail_s"

/datum/sprite_accessory/tail/special/xenosentinel
	name = "xenomorph sentinel tail"
	desc = ""
	icon_state = "xenos_sentinel_tail_s"

/datum/sprite_accessory/tail/special/xenohunter
	name = "xenomorph hunter tail"
	desc = ""
	icon_state = "xenos_hunter_tail_s"

/datum/sprite_accessory/tail/special/xenoqueen
	name = "xenomorph queen tail"
	desc = ""
	icon_state = "xenos_queen_tail_s"

/datum/sprite_accessory/tail/special/monkey
	name = "monkey tail"
	desc = ""
	icon_state = "chimptail_s"

/datum/sprite_accessory/tail/special/tesharitail
	name = "teshari tail"
	desc = ""
	icon_state = "seromitail_s"

/datum/sprite_accessory/tail/special/tesharitailfeathered
	name = "teshari tail w/ feathers"
	desc = ""
	icon_state = "seromitail_s"
	extra_overlay = "seromitail_feathers_s"

/datum/sprite_accessory/tail/special/unathihc
	name = "unathi tail, colorable"
	desc = ""
	icon_state = "sogtail_hc_s"

/datum/sprite_accessory/tail/special/tajaranhc
	name = "tajaran tail, colorable"
	desc = ""
	icon_state = "tajtail_hc_s"

/datum/sprite_accessory/tail/special/sergalhc
	name = "sergal tail, colorable"
	desc = ""
	icon_state = "sergtail_hc_s"

/datum/sprite_accessory/tail/special/akulahc
	name = "akula tail, colorable"
	desc = ""
	icon_state = "sharktail_hc_s"

/datum/sprite_accessory/tail/special/nevreanhc
	name = "nevrean tail, colorable"
	desc = ""
	icon_state = "nevreantail_hc_s"

/datum/sprite_accessory/tail/special/foxdefault
	name = "default zorren tail, colorable"
	desc = ""
	icon_state = "zorren_tail"

/datum/sprite_accessory/tail/special/foxhc
	name = "highlander zorren tail, colorable"
	desc = ""
	icon_state = "foxtail_hc_s"

/datum/sprite_accessory/tail/special/fennechc
	name = "flatland zorren tail, colorable"
	desc = ""
	icon_state = "fentail_hc_s"

/datum/sprite_accessory/tail/special/armalishc
	name = "armalis tail, colorable"
	desc = ""
	icon_state = "armalis_tail_humanoid_hc_s"

/datum/sprite_accessory/tail/special/xenodronehc
	name = "xenomorph drone tail, colorable"
	desc = ""
	icon_state = "xenos_drone_tail_hc_s"

/datum/sprite_accessory/tail/special/xenosentinelhc
	name = "xenomorph sentinel tail, colorable"
	desc = ""
	icon_state = "xenos_sentinel_tail_hc_s"

/datum/sprite_accessory/tail/special/xenohunterhc
	name = "xenomorph hunter tail, colorable"
	desc = ""
	icon_state = "xenos_hunter_tail_hc_s"

/datum/sprite_accessory/tail/special/xenoqueenhc
	name = "xenomorph queen tail, colorable"
	desc = ""
	icon_state = "xenos_queen_tail_hc_s"

/datum/sprite_accessory/tail/special/monkeyhc
	name = "monkey tail, colorable"
	desc = ""
	icon_state = "chimptail_hc_s"

/datum/sprite_accessory/tail/special/tesharitailhc
	name = "teshari tail, colorable"
	desc = ""
	icon_state = "seromitail_hc_s"

/datum/sprite_accessory/tail/special/tesharitailfeatheredhc
	name = "teshari tail w/ feathers, colorable"
	desc = ""
	icon_state = "seromitail_feathers_hc_s"

/datum/sprite_accessory/tail/special/vulpan
	name = "vulpkanin, colorable"
	desc = ""
	icon_state = "vulptail_s"
