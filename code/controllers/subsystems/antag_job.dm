SUBSYSTEM_DEF(antag_job)
	name = "Antag Job"
	flags = SS_NO_FIRE
		//List of all jobs
	dependencies = list(
		/datum/controller/subsystem/job
	)
	var/list/occupations = list()

	var/list/syndicate_code_phrase
	var/list/syndicate_code_response

	var/list/all_antag_types = list()
	var/list/all_antag_spawnpoints = list()
	VAR_PRIVATE/list/antag_names_to_ids = list()

/datum/controller/subsystem/antag_job/Initialize()
	populate_antag_type_list()
	syndicate_code_phrase = generate_code_phrase()
	syndicate_code_response = generate_code_phrase()

	return SS_INIT_SUCCESS

//Traitors and traitor silicons will get these. Revs will not.

	/*
	Should be expanded.
	How this works:
	Instead of "I'm looking for James Smith," the traitor would say "James Smith" as part of a conversation.
	Another traitor may then respond with: "They enjoy running through the void-filled vacuum of the derelict."
	The phrase should then have the words: James Smith.
	The response should then have the words: run, void, and derelict.
	This way assures that the code is suited to the conversation and is unpredicatable.
	Obviously, some people will be better at this than others but in theory, everyone should be able to do it and it only enhances roleplay.
	Can probably be done through "{ }" but I don't really see the practical benefit.
	One example of an earlier system is commented below.
	-N
	*/

/datum/controller/subsystem/antag_job/proc/generate_code_phrase()//Proc is used for phrase and response in master_controller.dm

	var/code_phrase = ""//What is returned when the proc finishes.
	var/words = pick(//How many words there will be. Minimum of two. 2, 4 and 5 have a lesser chance of being selected. 3 is the most likely.
		50; 2,
		200; 3,
		50; 4,
		25; 5
	)

	var/list/safety = list(1,2,3)//Tells the proc which options to remove later on.
	var/list/nouns = list("love","hate","anger","peace","pride","sympathy","bravery","loyalty","honesty","integrity","compassion","charity","success","courage","deceit","skill","beauty","brilliance","pain","misery","beliefs","dreams","justice","truth","faith","liberty","knowledge","thought","information","culture","trust","dedication","progress","education","hospitality","leisure","trouble","friendships", "relaxation")
	var/list/drinks = list("vodka and tonic","gin fizz","bahama mama","manhattan","black Russian","whiskey soda","long island tea","margarita","Irish coffee"," manly dwarf","Irish cream","doctor's delight","Beepksy Smash","tequila sunrise","brave bull","gargle blaster","bloody mary","whiskey cola","white Russian","vodka martini","martini","Cuba libre","kahlua","vodka","redwine","moonshine")
	var/list/locations = GLOB.teleportlocs.len ? GLOB.teleportlocs : drinks//if null, defaults to drinks instead.

	var/list/names = list()
	for(var/datum/data/record/t in GLOB.data_core.general)//Picks from crew manifest.
		names += t.fields["name"]

	var/maxwords = words//Extra var to check for duplicates.

	for(words,words>0,words--)//Randomly picks from one of the choices below.

		if(words==1&&(1 in safety)&&(2 in safety))//If there is only one word remaining and choice 1 or 2 have not been selected.
			safety = list(pick(1,2))//Select choice 1 or 2.
		else if(words==1&&maxwords==2)//Else if there is only one word remaining (and there were two originally), and 1 or 2 were chosen,
			safety = list(3)//Default to list 3

		switch(pick(safety))//Chance based on the safety list.
			if(1)//1 and 2 can only be selected once each to prevent more than two specific names/places/etc.
				switch(rand(1,2))//Mainly to add more options later.
					if(1)
						if(names.len&&prob(70))
							code_phrase += pick(names)
						else
							code_phrase += pick(pick(GLOB.first_names_male, GLOB.first_names_female))
							code_phrase += " "
							code_phrase += pick(GLOB.last_names)
					if(2)
						code_phrase += pick(SSjob.occupations)//Returns a job.
				safety -= 1
			if(2)
				switch(rand(1,2))//Places or things.
					if(1)
						code_phrase += pick(drinks)
					if(2)
						code_phrase += pick(locations)
				safety -= 2
			if(3)
				switch(rand(1,3))//Nouns, adjectives, verbs. Can be selected more than once.
					if(1)
						code_phrase += pick(nouns)
					if(2)
						code_phrase += pick(GLOB.adjectives)
					if(3)
						code_phrase += pick(GLOB.verbs)
		if(words==1)
			code_phrase += "."
		else
			code_phrase += ", "

	return code_phrase
/*
	MODULAR ANTAGONIST SYSTEM

	Attempts to move all the bullshit snowflake antag tracking code into its own system, which
	has the added bonus of making the display procs consistent. Still needs work/adjustment/cleanup
	but should be fairly self-explanatory with a review of the procs. Will supply a few examples
	of common tasks that the system will be expected to perform below. ~Z

	To use:
		- Get the appropriate datum via get_antag_data("antagonist id")
			using the id var of the desired /datum/antagonist ie. var/datum/antagonist/A = get_antag_data("traitor")
		- Call add_antagonist() on the desired target mind ie. A.add_antagonist(mob.mind)
		- To ignore protected roles, supply a positive second argument.
		- To skip equipping with appropriate gear, supply a positive third argument.
*/

/datum/controller/subsystem/antag_job/proc/get_antag_data(antag_type)
	return all_antag_types[antag_type]

/datum/controller/subsystem/antag_job/proc/clear_antag_roles(datum/mind/player, implanted)
	for(var/antag_type, value in all_antag_types)
		var/datum/antagonist/antag = value
		if(!implanted || !(antag.flags & ANTAG_IMPLANT_IMMUNE))
			antag.remove_antagonist(player, 1, implanted)

/datum/controller/subsystem/antag_job/proc/update_antag_icons(datum/mind/player)
	for(var/antag_type, value in all_antag_types)
		var/datum/antagonist/antag = value
		if(player)
			antag.update_icons_removed(player)
			if(antag.is_antagonist(player))
				antag.update_icons_added(player)
		else
			antag.update_all_icons()

/datum/controller/subsystem/antag_job/proc/populate_antag_type_list()
	for(var/antag_type in subtypesof(/datum/antagonist))
		var/datum/antagonist/antag_daturn = new antag_type
		all_antag_types[antag_daturn.id] = antag_daturn
		all_antag_spawnpoints[antag_daturn.landmark_id] = list()
		antag_names_to_ids[antag_daturn.role_text] = antag_daturn.id

/datum/controller/subsystem/antag_job/proc/get_antags(atype)
	var/datum/antagonist/antag = all_antag_types[atype]
	if(antag && islist(antag.current_antagonists))
		return antag.current_antagonists
	return list()

/datum/controller/subsystem/antag_job/proc/player_is_antag(datum/mind/player, only_offstation_roles = FALSE)
	for(var/antag_type, value in all_antag_types)
		var/datum/antagonist/antag = value
		if(only_offstation_roles && !(antag.flags & ANTAG_OVERRIDE_JOB))
			continue
		if(player in antag.current_antagonists)
			return TRUE
		if(player in antag.pending_antagonists)
			return TRUE
	return FALSE
