// This is a generic datum used to ask ghosts if they wish to be a specific role, such as a Promethean, an Apprentice, a Xeno, etc.
// Simply instantiate the correct subtype of this datum, call query(), and it will return a list of ghost candidates after a delay.
/datum/ghost_query
	var/list/candidates = list()
	var/finished = FALSE
	var/role_name = "a thing"
	var/question = "Would you like to play as a thing?"
	var/query_sound = 'sound/effects/ghost2.ogg' // A sound file to play to the ghost, to help people who are alt-tabbed know something might interest them.
	var/be_special_flag = 0
	var/list/check_bans = list()
	var/wait_time = 60 SECONDS 	// How long to wait until returning the list of candidates.
	var/cutoff_number = 0		// If above 0, when candidates list reaches this number, further potential candidates are rejected.

/datum/ghost_query/proc/query()
	// First, ask all the ghosts who want to be asked.
	for(var/mob/observer/dead/D in player_list)
		if(!D.MayRespawn())
			continue // They can't respawn for whatever reason.
		if(D.client)
			if(be_special_flag && !(D.client.prefs.be_special & be_special_flag) )
				continue // They don't want to see the prompt.
			for(var/ban in check_bans)
				if(jobban_isbanned(D, ban))
					continue // They're banned from this role.
			ask_question(D.client)
	// Then wait awhile.
	while(!finished)
		sleep(1 SECOND)
		wait_time -= 1 SECOND
		if(wait_time <= 0)
			finished = TRUE

	// Prune the list after the wait, incase any candidates logged out.
	for(var/mob/observer/dead/D in candidates)
		if(!D.client || !D.key)
			candidates.Remove(D)

	// Now we're done.
	finished = TRUE
	return candidates

/datum/ghost_query/proc/ask_question(var/client/C)
	spawn(0)
		if(!C)
			return
		window_flash(C)
		if(query_sound)
			SEND_SOUND(C, sound(query_sound))
		var/response = alert(C, question, "[role_name] request", "Yes", "No", "Never for this round")
		if(response == "Yes")
			response = alert(C, "Are you sure you want to play as a [role_name]?", "[role_name] request", "Yes", "No") // Protection from a misclick.
		if(!C || !src)
			return
		if(response == "Yes")
			if(finished || (cutoff_number && candidates.len >= cutoff_number) )
				to_chat(C, "<span class='warning'>Unfortunately, you were not fast enough, and there are no more available roles.  Sorry.</span>")
				return
			candidates.Add(C.mob)
			if(cutoff_number && candidates.len >= cutoff_number)
				finished = TRUE // Finish now if we're full.
		else if(response == "Never for this round")
			if(be_special_flag)
				C.prefs.be_special ^= be_special_flag

// Normal things.
/datum/ghost_query/promethean
	role_name = "Promethean"
	question = "Someone is requesting a soul for a promethean.  Would you like to play as one?"
	query_sound = 'sound/effects/slime_squish.ogg'
	be_special_flag = BE_ALIEN
	cutoff_number = 1

/datum/ghost_query/posi_brain
	role_name = "Positronic Intelligence"
	question = "Someone has activated a Positronic Brain.  Would you like to play as one?"
	query_sound = 'sound/machines/boobeebeep.ogg'
	be_special_flag = BE_AI
	check_bans = list("AI", "Cyborg")
	cutoff_number = 1

/datum/ghost_query/drone_brain
	role_name = "Drone Intelligence"
	question = "Someone has activated a Drone AI Chipset.  Would you like to play as one?"
	query_sound = 'sound/machines/boobeebeep.ogg'
	be_special_flag = BE_AI
	check_bans = list("AI", "Cyborg")
	cutoff_number = 1

// Antags.
/datum/ghost_query/apprentice
	role_name = "Technomancer Apprentice"
	question = "A Technomancer is requesting an Apprentice to help them on their adventure to the facility.  Would you like to play as the Apprentice?"
	be_special_flag = BE_WIZARD
	check_bans = list("Syndicate", "wizard")
	cutoff_number = 1

/datum/ghost_query/xeno
	role_name = "Alien"
	question = "An Alien has just been created on the facility.  Would you like to play as them?"
	query_sound = 'sound/voice/hiss5.ogg'
	be_special_flag = BE_ALIEN

/datum/ghost_query/blob
	role_name = "Blob"
	question = "A rapidly expanding Blob has just appeared on the facility.  Would you like to play as it?"
	be_special_flag = BE_ALIEN
	cutoff_number = 1
	wait_time = 10 SECONDS

/datum/ghost_query/syndicate_drone
	role_name = "Mercenary Drone"
	question = "A team of dubious mercenaries have purchased a powerful drone, and they are attempting to activate it.  Would you like to play as the drone?"
	be_special_flag = BE_AI
	check_bans = list("AI", "Cyborg", "Syndicate")
	cutoff_number = 1

/datum/ghost_query/borer
	role_name = "Cortical Borer"
	question = "A cortical borer has just been created on the facility.  Would you like to play as them?"
	be_special_flag = BE_ALIEN
	check_bans = list("Syndicate", "Borer")
	cutoff_number = 1

// Surface stuff.
/datum/ghost_query/lost_drone
	role_name = "Lost Drone"
	question = "A lost drone onboard has been discovered by a crewmember and they are attempting to reactivate it.  Would you like to play as the drone?"
	//be_special_flag = BE_AI	//VOREStation Removal: Positronic role is never used because intended purpose is unfitting, so remove the check
	check_bans = list("AI", "Cyborg")
	cutoff_number = 1

/datum/ghost_query/gravekeeper_drone
	role_name = "Gravekeeper Drone"
	question = "A gravekeeper drone is about to reactivate and tend to its gravesite. Would you like to play as the drone?"
	be_special_flag = BE_AI
	check_bans = list("AI", "Cyborg")
	cutoff_number = 1

/datum/ghost_query/lost_passenger
	role_name = "Lost Passenger"
	question = "A person suspended in cryosleep has been discovered by a crewmember \
	and they are attempting to open the cryopod.  Would you like to play as the occupant?"
	cutoff_number = 1

/datum/ghost_query/stowaway
	role_name = "Stowaway"
	question = "A person suspended in cryosleep has awoken in their pod aboard the station.\
	Would you like to play as the occupant?"
	cutoff_number = 1

/datum/ghost_query/corgi_rune
	role_name = "Dark Creature"
	question = "A curious explorer has touched a mysterious rune. \
	Would you like to play as the creature it summons?"
	cutoff_number = 1

/datum/ghost_query/cursedblade
	role_name = "Cursed Sword"
	question = "A cursed blade has been discovered by a curious explorer. \
	Would you like to play as the soul imprisoned within?"
	cutoff_number = 1
