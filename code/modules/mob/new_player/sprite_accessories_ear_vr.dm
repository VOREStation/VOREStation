/*
////////////////////////////
/  =--------------------=  /
/  == Ear Definitions  ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/ears
	name = "You should not see this..."
	icon = 'icons/mob/vore/ears_vr.dmi'
	do_colouration = 0 // Set to 1 to blend (ICON_ADD) hair color
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN) //This lets all races use
	color_blend_mode = ICON_ADD // Only appliciable if do_coloration = 1

// Species-unique ears

/datum/sprite_accessory/ears/shadekin
	name = "Shadekin Ears, colorable"
	desc = ""
	icon_state = "shadekin"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)

/datum/sprite_accessory/ears/shadekin/round
	name = "Shadekin Ears Round, colorable"
	desc = ""
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "shadekin-round"
	do_colouration = 1
	extra_overlay = "shadekin-round-inner"

// Ears avaliable to anyone

/datum/sprite_accessory/ears/alien_slug
	name = "Alien slug antennae"
	desc = ""
	icon = 'icons/mob/vore/ears_vr.dmi'
	icon_state = "alien_slug"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/taj_ears
	name = "tajaran, colorable (old)"
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN) //This lets all races use

/datum/sprite_accessory/ears/taj_ears_tall
	name = "tajaran tall, colorable (old)"
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN) //This lets all races use

/datum/sprite_accessory/ears/alt_ram_horns
	name = "Solid ram horns"
	desc = ""
	icon_state = "ram_horns_s"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/hyena
	name = "hyena ears, dual-color"
	desc = ""
	icon_state = "hyena"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "hyena-inner"

/datum/sprite_accessory/ears/moth
	name = "moth antennae"
	desc = ""
	icon_state = "moth"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

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

/datum/sprite_accessory/ears/antennae_eye
	name = "antennae eye, colorable"
	desc = ""
	icon_state = "antennae"
	extra_overlay = "antennae_eye_1"
	extra_overlay2 = "antennae_eye_2"
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

/datum/sprite_accessory/ears/tajaran_standard
	name = "tajaran, colorable"
	desc = ""
	icon_state = "ears_tajaran_standard"
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

/datum/sprite_accessory/ears/elfs
	name = "elven ears"
	desc = ""
	icon_state = "elfs"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/elfs1
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN) //This lets all races use

/datum/sprite_accessory/ears/elfs2
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN) //This lets all races use

/datum/sprite_accessory/ears/elfs3
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN) //This lets all races use

/datum/sprite_accessory/ears/elfs4
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN) //This lets all races use

/datum/sprite_accessory/ears/elfs5
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_UNATHI, SPECIES_TAJ, SPECIES_TESHARI, SPECIES_NEVREAN, SPECIES_AKULA, SPECIES_SERGAL, SPECIES_FENNEC, SPECIES_ZORREN_HIGH, SPECIES_VULPKANIN, SPECIES_XENOCHIMERA, SPECIES_XENOHYBRID, SPECIES_VASILISSAN, SPECIES_RAPALA, SPECIES_PROTEAN, SPECIES_ALRAUNE, SPECIES_WEREBEAST, SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW, SPECIES_ALTEVIAN) //This lets all races use

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

/datum/sprite_accessory/ears/fox
	name = "fox ears"
	desc = ""
	icon_state = "fox"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "fox-inner"

/datum/sprite_accessory/ears/bunny_floppy
	name = "floopy bunny ears (colorable)"
	desc = ""
	icon_state = "floppy_bun"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/teshari
	name = "Teshari (colorable)"
	desc = ""
	icon_state = "teshari"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "teshariinner"

/datum/sprite_accessory/ears/tesharihigh
	name = "Teshari upper ears (colorable)"
	desc = ""
	icon_state = "tesharihigh"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "tesharihighinner"

/datum/sprite_accessory/ears/tesharilow
	name = "Teshari lower ears (colorable)"
	desc = ""
	icon_state = "tesharilow"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "tesharilowinner"

/datum/sprite_accessory/ears/tesh_pattern_ear_male
	name = "Teshari male ear pattern (colorable)"
	desc = ""
	icon_state = "teshari"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "teshari_male_pattern"

/datum/sprite_accessory/ears/tesh_pattern_ear_female
	name = "Teshari female ear pattern (colorable)"
	desc = ""
	icon_state = "teshari"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "teshari_female_pattern"

/datum/sprite_accessory/ears/inkling
	name = "colorable mature inkling hair"
	desc = ""
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "inkling-colorable"
	color_blend_mode = ICON_MULTIPLY
	do_colouration = 1

/datum/sprite_accessory/ears/large_dragon
	name = "Large dragon horns"
	desc = ""
	icon_state = "big_liz"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/cobra_hood
	name = "Cobra hood (large)"
	desc = ""
	icon_state = "cobra_hood"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "cobra_hood-inner"

// Special snowflake ears go below here.

/datum/sprite_accessory/ears/molenar_kitsune
	name = "quintail kitsune ears (Molenar)"
	desc = ""
	icon_state = "molenar-kitsune"
	ckeys_allowed = list("molenar")

/datum/sprite_accessory/ears/lilimoth_antennae
	name = "citheronia antennae (Kira72)"
	desc = ""
	icon_state = "lilimoth_antennae"
	ckeys_allowed = list("kira72")

/datum/sprite_accessory/ears/molenar_deathclaw
	name = "deathclaw ears (Molenar)"
	desc = ""
	icon_state = "molenar-deathclaw"
	ckeys_allowed = list("molenar")

/datum/sprite_accessory/ears/miria_fluffdragon
	name = "fluffdragon ears (Miria Masters)"
	desc = ""
	icon_state = "miria-fluffdragonears"
	ckeys_allowed = list("miriamasters")

/datum/sprite_accessory/ears/miria_kitsune
	name = "kitsune ears (Miria Masters)"
	desc = ""
	icon_state = "miria-kitsuneears"
	ckeys_allowed = list("miriamasters")

/datum/sprite_accessory/ears/runac
	name = "fennecsune ears (Runac)"
	desc = ""
	icon_state = "runac"
	ckeys_allowed = list("rebcom1807")

/datum/sprite_accessory/ears/kerena
	name = "wingwolf ears (Kerena)"
	desc = ""
	icon_state = "kerena"
	ckeys_allowed = list("somekindofpony")

/datum/sprite_accessory/ears/rosey
	name = "tritail kitsune ears (Rosey)"
	desc = ""
	icon_state = "rosey"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	ckeys_allowed = list("joey4298")

/datum/sprite_accessory/ears/aronai
	name = "aronai ears/head (Aronai)"
	desc = ""
	icon_state = "aronai"
	ckeys_allowed = list("arokha")

/datum/sprite_accessory/ears/holly
	name = "tigress ears (Holly Sharp)"
	desc = ""
	icon_state = "tigressears"
	ckeys_allowed = list("hoodoo")

/datum/sprite_accessory/ears/molenar_inkling
	name = "teal mature inkling hair (Kari Akiren)"
	desc = ""
	icon_state = "molenar-tentacle"
	ckeys_allowed = list("molenar")

/datum/sprite_accessory/ears/shock
	name = "pharoah hound ears (Shock Diamond)"
	desc = ""
	icon_state = "shock"
	ckeys_allowed = list("icowom","cameron653")

/datum/sprite_accessory/ears/alurane
	name = "alurane ears/hair (Pumila)"
	desc = ""
	icon_state = "alurane-ears"
	ckeys_allowed = list("natje")

/datum/sprite_accessory/ears/frost
    name = "Frost antenna"
    desc = ""
    icon_state = "frosted_tips"
    ckeys_allowed = list("tucker0666")

/datum/sprite_accessory/ears/sylv_pip
    name = "sylveon ears and ribbons (Pip Shyner)"
    desc = ""
    icon_state = "pipears"
    ckeys_allowed = list("phoaly")

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

/datum/sprite_accessory/ears/synthhorns_plain
	name = "Synth horns, plain"
	desc = ""
	icon_state = "synthhorns_plain"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "synthhorns_plain_light"

/datum/sprite_accessory/ears/synthhorns_thick
	name = "Synth horns, thick"
	desc = ""
	icon_state = "synthhorns_thick"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "synthhorns_thick_light"

/datum/sprite_accessory/ears/synthhorns_curly
	name = "Synth horns, curly"
	desc = ""
	icon_state = "synthhorns_curled"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY


/datum/sprite_accessory/ears/forward_curled_demon_horns_bony
	name = "Succubus horns, colourable"
	desc = ""
	icon_state = "succu-horns_b"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/forward_curled_demon_horns_bony_with_colorable_ears
	name = "Succubus horns with pointy ears, colourable"
	desc = ""
	icon_state = "elfs"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "succu-horns_b"

/datum/sprite_accessory/ears/chorns_nubbydogs
	name = "Nubby Chorns"
	desc = ""
	icon_state = "chorn_nubby"
	do_colouration = 0
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/chorns_herk
	name = "Herk Chorns"
	desc = ""
	icon_state = "chorn_herk"
	do_colouration = 0
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/chorns_bork
	name = "Bork Chorns"
	desc = ""
	icon_state = "chorn_bork"
	do_colouration = 0
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/chorns_bull
	name = "Bull Chorns"
	desc = ""
	icon_state = "chorn_bull"
	do_colouration = 0
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/chorns_bicarrot
	name = "Bicarrot Chorns"
	desc = ""
	icon_state = "chorn_bicarrot"
	do_colouration = 0
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/chorns_longcarrot
	name = "Long Carrot Chorns"
	desc = ""
	icon_state = "chorn_longcarrot"
	do_colouration = 0
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/chorns_shortcarrot
	name = "Short Carrot Chorns"
	desc = ""
	icon_state = "chorn_shortcarrot"
	do_colouration = 0
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/chorns_scorp
	name = "Scorp Chorns"
	desc = ""
	icon_state = "chorn_scorp"
	do_colouration = 0
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/chorns_ocean
	name = "Ocean Chorns"
	desc = ""
	icon_state = "chorn_ocean"
	do_colouration = 0
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/chorns_chub
	name = "Chub Chorns"
	desc = ""
	icon_state = "chorn_chub"
	do_colouration = 0
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/bnnuy
	name = "Bnnuy Ears"
	desc = ""
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "bnnuy"
	extra_overlay = "bnnuy-inner"
	extra_overlay2 = "bnnuy-tips"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/bnnuy2
	name = "Bnnuy Ears 2"
	desc = ""
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "bnnuy2"
	extra_overlay = "bnnuy-inner"
	extra_overlay2 = "bnnuy-tips2"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/sandfox
	name = "Sandfox Ears"
	desc = ""
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "sandfox"
	extra_overlay = "sandfox-inner"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/teppiears
	name = "Teppi Ears"
	desc = ""
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "teppi_ears"
	extra_overlay = "teppi_ears_inner"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/teppihorns
	name = "Teppi Horns"
	desc = ""
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "teppi_horns"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/teppiearshorns
	name = "Teppi Ears and Horns"
	desc = ""
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "teppi_ears"
	extra_overlay = "teppi_ears_inner"
	extra_overlay2 = "teppi_horns"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/jackalope
	name = "Jackalope Ears and Antlers"
	desc = ""
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "jackalope"
	extra_overlay = "jackalope-antlers"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/rabbit_swept
	name = "Rabbit Ears (swept back)"
	desc = ""
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "rabbit-swept"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/antlers_large
	name = "Antlers (large)"
	desc = ""
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "antlers-large"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/antlers_wide
	name = "Antlers (wide)"
	desc = ""
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "antlers-wide"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/antlers_wide_e
	name = "Antlers (wide) with ears"
	desc = ""
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "antlers-wide"
	extra_overlay = "deer"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/kittyr
	name = "kitty right only, colorable"
	icon = 'icons/mob/vore/ears_uneven.dmi'
	desc = ""
	icon_state = "kittyrinner"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "kittyr"

/datum/sprite_accessory/ears/bunny_tall
	name = "Bunny Tall Ears"
	desc = ""
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "bunny-tall"
	extra_overlay = "bunny-tall-inner"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/altevian
	name = "Altevian Ears"
	desc = ""
	icon = 'icons/mob/vore/ears_vr.dmi'
	icon_state = "altevian"
	extra_overlay = "altevian-inner"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/wilddog
	name = "Wild Dog Ears"
	desc = ""
	icon = 'icons/mob/vore/ears_vr.dmi'
	icon_state = "wild_dog"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "wild_doginner"

/datum/sprite_accessory/ears/teshbeeantenna
	name = "Teshari bee antenna"
	icon = 'icons/mob/vore/ears_vr.dmi'
	icon_state = "teshbee"

/datum/sprite_accessory/ears/teshantenna
	name = "Teshari antenna, colorable"
	icon = 'icons/mob/vore/ears_vr.dmi'
	icon_state = "teshantenna"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/curlyteshantenna
	name = "Teshari curly antenna, colorable"
	icon = 'icons/mob/vore/ears_vr.dmi'
	icon_state = "curly_bug_tesh"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/syrishroom
	name = "Orange Mushroom Cap"
	icon = 'icons/mob/vore/ears_vr.dmi'
	icon_state = "syrishroom"

/datum/sprite_accessory/ears/singlesidehorn
	name = "Single Side Horn"
	desc = ""
	icon = 'icons/mob/vore/ears_vr.dmi'
	icon_state = "single-side-horn"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/zaprat
	name = "zaprat ears (dual-color)"
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "zaprat"
	extra_overlay = "zaprat-tips"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/kara //SatinIsle Fluff Item
	name = "Pterokara horn"
	desc = ""
	icon = 'icons/mob/vore/ears_vr.dmi'
	icon_state = "kara_horn"
	ckeys_allowed = list("satinisle")

/datum/sprite_accessory/ears/shark
	name = "shark ears (Colorable)"
	desc = ""
	icon_state = "shark_ears"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/sharkhigh
	name = "shark upper ears (Colorable)"
	desc = ""
	icon_state = "shark_ears_upper"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/sharklow
	name = "shark lower ears (Colorable)"
	desc = ""
	icon_state = "shark_ears_lower"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/sharkfin
	name = "shark fin (Colorable)"
	desc = ""
	icon_state = "shark_fin"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/sharkfinalt
	name = "shark fin alt style (Colorable)"
	desc = ""
	icon_state = "shark_fin_alt"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/sharkboth
	name = "shark ears and fin (Colorable)"
	desc = ""
	icon_state = "shark_ears"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "shark_fin"

/datum/sprite_accessory/ears/sharkbothalt
	name = "shark ears and fin alt style (Colorable)"
	desc = ""
	icon_state = "shark_ears"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "shark_fin_alt"

/datum/sprite_accessory/ears/sharkhighboth
	name = "shark upper ears and fin (Colorable)"
	desc = ""
	icon_state = "shark_ears_upper"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "shark_fin"

/datum/sprite_accessory/ears/sharkhighbothalt
	name = "shark upper ears and fin alt style (Colorable)"
	desc = ""
	icon_state = "shark_ears_upper"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "shark_fin_alt"

/datum/sprite_accessory/ears/sharklowboth
	name = "shark lower ears and fin (Colorable)"
	desc = ""
	icon_state = "shark_ears_lower"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "shark_fin"

/datum/sprite_accessory/ears/sharklowbothalt
	name = "shark lower ears and fin alt style (Colorable)"
	desc = ""
	icon_state = "shark_ears_lower"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
	extra_overlay = "shark_fin_alt"

/datum/sprite_accessory/ears/feather_horns
	name = "feather horns (dual-color)"
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "feather_horns"
	extra_overlay = "feather_horns-fluff"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/party_plume
	name = "nevrean party parrot plume(tri-color)"
	icon = 'icons/mob/vore/ears_32x64.dmi'
	icon_state = "party_plume"
	extra_overlay = "party_plume-1"
	extra_overlay2 = "party_plume-2"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

/datum/sprite_accessory/ears/feather_fan_ears //why yes I did abuse my abilities to make a sprite that is specifically compatible with one hair for my OC, why do you ask? - Tank
	name = "feather fan avian ears"
	icon = 'icons/mob/vore/ears_vr.dmi'
	icon_state = "feather_fan_ears"
	extra_overlay = "feather_fan_ears-outer"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY

//Dino frills
/datum/sprite_accessory/ears/dino_frills
	name = "triceratops frills"
	icon_state = "triceratops_frill"
	extra_overlay = "triceratops_frill_spikes"
	do_colouration = 1
	color_blend_mode = ICON_MULTIPLY
