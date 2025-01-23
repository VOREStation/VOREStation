/*
////////////////////////////
/  =--------------------=  /
/  ==  Body Markings   ==  /
/  =--------------------=  /
////////////////////////////
*/
/datum/sprite_accessory/marking
	icon = 'icons/mob/human_races/markings.dmi'
	do_colouration = 1 //Almost all of them have it, COLOR_ADD

	//Empty list is unrestricted. Should only restrict the ones that make NO SENSE on other species,
	//like Tajaran inner-ear coloring overlay stuff.
	species_allowed = list()
	//This lets all races use

	color_blend_mode = ICON_ADD

	var/genetic = TRUE
	var/organ_override = FALSE
	var/body_parts = list() //A list of bodyparts this covers, in organ_tag defines
	//Reminder: BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD

//Tattoos

/datum/sprite_accessory/marking/tat_rheart
	name = "Tattoo (Heart, R. Arm)"
	icon_state = "tat_rheart"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tat_lheart
	name = "Tattoo (Heart, L. Arm)"
	icon_state = "tat_lheart"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/tat_hive
	name = "Tattoo (Hive, Back)"
	icon_state = "tat_hive"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/tat_nightling
	name = "Tattoo (Nightling, Back)"
	icon_state = "tat_nightling"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/tat_campbell_full
	name = "Tattoo (Campbell, Arms/Legs)"
	icon_state = "tat_campbell"
	body_parts = list (BP_R_ARM,BP_L_ARM,BP_R_LEG,BP_L_LEG)

//TODO: remove these in a few months?
/datum/sprite_accessory/marking/tat_campbell
	name = "Tattoo (Campbell, R.Arm)"
	icon_state = "tat_campbell"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/tat_campbell/left
	name = "Tattoo (Campbell, L.Arm)"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/tat_campbell/rightleg
	name = "Tattoo (Campbell, R.Leg)"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/tat_campbell/leftleg
	name = "Tattoo (Campbell, L.Leg)"
	body_parts = list (BP_L_LEG)
//END TODO

/datum/sprite_accessory/marking/tat_silverburgh
	name = "Tattoo (Silverburgh, R.Leg)"
	icon_state = "tat_silverburgh"
	body_parts = list (BP_R_LEG)

/datum/sprite_accessory/marking/tat_silverburgh/left
	name = "Tattoo (Silverburgh, L.Leg)"
	icon_state = "tat_silverburgh"
	body_parts = list (BP_L_LEG)

/datum/sprite_accessory/marking/tat_tiger
	name = "Tattoo (Tiger Stripes, Body)"
	icon_state = "tat_tiger"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)

//New tats

