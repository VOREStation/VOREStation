//////////////////////////////////
//				AI
//////////////////////////////////
/datum/job/ai
	title = JOB_AI
	flag = AI
	departments = list(DEPARTMENT_SYNTHETIC)
	sorting_order = 1 // Be above their borgs.
	department_flag = ENGSEC
	faction = FACTION_STATION
	total_positions = 0 // Not used for AI, see is_position_available below and modules/mob/living/silicon/ai/latejoin.dm
	spawn_positions = 1
	selection_color = "#3F823F"
	supervisors = "your Laws"
	req_admin_notify = 1
	minimal_player_age = 7
	account_allowed = 0
	economic_modifier = 0
	has_headset = FALSE
	assignable = FALSE
	mob_type = JOB_SILICON_AI
	outfit_type = /decl/hierarchy/outfit/job/silicon/ai
	job_description = "The " + JOB_AI + " oversees the operation of the station and its crew, but has no real authority over them. \
						The " + JOB_AI + " is required to follow its Laws, and Lawbound Synthetics that are linked to it are expected to follow \
						the " + JOB_AI + "'s commands, and their own Laws."

// AI procs
/datum/job/ai/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	return 1

/datum/job/ai/is_position_available()
	return (empty_playable_ai_cores.len != 0)

/datum/job/ai/equip_preview(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/straight_jacket(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cardborg(H), slot_head)
	return 1

//////////////////////////////////
//			Cyborg
//////////////////////////////////
/datum/job/cyborg
	title = JOB_CYBORG
	flag = CYBORG
	departments = list(DEPARTMENT_SYNTHETIC)
	department_flag = ENGSEC
	faction = FACTION_STATION
	total_positions = 2
	spawn_positions = 2
	supervisors = "your Laws and the " + JOB_AI	//Nodrak
	selection_color = "#254C25"
	minimal_player_age = 1
	account_allowed = 0
	economic_modifier = 0
	has_headset = FALSE
	assignable = FALSE
	mob_type = JOB_SILICON_ROBOT
	outfit_type = /decl/hierarchy/outfit/job/silicon/cyborg
	job_description = "A " + JOB_CYBORG + " is a mobile station synthetic, piloted by a cybernetically preserved brain. It is considered a person, but is still required \
						to follow its Laws."
	alt_titles = list(JOB_ALT_ROBOT = /datum/alt_title/robot, JOB_ALT_DRONE = /datum/alt_title/drone)

// Cyborg Alt Titles
/datum/alt_title/robot
	title = JOB_ALT_ROBOT
	title_blurb = "A Robot is a mobile station synthetic, piloted by an advanced piece of technology called a Positronic Brain. It is considered a person, \
					legally, but is required to follow its Laws."

/datum/alt_title/drone
	title = JOB_ALT_DRONE
	title_blurb = "A Drone is a mobile station synthetic, piloted by a simple computer-based AI. As such, it is not a person, but rather an expensive and \
					and important piece of station property, and is expected to follow its Laws."

// Cyborg procs
/datum/job/cyborg/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	return 1

/datum/job/cyborg/equip_preview(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/cardborg(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cardborg(H), slot_head)
	return 1
