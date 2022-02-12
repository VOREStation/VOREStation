/*
////////////////////////////
/  =--------------------=  /
/  == Tail Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/tail
	name = "You should not see this..."
	icon = 'icons/mob/human_races/sprite_accessories/tails.dmi'
	do_colouration = TRUE // If you set it to false you're doing it wrong

<<<<<<< HEAD
	color_blend_mode = ICON_ADD // Only appliciable if do_coloration = 1
	em_block = TRUE
=======
	color_blend_mode = ICON_MULTIPLY // Only appliciable if do_coloration = 1
>>>>>>> 9f526f32ea7... Merge pull request #8278 from PolarisSS13/cynosure_map
	var/extra_overlay // Icon state of an additional overlay to blend in.
	var/extra_overlay2 //Tertiary.
	var/show_species_tail = 0 // If false, do not render species' tail.
	var/clothing_can_hide = 1 // If true, clothing with HIDETAIL hides it
	var/ani_state // State when wagging/animated
	var/extra_overlay_w // Wagging state for extra overlay
	var/extra_overlay2_w // Tertiary wagging.
	var/list/hide_body_parts = list() //Uses organ tag defines. Bodyparts in this list do not have their icons rendered, allowing for more spriter freedom when doing taur/digitigrade stuff.
	var/icon/clip_mask_icon = null //Icon file used for clip mask.
	var/clip_mask_state = null //Icon state to generate clip mask. Clip mask is used to 'clip' off the lower part of clothing such as jumpsuits & full suits.
	var/icon/clip_mask = null //Instantiated clip mask of given icon and state

<<<<<<< HEAD
	//species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files
=======
	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	whitelist_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_PROMETHEAN)
>>>>>>> 9f526f32ea7... Merge pull request #8278 from PolarisSS13/cynosure_map

/datum/sprite_accessory/tail/New()
	. = ..()
	if(clip_mask_icon && clip_mask_state)
		clip_mask = icon(icon = clip_mask_icon, icon_state = clip_mask_state)

// Species-unique tails

// Everyone tails

/datum/sprite_accessory/tail/invisible
	name = "hide species-sprite tail"
	icon = null
	icon_state = null
<<<<<<< HEAD

	//species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI, SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files
=======
	species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI, SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
>>>>>>> 9f526f32ea7... Merge pull request #8278 from PolarisSS13/cynosure_map

/datum/sprite_accessory/tail/squirrel
	name = "squirrel"
	icon_state = "squirrel"

/datum/sprite_accessory/tail/kitty
	name = "kitty, downwards"
	icon_state = "kittydown"

/datum/sprite_accessory/tail/kittyup
	name = "kitty, upwards"
	icon_state = "kittyup"

/datum/sprite_accessory/tail/tiger_white
	name = "tiger"
	icon_state = "tiger"
	extra_overlay = "tigerinnerwhite"

/datum/sprite_accessory/tail/stripey
	name = "stripey taj"
	icon_state = "stripeytail"
	extra_overlay = "stripeytail_mark"
<<<<<<< HEAD

	//species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files
=======
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
>>>>>>> 9f526f32ea7... Merge pull request #8278 from PolarisSS13/cynosure_map

/datum/sprite_accessory/tail/bunny
	name = "bunny"
	icon_state = "bunny"
	color_blend_mode = ICON_ADD

/datum/sprite_accessory/tail/bear
	name = "bear"
	icon_state = "bear"

/datum/sprite_accessory/tail/dragon
	name = "lizard"
	icon_state = "dragon"

/datum/sprite_accessory/tail/wolf
	name = "wolf"
	icon_state = "wolf"
	extra_overlay = "wolfinner"

/datum/sprite_accessory/tail/mouse
	name = "mouse"
	icon_state = "mouse"

/datum/sprite_accessory/tail/horse
	name = "horse tail"
	icon_state = "horse"

/datum/sprite_accessory/tail/cow
	name = "cow tail"
	icon_state = "cow"

/datum/sprite_accessory/tail/fantail
	name = "avian fantail"
	icon_state = "fantail"
	whitelist_allowed = list()

/datum/sprite_accessory/tail/wagtail
	name = "avian wagtail"
	icon_state = "wagtail"
	whitelist_allowed = list()

/datum/sprite_accessory/tail/wagtail/dc
	name = "avian wagtail, dual-color"
	extra_overlay = "wagtail_dc_tail"

/datum/sprite_accessory/tail/nevreanwagdc_alt
	name = "avian wagtail, marked, dual-color"
	icon_state = "wagtail2_dc"
	extra_overlay = "wagtail2_dc_mark"
	whitelist_allowed = list()

/datum/sprite_accessory/tail/crossfox
	name = "cross fox"
	do_colouration = FALSE // DOING IT WRONG
	icon_state = "crossfox"

/datum/sprite_accessory/tail/doublekitsune
	name = "double kitsune tail"
	icon_state = "doublekitsune"

/datum/sprite_accessory/tail/spade_color
	name = "demon tail"
	icon_state = "spadetail-black"
	color_blend_mode = ICON_ADD

/datum/sprite_accessory/tail/eboop
	name = "EGN mech tail (dual color)"
	icon_state = "eboop"
	extra_overlay = "eboop_mark"

/datum/sprite_accessory/tail/ringtail
	name = "ringtail"
	icon_state = "ringtail"
	extra_overlay = "ringtail_mark"
	whitelist_allowed = list() // Too excessive

/datum/sprite_accessory/tail/curltail
	name = "curltail (vwag)"
	icon_state = "curltail"
	ani_state = "curltail_w"
	extra_overlay = "curltail_mark"
	extra_overlay_w = "curltail_mark_w"

/datum/sprite_accessory/tail/shorttail
	name = "shorttail (vwag)"
	icon_state = "straighttail"
	ani_state = "straighttail_w"

/datum/sprite_accessory/tail/sneptail
	name = "snow leopard Tail (vwag)"
	icon_state = "sneptail"
	ani_state = "sneptail_w"
	extra_overlay = "sneptail_mark"
	extra_overlay_w = "sneptail_mark_w"

/datum/sprite_accessory/tail/tiger_new
	name = "tiger tail (vwag)"
	icon_state = "tigertail"
	ani_state = "tigertail_w"
	extra_overlay = "tigertail_mark"
	extra_overlay_w = "tigertail_mark_w"

/datum/sprite_accessory/tail/vulp_new
	name = "new canine tail (vwag)"
	icon_state = "vulptail"
	ani_state = "vulptail_w"
	extra_overlay = "vulptail_mark"
	extra_overlay_w = "vulptail_mark_w"

/datum/sprite_accessory/tail/otietail
	name = "otie tail (vwag)"
	icon_state = "otie"
	ani_state = "otie_w"

/datum/sprite_accessory/tail/ztail
	name = "jagged flufftail"
	icon_state = "ztail"

/datum/sprite_accessory/tail/snaketail
	name = "snake tail"
	icon_state = "snaketail"
	whitelist_allowed = list() // Too excessive

/datum/sprite_accessory/tail/vulpan_alt
	name = "canine alt style"
	icon_state = "vulptail_alt"

/datum/sprite_accessory/tail/skunktail
	name = "skunk, dual-color"
	icon_state = "skunktail"
	extra_overlay = "skunktail_mark"

/datum/sprite_accessory/tail/deertail
	name = "deer, dual-color"
	icon_state = "deertail"
	extra_overlay = "deertail_mark"

/datum/sprite_accessory/tail/teshari_fluffytail
	name = "Teshari alternative"
	icon_state = "teshari_fluffytail"
	extra_overlay = "teshari_fluffytail_mark"
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	//species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files

/datum/sprite_accessory/tail/nightstalker
	name = "Nightstalker, colorable"
	desc = ""
	icon_state = "nightstalker"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
=======
	species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	whitelist_allowed = list()
>>>>>>> 9f526f32ea7... Merge pull request #8278 from PolarisSS13/cynosure_map

//For all species tails. Includes haircolored tails.
/datum/sprite_accessory/tail/special
	name = "Blank tail. Do not select."
	icon = 'icons/effects/species_tails.dmi'
	whitelist_allowed = list()

/datum/sprite_accessory/tail/special/unathi
	name = "unathi tail"
	icon_state = "sogtail_s"
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

	//species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files
=======
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
>>>>>>> 9f526f32ea7... Merge pull request #8278 from PolarisSS13/cynosure_map

/datum/sprite_accessory/tail/special/tajaran
	name = "tajaran tail"
	icon_state = "tajtail_s"
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	//species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files
=======
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
>>>>>>> 9f526f32ea7... Merge pull request #8278 from PolarisSS13/cynosure_map

/datum/sprite_accessory/tail/special/monkey
	name = "monkey tail"
	icon_state = "chimptail_s"

/datum/sprite_accessory/tail/special/tesharitail
	name = "teshari tail"
	icon_state = "seromitail_s"
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	//species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files
=======
	species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
>>>>>>> 9f526f32ea7... Merge pull request #8278 from PolarisSS13/cynosure_map

/datum/sprite_accessory/tail/special/tesharitailfeathered
	name = "teshari tail w/ feathers"
	icon_state = "seromitail_s"
	extra_overlay = "seromitail_feathers_s"
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	//species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files
=======
	species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
>>>>>>> 9f526f32ea7... Merge pull request #8278 from PolarisSS13/cynosure_map

/datum/sprite_accessory/tail/special/unathihc
	name = "unathi tail"
	icon_state = "sogtail_hc_s"
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	//species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files
=======
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
>>>>>>> 9f526f32ea7... Merge pull request #8278 from PolarisSS13/cynosure_map

/datum/sprite_accessory/tail/special/tajaranhc
	name = "tajaran tail"
	icon_state = "tajtail_hc_s"
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	//species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files

/datum/sprite_accessory/tail/special/sergalhc
	name = "sergal tail, colorable"
	desc = ""
	icon_state = "sergtail_hc_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/special/akulahc
	name = "akula tail, colorable"
	desc = ""
	icon_state = "sharktail_hc_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/special/nevreanhc
	name = "nevrean tail, colorable"
	desc = ""
	icon_state = "nevreantail_hc_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/special/foxdefault
	name = "default zorren tail, colorable"
	desc = ""
	icon = "icons/mob/human_races/r_fox_vr.dmi"
	icon_state = "tail_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

=======
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

>>>>>>> 9f526f32ea7... Merge pull request #8278 from PolarisSS13/cynosure_map
/datum/sprite_accessory/tail/special/foxhc
	name = "fox tail"
	icon_state = "foxtail_hc_s"

/datum/sprite_accessory/tail/special/fennechc
	name = "fennec tail"
	icon_state = "fentail_hc_s"

/datum/sprite_accessory/tail/special/monkeyhc
	name = "monkey tail"
	icon_state = "chimptail_hc_s"

/datum/sprite_accessory/tail/special/tesharitailhc
	name = "teshari tail"
	icon_state = "seromitail_hc_s"

/datum/sprite_accessory/tail/special/tesharitailfeatheredhc
	name = "teshari tail w/ feathers"
	icon_state = "seromitail_feathers_hc_s"

/datum/sprite_accessory/tail/special/vulpan
	name = "canine"
	icon_state = "vulptail_s"

/datum/sprite_accessory/tail/zenghu_taj
	name = "Zeng-Hu Tajaran Synth tail"
	icon_state = "zenghu_taj"
	do_colouration = FALSE // It's cursed anyways

//Taurs moved to a separate file due to extra code around them

/datum/sprite_accessory/tail/tail_smooth
	name = "Smooth Lizard Tail"
	icon_state = "tail_smooth"
	ani_state = "tail_smooth_w"

/datum/sprite_accessory/tail/foxtail
	name = "Fox tail, colourable (vwag)"
	desc = ""
	icon_state = "foxtail"
	extra_overlay = "foxtail-tips"
	do_colouration = TRUE
	color_blend_mode = ICON_MULTIPLY
	ani_state = "foxtail_w"
	extra_overlay_w = "foxtail-tips_w"

/datum/sprite_accessory/tail/triplekitsune_colorable
	name = "Kitsune 3 tails"
	icon_state = "triplekitsune"
	extra_overlay = "triplekitsune_tips"

/datum/sprite_accessory/tail/ninekitsune_colorable
	name = "Kitsune 9 tails"
	icon_state = "ninekitsune"
	extra_overlay = "ninekitsune-tips"
	whitelist_allowed = list() // Too excessive

/datum/sprite_accessory/tail/shadekin_short
	name = "Shadekin Short Tail"
	icon_state = "shadekin-short"
	//species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)

/datum/sprite_accessory/tail/wartacosushi_tail //brightened +20RGB from matching roboparts
	name = "Ward-Takahashi Tail"
	icon_state = "wardtakahashi_vulp"

/datum/sprite_accessory/tail/wartacosushi_tail_dc
	name = "Ward-Takahashi Tail, dual-color"
	icon_state = "wardtakahashi_vulp_dc"
	extra_overlay = "wardtakahashi_vulp_dc_mark"
