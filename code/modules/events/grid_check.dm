/datum/event/grid_check	//NOTE: Times are measured in master controller ticks!
	announceWhen		= 5
/*
/datum/event/grid_check/setup()
	endWhen = rand(30,120)
*/
/datum/event/grid_check/start()
	// This sets off a chain of events that lead to the actual grid check (or perhaps worse).
	// First, the Supermatter engine makes a power spike.
	for(var/obj/machinery/power/generator/engine in machines)
		engine.power_spike()
		break // Just one engine, please.
	// After that, the engine checks if a grid checker exists on the same powernet, and if so, it triggers a blackout.
	// If not, lots of stuff breaks.  See code/modules/power/generator.dm for that piece of code.
//	power_failure(0)
/*
/datum/event/grid_check/announce()
	if (prob(30))
		command_announcement.Announce("Abnormal activity detected in [station_name()]'s powernet. As a precautionary measure, the station's power will be shut off for an indeterminate duration.", "Automated Grid Check", new_sound = 'sound/AI/poweroff.ogg')

/datum/event/grid_check/end()
	power_restore()
*/