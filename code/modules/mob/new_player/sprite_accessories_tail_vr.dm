/*
////////////////////////////
/  =--------------------=  /
/  == Tail Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/tail
	name = "You should not see this..."
	icon = 'icons/mob/vore/tails_vr.dmi'
	do_colouration = 0 //Set to 1 to enable coloration using the tail color.
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW) //This lets all races use

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

/datum/sprite_accessory/tail/squirrel_orange
	name = "squirel, orange"
	desc = ""
	icon_state = "squirrel-orange"

/datum/sprite_accessory/tail/squirrel_red
	name = "squirrel, red"
	desc = ""
	icon_state = "squirrel-red"

/datum/sprite_accessory/tail/squirrel
	name = "squirrel, colorable"
	desc = ""
	icon_state = "squirrel"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/kitty
	name = "kitty, colorable, downwards"
	desc = ""
	icon_state = "kittydown"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/kittyup
	name = "kitty, colorable, upwards"
	desc = ""
	icon_state = "kittyup"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/tiger_white
	name = "tiger, colorable"
	desc = ""
	icon_state = "tiger"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "tigerinnerwhite"

/datum/sprite_accessory/tail/stripey
	name = "stripey taj, colorable"
	desc = ""
	icon_state = "stripeytail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "stripeytail_mark"

/datum/sprite_accessory/tail/stripeytail_brown
	name = "stripey taj, brown"
	desc = ""
	icon_state = "stripeytail-brown"

/datum/sprite_accessory/tail/chameleon
	name = "Chameleon, colorable"
	desc = ""
	icon_state = "chameleon"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/bunny
	name = "bunny, colorable"
	desc = ""
	icon_state = "bunny"
	do_colouration = 1

/datum/sprite_accessory/tail/bear_brown
	name = "bear, brown"
	desc = ""
	icon_state = "bear-brown"

/datum/sprite_accessory/tail/bear
	name = "bear, colorable"
	desc = ""
	icon_state = "bear"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/dragon
	name = "dragon, colorable"
	desc = ""
	icon_state = "dragon"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/wolf_grey
	name = "wolf, grey"
	desc = ""
	icon_state = "wolf-grey"

/datum/sprite_accessory/tail/wolf_green
	name = "wolf, green"
	desc = ""
	icon_state = "wolf-green"

/datum/sprite_accessory/tail/wisewolf
	name = "wolf, wise"
	desc = ""
	icon_state = "wolf-wise"

/datum/sprite_accessory/tail/blackwolf
	name = "wolf, black"
	desc = ""
	icon_state = "wolf"

/datum/sprite_accessory/tail/wolf
	name = "wolf, colorable"
	desc = ""
	icon_state = "wolf"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "wolfinner"

/datum/sprite_accessory/tail/mouse_pink
	name = "mouse, pink"
	desc = ""
	icon_state = "mouse-pink"

/datum/sprite_accessory/tail/mouse
	name = "mouse, colorable"
	desc = ""
	icon_state = "mouse"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/horse
	name = "horse tail, colorable"
	desc = ""
	icon_state = "horse"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/cow
	name = "cow tail, colorable"
	desc = ""
	icon_state = "cow"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/fantail
	name = "avian fantail, colorable"
	desc = ""
	icon_state = "fantail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/wagtail
	name = "avian wagtail, colorable"
	desc = ""
	icon_state = "wagtail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/nevreandc
	name = "nevrean tail, dual-color"
	desc = ""
	icon_state = "nevreantail_dc"
	extra_overlay = "nevreantail_dc_tail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/nevreanwagdc
	name = "nevrean wagtail, dual-color"
	desc = ""
	icon_state = "wagtail"
	extra_overlay = "wagtail_dc_tail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/nevreanwagdc_alt
	name = "nevrean wagtail, marked, dual-color"
	desc = ""
	icon_state = "wagtail2_dc"
	extra_overlay = "wagtail2_dc_mark"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/crossfox
	name = "cross fox"
	desc = ""
	icon_state = "crossfox"

/datum/sprite_accessory/tail/beethorax
	name = "bee thorax"
	desc = ""
	icon_state = "beethorax"

/datum/sprite_accessory/tail/doublekitsune
	name = "double kitsune tail, colorable"
	desc = ""
	icon_state = "doublekitsune"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/spade_color
	name = "spade-tail (colorable)"
	desc = ""
	icon_state = "spadetail-black"
	do_colouration = 1

/datum/sprite_accessory/tail/snag
	name = "xenomorph tail 1"
	desc = ""
	icon_state = "snag"

/datum/sprite_accessory/tail/xenotail
	name = "xenomorph tail 2"
	desc = ""
	icon_state = "xenotail"

/datum/sprite_accessory/tail/eboop
	name = "EGN mech tail (dual color)"
	desc = ""
	icon_state = "eboop"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "eboop_mark"

/datum/sprite_accessory/tail/molenar_kitsune
	name = "quintail kitsune tails (Molenar)"
	desc = ""
	icon_state = "molenar-kitsune"
	ckeys_allowed = list("molenar")

/datum/sprite_accessory/tail/miria_fluffdragon
	name = "fluffdragon tail (Miria Masters)"
	desc = ""
	icon_state = "miria-fluffdragontail"
	ckeys_allowed = list("miriamasters")

/datum/sprite_accessory/tail/miria_kitsune
	name = "Black kitsune tails (Miria Masters)"
	desc = ""
	icon_state = "miria-kitsunetail"
	ckeys_allowed = list("miriamasters")

/datum/sprite_accessory/tail/molenar_deathclaw
	name = "deathclaw bits (Molenar)"
	desc = ""
	icon_state = "molenar-deathclaw"
	ckeys_allowed = list("molenar","silvertalismen","jertheace")

/datum/sprite_accessory/tail/runac
	name = "fennecsune tails (Runac)"
	desc = ""
	icon_state = "runac"
	ckeys_allowed = list("rebcom1807")

/datum/sprite_accessory/tail/reika //Leaving this since it was too hard to split the wings from the tail.
	name = "fox tail (+ beewings) (Reika)"
	desc = ""
	icon_state = "reika"
	ckeys_allowed = list("rikaru19xjenkins")

/datum/sprite_accessory/tail/rosey
	name = "tritail kitsune tails (Rosey)"
	desc = ""
	icon_state = "rosey_three"
	ckeys_allowed = list("joey4298")

/datum/sprite_accessory/tail/rosey2
	name = "pentatail kitsune tails (Rosey)" //I predict seven tails next. ~CK
	desc = ""
	icon_state = "rosey_five"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	ckeys_allowed = list("joey4298")

/datum/sprite_accessory/tail/scree
	name = "green taj tail (Scree)"
	desc = ""
	icon_state = "scree"
	ckeys_allowed = list("scree")

/datum/sprite_accessory/tail/aronai
	name = "aronai tail (Aronai)"
	desc = ""
	icon_state = "aronai"
	ckeys_allowed = list("arokha")

/datum/sprite_accessory/tail/cabletail
    name = "cabletail"
    desc = "cabletail"
    icon_state = "cabletail"
    ckeys_allowed = list("tucker0666")

/datum/sprite_accessory/tail/featherfluff_tail
    name = "featherfluff_tail"
    desc = ""
    icon_state = "featherfluff_tail"
    ckeys_allowed = list("tucker0666")

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

/datum/sprite_accessory/tail/ringtail
	name = "ringtail, colorable"
	desc = ""
	icon_state = "ringtail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "ringtail_mark"

/datum/sprite_accessory/tail/holly
	name = "tigress tail (Holly)"
	desc = ""
	icon_state = "tigresstail"
	ckeys_allowed = list("hoodoo")

/datum/sprite_accessory/tail/satyr
	name = "goat legs, colorable"
	desc = ""
	icon_state = "satyr"
	color_blend_mode = ICON_MULTIPLY
	do_colouration = 1
	hide_body_parts = list(BP_L_LEG, BP_L_FOOT, BP_R_LEG, BP_R_FOOT) //Exclude pelvis just in case.
	clip_mask_icon = 'icons/mob/vore/taurs_vr.dmi'
	clip_mask_state = "taur_clip_mask_def" //Used to clip off the lower part of suits & uniforms.

/datum/sprite_accessory/tail/tailmaw
	name = "tailmaw, colorable"
	desc = ""
	icon_state = "tailmaw"
	color_blend_mode = ICON_MULTIPLY
	do_colouration = 1

/datum/sprite_accessory/tail/curltail
	name = "curltail (vwag)"
	desc = ""
	icon_state = "curltail"
	ani_state = "curltail_w"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "curltail_mark"
	extra_overlay_w = "curltail_mark_w"

/datum/sprite_accessory/tail/shorttail
	name = "shorttail (vwag)"
	desc = ""
	icon_state = "straighttail"
	ani_state = "straighttail_w"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/sneptail
	name = "Snep/Furry Tail (vwag)"
	desc = ""
	icon_state = "sneptail"
	ani_state = "sneptail_w"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "sneptail_mark"
	extra_overlay_w = "sneptail_mark_w"


/datum/sprite_accessory/tail/tiger_new
	name = "tiger tail (vwag)"
	desc = ""
	icon_state = "tigertail"
	ani_state = "tigertail_w"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "tigertail_mark"
	extra_overlay_w = "tigertail_mark_w"

/datum/sprite_accessory/tail/vulp_new
	name = "new vulp tail (vwag)"
	desc = ""
	icon_state = "vulptail"
	ani_state = "vulptail_w"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "vulptail_mark"
	extra_overlay_w = "vulptail_mark_w"

/datum/sprite_accessory/tail/otietail
	name = "otie tail (vwag)"
	desc = ""
	icon_state = "otie"
	ani_state = "otie_w"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/newtailmaw
	name = "new tailmaw (vwag)"
	desc = ""
	icon_state = "newtailmaw"
	ani_state = "newtailmaw_w"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/ztail
	name = "jagged flufftail"
	desc = ""
	icon_state = "ztail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/snaketail
	name = "snake tail, colorable"
	desc = ""
	icon_state = "snaketail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/vulpan_alt
	name = "vulpkanin alt style, colorable"
	desc = ""
	icon_state = "vulptail_alt"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/sergaltaildc
	name = "sergal, dual-color"
	desc = ""
	icon_state = "sergal"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "sergal_mark"

/datum/sprite_accessory/tail/skunktail
	name = "skunk, dual-color"
	desc = ""
	icon_state = "skunktail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "skunktail_mark"

/datum/sprite_accessory/tail/deertail
	name = "deer, dual-color"
	desc = ""
	icon_state = "deertail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "deertail_mark"

/datum/sprite_accessory/tail/tesh_feathered
	name = "Teshari tail"
	desc = ""
	icon_state = "teshtail_s"
	do_colouration = 1
	extra_overlay = "teshtail_feathers_s"
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/teshari_fluffytail
	name = "Teshari alternative, colorable"
	desc = ""
	icon_state = "teshari_fluffytail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "teshari_fluffytail_mark"

/datum/sprite_accessory/tail/tesh_pattern_male
	name = "Teshari male tail pattern"
	desc = ""
	icon_state = "teshtail_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "teshpattern_male_tail"

/datum/sprite_accessory/tail/tesh_pattern_male_alt
	name = "Teshari male tail alt. pattern"
	desc = ""
	icon_state = "teshtail_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "teshpattern_male_alt"

/datum/sprite_accessory/tail/tesh_pattern_fem
	name = "Teshari female tail pattern"
	desc = ""
	icon_state = "teshtail_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "teshpattern_fem_tail"

/datum/sprite_accessory/tail/tesh_pattern_fem_alt
	name = "Teshari male tail alt. pattern"
	desc = ""
	icon_state = "teshtail_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "teshpattern_fem_alt"

/datum/sprite_accessory/tail/nightstalker
	name = "Nightstalker, colorable"
	desc = ""
	icon_state = "nightstalker"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

//For all species tails. Includes haircolored tails.
/datum/sprite_accessory/tail/special
	name = "Blank tail. Do not select."
	icon = 'icons/effects/species_tails_vr.dmi'

/datum/sprite_accessory/tail/special/unathi
	name = "unathi tail"
	desc = ""
	icon_state = "sogtail_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/special/tajaran
	name = "tajaran tail"
	desc = ""
	icon_state = "tajtail_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

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

/datum/sprite_accessory/tail/special/monkey
	name = "monkey tail"
	desc = ""
	icon_state = "chimptail_s"

/datum/sprite_accessory/tail/special/unathihc
	name = "unathi tail, colorable"
	desc = ""
	icon_state = "sogtail_hc_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/special/tajaranhc
	name = "tajaran tail, colorable"
	desc = ""
	icon_state = "tajtail_hc_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

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

/datum/sprite_accessory/tail/special/foxhc
	name = "highlander zorren tail, colorable"
	desc = ""
	icon_state = "foxtail_hc_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/special/fennechc
	name = "flatland zorren tail, colorable"
	desc = ""
	icon_state = "fentail_hc_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/special/armalishc
	name = "armalis tail, colorable"
	desc = ""
	icon_state = "armalis_tail_humanoid_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/xenodronehc
	name = "xenomorph drone tail, colorable"
	desc = ""
	icon_state = "xenos_drone_tail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/xenosentinelhc
	name = "xenomorph sentinel tail, colorable"
	desc = ""
	icon_state = "xenos_sentinel_tail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/xenohunterhc
	name = "xenomorph hunter tail, colorable"
	desc = ""
	icon_state = "xenos_hunter_tail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/xenoqueenhc
	name = "xenomorph queen tail, colorable"
	desc = ""
	icon_state = "xenos_queen_tail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/monkeyhc
	name = "monkey tail, colorable"
	desc = ""
	icon_state = "chimptail_hc_s"
	do_colouration = 1

/datum/sprite_accessory/tail/special/vulpan
	name = "vulpkanin, colorable"
	desc = ""
	icon_state = "vulptail_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY


/datum/sprite_accessory/tail/zenghu_taj
	name = "Zeng-Hu Tajaran Synth tail"
	desc = ""
	icon_state = "zenghu_taj"

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

/datum/sprite_accessory/tail/tail_smooth
	name = "Smooth Lizard Tail, colorable"
	desc = ""
	icon_state = "tail_smooth"
	ani_state = "tail_smooth_w"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/triplekitsune_colorable
	name = "Kitsune 3 tails, colorable"
	desc = ""
	icon_state = "triplekitsune"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "triplekitsune_tips"

/datum/sprite_accessory/tail/ninekitsune_colorable
	name = "Kitsune 9 tails, colorable"
	desc = ""
	icon_state = "ninekitsune"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "ninekitsune-tips"

/datum/sprite_accessory/tail/shadekin_short
	name = "Shadekin Short Tail, colorable"
	desc = ""
	icon_state = "shadekin-short"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	//apply_restrictions = TRUE
	//species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)

/datum/sprite_accessory/tail/wartacosushi_tail //brightened +20RGB from matching roboparts
	name = "Ward-Takahashi Tail"
	desc = ""
	icon_state = "wardtakahashi_vulp"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/wartacosushi_tail_dc
	name = "Ward-Takahashi Tail, dual-color"
	desc = ""
	icon_state = "wardtakahashi_vulp_dc"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "wardtakahashi_vulp_dc_mark"

/datum/sprite_accessory/tail/Easterntail
	name = "Eastern Dragon (Animated)"
	desc = ""
	icon_state = "Easterntail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "EasterntailColorTip"
	ani_state = "Easterntail_w"
	extra_overlay_w = "EasterntailColorTip_w"

/datum/sprite_accessory/tail/synthtail_static
	name = "Synthetic lizard tail"
	desc = ""
	icon_state = "synthtail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/synthtail_vwag
	name = "Synthetic lizard tail (vwag)"
	desc = ""
	icon_state = "synthtail"
	ani_state = "synthtail_w"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/Plugtail
	name = "Synthetic plug tail"
	desc = ""
	icon_state = "Plugtail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "PlugtailMarking"
	extra_overlay2 = "PlugtailMarking2"

/datum/sprite_accessory/tail/Segmentedtail
	name = "Segmented tail, animated"
	desc = ""
	icon_state = "Segmentedtail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "Segmentedtailmarking"
	ani_state = "Segmentedtail_w"
	extra_overlay_w = "Segmentedtailmarking_w"

/datum/sprite_accessory/tail/Segmentedlights
	name = "Segmented tail, animated synth"
	desc = ""
	icon_state = "Segmentedtail"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "Segmentedlights"
	ani_state = "Segmentedtail_w"
	extra_overlay_w = "Segmentedlights_w"

/datum/sprite_accessory/tail/fox_tail
	name = "Fox tail"
	desc = ""
	icon_state = "fox_tail_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/fox_tail_plain
	name = "Fox tail"
	desc = ""
	icon_state = "fox_tail_plain_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/fennec_tail
	name = "Fennec tail"
	desc = ""
	icon_state = "fennec_tail_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/lizard_tail_smooth
	name = "Lizard Tail (Smooth)"
	desc = ""
	icon_state = "lizard_tail_smooth"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/lizard_tail_dark_tiger
	name = "Lizard Tail (Dark Tiger)"
	desc = ""
	icon_state = "lizard_tail_dark_tiger"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/lizard_tail_light_tiger
	name = "Lizard Tail (Light Tiger)"
	desc = ""
	icon_state = "lizard_tail_light_tiger"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/lizard_tail_spiked
	name = "Lizard Tail (Spiked)"
	desc = ""
	icon_state = "lizard_tail_spiked"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/xenotail_fullcolour
	name = "xenomorph tail (fully colourable)"
	desc = ""
	icon_state = "xenotail_fullcolour"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/xenotailalt_fullcolour
	name = "xenomorph tail alt. (fully colourable)"
	desc = ""
	icon_state = "xenotailalt_fullcolour"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/tail/peacocktail_red //this is ckey locked for now, but prettiebyrd wants these tails to be unlocked at a later date
	name = "Peacock tail (vwag)"
	desc = ""
	icon = 'icons/mob/vore/tails_vr.dmi'
	icon_state = "peacocktail_red"
	ani_state = "peacocktail_red_w"
	ckeys_allowed = list("prettiebyrd")

/datum/sprite_accessory/tail/peacocktail //ditto
	name = "Peacock tail, colorable (vwag)"
	desc = ""
	icon = 'icons/mob/vore/tails_vr.dmi'
	icon_state = "peacocktail"
	ani_state = "peacocktail_w"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	ckeys_allowed = list("prettiebyrd")

/datum/sprite_accessory/tail/tentacle
	name = "Tentacle, colorable (vwag)"
	desc = ""
	icon = 'icons/mob/vore/tails_vr.dmi'
	icon_state = "tentacle"
	ani_state = "tentacle_w"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY