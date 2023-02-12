/*
Player tips procs and lists are defined under /code/modules/player_tips_vr
*/
SUBSYSTEM_DEF(player_tips)
	name = "Periodic Player Tips"
	priority = FIRE_PRIORITY_PLAYERTIPS
	runlevels = RUNLEVEL_GAME

	wait = 3000 //We check if it's time to send a tip every 5 minutes (300 seconds)
	var/static/datum/player_tips/player_tips = new




/datum/controller/subsystem/player_tips/fire()
	player_tips.send_tips()
