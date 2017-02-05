/datum/sprite_accessory
	var/list/heads_allowed = null //Specifies which, if any, alt heads a head marking, hairstyle or facial hair style is compatible with.
	var/list/tails_allowed = null //Specifies which, if any, tails a tail marking is compatible with.
	var/marking_location //Specifies which bodypart a body marking is located on.
	var/secondary_theme = null //If exists, there's a secondary colour to that hair style and the secondary theme's icon state's suffix is equal to this.
	var/no_sec_colour = null //If exists, prohibit the colouration of the secondary theme.

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

//Special hairstyles
/datum/sprite_accessory/ears/inkling
	name = "colorable mature inkling hair"
	desc = ""
	icon = 'icons/mob/human_face_vr.dmi'
	icon_state = "inkling-colorable"


/* HEAD ACCESSORY */

/datum/sprite_accessory/head_accessory
	icon = 'icons/mob/body_accessory_vr.dmi'
	species_allowed = list("Unathi", "Vulpkanin", "Tajaran", "Machine")
	icon_state = "accessory_none"
	var/over_hair

/datum/sprite_accessory/head_accessory/none
	name = "None"
	species_allowed = list("Human", "Unathi", "Diona", "Grey", "Machine", "Tajaran", "Vulpkanin", "Slime People", "Skeleton", "Vox")
	icon_state = "accessory_none"

/datum/sprite_accessory/head_accessory/unathi
	species_allowed = list("Unathi")
	over_hair = 1

/datum/sprite_accessory/head_accessory/unathi/simple
	name = "Simple"
	icon_state = "horns_simple"

/datum/sprite_accessory/head_accessory/unathi/short
	name = "Short"
	icon_state = "horns_short"

/datum/sprite_accessory/head_accessory/unathi/curled
	name = "Curled"
	icon_state = "horns_curled"

/datum/sprite_accessory/head_accessory/unathi/ram
	name = "Ram"
	icon_state = "horns_ram"

/datum/sprite_accessory/head_accessory/tajara
	species_allowed = list("Tajaran")

/datum/sprite_accessory/head_accessory/tajara/outears_taj
	name = "Tajaran Outer Ears"
	icon_state = "markings_face_outears_taj"

/datum/sprite_accessory/head_accessory/tajara/inears_taj
	name = "Tajaran Inner Ears"
	icon_state = "markings_face_inears_taj"

/datum/sprite_accessory/head_accessory/tajara/muzzle_taj
	name = "Tajaran Muzzle"
	icon_state = "markings_face_muzzle_taj"

/datum/sprite_accessory/head_accessory/tajara/muzzle_and_inears_taj
	name = "Tajaran Muzzle and Inner Ears"
	icon_state = "markings_face_muzzle_and_inears_taj"

/datum/sprite_accessory/head_accessory/tajara/taj_ears
	icon = 'icons/mob/human_face_vr.dmi'
	name = "Tajaran Ears"
	icon_state = "ears_plain"

/datum/sprite_accessory/head_accessory/tajara/taj_nose
	name = "Tajaran Nose"
	icon_state = "markings_face_nose_taj"

/datum/sprite_accessory/head_accessory/vulpkanin
	species_allowed = list("Vulpkanin")

/datum/sprite_accessory/head_accessory/vulpkanin/vulp_earfluff
	icon = 'icons/mob/human_face_vr.dmi'
	name = "Vulpkanin Earfluff"
	icon_state = "vulp_facial_earfluff"

/datum/sprite_accessory/head_accessory/vulpkanin/vulp_blaze
	icon = 'icons/mob/human_face_vr.dmi'
	name = "Blaze"
	icon_state = "vulp_facial_blaze"

/datum/sprite_accessory/head_accessory/vulpkanin/vulp_vulpine
	icon = 'icons/mob/human_face_vr.dmi'
	name = "Vulpine"
	icon_state = "vulp_facial_vulpine"

/datum/sprite_accessory/head_accessory/vulpkanin/vulp_vulpine_fluff
	icon = 'icons/mob/human_face_vr.dmi'
	name = "Vulpine and Earfluff"
	icon_state = "vulp_facial_vulpine_fluff"

