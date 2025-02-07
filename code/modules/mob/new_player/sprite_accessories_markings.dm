/*
////////////////////////////
/  =--------------------=  /
/  ==  Body Markings   ==  /
/  =--------------------=  /
////////////////////////////

includes scars and tattoos
*/
/datum/sprite_accessory/marking
	icon = 'icons/mob/human_races/markings.dmi'
	do_colouration = 1 //Almost all of them have it, COLOR_ADD

	//Empty list is unrestricted. Should only restrict the ones that make NO SENSE on other species,
	//like Tajaran inner-ear coloring overlay stuff.
	//species_allowed = list()
	//This lets all races use

	//I'm leaving this in for posterity: IT DOES NOT. THE PROCS BREAK. YOU *WILL* RUNTIME THE LISTS.
	//besides, we permit all* combinations here, for the catgirls and foxgirls and all that lot
	//*the only exclusives are vox/teshari, due to the different base body shapes; stuff won't line up7

	color_blend_mode = ICON_ADD
	var/digitigrade_acceptance = MARKING_NONDIGI_ONLY
	var/digitigrade_icon = 'icons/mob/human_races/markings_digi.dmi'

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
	body_parts = list(BP_HEAD, BP_TORSO, BP_GROIN, BP_R_LEG, BP_L_LEG, BP_L_FOOT, BP_R_FOOT)
	color_blend_mode = ICON_MULTIPLY
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

/datum/sprite_accessory/marking/vr_inner_thigh
	name = "inner thighs"
	icon_state = "inner_thigh"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr_inner_arms
	name = "inner arms"
	icon_state = "inner_arm"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_R_ARM)

/datum/sprite_accessory/marking/vr_vulp_belly
	name = "belly fur (Vulp)"
	icon_state = "vulp_belly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_vulp_fullbelly
	name = "full belly fur (Vulp)"
	icon_state = "vulp_fullbelly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_vulp_fullbellyplus
	name = "full wide chest fur (Vulp)"
	icon_state = "vulp_fullchestplus"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_vulp_crest
	name = "belly crest (Vulp)"
	icon_state = "vulp_crest"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_vulp_nose
	name = "nose (Vulp)"
	icon_state = "vulp_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_vulp_short_nose
	name = "nose, short (Vulp)"
	icon_state = "vulp_short_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_snoutstripe
	name = "snout stripe (Vulp)"
	icon_state = "snoutstripe"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_vulp_face
	name = "face (Vulp)"
	icon_state = "vulp_face"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_vulp_facealt
	name = "face, alt. (Vulp)"
	icon_state = "vulp_facealt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_vulp_earsface
	name = "ears and face (Vulp)"
	icon_state = "vulp_earsface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_vulp_all
	name = "all head highlights (Vulp)"
	icon_state = "vulp_all"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_sergal_full
	name = "Sergal Markings"
	icon_state = "sergal_full"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	//species_allowed = list("Sergal")			//Removing Polaris whitelits

/datum/sprite_accessory/marking/vr_sergal_full_female
	name = "Sergal Markings (Female)"
	icon_state = "sergal_full_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	//("Sergal")

/datum/sprite_accessory/marking/vr_monoeye
	name = "Monoeye"
	icon_state = "monoeye"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_spidereyes
	name = "Spider Eyes"
	icon_state = "spidereyes"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_sergaleyes
	name = "Sergal Eyes"
	icon_state = "eyes_sergal"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_closedeyes
	name = "Closed Eyes"
	icon_state = "eyes_closed"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_brows
	name = "Eyebrows"
	icon_state = "brows"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_nevrean_female
	name = "Female Nevrean beak"
	icon_state = "nevrean_f"
	body_parts = list(BP_HEAD)
	color_blend_mode = ICON_MULTIPLY
	gender = FEMALE

