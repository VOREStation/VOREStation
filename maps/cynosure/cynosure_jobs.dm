<<<<<<< HEAD
=======
#define CRASH_SURVIVOR_TITLE "Crash Survivor"

>>>>>>> 009e1d1aa03... Merge pull request #8825 from MistakeNot4892/drakes
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
	alt_titles = list(CRASH_SURVIVOR_TITLE = /datum/alt_title/crash_survivor)
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
#undef CRASH_SURVIVOR_TITLE

/datum/job/trained_animal
	title = "Trained Drake"
	departments = list(DEPARTMENT_PLANET)
	department_flag = CIVILIAN
	flag = DOGGO
	selection_color = "#6085a8"
	total_positions = 2
	spawn_positions = 1
	faction = "Station"
	supervisors = "your conscience"
	economic_modifier = 1
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/siffet
	job_description = "A number of the bolder folks in Sif's anomalous region have partially domesticated some of the local wildlife as working animals."
	assignable = FALSE
	has_headset = FALSE
	account_allowed = FALSE
	offmap_spawn = TRUE
	announce_arrival_and_despawn = FALSE
	banned_job_species = null

	alt_titles = list(
		"Expedition Drake" = /datum/alt_title/drake/explorer_drake,
		"Wild Drake" =       /datum/alt_title/drake/wild_drake,
		"Wild Hatchling" =   /datum/alt_title/drake/wild_hatchling
	)

/datum/alt_title/drake
	title = "Trained Drake"
	title_blurb = "A number of the bolder folks in Sif's anomalous region have partially domesticated some of the local wildlife as working animals."
	var/drake_type = /mob/living/simple_mob/animal/sif/grafadreka/trained

/datum/alt_title/drake/explorer_drake
	title = "Expedition Drake"
	title_blurb = "The Cynosure Xenobiology department has spearheaded an effort to train some of the intelligent local wildlife to assist with Exploration field operations."
	drake_type = /mob/living/simple_mob/animal/sif/grafadreka/trained/station

/datum/alt_title/drake/wild_drake
	title = "Wild Drake"
	title_blurb = "Several packs of wild grafadreka have been pushed into the Anomalous Region by changing climate and rough weather, and sometimes come into contact with the locals."
	drake_type = /mob/living/simple_mob/animal/sif/grafadreka

/datum/alt_title/drake/wild_hatchling
	title = "Wild Hatchling"
	title_blurb = "Wild grafadreka are not particularly good parents, and their hatchlings often wander away or are abandoned to their own devices."
	drake_type = /mob/living/simple_mob/animal/sif/grafadreka/hatchling

/datum/job/trained_animal/handle_nonhuman_mob(var/mob/living/carbon/human/player, var/alt_title)

	var/datum/alt_title/drake/drake_setup = alt_titles[alt_title] || /datum/alt_title/drake
	var/drake_type = istype(drake_setup) ? drake_setup.drake_type : initial(drake_setup.drake_type)
	var/mob/living/critter = new drake_type(player.loc)

	// Copy over some prefs.
	if(player.client && player.client.prefs)

		// Set various strings and preference-loaded values.
		var/datum/preferences/P = player.client.prefs
		critter.gender = P.identifying_gender
		critter.flavor_text = LAZYACCESS(P.flavor_texts, "general")

		if(player.mind)
			critter.name = player.mind.name
			critter.real_name = critter.name

		if(istype(critter, /mob/living/simple_mob/animal/sif/grafadreka))
			var/mob/living/simple_mob/animal/sif/grafadreka/drake = critter
			// Protect against unset defaults creating a drake-shaped void.
			var/col = rgb(P.r_eyes, P.g_eyes, P.b_eyes)
			if(col != COLOR_BLACK)
				drake.eye_colour = col
			col = rgb(P.r_facial, P.g_facial, P.b_facial)
			if(col != COLOR_BLACK)
				drake.fur_colour = col
			col = rgb(P.r_hair, P.g_hair, P.b_hair)
			if(col != COLOR_BLACK)
				drake.base_colour = col
			drake.update_icon()

			for(var/language in P.alternate_languages)
				LAZYDISTINCTADD(drake.understands_languages, language)

			var/obj/item/storage/internal/animal_harness/grafadreka/harness = drake.harness
			if (istype(harness))
				var/obj/item/gps/gps = harness.attached_items[harness.ATTACHED_GPS]
				if (gps)
					gps.SetTag(drake.name)

		// Transfer over key.
		if(player.mind)
			player.mind.transfer_to(critter)
			critter.mind.original = critter
		else
			critter.key = player.key
		qdel(player)

		// Pass the mob back.
		prompt_rename(critter)
		return critter


/datum/job/trained_animal/proc/prompt_rename(var/mob/player)

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


/obj/item/card/id/drake_expedition
	name = "animal access card"
	access = list(access_explorer, access_research)


/obj/item/storage/internal/animal_harness/grafadreka/expedition
	name = "expedition harness"
	color = null
	icon_state = "explorer"


/obj/item/flashlight/glowstick/grafadreka
	name = "high duration glowstick"
	action_button_name = null