/datum/sprite_accessory/head_accessory/vulpkanin/vulp_mask
	icon = 'icons/mob/human_face_vr.dmi'
	name = "Mask"
	icon_state = "vulp_facial_mask"

/datum/sprite_accessory/head_accessory/vulpkanin/vulp_patch
	icon = 'icons/mob/human_face_vr.dmi'
	name = "Patch"
	icon_state = "vulp_facial_patch"

/datum/sprite_accessory/head_accessory/vulpkanin/vulp_ruff
	icon = 'icons/mob/human_face_vr.dmi'
	name = "Ruff"
	icon_state = "vulp_facial_ruff"

/datum/sprite_accessory/head_accessory/vulpkanin/vulp_kita
	icon = 'icons/mob/human_face_vr.dmi'
	name = "Kita"
	icon_state = "vulp_facial_kita"

/datum/sprite_accessory/head_accessory/vulpkanin/vulp_swift
	icon = 'icons/mob/human_face_vr.dmi'
	name = "Swift"
	icon_state = "vulp_facial_swift"

/datum/sprite_accessory/head_accessory/vulpkanin/vulp_nose
	name = "Vulpkanin Nose"
	icon_state = "markings_face_nose_vulp"


/* BODY MARKINGS */

/datum/sprite_accessory/body_markings
	icon = 'icons/mob/body_accessory_vr.dmi'
	species_allowed = list("Unathi", "Tajaran", "Vulpkanin", "Vox")
	icon_state = "accessory_none"
	marking_location = "body"

/datum/sprite_accessory/body_markings/none
	name = "None"
	species_allowed = list("Human","Skrell","Unathi","Tajara", "Teshari", "Nevrean", "Akula", "Sergal", "Flatland Zorren", "Highlander Zorren", "Vulpkanin", "Xenochimera", "Xenomorph Hybrid") //This lets all races set "None" to body markings.
	icon_state = "accessory_none"

/datum/sprite_accessory/body_markings/tiger
	name = "Tiger Body"
	species_allowed = list("Unathi", "Tajaran", "Vulpkanin")
	icon_state = "markings_tiger"

/datum/sprite_accessory/body_markings/unathi
	species_allowed = list("Unathi")

/datum/sprite_accessory/body_markings/unathi/stripe_una
	name = "Unathi Stripe"
	icon_state = "markings_stripe_una"

/datum/sprite_accessory/body_markings/unathi/belly_narrow_una
	name = "Unathi Belly"
	icon_state = "markings_belly_narrow_una"

/datum/sprite_accessory/body_markings/unathi/banded_una
	name = "Unathi Banded"
	icon_state = "markings_banded_una"

/datum/sprite_accessory/body_markings/unathi/points_una
	name = "Unathi Points"
	icon_state = "markings_points_una"

/datum/sprite_accessory/body_markings/tajara
	species_allowed = list("Tajaran")

/datum/sprite_accessory/body_markings/tajara/belly_flat_taj
	name = "Tajaran Belly"
	icon_state = "markings_belly_flat_taj"

/datum/sprite_accessory/body_markings/tajara/belly_crest_taj
	name = "Tajaran Chest Crest"
	icon_state = "markings_belly_crest_taj"

/datum/sprite_accessory/body_markings/tajara/belly_full_taj
	name = "Tajaran Belly 2"
	icon_state = "markings_belly_full_taj"

/datum/sprite_accessory/body_markings/tajara/points_taj
	name = "Tajaran Points"
	icon_state = "markings_points_taj"

/datum/sprite_accessory/body_markings/tajara/patchy_taj
	name = "Tajaran Patches"
	icon_state = "markings_patch_taj"

/datum/sprite_accessory/body_markings/vulpkanin
	species_allowed = list("Vulpkanin")

/datum/sprite_accessory/body_markings/vulpkanin/belly_fox_vulp
	name = "Vulpkanin Belly"
	icon_state = "markings_belly_fox_vulp"

/datum/sprite_accessory/body_markings/vulpkanin/belly_full_vulp
	name = "Vulpkanin Belly 2"
	icon_state = "markings_belly_full_vulp"