/datum/sprite_accessory/marking/vr_nevrean_male
	name = "Male Nevrean beak"
	icon_state = "nevrean_m"
	body_parts = list(BP_HEAD)
	color_blend_mode = ICON_MULTIPLY
	gender = MALE

/datum/sprite_accessory/marking/vr_spots
	name = "Spots"
	icon_state = "spots"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr_shaggy_mane
	name = "Shaggy mane/feathers"
	icon_state = "shaggy"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr_jagged_teeth
	name = "Jagged teeth"
	icon_state = "jagged"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_blank_face
	name = "Blank round face (use with monster mouth)"
	icon_state = "blankface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_monster_mouth
	name = "Monster mouth"
	icon_state = "monster"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_saber_teeth
	name = "Saber teeth"
	icon_state = "saber"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_fangs
	name = "Fangs"
	icon_state = "fangs"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_tusks
	name = "Tusks"
	icon_state = "tusks"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_otie_face
	name = "Otie face"
	icon_state = "otieface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_otie_nose
	name = "Otie nose"
	icon_state = "otie_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_otienose_lite
	name = "Short otie nose"
	icon_state = "otienose_lite"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_backstripes
	name = "Back stripes"
	icon_state = "otiestripes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_belly_butt
	name = "Belly and butt"
	icon_state = "bellyandbutt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr_fingers_toes
	name = "Fingers and toes"
	icon_state = "fingerstoes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr_otie_socks
	name = "Fingerless socks"
	icon_state = "otiesocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr_corvid_beak
	name = "Corvid beak"
	icon_state = "corvidbeak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_corvid_belly
	name = "Corvid belly"
	icon_state = "corvidbelly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_cow_body
	name = "Cow markings"
	icon_state = "cowbody"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_cow_nose
	name = "Cow nose"
	icon_state = "cownose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_zmask
	name = "Eye mask"
	icon_state = "zmask"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_zbody
	name = "Thick jagged stripes"
	icon_state = "zbody"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr_znose
	name = "Jagged snout"
	icon_state = "znose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_otter_nose
	name = "Otter nose"
	icon_state = "otternose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_otter_face
	name = "Otter face"
	icon_state = "otterface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_deer_face
	name = "Deer face"
	icon_state = "deerface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_sharkface
	name = "Akula snout"
	icon_state = "sharkface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_sheppy_face
	name = "Shepherd snout"
	icon_state = "shepface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_sheppy_back
	name = "Shepherd back"
	icon_state = "shepback"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_zorren_belly_male
	name = "Zorren Male Torso"
	icon_state = "zorren_belly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_zorren_belly_female
	name = "Zorren Female Torso"
	icon_state = "zorren_belly_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_zorren_back_patch
	name = "Zorren Back Patch"
	icon_state = "zorren_backpatch"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr_zorren_face_male
	name = "Zorren Male Face"
	icon_state = "zorren_face"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = MALE

/datum/sprite_accessory/marking/vr_zorren_face_female
	name = "Zorren Female Face"
	icon_state = "zorren_face_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = FEMALE

/datum/sprite_accessory/marking/vr_zorren_muzzle_male
	name = "Zorren Male Muzzle"
	icon_state = "zorren_muzzle"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = MALE

/datum/sprite_accessory/marking/vr_zorren_muzzle_female
	name = "Zorren Female Muzzle"
	icon_state = "zorren_muzzle_female"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	gender = FEMALE

/datum/sprite_accessory/marking/vr_zorren_socks
	name = "Zorren Socks"
	icon_state = "zorren_socks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr_zorren_longsocks
	name = "Zorren Longsocks"
	icon_state = "zorren_longsocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr_tesh_feathers
	name = "Teshari Feathers"
	icon_state = "tesh-feathers"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_harpy_feathers
	name = "Rapala leg Feather"
	icon_state = "harpy-feathers"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr_harpy_legs
	name = "Rapala leg coloring"
	icon_state = "harpy-leg"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr_chooves
	name = "Cloven hooves"
	icon_state = "chooves"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT)

