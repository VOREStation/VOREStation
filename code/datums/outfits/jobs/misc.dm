/decl/hierarchy/outfit/job/silicon
	head = /obj/item/clothing/head/cardborg
	hierarchy_type = /decl/hierarchy/outfit/job/silicon

/decl/hierarchy/outfit/job/silicon/ai
	name = OUTFIT_JOB_NAME(JOB_AI)
	suit = /obj/item/clothing/suit/straight_jacket

/decl/hierarchy/outfit/job/silicon/cyborg
	name = OUTFIT_JOB_NAME(JOB_CYBORG)
	suit = /obj/item/clothing/suit/cardborg

/datum/job/vr_avatar //So VR avatars dont spawn with PDAs and flood the servers
	title = JOB_VR
	disallow_jobhop = TRUE
	total_positions = 99
	spawn_positions = 5
	latejoin_only = 1
	supervisors = "The VR world"

	flag = NONCREW
	departments = list(DEPARTMENT_NONCREW)
	department_flag = OTHER
	faction = "Station"
	assignable = FALSE
	account_allowed = 0
	offmap_spawn = TRUE
	outfit_type = /decl/hierarchy/outfit/noncrew/vr_avatar

/decl/hierarchy/outfit/noncrew/vr_avatar
	pda_slot = null
	id_slot = null
	r_pocket = null
	l_pocket = null
	flags = OUTFIT_HAS_BACKPACK
