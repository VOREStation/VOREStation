//VOREStation Body Markings and Overrides
//Reminder: BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD

/datum/sprite_accessory/marking //Override for base markings
	color_blend_mode = ICON_ADD
	species_allowed = list() //This lets all races use

/datum/sprite_accessory/marking/vr_vulp_belly
	name = "belly fur (Vulp)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "vulp_belly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_vulp_fullbelly
	name = "full belly fur (Vulp)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "vulp_fullbelly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_vulp_crest
	name = "belly crest (Vulp)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "vulp_crest"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_vulp_nose
	name = "nose (Vulp)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "vulp_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_vulp_short_nose
	name = "nose, short (Vulp)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "vulp_short_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_snoutstripe
	name = "snout stripe (Vulp)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "snoutstripe"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_vulp_face
	name = "face (Vulp)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "vulp_face"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_vulp_facealt
	name = "face, alt. (Vulp)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "vulp_facealt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_vulp_earsface
	name = "ears and face (Vulp)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "vulp_earsface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_vulp_all
	name = "all head highlights (Vulp)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "vulp_all"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_sergal_full
	name = "Sergal Markings"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "sergal_full"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	//species_allowed = list("Sergal")			//Removing Polaris whitelits

/datum/sprite_accessory/marking/vr_sergal_full_female
	name = "Sergal Markings (Female)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "sergal_full_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	//("Sergal")

/datum/sprite_accessory/marking/vr_monoeye
	name = "Monoeye"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "monoeye"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_spidereyes
	name = "Spider Eyes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "spidereyes"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_sergaleyes
	name = "Sergal Eyes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "eyes_sergal"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_closedeyes
	name = "Closed Eyes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "eyes_closed"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_brows
	name = "Eyebrows"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "brows"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_nevrean_female
	name = "Female Nevrean beak"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "nevrean_f"
	body_parts = list(BP_HEAD)
	color_blend_mode = ICON_MULTIPLY
	gender = FEMALE

/datum/sprite_accessory/marking/vr_nevrean_male
	name = "Male Nevrean beak"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "nevrean_m"
	body_parts = list(BP_HEAD)
	color_blend_mode = ICON_MULTIPLY
	gender = MALE

/datum/sprite_accessory/marking/vr_spots
	name = "Spots"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "spots"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr_shaggy_mane
	name = "Shaggy mane/feathers"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "shaggy"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr_jagged_teeth
	name = "Jagged teeth"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "jagged"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_blank_face
	name = "Blank round face (use with monster mouth)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "blankface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_monster_mouth
	name = "Monster mouth"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "monster"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_saber_teeth
	name = "Saber teeth"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "saber"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_fangs
	name = "Fangs"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "fangs"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_tusks
	name = "Tusks"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "tusks"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_otie_face
	name = "Otie face"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "otieface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_otie_nose
	name = "Otie nose"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "otie_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_otienose_lite
	name = "Short otie nose"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "otienose_lite"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_backstripes
	name = "Back stripes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "otiestripes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_belly_butt
	name = "Belly and butt"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "bellyandbutt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr_fingers_toes
	name = "Fingers and toes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "fingerstoes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr_otie_socks
	name = "Fingerless socks"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "otiesocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr_corvid_beak
	name = "Corvid beak"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "corvidbeak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_corvid_belly
	name = "Corvid belly"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "corvidbelly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_cow_body
	name = "Cow markings"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "cowbody"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_cow_nose
	name = "Cow nose"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "cownose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_zmask
	name = "Eye mask"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "zmask"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_zbody
	name = "Thick jagged stripes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "zbody"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr_znose
	name = "Jagged snout"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "znose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_otter_nose
	name = "Otter nose"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "otternose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_otter_face
	name = "Otter face"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "otterface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_deer_face
	name = "Deer face"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "deerface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_sharkface
	name = "Akula snout"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "sharkface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_sheppy_face
	name = "Shepherd snout"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "shepface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_sheppy_back
	name = "Shepherd back"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "shepback"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_zorren_belly_male
	name = "Zorren Male Torso"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "zorren_belly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_zorren_belly_female
	name = "Zorren Female Torso"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "zorren_belly_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_zorren_back_patch
	name = "Zorren Back Patch"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "zorren_backpatch"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr_zorren_face_male
	name = "Zorren Male Face"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "zorren_face"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = MALE

/datum/sprite_accessory/marking/vr_zorren_face_female
	name = "Zorren Female Face"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "zorren_face_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = FEMALE

/datum/sprite_accessory/marking/vr_zorren_muzzle_male
	name = "Zorren Male Muzzle"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "zorren_muzzle"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = MALE