/datum/sprite_accessory/marking/vr_topscars
	name = "Top surgery scars"
	icon_state = "topscars"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr_body_tonage
	name = "Body tonage"
	icon_state = "tonage"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr_body_tone
	name = "Body toning (for emergency contrast loss)"
	icon_state = "btone"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr_gloss
	name = "Full body gloss"
	icon_state = "gloss"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_eboop_panels
	name = "Eggnerd FBP panels"
	icon_state = "eboop"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_osocks_complete
	name = "Modular Longsocks"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_ARM,BP_R_HAND,BP_L_ARM,BP_L_HAND,BP_R_FOOT,BP_R_LEG,BP_L_FOOT,BP_L_LEG)

//TODO: remove these in a few months?
/datum/sprite_accessory/marking/vr_osocks_rarm
	name = "Modular Longsock (right arm)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_ARM,BP_R_HAND)

/datum/sprite_accessory/marking/vr_osocks_larm
	name = "Modular Longsock (left arm)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_L_HAND)

/datum/sprite_accessory/marking/vr_osocks_rleg
	name = "Modular Longsock (right leg)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_FOOT,BP_R_LEG)

/datum/sprite_accessory/marking/vr_osocks_lleg
	name = "Modular Longsock (left leg)"
	icon_state = "osocks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_L_LEG)
//END TODO

/datum/sprite_accessory/marking/vr_gradient
	name = "Gradient (Arms and Legs)"
	icon_state = "gradient"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_ARM,BP_R_HAND,BP_L_ARM,BP_L_HAND,BP_R_FOOT,BP_R_LEG,BP_L_FOOT,BP_L_LEG)

/datum/sprite_accessory/marking/vr_animeeyesinner
	name = "Anime Eyes Inner"
	icon_state = "animeeyesinner"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_animeeyesouter
	name = "Anime Eyes Outer"
	icon_state = "animeeyesouter"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_panda_eye_marks
	name = "Panda Eye Markings"
	icon_state = "eyes_panda"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_catwomantorso
	name = "Catwoman chest stripes"
	icon_state = "catwomanchest"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr_catwomangroin
	name = "Catwoman groin stripes"
	icon_state = "catwomangroin"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN)

/datum/sprite_accessory/marking/vr_catwoman_rleg
	name = "Catwoman right leg stripes"
	icon_state = "catwomanright"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/vr_catwoman_lleg
	name = "Catwoman left leg stripes"
	icon_state = "catwomanleft"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/vr_teshi_small_feathers
	name = "Teshari small wingfeathers"
	icon_state = "teshi_sf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_HAND,BP_R_HAND,BP_TORSO)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_spirit_lights
	name = "Ward - Spirit FBP Lights"
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_spirit_lights_body
	name = "Ward - Spirit FBP Lights (body)"
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO)

/datum/sprite_accessory/marking/vr_spirit_lights_head
	name = "Ward - Spirit FBP Lights (head)"
	icon_state = "lights"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_spirit_panels
	name = "Ward - Spirit FBP Panels"
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_spirit_panels_body
	name = "Ward - Spirit FBP Panels (body)"
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO)

/datum/sprite_accessory/marking/vr_spirit_panels_head
	name = "Ward - Spirit FBP Panels (head)"
	icon_state = "panels"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_tentacle_head
	name = "Squid Head"
	icon_state = "tentaclehead"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_tentacle_mouth
	name = "Tentacle Mouth"
	icon_state = "tentaclemouth"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_rosette
	name = "Rosettes"
	icon_state = "rosette"
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)

/datum/sprite_accessory/marking/vr_werewolf_nose
	name = "Werewolf nose"
	icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf_nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_WEREBEAST)

/datum/sprite_accessory/marking/vr_werewolf_face
	name = "Werewolf face"
	icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_WEREBEAST)

/datum/sprite_accessory/marking/vr_werewolf_belly
	name = "Werewolf belly"
	icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN,BP_TORSO)
	species_allowed = list(SPECIES_WEREBEAST)

