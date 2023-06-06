SUBSYSTEM_DEF(sun)
	name = "Sun"
	wait = 1 MINUTES

	var/static/datum/sun/sun = new

/datum/controller/subsystem/sun/fire()
	sun.calc_position()
