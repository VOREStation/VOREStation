SUBSYSTEM_DEF(job)
	name = "Job"
	dependencies = list(
		/datum/controller/subsystem/mapping,
	)
	flags = SS_NO_FIRE

		//List of all jobs
	var/list/datum/job/occupations = list()
		//List of all jobs
	var/list/datum/job/occupation_with_excludes = list()
		//Players who need jobs
	var/list/mob/new_player/unassigned = list()
	var/list/datum/job/occupations_by_name = list()	//Dict of all jobs, keys are titles
	var/list/type_occupations = list()	//Dict of all jobs, keys are types

	var/list/department_datums = list()
	var/list/job_icon_cache = list()
	var/debug_messages = FALSE


/datum/controller/subsystem/job/proc/get_all_job_icons() //For all existing HUD icons
	return occupation_with_excludes + GLOB.alt_titles_with_icons + list("Prisoner")

/datum/controller/subsystem/job/Initialize()
	setup_departments()
	setup_occupations()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/job/proc/setup_occupations(faction = FACTION_STATION)
	occupations.Cut()
	var/list/all_jobs = subtypesof(/datum/job)
	if(!length(all_jobs))
		to_chat(world, span_warning("Error setting up jobs, no job datums found"))
		return FALSE

	for(var/job_path in all_jobs)
		var/datum/job/job = new job_path()
		if(job.faction != faction)
			continue
		occupations += job
		if(!(is_type_in_list(job, GLOB.exclude_jobs)))
			occupation_with_excludes += job
		occupations_by_name[job.title] = job
		type_occupations[job_path] = job
		if(LAZYLEN(job.departments))
			add_to_departments(job)

	sortTim(occupations, GLOBAL_PROC_REF(cmp_job_datums))
	for(var/department, value in department_datums)
		var/datum/department/dept = value
		sortTim(dept.jobs, GLOBAL_PROC_REF(cmp_job_datums), TRUE)
		sortTim(dept.primary_jobs, GLOBAL_PROC_REF(cmp_job_datums), TRUE)

	return TRUE

/datum/controller/subsystem/job/proc/add_to_departments(datum/job/J)
	// Adds to the regular job lists in the departments, which allow multiple departments for a job.
	for(var/D in J.departments)
		var/datum/department/dept = LAZYACCESS(department_datums, D)
		if(!istype(dept))
			job_debug_message("Job '[J.title]' is defined as being inside department '[D]', but it does not exist.")
			continue
		dept.jobs[J.title] = J

	// Now for the 'primary' department for a job, which is defined as being the first department in the list for a job.
	// This results in no duplicates, which can be useful in some situations.
	if(LAZYLEN(J.departments))
		var/primary_department = J.departments[1]
		var/datum/department/dept = LAZYACCESS(department_datums, primary_department)
		if(!istype(dept))
			job_debug_message("Job '[J.title]' has their primary department be '[primary_department]', but it does not exist.")
		else
			dept.primary_jobs[J.title] = J

/datum/controller/subsystem/job/proc/setup_departments()
	for(var/t in subtypesof(/datum/department))
		var/datum/department/D = new t()
		department_datums[D.name] = D

	sortTim(department_datums, GLOBAL_PROC_REF(cmp_department_datums), TRUE)

/datum/controller/subsystem/job/proc/get_all_department_datums()
	var/list/dept_datums = list()
	for(var/D in department_datums)
		dept_datums += department_datums[D]
	return dept_datums

/datum/controller/subsystem/job/proc/get_job(rank)
	if(!rank)
		return null
	return occupations_by_name[rank]

/datum/controller/subsystem/job/proc/get_player_alt_title(mob/new_player/player, rank)
	return player.client.prefs.GetPlayerAltTitle(get_job(rank))

/datum/controller/subsystem/job/proc/get_job_type(jobtype)
	return type_occupations[jobtype]

// Determines if a job title is inside of a specific department.
// Useful to replace the old `if(job_title in GLOB.command_positions)` code.
/datum/controller/subsystem/job/proc/is_job_in_department(rank, target_department_name)
	var/datum/department/D = LAZYACCESS(department_datums, target_department_name)
	if(istype(D))
		return LAZYFIND(D.jobs, rank) ? TRUE : FALSE
	return FALSE

// Returns a list of all job names in a specific department.
/datum/controller/subsystem/job/proc/get_job_titles_in_department(target_department_name)
	var/datum/department/D = LAZYACCESS(department_datums, target_department_name)
	if(istype(D))
		var/list/job_titles = list()
		for(var/J in D.jobs)
			job_titles += J
		return job_titles

	job_debug_message("Was asked to get job titles for a non-existant department '[target_department_name]'.")
	return list()

// Returns a reference to the primary department datum that a job is in.
// Can receive job datum refs, typepaths, or job title strings.
/datum/controller/subsystem/job/proc/get_primary_department_of_job(datum/job/J)
	if(!istype(J, /datum/job))
		if(ispath(J))
			J = get_job_type(J)
		else if(istext(J))
			J = get_job(J)

	if(!istype(J))
		job_debug_message("Was asked to get department for job '[J]', but input could not be resolved into a job datum.")
		return

	if(!LAZYLEN(J.departments))
		return

	var/primary_department = J.departments[1]
	var/datum/department/dept = LAZYACCESS(department_datums, primary_department)
	if(!istype(dept))
		job_debug_message("Job '[J.title]' has their primary department be '[primary_department]', but it does not exist.")
		return

	return department_datums[primary_department]

/datum/controller/subsystem/job/proc/get_ping_role(var/role)
	var/datum/job/J = get_job(role)
	if(J.requestable)
		return get_primary_department_of_job(J)

// Someday it might be good to port code/game/jobs/job_controller.dm to here and clean it up.

/datum/controller/subsystem/job/proc/job_debug_message(message)
	if(debug_messages)
		log_world("JOB DEBUG: [message]")

