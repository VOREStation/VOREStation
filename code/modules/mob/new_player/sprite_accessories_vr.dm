////////////////////////
// For sergals and stuff
////////////////////////
// Note: Creating a sub-datum to group all vore stuff together
// would require us to exclude that datum from the global list.

/datum/sprite_accessory/hair

	species_allowed = list("Human","Skrell","Unathi","Tajara", "Teshari", "Nevrean", "Akula", "Sergal", "Flatland Zorren", "Highlander Zorren", "Vulpkanin", "Xenochimera", "Xenomorph Hybrid") //This lets all races use the default hairstyles.

	sergal_plain
		name = "Sergal Plain"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "serg_plain"
		species_allowed = list("Sergal")

	sergal_medicore
		name = "Sergal Medicore"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "serg_medicore"
		species_allowed = list("Sergal")

	sergal_tapered
		name = "Sergal Tapered"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "serg_tapered"
		species_allowed = list("Sergal")

	sergal_fairytail
		name = "Sergal Fairytail"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "serg_fairytail"
		species_allowed = list("Sergal")

	braid
		name = "Floorlength Braid"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "hair_braid"

	bald
		name = "Bald"
		icon_state = "bald"
		gender = MALE
		species_allowed = list("Human","Skrell","Unathi","Tajara", "Teshari", "Nevrean", "Akula", "Sergal", "Flatland Zorren", "Highlander Zorren", "Vulpkanin", "Xenochimera", "Xenomorph Hybrid") //Lets all the races be bald if they want.


	una_hood
		name = "Cobra Hood"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "soghun_hood"

	una_spines_long
		name = "Long Unathi Spines"
		icon_state = "soghun_longspines"
		species_allowed = list("Unathi", "Xenochimera") //Xenochimera get most hairstyles since they're abominations.

	una_spines_short
		name = "Short Unathi Spines"
		icon_state = "soghun_shortspines"
		species_allowed = list("Unathi", "Xenochimera")


	una_frills_long
		name = "Long Unathi Frills"
		icon_state = "soghun_longfrills"
		species_allowed = list("Unathi", "Xenochimera")

	una_frills_short
		name = "Short Unathi Frills"
		icon_state = "soghun_shortfrills"
		species_allowed = list("Unathi", "Xenochimera")

	una_horns
		name = "Unathi Horns"
		icon_state = "soghun_horns"
		species_allowed = list("Unathi", "Xenochimera")

	una_doublehorns
		name = "Double Unathi Horns"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "soghun_dubhorns"
		species_allowed = list("Unathi", "Xenochimera")

	taj_ears
		name = "Tajaran Ears"
		icon_state = "ears_plain"
		species_allowed = list("Tajara", "Xenochimera")


	taj_ears_clean
		name = "Tajara Clean"
		icon_state = "hair_clean"
		species_allowed = list("Tajara", "Xenochimera")

	taj_ears_bangs
		name = "Tajara Bangs"
		icon_state = "hair_bangs"
		species_allowed = list("Tajara", "Xenochimera")

	taj_ears_braid
		name = "Tajara Braid"
		icon_state = "hair_tbraid"
		species_allowed = list("Tajara", "Xenochimera")

	taj_ears_shaggy
		name = "Tajara Shaggy"
		icon_state = "hair_shaggy"
		species_allowed = list("Tajara", "Xenochimera")

	taj_ears_mohawk
		name = "Tajaran Mohawk"
		icon_state = "hair_mohawk"
		species_allowed = list("Tajara", "Xenochimera")

	taj_ears_plait
		name = "Tajara Plait"
		icon_state = "hair_plait"
		species_allowed = list("Tajara", "Xenochimera")

	taj_ears_straight
		name = "Tajara Straight"
		icon_state = "hair_straight"
		species_allowed = list("Tajara", "Xenochimera")

	taj_ears_long
		name = "Tajara Long"
		icon_state = "hair_long"
		species_allowed = list("Tajara", "Xenochimera")

	taj_ears_rattail
		name = "Tajara Rat Tail"
		icon_state = "hair_rattail"
		species_allowed = list("Tajara", "Xenochimera")

	taj_ears_spiky
		name = "Tajara Spiky"
		icon_state = "hair_tajspiky"
		species_allowed = list("Tajara", "Xenochimera")

	taj_ears_messy
		name = "Tajara Messy"
		icon_state = "hair_messy"
		species_allowed = list("Tajara", "Xenochimera")
