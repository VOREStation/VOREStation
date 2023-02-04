/proc/fix_player_notes_listing()
	var/list/has_notes = list()
	// flist() dir names include the /
	for(var/subdir in flist("data/player_saves/"))
		for(var/ckey in flist("data/player_saves/[subdir]"))
			if(fexists("data/player_saves/[subdir][ckey]info.sav"))
				has_notes += copytext(ckey, 1, -1) // Trim the tailing /

	//Updating list of keys with notes on them
	var/savefile/note_list = new("data/player_notes.sav")
	var/list/note_keys
	note_list >> note_keys
	if(!note_keys) note_keys = list()
	note_keys |= has_notes
	note_list << note_keys
	del(note_list) // savefile, so NOT qdel
