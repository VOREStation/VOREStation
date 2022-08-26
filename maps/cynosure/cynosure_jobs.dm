#define CRASH_SURVIVOR_TITLE "Crash Survivor"
#define DRAKE_SURVIVOR_TITLE "Working Drake"

// Pilots

var/const/EXPLORER 			=(1<<14)

var/const/access_explorer = 43

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
		"Pilot" = /decl/hierarchy/outfit/job/pilot)

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
<<<<<<< HEAD
			
/*
	alt_titles = list(
		"Explorer Technician" = /decl/hierarchy/outfit/job/explorer2/technician,
		"Explorer Medic" = /decl/hierarchy/outfit/job/explorer2/medic)
*/
=======

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
			doggo.eye_colour =  rgb(P.r_eyes, P.g_eyes, P.b_eyes)
			doggo.fur_colour =  rgb(P.r_facial, P.g_facial, P.b_facial)
			doggo.base_colour = rgb(P.r_hair, P.g_hair, P.b_hair)
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
>>>>>>> 7aa6f14ab0c... Merge pull request #8688 from MistakeNot4892/doggo