/datum/sprite_accessory/marking/vr_werewolf_socks
	name = "Werewolf socks"
	icon = 'icons/mob/species/werebeast/werebeast_markings.dmi'
	icon_state = "werewolf"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)
	species_allowed = list(SPECIES_WEREBEAST)

/datum/sprite_accessory/marking/vr_shadekin_snoot
	name = "Shadekin Snoot"
	icon_state = "shadekin-snoot"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_SHADEKIN, SPECIES_SHADEKIN_CREW)

/datum/sprite_accessory/marking/vr_taj_nose_alt
	name = "Nose Color, alt. (Taj)"
	icon_state = "taj_nosealt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_talons
	name = "Talons"
	icon_state = "talons"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr_claws
	name = "Claws"
	icon_state = "claws"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr_equine_snout //Why the long face? Works best with sergal bodytype.
	name = "Equine Snout"
	icon_state = "donkey"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_equine_nose
	name = "Equine Nose"
	icon_state = "dnose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_bee_stripes
	name = "bee stripes"
	icon_state = "beestripes"
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_vas_toes
	name = "Bug Paws (Vasilissan)"
	icon_state = "vas_toes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT)

/datum/sprite_accessory/marking/vr_vulp_skull
	name = "Vulpkanin Skull Face"
	icon_state = "vulp_skull"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_una_skull
	name = "Unathi Skull Face"
	icon_state = "una_skull"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_bellyspiral
	name = "Belly Spiral"
	icon_state = "bellyspiral"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_fluffy_cuffs
	name = "Wrist Fluff"
	icon_state = "fluffy_cuffs"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND)

/datum/sprite_accessory/marking/vr_chubby_belly
	name = "Chubby Belly"
	icon_state = "chubby_belly"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_chubby_belly_s
	name = "Smooth Chubby Belly"
	icon_state = "chubby_belly_s"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_r_belly_fluff
	name = "Belly Fluff"
	icon_state = "belly_fluff"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr_r_chest_fluff
	name = "Chest Fluff"
	icon_state = "chest_fluff"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr_tesh_skull
	name = "Teshari Skull Face"
	icon_state = "teshari_skull"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_shoulder_fluff
	name = "Shoulder Fluff"
	icon_state = "shoulder_markings"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_ARM,BP_R_ARM)

//CitRP stuff

/datum/sprite_accessory/marking/vr_c_beast_body
	name = "Cyber Body"
	icon_state = "c_beast_body"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_c_beast_plating
	name = "Cyber Plating (Use w/ Cyber Body)"
	icon_state = "c_beast_plating"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM)

