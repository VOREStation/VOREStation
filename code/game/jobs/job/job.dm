/datum/job

	//The name of the job
	var/title = "NOPE"
	//Job access. The use of minimal_access or access is determined by a config setting: config.jobs_have_minimal_access
	var/list/minimal_access = list()      // Useful for servers which prefer to only have access given to the places a job absolutely needs (Larger server population)
	var/list/access = list()              // Useful for servers which either have fewer players, so each person needs to fill more than one role, or servers which like to give more access, so players can't hide forever in their super secure departments (I'm looking at you, chemistry!)
	var/flag = 0 	                      // Bitflags for the job
	var/department_flag = 0
	var/faction = FACTION_NONE            // Players will be allowed to spawn in as jobs that are set to FACTION_STATION
	var/total_positions = 0               // How many players can be this job
	var/spawn_positions = 0               // How many players can spawn in as this job
	var/current_positions = 0             // How many players have this job
	var/supervisors = null                // Supervisors, who this person answers to directly
	var/selection_color = "#ffffff"       // Selection screen color
	var/list/alt_titles = null            // List of alternate titles; There is no need for an alt-title datum for the base job title.
	var/req_admin_notify                  // If this is set to 1, a text is printed to the player when jobs are assigned, telling him that he should let admins know that he has to disconnect.
	var/minimal_player_age = 0            // If you have use_age_restriction_for_jobs config option enabled and the database set up, this option will add a requirement for players to be at least minimal_player_age days old. (meaning they first signed in at least that many days before.)
	var/list/departments = list()         // List of departments this job belongs to, if any. The first one on the list will be the 'primary' department.
	var/sorting_order = 0                 // Used for sorting jobs so boss jobs go above regular ones, and their boss's boss is above that. Higher numbers = higher in sorting.
	var/departments_managed = null        // Is this a management position?  If yes, list of departments managed.  Otherwise null.
	var/department_accounts = null        // Which department accounts should people with this position be given the pin for?
	var/assignable = TRUE                 // Should it show up on things like the ID computer?
	var/minimum_character_age = 0
	var/list/min_age_by_species = null
	var/ideal_character_age = 30
	var/list/ideal_age_by_species = null
	var/list/banned_job_species = null
	var/has_headset = TRUE                //Do people with this job need to be given headsets and told how to use them?  E.g. Cyborgs don't.

	var/account_allowed = 1				  // Does this job type come with a station account?
	var/economic_modifier = 2			  // With how much does this job modify the initial account amount?

	var/outfit_type						  // What outfit datum does this job use in its default title?

	var/offmap_spawn = FALSE			  // Do we require weird and special spawning and datacore handling?
	var/mob_type = JOB_CARBON 		      // Bitflags representing mob type this job spawns

	// Description of the job's role and minimum responsibilities.
	var/job_description = "This Job doesn't have a description! Please report it!"

	//Requires a ckey to be whitelisted in jobwhitelist.txt
	var/whitelist_only = 0

	//Does not display this job on the occupation setup screen
	var/latejoin_only = 0

	//Every hour playing this role gains this much time off. (Can be negative for off duty jobs!)
	var/timeoff_factor = 3

	//What type of PTO is that job earning?
	var/pto_type

	//Disallow joining as this job midround from off-duty position via going on-duty
	var/disallow_jobhop = FALSE

	//Time required in the department as other jobs before playing this one (in hours)
	var/dept_time_required = 0

	//Do we forbid ourselves from earning PTO?
	var/playtime_only = FALSE

	var/requestable = TRUE

	VAR_PROTECTED/list/mail_goodies = null		  // Goodies that can be received via the mail system
	VAR_PROTECTED/exclusive_mail_goodies = FALSE	  // If this job's mail goodies compete with generic goodies.
	VAR_PROTECTED/mail_color = "#FFF"

/datum/job/New()
	. = ..()
	department_accounts = department_accounts || departments_managed

/datum/job/proc/equip(var/mob/living/carbon/human/H, var/alt_title)
	var/decl/hierarchy/outfit/outfit = get_outfit(H, alt_title)
	if(!outfit)
		return FALSE
	. = outfit.equip(H, title, alt_title)
	return 1

