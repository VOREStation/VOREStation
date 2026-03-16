//KEEP THE STREAK ALIVE
SUBSYSTEM_DEF(nerdle)
	name = "nerdle"
	priority = FIRE_PRIORITY_APPRECIATE
	runlevels = RUNLEVEL_GAME
	flags = SS_BACKGROUND | SS_NO_FIRE
	var/target_word = "fuckd"

	var/list/player_attempts = list(0,0,0,0,0,0,0)//serialized, index = count of people who win/lose with that many guesses, 7 is for all the losers
	var/total_players = 0

/datum/controller/subsystem/nerdle/Initialize()
	var/list/l = world.file2list("strings/nerdle_dict.txt")
	target_word = pick(l)
	l = null
	return SS_INIT_SUCCESS

/datum/controller/subsystem/nerdle/proc/report_winner_or_loser(var/guesses, var/failure = FALSE)
	guesses = clamp(guesses,1,7)
	if(failure)
		guesses = 7 //fail

	player_attempts[guesses] = player_attempts[guesses]+1
	total_players ++

/datum/controller/subsystem/nerdle/can_vv_get(var_name) //the sancity of nerdle shall not be infringed by man or any of the gods above them.
	if(var_name == NAMEOF(src, target_word))
		return FALSE
	return ..()
