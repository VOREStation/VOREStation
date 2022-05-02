<<<<<<< HEAD:code/modules/mob/living/carbon/human/human_defines.dm
/mob/living/carbon/human
	//Hair colour and style
	var/r_hair = 0
	var/g_hair = 0
	var/b_hair = 0
	var/h_style = "Bald"

	var/r_grad = 0
	var/g_grad = 0
	var/b_grad = 0
	var/grad_style = "none"
	//Facial hair colour and style
	var/r_facial = 0
	var/g_facial = 0
	var/b_facial = 0
	var/f_style = "Shaved"

	//Eye colour
	var/r_eyes = 0
	var/g_eyes = 0
	var/b_eyes = 0

	var/s_tone = 0	//Skin tone

	//Skin colour
	var/r_skin = 0
	var/g_skin = 0
	var/b_skin = 0

	var/skin_state = SKIN_NORMAL

	//Synth colors
	var/synth_color	= 0					//Lets normally uncolorable synth parts be colorable.
	var/r_synth							//Used with synth_color to color synth parts that normaly can't be colored.
	var/g_synth							//Same as above
	var/b_synth							//Same as above
	var/synth_markings = 0				//Enables/disables markings on synth parts.

	//var/size_multiplier = 1 //multiplier for the mob's icon size //VOREStation Edit (Moved to /mob/living)
	var/damage_multiplier = 1 //multiplies melee combat damage
	var/icon_update = 1 //whether icon updating shall take place

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup

	var/age = 30		//Player's age (pure fluff)
	var/b_type = "A+"	//Player's bloodtype
	var/datum/robolimb/synthetic		//If they are a synthetic (aka synthetic torso). Also holds the datum for the type of robolimb.

	var/list/all_underwear = list()
	var/list/all_underwear_metadata = list()
	var/list/hide_underwear = list()
	var/backbag = 2		//Which backpack type the player has chosen.
	var/pdachoice = 1	//Which PDA type the player has chosen.

	// General information
	var/home_system = ""
	var/citizenship = ""
	var/personal_faction = ""
	var/religion = ""
	var/antag_faction = ""
	var/antag_vis = ""

	//Equipment slots
	var/obj/item/wear_suit = null
	var/obj/item/w_uniform = null
	var/obj/item/shoes = null
	var/obj/item/belt = null
	var/obj/item/gloves = null
	var/obj/item/glasses = null
	var/obj/item/head = null
	var/obj/item/l_ear = null
	var/obj/item/r_ear = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null

	var/used_skillpoints = 0
	var/skill_specialization = null
	var/list/skills = list()

	var/voice = ""	//Instead of new say code calling GetVoice() over and over and over, we're just going to ask this variable, which gets updated in Life()

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/last_dam = -1	//Used for determining if we need to process all organs or just some or even none.

	var/xylophone = 0 //For the spoooooooky xylophone cooldown

	var/mob/remoteview_target = null
	var/hand_blood_color

	var/list/flavor_texts = list()
	var/gunshot_residue
	var/pulling_punches    // Are you trying not to hurt your opponent?
	var/robolimb_count = 0 // Total number of external robot parts.
	var/robobody_count = 0 // Counts torso, groin, and head, if they're robotic

	mob_bump_flag = HUMAN
	mob_push_flags = ~HEAVY
	mob_swap_flags = ~HEAVY

	var/identifying_gender // In case the human identifies as another gender than it's biological

	var/list/descriptors	// For comparative examine code

	var/step_count = 0 // Track how many footsteps have been taken to know when to play footstep sounds

	can_be_antagged = TRUE

// Used by mobs in virtual reality to point back to the "real" mob the client belongs to.
	var/mob/living/carbon/human/vr_holder = null
	// Used by "real" mobs after they leave a VR session
	var/mob/living/carbon/human/vr_link = null

	var/obj/machinery/machine_visual //machine that is currently applying visual effects to this mob. Only used for camera monitors currently.

	inventory_panel_type = /datum/inventory_panel/human
	butchery_loot = list(/obj/item/stack/animalhide/human = 1)

	// Horray Furries!
	var/datum/sprite_accessory/ears/ear_style = null
	var/r_ears = 30
	var/g_ears = 30
	var/b_ears = 30
	var/r_ears2 = 30
	var/g_ears2 = 30
	var/b_ears2 = 30
	var/r_ears3 = 30 //Trust me, we could always use more colour. No japes.
	var/g_ears3 = 30
	var/b_ears3 = 30
	var/datum/sprite_accessory/tail/tail_style = null
	var/r_tail = 30
	var/g_tail = 30
	var/b_tail = 30
	var/r_tail2 = 30
	var/g_tail2 = 30
	var/b_tail2 = 30
	var/r_tail3 = 30
	var/g_tail3 = 30
	var/b_tail3 = 30
	var/datum/sprite_accessory/wing/wing_style = null
	var/r_wing = 30
	var/g_wing = 30
	var/b_wing = 30
	var/r_wing2 = 30
	var/g_wing2 = 30
	var/b_wing2 = 30
	var/r_wing3 = 30
	var/g_wing3 = 30
	var/b_wing3 = 30

	var/wagging = 0 //UGH.
	var/flapping = 0

	// Custom Species Name
	var/custom_species