/datum/sprite_accessory/body_markings/vulpkanin/belly_crest_vulp
	name = "Vulpkanin Belly Crest"
	icon_state = "markings_belly_crest_vulp"

/datum/sprite_accessory/body_markings/vulpkanin/points_fade_vulp
	name = "Vulpkanin Points"
	icon_state = "markings_points_fade_vulp"

/datum/sprite_accessory/body_markings/vulpkanin/points_fade_belly_vulp
	name = "Vulpkanin Points and Belly"
	icon_state = "markings_points_fade_belly_vulp"

/datum/sprite_accessory/body_markings/vulpkanin/points_fade_belly_alt_vulp
	name = "Vulpkanin Points and Belly Alt."
	icon_state = "markings_points_fade_belly_alt_vulp"

/datum/sprite_accessory/body_markings/vulpkanin/points_sharp_vulp
	name = "Vulpkanin Points 2"
	icon_state = "markings_points_sharp_vulp"

/datum/sprite_accessory/body_markings/vulpkanin/points_crest_vulp
	name = "Vulpkanin Points and Crest"
	icon_state = "markings_points_crest_vulp"

/datum/sprite_accessory/body_markings/drask
	species_allowed = list("Drask")

/datum/sprite_accessory/body_markings/drask/arm_spines_drask
	name = "Drask Arm Spines"
	icon_state = "markings_armspines_drask"

/datum/sprite_accessory/body_markings/head
	marking_location = "head"
	species_allowed = list()

/datum/sprite_accessory/body_markings/head/tajara
	species_allowed = list("Tajaran")

/datum/sprite_accessory/body_markings/head/tajara/tiger_head_taj
	name = "Tajaran Tiger Head"
	icon_state = "markings_head_tiger_taj"

/datum/sprite_accessory/body_markings/head/tajara/tiger_face_taj
	name = "Tajaran Tiger Head and Face"
	icon_state = "markings_face_tiger_taj"

/datum/sprite_accessory/body_markings/head/tajara/outears_taj
	name = "Tajaran Outer Ears"
	icon_state = "markings_face_outears_taj"

/datum/sprite_accessory/body_markings/head/tajara/inears_taj
	name = "Tajaran Inner Ears"
	icon_state = "markings_face_inears_taj"

/datum/sprite_accessory/body_markings/head/tajara/nose_taj
	name = "Tajaran Nose"
	icon_state = "markings_face_nose_taj"

/datum/sprite_accessory/body_markings/head/tajara/muzzle_taj
	name = "Tajaran Muzzle"
	icon_state = "markings_face_muzzle_taj"

/datum/sprite_accessory/body_markings/head/tajara/muzzle_and_inears_taj
	name = "Tajaran Muzzle and Inner Ears"
	icon_state = "markings_face_muzzle_and_inears_taj"

/datum/sprite_accessory/body_markings/head/tajara/muzzle_alt_taj //Companion marking for Tajaran Belly 2.
	name = "Tajaran Muzzle 2"
	icon_state = "markings_face_full_taj"

/datum/sprite_accessory/body_markings/head/tajara/points_taj //Companion marking for Tajaran Points.
	name = "Tajaran Points Head"
	icon_state = "markings_face_points_taj"

/datum/sprite_accessory/body_markings/head/tajara/patchy_taj //Companion marking for Tajaran Patches.
	name = "Tajaran Patches Head"
	icon_state = "markings_face_patch_taj"

/datum/sprite_accessory/body_markings/head/vulpkanin
	species_allowed = list("Vulpkanin")

/datum/sprite_accessory/body_markings/head/vulpkanin/tiger_head_vulp
	name = "Vulpkanin Tiger Head"
	icon_state = "markings_head_tiger_vulp"

/datum/sprite_accessory/body_markings/head/vulpkanin/tiger_face_vulp
	name = "Vulpkanin Tiger Head and Face"
	icon_state = "markings_face_tiger_vulp"

/datum/sprite_accessory/body_markings/head/vulpkanin/nose_default_vulp
	name = "Vulpkanin Nose"
	icon_state = "markings_face_nose_vulp"

/datum/sprite_accessory/body_markings/head/vulpkanin/muzzle_vulp //Companion marking for Vulpkanin Belly Alt..
	name = "Vulpkanin Muzzle"
	icon_state = "markings_face_full_vulp"

