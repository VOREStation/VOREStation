var/global/datum/controller/occupations/job_master

#define GET_RANDOM_JOB 0
#define BE_ASSISTANT 1
#define RETURN_TO_LOBBY 2

/datum/controller/occupations
		//List of all jobs
	var/list/occupations = list()
		//Players who need jobs
	var/list/unassigned = list()
		//Debug info
	var/list/job_debug = list()
		//Cache of icons for job info window
	var/list/job_icons = list()

/datum/controller/occupations/proc/SetupOccupations(var/faction = "Station")
	occupations = list()
	//var/list/all_jobs = typesof(/datum/job)
	var/list/all_jobs = list(/datum/job/assistant) | using_map.allowed_jobs
	if(!all_jobs.len)
		to_world("<span class='warning'>Error setting up jobs, no job datums found!</span>")
		return 0
	for(var/J in all_jobs)
		var/datum/job/job = new J()
		if(!job)	continue
		if(job.faction != faction)	continue
		occupations += job
	sortTim(occupations, /proc/cmp_job_datums)


	return 1


/datum/controller/occupations/proc/Debug(var/text)
	if(!Debug2)	return 0
	job_debug.Add(text)
	return 1


/datum/controller/occupations/proc/GetJob(var/rank)
	if(!rank)	return null
	for(var/datum/job/J in occupations)
		if(!J)	continue
		if(J.title == rank)	return J
	return null

/datum/controller/occupations/proc/GetPlayerAltTitle(mob/new_player/player, rank)
	return player.client.prefs.GetPlayerAltTitle(GetJob(rank))

/datum/controller/occupations/proc/AssignRole(var/mob/new_player/player, var/rank, var/latejoin = 0)
	Debug("Running AR, Player: [player], Rank: [rank], LJ: [latejoin]")
	if(player && player.mind && rank)
		var/datum/job/job = GetJob(rank)
		if(!job)
			return 0
		if((job.minimum_character_age || job.min_age_by_species) && (player.client.prefs.age < job.get_min_age(player.client.prefs.species, player.client.prefs.organ_data["brain"])))
			return 0
		if(jobban_isbanned(player, rank))
			return 0
		if(!job.player_old_enough(player.client))
			return 0
		//VOREStation Add
		if(!job.player_has_enough_playtime(player.client))
			return 0
		if(!is_job_whitelisted(player, rank))
			return 0
		//VOREStation Add End

		var/position_limit = job.total_positions
		if(!latejoin)
			position_limit = job.spawn_positions
		if((job.current_positions < position_limit) || position_limit == -1)
			Debug("Player: [player] is now Rank: [rank], JCP:[job.current_positions], JPL:[position_limit]")
			player.mind.assigned_role = rank
			player.mind.role_alt_title = GetPlayerAltTitle(player, rank)
			unassigned -= player
			job.current_positions++
			return 1
	Debug("AR has failed, Player: [player], Rank: [rank]")
	return 0

/datum/controller/occupations/proc/FreeRole(var/rank)	//making additional slot on the fly
	var/datum/job/job = GetJob(rank)
	if(job && job.total_positions != -1)
		job.total_positions++
		return 1
	return 0

/datum/controller/occupations/proc/FindOccupationCandidates(datum/job/job, level, flag)
	Debug("Running FOC, Job: [job], Level: [level], Flag: [flag]")
	var/list/candidates = list()
	for(var/mob/new_player/player in unassigned)
		if(jobban_isbanned(player, job.title))
			Debug("FOC isbanned failed, Player: [player]")
			continue
		if(!job.player_old_enough(player.client))
			Debug("FOC player not old enough, Player: [player]")
			continue
		if(job.minimum_character_age && (player.client.prefs.age < job.get_min_age(player.client.prefs.species, player.client.prefs.organ_data["brain"])))
			Debug("FOC character not old enough, Player: [player]")
			continue
		//VOREStation Code Start
		if(!job.player_has_enough_playtime(player.client))
			Debug("FOC character not enough playtime, Player: [player]")
			continue
		if(!is_job_whitelisted(player, job.title))
			Debug("FOC is_job_whitelisted failed, Player: [player]")
			continue
		//VOREStation Code End
		if(job.is_species_banned(player.client.prefs.species, player.client.prefs.organ_data["brain"]) == TRUE)
			Debug("FOC character species invalid for job, Player: [player]")
			continue
		if(flag && !(player.client.prefs.be_special & flag))
			Debug("FOC flag failed, Player: [player], Flag: [flag], ")
			continue
		if(player.client.prefs.GetJobDepartment(job, level) & job.flag)
			Debug("FOC pass, Player: [player], Level:[level]")
			candidates += player
	return candidates

