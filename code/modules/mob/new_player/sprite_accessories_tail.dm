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
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)
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

	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

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
	species_allowed = list(SPECIES_TAJ, SPECIES_UNATHI, SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

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
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

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
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/nevreandc
	name = "nevrean tail, dual-color"
	desc = ""
	icon_state = "nevreantail_dc"
	extra_overlay = "nevreantail_dc_tail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
=======
	whitelist_allowed = list()
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

/datum/sprite_accessory/tail/wagtail/dc
	name = "avian wagtail, dual-color"
	extra_overlay = "wagtail_dc_tail"
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
=======
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

/datum/sprite_accessory/tail/nevreanwagdc_alt
	name = "avian wagtail, marked, dual-color"
	icon_state = "wagtail2_dc"
	extra_overlay = "wagtail2_dc_mark"
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
=======
	whitelist_allowed = list()
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

/datum/sprite_accessory/tail/crossfox
	name = "cross fox"
	do_colouration = FALSE // DOING IT WRONG
	icon_state = "crossfox"

<<<<<<< HEAD
/datum/sprite_accessory/tail/beethorax
	name = "bee thorax"
	desc = ""
	icon_state = "beethorax"

=======
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)
/datum/sprite_accessory/tail/doublekitsune
	name = "double kitsune tail"
	icon_state = "doublekitsune"

/datum/sprite_accessory/tail/spade_color
	name = "demon tail"
	icon_state = "spadetail-black"
<<<<<<< HEAD
	do_colouration = 1

/datum/sprite_accessory/tail/snag
	name = "xenomorph tail 1"
	desc = ""
	icon_state = "snag"

/datum/sprite_accessory/tail/xenotail
	name = "xenomorph tail 2"
	desc = ""
	icon_state = "xenotail"
=======
	color_blend_mode = ICON_ADD
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

/datum/sprite_accessory/tail/eboop
	name = "EGN mech tail (dual color)"
	icon_state = "eboop"
	extra_overlay = "eboop_mark"
<<<<<<< HEAD

/datum/sprite_accessory/tail/ketrai_wag
	name = "fennix tail (vwag)"
	desc = ""
	icon_state = "ketraitail"
	ani_state = "ketraitail_w"
	//ckeys_allowed = list("ketrai") //They requested it to be enabled for everyone.

/datum/sprite_accessory/tail/ketrainew_wag
	name = "new fennix tail (vwag)"
	desc = ""
	icon_state = "ketraitailnew"
	ani_state = "ketraitailnew_w"

/datum/sprite_accessory/tail/redpanda
	name = "red panda"
	desc = ""
	icon_state = "redpanda"
=======
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

/datum/sprite_accessory/tail/ringtail
	name = "ringtail"
	icon_state = "ringtail"
	extra_overlay = "ringtail_mark"
<<<<<<< HEAD

/datum/sprite_accessory/tail/satyr
	name = "goat legs, colorable"
	desc = ""
	icon_state = "satyr"
	color_blend_mode = ICON_MULTIPLY
	do_colouration = 1
	hide_body_parts = list(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT) //Exclude pelvis just in case.
	clip_mask_icon = 'icons/mob/human_races/sprite_accessories/taurs.dmi'
	clip_mask_state = "taur_clip_mask_def" //Used to clip off the lower part of suits & uniforms.

/datum/sprite_accessory/tail/tailmaw
	name = "tailmaw, colorable"
	desc = ""
	icon_state = "tailmaw"
	color_blend_mode = ICON_MULTIPLY
	do_colouration = 1
=======
	whitelist_allowed = list() // Too excessive
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

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
<<<<<<< HEAD

=======
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

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
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/newtailmaw
	name = "new tailmaw (vwag)"
	desc = ""
	icon_state = "newtailmaw"
	ani_state = "newtailmaw_w"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
=======
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

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
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/sergaltaildc
	name = "sergal, dual-color"
	desc = ""
	icon_state = "sergal"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "sergal_mark"
=======
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

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
	species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

<<<<<<< HEAD
/datum/sprite_accessory/tail/nightstalker
	name = "Nightstalker, colorable"
	desc = ""
	icon_state = "nightstalker"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