/datum/sprite_accessory/marking/vr_c_beast_band
	name = "Cyber Band (Use w/ Cybertech head)"
	icon_state = "c_beast_band"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_c_beast_cheek_a
	name = "Cyber Beast Cheeks A (Use A, B and C)"
	icon_state = "c_beast_a"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_c_beast_cheek_b
	name = "Cyber Beast Cheeks B (Use A, B and C)"
	icon_state = "c_beast_b"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_c_beast_cheek_c
	name = "Cyber Beast Cheeks C (Use A, B and C)"
	icon_state = "c_beast_c"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_teshari_large_eyes
	name = "Teshari large eyes"
	icon_state = "teshlarge_eyes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_teshari_coat
	name = "Teshari coat"
	icon_state = "tesh_coat"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_TORSO,BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_teshari_pattern_male
	name = "Teshari male pattern"
	icon_state = "tesh-pattern-male"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_teshari_pattern_female
	name = "Teshari female pattern"
	icon_state = "tesh-pattern-fem"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG,BP_L_HAND,BP_R_HAND,BP_TORSO,BP_GROIN,BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_unathihood
	name = "Cobra hood (small)"
	icon_state = "unathihood"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_unathidoublehorns
	name = "Double Unathi Horns"
	icon_state = "unathidoublehorns"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_unathihorns
	name = "Unathi Horns"
	icon_state = "unathihorns"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_unathiramhorns
	name = "Unathi Ram Horns"
	icon_state = "unathiramhorns"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_unathishortspines
	name = "Unathi Short Spines"
	icon_state = "unathishortspines"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_unathilongspines
	name = "Unathi Long Spines"
	icon_state = "unathilongspines"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_unathishortfrills
	name = "Unathi Short Frills"
	icon_state = "unathishortfrills"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_unathilongfrills
	name = "Unathi Long Frills"
	icon_state = "unathilongfrills"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_thunderthighs
	name = "Boosted Thighs"
	icon_state = "thunderthighs"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr_altevian_snout
	name = "Altevian Snout"
	icon_state = "altevian-snout"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_altevian_chin
	name = "Altevian Chin"
	icon_state = "altevian-chin"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_altevian_nose
	name = "Altevian Nose"
	icon_state = "altevian-nose"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_altevian_fangs
	name = "Altevian Fangs"
	icon_state = "altevian-fangs"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_altevian_incisors
	name = "Altevian Incisors"
	icon_state = "altevian-incisors"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_eldritch_markings
	name = "Eldritch Markings"
	icon_state = "perrinmarkings"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD,BP_L_ARM,BP_L_HAND,BP_R_ARM,BP_R_HAND,BP_L_LEG,BP_L_FOOT,BP_R_LEG,BP_R_FOOT)

/datum/sprite_accessory/marking/vr_tesh_beak
	name = "Teshari beak, pointed"
	icon_state = "tesh-beak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_tesh_beak_alt
	name = "Teshari beak, rounded"
	icon_state = "tesh-beak-alt"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_generic_hooves
	name = "Generic Hooves"
	icon_state = "generic_hooves"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT,BP_R_FOOT)
	hide_body_parts = list(BP_L_FOOT,BP_R_FOOT)
	organ_override = TRUE

/datum/sprite_accessory/marking/vr_unathi_blocky_head
	name = "Unathi alt head (Blocky)"
	icon_state = "unathi_blocky_head"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)
	hide_body_parts = list(BP_HEAD)
	organ_override = TRUE

/datum/sprite_accessory/marking/vr_unathi_blocky_head_eyes
	name = "Unathi alt head eyes (Blocky)"
	icon_state = "unathi_blocky_head_eyes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_manedwolf1
	name = "Maned Wolf Primary Markings"
	icon_state = "manedwolf1"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD,BP_TORSO,BP_R_ARM,BP_L_ARM,BP_R_HAND,BP_L_HAND,BP_R_LEG,BP_L_LEG,BP_R_FOOT,BP_L_FOOT)

/datum/sprite_accessory/marking/vr_manedwolf2
	name = "Maned Wolf Secondary Markings"
	icon_state = "manedwolf2"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD,BP_TORSO,BP_GROIN)

/datum/sprite_accessory/marking/vr_head_paint_front
	name = "Head Paint Front"
	icon_state = "paintfront"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_head_paint_back
	name = "Head Paint"
	icon_state = "paint"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_knees_to_chest
	name = "knees to chest"
	icon_state = "knees_to_chest"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO,BP_GROIN,BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/vr_sect_drone
	name = "Sect Drone Bodytype"
	icon_state = "sectdrone"
	color_blend_mode = ICON_MULTIPLY
	hide_body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	body_parts = list(BP_L_FOOT,BP_R_FOOT,BP_L_LEG,BP_R_LEG,BP_L_ARM,BP_R_ARM,BP_L_HAND,BP_R_HAND,BP_GROIN,BP_TORSO,BP_HEAD)
	organ_override = TRUE

