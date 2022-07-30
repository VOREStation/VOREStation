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
	playtime_only = TRUE
	pto_type = PTO_TALON
	timeoff_factor = 1
	dept_time_required = 60
	access = list(access_talon)
	minimal_access = list(access_talon)
	alt_titles = list("Talon Commander" = /datum/alt_title/talon_commander)

/datum/alt_title/talon_commander
	title = "Talon Commander"

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
	playtime_only = TRUE
	pto_type = PTO_TALON
	timeoff_factor = 1
	access = list(access_talon)
	minimal_access = list(access_talon)
	alt_titles = list("Talon Medic" = /datum/alt_title/talon_medic)

/datum/alt_title/talon_medic
	title = "Talon Medic"


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
	playtime_only = TRUE
	pto_type = PTO_TALON
	timeoff_factor = 1
	access = list(access_talon)
	minimal_access = list(access_talon)
	alt_titles = list("Talon Technician" = /datum/alt_title/talon_tech)

/datum/alt_title/talon_tech
	title = "Talon Technician"


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
	playtime_only = TRUE
	pto_type = PTO_TALON
	timeoff_factor = 1
	access = list(access_talon)
	minimal_access = list(access_talon)
	alt_titles = list("Talon Helmsman" = /datum/alt_title/talon_helmsman)

/datum/alt_title/talon_helmsman
	title = "Talon Helmsman"


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
	playtime_only = TRUE
	pto_type = PTO_TALON
	timeoff_factor = 1
	access = list(access_talon)
	minimal_access = list(access_talon)
	alt_titles = list("Talon Security" = /datum/alt_title/talon_security)

/datum/alt_title/talon_security
	title = "Talon Security"

/datum/job/talon_miner
	title = "Talon Miner"
	flag = TALMIN
	department_flag = TALON
	job_description = "The miner's job is to excavate ores and refine them for the Talon's use, as well as for trading."
	supervisors = "the ITV Talon's captain"
	outfit_type = /decl/hierarchy/outfit/job/talon_miner

	offmap_spawn = TRUE
	faction = "Station" //Required for SSjob to allow people to join as it
	departments = list(DEPARTMENT_TALON)
	total_positions = 1
	spawn_positions = 1
	selection_color = "#aaaaaa"
	economic_modifier = 5
	minimal_player_age = 14
	playtime_only = TRUE
	pto_type = PTO_TALON
	timeoff_factor = 1
	access = list(access_talon)
	minimal_access = list(access_talon)
	alt_titles = list("Talon Excavator" = /datum/alt_title/talon_excavator)

/datum/alt_title/talon_excavator
	title = "Talon Excavator"

//////////////////////TALON OUTFITS//////////////////////

/decl/hierarchy/outfit/job/talon_captain
	name = OUTFIT_JOB_NAME("Talon Captain")

	id_type = /obj/item/card/id/talon/captain
	id_slot = slot_wear_id
	pda_type = null

	l_ear = /obj/item/radio/headset/talon
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/rank/talon/command
	shoes = /obj/item/clothing/shoes/brown
	backpack = /obj/item/storage/backpack/talon
	satchel_one = /obj/item/storage/backpack/satchel/talon
	messenger_bag = /obj/item/storage/backpack/messenger/talon

/decl/hierarchy/outfit/job/talon_pilot
	name = OUTFIT_JOB_NAME("Talon Pilot")

	id_type = /obj/item/card/id/talon/pilot
	id_slot = slot_wear_id
	pda_type = null
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL

	l_ear = /obj/item/radio/headset/talon
	shoes = /obj/item/clothing/shoes/black
	head = /obj/item/clothing/head/pilot_vr/talon
	uniform = /obj/item/clothing/under/rank/talon/pilot
	suit = /obj/item/clothing/suit/storage/toggle/bomber/pilot
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/fakesunglasses/aviator
	uniform_accessories = list(/obj/item/clothing/accessory/storage/webbing/pilot1 = 1)
	backpack = /obj/item/storage/backpack/talon
	satchel_one = /obj/item/storage/backpack/satchel/talon
	messenger_bag = /obj/item/storage/backpack/messenger/talon