/datum/sprite_accessory/marking/tat_belly
	name = "Tattoo (Belly)"
	icon_state = "tat_belly"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/tat_forrest_left
	name = "Tattoo (Forrest, Left Eye)"
	icon_state = "tat_forrest_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_forrest_right
	name = "Tattoo (Forrest, Right Eye)"
	icon_state = "tat_forrest_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_hunter_left
	name = "Tattoo (Hunter, Left Eye)"
	icon_state = "tat_hunter_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_hunter_right
	name = "Tattoo (Hunter, Right Eye)"
	icon_state = "tat_hunter_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_jaeger_left
	name = "Tattoo (Jaeger, Left Eye)"
	icon_state = "tat_jaeger_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_jaeger_right
	name = "Tattoo (Jaeger, Right Eye)"
	icon_state = "tat_jaeger_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_kater_left
	name = "Tattoo (Kater, Left Eye)"
	icon_state = "tat_kater_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_kater_right
	name = "Tattoo (Kater, Right Eye)"
	icon_state = "tat_kater_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_lujan_left
	name = "Tattoo (Lujan, Left Eye)"
	icon_state = "tat_lujan_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_lujan_right
	name = "Tattoo (Lujan, Right Eye)"
	icon_state = "tat_lujan_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_montana_left
	name = "Tattoo (Montana, Left Face)"
	icon_state = "tat_montana_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_montana_right
	name = "Tattoo (Montana, Right Face)"
	icon_state = "tat_montana_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_natasha_left
	name = "Tattoo (Natasha, Left Eye)"
	icon_state = "tat_natasha_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_natasha_right
	name = "Tattoo (Natasha, Right Eye)"
	icon_state = "tat_natasha_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_tamoko
	name = "Tattoo (Ta Moko, Face)"
	icon_state = "tat_tamoko"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_toshi_left
	name = "Tattoo (Toshi, Left Eye)"
	icon_state = "tat_toshi_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_toshi_right
	name = "Tattoo (Volgin, Right Eye)"
	icon_state = "tat_toshi_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tat_wings_back
	name = "Tattoo (Wings, Lower Back)"
	icon_state = "tat_wingsback"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/tilaka
	name = "Tilaka"
	icon_state = "tilaka"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/bands
	name = "Color Bands"
	icon_state = "bands"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/bandsface
	name = "Color Bands (Face)"
	icon_state = "bandsface"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/bandsface_human
	name = "Color Bands (Face)"
	icon_state = "bandshumanface"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tiger_stripes
	name = "Tiger Stripes"
	icon_state = "tiger"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/tigerhead
	name = "Tiger Stripes (Head, Minor)"
	icon_state = "tigerhead"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/tigerface
	name = "Tiger Stripes (Head, Major)"
	icon_state = "tigerface"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/backstripe
	name = "Back Stripe"
	icon_state = "backstripe"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/bindi
	name = "Bindi"
	icon_state = "bindi"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/blush
	name = "Blush"
	icon_state= "blush"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/bridge
	name = "Bridge"
	icon_state = "bridge"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/brow_left
	name = "Brow Left"
	icon_state = "brow_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/brow_left/teshari
	name = "Brow Left (Teshari)"
	icon_state = "brow_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/brow_right
	name = "Brow Right"
	icon_state = "brow_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/brow_right/teshari
	name = "Brow Right (Teshari)"
	icon_state = "brow_r_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/cheekspot_left
	name = "Cheek Spot (Left Cheek)"
	icon_state = "cheekspot_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/cheekspot_right
	name = "Cheek Spot (Right Cheek)"
	icon_state = "cheekspot_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/cheshire_left
	name = "Cheshire (Left Cheek)"
	icon_state = "cheshire_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/cheshire_right
	name = "Cheshire (Right Cheek)"
	icon_state = "cheshire_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/eyestripe
	name = "Eye Stripe"
	icon_state = "eyestripe"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/eyestripe/teshari
	name = "Eye Stripe (Teshari)"
	icon_state = "eyestripe_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/eyecorner_left
	name = "Eye Corner Left"
	icon_state = "eyecorner_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/eyecorner_left/teshari
	name = "Eye Corner Left (Teshari)"
	icon_state = "eyecorner_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/eyecorner_right
	name = "Eye Corner Right"
	icon_state = "eyecorner_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/eyecorner_right/teshari
	name = "Eye Corner Right (Teshari)"
	icon_state = "eyecorner_r_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/fullfacepaint
	name = "Full Face Paint"
	icon_state = "fullface"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/lips
	name = "Lips"
	icon_state = "lips"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/lowercheek_left
	name = "Lower Cheek Left"
	icon_state = "lowercheek_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/lowercheek_left
	name = "Lower Cheek Right"
	icon_state = "lowercheek_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/neck
	name = "Neck Cover"
	icon_state = "neck"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/neckthick
	name = "Neck Cover (Thick)"
	icon_state = "neckthick"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/nosestripe
	name = "Nose Stripe"
	icon_state = "nosestripe"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/nosestripe/teshari
	name = "Nose Stripe (Teshari)"
	icon_state = "nosestripe_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/nosetape
	name = "Nose Tape"
	icon_state = "nosetape"
	body_parts = list(BP_HEAD)
	genetic = FALSE