/datum/job/proc/get_outfit(var/mob/living/carbon/human/H, var/alt_title)
	if(alt_title && alt_titles)
		var/datum/alt_title/A = alt_titles[alt_title]
		if(A && initial(A.title_outfit))
			. = initial(A.title_outfit)
	. = . || outfit_type
	. = outfit_by_type(.)

/datum/job/proc/setup_account(var/mob/living/carbon/human/H)
	if(!account_allowed || (H.mind && H.mind.initial_account))
		return

	var/income = 1
	if(H.client)
		switch(H.client.prefs.economic_status)
			if(CLASS_UPPER)		income = 1.30
			if(CLASS_UPMID)		income = 1.15
			if(CLASS_MIDDLE)	income = 1
			if(CLASS_LOWMID)	income = 0.75
			if(CLASS_LOWER)		income = 0.50
			if(CLASS_BROKE)		income = 0	//VOREStation Add - Rent's not cheap

	//give them an account in the station database
	var/money_amount = (rand(15,40) + rand(15,40)) * income * economic_modifier * ECO_MODIFIER //VOREStation Edit - Smoothed peaks, ECO_MODIFIER rather than per-species ones.
	var/datum/money_account/M = create_account(H.real_name, money_amount, null, offmap_spawn)
	if(H.mind)
		var/remembered_info = ""
		remembered_info += span_bold("Your account number is:") + " #[M.account_number]<br>"
		remembered_info += span_bold("Your account pin is:") + " [M.remote_access_pin]<br>"
		remembered_info += span_bold("Your account funds are:") + " $[M.money]<br>"

		if(M.transaction_log.len)
			var/datum/transaction/T = M.transaction_log[1]
			remembered_info += span_bold("Your account was created:") + " [T.time], [T.date] at [T.source_terminal]<br>"
		H.mind.store_memory(remembered_info)

		H.mind.initial_account = M

	to_chat(H, span_boldnotice("Your account number is: [M.account_number], your account pin is: [M.remote_access_pin]"))

// overrideable separately so AIs/borgs can have cardborg hats without unneccessary new()/qdel()
/datum/job/proc/equip_preview(mob/living/carbon/human/H, var/alt_title)
	var/decl/hierarchy/outfit/outfit = get_outfit(H, alt_title)
	if(!outfit)
		return FALSE
	. = outfit.equip_base(H, title, alt_title)

/datum/job/proc/get_access()
	if(!config || CONFIG_GET(flag/jobs_have_minimal_access))
		return src.minimal_access.Copy()
	else
		return src.access.Copy()

//If the configuration option is set to require players to be logged as old enough to play certain jobs, then this proc checks that they are, otherwise it just returns 1
/datum/job/proc/player_old_enough(client/C)
	return (available_in_days(C) == 0) //Available in 0 days = available right now = player is old enough to play.

/datum/job/proc/available_in_days(client/C)
	if(C && CONFIG_GET(flag/use_age_restriction_for_jobs) && isnum(C.player_age) && isnum(minimal_player_age))
		return max(0, minimal_player_age - C.player_age)
	return 0

/datum/job/proc/apply_fingerprints(var/mob/living/carbon/human/target)
	if(!istype(target))
		return 0
	for(var/obj/item/item in target.contents)
		apply_fingerprints_to_item(target, item)
	return 1

/datum/job/proc/apply_fingerprints_to_item(var/mob/living/carbon/human/holder, var/obj/item/item)
	item.add_fingerprint(holder,1)
	if(item.contents.len)
		for(var/obj/item/sub_item in item.contents)
			apply_fingerprints_to_item(holder, sub_item)

/datum/job/proc/is_position_available()
	return (current_positions < total_positions) || (total_positions == -1)

/datum/job/proc/has_alt_title(var/mob/H, var/supplied_title, var/desired_title)
	return (supplied_title == desired_title) || (H.mind && H.mind.role_alt_title == desired_title)

/datum/job/proc/get_description_blurb(var/alt_title)
	var/list/message = list()
	message |= job_description

	if(alt_title && alt_titles)
		var/typepath = alt_titles[alt_title]
		if(typepath)
			var/datum/alt_title/A = new typepath()
			if(A.title_blurb)
				message |= A.title_blurb
	return message

