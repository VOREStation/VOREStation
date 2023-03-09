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
			
/*
	alt_titles = list(
<<<<<<< HEAD
		"Explorer Technician" = /decl/hierarchy/outfit/job/explorer2/technician,
		"Explorer Medic" = /decl/hierarchy/outfit/job/explorer2/medic)
*/
=======
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

			if (drake.harness?.attached_items)
				var/obj/item/gps/gps = drake.harness.attached_items[drake.harness.ATTACHED_GPS]
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


/obj/item/storage/animal_harness/grafadreka/expedition
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
/obj/item/storage/animal_harness/grafadreka/expedition/CreateAttachments()
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
	harness = /obj/item/storage/animal_harness/grafadreka/expedition

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
>>>>>>> fdc85e31dc4... Merge pull request #8904 from MistakeNot4892/drakes3