/datum/sprite_accessory/marking/nosetape/tesh
	name = "Nose Tape (Teshari)"
	icon_state = "nosetape_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_abdomen_left
	name = "Scar, Abdomen Left"
	icon_state = "scar_abdomen_l"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_abdomen_left/teshari
	name = "Scar, Abdomen Left (Teshari)"
	icon_state = "scar_abdomen_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_abdomen_right
	name = "Scar, Abdomen Right"
	icon_state = "scar_abdomen_r"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_abdomen_right/teshari
	name = "Scar, Abdomen Right (Teshari)"
	icon_state = "scar_abdomen_r_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_abdomen_small_left
	name = "Scar, Abdomen Small Left"
	icon_state = "scar_abdomensmall_l"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_abdomen_small_left/teshari
	name = "Scar, Abdomen Small Left (Teshari)"
	icon_state = "scar_abdomensmall_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_abdomen_small_right
	name = "Scar, Abdomen Small Right"
	icon_state = "scar_abdomensmall_r"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_abdomen_small_right/teshari
	name = "Scar, Abdomen Small Right (Teshari)"
	icon_state = "scar_abdomensmall_r_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_back_large
	name = "Scar, Back Large"
	icon_state = "scar_back_large"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_back_large/teshari
	name = "Scar, Back Large (Teshari)"
	icon_state = "scar_back_large_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_back_small
	name = "Scar, Back Small (Center)"
	icon_state = "scar_back_small"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_back_small/teshari
	name = "Scar, Back Small (Center)(Teshari)"
	icon_state = "scar_back_small_tesh"
	species_allowed = list(SPECIES_TESHARI)
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_back_small_upper_right
	name = "Scar, Back Small (Upper Right)"
	icon_state = "scar_back_small_ur"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_back_small_upper_left
	name = "Scar, Back Small (Upper Left)"
	icon_state = "scar_back_small_ul"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_back_small_lower_right
	name = "Scar, Back Small (Lower Right)"
	icon_state = "scar_back_small_lr"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_back_small_lower_left
	name = "Scar, Back Small (Lower Left)"
	icon_state = "scar_back_small_ll"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_chest_large_left
	name = "Scar, Chest Large (Left)"
	icon_state = "scar_chest_large_l"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_chest_large_left/teshari
	name = "Scar, Chest Large (Left)(Teshari)"
	icon_state = "scar_chest_large_l_tesh"
	species_allowed = list(SPECIES_TESHARI)
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_chest_large_right
	name = "Scar, Chest Large (Right)"
	icon_state = "scar_chest_large_r"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_chest_large_right/teshari
	name = "Scar, Chest Large (Right)(Teshari)"
	icon_state = "scar_chest_large_r_tesh"
	species_allowed = list(SPECIES_TESHARI)
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_chest_small_left
	name = "Scar, Chest Small (Left)"
	icon_state = "scar_chest_small_l"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_chest_small_left/teshari
	name = "Scar, Chest Small (Left)(Teshari)"
	icon_state = "scar_chest_small_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_chest_small_right
	name = "Scar, Chest Small (Right)"
	icon_state = "scar_chest_small_r"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_chest_small_right/teshari
	name = "Scar, Chest Small (Right)(Teshari)"
	icon_state = "scar_chest_small_r_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_belly
	name = "Scar, Belly"
	icon_state = "scar_belly"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/scar_belly/teshari
	name = "Scar, Belly (Teshari)"
	icon_state = "scar_belly_tesh"
	species_allowed = list(SPECIES_TESHARI)
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/scar_cheek_left
	name = "Scar, Cheek (Left)"
	icon_state = "scar_cheek_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_cheek_right
	name = "Scar, Cheek (Right)"
	icon_state = "scar_cheek_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_forehead_left
	name = "Scar, Forehead (Left)"
	icon_state = "scar_forehead_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_forehead_left/teshari
	name = "Scar, Forehead (Left)(Teshari)"
	icon_state = "scar_forehead_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_forehead_right
	name = "Scar, Forehead (Right)"
	icon_state = "scar_forehead_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_forehead_right/teshari
	name = "Scar, Forehead (Right)(Teshari)"
	icon_state = "scar_forehead_r_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_chin
	name = "Scar, Chin"
	icon_state = "scar_chin"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_muzzle_teshari
	name = "Scar, Muzzle"
	icon_state = "scar_muzzle_tesh"
	species_allowed = list(SPECIES_TESHARI)
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_eye_left
	name = "Scar, Over Eye (Left)"
	icon_state = "scar_eye_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_eye_left/teshari
	name = "Scar, Over Eye (Left)(Teshari)"
	icon_state = "scar_eye_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_eye_right
	name = "Scar, Over Eye (Right)"
	icon_state = "scar_eye_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/scar_eye_right/teshari
	name = "Scar, Over Eye (Right)(Teshari)"
	icon_state = "scar_eye_r_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_arm_upper
	name = "Scar, Left Arm (Upper)"
	icon_state = "scar_arm_left_u"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/scar_left_arm_upper/teshari
	name = "Scar, Left Arm (Upper)(Teshari)"
	icon_state = "scar_arm_left_u_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_arm_lower
	name = "Scar, Left Arm (Lower)"
	icon_state = "scar_arm_left_l"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/scar_left_arm_lower/teshari
	name = "Scar, Left Arm (Lower)(Teshari)"
	icon_state = "scar_arm_left_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_arm_rear
	name = "Scar, Left Arm (Rear)"
	icon_state = "scar_arm_left_rear"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/scar_left_arm_rear/teshari
	name = "Scar, Left Arm (Rear)(Teshari)"
	icon_state = "scar_arm_left_rear_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_hand
	name = "Scar, Left Hand"
	icon_state = "scar_hand_left"
	body_parts = list(BP_L_HAND)