/datum/sprite_accessory/body_markings/head/vulpkanin/muzzle_ears_vulp //Companion marking for Vulpkanin Belly Alt..
	name = "Vulpkanin Muzzle and Ears"
	icon_state = "markings_face_full_ears_vulp"

/datum/sprite_accessory/body_markings/head/vulpkanin/points_fade_vulp //Companion marking for Vulpkanin Points Fade.
	name = "Vulpkanin Points Head"
	icon_state = "markings_face_points_fade_vulp"

/datum/sprite_accessory/body_markings/head/vulpkanin/points_sharp_vulp //Companion marking for Vulpkanin Points Sharp.
	name = "Vulpkanin Points Head 2"
	icon_state = "markings_face_points_sharp_vulp"

/datum/sprite_accessory/body_markings/head/unathi
	species_allowed = list("Unathi")

/datum/sprite_accessory/body_markings/head/unathi/tiger_head_una
	name = "Unathi Tiger Head"
	icon_state = "markings_head_tiger_una"
	heads_allowed = list("All")

/datum/sprite_accessory/body_markings/head/unathi/tiger_face_una
	name = "Unathi Tiger Head and Face"
	icon_state = "markings_face_tiger_una"

/datum/sprite_accessory/body_markings/head/unathi/snout_una_round
	name = "Unathi Round Snout"
	icon_state = "markings_face_snout_una_round"

/datum/sprite_accessory/body_markings/head/unathi/snout_lower_una_round
	name = "Unathi Lower Round Snout"
	icon_state = "markings_face_snout_lower_una"

/datum/sprite_accessory/body_markings/head/unathi/banded_una //Companion marking for Unathi Banded.
	name = "Unathi Banded Head"
	icon_state = "markings_face_banded_una"
	heads_allowed = list("All")

/datum/sprite_accessory/body_markings/head/unathi/snout_narrow_una //Companion marking for Unathi Narrow Belly.
	name = "Unathi Snout 2"
	icon_state = "markings_face_narrow_una"

/datum/sprite_accessory/body_markings/head/unathi/points_una //Companion marking for Unathi Points.
	name = "Unathi Points Head"
	icon_state = "markings_face_points_una"

/datum/sprite_accessory/body_markings/head/unathi/sharp
	heads_allowed = list("Unathi Sharp Snout")

/datum/sprite_accessory/body_markings/head/unathi/sharp/tiger_face_una_sharp
	name = "Unathi Sharp Tiger Head and Face"
	icon_state = "markings_face_tiger_una_sharp"

/datum/sprite_accessory/body_markings/head/unathi/sharp/snout_una_sharp
	name = "Unathi Sharp Snout"
	icon_state = "markings_face_snout_una_sharp"

/datum/sprite_accessory/body_markings/head/unathi/sharp/snout_narrow_una_sharp //Companion marking for Unathi Narrow Belly.
	name = "Unathi Sharp Snout 2"
	icon_state = "markings_face_narrow_una_sharp"

/datum/sprite_accessory/body_markings/head/unathi/sharp/points_una_sharp //Companion marking for Unathi Points.
	name = "Unathi Sharp Points Head"
	icon_state = "markings_face_points_una"


/datum/sprite_accessory/body_markings/tattoo/tiger_body
	name = "Tiger-stripe Tattoo"
	species_allowed = list("Human", "Unathi", "Vulpkanin", "Tajaran", "Skrell")
	icon_state = "markings_tiger"

/datum/sprite_accessory/body_markings/tattoo/heart
	name = "Heart Tattoo"
	icon_state = "markings_tattoo_heart"

/datum/sprite_accessory/body_markings/tattoo/hive
	name = "Hive Tattoo"
	icon_state = "markings_tattoo_hive"

/datum/sprite_accessory/body_markings/tattoo/nightling
	name = "Nightling Tattoo"
	icon_state = "markings_tattoo_nightling"

/datum/sprite_accessory/body_markings/tattoo/grey
	species_allowed = list("Grey")

/datum/sprite_accessory/body_markings/tattoo/grey/heart_grey
	name = "Grey Heart Tattoo"
	icon_state = "markings_tattoo_heart_grey"

