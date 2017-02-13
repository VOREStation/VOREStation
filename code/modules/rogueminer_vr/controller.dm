//////////////////////////////
// Tracks mining zone progress and decay
// Makes mining zones more difficult as you enter new ones
// THIS IS THE FIRST UNIT INITIALIZED THAT STARTS EVERYTHING
//////////////////////////////
var/datum/controller/rogue/rm_controller = new()

/datum/controller/rogue
	var/list/datum/rogue/zonemaster/all_zones = list()

	var/difficulty = RM_STARTING_DIFF

	//The current mining zone that the shuttle goes to and whatnot
	var/area/current

/datum/controller/rogue/New()
	//How many zones are we working with here
	for(var/area/asteroid/rogue/A in world)
		all_zones += new /datum/rogue/zonemaster(A)

/datum/controller/rogue/proc/decay(var/manual = 0)
	difficulty = max(difficulty-RM_DIFF_DECAY_AMT,RM_STARTING_DIFF)
	if(!manual) //If it was called manually somehow, then don't start the timer, just decay now.
		spawn(RM_DIFF_DECAY_TIME)
			decay()
	return difficulty