/datum/sprite_accessory/marking/vr_sect_drone_eyes
	name = "Sect Drone Eyes"
	icon_state = "sectdrone_eyes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_zaprat_cheeks
	name = "Cheek Marks"
	icon_state = "zaprat_cheeks"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_secbirbfeathers
	name = "Secretary Bird Feathers"
	icon_state = "secbirbfeathers"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_zmaskanime
	name = "eye mask (anime eyes)"
	icon_state = "zmaskanime"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_birdpants
	name = "leg coverings (nev/rap)"
	icon_state = "birdpants"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG, BP_L_LEG, BP_GROIN)

/datum/sprite_accessory/marking/vr_nevrean_long
	name = "Long Snout"
	icon_state = "nevrean_long"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_heterochromia_l
	name = "Heterochromia (left eye)"
	icon_state = "heterochromia_l"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_teshi_heterochromia_l
	name = "Heterochromia (Teshari) (left eye)"
	icon_state = "teshi_heterochromia_l"
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_TESHARI)

/datum/sprite_accessory/marking/vr_nevrean_beak //that's right, its bird rework time
	name = "nevrean beak"
	icon_state = "nevrean_beak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_parrot_beak
	name = "parrot beak (nev)"
	icon_state = "parrot_beak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_thin_beak //kiwis and hummingbirds
	name = "thin beak (nev)"
	icon_state = "thin_beak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_finch_beak
	name = "finch beak (nev)"
	icon_state = "finch_beak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_pelican_beak
	name = "pelican beak (nev)"
	icon_state = "pelican_beak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_pelican_beak_pouch //recolor the pouch
	name = "pelican beak pouch (nev)"
	icon_state = "pelican_beak_pouch"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_toucan_beak
	name = "toucan beak (nev)"
	icon_state = "toucan_beak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_toucan_beak_tip //recolor the tip
	name = "toucan beak tip (nev)"
	icon_state = "toucan_beak_tip"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_raptor_beak_small
	name = "bird of prey beak, small (nev)"
	icon_state = "raptor_beak_small"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_raptor_beak_large
	name = "bird of prey beak, large (nev)"
	icon_state = "raptor_beak_large"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_nev_heartface
	name = "heart face (nev)"
	icon_state = "heartface"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_nev_fullhead
	name = "full head recolor (nev)"
	icon_state = "full_head_nev"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_nev_tophead
	name = "top of the head recolor (nev)"
	icon_state = "top_head_nev"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_nev_cheeks //the face ones
	name = "bird face cheeks (nev)"
	icon_state = "cheeks_nev"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

// Dino stuff
/datum/sprite_accessory/marking/vr_dino_horn
	name = "dino horn"
	icon_state = "dino_horn"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_dino_plates
	name = "stegosaurus plates"
	icon_state = "stegoplates"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/vr_triceratops_beak
	name = "triceratops beak"
	icon_state = "triceratops_beak"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_triceratops_horn
	name = "triceratops horn"
	icon_state = "triceratops_horn"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/vr_backsail
	name = "backsail"
	icon_state = "backsail"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

//Replikant-specific markings

/datum/sprite_accessory/marking/replikant/replika_r_thigh
	name = "Replikant Stripe - Right Thigh"
	icon_state = "replika"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG)

/datum/sprite_accessory/marking/replikant/replika_r_knee
	name = "Replikant Stripe - Right Knee"
	icon_state = "replika"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_FOOT)

/datum/sprite_accessory/marking/replikant/replika_l_thigh
	name = "Replikant Stripe - Left Thigh"
	icon_state = "replika"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG)

/datum/sprite_accessory/marking/replikant/replika_l_knee
	name = "Replikant Stripe - Left Knee"
	icon_state = "replika"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT)

/datum/sprite_accessory/marking/replikant/replika_panels_body
	name = "Replikant Paneling - SynthFlesh (body)"
	icon_state = "replikao"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_TORSO)

/datum/sprite_accessory/marking/replikant/replika_panels_groin
	name = "Replikant Paneling - SynthFlesh (groin)"
	icon_state = "replika"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_GROIN)