/datum/sprite_accessory/marking/scar_left_hand/teshari
	name = "Scar, Left Hand (Teshari)"
	icon_state = "scar_hand_left_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_arm_upper
	name = "Scar, Right Arm (Upper)"
	icon_state = "scar_arm_right_u"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/scar_right_arm_upper/teshari
	name = "Scar, Right Arm (Upper)(Teshari)"
	icon_state = "scar_arm_right_u_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_arm_lower
	name = "Scar, Right Arm (Lower)"
	icon_state = "scar_arm_right_l"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/scar_right_arm_lower/teshari
	name = "Scar, Right Arm (Lower)(Teshari)"
	icon_state = "scar_arm_right_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_arm_rear
	name = "Scar, Right Arm (Rear)"
	icon_state = "scar_arm_right_rear"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/scar_right_arm_rear/teshari
	name = "Scar, Right Arm (Rear)(Teshari)"
	icon_state = "scar_arm_right_rear_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_hand
	name = "Scar, Right Hand"
	icon_state = "scar_hand_right"
	body_parts = list(BP_R_HAND)

/datum/sprite_accessory/marking/scar_right_hand/teshari
	name = "Scar, Right Hand (Teshari)"
	icon_state = "scar_hand_right_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_leg_upper
	name = "Scar, Left Leg (Upper)"
	icon_state = "scar_leg_left_u"
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/scar_left_leg_upper/teshari
	name = "Scar, Left Leg (Upper)(Teshari)"
	icon_state = "scar_leg_left_u_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_leg_lower
	name = "Scar, Left Leg (Lower)"
	icon_state = "scar_leg_left_l"
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/scar_left_leg_lower/teshari
	name = "Scar, Left Leg (Lower)(Teshari)"
	icon_state = "scar_leg_left_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_leg_rear
	name = "Scar, Left Leg (Rear)"
	icon_state = "scar_leg_left_rear"
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/scar_left_leg_rear/teshari
	name = "Scar, Left Leg (Rear)(Teshari)"
	icon_state = "scar_leg_left_rear_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_left_foot
	name = "Scar, Left Foot"
	icon_state = "scar_left_foot"
	body_parts = list(BP_L_FOOT)

/datum/sprite_accessory/marking/scar_left_foot/teshari
	name = "Scar, Left Foot (Teshari)"
	icon_state = "scar_left_foot_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_leg_upper
	name = "Scar, Right Leg (Upper)"
	icon_state = "scar_right_leg_u"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/scar_right_leg_upper/teshari
	name = "Scar, Right Leg (Upper)(Teshari)"
	icon_state = "scar_right_leg_u_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_leg_lower
	name = "Scar, Right Leg (Lower)"
	icon_state = "scar_right_leg_l"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/scar_right_leg_lower/teshari
	name = "Scar, Right Leg (Lower)(Teshari)"
	icon_state = "scar_right_leg_l_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_leg_rear
	name = "Scar, Right Leg (Rear)"
	icon_state = "scar_right_leg_rear"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/scar_right_leg_rear/teshari
	name = "Scar, Right Leg (Rear)(Teshari)"
	icon_state = "scar_right_leg_rear_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/scar_right_foot
	name = "Scar, Right Foot"
	icon_state = "scar_right_foot"
	body_parts = list(BP_R_FOOT)

/datum/sprite_accessory/marking/scar_right_foot/teshari
	name = "Scar, Right Foot (Teshari)"
	icon_state = "scar_right_foot_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/skull_paint
	name = "Skull Paint"
	icon_state = "skull"
	body_parts = list(BP_HEAD)
	genetic = FALSE

//Heterochromia

