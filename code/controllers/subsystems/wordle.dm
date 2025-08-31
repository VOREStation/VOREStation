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
	var/list/l = world.file2list("strings/wordle.txt")
	target_word = pick(l)
	l = null
	return SS_INIT_SUCCESS

/datum/controller/subsystem/nerdle/proc/report_winner_or_loser(var/guesses)
	guesses = clamp(guesses,1,7)
	player_attempts[guesses] = player_attempts[guesses]+1
	total_players ++