/datum/controller/occupations/proc/GiveRandomJob(var/mob/new_player/player)
	Debug("GRJ Giving random job, Player: [player]")
	for(var/datum/job/job in shuffle(occupations))
		if(!job)
			continue

		if((job.minimum_character_age || job.min_age_by_species) && (player.client.prefs.age < job.get_min_age(player.client.prefs.species, player.client.prefs.organ_data["brain"])))
			continue

		if(job.is_species_banned(player.client.prefs.species, player.client.prefs.organ_data["brain"]) == TRUE)
			continue

		if(istype(job, GetJob(USELESS_JOB))) // We don't want to give him assistant, that's boring! //VOREStation Edit - Visitor not Assistant
			continue

		if(SSjob.is_job_in_department(job.title, DEPARTMENT_COMMAND)) //If you want a command position, select it!
			continue

		if(jobban_isbanned(player, job.title))
			Debug("GRJ isbanned failed, Player: [player], Job: [job.title]")
			continue

		if(!job.player_old_enough(player.client))
			Debug("GRJ player not old enough, Player: [player]")
			continue

		//VOREStation Code Start
		if(!job.player_has_enough_playtime(player.client))
			Debug("GRJ player not enough playtime, Player: [player]")
			continue
		if(!is_job_whitelisted(player, job.title))
			Debug("GRJ player not whitelisted for this job, Player: [player], Job: [job.title]")
			continue
		//VOREStation Code End

		if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
			Debug("GRJ Random job given, Player: [player], Job: [job]")
			AssignRole(player, job.title)
			unassigned -= player
			break

/datum/controller/occupations/proc/ResetOccupations()
	for(var/mob/new_player/player in player_list)
		if((player) && (player.mind))
			player.mind.assigned_role = null
			player.mind.special_role = null
	SetupOccupations()
	unassigned = list()
	return


///This proc is called before the level loop of DivideOccupations() and will try to select a head, ignoring ALL non-head preferences for every level until it locates a head or runs out of levels to check
/datum/controller/occupations/proc/FillHeadPosition()
	for(var/level = 1 to 3)
		for(var/command_position in SSjob.get_job_titles_in_department(DEPARTMENT_COMMAND))
			var/datum/job/job = GetJob(command_position)
			if(!job)	continue
			var/list/candidates = FindOccupationCandidates(job, level)
			if(!candidates.len)	continue

			// Build a weighted list, weight by age.
			var/list/weightedCandidates = list()
			for(var/mob/V in candidates)
				// Log-out during round-start? What a bad boy, no head position for you!
				if(!V.client) continue
				var/age = V.client.prefs.age

				if(age < job.get_min_age(V.client.prefs.species, V.client.prefs.organ_data["brain"])) // Nope.
					continue

				var/idealage = job.get_ideal_age(V.client.prefs.species, V.client.prefs.organ_data["brain"])
				var/agediff = abs(idealage - age) // Compute the absolute difference in age from target
				switch(agediff) /// If the math sucks, it's because I almost failed algebra in high school.
					if(20 to INFINITY)
						weightedCandidates[V] = 3 // Too far off
					if(10 to 20)
						weightedCandidates[V] = 6 // Nearer the mark, but not quite
					if(0 to 10)
						weightedCandidates[V] = 10 // On the mark
					else
						// If there's ABSOLUTELY NOBODY ELSE
						if(candidates.len == 1) weightedCandidates[V] = 1


			var/mob/new_player/candidate = pickweight(weightedCandidates)
			if(AssignRole(candidate, command_position))
				return 1
	return 0


