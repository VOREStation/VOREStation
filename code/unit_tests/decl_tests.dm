/datum/unit_test/emotes_shall_have_unique_keys
	name = "DECLS: Emotes Shall Have Unique Keys"

/datum/unit_test/emotes_shall_have_unique_keys/start_test()

	var/list/keys = list()
	var/list/duplicates = list()

	var/list/all_emotes = decls_repository.get_decls_of_subtype(/decl/emote)
	for(var/etype in all_emotes)
		var/decl/emote/emote = all_emotes[etype]
		if(!emote.key)
			continue
		if(emote.key in keys)
			if(!duplicates[emote.key])
				duplicates[emote.key] = list()
			duplicates[emote.key] += etype
		else
			keys += emote.key

	if(length(duplicates))
		fail("[length(duplicates)] emote\s had overlapping keys: [english_list(duplicates)].")
	else
		pass("All emotes had unique keys.")

	return TRUE