/datum/sprite_accessory/marking/heterochromia
	name = "Heterochromia (right eye)"
	icon_state = "heterochromia"
	body_parts = list(BP_HEAD)

//Taj/Unathi shared markings

/datum/sprite_accessory/marking/taj_paw_socks
	name = "Socks Coloration (Taj)"
	icon_state = "taj_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/una_paw_socks
	name = "Socks Coloration (Una)"
	icon_state = "una_pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/paw_socks
	name = "Socks Coloration (Generic)"
	icon_state = "pawsocks"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/paw_socks_belly
	name = "Socks,Belly Coloration (Generic)"
	icon_state = "pawsocksbelly"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/belly_hands_feet
	name = "Hands,Feet,Belly Color (Minor)"
	icon_state = "bellyhandsfeetsmall"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/hands_feet_belly_full
	name = "Hands,Feet,Belly Color (Major)"
	icon_state = "bellyhandsfeet"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/hands_feet_belly_full_female
	name = "Hands,Feet,Belly Color (Major, Female)"
	icon_state = "bellyhandsfeet_female"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/patches
	name = "Color Patches"
	icon_state = "patches"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/patchesface
	name = "Color Patches (Face)"
	icon_state = "patchesface"
	body_parts = list(BP_HEAD)

//Taj specific stuff
/datum/sprite_accessory/marking/taj_belly
	name = "Belly Fur (Taj)"
	icon_state = "taj_belly"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/taj_bellyfull
	name = "Belly Fur Wide (Taj)"
	icon_state = "taj_bellyfull"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/taj_earsout
	name = "Outer Ear (Taj)"
	icon_state = "taj_earsout"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/taj_earsin
	name = "Inner Ear (Taj)"
	icon_state = "taj_earsin"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/taj_nose
	name = "Nose Color (Taj)"
	icon_state = "taj_nose"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/taj_crest
	name = "Chest Fur Crest (Taj)"
	icon_state = "taj_crest"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/taj_muzzle
	name = "Muzzle Color (Taj)"
	icon_state = "taj_muzzle"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/taj_face
	name = "Cheeks Color (Taj)"
	icon_state = "taj_face"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/taj_all
	name = "All Taj Head (Taj)"
	icon_state = "taj_all"
	body_parts = list(BP_HEAD)

//Una specific stuff
/datum/sprite_accessory/marking/una_face
	name = "Face Color (Una)"
	icon_state = "una_face"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/una_facelow
	name = "Face Color Low (Una)"
	icon_state = "una_facelow"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/una_scutes
	name = "Scutes (Una)"
	icon_state = "una_scutes"
	body_parts = list(BP_TORSO)

//Tesh stuff.
/datum/sprite_accessory/marking/teshi_fluff
	name = "Underfluff (Teshari)"
	icon_state = "teshi_fluff"
	body_parts = list(BP_HEAD, BP_TORSO, BP_GROIN, BP_R_LEG, BP_L_LEG)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/teshi_heterochromia
	name = "Heterochromia (Teshari) (right eye)"
	icon_state = "teshi_heterochromia"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

	//Diona stuff.

/datum/sprite_accessory/marking/diona_leaves
	name = "Leaves (Diona)"
	icon_state = "diona_leaves"
	body_parts = list(BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_TORSO, BP_GROIN, BP_HEAD)

/datum/sprite_accessory/marking/diona_thorns
	name = "Thorns (Diona)"
	icon_state = "diona_thorns"
	body_parts =list(BP_TORSO, BP_HEAD)
	do_colouration = 0

/datum/sprite_accessory/marking/diona_flowers
	name = "Flowers (Diona)"
	icon_state = "diona_flowers"
	body_parts =list(BP_TORSO, BP_HEAD)
	do_colouration = 0

/datum/sprite_accessory/marking/diona_moss
	name = "Moss (Diona)"
	icon_state = "diona_moss"
	body_parts =list(BP_TORSO)
	do_colouration = 0

/datum/sprite_accessory/marking/diona_mushroom
	name = "Mushroom (Diona)"
	icon_state = "diona_mushroom"
	body_parts =list(BP_HEAD)
	do_colouration = 0

/datum/sprite_accessory/marking/diona_antennae
	name = "Antennae (Diona)"
	icon_state = "diona_antennae"
	body_parts =list(BP_HEAD)
	do_colouration = 0