///This proc is called at the start of the level loop of DivideOccupations() and will cause head jobs to be checked before any other jobs of the same level
/datum/controller/occupations/proc/CheckHeadPositions(var/level)
	for(var/command_position in SSjob.get_job_titles_in_department(DEPARTMENT_COMMAND))
		var/datum/job/job = GetJob(command_position)
		if(!job)	continue
		var/list/candidates = FindOccupationCandidates(job, level)
		if(!candidates.len)	continue
		var/mob/new_player/candidate = pick(candidates)
		AssignRole(candidate, command_position)
	return


/** Proc DivideOccupations
 *  fills var "assigned_role" for all ready players.
 *  This proc must not have any side effect besides of modifying "assigned_role".
 **/
/datum/controller/occupations/proc/DivideOccupations()
	//Setup new player list and get the jobs list
	Debug("Running DO")
	SetupOccupations()

	//Holder for Triumvirate is stored in the ticker, this just processes it
	if(ticker && ticker.triai)
		for(var/datum/job/A in occupations)
			if(A.title == "AI")
				A.spawn_positions = 3
				break

	//Get the players who are ready
	for(var/mob/new_player/player in player_list)
		if(player.ready && player.mind && !player.mind.assigned_role)
			unassigned += player

	Debug("DO, Len: [unassigned.len]")
	if(unassigned.len == 0)	return 0

	//Shuffle players and jobs
	unassigned = shuffle(unassigned)

	HandleFeedbackGathering()

	//People who wants to be assistants, sure, go on.
	Debug("DO, Running Assistant Check 1")
	var/datum/job/assist = new DEFAULT_JOB_TYPE ()
	var/list/assistant_candidates = FindOccupationCandidates(assist, 3)
	Debug("AC1, Candidates: [assistant_candidates.len]")
	for(var/mob/new_player/player in assistant_candidates)
		Debug("AC1 pass, Player: [player]")
		AssignRole(player, USELESS_JOB) //VOREStation Edit - Visitor not Assistant
		assistant_candidates -= player
	Debug("DO, AC1 end")

	//Select one head
	Debug("DO, Running Head Check")
	FillHeadPosition()
	Debug("DO, Head Check end")

	//Other jobs are now checked
	Debug("DO, Running Standard Check")


	// New job giving system by Donkie
	// This will cause lots of more loops, but since it's only done once it shouldn't really matter much at all.
	// Hopefully this will add more randomness and fairness to job giving.

	// Loop through all levels from high to low
	var/list/shuffledoccupations = shuffle(occupations)
	// var/list/disabled_jobs = ticker.mode.disabled_jobs  // So we can use .Find down below without a colon.
	for(var/level = 1 to 3)
		//Check the head jobs first each level
		CheckHeadPositions(level)

		// Loop through all unassigned players
		for(var/mob/new_player/player in unassigned)

			// Loop through all jobs
			for(var/datum/job/job in shuffledoccupations) // SHUFFLE ME BABY
				if(!job || ticker.mode.disabled_jobs.Find(job.title) )
					continue

				if(jobban_isbanned(player, job.title))
					Debug("DO isbanned failed, Player: [player], Job:[job.title]")
					continue

				if(!job.player_old_enough(player.client))
					Debug("DO player not old enough, Player: [player], Job:[job.title]")
					continue

				//VOREStation Add
				if(!job.player_has_enough_playtime(player.client))
					Debug("DO player not enough playtime, Player: [player]")
					continue
				//VOREStation Add End

				// If the player wants that job on this level, then try give it to him.
				if(player.client.prefs.GetJobDepartment(job, level) & job.flag)

					// If the job isn't filled
					if((job.current_positions < job.spawn_positions) || job.spawn_positions == -1)
						Debug("DO pass, Player: [player], Level:[level], Job:[job.title]")
						AssignRole(player, job.title)
						unassigned -= player
						break

	// Hand out random jobs to the people who didn't get any in the last check
	// Also makes sure that they got their preference correct
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == GET_RANDOM_JOB)
			GiveRandomJob(player)
	/*
	Old job system
	for(var/level = 1 to 3)
		for(var/datum/job/job in occupations)
			Debug("Checking job: [job]")
			if(!job)
				continue
			if(!unassigned.len)
				break
			if((job.current_positions >= job.spawn_positions) && job.spawn_positions != -1)
				continue
			var/list/candidates = FindOccupationCandidates(job, level)
			while(candidates.len && ((job.current_positions < job.spawn_positions) || job.spawn_positions == -1))
				var/mob/new_player/candidate = pick(candidates)
				Debug("Selcted: [candidate], for: [job.title]")
				AssignRole(candidate, job.title)
				candidates -= candidate*/

	Debug("DO, Standard Check end")

	Debug("DO, Running AC2")

	// For those who wanted to be assistant if their preferences were filled, here you go.
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == BE_ASSISTANT)
			Debug("AC2 Assistant located, Player: [player]")
			AssignRole(player, USELESS_JOB) //VOREStation Edit - Visitor not Assistant

	//For ones returning to lobby
	for(var/mob/new_player/player in unassigned)
		if(player.client.prefs.alternate_option == RETURN_TO_LOBBY)
			player.ready = 0
			player.new_player_panel_proc()
			unassigned -= player
	return 1


