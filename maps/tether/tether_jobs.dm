///////////////////////////////////
//// Talon Jobs
/datum/department/talon
	name = DEPARTMENT_TALON
	short_name = "Talon"
	color = "#888888"
	sorting_order = -2
	assignable = FALSE
	visible = FALSE

/datum/job/talon_captain
	title = "Talon Captain"
	flag = TALCAP
	department_flag = TALON
	departments_managed = list(DEPARTMENT_TALON)
	job_description = "The captain's job is to generate profit through trade or other means such as salvage or even privateering."
	supervisors = "yourself"
	outfit_type = /decl/hierarchy/outfit/job/talon_captain

	offmap_spawn = TRUE
	faction = "Station" //Required for SSjob to allow people to join as it
	departments = list(DEPARTMENT_TALON)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#999999"
	economic_modifier = 7
	minimal_player_age = 14
	pto_type = null
	access = list(access_talon)
	minimal_access = list(access_talon)

/datum/job/talon_doctor
	title = "Talon Doctor"
	flag = TALDOC
	department_flag = TALON
	job_description = "The doctor's job is to make sure the crew of the ITV Talon remain in good health and to monitor them when away from the ship."
	supervisors = "the ITV Talon's captain"
	outfit_type = /decl/hierarchy/outfit/job/talon_doctor

	offmap_spawn = TRUE
	faction = "Station" //Required for SSjob to allow people to join as it
	departments = list(DEPARTMENT_TALON)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#aaaaaa"
	economic_modifier = 5
	minimal_player_age = 14
	pto_type = null
	access = list(access_talon)
	minimal_access = list(access_talon)

/datum/job/talon_engineer
	title = "Talon Engineer"
	flag = TALENG
	department_flag = TALON
	job_description = "The engineer's job is to ensure the ITV Talon remains in tip-top shape and to repair any damage as well as manage the shields."
	supervisors = "the ITV Talon's captain"
	outfit_type = /decl/hierarchy/outfit/job/talon_engineer

	offmap_spawn = TRUE
	faction = "Station" //Required for SSjob to allow people to join as it
	departments = list(DEPARTMENT_TALON)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#aaaaaa"
	economic_modifier = 5
	minimal_player_age = 14
	pto_type = null
	access = list(access_talon)
	minimal_access = list(access_talon)

/datum/job/talon_pilot
	title = "Talon Pilot"
	flag = TALPIL
	department_flag = TALON
	job_description = "The pilot's job is to fly the ITV Talon in the most efficient and profitable way possible."
	supervisors = "the ITV Talon's captain"
	outfit_type = /decl/hierarchy/outfit/job/talon_pilot

	offmap_spawn = TRUE
	faction = "Station" //Required for SSjob to allow people to join as it
	departments = list(DEPARTMENT_TALON)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#aaaaaa"
	economic_modifier = 5
	minimal_player_age = 14
	pto_type = null
	access = list(access_talon)
	minimal_access = list(access_talon)

/datum/job/talon_guard
	title = "Talon Guard"
	flag = TALSEC
	department_flag = TALON
	job_description = "The guard's job is to keep the crew of the ITV Talon safe and ensure the captain's wishes are carried out."
	supervisors = "the ITV Talon's captain"
	outfit_type = /decl/hierarchy/outfit/job/talon_security

	offmap_spawn = TRUE
	faction = "Station" //Required for SSjob to allow people to join as it
	departments = list(DEPARTMENT_TALON)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#aaaaaa"
	economic_modifier = 5
	minimal_player_age = 14
	pto_type = null
	access = list(access_talon)
	minimal_access = list(access_talon)

/datum/job/talon_cyborg
	title = "Talon Cyborg"
	flag = TALBORG
	department_flag = TALON
	job_description = "A Cyborg is a mobile synthetic, piloted by a cybernetically preserved brain. It is considered a person, but is still required \
						to follow its Laws."
	supervisors = "your Laws and the ITV Talon's Captain"	// Might add an AI to the Talon later :3
	outfit_type = /decl/hierarchy/outfit/job/silicon/cyborg

	offmap_spawn = TRUE
	faction = "Station" //Required for SSjob to allow people to join as it
	departments = list(DEPARTMENT_TALON)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#aaaaaa"
	account_allowed = 0
	economic_modifier = 0
	minimal_player_age = 14
	has_headset = FALSE
	assignable = FALSE
	mob_type = JOB_SILICON_ROBOT

