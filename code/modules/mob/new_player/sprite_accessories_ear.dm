/*
////////////////////////////
/  =--------------------=  /
/  == Ear Definitions  ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/ears
	name = "You should not see this..."
	icon = 'icons/mob/human_races/sprite_accessories/ears.dmi'
	do_colouration = TRUE // If you're overrding this you're doing it wrong
	color_blend_mode = ICON_MULTIPLY // Only appliciable if do_coloration = 1
	var/extra_overlay // Icon state of an additional overlay to blend in.
	var/extra_overlay2
<<<<<<< HEAD
	var/desc = "You should not see this..."
	em_block = TRUE
=======
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

	species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/ears/shadekin
	name = "Shadekin Ears"
	icon_state = "shadekin"
	species_allowed = list() // SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW
<<<<<<< HEAD
=======
	whitelist_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_PROMETHEAN)
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

/datum/sprite_accessory/ears/taj_ears
	name = "Tajaran Ears"
	icon_state = "ears_plain"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	extra_overlay = "ears_plain-inner"

/datum/sprite_accessory/ears/taj_ears_tall
	name = "Tajaran Tall Ears"
	icon_state = "msai_plain"
	species_allowed = list(SPECIES_TAJ, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	extra_overlay = "msai_plain-inner"

/datum/sprite_accessory/ears/antennae
	name = "antennae"
	icon_state = "antennae"

/datum/sprite_accessory/ears/curly_bug
	name = "curly antennae"
	icon_state = "curly_bug"

/datum/sprite_accessory/ears/dual_robot
	name = "synth antennae"
	icon_state = "dual_robot_antennae"

/datum/sprite_accessory/ears/right_robot
	name = "right synth"

	icon_state = "right_robot_antennae"

/datum/sprite_accessory/ears/left_robot
	name = "left synth"
	icon_state = "left_robot_antennae"

/datum/sprite_accessory/ears/oni_h1
	name = "oni horns"
	icon_state = "oni-h1_c"

/datum/sprite_accessory/ears/demon_horns1
	name = "demon horns"
	icon_state = "demon-horns1_c"

/datum/sprite_accessory/ears/demon_horns2
	name = "demon horns (outward)"
	icon_state = "demon-horns2"

/datum/sprite_accessory/ears/foxears
<<<<<<< HEAD
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
=======
	name = "fox ears"
	icon_state = "foxearshc"
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

/datum/sprite_accessory/ears/fenears
	name = "fennec ears"
	icon_state = "fenearshc"
	extra_overlay = "fenears-inner"
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
=======
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

/datum/sprite_accessory/ears/sergal
	name = "fluffy ears"
	icon_state = "serg_plain_s"
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
=======
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

/datum/sprite_accessory/ears/mouse
	name = "mouse (monotone)"
	icon_state = "mouse"

/datum/sprite_accessory/ears/mouse/dual
	name = "mouse (dual tone)"
	extra_overlay = "mouseinner"

/datum/sprite_accessory/ears/wolf
	name = "wolf"
	icon_state = "wolf"
	extra_overlay = "wolfinner"

/datum/sprite_accessory/ears/bear
	name = "bear"
	icon_state = "bear"

/datum/sprite_accessory/ears/smallbear
	name = "small bear"
	icon_state = "smallbear"

/datum/sprite_accessory/ears/squirrel
	name = "squirrel"
	icon_state = "squirrel"

/datum/sprite_accessory/ears/kitty
	name = "kitty"
	icon_state = "kitty"
	extra_overlay = "kittyinner"

/datum/sprite_accessory/ears/bunny
	name = "bunny"
	icon_state = "bunny"

/datum/sprite_accessory/ears/antlers
	name = "antlers"
	icon_state = "antlers"

/datum/sprite_accessory/ears/smallantlers
	name = "small antlers"
	icon_state = "smallantlers"

/datum/sprite_accessory/ears/deer
	name = "deer ears"
	icon_state = "deer"

/datum/sprite_accessory/ears/deer/antlers
	name = "small antlers with ears"
	extra_overlay = "smallantlers"

/datum/sprite_accessory/ears/cow_horns
	name = "cow horns"
	icon_state = "cow-c"

/datum/sprite_accessory/ears/cow
	name = "cow ears"
	icon_state = "cow-nohorns"

/datum/sprite_accessory/ears/cow/antlers
	name = "antlers with ears"
	extra_overlay = "antlers_mark"

/datum/sprite_accessory/ears/caprahorns
	name = "caprine horns"
	icon_state = "caprahorns"

/datum/sprite_accessory/ears/otie
	name = "otie"
	icon_state = "otie"
	extra_overlay = "otie-inner"

/datum/sprite_accessory/ears/donkey
	name = "donkey"
	icon_state = "donkey"
	extra_overlay = "otie-inner"

/datum/sprite_accessory/ears/elf
	name = "pointed ears (tall)"
	icon_state = "elfs"
	species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

<<<<<<< HEAD
/datum/sprite_accessory/ears/elfs1
	name = "pointed ears (tall)"
	desc = ""
	icon_state = "elfs"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/ears/elfs2
	name = "pointed ears"
	desc = ""
	icon_state = "ears_pointy"
	do_colouration = 1
=======
/datum/sprite_accessory/ears/elf2
	name = "pointed ears"
	icon_state = "ears_pointy"
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)
	species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/ears/elf3
	name = "pointed ears (down)"
	icon_state = "ears_pointy_down"
	species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/ears/elf4
	name = "pointed ears (long)"
	icon_state = "ears_pointy_long"
	species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/ears/elf5
	name = "pointed ears (long, down)"
	icon_state = "ears_pointy_long_down"
	species_allowed = list(SPECIES_HUMAN, SPECIES_HUMAN_VATBORN, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/ears/sleek
	name = "sleek ears"
	icon_state = "sleek"

/datum/sprite_accessory/ears/drake
	name = "frills"
	icon_state = "drake"
<<<<<<< HEAD
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
=======
	species_allowed = list(SPECIES_UNATHI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)
	whitelist_allowed = list(SPECIES_PROMETHEAN)
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)

/datum/sprite_accessory/ears/vulp
	name = "canine (dual tone)"
	icon_state = "vulp"
	extra_overlay = "vulp-inner"

/datum/sprite_accessory/ears/vulp_short
	name = "canine short"
	icon_state = "vulp_terrier"

/datum/sprite_accessory/ears/vulp_short/dc
	name = "canine short (dual tone)"
	extra_overlay = "vulp_terrier-inner"

/datum/sprite_accessory/ears/vulp_jackal
	name = "canine thin (dual tone)"
	icon_state = "vulp_jackal"
	extra_overlay = "vulp_jackal-inner"

/datum/sprite_accessory/ears/bunny_floppy
	name = "floopy bunny ears"
	icon_state = "floppy_bun"

/datum/sprite_accessory/ears/teshari
	name = "Teshari (colorable fluff)"
	icon_state = "teshari"
	extra_overlay = "teshariinner"
	species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/ears/tesharihigh
	name = "Teshari upper ears (colorable fluff)"
	icon_state = "tesharihigh"
	extra_overlay = "tesharihighinner"
	species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

/datum/sprite_accessory/ears/tesharilow
	name = "Teshari lower ears (colorable fluff)"
	icon_state = "tesharilow"
	extra_overlay = "tesharilowinner"
	species_allowed = list(SPECIES_TESHARI, SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)

<<<<<<< HEAD
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

=======
>>>>>>> de662cd5378... Properly filters the genemod whitelisting (#8381)
// Special snowflake ears go below here.
/datum/sprite_accessory/ears/elf/caprine
	name = "Caprine horns with pointy ears"
	extra_overlay = "caprahorns"

/datum/sprite_accessory/ears/elf/oni
	name = "oni horns with pointy ears"
	extra_overlay = "oni-h1_c"

/datum/sprite_accessory/ears/elf/demon
	name = "Demon horns with pointy ears"
	extra_overlay = "demon-horns1_c"

/datum/sprite_accessory/ears/elf/demon_outwards
	name = "Demon horns with pointy ears (outwards)"
	extra_overlay = "demon-horns2"