/obj/item/flashlight/glowstick/grafadreka/Initialize()
	. = ..()
	var/obj/item/flashlight/glowstick/archetype = pick(typesof(/obj/item/flashlight/glowstick) - type)
	flashlight_colour = initial(archetype.flashlight_colour)
	icon_state = initial(archetype.icon_state)
	item_state = initial(archetype.item_state)
	fuel = rand(3200, 4800)
	on = TRUE
	update_icon()
	START_PROCESSING(SSobj, src)


// Station/Science drake harness contents on spawn
/obj/item/storage/internal/animal_harness/grafadreka/expedition/CreateAttachments()
	var/mob/living/owner = loc
	if(!istype(owner))
		return
	attached_items[ATTACHED_ID] = new /obj/item/card/id/drake_expedition (owner)
	attached_items[ATTACHED_RADIO] = new /obj/item/radio (owner)
	new /obj/item/stack/medical/bruise_pack (src)
	new /obj/item/stack/medical/ointment (src)
	new /obj/item/storage/mre/menu13 (src) // The good stuff
	var/obj/item/gps/explorer/on/gps = new (owner)
	gps.SetTag(owner.name)
	attached_items[ATTACHED_GPS] = gps
	attached_items[ATTACHED_LIGHT] = new /obj/item/flashlight/glowstick/grafadreka (owner)


/mob/living/simple_mob/animal/sif/grafadreka/trained/station
	player_msg = {"<b>You are a large Sivian pack predator working with the Science team.</b>
You have been <b>trained by the Xenobiology department</b> to assist with expeditions and field work, and are an official part of the Exploration staff."
You can eat glowing tree fruit to fuel your <b>ranged spitting attack</b> and <b>poisonous bite</b> (on <span class = 'danger'>harm intent</span>), as well as <b>healing saliva</b> (on <b><font color = '#009900'>help intent</font></b>).
Using <font color='#e0a000'>grab intent</font> you can pick up and drop items by clicking them or yourself, and can interact with some simple machines like buttons and levers."}
	harness = /obj/item/storage/internal/animal_harness/grafadreka/expedition

/obj/item/book/manual/drake_handling
	name = "Care And Handling Of The Sivian Snow Drake v0.1.12b"
	icon_state = "book3"
	author = "Xenoscience Team"
	title = "Care And Handling Of The Sivian Snow Drake v0.1.12b"

/obj/item/book/manual/drake_handling/Initialize()
	. = ..()
	dat = {"<html>
				<head>
				<style>
				h1 {font-size: 18px; margin: 15px 0px 5px;}
				h2 {font-size: 15px; margin: 15px 0px 5px;}
				li {margin: 2px 0px 2px 15px;}
				ul {margin: 5px; padding: 0px;}
				ol {margin: 5px; padding: 0px 15px;}
				body {font-size: 13px; font-family: Verdana;}
				</style>
				</head>
				<body>
				<p><i>This seems to be a notebook full of handwritten notes, loosely organized by topic. There's a crude index scribbled on the inside of the cover, but it's not very useful.</i></p>
				<h2>General behavior</h2>
				<p>Grafadreka (drakes) are actually pretty timid and easily spooked despite their size and appearance. In the wild, they hunt in groups and will hit and run using their stunning spit, avoiding direct engagement unless given no other option. They seem to have an inherent social structure, with a dominant packmember taking the lead but the pack as a whole working as a team. May be useful for training?</p>
				<p>Instinctive aggression towards spiders & smaller Sivian wildlife - can be trained out of them with difficulty. Wild populations can live entirely off spider meat or carrion.</p>
				<p>Quite social animals - will seek out humans or other creatures in the absence of packmembers just for company. Very food motivated! Seem to enjoy working with personnel out in the field or hanging out in social areas like the bar.</p>
				<p>Egg-layers - nests of 1-3 eggs in caves north of Cynosure - influenced by different environment? <i>Terrible</i> parents, hatchlings always wandering off & getting eaten by spiders.</p>
				<h2>Training results</h2>
				<p>Signal training very successful - almost every drake responds positively to audible cues like summon whistles, vocal cues like 'up' and 'down' - strong indicators of language understanding.</p>
				<p>Can be encouraged to be careful with spitting - related to pack hunting instincts? - not always reliable.</p>
				<p>Good visual memory, can be trained to seek out specific kinds of object with vocal cues - implies use of tools could be trainable if they had better manual dexterity.</p>
				<p>Can understand buttons/levers, door panels, access cards and automatic doors.</p>
				<h2>Medical care</h2>
				<ul>
				<li>DO NOT TAKE OFFPLANET. Listlessness, faded glow, shedding of skin and lining of innards, death in ~3 days. LEAVE THEM ON SIF.</li>
				<li>Per above, Security and Customs are very mad about import/export of controlled species. Don't take them on the shuttle.</li>
				<li>Their saliva has a lot of bacteria and Sivian organic chemicals in it. Good for encouraging healing in Sivian wildlife, poisonous to humans (but does stop bleeding).</li>
				<li>For minor injuries, they'll probably sort themselves out.</li>
				<li>Standard human-compatible bandages, biogels and ointments seem to work fine for them.</li>
				<li>Good reactions to bicaridine - use to reduce scarring & promote recovery from serious wounds.</li>
				<li>Don't try to feed them a pill, they're worse than cats.</li>
				</ul>
				</body>
			</html>"}
>>>>>>> 009e1d1aa03... Merge pull request #8825 from MistakeNot4892/drakes