/decl/hierarchy/outfit/job/talon_doctor
	name = OUTFIT_JOB_NAME("Talon Doctor")
	hierarchy_type = /decl/hierarchy/outfit/job

	id_type = /obj/item/card/id/talon/doctor
	id_slot = slot_wear_id
	pda_type = null

	l_ear = /obj/item/radio/headset/talon
	shoes = /obj/item/clothing/shoes/white
	backpack = /obj/item/storage/backpack/medic
	satchel_one = /obj/item/storage/backpack/satchel/med
	messenger_bag = /obj/item/storage/backpack/messenger/med
	uniform = /obj/item/clothing/under/rank/talon/proper
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	l_hand = /obj/item/storage/firstaid/regular
	r_pocket = /obj/item/flashlight/pen
	backpack = /obj/item/storage/backpack/talon
	satchel_one = /obj/item/storage/backpack/satchel/talon
	messenger_bag = /obj/item/storage/backpack/messenger/talon

/decl/hierarchy/outfit/job/talon_security
	name = OUTFIT_JOB_NAME("Talon Security")
	hierarchy_type = /decl/hierarchy/outfit/job

	id_type = /obj/item/card/id/talon/officer
	id_slot = slot_wear_id
	pda_type = null
	backpack_contents = list(/obj/item/handcuffs = 1)

	l_ear = /obj/item/radio/headset/talon
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/boots/jackboots
	backpack = /obj/item/storage/backpack/security
	satchel_one = /obj/item/storage/backpack/satchel/sec
	messenger_bag = /obj/item/storage/backpack/messenger/sec
	uniform = /obj/item/clothing/under/rank/talon/security
	l_pocket = /obj/item/flash
	backpack = /obj/item/storage/backpack/talon
	satchel_one = /obj/item/storage/backpack/satchel/talon
	messenger_bag = /obj/item/storage/backpack/messenger/talon

/decl/hierarchy/outfit/job/talon_engineer
	name = OUTFIT_JOB_NAME("Talon Engineer")
	hierarchy_type = /decl/hierarchy/outfit/job

	id_type = /obj/item/card/id/talon/engineer
	id_slot = slot_wear_id
	pda_type = null
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

	l_ear = /obj/item/radio/headset/talon
	belt = /obj/item/storage/belt/utility/full
	shoes = /obj/item/clothing/shoes/boots/workboots
	r_pocket = /obj/item/t_scanner
	backpack = /obj/item/storage/backpack/industrial
	satchel_one = /obj/item/storage/backpack/satchel/eng
	messenger_bag = /obj/item/storage/backpack/messenger/engi
	uniform = /obj/item/clothing/under/rank/talon/basic
	belt = /obj/item/storage/belt/utility/atmostech
	backpack = /obj/item/storage/backpack/talon
	satchel_one = /obj/item/storage/backpack/satchel/talon
	messenger_bag = /obj/item/storage/backpack/messenger/talon

/decl/hierarchy/outfit/job/talon_miner
	name = OUTFIT_JOB_NAME("Talon Miner")
	hierarchy_type = /decl/hierarchy/outfit/job

	id_type = /obj/item/card/id/talon/miner
	id_slot = slot_wear_id
	pda_type = null
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

	l_ear = /obj/item/radio/headset/talon
	shoes = /obj/item/clothing/shoes/boots/workboots
	r_pocket = /obj/item/storage/bag/ore
	l_pocket = /obj/item/tool/crowbar
	uniform = /obj/item/clothing/under/rank/talon/basic
	backpack = /obj/item/storage/backpack/talon
	satchel_one = /obj/item/storage/backpack/satchel/talon
	messenger_bag = /obj/item/storage/backpack/messenger/talon
