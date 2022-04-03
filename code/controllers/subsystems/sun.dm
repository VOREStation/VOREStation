SUBSYSTEM_DEF(sun)
	name = "Sun"
	wait = 60 SECONDS
	var/static/datum/sun/sun = new

/datum/controller/subsystem/sun/fire(resumed, no_mc_tick)
	sun.calc_position()