// Vulpa stuffs

	vulp_hair_none
		name = "None"
		icon_state = "bald"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_kajam
		name = "Kajam"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "kajam"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_keid
		name = "Keid"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "keid"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_adhara
		name = "Adhara"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "adhara"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_kleeia
		name = "Kleeia"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "kleeia"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_mizar
		name = "Mizar"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "mizar"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_apollo
		name = "Apollo"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "apollo"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_belle
		name = "Belle"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "belle"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_bun
		name = "Bun"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "bun"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_jagged
		name = "Jagged"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "jagged"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_curl
		name = "Curl"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "curl"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_hawk
		name = "Hawk"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "hawk"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_anita
		name = "Anita"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "anita"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_short
		name = "Short"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "short"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_hair_spike
		name = "Spike"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "spike"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

/datum/sprite_accessory/facial_hair

	vulp_blaze
		name = "Blaze"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_blaze"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_vulpine
		name = "Vulpine"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_vulpine"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_earfluff
		name = "Earfluff"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_earfluff"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_mask
		name = "Mask"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_mask"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_patch
		name = "Patch"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_patch"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_ruff
		name = "Ruff"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_ruff"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_kita
		name = "Kita"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_kita"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulp_swift
		name = "Swift"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "vulp_facial_swift"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

	vulpkanin
		name = "Default Vulpkanin skin"
		icon_state = "default"
		icon = 'icons/mob/human_races/r_vulpkanin.dmi'
		species_allowed = list("Vulpkanin")


/*
/////////////////////////////
/  =---------------------=  /
/  == Dicks Definitions ==  /
/  =---------------------=  /
/////////////////////////////
*/

/datum/sprite_accessory/dicks
	icon = 'icons/vore/extras/dicks.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell", "Sergal", "Akula","Nevrean", "Highlander Zorren", "Flatland Zorren", "Vulpkanin", "Xenomorph Hybrid")

	dik_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell", "Sergal", "Akula","Nevrean", "Highlander Zorren", "Flatland Zorren", "Vulpkanin", "Xenomorph Hybrid", "Diona", "Teshari", "Promethean")

	dik_normal
		name = "Normal Dick"
		icon_state = "normal"

	dik_circumcised
		name = "Circumcised Dick"
		icon_state = "cut"

	dik_big
		name = "Big Dick"
		icon_state = "big"

	dik_big2
		name = "Bigger Dick"
		icon_state = "big2"

	dik_small
		name = "Small Dick"
		icon_state = "small"

	dik_knotted
		name = "Knotted Dick"
		icon_state = "knotted"

	dik_feline
		name = "Feline Dick"
		icon_state = "feline"

	dik_tentacle
		name = "Tentacle Dicks"
		icon_state = "tentacle"

	dik_tentacle2
		name = "Tentacle Big Dicks"
		icon_state = "tentacle_big"

	dik_normal_slime
		name = "Slime Normal Dick"
		icon_state = "normal_slime"
		species_allowed = list ("Promethean")

	dik_small_slime
		name = "Slime Small Dick"
		icon_state = "small_slime"
		species_allowed = list ("Promethean")

	dik_big2_slime
		name = "Slime Bigger Dick"
		icon_state = "big2_slime"
		species_allowed = list ("Promethean")

	dik_bishop
		name = "Bishop Synthpenis"
		icon_state = "robo-bishop"
		do_colouration = 0

	dik_hesphiastos
		name = "Hesphiastos Synthpenis"
		icon_state = "robo-hesphiastos"
		do_colouration = 0

	dik_morpheus
		name = "Morpheus Synthpenis"
		icon_state = "robo-morpheus"
		do_colouration = 0

	dik_wardtakahashi
		name = "Ward-Takahashi Synthpenis"
		icon_state = "robo-wardtakahashi"
		do_colouration = 0

	dik_zenghu
		name = "Zeng-hu Synthpenis"
		icon_state = "robo-zenghu"
		do_colouration = 0

	dik_xion
		name = "Xion Synthpenis"
		icon_state = "robo-xion"
		do_colouration = 0

	dik_nt
		name = "NanoTrasen Synthpenis"
		icon_state = "robo-nanotrasen"
		do_colouration = 0
	dik_morpheus
		name = "Morpheus Synthpenis"
		icon_state = "robo-morpheus"
		do_colouration = 0

	dik_scorpius
		name = "Scorpius Synthpenis"
		icon_state = "robo-scorpius"
		do_colouration = 0

	dik_unbranded
		name = "Unbranded Synthpenis"
		icon_state = "robo-unbranded"
		do_colouration = 0

/*
//////////////////////////////
/  =----------------------=  /
/  == Vagina Definitions ==  /
/  =----------------------=  /
//////////////////////////////
*/

