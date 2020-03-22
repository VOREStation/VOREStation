// New grid check event:
// Very similar to the old one, power goes out in most of the colony, however the new feature is the ability for engineering to
// get power back on sooner, if they are able to reach a special machine and initiate a manual reboot.  If no one is able to do so,
// it will reboot itself after a few minutes, just like the old one.  Bad things happen if there is no grid checker machine protecting
// the powernet when this event fires.

/datum/gm_action/grid_check
	name = "grid check"
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_EVERYONE)
	chaotic = 20

/datum/gm_action/grid_check/get_weight()
	return 50 + (metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 30)

/datum/gm_action/grid_check/start()
	..()
	// This sets off a chain of events that lead to the actual grid check (or perhaps worse).
	// First, the Supermatter engine makes a power spike.
	for(var/obj/machinery/power/generator/engine in machines)
		engine.power_spike()
		break // Just one engine, please.
	// After that, the engine checks if a grid checker exists on the same powernet, and if so, it triggers a blackout.
	// If not, lots of stuff breaks.  See code/modules/power/generator.dm for that piece of code.