/decl/hierarchy/outfit/job/talon_captain
	name = OUTFIT_JOB_NAME("Talon Captain")

	id_type = /obj/item/weapon/card/id/gold
	id_slot = slot_wear_id
	pda_type = null

	l_ear = /obj/item/device/radio/headset/talon
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/rank/captain
	shoes = /obj/item/clothing/shoes/brown
	backpack = /obj/item/weapon/storage/backpack/captain
	satchel_one = /obj/item/weapon/storage/backpack/satchel/cap
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/com

/decl/hierarchy/outfit/job/talon_pilot
	name = OUTFIT_JOB_NAME("Talon Pilot")
	id_pda_assignment = "Pilot"

	id_slot = slot_wear_id
	pda_type = null
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL

	l_ear = /obj/item/device/radio/headset/talon
	shoes = /obj/item/clothing/shoes/black
	uniform = /obj/item/clothing/under/rank/pilot1
	suit = /obj/item/clothing/suit/storage/toggle/bomber/pilot
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/fakesunglasses/aviator

/decl/hierarchy/outfit/job/talon_doctor
	name = OUTFIT_JOB_NAME("Talon Doctor")
	hierarchy_type = /decl/hierarchy/outfit/job

	id_type = /obj/item/weapon/card/id/medical
	id_slot = slot_wear_id
	pda_type = null

	l_ear = /obj/item/device/radio/headset/talon
	shoes = /obj/item/clothing/shoes/white
	backpack = /obj/item/weapon/storage/backpack/medic
	satchel_one = /obj/item/weapon/storage/backpack/satchel/med
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/med
	uniform = /obj/item/clothing/under/rank/medical
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	l_hand = /obj/item/weapon/storage/firstaid/regular
	r_pocket = /obj/item/device/flashlight/pen

/decl/hierarchy/outfit/job/talon_security
	name = OUTFIT_JOB_NAME("Talon Security")
	hierarchy_type = /decl/hierarchy/outfit/job

	id_type = /obj/item/weapon/card/id/security
	id_slot = slot_wear_id
	pda_type = null
	backpack_contents = list(/obj/item/weapon/handcuffs = 1)

	l_ear = /obj/item/device/radio/headset/talon
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/boots/jackboots
	backpack = /obj/item/weapon/storage/backpack/security
	satchel_one = /obj/item/weapon/storage/backpack/satchel/sec
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/sec
	uniform = /obj/item/clothing/under/rank/security
	l_pocket = /obj/item/device/flash

/decl/hierarchy/outfit/job/talon_engineer
	name = OUTFIT_JOB_NAME("Talon Engineer")
	hierarchy_type = /decl/hierarchy/outfit/job

	id_type = /obj/item/weapon/card/id/engineering
	id_slot = slot_wear_id
	pda_type = null
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

	l_ear = /obj/item/device/radio/headset/talon
	belt = /obj/item/weapon/storage/belt/utility/full
	shoes = /obj/item/clothing/shoes/boots/workboots
	r_pocket = /obj/item/device/t_scanner
	backpack = /obj/item/weapon/storage/backpack/industrial
	satchel_one = /obj/item/weapon/storage/backpack/satchel/eng
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/engi
	uniform = /obj/item/clothing/under/rank/atmospheric_technician
	belt = /obj/item/weapon/storage/belt/utility/atmostech

/datum/job/talon_cyborg/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	return 1

/datum/job/talon_cyborg/equip_preview(mob/living/carbon/human/H)
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/cardborg(H), slot_wear_suit)
	H.equip_to_slot_or_del(new /obj/item/clothing/head/cardborg(H), slot_head)
	return 1