/datum/sprite_accessory/body_markings/tattoo/grey/hive_grey
	name = "Grey Hive Tattoo"
	icon_state = "markings_tattoo_hive_grey"

/datum/sprite_accessory/body_markings/tattoo/grey/nightling_grey
	name = "Grey Nightling Tattoo"
	icon_state = "markings_tattoo_nightling_grey"

/datum/sprite_accessory/body_markings/tattoo/grey/tiger_body_grey
	name = "Grey Tiger-stripe Tattoo"
	icon_state = "markings_tattoo_tiger_grey"

/datum/sprite_accessory/body_markings/tattoo/vox
	species_allowed = list("Vox")

/datum/sprite_accessory/body_markings/tattoo/vox/heart_vox
	name = "Vox Heart Tattoo"
	icon_state = "markings_tattoo_heart_vox"

/datum/sprite_accessory/body_markings/tattoo/vox/hive_vox
	name = "Vox Hive Tattoo"
	icon_state = "markings_tattoo_hive_vox"

/datum/sprite_accessory/body_markings/tattoo/vox/nightling_vox
	name = "Vox Nightling Tattoo"
	icon_state = "markings_tattoo_nightling_vox"

/datum/sprite_accessory/body_markings/tattoo/vox/tiger_body_vox
	name = "Vox Tiger-stripe Tattoo"
	icon_state = "markings_tattoo_tiger_vox"

/datum/sprite_accessory/body_markings/tail
	species_allowed = list()
	icon_state = "accessory_none"
	marking_location = "tail"
	tails_allowed = null

/datum/sprite_accessory/body_markings/tail/vox
	species_allowed = list("Vox")

/datum/sprite_accessory/body_markings/tail/vox/vox_band
	name = "Vox Tail Band"
	icon_state = "markings_voxtail_band"

/datum/sprite_accessory/body_markings/tail/vox/vox_tip
	name = "Vox Tail Tip"
	icon_state = "markings_voxtail_tip"

/datum/sprite_accessory/body_markings/tail/vox/vox_stripe
	name = "Vox Tail Stripe"
	icon_state = "markings_voxtail_stripe"

/datum/sprite_accessory/body_markings/tail/vulpkanin
	species_allowed = list("Vulpkanin")

/datum/sprite_accessory/body_markings/tail/vulpkanin/vulp_default_tip
	name = "Vulpkanin Default Tail Tip"
	icon_state = "markings_vulptail_tip"

/datum/sprite_accessory/body_markings/tail/vulpkanin/vulp_default_fade
	name = "Vulpkanin Default Tail Fade"
	icon_state = "markings_vulptail_fade"

/datum/sprite_accessory/body_markings/tail/vulpkanin/vulp_bushy_fluff
	name = "Vulpkanin Bushy Tail Fluff"
	tails_allowed = list("Vulpkanin Alt 1 (Bushy)")
	icon_state = "markings_vulptail2_fluff"

/datum/sprite_accessory/body_markings/tail/vulpkanin/vulp_short_tip
	name = "Vulpkanin Short Tail Tip"
	tails_allowed = list("Vulpkanin Alt 4 (Short)")
	icon_state = "markings_vulptail5_tip"

/datum/sprite_accessory/body_markings/tail/vulpkanin/vulp_hybrid_tip
	name = "Vulpkanin Bushy Straight Tail Tip"
	tails_allowed = list("Vulpkanin Alt 5 (Straight Bushy)")
	icon_state = "markings_vulptail6_tip"

/datum/sprite_accessory/body_markings/tail/vulpkanin/vulp_hybrid_fade
	name = "Vulpkanin Bushy Straight Tail Fade"
	tails_allowed = list("Vulpkanin Alt 5 (Straight Bushy)")
	icon_state = "markings_vulptail6_fade"

/datum/sprite_accessory/body_markings/tail/vulpkanin/vulp_hybrid_silverf
	name = "Vulpkanin Bushy Straight Tail Black Fade White Tip"
	tails_allowed = list("Vulpkanin Alt 5 (Straight Bushy)")
	icon_state = "markings_vulptail6_silverf"