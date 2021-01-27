#define PING_BUFFER_TIME 25

SUBSYSTEM_DEF(ping)
	name = "Ping"
	wait = 6
	flags = SS_NO_INIT|SS_POST_FIRE_TIMING
	priority = FIRE_PRIORITY_PING
	init_order = INIT_ORDER_PING
	runlevels = RUNLEVEL_LOBBY|RUNLEVEL_SETUP|RUNLEVEL_GAME|RUNLEVEL_POSTGAME
	var/list/currentrun

/datum/controller/subsystem/ping/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = GLOB.clients.Copy()

	var/list/currentrun = src.currentrun
	while (length(currentrun))
		var/client/C = currentrun[currentrun.len]
		currentrun.len--
		if (!C || world.time - C.connection_time < PING_BUFFER_TIME)
			if (MC_TICK_CHECK)
				return
			continue
		winset(C, null, "command=.update_ping+[world.time+world.tick_lag*world.tick_usage/100]")
		if (MC_TICK_CHECK) //one day, when ss13 has 1000 people per server, you guys are gonna be glad I added this tick check
			return

	currentrun = null

#undef PING_BUFFER_TIME