=======
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)
//For all species tails. Includes haircolored tails.
/datum/sprite_accessory/tail/special
	name = "Blank tail. Do not select."
	icon = 'icons/effects/species_tails.dmi'

/datum/sprite_accessory/tail/special/unathi
	name = "unathi tail"
	icon_state = "sogtail_s"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/tail/special/tajaran
	name = "tajaran tail"
	icon_state = "tajtail_s"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
<<<<<<< HEAD

/datum/sprite_accessory/tail/special/sergal
	name = "sergal tail"
	desc = ""
	icon_state = "sergtail_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/special/akula
	name = "akula tail"
	desc = ""
	icon_state = "sharktail_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/special/nevrean
	name = "nevrean tail"
	desc = ""
	icon_state = "nevreantail_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

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
=======
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

/datum/sprite_accessory/tail/special/monkey
	name = "monkey tail"
	icon_state = "chimptail_s"

/datum/sprite_accessory/tail/special/tesharitail
	name = "teshari tail"
	icon_state = "seromitail_s"
	species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/tail/special/tesharitailfeathered
	name = "teshari tail w/ feathers"
	icon_state = "seromitail_s"
	extra_overlay = "seromitail_feathers_s"
	species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/tail/special/unathihc
	name = "unathi tail"
	icon_state = "sogtail_hc_s"
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/tail/special/tajaranhc
	name = "tajaran tail"
	icon_state = "tajtail_hc_s"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

<<<<<<< HEAD
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
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)
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
<<<<<<< HEAD

//Taurs moved to a separate file due to extra code around them

//Buggo Abdomens!

/datum/sprite_accessory/tail/buggo
	name = "Bug abdomen, colorable"
	desc = ""
	icon_state = "buggo_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/buggobee
	name = "Bug abdomen, bee top, dual-colorable"
	desc = ""
	icon_state = "buggo_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggobee_markings"

/datum/sprite_accessory/tail/buggobeefull
	name = "Bug abdomen, bee full, dual-colorable"
	desc = ""
	icon_state = "buggo_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggobeefull_markings"

/datum/sprite_accessory/tail/buggounder
	name = "Bug abdomen, underside, dual-colorable"
	desc = ""
	icon_state = "buggo_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggounder_markings"

/datum/sprite_accessory/tail/buggofirefly
	name = "Bug abdomen, firefly, dual-colorable"
	desc = ""
	icon_state = "buggo_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggofirefly_markings"

/datum/sprite_accessory/tail/buggofat
	name = "Fat bug abdomen, colorable"
	desc = ""
	icon_state = "buggofat_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/buggofatbee
	name = "Fat bug abdomen, bee top, dual-colorable"
	desc = ""
	icon_state = "buggofat_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggofatbee_markings"

/datum/sprite_accessory/tail/buggofatbeefull
	name = "Fat bug abdomen, bee full, dual-colorable"
	desc = ""
	icon_state = "buggofat_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggofatbeefull_markings"

/datum/sprite_accessory/tail/buggofatunder
	name = "Fat bug abdomen, underside, dual-colorable"
	desc = ""
	icon_state = "buggofat_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggofatunder_markings"

/datum/sprite_accessory/tail/buggofatfirefly
	name = "Fat bug abdomen, firefly, dual-colorable"
	desc = ""
	icon_state = "buggofat_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggofatfirefly_markings"

/datum/sprite_accessory/tail/buggowag
	name = "Bug abdomen, colorable, vwag change"
	desc = ""
	icon_state = "buggo_s"
	ani_state = "buggofat_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/buggobeewag
	name = "Bug abdomen, bee top, dual color, vwag"
	desc = ""
	icon_state = "buggo_s"
	ani_state = "buggofat_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggobee_markings"
	extra_overlay_w = "buggofatbee_markings"

/datum/sprite_accessory/tail/buggobeefullwag
	name = "Bug abdomen, bee full, dual color, vwag"
	desc = ""
	icon_state = "buggo_s"
	ani_state = "buggofat_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggobeefull_markings"
	extra_overlay_w = "buggofatbeefull_markings"

/datum/sprite_accessory/tail/buggounderwag
	name = "Bug abdomen, underside, dual color, vwag"
	desc = ""
	icon_state = "buggo_s"
	ani_state = "buggofat_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggounder_markings"
	extra_overlay_w = "buggofatunder_markings"

