/// Player tips procs and lists are defined under /code/modules/player_tips_vr
SUBSYSTEM_DEF(player_tips)
	name = "Periodic Player Tips"
	priority = FIRE_PRIORITY_PLAYERTIPS
	runlevels = RUNLEVEL_GAME
	wait = 3000 //We check if it's time to send a tip every 5 minutes (300 seconds)
	flags = SS_NO_INIT

	var/static/datum/player_tips/player_tips = new
	var/list/current_run = list()

/datum/controller/subsystem/player_tips/fire(resumed)
	if(!resumed)
		if(!player_tips.check_next_tip())
			return
		player_tips.set_current_tip()
		current_run = GLOB.player_list.Copy()

	for(var/mob/target_mob in current_run)
		current_run -= target_mob
		player_tips.send_tip(target_mob)
		if(MC_TICK_CHECK)
			return
