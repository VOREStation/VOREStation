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

	vulp_none
		name = "None"
		icon = 'icons/mob/human_face_vr.dmi'
		icon_state = "none"
		species_allowed = list("Vulpkanin")
		gender = NEUTER

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

//Special hairstyles
/datum/sprite_accessory/ears/inkling
	name = "colorable mature inkling hair"
	desc = ""
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "inkling-colorable"


//VOREStation Body Markings and Overrides
//Reminder: BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD
/datum/sprite_accessory/marking/vr
	icon = 'icons/mob/human_races/markings_vr.dmi'

	vulp_belly
		name = "belly fur (Vulp)"
		icon_state = "vulp_belly"
		body_parts = list(BP_TORSO)

	vulp_fullbelly
		name = "full belly fur (Vulp)"
		icon_state = "vulp_fullbelly"
		body_parts = list(BP_TORSO)

	vulp_crest
		name = "belly crest (Vulp)"
		icon_state = "vulp_crest"
		body_parts = list(BP_TORSO)

	vulp_nose
		name = "nose (Vulp)"
		icon_state = "vulp_nose"
		body_parts = list(BP_HEAD)

	vulp_face
		name = "face (Vulp)"
		icon_state = "vulp_face"
		body_parts = list(BP_HEAD)

	vulp_earsface
		name = "ears and face (Vulp)"
		icon_state = "vulp_earsface"
		body_parts = list(BP_HEAD)

	vulp_all
		name = "all head highlights (Vulp)"
		icon_state = "vulp_all"
		body_parts = list(BP_HEAD)

	sergal_full
		name = "Sergal Markings"
		icon_state = "sergal_full"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
		species_allowed = list("Sergal")

	sergal_full_female
		name = "Sergal Markings (Female)"
		icon_state = "sergal_full_female"
		body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
		species_allowed = list("Sergal")
		gender = FEMALE

	monoeye
		name = "Monoeye"
		icon_state = "monoeye"
		body_parts = list(BP_HEAD)