/datum/sprite_accessory/marking/vr_zorren_muzzle_female
	name = "Zorren Female Muzzle"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "zorren_muzzle_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = FEMALE

/datum/sprite_accessory/marking/vr_zorren_socks
	name = "Zorren Socks"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "zorren_socks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr_zorren_longsocks
	name = "Zorren Longsocks"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "zorren_longsocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr_tesh_feathers
	name = "Teshari Feathers"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "tesh-feathers"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_harpy_feathers
	name = "Rapala leg Feather"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "harpy-feathers"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr_harpy_legs
	name = "Rapala leg coloring"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "harpy-leg"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr_chooves
	name = "Cloven hooves"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "chooves"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT)

/datum/sprite_accessory/marking/vr_body_tone
	name = "Body toning (for emergency contrast loss)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "btone"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr_gloss
	name = "Full body gloss"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "gloss"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_eboop_panels
	name = "Eggnerd FBP panels"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "eboop"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_osocks_rarm
	name = "Modular Longsock (right arm)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_ARM,BP_R_HAND)

/datum/sprite_accessory/marking/vr_osocks_larm
	name = "Modular Longsock (left arm)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_L_HAND)

/datum/sprite_accessory/marking/vr_osocks_rleg
	name = "Modular Longsock (right leg)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_FOOT,BP_R_LEG)

/datum/sprite_accessory/marking/vr_osocks_lleg
	name = "Modular Longsock (left leg)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_L_LEG)

/datum/sprite_accessory/marking/vr_animeeyesinner
	name = "Anime Eyes Inner"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "animeeyesinner"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_animeeyesouter
	name = "Anime Eyes Outer"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "animeeyesouter"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_panda_eye_marks
	name = "Panda Eye Markings"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "eyes_panda"
	body_parts = list(BP_HEAD)
	//species_allowed = list(SPECIES_EVENT1, SPECIES_EVENT2, SPECIES_EVENT3)			//Removing Polaris whitelits

/datum/sprite_accessory/marking/vr_catwomantorso
	name = "Catwoman chest stripes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "catwomanchest"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr_catwomangroin
	name = "Catwoman groin stripes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "catwomangroin"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/vr_catwoman_rleg
	name = "Catwoman right leg stripes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "catwomanright"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/vr_catwoman_lleg
	name = "Catwoman left leg stripes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "catwomanleft"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/vr_teshi_small_feathers
	name = "Teshari small wingfeathers"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "teshi_sf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND,BP_TORSO)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_spirit_lights
	name = "Ward - Spirit FBP Lights"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_spirit_lights_body
	name = "Ward - Spirit FBP Lights (body)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO)

/datum/sprite_accessory/marking/vr_spirit_lights_head
	name = "Ward - Spirit FBP Lights (head)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_spirit_panels
	name = "Ward - Spirit FBP Panels"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_spirit_panels_body
	name = "Ward - Spirit FBP Panels (body)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr_spirit_panels_head
	name = "Ward - Spirit FBP Panels (head)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_tentacle_head
	name = "Squid Head"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "tentaclehead"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_tentacle_mouth
	name = "Tentacle Mouth"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "tentaclemouth"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_rosette
	name = "Rosettes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "rosette"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_werewolf_nose
	name = "Werewolf nose"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_WEREBEAST)

/datum/sprite_accessory/marking/vr_werewolf_face
	name = "Werewolf face"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_WEREBEAST)

/datum/sprite_accessory/marking/vr_werewolf_belly
	name = "Werewolf belly"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_WEREBEAST)

/datum/sprite_accessory/marking/vr_werewolf_socks
	name = "Werewolf socks"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_WEREBEAST)

/datum/sprite_accessory/marking/vr_shadekin_snoot
	name = "Shadekin Snoot"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "shadekin-snoot"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)

/datum/sprite_accessory/marking/vr_taj_nose_alt
	name = "Nose Color, alt. (Taj)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "taj_nosealt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_talons
	name = "Talons"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "talons"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr_claws
	name = "Claws"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "claws"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr_equine_snout //Why the long face? Works best with sergal bodytype.
	name = "Equine Snout"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "donkey"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_equine_nose
	name = "Equine Nose"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "dnose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_bee_stripes
	name = "bee stripes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "beestripes"
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_vas_toes
	name = "Bug Paws (Vasilissan)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "vas_toes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT)

	//CitRP stuff

/datum/sprite_accessory/marking/vr_c_beast_body
	name = "Cyber Body"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "c_beast_body"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_c_beast_plating
	name = "Cyber Plating (Use w/ Cyber Body)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "c_beast_plating"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM)

