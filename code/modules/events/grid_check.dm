/datum/event/grid_check

/datum/event/grid_check/start()
	// This sets off a chain of events that lead to the actual grid check (or perhaps worse).
	// First, the Supermatter engine makes a power spike.
	for(var/obj/machinery/power/generator/engine in machines)
		engine.power_spike(80)
		break // Just one engine, please.
	// After that, the engine checks if a grid checker exists on the same powernet, and if so, it triggers a blackout.
	// If not, lots of stuff breaks.  See code/modules/power/generator.dm for that piece of code.
