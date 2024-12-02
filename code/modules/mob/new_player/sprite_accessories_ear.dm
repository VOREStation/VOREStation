/*
////////////////////////////
/  =--------------------=  /
/  == Ear Definitions  ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/ears
	name = DEVELOPER_WARNING_NAME
	icon = 'icons/mob/human_races/sprite_accessories/ears.dmi'
	do_colouration = 0 // Set to 1 to blend (ICON_ADD) hair color

	color_blend_mode = ICON_ADD // Only appliciable if do_coloration = 1
	var/extra_overlay // Icon state of an additional overlay to blend in.
	var/extra_overlay2
	var/desc = DEVELOPER_WARNING_NAME
	em_block = TRUE

	//species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files

/**
 * Gets the number of color channels we have.
 */
/datum/sprite_accessory/ears/get_color_channel_count()
	if(!do_colouration)
		return 0
	. = 1
	if(extra_overlay)
		. += 1
	if(extra_overlay2)
		. += 1

/datum/sprite_accessory/ears/shadekin
	name = "Shadekin Ears, colorable"
	desc = ""
	icon_state = "shadekin"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	//species_allowed = list() // SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW			//Removing Polaris whitelits, ones we need are defined in our files

/datum/sprite_accessory/ears/taj_ears
	name = "Tajaran Ears"
	icon_state = "ears_plain"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	//species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files
	extra_overlay = "ears_plain-inner"

/datum/sprite_accessory/ears/taj_ears_tall
	name = "Tajaran Tall Ears"
	icon_state = "msai_plain"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	//species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files
	extra_overlay = "msai_plain-inner"

/datum/sprite_accessory/ears/squirrel_orange
	name = "squirel, orange"
	desc = ""
	icon_state = "squirrel-orange"

/datum/sprite_accessory/ears/squirrel_red
	name = "squirrel, red"
	desc = ""
	icon_state = "squirrel-red"

/datum/sprite_accessory/ears/bunny_white
	name = "bunny, white"
	desc = ""
	icon_state = "bunny"

/datum/sprite_accessory/ears/bear_brown
	name = "bear, brown"
	desc = ""
	icon_state = "bear-brown"

/datum/sprite_accessory/ears/bear_panda
	name = "bear, panda"
	desc = ""
	icon_state = "panda"

/datum/sprite_accessory/ears/wolf_grey
	name = "wolf, grey"
	desc = ""
	icon_state = "wolf-grey"

/datum/sprite_accessory/ears/wolf_green
	name = "wolf, green"
	desc = ""
	icon_state = "wolf-green"

/datum/sprite_accessory/ears/wisewolf
	name = "wolf, wise"
	desc = ""
	icon_state = "wolf-wise"

/datum/sprite_accessory/ears/mouse_grey
	name = "mouse, grey"
	desc = ""
	icon_state = "mouse-grey"

/datum/sprite_accessory/ears/bee
	name = "bee antennae"
	desc = ""
	icon_state = "bee"

/datum/sprite_accessory/ears/antennae
	name = "antennae, colorable"
	desc = ""
	icon_state = "antennae"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/curly_bug
	name = "curly antennae, colorable"
	desc = ""
	icon_state = "curly_bug"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/dual_robot
	name = "synth antennae, colorable"
	desc = ""
	icon_state = "dual_robot_antennae"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/right_robot
	name = "right synth, colorable"
	desc = ""
	icon_state = "right_robot_antennae"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/left_robot
	name = "left synth, colorable"
	desc = ""
	icon_state = "left_robot_antennae"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/oni_h1
	name = "oni horns"
	desc = ""
	icon_state = "oni-h1"

/datum/sprite_accessory/ears/oni_h1_c
	name = "oni horns, colorable"
	desc = ""
	icon_state = "oni-h1_c"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/demon_horns1
	name = "demon horns"
	desc = ""
	icon_state = "demon-horns1"

/datum/sprite_accessory/ears/demon_horns1_c
	name = "demon horns, colorable"
	desc = ""
	icon_state = "demon-horns1_c"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/demon_horns2
	name = "demon horns, colorable(outward)"
	desc = ""
	icon_state = "demon-horns2"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/dragon_horns
	name = "dragon horns, colorable"
	desc = ""
	icon_state = "dragon-horns"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/foxears
	name = "highlander zorren ears"
	desc = ""
	icon_state = "foxears"

/datum/sprite_accessory/ears/fenears
	name = "flatland zorren ears"
	desc = ""
	icon_state = "fenears"

/datum/sprite_accessory/ears/sergal //Redundant
	name = "Sergal ears"
	icon_state = "serg_plain_s"

/datum/sprite_accessory/ears/foxearshc
	name = "highlander zorren ears, colorable"
	desc = ""
	icon_state = "foxearshc"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/fenearshc
	name = "flatland zorren ears, colorable"
	desc = ""
	icon_state = "fenearshc"
	extra_overlay = "fenears-inner"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/sergalhc
	name = "Sergal ears, colorable"
	icon_state = "serg_plain_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/mousehc
	name = "mouse, colorable"
	desc = ""
	icon_state = "mouse"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "mouseinner"

/datum/sprite_accessory/ears/mousehcno
	name = "mouse, colorable, no inner"
	desc = ""
	icon_state = "mouse"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/wolfhc
	name = "wolf, colorable"
	desc = ""
	icon_state = "wolf"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "wolfinner"

/datum/sprite_accessory/ears/bearhc
	name = "bear, colorable"
	desc = ""
	icon_state = "bear"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/smallbear
	name = "small bear"
	desc = ""
	icon_state = "smallbear"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/squirrelhc
	name = "squirrel, colorable"
	desc = ""
	icon_state = "squirrel"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/kittyhc
	name = "kitty, colorable"
	desc = ""
	icon_state = "kitty"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "kittyinner"