/datum/sprite_accessory/marking/vr_c_beast_band
	name = "Cyber Band (Use w/ Cybertech head)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "c_beast_band"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_c_beast_cheek_a
	name = "Cyber Beast Cheeks A (Use A, B and C)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "c_beast_a"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_c_beast_cheek_b
	name = "Cyber Beast Cheeks B (Use A, B and C)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "c_beast_b"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_c_beast_cheek_c
	name = "Cyber Beast Cheeks C (Use A, B and C)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "c_beast_c"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_teshari_large_eyes
	name = "Teshari large eyes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "teshlarge_eyes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_teshari_coat
	name = "Teshari coat"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "tesh_coat"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_teshari_pattern_male
	name = "Teshari male pattern"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "tesh-pattern-male"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_teshari_pattern_female
	name = "Teshari female pattern"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "tesh-pattern-fem"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_unathihood
	name = "Cobra hood (small)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "unathihood"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_unathidoublehorns
	name = "Double Unathi Horns"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "unathidoublehorns"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_unathihorns
	name = "Unathi Horns"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "unathihorns"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_unathiramhorns
	name = "Unathi Ram Horns"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "unathiramhorns"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_unathishortspines
	name = "Unathi Short Spines"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "unathishortspines"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_unathilongspines
	name = "Unathi Long Spines"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "unathilongspines"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_unathishortfrills
	name = "Unathi Short Frills"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "unathishortfrills"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_unathilongfrills
	name = "Unathi Long Frills"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "unathilongfrills"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_thunderthighs
	name = "Boosted Thighs"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "thunderthighs"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr_altevian_snout
	name = "Altevian Snout"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "altevian-snout"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_altevian_chin
	name = "Altevian Chin"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "altevian-chin"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_altevian_nose
	name = "Altevian Nose"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "altevian-nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_altevian_fangs
	name = "Altevian Fangs"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "altevian-fangs"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_altevian_incisors
	name = "Altevian Incisors"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "altevian-incisors"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_eldritch_markings
	name = "Eldritch Markings"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "perrinmarkings"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD,BP_L_ARM,BP_L_HAND,BP_R_ARM,BP_R_HAND,BP_L_LEG,BP_L_FOOT,BP_R_LEG,BP_R_FOOT)

/datum/sprite_accessory/marking/vr_tesh_beak
	name = "Teshari beak, pointed"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "tesh-beak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_tesh_beak_alt
	name = "Teshari beak, rounded"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "tesh-beak-alt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_generic_hooves
	name = "Generic Hooves"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "generic_hooves"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT)
	hide_body_parts = list(BP_L_FOOT,BP_R_FOOT)
	organ_override = TRUE

/datum/sprite_accessory/marking/vr_unathi_blocky_head
	name = "Unathi alt head (Blocky)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "unathi_blocky_head"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	hide_body_parts = list(BP_HEAD)
	organ_override = TRUE

/datum/sprite_accessory/marking/vr_unathi_blocky_head_eyes
	name = "Unathi alt head eyes (Blocky)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "unathi_blocky_head_eyes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_manedwolf1
	name = "Maned Wolf Primary Markings"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "manedwolf1"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD,BP_TORSO,BP_R_ARM,BP_L_ARM,BP_R_HAND,BP_L_HAND,BP_R_LEG,BP_L_LEG,BP_R_FOOT,BP_L_FOOT)

/datum/sprite_accessory/marking/vr_manedwolf2
	name = "Maned Wolf Secondary Markings"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "manedwolf2"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD,BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_head_paint_front
	name = "Head Paint Front"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "paintfront"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_head_paint_back
	name = "Head Paint"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "paint"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_sect_drone
	name = "Sect Drone Bodytype"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "sectdrone"
	color_blend_mode = ICON_MULTIPLY
	hide_body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	organ_override = TRUE

/datum/sprite_accessory/marking/vr_sect_drone_eyes
	name = "Sect Drone Eyes"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "sectdrone_eyes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_zaprat_cheeks
	name = "Cheek Marks"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "zaprat_cheeks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_secbirbfeathers
	name = "Secretary Bird Feathers"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "secbirbfeathers"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_zmaskanime
	name = "eye mask (anime eyes)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "zmaskanime"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_birdpants
	name = "leg coverings (nev/rap)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "birdpants"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG, BP_L_LEG, BP_GROIN)

/datum/sprite_accessory/marking/vr/nevrean_long
	name = "Long Snout"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "nevrean_long"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_heterochromia_l
	name = "Heterochromia (left eye)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "heterochromia_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_teshi_heterochromia_l
	name = "Heterochromia (Teshari) (left eye)"
	icon = 'icons/mob/human_races/markings_vr.dmi'
	icon_state = "teshi_heterochromia_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