//Skrell stuff.
/datum/sprite_accessory/marking/skrell
	name = "Countershading (Skrell)"
	icon_state = "skr_shade"
	body_parts = list(BP_TORSO, BP_GROIN, BP_HEAD)

/datum/sprite_accessory/marking/skrell/stripes
	name = "Poison Dart Stripes (Skrell)"
	icon_state = "skr_stripes"
	body_parts = list(BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM, BP_TORSO)

//Cybernetic Augments, some species-limited due to sprite misalignment. /aug/ types are excluded from dna.
/datum/sprite_accessory/marking/aug
	name = "Augment (Backports, Back)"
	icon_state = "aug_backports"
	genetic = FALSE
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/aug/diode
	name = "Augment (Backports Diode, Back)"
	icon_state = "aug_backportsdiode"

/datum/sprite_accessory/marking/aug/backportswide
	name = "Augment (Backports Wide, Back)"
	icon_state = "aug_backportswide"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/aug/backportswide/diode
	name = "Augment (Backports Wide Diode, Back)"
	icon_state = "aug_backportswidediode"

/datum/sprite_accessory/marking/aug/headcase
	name = "Augment (Headcase, Head)"
	icon_state = "aug_headcase"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/headcase_light
	name = "Augment (Headcase Light, Head)"
	icon_state = "aug_headcaselight"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/headport
	name = "Augment (Headport, Head)"
	icon_state = "aug_headport"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/headport/diode
	name = "Augment (Headport Diode, Head)"
	icon_state = "aug_headplugdiode"

/datum/sprite_accessory/marking/aug/lowerjaw
	name = "Augment (Lower Jaw, Head)"
	icon_state = "aug_lowerjaw"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/scalpports
	name = "Augment (Scalp Ports)"
	icon_state = "aug_scalpports"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/scalpports/vertex_left
	name = "Augment (Scalp Port, Vertex Left)"
	icon_state = "aug_vertexport_l"

/datum/sprite_accessory/marking/aug/scalpports/vertex_right
	name = "Augment (Scalp Port, Vertex Right)"
	icon_state = "aug_vertexport_r"

/datum/sprite_accessory/marking/aug/scalpports/occipital_left
	name = "Augment (Scalp Port, Occipital Left)"
	icon_state = "aug_occipitalport_l"

/datum/sprite_accessory/marking/aug/scalpports/occipital_right
	name = "Augment (Scalp Port, Occipital Right)"
	icon_state = "aug_occipitalport_r"

/datum/sprite_accessory/marking/aug/scalpportsdiode
	name = "Augment (Scalp Ports Diode)"
	icon_state = "aug_scalpportsdiode"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/scalpportsdiode/vertex_left
	name = "Augment (Scalp Port Diode, Vertex Left)"
	icon_state = "aug_vertexportdiode_l"

/datum/sprite_accessory/marking/aug/scalpportsdiode/vertex_right
	name = "Augment (Scalp Port Diode, Vertex Right)"
	icon_state = "aug_vertexportdiode_r"

/datum/sprite_accessory/marking/aug/scalpportsdiode/occipital_left
	name = "Augment (Scalp Port Diode, Occipital Left)"
	icon_state = "aug_occipitalportdiode_l"

/datum/sprite_accessory/marking/aug/scalpportsdiode/occipital_right
	name = "Augment (Scalp Port Diode, Occipital Right)"
	icon_state = "aug_occipitalportdiode_r"

/datum/sprite_accessory/marking/aug/backside_left
	name = "Augment (Backside Left, Head)"
	icon_state = "aug_backside_l"

/datum/sprite_accessory/marking/aug/backside_left/side_diode
	name = "Augment (Backside Left Diode, Head)"
	icon_state = "aug_sidediode_l"

/datum/sprite_accessory/marking/aug/backside_right
	name = "Augment (Backside Right, Head)"
	icon_state = "aug_backside_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/backside_right/side_diode
	name = "Augment (Backside Right Diode, Head)"
	icon_state = "aug_sidediode_r"

/datum/sprite_accessory/marking/aug/side_deunan_left
	name = "Augment (Deunan, Side Left)"
	icon_state = "aug_sidedeunan_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/side_deunan_right
	name = "Augment (Deunan, Side Right)"
	icon_state = "aug_sidedeunan_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/side_kuze_left
	name = "Augment (Kuze, Side Left)"
	icon_state = "aug_sidekuze_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/side_kuze_left/side_diode
	name = "Augment (Kuze Diode, Side Left)"
	icon_state = "aug_sidekuzediode_l"