/datum/controller/occupations/proc/EquipRank(var/mob/living/carbon/human/H, var/rank, var/joined_late = 0)
	if(!H)	return null

	var/datum/job/job = GetJob(rank)
	var/list/spawn_in_storage = list()

	if(!joined_late)
		var/obj/S = null
		var/list/possible_spawns = list()
		for(var/obj/effect/landmark/start/sloc in landmarks_list)
			if(sloc.name != rank)	continue
			if(locate(/mob/living) in sloc.loc)	continue
			possible_spawns.Add(sloc)
		if(possible_spawns.len)
			S = pick(possible_spawns)
		if(!S)
			S = locate("start*[rank]") // use old stype
		if(istype(S, /obj/effect/landmark/start) && istype(S.loc, /turf))
			H.forceMove(S.loc)
		else
			var/list/spawn_props = LateSpawn(H.client, rank)
			var/turf/T = spawn_props["turf"]
			if(!T)
				to_chat(H, "<span class='critical'>You were unable to be spawned at your chosen late-join spawnpoint. Please verify your job/spawn point combination makes sense, and try another one.</span>")
				return
			else
				H.forceMove(T)

		// Moving wheelchair if they have one
		if(H.buckled && istype(H.buckled, /obj/structure/bed/chair/wheelchair))
			H.buckled.forceMove(H.loc)
			H.buckled.set_dir(H.dir)

	if(job)

		//Equip custom gear loadout.
		var/list/custom_equip_slots = list()
		var/list/custom_equip_leftovers = list()
		if(H.client.prefs.gear && H.client.prefs.gear.len && !(job.mob_type & JOB_SILICON))
			for(var/thing in H.client.prefs.gear)
				var/datum/gear/G = gear_datums[thing]
				if(!G) //Not a real gear datum (maybe removed, as this is loaded from their savefile)
					continue

				var/permitted
				// Check if it is restricted to certain roles
				if(G.allowed_roles)
					for(var/job_name in G.allowed_roles)
						if(job.title == job_name)
							permitted = 1
				else
					permitted = 1

				// Check if they're whitelisted for this gear (in alien whitelist? seriously?)
				if(G.whitelisted && !is_alien_whitelisted(H, GLOB.all_species[G.whitelisted]))
					permitted = 0

				// If they aren't, tell them
				if(!permitted)
					to_chat(H, "<span class='warning'>Your current species, job or whitelist status does not permit you to spawn with [thing]!</span>")
					continue

				// Implants get special treatment
				if(G.slot == "implant")
					var/obj/item/implant/I = G.spawn_item(H, H.client.prefs.gear[G.display_name])
					I.invisibility = 100
					I.implant_loadout(H)
					continue

				// Try desperately (and sorta poorly) to equip the item. Now with increased desperation!
				if(G.slot && !(G.slot in custom_equip_slots))
					var/metadata = H.client.prefs.gear[G.display_name]
					if(G.slot == slot_wear_mask || G.slot == slot_wear_suit || G.slot == slot_head)
						custom_equip_leftovers += thing
					else if(H.equip_to_slot_or_del(G.spawn_item(H, metadata), G.slot))
						to_chat(H, "<span class='notice'>Equipping you with \the [thing]!</span>")
						if(G.slot != slot_tie)
							custom_equip_slots.Add(G.slot)
					else
						custom_equip_leftovers.Add(thing)
				else
					spawn_in_storage += thing

		// Set up their account
		job.setup_account(H)

		// Equip job items.
		job.equip(H, H.mind ? H.mind.role_alt_title : "")

		// Stick their fingerprints on literally everything
		job.apply_fingerprints(H)

		// Only non-silicons get post-job-equip equipment
		if(!(job.mob_type & JOB_SILICON))
			H.equip_post_job()

		// If some custom items could not be equipped before, try again now.
		for(var/thing in custom_equip_leftovers)
			var/datum/gear/G = gear_datums[thing]
			if(G.slot in custom_equip_slots)
				spawn_in_storage += thing
			else
				var/metadata = H.client.prefs.gear[G.display_name]
				if(H.equip_to_slot_or_del(G.spawn_item(H, metadata), G.slot))
					to_chat(H, "<span class='notice'>Equipping you with \the [thing]!</span>")
					custom_equip_slots.Add(G.slot)
				else
					spawn_in_storage += thing
	else
		to_chat(H, "Your job is [rank] and the game just can't handle it! Please report this bug to an administrator.")

	H.job = rank
	log_game("JOINED [key_name(H)] as \"[rank]\"")
	log_game("SPECIES [key_name(H)] is a: \"[H.species.name]\"") //VOREStation Add

	// If they're head, give them the account info for their department
	if(H.mind && job.department_accounts)
		var/remembered_info = ""
		for(var/D in job.department_accounts)
			var/datum/money_account/department_account = department_accounts[D]
			if(department_account)
				remembered_info += "<b>Department account number ([D]):</b> #[department_account.account_number]<br>"
				remembered_info += "<b>Department account pin ([D]):</b> [department_account.remote_access_pin]<br>"
				remembered_info += "<b>Department account funds ([D]):</b> $[department_account.money]<br>"

		H.mind.store_memory(remembered_info)

	var/alt_title = null
	if(H.mind)
		H.mind.assigned_role = rank
		alt_title = H.mind.role_alt_title

		// If we're a silicon, we may be done at this point
		if(job.mob_type & JOB_SILICON_ROBOT)
			return H.Robotize()
		if(job.mob_type & JOB_SILICON_AI)
			return H

		// TWEET PEEP
		if(rank == "Site Manager")
			var/sound/announce_sound = (ticker.current_state <= GAME_STATE_SETTING_UP) ? null : sound('sound/misc/boatswain.ogg', volume=20)
			captain_announcement.Announce("All hands, [alt_title ? alt_title : "Site Manager"] [H.real_name] on deck!", new_sound = announce_sound, zlevel = H.z)

		//Deferred item spawning.
		if(spawn_in_storage && spawn_in_storage.len)
			var/obj/item/storage/B
			for(var/obj/item/storage/S in H.contents)
				B = S
				break

			if(!isnull(B))
				for(var/thing in spawn_in_storage)
					to_chat(H, "<span class='notice'>Placing \the [thing] in your [B.name]!</span>")
					var/datum/gear/G = gear_datums[thing]
					var/metadata = H.client.prefs.gear[G.display_name]
					G.spawn_item(B, metadata)
			else
				to_chat(H, "<span class='danger'>Failed to locate a storage object on your mob, either you spawned with no arms and no backpack or this is a bug.</span>")

	if(istype(H)) //give humans wheelchairs, if they need them.
		var/obj/item/organ/external/l_foot = H.get_organ("l_foot")
		var/obj/item/organ/external/r_foot = H.get_organ("r_foot")
		var/obj/item/storage/S = locate() in H.contents
		var/obj/item/wheelchair/R
		if(S)
			R = locate() in S.contents
		if(!l_foot || !r_foot || R)
			var/wheelchair_type = R?.unfolded_type || /obj/structure/bed/chair/wheelchair
			var/obj/structure/bed/chair/wheelchair/W = new wheelchair_type(H.loc)
			W.buckle_mob(H)
			H.update_canmove()
			W.set_dir(H.dir)
			W.add_fingerprint(H)
			if(R)
				W.color = R.color
				qdel(R)

	to_chat(H, "<B>You are [job.total_positions == 1 ? "the" : "a"] [alt_title ? alt_title : rank].</B>")

	if(job.supervisors)
		to_chat(H, "<b>As the [alt_title ? alt_title : rank] you answer directly to [job.supervisors]. Special circumstances may change this.</b>")
	if(job.has_headset)
		H.equip_to_slot_or_del(new /obj/item/radio/headset(H), slot_l_ear)
		to_chat(H, "<b>To speak on your department's radio channel use :h. For the use of other channels, examine your headset.</b>")

	if(job.req_admin_notify)
		to_chat(H, "<b>You are playing a job that is important for Game Progression. If you have to disconnect, please notify the admins via adminhelp.</b>")

	// EMAIL GENERATION
	// Email addresses will be created under this domain name. Mostly for the looks.
	var/domain = "freemail.nt"
	if(using_map && LAZYLEN(using_map.usable_email_tlds))
		domain = using_map.usable_email_tlds[1]
	var/sanitized_name = sanitize(replacetext(replacetext(lowertext(H.real_name), " ", "."), "'", ""))
	var/complete_login = "[sanitized_name]@[domain]"

	// It is VERY unlikely that we'll have two players, in the same round, with the same name and branch, but still, this is here.
	// If such conflict is encountered, a random number will be appended to the email address. If this fails too, no email account will be created.
	if(ntnet_global.does_email_exist(complete_login))
		complete_login = "[sanitized_name][random_id(/datum/computer_file/data/email_account/, 100, 999)]@[domain]"

	// If even fallback login generation failed, just don't give them an email. The chance of this happening is astronomically low.
	if(ntnet_global.does_email_exist(complete_login))
		to_chat(H, "You were not assigned an email address.")
		H.mind.store_memory("You were not assigned an email address.")
	else
		var/datum/computer_file/data/email_account/EA = new/datum/computer_file/data/email_account()
		EA.password = GenerateKey()
		EA.login = 	complete_login
		to_chat(H, "Your email account address is <b>[EA.login]</b> and the password is <b>[EA.password]</b>. This information has also been placed into your notes.")
		H.mind.store_memory("Your email account address is [EA.login] and the password is [EA.password].")
	// END EMAIL GENERATION

	//Gives glasses to the vision impaired
	if(H.disabilities & NEARSIGHTED)
		var/equipped = H.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(H), slot_glasses)
		if(equipped != 1)
			var/obj/item/clothing/glasses/G = H.glasses
			G.prescription = 1

	BITSET(H.hud_updateflag, ID_HUD)
	BITSET(H.hud_updateflag, IMPLOYAL_HUD)
	BITSET(H.hud_updateflag, SPECIALROLE_HUD)
	return H