=======
/mob/living/human
	//Hair colour and style
	var/r_hair = 0
	var/g_hair = 0
	var/b_hair = 0
	var/h_style = "Bald"

	var/r_grad = 0
	var/g_grad = 0
	var/b_grad = 0
	var/grad_style = "none"
	//Facial hair colour and style
	var/r_facial = 0
	var/g_facial = 0
	var/b_facial = 0
	var/f_style = "Shaved"

	//Eye colour
	var/r_eyes = 0
	var/g_eyes = 0
	var/b_eyes = 0

	var/s_tone = 0	//Skin tone

	//Skin colour
	var/r_skin = 0
	var/g_skin = 0
	var/b_skin = 0

	var/skin_state = SKIN_NORMAL

	//Synth colors
	var/synth_color	= 0					//Lets normally uncolorable synth parts be colorable.
	var/r_synth							//Used with synth_color to color synth parts that normaly can't be colored.
	var/g_synth							//Same as above
	var/b_synth							//Same as above
	var/synth_markings = 0				//Enables/disables markings on synth parts.

	var/damage_multiplier = 1 //multiplies melee combat damage
	var/icon_update = 1 //whether icon updating shall take place

	var/lip_style = null	//no lipstick by default- arguably misleading, as it could be used for general makeup

	var/age = 30		//Player's age (pure fluff)
	var/b_type = "A+"	//Player's bloodtype
	var/datum/robolimb/synthetic		//If they are a synthetic (aka synthetic torso). Also holds the datum for the type of robolimb.

	var/list/all_underwear = list()
	var/list/all_underwear_metadata = list()
	var/list/hide_underwear = list()
	var/backbag = 2		//Which backpack type the player has chosen.
	var/pdachoice = 1	//Which PDA type the player has chosen.

	// General information
	var/home_system = ""
	var/citizenship = ""
	var/personal_faction = ""
	var/religion = ""
	var/antag_faction = ""
	var/antag_vis = ""

	//Equipment slots
	var/obj/item/wear_suit = null
	var/obj/item/w_uniform = null
	var/obj/item/shoes = null
	var/obj/item/belt = null
	var/obj/item/gloves = null
	var/obj/item/glasses = null
	var/obj/item/head = null
	var/obj/item/l_ear = null
	var/obj/item/r_ear = null
	var/obj/item/wear_id = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/obj/item/s_store = null

	inventory_panel_type = /datum/inventory_panel/human

	var/used_skillpoints = 0
	var/skill_specialization = null
	var/list/skills = list()

	var/voice = ""	//Instead of new say code calling GetVoice() over and over and over, we're just going to ask this variable, which gets updated in Life()

	var/special_voice = "" // For changing our voice. Used by a symptom.

	var/last_dam = -1	//Used for determining if we need to process all organs or just some or even none.

	var/xylophone = 0 //For the spoooooooky xylophone cooldown

	var/mob/remoteview_target = null
	var/hand_blood_color

	var/list/flavor_texts = list()
	var/gunshot_residue
	var/pulling_punches    // Are you trying not to hurt your opponent?
	var/robolimb_count = 0 // Total number of external robot parts.
	var/robobody_count = 0 // Counts torso, groin, and head, if they're robotic

	mob_bump_flag = HUMAN
	mob_push_flags = ~HEAVY
	mob_swap_flags = ~HEAVY

	var/identifying_gender // In case the human identifies as another gender than it's biological

	var/list/descriptors	// For comparative examine code

	var/step_count = 0 // Track how many footsteps have been taken to know when to play footstep sounds

	can_be_antagged = TRUE

// Used by mobs in virtual reality to point back to the "real" mob the client belongs to.
	var/mob/living/human/vr_holder = null
	// Used by "real" mobs after they leave a VR session
	var/mob/living/human/vr_link = null

	var/obj/machinery/machine_visual //machine that is currently applying visual effects to this mob. Only used for camera monitors currently.
	butchery_loot = list(/obj/item/stack/animalhide/human = 1)

	// Horray Furries!
	var/datum/sprite_accessory/ears/ear_style = null
	var/r_ears = 30
	var/g_ears = 30
	var/b_ears = 30
	var/r_ears2 = 30
	var/g_ears2 = 30
	var/b_ears2 = 30
	var/r_ears3 = 30 //Trust me, we could always use more colour. No japes.
	var/g_ears3 = 30
	var/b_ears3 = 30
	var/datum/sprite_accessory/tail/tail_style = null
	var/r_tail = 30
	var/g_tail = 30
	var/b_tail = 30
	var/r_tail2 = 30
	var/g_tail2 = 30
	var/b_tail2 = 30
	var/r_tail3 = 30
	var/g_tail3 = 30
	var/b_tail3 = 30
	var/datum/sprite_accessory/wing/wing_style = null
	var/r_wing = 30
	var/g_wing = 30
	var/b_wing = 30
	var/r_wing2 = 30
	var/g_wing2 = 30
	var/b_wing2 = 30
	var/r_wing3 = 30
	var/g_wing3 = 30
	var/b_wing3 = 30

	var/wagging = 0 //UGH.
	var/flapping = 0

	// Custom Species Name
	var/custom_species

	var/list/chem_effects = list()
	var/pulse = PULSE_NORM	//current pulse level

	var/list/datum/disease2/disease/virus2 = list()
	var/list/antibodies = list()

	var/shock_stage = 0

	var/obj/item/handcuffed = null // Whether or not the mob is handcuffed
	var/obj/item/legcuffed = null  // Same as handcuffs but for legs. Bear traps use this.

	var/does_not_breathe = FALSE // Used for specific mobs that can't take advantage of the species flags (changelings)
>>>>>>> 666428014d2... Merge pull request #8546 from Atermonera/surgery_refactor:code/modules/mob/living/human/human_defines.dm