/datum/sprite_accessory/marking/aug/side_kuze_right
	name = "Augment (Kuze, Side Right)"
	icon_state = "aug_sidekuze_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/side_kuze_right/side_diode
	name = "Augment (Kuze Diode, Side Right)"
	icon_state = "aug_sidekuzediode_r"

/datum/sprite_accessory/marking/aug/side_kinzie_left
	name = "Augment (Kinzie, Side Left)"
	icon_state = "aug_sidekinzie_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/side_kinzie_right
	name = "Augment (Kinzie, Side Right)"
	icon_state = "aug_sidekinzie_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/side_shelly_left
	name = "Augment (Shelly, Side Left)"
	icon_state = "aug_sideshelly_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/side_shelly_right
	name = "Augment (Shelly, Side Right)"
	icon_state = "aug_sideshelly_r"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/aug/chestports
	name = "Augment (Chest Ports)"
	icon_state = "aug_chestports"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/aug/chestports/teshari
	name = "Augment (Chest Ports)(Teshari)"
	icon_state = "aug_chestports_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/aug/abdomenports
	name = "Augment (Abdomen Ports)"
	icon_state = "aug_abdomenports"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/aug/abdomenports/teshari
	name = "Augment (Abdomen Ports)(Teshari)"
	icon_state = "aug_abdomenports_tesh"
	body_parts = list(BP_GROIN)
	species_allowed = list(SPECIES_TESHARI)

//bandages

/datum/sprite_accessory/marking/bandage
	name = "Bandage, Head 1"
	icon_state = "bandage1"
	body_parts = list(BP_HEAD)
	genetic = FALSE
	do_colouration = FALSE

/datum/sprite_accessory/marking/bandage/teshari
	name = "Bandage, Head 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/head2
	name = "Bandage, Head 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/head2/teshari
	name = "Bandage, Head 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/head3
	name = "Bandage, Head 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/head3/teshari
	name = "Bandage, Head 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/torso
	name = "Bandage, Torso 1"
	icon_state = "bandage1"
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/bandage/torso/teshari
	name = "Bandage, Torso 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/torso/torso2
	name = "Bandage, Torso 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/torso/torso2/teshari
	name = "Bandage, Torso 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/torso/torso3
	name = "Bandage, Torso 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/torso/torso3/teshari
	name = "Bandage, Torso 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/groin
	name = "Bandage, Groin 1"
	icon_state = "bandage1"
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/bandage/groin/teshari
	name = "Bandage, Groin 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/groin/groin2
	name = "Bandage, Groin 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/groin/groin2/teshari
	name = "Bandage, Groin 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/groin/groin3
	name = "Bandage, Groin 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/groin/groin3/teshari
	name = "Bandage, Groin 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_arm
	name = "Bandage, Left Arm 1"
	icon_state = "bandage1"
	body_parts = list(BP_L_ARM)

/datum/sprite_accessory/marking/bandage/l_arm/teshari
	name = "Bandage, Left Arm 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_arm/l_arm2
	name = "Bandage, Left Arm 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/l_arm/l_arm2/teshari
	name = "Bandage, Left Arm 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_arm/l_arm3
	name = "Bandage, Left Arm 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/l_arm/l_arm3/teshari
	name = "Bandage, Left Arm 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_hand
	name = "Bandage, Left Hand 1"
	icon_state = "bandage1"
	body_parts = list(BP_L_HAND)

/datum/sprite_accessory/marking/bandage/l_hand/teshari
	name = "Bandage, Left Hand 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_hand/l_hand2
	name = "Bandage, Left Hand 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/l_hand/l_hand_2/teshari
	name = "Bandage, Left Hand 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_hand/l_hand3
	name = "Bandage, Left Hand 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/r_arm
	name = "Bandage, Right Arm 1"
	icon_state = "bandage1"
	body_parts = list(BP_R_ARM)

/datum/sprite_accessory/marking/bandage/r_arm/teshari
	name = "Bandage, Right Arm 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_arm/r_arm2
	name = "Bandage, Right Arm 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/r_arm/r_arm2/teshari
	name = "Bandage, Right Arm 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_arm/r_arm3
	name = "Bandage, Right Arm 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/r_arm/r_arm3/teshari
	name = "Bandage, Right Arm 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_hand
	name = "Bandage, Right Hand 1"
	icon_state = "bandage1"
	body_parts = list(BP_R_HAND)