/datum/controller/subsystem/job/proc/assign_role(mob/new_player/player, rank, latejoin = FALSE)
	job_debug_message("Running AR, Player: [player], Rank: [rank], LJ: [latejoin]")
	if(player && player.mind && rank)
		var/datum/job/job = get_job(rank)
		if(!job)
			return FALSE
		if((job.minimum_character_age || job.min_age_by_species) && (player.read_preference(/datum/preference/numeric/human/age) < job.get_min_age(player.client.prefs.read_preference(/datum/preference/choiced/species), player.client.prefs.read_preference(/datum/preference/organ_data)?[O_BRAIN])))
			return FALSE
		if(jobban_isbanned(player, rank))
			return FALSE
		if(!job.player_old_enough(player.client))
			return FALSE
		if(!job.player_has_enough_playtime(player.client))
			return FALSE
		if(!is_job_whitelisted(player, rank))
			return FALSE

		var/position_limit = job.total_positions
		if(!latejoin)
			position_limit = job.spawn_positions
		if((job.current_positions < position_limit) || position_limit == -1)
			job_debug_message("Player: [player] is now Rank: [rank], JCP:[job.current_positions], JPL:[position_limit]")
			player.mind.assigned_role = rank
			player.mind.role_alt_title = get_player_alt_title(player, rank)
			unassigned -= player
			job.current_positions++
			return TRUE
	job_debug_message("AR has failed, Player: [player], Rank: [rank]")
	return FALSE

/datum/controller/subsystem/job/proc/free_role(rank)	//making additional slot on the fly
	var/datum/job/job = get_job(rank)
	if(job && job.total_positions != -1)
		job.total_positions++
		return TRUE
	return FALSE

/datum/controller/subsystem/job/proc/update_limit(rank, comperator)
	var/datum/job/job = get_job(rank)
	if(job && job.total_positions != -1)
		job.update_limit(comperator)
		return TRUE
	return FALSE

/datum/controller/subsystem/job/proc/find_occupation_candidate(datum/job/job, level, flag)
	job_debug_message("Running FOC, Job: [job], Level: [level], Flag: [flag]")
	var/list/candidates = list()
	for(var/mob/new_player/player in unassigned)
		if(jobban_isbanned(player, job.title))
			job_debug_message("FOC isbanned failed, Player: [player]")
			continue
		if(!job.player_old_enough(player.client))
			job_debug_message("FOC player not old enough, Player: [player]")
			continue
		if(job.minimum_character_age && (player.read_preference(/datum/preference/numeric/human/age) < job.get_min_age(player.client.prefs.read_preference(/datum/preference/choiced/species), player.client.prefs.read_preference(/datum/preference/organ_data)?[O_BRAIN])))
			job_debug_message("FOC character not old enough, Player: [player]")
			continue
		//VOREStation Code Start
		if(!job.player_has_enough_playtime(player.client))
			job_debug_message("FOC character not enough playtime, Player: [player]")
			continue
		if(!is_job_whitelisted(player, job.title))
			job_debug_message("FOC is_job_whitelisted failed, Player: [player]")
			continue
		//VOREStation Code End
		if(flag && !(player.client.prefs.be_special & flag))
			job_debug_message("FOC flag failed, Player: [player], Flag: [flag], ")
			continue
		if(player.client.prefs.GetJobDepartment(job, level) & job.flag)
			job_debug_message("FOC pass, Player: [player], Level:[level]")
			candidates += player
	return candidates

/datum/controller/subsystem/job/proc/give_random_job(mob/new_player/player)
	job_debug_message("GRJ Giving random job, Player: [player]")
	for(var/datum/job/job in shuffle(occupations))
		if(!job)
			continue

		if((job.minimum_character_age || job.min_age_by_species) && (player.read_preference(/datum/preference/numeric/human/age) < job.get_min_age(player.client.prefs.read_preference(/datum/preference/choiced/species), player.client.prefs.read_preference(/datum/preference/organ_data)?[O_BRAIN])))
			continue

		if(istype(job, get_job(JOB_ALT_VISITOR))) // We don't want to give him assistant, that's boring! //VOREStation Edit - Visitor not Assistant
			continue

		if(SSjob.is_job_in_department(job.title, DEPARTMENT_COMMAND)) //If you want a command position, select it!
			continue

		if(jobban_isbanned(player, job.title))
			job_debug_message("GRJ isbanned failed, Player: [player], Job: [job.title]")
			continue

		if(!job.player_old_enough(player.client))
			job_debug_message("GRJ player not old enough, Player: [player]")
			continue

		if(!job.player_has_enough_playtime(player.client))
			job_debug_message("GRJ player not enough playtime, Player: [player]")
			continue
		if(!is_job_whitelisted(player, job.title))
			job_debug_message("GRJ player not whitelisted for this job, Player: [player], Job: [job.title]")
			continue

		if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
			job_debug_message("GRJ Random job given, Player: [player], Job: [job]")
			assign_role(player, job.title)
			unassigned -= player
			break

/datum/controller/subsystem/job/proc/reset_occupations()
	for(var/mob/new_player/player in GLOB.player_list)
		if((player) && (player.mind))
			player.mind.assigned_role = null
			player.mind.special_role = null
	setup_occupations()
	unassigned = list()
	return

///This proc is called before the level loop of DivideOccupations() and will try to select a head, ignoring ALL non-head preferences for every level until it locates a head or runs out of levels to check
/datum/controller/subsystem/job/proc/fill_head_position()
	for(var/level = 1 to 3)
		for(var/command_position in SSjob.get_job_titles_in_department(DEPARTMENT_COMMAND))
			var/datum/job/job = get_job(command_position)
			if(!job)
				continue
			var/list/candidates = find_occupation_candidate(job, level)
			if(!length(candidates))
				continue

			// Build a weighted list, weight by age.
			var/list/weightedCandidates = list()
			for(var/mob/mob_candidate in candidates)
				// Log-out during round-start? What a bad boy, no head position for you!
				if(!mob_candidate.client)
					continue
				var/age = mob_candidate.read_preference(/datum/preference/numeric/human/age)

				if(age < job.get_min_age(mob_candidate.client.prefs.read_preference(/datum/preference/choiced/species), mob_candidate.client.prefs.read_preference(/datum/preference/organ_data)?[O_BRAIN])) // Nope.
					continue

				var/idealage = job.get_ideal_age(mob_candidate.client.prefs.read_preference(/datum/preference/choiced/species), mob_candidate.client.prefs.read_preference(/datum/preference/organ_data)?[O_BRAIN])
				var/agediff = abs(idealage - age) // Compute the absolute difference in age from target
				switch(agediff) /// If the math sucks, it's because I almost failed algebra in high school.
					if(20 to INFINITY)
						weightedCandidates[mob_candidate] = 3 // Too far off
					if(10 to 20)
						weightedCandidates[mob_candidate] = 6 // Nearer the mark, but not quite
					if(0 to 10)
						weightedCandidates[mob_candidate] = 10 // On the mark
					else
						// If there's ABSOLUTELY NOBODY ELSE
						if(length(candidates) == 1)
							weightedCandidates[mob_candidate] = 1


			var/mob/new_player/candidate = pickweight(weightedCandidates)
			if(assign_role(candidate, command_position))
				return TRUE
	return FALSE

