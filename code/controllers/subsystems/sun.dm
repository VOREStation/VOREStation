SUBSYSTEM_DEF(sun)
	name = "Sun"
	wait = 600
	flags = SS_NO_INIT
	var/static/datum/sun/sun = new

/datum/controller/subsystem/sun/fire(resumed)
	if(!resumed)
		sun.calc_position()
