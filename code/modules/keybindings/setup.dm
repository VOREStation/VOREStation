// Set a client's focus to an object and override these procs on that object to let it handle keypresses

/datum/proc/key_down(key, client/user) // Called when a key is pressed down initially
	return
/datum/proc/key_up(key, client/user) // Called when a key is released
	return
/datum/proc/keyLoop(client/user) // Called once every server tick
	set waitfor = FALSE
	return

/// Set mob's focus 
/// TODO - Do we even need this concept?
/mob/proc/set_focus(datum/new_focus)
	if(focus == new_focus)
		return
	focus = new_focus

/// Turns a keys bitfield into text showing all bits set
/proc/keys2text(keys)
	if(!keys)
		return ""
	var/list/out = list()
	if(keys & NORTH_KEY) out += "NORTH"
	if(keys & SOUTH_KEY) out += "SOUTH"
	if(keys & EAST_KEY) out += "EAST"
	if(keys & WEST_KEY) out += "WEST"
	if(keys & W_KEY) out += "W"
	if(keys & A_KEY) out += "A"
	if(keys & S_KEY) out += "S"
	if(keys & D_KEY) out += "D"
	if(keys & CTRL_KEY) out += "CTRL"
	if(keys & SHIFT_KEY) out += "SHIFT"
	if(keys & ALT_KEY) out += "ALT"
	return out.Join(" ")