/datum/controller/occupations/proc/LoadJobs(jobsfile) //ran during round setup, reads info from jobs.txt -- Urist
	if(!config.load_jobs_from_txt)
		return 0

	var/list/jobEntries = file2list(jobsfile)

	for(var/job in jobEntries)
		if(!job)
			continue

		job = trim(job)
		if (!length(job))
			continue

		var/pos = findtext(job, "=")
		var/name = null
		var/value = null

		if(pos)
			name = copytext(job, 1, pos)
			value = copytext(job, pos + 1)
		else
			continue

		if(name && value)
			var/datum/job/J = GetJob(name)
			if(!J)	continue
			J.total_positions = text2num(value)
			J.spawn_positions = text2num(value)
			if(J.mob_type & JOB_SILICON)
				J.total_positions = 0

	return 1


/datum/controller/occupations/proc/HandleFeedbackGathering()
	for(var/datum/job/job in occupations)
		var/tmp_str = "|[job.title]|"

		var/level1 = 0 //high
		var/level2 = 0 //medium
		var/level3 = 0 //low
		var/level4 = 0 //never
		var/level5 = 0 //banned
		var/level6 = 0 //account too young
		for(var/mob/new_player/player in player_list)
			if(!(player.ready && player.mind && !player.mind.assigned_role))
				continue //This player is not ready
			if(jobban_isbanned(player, job.title))
				level5++
				continue
			if(!job.player_old_enough(player.client))
				level6++
				continue
			//VOREStation Add
			if(!job.player_has_enough_playtime(player.client))
				level6++
				continue
			//VOREStation Add End
			if(player.client.prefs.GetJobDepartment(job, 1) & job.flag)
				level1++
			else if(player.client.prefs.GetJobDepartment(job, 2) & job.flag)
				level2++
			else if(player.client.prefs.GetJobDepartment(job, 3) & job.flag)
				level3++
			else level4++ //not selected

		tmp_str += "HIGH=[level1]|MEDIUM=[level2]|LOW=[level3]|NEVER=[level4]|BANNED=[level5]|YOUNG=[level6]|-"
		feedback_add_details("job_preferences",tmp_str)