/datum/job/proc/get_job_icon()
	if(!job_master.job_icons[title])
		var/mob/living/carbon/human/dummy/mannequin/mannequin = get_mannequin("#job_icon")
		dress_mannequin(mannequin)
		mannequin.dir = SOUTH
		mannequin.ImmediateOverlayUpdate()
		var/icon/preview_icon = getFlatIcon(mannequin)

		preview_icon.Scale(preview_icon.Width() * 2, preview_icon.Height() * 2) // Scaling here to prevent blurring in the browser.
		job_master.job_icons[title] = preview_icon

	return job_master.job_icons[title]

/datum/job/proc/dress_mannequin(var/mob/living/carbon/human/dummy/mannequin/mannequin)
	mannequin.delete_inventory(TRUE)
	equip_preview(mannequin)
	if(mannequin.back)
		var/obj/O = mannequin.back
		mannequin.drop_from_inventory(O)
		qdel(O)

///Assigns minimum age by race & brain type. Code says Positronic = mechanical and Drone = digital because nothing can be simple.
///Will first check based on brain type, then based on species.
/datum/job/proc/get_min_age(species_name, brain_type)
	return minimum_character_age // VOREStation Edit - Minimum character age by rules is 18, return default which is standard for all species
    //return (brain_type && LAZYACCESS(min_age_by_species, brain_type)) || LAZYACCESS(min_age_by_species, species_name) || minimum_character_age //VOREStation Removal

/datum/job/proc/get_ideal_age(species_name, brain_type)
	return ideal_character_age // VOREStation Edit - Minimum character age by rules is 18, return default which is standard for all species
	//return (brain_type && LAZYACCESS(ideal_age_by_species, brain_type)) || LAZYACCESS(ideal_age_by_species, brain_type) || ideal_character_age //VOREStation Removal

/datum/job/proc/is_species_banned(species_name, brain_type)
	return FALSE // VOREStation Edit - Any species can be any job.
	/* VOREStation Removal
	if(banned_job_species == null)
		return
	if(species_name in banned_job_species)
		return TRUE
	if(brain_type in banned_job_species)
		return TRUE
	*/


// Check client-specific availability rules.
/datum/job/proc/player_has_enough_pto(client/C)
	return timeoff_factor >= 0 || (C && LAZYACCESS(C.department_hours, pto_type) > 0)

/datum/job/proc/player_has_enough_playtime(client/C)
	return (available_in_playhours(C) == 0)

/datum/job/proc/available_in_playhours(client/C)
	if(C && CONFIG_GET(flag/use_playtime_restriction_for_jobs) && dept_time_required)
		if(isnum(C.play_hours[pto_type])) // Has played that department before
			return max(0, dept_time_required - C.play_hours[pto_type])
		else // List doesn't have that entry, maybe never played, maybe invalid PTO type (you should fix that...)
			return dept_time_required // Could be 0, too, which is fine! They can play that
	return 0

// Special treatment for some the more complicated heads

// Captain gets every department combined
/datum/job/captain/available_in_playhours(client/C)
	if(C && CONFIG_GET(flag/use_playtime_restriction_for_jobs) && dept_time_required)
		var/remaining_time_needed = dept_time_required
		for(var/key in C.play_hours)
			if(isnum(C.play_hours[key]) && !(key == PTO_TALON))
				remaining_time_needed = max(0, remaining_time_needed - C.play_hours[key])
		return remaining_time_needed
	return 0

// HoP gets civilian, cargo, and exploration combined
/datum/job/hop/available_in_playhours(client/C)
	if(C && CONFIG_GET(flag/use_playtime_restriction_for_jobs) && dept_time_required)
		var/remaining_time_needed = dept_time_required
		if(isnum(C.play_hours[PTO_CIVILIAN]))
			remaining_time_needed = max(0, remaining_time_needed - C.play_hours[PTO_CIVILIAN])
		if(isnum(C.play_hours[PTO_CARGO]))
			remaining_time_needed = max(0, remaining_time_needed - C.play_hours[PTO_CARGO])
		if(isnum(C.play_hours[PTO_EXPLORATION]))
			remaining_time_needed = max(0, remaining_time_needed - C.play_hours[PTO_EXPLORATION])
		return remaining_time_needed
	return 0

/datum/job/proc/get_request_reasons()
	return list()