//Digitigrade markings
/datum/sprite_accessory/marking/digi
	name = "Digitigrate Marking Subcat, Please Ignore"
	icon = 'icons/mob/human_races/markings_digi.dmi'
	digitigrade_acceptance = MARKING_DIGITIGRADE_ONLY

/datum/sprite_accessory/marking/digi/fullleft
	name = "Digitigrade Full Left Leg(Only works with digitigrade legs)"
	icon_state = "full"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_L_FOOT)

/datum/sprite_accessory/marking/digi/fullright
	name = "Digitigrade Full Right Leg(Only works with digitigrade legs)"
	icon_state = "full"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG,BP_R_FOOT)

/datum/sprite_accessory/marking/digi/longsockleft
	name = "Digitigrade Long Socks Left(Only works with digitigrade legs)"
	icon_state = "longsock"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_L_FOOT)

/datum/sprite_accessory/marking/digi/longsockright
	name = "Digitigrade Long Socks Right(Only works with digitigrade legs)"
	icon_state = "longsock"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG,BP_R_FOOT)

/datum/sprite_accessory/marking/digi/medsockleft
	name = "Digitigrade Medium Socks Left(Only works with digitigrade legs)"
	icon_state = "medsock"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_L_FOOT)

/datum/sprite_accessory/marking/digi/medsockright
	name = "Digitigrade Medium Socks Right(Only works with digitigrade legs)"
	icon_state = "medsock"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG,BP_R_FOOT)

/datum/sprite_accessory/marking/digi/shortsockleft
	name = "Digitigrade Short Socks Left(Only works with digitigrade legs)"
	icon_state = "shortsock"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT)

/datum/sprite_accessory/marking/digi/shortsockright
	name = "Digitigrade Short Socks Right(Only works with digitigrade legs)"
	icon_state = "shortsock"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_FOOT)

/datum/sprite_accessory/marking/digi/toesleft
	name = "Digitigrade Toes Left(Only works with digitigrade legs)"
	icon_state = "toes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_FOOT)

/datum/sprite_accessory/marking/digi/toesright
	name = "Digitigrade Toes Right(Only works with digitigrade legs)"
	icon_state = "toes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_FOOT)

/datum/sprite_accessory/marking/digi/stripesleft
	name = "Digitigrade Stripes Left(Only works with digitigrade legs)"
	icon_state = "stripes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_L_FOOT)

/datum/sprite_accessory/marking/digi/stripesright
	name = "Digitigrade Stripes Right(Only works with digitigrade legs)"
	icon_state = "stripes"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG,BP_R_FOOT)

/datum/sprite_accessory/marking/digi/smallspotsleft
	name = "Digitigrade Small Spots Left(Only works with digitigrade legs)"
	icon_state = "smallspots"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_L_FOOT)

/datum/sprite_accessory/marking/digi/smallspotsright
	name = "Digitigrade Small Spots Right(Only works with digitigrade legs)"
	icon_state = "smallspots"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG,BP_R_FOOT)

/datum/sprite_accessory/marking/digi/bigspotsleft
	name = "Digitigrade Big Spots Left(Only works with digitigrade legs)"
	icon_state = "bigspots"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_L_FOOT)

/datum/sprite_accessory/marking/digi/bigspotsright
	name = "Digitigrade Big Spots Right(Only works with digitigrade legs)"
	icon_state = "bigspots"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_R_LEG,BP_R_FOOT)

/datum/sprite_accessory/marking/digi/inner_thigh
	name = "inner thighs (digitigrade)"
	icon_state = "digi_inner"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_R_LEG)

/datum/sprite_accessory/marking/digi/gradient
	name = "Digitigrade Gradient, Legs (Only works with digitigrade legs)"
	icon_state = "digigradient"
	color_blend_mode = ICON_MULTIPLY
	body_parts = list(BP_L_LEG,BP_L_FOOT,BP_R_LEG,BP_R_FOOT)