/datum/sprite_accessory/ears/bunnyhc
	name = "bunny, colorable"
	desc = ""
	icon_state = "bunny"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/antlers
	name = "antlers"
	desc = ""
	icon_state = "antlers"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/antlers_e
	name = "antlers with ears"
	desc = ""
	icon_state = "cow-nohorns"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "antlers_mark"

/datum/sprite_accessory/ears/smallantlers
	name = "small antlers"
	desc = ""
	icon_state = "smallantlers"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/smallantlers_e
	name = "small antlers with ears"
	desc = ""
	icon_state = "smallantlers"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "deer"

/datum/sprite_accessory/ears/deer
	name = "deer ears"
	desc = ""
	icon_state = "deer"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/cow
	name = "cow, horns"
	desc = ""
	icon_state = "cow"

/datum/sprite_accessory/ears/cowc
	name = "cow, horns, colorable"
	desc = ""
	icon_state = "cow-c"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/cow_nohorns
	name = "cow, no horns"
	desc = ""
	icon_state = "cow-nohorns"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/caprahorns
	name = "caprine horns"
	desc = ""
	icon_state = "caprahorns"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/otie
	name = "otie, colorable"
	desc = ""
	icon_state = "otie"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "otie-inner"

/datum/sprite_accessory/ears/donkey
	name = "donkey, colorable"
	desc = ""
	icon_state = "donkey"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "otie-inner"

/datum/sprite_accessory/ears/zears
	name = "jagged ears"
	desc = ""
	icon_state = "zears"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/elfs1
	name = "pointed ears (tall)"
	desc = ""
	icon_state = "elfs"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	//species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files

/datum/sprite_accessory/ears/elfs2
	name = "pointed ears"
	desc = ""
	icon_state = "ears_pointy"
	do_colouration = 1
	//species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files

/datum/sprite_accessory/ears/elfs3
	name = "pointed ears (down)"
	desc = ""
	icon_state = "ears_pointy_down"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	//species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files

/datum/sprite_accessory/ears/elfs4
	name = "pointed ears (long)"
	desc = ""
	icon_state = "ears_pointy_long"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	//species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files

/datum/sprite_accessory/ears/elfs5
	name = "pointed ears (long, down)"
	desc = ""
	icon_state = "ears_pointy_long_down"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	//species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files

/datum/sprite_accessory/ears/sleek
	name = "sleek ears"
	desc = ""
	icon_state = "sleek"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/drake
	name = "drake frills"
	desc = ""
	icon_state = "drake"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/vulp
	name = "vulpkanin, dual-color"
	desc = ""
	icon_state = "vulp"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "vulp-inner"

/datum/sprite_accessory/ears/vulp_short
	name = "vulpkanin short"
	desc = ""
	icon_state = "vulp_terrier"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/vulp_short_dc
	name = "vulpkanin short, dual-color"
	desc = ""
	icon_state = "vulp_terrier"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "vulp_terrier-inner"

/datum/sprite_accessory/ears/vulp_jackal
	name = "vulpkanin thin, dual-color"
	desc = ""
	icon_state = "vulp_jackal"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "vulp_jackal-inner"

/datum/sprite_accessory/ears/bunny_floppy
	name = "floopy bunny ears (colorable)"
	desc = ""
	icon_state = "floppy_bun"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/teshari
	name = "Teshari (colorable fluff)"
	desc = ""
	icon_state = "teshari"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "teshariinner"
	//species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files

/datum/sprite_accessory/ears/tesharihigh
	name = "Teshari upper ears (colorable fluff)"
	desc = ""
	icon_state = "tesharihigh"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "tesharihighinner"
	//species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files

/datum/sprite_accessory/ears/tesharilow
	name = "Teshari lower ears (colorable fluff)"
	desc = ""
	icon_state = "tesharilow"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "tesharilowinner"
	//species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits, ones we need are defined in our files

/datum/sprite_accessory/ears/inkling
	name = "colorable mature inkling hair"
	desc = ""
	icon = 'icons/mob/human_face_alt.dmi'
	icon_state = "inkling-colorable"
	color_blend_mode = ICON_MULTIPLY
	do_colouration = 1

/datum/sprite_accessory/ears/large_dragon
	name = "Large dragon horns"
	desc = ""
	icon_state = "big_liz"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

// Special snowflake ears go below here.
/datum/sprite_accessory/ears/elf_caprine_colorable
	name = "Caprine horns with pointy ears, colorable"
	desc = ""
	icon_state = "elfs"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "caprahorns"

/datum/sprite_accessory/ears/elf_oni_colorable
	name = "oni horns with pointy ears, colorable"
	desc = ""
	icon_state = "elfs"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "oni-h1_c"

/datum/sprite_accessory/ears/elf_demon_colorable
	name = "Demon horns with pointy ears, colorable"
	desc = ""
	icon_state = "elfs"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "demon-horns1_c"

/datum/sprite_accessory/ears/elf_demon_outwards_colorable
	name = "Demon horns with pointy ears, outwards, colourable"
	desc = ""
	icon_state = "elfs"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "demon-horns2"

/datum/sprite_accessory/ears/elf_dragon_colorable
	name = "Dragon horns with pointy ears, colourable"
	desc = ""
	icon_state = "elfs"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "dragon-horns"

/datum/sprite_accessory/ears/zorgoia
	name = "Zorgoia ears"
	desc = ""
	icon = 'icons/mob/human_races/sprite_accessories/ears.dmi'
	icon_state = "zorgoia"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "zorgoia_inner"
	extra_overlay2 = "zorgoia_tips"
