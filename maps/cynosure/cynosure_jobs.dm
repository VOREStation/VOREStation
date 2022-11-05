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

	id_type = /obj/item/weapon/card/id/talon/captain
	id_slot = slot_wear_id
	pda_type = null

	l_ear = /obj/item/device/radio/headset/talon
	glasses = /obj/item/clothing/glasses/sunglasses
	uniform = /obj/item/clothing/under/rank/talon/command
	shoes = /obj/item/clothing/shoes/brown
	backpack = /obj/item/weapon/storage/backpack/talon
	satchel_one = /obj/item/weapon/storage/backpack/satchel/talon
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/talon

/decl/hierarchy/outfit/job/talon_pilot
	name = OUTFIT_JOB_NAME("Talon Pilot")

	id_type = /obj/item/weapon/card/id/talon/pilot
	id_slot = slot_wear_id
	pda_type = null
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_COMPREHENSIVE_SURVIVAL

	l_ear = /obj/item/device/radio/headset/talon
	shoes = /obj/item/clothing/shoes/black
	head = /obj/item/clothing/head/pilot_vr/talon
	uniform = /obj/item/clothing/under/rank/talon/pilot
	suit = /obj/item/clothing/suit/storage/toggle/bomber/pilot
	gloves = /obj/item/clothing/gloves/fingerless
	glasses = /obj/item/clothing/glasses/fakesunglasses/aviator
	uniform_accessories = list(/obj/item/clothing/accessory/storage/webbing/pilot1 = 1)
	backpack = /obj/item/weapon/storage/backpack/talon
	satchel_one = /obj/item/weapon/storage/backpack/satchel/talon
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/talon

/decl/hierarchy/outfit/job/talon_doctor
	name = OUTFIT_JOB_NAME("Talon Doctor")
	hierarchy_type = /decl/hierarchy/outfit/job

	id_type = /obj/item/weapon/card/id/talon/doctor
	id_slot = slot_wear_id
	pda_type = null

	l_ear = /obj/item/device/radio/headset/talon
	shoes = /obj/item/clothing/shoes/white
	backpack = /obj/item/weapon/storage/backpack/medic
	satchel_one = /obj/item/weapon/storage/backpack/satchel/med
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/med
	uniform = /obj/item/clothing/under/rank/talon/proper
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	l_hand = /obj/item/weapon/storage/firstaid/regular
	r_pocket = /obj/item/device/flashlight/pen
	backpack = /obj/item/weapon/storage/backpack/talon
	satchel_one = /obj/item/weapon/storage/backpack/satchel/talon
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/talon

/decl/hierarchy/outfit/job/talon_security
	name = OUTFIT_JOB_NAME("Talon Security")
	hierarchy_type = /decl/hierarchy/outfit/job

	id_type = /obj/item/weapon/card/id/talon/officer
	id_slot = slot_wear_id
	pda_type = null
	backpack_contents = list(/obj/item/weapon/handcuffs = 1)

	l_ear = /obj/item/device/radio/headset/talon
	gloves = /obj/item/clothing/gloves/black
	shoes = /obj/item/clothing/shoes/boots/jackboots
	backpack = /obj/item/weapon/storage/backpack/security
	satchel_one = /obj/item/weapon/storage/backpack/satchel/sec
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/sec
	uniform = /obj/item/clothing/under/rank/talon/security
	l_pocket = /obj/item/device/flash
	backpack = /obj/item/weapon/storage/backpack/talon
	satchel_one = /obj/item/weapon/storage/backpack/satchel/talon
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/talon

/decl/hierarchy/outfit/job/talon_engineer
	name = OUTFIT_JOB_NAME("Talon Engineer")
	hierarchy_type = /decl/hierarchy/outfit/job

	id_type = /obj/item/weapon/card/id/talon/engineer
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
	uniform = /obj/item/clothing/under/rank/talon/basic
	belt = /obj/item/weapon/storage/belt/utility/atmostech
	backpack = /obj/item/weapon/storage/backpack/talon
	satchel_one = /obj/item/weapon/storage/backpack/satchel/talon
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/talon