///This proc is called at the start of the level loop of DivideOccupations() and will cause head jobs to be checked before any other jobs of the same level
/datum/controller/subsystem/job/proc/check_head_position(level)
	for(var/command_position in SSjob.get_job_titles_in_department(DEPARTMENT_COMMAND))
		var/datum/job/job = get_job(command_position)
		if(!job)
			continue
		var/list/candidates = find_occupation_candidate(job, level)
		if(!length(candidates))
			continue
		var/mob/new_player/candidate = pick(candidates)
		assign_role(candidate, command_position)







/** Proc DivideOccupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
/datum/controller/subsystem/job/proc/divide_occupations()
	//Setup new player list and get the jobs list
	job_debug_message("Running DO")
	setup_occupations()

	//Holder for Triumvirate is stored in the ticker, this just processes it
	if(SSticker && GLOB.triai)
		for(var/datum/job/A in occupations)
			if(A.title == JOB_AI)
				A.spawn_positions = 3
				break

	//Get the players who are ready
	for(var/mob/new_player/player in GLOB.player_list)
		if(player.ready && player.mind && !player.mind.assigned_role)
			unassigned += player

	job_debug_message("DO, Len: [length(unassigned)]")
	if(!length(unassigned))
		return FALSE

	//Shuffle players and jobs
	unassigned = shuffle(unassigned)

	handle_feedback_gathering()

	//People who wants to be assistants, sure, go on.
	job_debug_message("DO, Running Assistant Check 1")
	var/datum/job/assist = new DEFAULT_JOB_TYPE ()
	var/list/assistant_candidates = find_occupation_candidate(assist, 3)
	job_debug_message("AC1, Candidates: [length(assistant_candidates)]")
	for(var/mob/new_player/player in assistant_candidates)
		job_debug_message("AC1 pass, Player: [player]")
		assign_role(player, JOB_ALT_VISITOR) //VOREStation Edit - Visitor not Assistant
		assistant_candidates -= player
	job_debug_message("DO, AC1 end")

	//Select one head
	job_debug_message("DO, Running Head Check")
	fill_head_position()
	job_debug_message("DO, Head Check end")

	//Other jobs are now checked
	job_debug_message("DO, Running Standard Check")


	// New job giving system by Donkie
	// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
	// Hopefully this will add more randomness and fairness to job giving.

	// Loop through all levels from high to low
	var/list/shuffledoccupations = shuffle(occupations)
	// var/list/disabled_jobs = SSticker.mode.disabled_jobs  // So we can use .Find down below without a colon.
	for(var/level = 1 to 3)
		//Check the head jobs first each level
		check_head_position(level)

		// Loop through all unassigned players
		for(var/mob/new_player/player in unassigned)

			// Loop through all jobs
			for(var/datum/job/job in shuffledoccupations) // SHUFFLE ME BABY
				if(!job || SSticker.mode.disabled_jobs.Find(job.title) )
					continue

				if(jobban_isbanned(player, job.title))
					job_debug_message("DO isbanned failed, Player: [player], Job:[job.title]")
					continue

				if(!job.player_old_enough(player.client))
					job_debug_message("DO player not old enough, Player: [player], Job:[job.title]")
					continue

				//VOREStation Add
				if(!job.player_has_enough_playtime(player.client))
					job_debug_message("DO player not enough playtime, Player: [player]")
					continue
				//VOREStation Add End

				// If the player wants that job on this level, then try give it to him.
				if(player.client.prefs.GetJobDepartment(job, level) & job.flag)

					// If the job isn't filled
					if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
						job_debug_message("DO pass, Player: [player], Level:[level], Job:[job.title]")
						assign_role(player, job.title)
						unassigned -= player
						break

	// Hand out random jobs to the people who didn't get any in the last check
	// Also makes sure that they got their preference correct
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == GET_RANDOM_JOB)
			give_random_job(player)

	job_debug_message("DO, Standard Check end")

	job_debug_message("DO, Running AC2")

	// For those who wanted to be assistant if their preferences were filled, here you go.
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == BE_ASSISTANT)
			job_debug_message("AC2 Assistant located, Player: [player]")
			assign_role(player, JOB_ALT_VISITOR) //VOREStation Edit - Visitor not Assistant

	//For ones returning to lobby
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == RETURN_TO_LOBBY)
			player.ready = PLAYER_NOT_READY
			unassigned -= player
	return TRUE

/datum/controller/subsystem/job/proc/equip_rank(mob/living/carbon/human/human_mob, rank, joined_late = 0, announce = TRUE)
	if(!human_mob)
		return null

	var/datum/job/job = get_job(rank)
	var/list/spawn_in_storage = list()

	if(!joined_late)
		var/obj/spawn_point = null
		var/list/possible_spawns = list()
		for(var/obj/effect/landmark/start/sloc in GLOB.landmarks_list)
			if(sloc.name != rank)	continue
			if(locate(/mob/living) in sloc.loc)	continue
			possible_spawns.Add(sloc)
		if(length(possible_spawns))
			spawn_point = pick(possible_spawns)
		if(!spawn_point)
			spawn_point = locate("start*[rank]") // use old stype
		if(istype(spawn_point, /obj/effect/landmark/start) && istype(spawn_point.loc, /turf))
			human_mob.forceMove(spawn_point.loc)
		else
			var/list/spawn_props = late_spawn(human_mob.client, rank)
			var/turf/spawn_turf = spawn_props["turf"]
			if(!spawn_turf)
				to_chat(human_mob, span_critical("You were unable to be spawned at your chosen late-join spawnpoint. Please verify your job/spawn point combination makes sense, and try another one."))
				return
			else
				human_mob.forceMove(spawn_turf)

		// Moving wheelchair if they have one
		if(human_mob.buckled && istype(human_mob.buckled, /obj/structure/bed/chair/wheelchair))
			human_mob.buckled.forceMove(human_mob.loc)
			human_mob.buckled.set_dir(human_mob.dir)

	if(job)

		//Equip custom gear loadout.
		var/list/custom_equip_slots = list()
		var/list/custom_equip_leftovers = list()
		if(human_mob?.client?.prefs && !(job.mob_type & JOB_SILICON))
			var/list/active_gear_list = LAZYACCESS(human_mob.client.prefs.gear_list, "[human_mob.client.prefs.gear_slot]")
			for(var/thing in active_gear_list)
				var/datum/gear/gaar_thing = GLOB.gear_datums[thing]
				if(!gaar_thing) //Not a real gear datum (maybe removed, as this is loaded from their savefile)
					continue

				var/permitted
				// Check if it is restricted to certain roles
				if(gaar_thing.allowed_roles)
					for(var/job_name in gaar_thing.allowed_roles)
						if(job.title == job_name)
							permitted = TRUE
				else
					permitted = TRUE

				// Check if they're whitelisted for this gear (in alien whitelist? seriously?)
				if(gaar_thing.whitelisted && !is_alien_whitelisted(human_mob.client, GLOB.all_species[gaar_thing.whitelisted]))
					permitted = FALSE

				// If they aren't, tell them
				if(!permitted)
					to_chat(human_mob, span_warning("Your current species, job or whitelist status does not permit you to spawn with [thing]!"))
					continue

				// Implants get special treatment
				if(gaar_thing.slot == "implant")
					var/obj/item/implant/gear_implant = gaar_thing.spawn_item(human_mob, active_gear_list[gaar_thing.display_name])
					gear_implant.invisibility = INVISIBILITY_MAXIMUM
					gear_implant.implant_loadout(human_mob)
					continue

				// Try desperately (and sorta poorly) to equip the item. Now with increased desperation!
				if(gaar_thing.slot && !(gaar_thing.slot in custom_equip_slots))
					var/metadata = active_gear_list[gaar_thing.display_name]
					//if(G.slot == slot_wear_mask || G.slot == slot_wear_suit || G.slot == slot_head)
					//	custom_equip_leftovers += thing
					//else
					if(gaar_thing.slot == slot_wear_suit && human_mob.client?.prefs?.no_jacket)
						continue
					if(gaar_thing.slot == slot_shoes && human_mob.client?.prefs?.shoe_hater)	//RS ADD
						continue
					if(human_mob.equip_to_slot_or_del(gaar_thing.spawn_item(human_mob, metadata), gaar_thing.slot))
						to_chat(human_mob, span_notice("Equipping you with \the [thing]!"))
						if(gaar_thing.slot != slot_tie)
							custom_equip_slots.Add(gaar_thing.slot)
					else
						custom_equip_leftovers.Add(thing)
				else
					spawn_in_storage += thing

		// Set up their account
		job.setup_account(human_mob)

		// Equip job items.
		job.equip(human_mob, human_mob.mind ? human_mob.mind.role_alt_title : "")

		// Stick their fingerprints on literally everything
		job.apply_fingerprints(human_mob)

		// Only non-silicons get post-job-equip equipment and dormant diseases
		if(!(job.mob_type & JOB_SILICON))
			human_mob.equip_post_job()
			human_mob.give_random_dormant_disease(guaranteed_symptoms = job.symptoms)

		// If some custom items could not be equipped before, try again now.
		for(var/thing in custom_equip_leftovers)
			var/datum/gear/gear_thing = GLOB.gear_datums[thing]
			if(gear_thing.slot == slot_wear_suit && human_mob.client?.prefs?.no_jacket)
				continue
			if(gear_thing.slot == slot_shoes && human_mob.client?.prefs?.shoe_hater)
				continue
			if(gear_thing.slot in custom_equip_slots)
				spawn_in_storage += thing
			else
				var/list/active_gear_list = LAZYACCESS(human_mob.client.prefs.gear_list, "[human_mob.client.prefs.gear_slot]")
				var/metadata = active_gear_list[gear_thing.display_name]
				if(human_mob.equip_to_slot_or_del(gear_thing.spawn_item(human_mob, metadata), gear_thing.slot))
					to_chat(human_mob, span_notice("Equipping you with \the [thing]!"))
					custom_equip_slots.Add(gear_thing.slot)
				else
					spawn_in_storage += thing

		//Give new players a welcome guide!
		if(isnum(human_mob.client?.player_age) && human_mob.client.player_age < 10)
			human_mob.equip_to_slot_or_del(new /obj/item/book/manual/virgo_pamphlet(human_mob), slot_r_hand)
	else
		to_chat(human_mob, span_filter_notice("Your job is [rank] and the game just can't handle it! Please report this bug to an administrator."))

	human_mob.job = rank
	log_game("JOINED [key_name(human_mob)] as \"[rank]\"")
	log_game("SPECIES [key_name(human_mob)] is a: \"[human_mob.species.name]\"") //VOREStation Add

	// If they're head, give them the account info for their department
	if(human_mob.mind && job.department_accounts)
		var/remembered_info = ""
		for(var/job_department in job.department_accounts)
			var/datum/money_account/department_account = GLOB.department_accounts[job_department]
			if(department_account)
				remembered_info += span_bold("Department account number ([job_department]):") + " #[department_account.account_number]<br>"
				remembered_info += span_bold("Department account pin ([job_department]):") + " [department_account.remote_access_pin]<br>"
				remembered_info += span_bold("Department account funds ([job_department]):") + " $[department_account.money]<br>"

		human_mob.mind.store_memory(remembered_info)

	var/alt_title = null
	if(human_mob.mind)
		human_mob.mind.assigned_role = rank
		alt_title = human_mob.mind.role_alt_title

		// If we're a silicon, we may be done at this point
		if(job.mob_type & JOB_SILICON_ROBOT)
			return human_mob.Robotize()
		if(job.mob_type & JOB_SILICON_AI)
			return human_mob

		// TWEET PEEP
		if(rank == JOB_SITE_MANAGER && announce)
			var/sound/announce_sound = (SSticker.current_state <= GAME_STATE_SETTING_UP) ? null : sound('sound/misc/boatswain.ogg', volume=20)
			GLOB.captain_announcement.Announce("All hands, [alt_title ? alt_title : JOB_SITE_MANAGER] [human_mob.real_name] on deck!", new_sound = announce_sound, zlevel = human_mob.z)

		//Deferred item spawning.
		if(spawn_in_storage && length(spawn_in_storage))
			var/obj/item/storage/storage_bag
			for(var/obj/item/storage/worn_bag in human_mob.contents)
				storage_bag = worn_bag
				break

			var/list/active_gear_list = LAZYACCESS(human_mob.client.prefs.gear_list, "[human_mob.client.prefs.gear_slot]")
			if(!isnull(storage_bag))
				for(var/thing in spawn_in_storage)
					to_chat(human_mob, span_notice("Placing \the [thing] in your [storage_bag.name]!"))
					var/datum/gear/gear_thing = GLOB.gear_datums[thing]
					var/metadata = active_gear_list[gear_thing.display_name]
					gear_thing.spawn_item(storage_bag, metadata)
			else
				to_chat(human_mob, span_danger("Failed to locate a storage object on your mob, either you spawned with no arms and no backpack or this is a bug."))

	if(istype(human_mob)) //give humans wheelchairs, if they need them.
		var/obj/item/organ/external/l_foot = human_mob.get_organ(BP_L_FOOT)
		var/obj/item/organ/external/r_foot = human_mob.get_organ(BP_R_FOOT)
		var/obj/item/storage/storage_bag = locate() in human_mob.contents
		var/obj/item/wheelchair/used_wheelchair
		if(storage_bag)
			used_wheelchair = locate() in storage_bag.contents
		if(!l_foot || !r_foot || used_wheelchair)
			var/wheelchair_type = used_wheelchair?.unfolded_type || /obj/structure/bed/chair/wheelchair
			var/obj/structure/bed/chair/wheelchair/active_wheelchair = new wheelchair_type(human_mob.loc)
			active_wheelchair.buckle_mob(human_mob)
			human_mob.update_canmove()
			active_wheelchair.set_dir(human_mob.dir)
			active_wheelchair.add_fingerprint(human_mob)
			if(used_wheelchair)
				active_wheelchair.color = used_wheelchair.color
				qdel(used_wheelchair)

	to_chat(human_mob, span_filter_notice(span_bold("You are [job.total_positions == 1 ? "the" : "a"] [alt_title ? alt_title : rank].")))

	if(job.supervisors)
		to_chat(human_mob, span_filter_notice(span_bold("As the [alt_title ? alt_title : rank] you answer directly to [job.supervisors]. Special circumstances may change this.")))
	if(job.has_headset)
		human_mob.equip_to_slot_or_del(new /obj/item/radio/headset(human_mob), slot_l_ear)
		to_chat(human_mob, span_filter_notice(span_bold("To speak on your department's radio channel use :h. For the use of other channels, examine your headset.")))

	if(job.req_admin_notify)
		to_chat(human_mob, span_filter_notice(span_bold("You are playing a job that is important for Game Progression. If you have to disconnect, please notify the admins via adminhelp.")))

	// EMAIL GENERATION
	// Email addresses will be created under this domain name. Mostly for the looks.
	var/domain = "freemail.nt"
	if(using_map && LAZYLEN(using_map.usable_email_tlds))
		domain = using_map.usable_email_tlds[1]
	var/sanitized_name = sanitize(replacetext(replacetext(lowertext(human_mob.real_name), " ", "."), "'", ""))
	var/complete_login = "[sanitized_name]@[domain]"

	// It is VERY unlikely that we'll have two players, in the same round, with the same name and branch, but still, this is here.
	// If such conflict is encountered, a random number will be appended to the email address. If this fails too, no email account will be created.
	if(GLOB.ntnet_global.does_email_exist(complete_login))
		complete_login = "[sanitized_name][random_id(/datum/computer_file/data/email_account/, 100, 999)]@[domain]"

	// If even fallback login generation failed, just don't give them an email. The chance of this happening is astronomically low.
	if(GLOB.ntnet_global.does_email_exist(complete_login))
		to_chat(human_mob, span_filter_notice("You were not assigned an email address."))
		human_mob.mind.store_memory("You were not assigned an email address.")
	else
		var/datum/computer_file/data/email_account/user_mail_acc = new/datum/computer_file/data/email_account()
		user_mail_acc.password = GenerateKey()
		user_mail_acc.login = 	complete_login
		to_chat(human_mob, span_filter_notice("Your email account address is " + span_bold("[user_mail_acc.login]") + " and the password is " + span_bold("[user_mail_acc.password]") + ". This information has also been placed into your notes."))
		human_mob.mind.store_memory("Your email account address is [user_mail_acc.login] and the password is [user_mail_acc.password].")
	// END EMAIL GENERATION

	//Gives glasses to the vision impaired
	if(human_mob.disabilities & NEARSIGHTED)
		var/equipped = human_mob.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(human_mob), slot_glasses)
		if(equipped != 1)
			var/obj/item/clothing/glasses/worn_glasses = human_mob.glasses
			worn_glasses.prescription = TRUE

	BITSET(human_mob.hud_updateflag, ID_HUD)
	BITSET(human_mob.hud_updateflag, IMPLOYAL_HUD)
	BITSET(human_mob.hud_updateflag, SPECIALROLE_HUD)
	return human_mob

/datum/controller/subsystem/job/proc/handle_feedback_gathering()
	for(var/datum/job/job in occupations)
		var/tmp_str = "|[job.title]|"

		var/level1 = 0 //high
		var/level2 = 0 //medium
		var/level3 = 0 //low
		var/level4 = 0 //never
		var/level5 = 0 //banned
		var/level6 = 0 //account too young
		for(var/mob/new_player/player in GLOB.player_list)
			if(!(player.ready && player.mind && !player.mind.assigned_role))
				continue //This player is not ready
			if(jobban_isbanned(player, job.title))
				level5++
				continue
			if(!job.player_old_enough(player.client))
				level6++
				continue
			if(!job.player_has_enough_playtime(player.client))
				level6++
				continue
			if(player.client.prefs.GetJobDepartment(job, 1) & job.flag)
				level1++
			else if(player.client.prefs.GetJobDepartment(job, 2) & job.flag)
				level2++
			else if(player.client.prefs.GetJobDepartment(job, 3) & job.flag)
				level3++
			else level4++ //not selected

		tmp_str += "HIGH=[level1]|MEDIUM=[level2]|LOW=[level3]|NEVER=[level4]|BANNED=[level5]|YOUNG=[level6]|-"
		feedback_add_details("job_preferences",tmp_str)

/datum/controller/subsystem/job/proc/late_spawn(client/spawn_client, rank)

	var/datum/spawnpoint/spawnpos
	var/fail_deadly = FALSE
	var/obj/belly/vore_spawn_gut
	var/absorb_choice = FALSE // Ability to start absorbed with vorespawn
	var/mob/living/prey_to_nomph
	var/obj/item/item_to_be // Item TF spawning
	var/mob/living/item_carrier // Capture crystal spawning
	var/vorgans = FALSE // capture crystal simplemob spawning

	// Remove fail_deadly addition on offmap_spawn

	//Spawn them at their preferred one
	if(spawn_client?.prefs.read_preference(/datum/preference/choiced/living/spawnpoint))
		if(spawn_client.prefs.read_preference(/datum/preference/choiced/living/spawnpoint) == "Vorespawn - Prey")
			var/list/preds = list()
			var/list/pred_names = list() //This is cringe
			for(var/client/current_client in GLOB.clients)
				if(!isliving(current_client.mob))
					continue
				var/mob/living/current_mob = current_client.mob
				if(current_mob.stat == UNCONSCIOUS || current_mob.stat == DEAD || (current_mob.client.is_afk(10 MINUTES) && !current_mob.no_latejoin_vore_warning))
					continue
				if(!current_mob.latejoin_vore)
					continue
				if(!(current_mob.z in using_map.vorespawn_levels))
					continue
				preds += current_mob
				pred_names += current_mob.real_name //very cringe

			if(length(preds))
				var/pred_name = tgui_input_list(spawn_client, "Choose a Predator.", "Pred Spawnpoint", pred_names)
				if(!pred_name)
					return
				var/index = pred_names.Find(pred_name)
				var/mob/living/pred = preds[index]
				var/list/available_bellies = list()
				for(var/obj/belly/current_belly in pred.vore_organs)
					if(current_belly.vorespawn_blacklist)
						continue
					if(LAZYLEN(current_belly.vorespawn_whitelist) && !(spawn_client.ckey in current_belly.vorespawn_whitelist))
						continue
					available_bellies += current_belly
				var/backup = tgui_alert(spawn_client, "Do you want a mind backup?", "Confirm", list("Yes", "No"))
				if(backup == "Yes")
					backup = 1
				vore_spawn_gut = tgui_input_list(spawn_client, "Choose a Belly.", "Belly Spawnpoint", available_bellies)
				if(!vore_spawn_gut)
					return
				if(vore_spawn_gut.vorespawn_absorbed & VS_FLAG_ABSORB_YES)
					absorb_choice = TRUE
					if(vore_spawn_gut.vorespawn_absorbed & VS_FLAG_ABSORB_PREY)
						if(tgui_alert(spawn_client, "Do you want to start absorbed into [pred]'s [vore_spawn_gut]?", "Confirm", list("Yes", "No")) != "Yes")
							absorb_choice = FALSE
					else if(tgui_alert(spawn_client, "[pred]'s [vore_spawn_gut] will start with you absorbed. Continue?", "Confirm", list("Yes", "No")) != "Yes")
						return
				to_chat(spawn_client, span_boldwarning("[pred] has received your spawn request. Please wait."))
				log_admin("[key_name(spawn_client)] has requested to vore spawn into [key_name(pred)]")
				message_admins("[key_name(spawn_client)] has requested to vore spawn into [key_name(pred)]")

				var/confirm
				var/spawner_name = spawn_client.prefs.read_preference(/datum/preference/name/real_name)
				if(pred.no_latejoin_vore_warning)
					if(pred.no_latejoin_vore_warning_time > 0)
						if(absorb_choice)
							confirm = tgui_alert(pred, "[spawner_name] is attempting to spawn absorbed as your [vore_spawn_gut]. Let them?", "Confirm", list("No", "Yes"), pred.no_latejoin_vore_warning_time SECONDS)
						else
							confirm = tgui_alert(pred, "[spawner_name] is attempting to spawn into your [vore_spawn_gut]. Let them?", "Confirm", list("No", "Yes"), pred.no_latejoin_vore_warning_time SECONDS)
					if(!confirm)
						confirm = "Yes"
				else
					if(absorb_choice)
						confirm = tgui_alert(pred, "[spawner_name] is attempting to spawn absorbed as your [vore_spawn_gut]. Let them?", "Confirm", list("No", "Yes"))
					else
						confirm = tgui_alert(pred, "[spawner_name] is attempting to spawn into your [vore_spawn_gut]. Let them?", "Confirm", list("No", "Yes"))
				if(confirm != "Yes")
					to_chat(spawn_client, span_warning("[pred] has declined your spawn request."))
					var/message = tgui_input_text(pred,"Do you want to leave them a message?", "Notify Prey", max_length = MAX_MESSAGE_LEN)
					if(message)
						to_chat(spawn_client, span_notice("[pred] message : [message]"))
					return
				if(!vore_spawn_gut || QDELETED(vore_spawn_gut))
					to_chat(spawn_client, span_warning("Somehow, the belly you were trying to enter no longer exists."))
					return
				if(pred.stat == UNCONSCIOUS || pred.stat == DEAD)
					to_chat(spawn_client, span_warning("[pred] is not conscious."))
					to_chat(pred, span_warning("You must be conscious to accept."))
					return
				if(!(pred.z in using_map.vorespawn_levels))
					to_chat(spawn_client, span_warning("[pred] is no longer in station grounds."))
					to_chat(pred, span_warning("You must be within station grounds to accept."))
					return
				if(backup)
					addtimer(CALLBACK(src, PROC_REF(m_backup_client), spawn_client), 5 SECONDS)
				log_admin("[key_name(spawn_client)] has vore spawned into [key_name(pred)]")
				message_admins("[key_name(spawn_client)] has vore spawned into [key_name(pred)]")
				to_chat(spawn_client, span_notice("You have been spawned via vore. You are free to roleplay how you got there as you please, such as teleportation or having had already been there."))
				if(vore_spawn_gut.entrance_logs)
					to_chat(pred, span_notice("Your prey has spawned via vore. You are free to roleplay this how you please, such as teleportation or having had already been there."))
			else
				to_chat(spawn_client, span_warning("No predators were available to accept you."))
				return
			spawnpos = GLOB.spawntypes[spawn_client.prefs.read_preference(/datum/preference/choiced/living/spawnpoint)]
		if(spawn_client.prefs.read_preference(/datum/preference/choiced/living/spawnpoint) == "Vorespawn - Pred") //Same as above, but in reverse!
			var/list/preys = list()
			var/list/prey_names = list() //This is still cringe
			for(var/client/current_client in GLOB.clients)
				if(!isliving(current_client.mob))
					continue
				var/mob/living/current_mob = current_client.mob
				if(current_mob.stat == UNCONSCIOUS || current_mob.stat == DEAD || (current_mob.client.is_afk(10 MINUTES) && !current_mob.no_latejoin_prey_warning))
					continue
				if(!current_mob.latejoin_prey)
					continue
				if(!(current_mob.z in using_map.vorespawn_levels))
					continue
				preys += current_mob
				prey_names += current_mob.real_name
			if(length(preys))
				var/prey_name = tgui_input_list(spawn_client, "Choose a Prey to spawn nom.", "Prey Spawnpoint", prey_names)
				if(!prey_name)
					return
				var/index = prey_names.Find(prey_name)
				var/mob/living/prey = preys[index]
				var/list/available_bellies = list()

				var/datum/vore_preferences/spawn_preferences = spawn_client.prefs_vr
				for(var/preference in spawn_preferences.belly_prefs)
					available_bellies += preference["name"]
				vore_spawn_gut = tgui_input_list(spawn_client, "Choose your Belly.", "Belly Spawnpoint", available_bellies)
				if(!vore_spawn_gut)
					return
				if(alert(spawn_client, "Do you want to instantly absorb them?", "Confirm", "Yes", "No") == "Yes")
					absorb_choice = TRUE
				to_chat(spawn_client, span_boldwarning("[prey] has received your spawn request. Please wait."))
				log_admin("[key_name(spawn_client)] has requested to pred spawn onto [key_name(prey)]")
				message_admins("[key_name(spawn_client)] has requested to pred spawn onto [key_name(prey)]")

				var/confirm
				var/spawner_name = spawn_client.prefs.read_preference(/datum/preference/name/real_name)
				if(prey.no_latejoin_prey_warning)
					if(prey.no_latejoin_prey_warning_time > 0)
						if(absorb_choice)
							confirm = tgui_alert(prey, "[spawner_name] is attempting to televore and instantly absorb you with their [vore_spawn_gut]. Let them?", "Confirm", list("No", "Yes"), prey.no_latejoin_prey_warning_time SECONDS)
						else
							confirm = tgui_alert(prey, "[spawner_name] is attempting to televore you into their [vore_spawn_gut]. Let them?", "Confirm", list("No", "Yes"), prey.no_latejoin_prey_warning_time SECONDS)
					if(!confirm)
						confirm = "Yes"
				else
					if(absorb_choice)
						confirm = tgui_alert(prey, "[spawner_name] is attempting to televore and instantly absorb you with their [vore_spawn_gut]. Let them?", "Confirm", list("No", "Yes"))
					else
						confirm = tgui_alert(prey, "[spawner_name] is attempting to televore you into their [vore_spawn_gut]. Let them?", "Confirm", list("No", "Yes"))
				if(confirm != "Yes")
					to_chat(spawn_client, span_warning("[prey] has declined your spawn request."))
					var/message = tgui_input_text(prey,"Do you want to leave them a message?", "Notify Pred", max_length = MAX_MESSAGE_LEN)
					if(message)
						to_chat(spawn_client, span_notice("[prey] message : [message]"))
					return
				if(prey.stat == UNCONSCIOUS || prey.stat == DEAD)
					to_chat(spawn_client, span_warning("[prey] is not conscious."))
					to_chat(prey, span_warning("You must be conscious to accept."))
					return
				if(!(prey.z in using_map.vorespawn_levels))
					to_chat(spawn_client, span_warning("[prey] is no longer in station grounds."))
					to_chat(prey, span_warning("You must be within station grounds to accept."))
					return
				log_admin("[key_name(spawn_client)] has pred spawned onto [key_name(prey)]")
				message_admins("[key_name(spawn_client)] has pred spawned onto [key_name(prey)]")
				prey_to_nomph = prey
			else
				to_chat(spawn_client, span_warning("No prey were available to accept you."))
				return
		// Item TF spawnpoints!
		else if(spawn_client.prefs.read_preference(/datum/preference/choiced/living/spawnpoint) == "Item TF spawn")
			var/list/items = list()
			var/list/item_names = list()
			var/list/carriers = list()
			for(var/obj/item/item_spawnpoint in GLOB.item_tf_spawnpoints)
				if(LAZYLEN(item_spawnpoint.ckeys_allowed_itemspawn))
					if(!(spawn_client.ckey in item_spawnpoint.ckeys_allowed_itemspawn))
						continue
				var/atom/item_loc = item_spawnpoint.loc
				var/mob/living/carrier
				while(!isturf(item_loc))
					if(isliving(item_loc))
						carrier = item_loc
						break
					else
						item_loc = item_loc.loc
				if(istype(carrier))
					if(!(carrier.z in using_map.vorespawn_levels))
						continue
					if(carrier.stat == UNCONSCIOUS || carrier.stat == DEAD || carrier.client.is_afk(10 MINUTES))
						continue
					carriers += carrier
				else
					if(!(item_loc.z in using_map.vorespawn_levels))
						continue
					carriers += null

				if(istype(item_spawnpoint, /obj/item/capture_crystal))
					if(carrier)
						items += item_spawnpoint
						var/obj/item/capture_crystal/cryst = item_spawnpoint
						if(cryst.spawn_mob_type)
							item_names += "\a [cryst.spawn_mob_name] inside of [carrier]'s [item_spawnpoint.name] ([item_spawnpoint.loc.name])"
						else
							item_names += "Inside of [carrier]'s [item_spawnpoint.name] ([item_spawnpoint.loc.name])"
				else if(item_spawnpoint.name == initial(item_spawnpoint.name))
					items += item_spawnpoint
					if(carrier)
						item_names += "[carrier]'s [item_spawnpoint.name] ([item_spawnpoint.loc.name])"
					else
						item_names += "[item_spawnpoint.name] ([item_spawnpoint.loc.name])"
				else
					items += item_spawnpoint
					if(carrier)
						item_names += "[carrier]'s [item_spawnpoint.name] (\a [initial(item_spawnpoint.name)] at [item_spawnpoint.loc.name])"
					else
						item_names += "[item_spawnpoint.name] (\a [initial(item_spawnpoint.name)] at [item_spawnpoint.loc.name])"
			if(LAZYLEN(items))
				var/backup = tgui_alert(spawn_client, "Do you want a mind backup?", "Confirm", list("Yes", "No"))
				if(backup == "Yes")
					backup = TRUE
				var/item_name = tgui_input_list(spawn_client, "Choose an Item to spawn as.", "Item TF Spawnpoint", item_names)
				if(!item_name)
					return
				var/index = item_names.Find(item_name)
				var/obj/item/item = items[index]

				var/mob/living/carrier = carriers[index]
				if(istype(carrier))
					to_chat(spawn_client, span_boldwarning("[carrier] has received your spawn request. Please wait."))
					log_and_message_admins("[key_name(spawn_client)] has requested to item spawn into [key_name(carrier)]'s possession")

					var/confirm = tgui_alert(carrier, "[spawn_client.prefs.read_preference(/datum/preference/name/real_name)] is attempting to join as the [item_name] in your possession.", "Confirm", list("No", "Yes"))
					if(confirm != "Yes")
						to_chat(spawn_client, span_warning("[carrier] has declined your spawn request."))
						var/message = tgui_input_text(carrier,"Do you want to leave them a message?", "Notify Spawner", max_length = MAX_MESSAGE_LEN)
						if(message)
							to_chat(spawn_client, span_notice("[carrier] message : [message]"))
						return
					if(carrier.stat == UNCONSCIOUS || carrier.stat == DEAD)
						to_chat(spawn_client, span_warning("[carrier] is not conscious."))
						to_chat(carrier, span_warning("You must be conscious to accept."))
						return
					if(!(carrier.z in using_map.vorespawn_levels))
						to_chat(spawn_client, span_warning("[carrier] is no longer in station grounds."))
						to_chat(carrier, span_warning("You must be within station grounds to accept."))
						return
					log_and_message_admins("[key_name(spawn_client)] has item spawned onto [key_name(carrier)]")
					item_to_be = item
					item_carrier = carrier
					if(backup)
						addtimer(CALLBACK(src, PROC_REF(m_backup_client), spawn_client), 5 SECONDS)
				else
					var/confirm = tgui_alert(spawn_client, "\The [item.name] is currently not in any character's possession! Do you still want to spawn as it?", "Confirm", list("No", "Yes"))
					if(confirm != "Yes")
						return
					log_and_message_admins("[key_name(spawn_client)] has item spawned into \a [item.name] that was not held by anyone")
					item_to_be = item
					if(backup)
						addtimer(CALLBACK(src, PROC_REF(m_backup_client), spawn_client), 5 SECONDS)
				if(istype(item, /obj/item/capture_crystal))
					var/obj/item/capture_crystal/cryst = item
					if(cryst.spawn_mob_type)
						var/confirm = tgui_alert(spawn_client, "Do you want to spawn with your slot's vore organs and prefs?", "Confirm", list("No", "Yes"))
						if(confirm == "Yes")
							vorgans = TRUE
			else
				to_chat(spawn_client, span_warning("No items were available to accept you."))
				return
		else
			if(!(spawn_client.prefs.read_preference(/datum/preference/choiced/living/spawnpoint) in using_map.allowed_spawns))
				if(fail_deadly)
					to_chat(spawn_client, span_warning("Your chosen spawnpoint is unavailable for this map and your job requires a specific spawnpoint. Please correct your spawn point choice."))
					return
				else
					to_chat(spawn_client, span_warning("Your chosen spawnpoint ([spawn_client.prefs.read_preference(/datum/preference/choiced/living/spawnpoint)]) is unavailable for the current map. Spawning you at one of the enabled spawn points instead."))
					spawnpos = null
			else
				spawnpos = GLOB.spawntypes[spawn_client.prefs.read_preference(/datum/preference/choiced/living/spawnpoint)]

	//We will return a list key'd by "turf" and "msg"
	. = list("turf","msg", "voreny", "prey", "itemtf", "vorgans", "carrier") // Item TF spawnpoints, spawn as mob
	if(vore_spawn_gut)
		.["voreny"] = vore_spawn_gut
		.["absorb"] = absorb_choice
	if(prey_to_nomph)
		.["prey"] = prey_to_nomph	//We pass this on later to reverse the vorespawn in new_player.dm
	// Item TF spawnpoints
	if(item_to_be)
		.["carrier"] = item_carrier
		.["vorgans"] = vorgans
		.["itemtf"] = item_to_be
	if(spawnpos && istype(spawnpos) && length(spawnpos.turfs))
		if(spawnpos.check_job_spawning(rank))
			.["turf"] = spawnpos.get_spawn_position()
			.["msg"] = spawnpos.msg
			.["channel"] = spawnpos.announce_channel
		else
			var/datum/job/job_rank = SSjob.get_job(rank)
			if(fail_deadly || job_rank?.offmap_spawn)
				to_chat(spawn_client, span_warning("Your chosen spawnpoint ([spawnpos.display_name]) is unavailable for your chosen job. Please correct your spawn point choice."))
				return
			to_chat(spawn_client, span_filter_warning("Your chosen spawnpoint ([spawnpos.display_name]) is unavailable for your chosen job. Spawning you at the Arrivals shuttle instead."))
			var/spawning = pick(GLOB.latejoin)
			.["turf"] = get_turf(spawning)
			.["msg"] = "will arrive at the station shortly"
	else if(!fail_deadly)
		var/spawning = pick(GLOB.latejoin)
		.["turf"] = get_turf(spawning)
		.["msg"] = "has arrived on the station"

/datum/controller/subsystem/job/proc/m_backup_client(client/target_client)	//Same as m_backup, but takes a client entry. Used for vore late joining.
	if(!ishuman(target_client.mob))
		return
	var/mob/living/carbon/human/target_human = target_client.mob
	SStranscore.m_backup(target_human.mind, target_human.nif, TRUE)

/datum/controller/subsystem/job/proc/get_all_jobs()
	var/list/all_jobs = list()
	for(var/datum/job/current_job as anything in occupation_with_excludes)
		all_jobs += current_job.title
	return all_jobs

/datum/controller/subsystem/job/proc/get_all_centcom_jobs()
	return list("VIP Guest",
		"Custodian",
		"Thunderdome Overseer",
		"Intel Officer",
		"Medical Officer",
		"Death Commando",
		"Research Officer",
		"BlackOps Commander",
		"Supreme Commander",
		"Emergency Response Team",
		"Emergency Response Team Leader")