/datum/sprite_accessory/vaginas
	icon = 'icons/vore/extras/vaginas.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell", "Sergal", "Akula","Nevrean", "Highlander Zorren", "Flatland Zorren", "Vulpkanin", "Xenomorph Hybrid")

	vag_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell", "Sergal", "Akula","Nevrean", "Highlander Zorren", "Flatland Zorren", "Vulpkanin", "Xenomorph Hybrid", "Diona", "Teshari", "Promethean")

	vag_normal
		name = "Normal Vagina"
		icon_state = "normal"

	vag_hairy
		name = "Hairy Vagina"
		icon_state = "hairy"

	vag_gaping
		name = "Gaping Vagina"
		icon_state = "gaping"

	vag_dripping
		name = "Dripping Vagina"
		icon_state = "dripping"

	vag_tentacle
		name = "Tentacle Vagina"
		icon_state = "tentacles"

	vag_dentata
		name = "Vagina Dentata"
		icon_state = "dentata"
		do_colouration = 0

	vag_normal_slime
		name = "Slime Normal Vagina"
		icon_state = "normal_slime"
		species_allowed = list ("Promethean")

	vag_gaping_slime
		name = "Slime Gaping Vagina"
		icon_state = "gaping_slime"
		species_allowed = list ("Promethean")

	vag_dripping_slime
		name = "Slime Dripping Vagina"
		icon_state = "dripping_slime"
		species_allowed = list ("Promethean")

/*
///////////////////////////////
/  =-----------------------=  /
/  == Breasts Definitions ==  /
/  =-----------------------=  /
///////////////////////////////
*/

/datum/sprite_accessory/breasts
	icon = 'icons/vore/extras/breasts.dmi'
	species_allowed = list("Human","Unathi","Tajara","Skrell", "Sergal", "Akula","Nevrean", "Highlander Zorren", "Flatland Zorren", "Vulpkanin", "Xenomorph Hybrid")

	brt_none
		name = "None"
		icon = null
		icon_state = null
		species_allowed = list("Human","Unathi","Tajara","Skrell", "Sergal", "Akula","Nevrean", "Highlander Zorren", "Flatland Zorren", "Vulpkanin", "Xenomorph Hybrid", "Diona", "Teshari", "Promethean")

	brt_normala
		name = "Tiny Breasts"
		icon_state = "normal_a"

	brt_normalb
		name = "Small Breasts"
		icon_state = "normal_b"

	brt_normalc
		name = "Normal Breasts"
		icon_state = "normal_c"

	brt_normald
		name = "Big Breasts"
		icon_state = "normal_d"

	brt_normale
		name = "Very Big Breasts"
		icon_state = "normal_e"

	brt_slimea
		name = "Slime Tiny Breasts"
		icon_state = "slime_a"
		species_allowed = list ("Promethean")

	brt_slimeb
		name = "Slime Small Breasts"
		icon_state = "slime_b"
		species_allowed = list ("Promethean")

	brt_slimec
		name = "Slime Normal Breasts"
		icon_state = "slime_c"
		species_allowed = list ("Promethean")

	brt_slimed
		name = "Slime Big Breasts"
		icon_state = "slime_d"
		species_allowed = list ("Promethean")

	brt_slimee
		name = "Slime Very Big Breasts"
		icon_state = "slime_e"
		species_allowed = list ("Promethean")

	brt_bishop
		name = "Bishop Synthbreasts"
		icon_state = "robo-bishop"
		do_colouration = 0

	brt_hesphiastos
		name = "Hesphiastos Synthbreasts"
		icon_state = "robo-hesphiastos"
		do_colouration = 0


	brt_wardtakahashi
		name = "Ward-Takahashi Synthbreasts"
		icon_state = "robo-wardtakahashi"
		do_colouration = 0

	brt_zenghu
		name = "Zeng-hu Synthbreasts"
		icon_state = "robo-zenghu"
		do_colouration = 0

	brt_xion
		name = "Xion Synthbreasts"
		icon_state = "robo-xion"
		do_colouration = 0

	brt_nt
		name = "NanoTrasen Synthbreasts"
		icon_state = "robo-nanotrasen"
		do_colouration = 0

	brt_scorpius
		name = "Scorpius Synthbreasts"
		icon_state = "robo-scorpius"
		do_colouration = 0

	brt_morpheus
		name = "Morpheus Synthbreasts"
		icon_state = "robo-morpheus"
		do_colouration = 0

	brt_unbranded
		name = "Unbranded Synthbreasts"
		icon_state = "robo-unbranded"
		do_colouration = 0