/decl/hierarchy/outfit/job/talon_miner
	name = OUTFIT_JOB_NAME("Talon Miner")
	hierarchy_type = /decl/hierarchy/outfit/job

	id_type = /obj/item/weapon/card/id/talon/miner
	id_slot = slot_wear_id
	pda_type = null
	flags = OUTFIT_HAS_BACKPACK|OUTFIT_EXTENDED_SURVIVAL

	l_ear = /obj/item/device/radio/headset/talon
	shoes = /obj/item/clothing/shoes/boots/workboots
	r_pocket = /obj/item/weapon/storage/bag/ore
	l_pocket = /obj/item/weapon/tool/crowbar
	uniform = /obj/item/clothing/under/rank/talon/basic
	backpack = /obj/item/weapon/storage/backpack/talon
	satchel_one = /obj/item/weapon/storage/backpack/satchel/talon
	messenger_bag = /obj/item/weapon/storage/backpack/messenger/talon

/*
#define CRASH_SURVIVOR_TITLE "Crash Survivor"
#define DRAKE_SURVIVOR_TITLE "Tamed Drake"

// Pilots

var/global/const/EXPLORER 			=(1<<14)

var/global/const/access_explorer = 43

/datum/access/explorer
	id = access_explorer
	desc = "Explorer"
	region = ACCESS_REGION_GENERAL

//Cynosure Jobs

/datum/department/planetside
	name = DEPARTMENT_PLANET
	color = "#555555"
	sorting_order = 2 // Same as cargo in importance.

/datum/job/explorer
	title = "Explorer"
	flag = EXPLORER
	departments = list(DEPARTMENT_RESEARCH, DEPARTMENT_PLANET)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Research Director"
	selection_color =  "#633D63"
	economic_modifier = 4
	access = list(access_explorer, access_research)
	minimal_access = list(access_explorer, access_research)

	outfit_type = /decl/hierarchy/outfit/job/explorer2
	job_description = "An Explorer searches for interesting things on the surface of Sif, and returns them to the station."

	alt_titles = list(
		"Pilot" = /datum/alt_title/pilot)

/datum/alt_title/pilot
	title = "Pilot"
	title_blurb = "A pilot ferries crew around in Cynosure Station's shuttle, the NTC Calvera."
	title_outfit = /decl/hierarchy/outfit/job/pilot

/datum/job/paramedic
	alt_titles = list(
					"Emergency Medical Technician" = /datum/alt_title/emt,
					"Search and Rescue" = /datum/alt_title/sar)

/datum/alt_title/sar
	title = "Search and Rescue"
	title_blurb = "A Search and Rescue operative recovers individuals who are injured or dead on the surface of Sif."
	title_outfit = /decl/hierarchy/outfit/job/medical/sar

/datum/job/rd
    access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
                        access_tox_storage, access_teleporter, access_sec_doors,
                        access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
                        access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch,
                        access_network, access_maint_tunnels, access_explorer, access_eva, access_external_airlocks)
    minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
                        access_tox_storage, access_teleporter, access_sec_doors,
                        access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
                        access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch,
                        access_network, access_maint_tunnels, access_explorer, access_eva, access_external_airlocks)

/datum/job/survivalist
	title = "Survivalist"
	departments = list(DEPARTMENT_PLANET)
	department_flag = CIVILIAN
	flag = HERMIT
	selection_color = "#6085a8"
	total_positions = 3
	spawn_positions = 3
	faction = "Station"
	supervisors = "your conscience"
	economic_modifier = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/survivalist
	job_description = "There are a few small groups of people living in the wilderness of Sif, and they occasionally venture to the Cynosure to trade, ask for help, or just have someone to talk to."
	assignable = FALSE
	has_headset = FALSE
	account_allowed = FALSE
	offmap_spawn = TRUE
	substitute_announce_title = "Colonist"
	banned_job_species = null
	alt_titles = list(
		CRASH_SURVIVOR_TITLE = /datum/alt_title/crash_survivor,
		DRAKE_SURVIVOR_TITLE = /datum/alt_title/working_drake
	)
	var/const/SPAWN_DAMAGE_MULT = 0.15
	var/const/TOTAL_INJURIES = 3
	var/static/list/pod_templates = list(
		/datum/map_template/surface/plains/Epod,
		/datum/map_template/surface/plains/Epod2,
		///datum/map_template/surface/wilderness/deep/Epod3, // Don't use this one, it has spiders.
		/datum/map_template/surface/wilderness/normal/Epod4
	)

/datum/job/survivalist/get_outfit(var/mob/living/carbon/human/H, var/alt_title)
	if(H.species?.name == SPECIES_VOX)
		return outfit_by_type(/decl/hierarchy/outfit/vox/survivor)
	return ..()

/datum/alt_title/crash_survivor
	title = CRASH_SURVIVOR_TITLE
	title_blurb = "Crashing in the wilderness of Sif's anomalous region is not a recommended holiday activity."
	title_outfit = /decl/hierarchy/outfit/job/survivalist/crash_survivor

/datum/alt_title/working_drake
	title = DRAKE_SURVIVOR_TITLE
	title_outfit = /decl/hierarchy/outfit/siffet
	title_blurb = "Some of the bolder colonists in Sif's anomalous region have partially domesticated some of the the local predators as working animals."

/datum/job/survivalist/equip(mob/living/carbon/human/H, alt_title)
	. = ..()
	if(.)

		if(alt_title == CRASH_SURVIVOR_TITLE)

			// Spawn some kit for getting out of the pod, if they don't have it already.
			var/turf/T = get_turf(H)

			var/obj/item/storage/toolbox/mechanical/toolbox
			for(var/turf/neighbor in RANGE_TURFS(1, T))
				toolbox = locate(/obj/item/storage/toolbox/mechanical) in neighbor
				if(toolbox)
					break

			if(!toolbox)
				toolbox = new(T)
			if(!(locate(/obj/item/pickaxe/hand) in toolbox))
				new /obj/item/pickaxe/hand(toolbox)
			if(!(locate(/obj/item/gps) in toolbox))
				new /obj/item/gps(toolbox)
			toolbox.name = "emergency toolbox"
			toolbox.desc = "A heavy toolbox stocked with tools for getting out of a crashed pod, as well as a GPS to aid with recovery."
			toolbox.make_exact_fit()

			// Clear the mark so it isn't available for other spawns.
			for(var/obj/effect/landmark/crashed_pod/pod_landmark in T)
				qdel(pod_landmark)

			// Smack them around from the landing.
			apply_post_spawn_damage(H)

/datum/job/survivalist/proc/apply_post_spawn_damage(var/mob/living/carbon/human/H)
	set waitfor = FALSE
	sleep(1) // let init and setup finish
	// beat them up a little
	for(var/injuries in 1 to TOTAL_INJURIES)
		var/deal_brute = rand(0, round(H.species.total_health * SPAWN_DAMAGE_MULT))
		H.take_overall_damage(deal_brute, round(H.species.total_health * SPAWN_DAMAGE_MULT) - deal_brute, "Crash Trauma")
	// remove any bleeding/internal bleeding, don't be too unfair
	for(var/obj/item/organ/external/E in H.organs)
		for(var/datum/wound/W in E.wounds)
			if(W.internal)
				E.wounds -= W
				qdel(W)
		E.organ_clamp()
		E.update_damages()

/datum/job/survivalist/get_latejoin_spawn_locations(var/mob/spawning, var/rank)
	var/alt_title = spawning?.client?.prefs?.GetPlayerAltTitle(job_master.GetJob(rank))
	if(alt_title == CRASH_SURVIVOR_TITLE)
		return get_spawn_locations(spawning, rank)
	return ..()

/datum/job/survivalist/proc/get_existing_spawn_points()
	for(var/obj/effect/landmark/crashed_pod/sloc in landmarks_list)
		if(!(locate(/mob/living) in sloc.loc))
			LAZYADD(., get_turf(sloc))

/datum/job/survivalist/get_spawn_locations(var/mob/spawning, var/rank)

	var/alt_title = spawning?.client?.prefs?.GetPlayerAltTitle(job_master.GetJob(rank))
	if(!spawning || alt_title != CRASH_SURVIVOR_TITLE)
		return ..()

	var/list/existing_points = get_existing_spawn_points()
	// Create a point if none are available.
	if(!length(existing_points))
		// Boilerplate from mapping.dm
		var/specific_sanity = 100
		var/datum/map_template/chosen_template = pick(pod_templates)
		chosen_template = new chosen_template
		while(specific_sanity > 0)
			specific_sanity--
			var/width_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + round(chosen_template.width / 2)
			var/height_border = TRANSITIONEDGE + SUBMAP_MAP_EDGE_PAD + round(chosen_template.height / 2)
			var/turf/T = locate(rand(width_border, world.maxx - width_border), rand(height_border, world.maxy - height_border), Z_LEVEL_SURFACE_WILD)
			var/valid = TRUE
			for(var/turf/check in chosen_template.get_affected_turfs(T,TRUE))
				var/area/new_area = get_area(check)
				if(!(istype(new_area, /area/surface/outside/wilderness)))
					valid = FALSE // Probably overlapping something important.
					break
			if(!valid)
				continue
			chosen_template.load(T, centered = TRUE)
			admin_notice("Crash survivor placed \"[chosen_template.name]\" at ([T.x], [T.y], [T.z])\n", R_DEBUG)
			break

		// Rebuild the spawn point list now that one has been spawned.
		existing_points = get_existing_spawn_points()

	return existing_points

/datum/job/survivalist/handle_nonhuman_mob(var/mob/living/carbon/human/player, var/alt_title)

	if(alt_title == DRAKE_SURVIVOR_TITLE)

		var/mob/living/simple_mob/animal/sif/grafadreka/trained/doggo = new(player.loc)

		// Copy over some prefs.
		if(player.client && player.client.prefs)

			var/datum/preferences/P = player.client.prefs
			doggo.gender = P.identifying_gender
			doggo.flavor_text = LAZYACCESS(P.flavor_texts, "general")

			// Protect against unset defaults creating a drake-shaped void.
			var/col = rgb(P.r_eyes, P.g_eyes, P.b_eyes)
			if(col != COLOR_BLACK)
				doggo.eye_colour = col
			col = rgb(P.r_facial, P.g_facial, P.b_facial)
			if(col != COLOR_BLACK)
				doggo.fur_colour = col
			col = rgb(P.r_hair, P.g_hair, P.b_hair)
			if(col != COLOR_BLACK)
				doggo.base_colour = col
			doggo.update_icon()

		// Transfer over key.
		if(player.mind)
			doggo.name = player.mind.name
			doggo.real_name = doggo.name
			player.mind.transfer_to(doggo)
			doggo.mind.original = doggo
		else
			doggo.key = player.key

		// Pass the mob back.
		qdel(player)
		prompt_rename(doggo)
		return doggo

	return ..()
/datum/job/survivalist/proc/prompt_rename(var/mob/player)

	set waitfor = FALSE
	sleep(1 SECOND)
	if(QDELETED(player))
		return

	// Let them customize their name in case they wanted something lowercase or nonstandard beyond what the prefs panel allowed.
	var/new_name = sanitize(input(player, "Would you like to customize your name?", "Drake Name", player.real_name), MAX_NAME_LEN)
	if(!new_name || QDELETED(player))
		return

	player.real_name = new_name
	player.name = player.real_name
	if(player.mind)
		player.mind.name = player.real_name

#undef CRASH_SURVIVOR_TITLE
#undef DRAKE_SURVIVOR_TITLE
*/