/datum/controller/occupations/proc/LateSpawn(var/client/C, var/rank)

	var/datum/spawnpoint/spawnpos
	var/fail_deadly = FALSE

	var/datum/job/J = SSjob.get_job(rank)
	fail_deadly = J?.offmap_spawn

	//Spawn them at their preferred one
	if(C && C.prefs.spawnpoint)
		if(!(C.prefs.spawnpoint in using_map.allowed_spawns))
			if(fail_deadly)
				to_chat(C, "<span class='warning'>Your chosen spawnpoint is unavailable for this map and your job requires a specific spawnpoint. Please correct your spawn point choice.</span>")
				return
			else
				to_chat(C, "<span class='warning'>Your chosen spawnpoint ([C.prefs.spawnpoint]) is unavailable for the current map. Spawning you at one of the enabled spawn points instead.</span>")
				spawnpos = null
		else
			spawnpos = spawntypes[C.prefs.spawnpoint]

	//We will return a list key'd by "turf" and "msg"
	. = list("turf","msg")
	if(spawnpos && istype(spawnpos) && spawnpos.turfs.len)
		if(spawnpos.check_job_spawning(rank))
			.["turf"] = spawnpos.get_spawn_position()
			.["msg"] = spawnpos.msg
			.["channel"] = spawnpos.announce_channel
		else
			if(fail_deadly)
				to_chat(C, "<span class='warning'>Your chosen spawnpoint ([spawnpos.display_name]) is unavailable for your chosen job. Please correct your spawn point choice.</span>")
				return
			to_chat(C, "Your chosen spawnpoint ([spawnpos.display_name]) is unavailable for your chosen job. Spawning you at the Arrivals shuttle instead.")
			var/spawning = pick(latejoin)
			.["turf"] = get_turf(spawning)
			.["msg"] = "will arrive at the station shortly"
	else if(!fail_deadly)
		var/spawning = pick(latejoin)
		.["turf"] = get_turf(spawning)
		.["msg"] = "has arrived on the station"
