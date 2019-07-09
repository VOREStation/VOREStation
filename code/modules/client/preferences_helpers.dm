// Moved into the preference datum, to be more accessible to things outside of character setup.

// Checks in a really hacky way if a character's preferences say they are an FBP or not.
/datum/preferences/proc/is_FBP()
	if(organ_data && organ_data[BP_TORSO] != "cyborg")
		return FALSE
	return TRUE

// Returns what kind of FBP the player's prefs are. Returns 0 if they're not an FBP.
/datum/preferences/proc/get_FBP_type()
	if(!is_FBP())
		return FALSE // Not a robot.
	if(O_BRAIN in organ_data)
		switch(organ_data[O_BRAIN])
			if("assisted")
				return PREF_FBP_CYBORG
			if("mechanical")
				return PREF_FBP_POSI
			if("digital")
				return PREF_FBP_SOFTWARE
	return 0 // Something went wrong!
