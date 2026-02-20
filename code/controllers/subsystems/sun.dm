SUBSYSTEM_DEF(sun)
	name = "Sun"
	wait = 600
	flags = SS_NO_INIT
	var/static/datum/sun/sun = new
	var/list/current_run

/datum/controller/subsystem/sun/fire(resumed)
	if(!resumed)
		current_run = GLOB.solars_list.Copy()
		sun.calc_position()

	//now tell the solar control computers to update their status and linked devices
	while(length(current_run))
		var/obj/machinery/power/solar_control/SC = current_run[length(current_run)]
		current_run.len--
		if(!SC.powernet)
			GLOB.solars_list.Remove(SC)
			continue
		SC.update()
		if(MC_TICK_CHECK)
			return