/datum/sprite_accessory/marking/bandage/r_hand/teshari
	name = "Bandage, Right Hand 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_hand/r_hand2
	name = "Bandage, Right Hand 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/r_hand/r_hand2/teshari
	name = "Bandage, Right Hand 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_hand/r_hand3
	name = "Bandage, Right Hand 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/l_leg
	name = "Bandage, Left Leg 1"
	icon_state = "bandage1"
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/bandage/l_leg/teshari
	name = "Bandage, Left Leg 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_leg/l_leg2
	name = "Bandage, Left Leg 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/l_leg/l_leg2/teshari
	name = "Bandage, Left Leg 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_leg/l_leg3
	name = "Bandage, Left Leg 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/l_leg/l_leg3/teshari
	name = "Bandage, Left Leg 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_foot
	name = "Bandage, Left Foot 1"
	icon_state = "bandage1"
	body_parts = list(BP_L_FOOT)

/datum/sprite_accessory/marking/bandage/l_foot/teshari
	name = "Bandage, Left Foot 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_foot/l_foot2
	name = "Bandage, Left Foot 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/l_foot/l_foot_2/teshari
	name = "Bandage, Left Foot 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/l_foot/l_foot3
	name = "Bandage, Left Foot 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/l_foot/l_foot_3/teshari
	name = "Bandage, Left Foot 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_leg
	name = "Bandage, Right Leg 1"
	icon_state = "bandage1"
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/bandage/r_leg/teshari
	name = "Bandage, Right Leg 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_leg/r_leg2
	name = "Bandage, Right Leg 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/r_leg/r_leg2/teshari
	name = "Bandage, Right Leg 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_leg/r_leg3
	name = "Bandage, Right Leg 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/r_leg/r_leg3/teshari
	name = "Bandage, Right Leg 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_foot
	name = "Bandage, Right Foot 1"
	icon_state = "bandage1"
	body_parts = list(BP_R_FOOT)

/datum/sprite_accessory/marking/bandage/r_foot/teshari
	name = "Bandage, Right Foot 1 (Teshari)"
	icon_state = "bandage1_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_foot/r_foot2
	name = "Bandage, Right Foot 2"
	icon_state = "bandage2"

/datum/sprite_accessory/marking/bandage/r_foot/r_foot2/teshari
	name = "Bandage, Right Foot 2 (Teshari)"
	icon_state = "bandage2_tesh"
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/bandage/r_foot/r_foot3
	name = "Bandage, Right Foot 3"
	icon_state = "bandage3"

/datum/sprite_accessory/marking/bandage/r_foot/r_foot3/teshari
	name = "Bandage, Right Foot 3 (Teshari)"
	icon_state = "bandage3_tesh"
	species_allowed = list(SPECIES_TESHARI)

//Vox Exclusives
/datum/sprite_accessory/marking/vox
	name = "Vox Beak"
	icon = 'icons/mob/human_races/markings_vox.dmi'
	icon_state = "vox_beak"
	species_allowed = list(SPECIES_VOX)
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vox/voxtalons
	name = "Vox scales"
	icon_state = "vox_talons"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_ARM,BP_L_ARM,BP_R_HAND,BP_L_HAND,BP_R_LEG,BP_L_LEG,BP_R_FOOT,BP_L_FOOT)

/datum/sprite_accessory/marking/vox/voxclaws
	name = "Vox Claws"
	icon_state = "Voxclaws"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vox/vox_alt
	name = "Vox Alternate"
	icon_state = "bay_vox"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)

/datum/sprite_accessory/marking/vox/vox_alt_eyes
	name = "Alternate Vox Eyes"
	icon_state = "bay_vox_eyes"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vox/voxscales
	name = "Alternate Vox scales"
	icon_state = "Voxscales"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_ARM,BP_L_ARM,BP_R_HAND,BP_L_HAND,BP_R_LEG,BP_L_LEG,BP_R_FOOT,BP_L_FOOT)

/datum/sprite_accessory/marking/vox/dinomuzzle
	name = "Vox Dinosaur Muzzle"
	icon_state = "vox_muzzle"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
