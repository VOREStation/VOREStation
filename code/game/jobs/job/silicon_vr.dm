/datum/job/ai
	disallow_jobhop = TRUE
	pto_type = PTO_CIVILIAN

/datum/job/cyborg
	pto_type = PTO_CYBORG
	minimal_player_age = 3		//1 day is a little too little time
	total_positions = 4 		//Along with one able to spawn later in the round.
	spawn_positions = 3 		//Let's have 3 able to spawn in roundstart