/datum/sprite_accessory/tail/buggofireflywag
	name = "Bug abdomen, firefly, dual color, vwag"
	desc = ""
	icon_state = "buggo_s"
	ani_state = "buggofat_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggofirefly_markings"
	extra_overlay_w = "buggofatfirefly_markings"

//Vass buggo variants!

/datum/sprite_accessory/tail/buggovass
	name = "Bug abdomen, vass, colorable"
	desc = ""
	icon_state = "buggo_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/buggovassbee
	name = "Bug abdomen, bee top, dc, vass"
	desc = ""
	icon_state = "buggo_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggobee_vass_markings"

/datum/sprite_accessory/tail/buggovassbeefull
	name = "Bug abdomen, bee full, dc, vass"
	desc = ""
	icon_state = "buggo_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggobeefull_vass_markings"

/datum/sprite_accessory/tail/buggovassunder
	name = "Bug abdomen, underside, dc, vass"
	desc = ""
	icon_state = "buggo_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggounder_vass_markings"

/datum/sprite_accessory/tail/buggovassfirefly
	name = "Bug abdomen, firefly, dc, vass"
	desc = ""
	icon_state = "buggo_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggofirefly_vass_markings"

/datum/sprite_accessory/tail/buggovassfat
	name = "Fat bug abdomen, vass, colorable"
	desc = ""
	icon_state = "buggofat_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/buggovassfatbee
	name = "Fat bug abdomen, bee top, dc, vass"
	desc = ""
	icon_state = "buggofat_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggofatbee_vass_markings"

/datum/sprite_accessory/tail/buggovassfatbeefull
	name = "Fat bug abdomen, bee full, dc, vass"
	desc = ""
	icon_state = "buggofat_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggofatbeefull_vass_markings"

/datum/sprite_accessory/tail/buggovassfatunder
	name = "Fat bug abdomen, underside, dc, vass"
	desc = ""
	icon_state = "buggofat_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggofatunder_vass_markings"

/datum/sprite_accessory/tail/buggovassfatfirefly
	name = "Fat bug abdomen, firefly, dc, vass"
	desc = ""
	icon_state = "buggofat_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggofatfirefly_vass_markings"

/datum/sprite_accessory/tail/buggovasswag
	name = "Bug abdomen, vass, colorable, vwag change"
	desc = ""
	icon_state = "buggo_vass_s"
	ani_state = "buggofat_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/buggovassbeewag
	name = "Bug abdomen, bee top, dc, vass, vwag"
	desc = ""
	icon_state = "buggo_vass_s"
	ani_state = "buggofat_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggobee_vass_markings"
	extra_overlay_w = "buggofatbee_vass_markings"

/datum/sprite_accessory/tail/buggovassbeefullwag
	name = "Bug abdomen, bee full, dc, vass, vwag"
	desc = ""
	icon_state = "buggo_vass_s"
	ani_state = "buggofat_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggobeefull_vass_markings"
	extra_overlay_w = "buggofatbeefull_vass_markings"

/datum/sprite_accessory/tail/buggovassunderwag
	name = "Bug abdomen, underside, dc, vass, vwag"
	desc = ""
	icon_state = "buggo_vass_s"
	ani_state = "buggofat_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggounder_vass_markings"
	extra_overlay_w = "buggofatunder_vass_markings"

/datum/sprite_accessory/tail/buggovassfireflywag
	name = "Bug abdomen, firefly, dc, vass, vwag"
	desc = ""
	icon_state = "buggo_vass_s"
	ani_state = "buggofat_vass_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "buggofirefly_vass_markings"
	extra_overlay_w = "buggofatfirefly_vass_markings"

=======
	do_colouration = FALSE // It's cursed anyways

//Taurs moved to a separate file due to extra code around them

>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)
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
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
=======
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

/datum/sprite_accessory/tail/wartacosushi_tail_dc
	name = "Ward-Takahashi Tail, dual-color"
	icon_state = "wardtakahashi_vulp_dc"
	extra_overlay = "wardtakahashi_vulp_dc_mark"
