// Tell the game master that something dangerous happened, e.g. someone dying.
/datum/game_master/proc/adjust_danger(var/amt)
	amt = amt * danger_modifier
	danger = round( CLAMP(danger + amt, 0, 1000), 0.1)

// Tell the game master that something interesting happened.
/datum/game_master/proc/adjust_staleness(var/amt)
	amt = amt * staleness_modifier
	staleness = round( CLAMP(staleness + amt, -50, 200), 0.1)