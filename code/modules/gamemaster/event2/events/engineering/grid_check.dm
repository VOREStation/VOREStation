// New grid check event:
// Very similar to the old one, power goes out in most of the station, however the new feature is the ability for engineering to
// get power back on sooner, if they are able to reach a special machine and initiate a manual reboot.  If no one is able to do so,
// it will reboot itself after a few minutes, just like the old one.  Bad things happen if there is no grid checker machine protecting
// the powernet when this event fires.

/datum/event2/meta/grid_check
	name = "grid check"
	departments = list(DEPARTMENT_ENGINEERING, DEPARTMENT_EVERYONE)
	chaos = 10
	chaotic_threshold = EVENT_CHAOS_THRESHOLD_LOW_IMPACT
	reusable = TRUE
	event_type = /datum/event2/event/grid_check

// Having the turbines be way over their rated limit makes grid checks more likely.
/datum/event2/meta/grid_check/proc/get_overpower()
	var/highest_overpower = 0
	for(var/obj/machinery/power/generator/turbine as anything in GLOB.all_turbines)
		var/overpower = max((turbine.effective_gen / turbine.max_power) - 1, 0)
		if(overpower > highest_overpower)
			highest_overpower = overpower
	return highest_overpower

/datum/event2/meta/grid_check/get_weight()
	var/population_factor = metric.count_people_in_department(DEPARTMENT_ENGINEERING) * 10
	var/overpower_factor = 50 * get_overpower() // Will be 0 if not overloaded at all, and 50 if turbines are outputting twice as much as rated.
	return (20 + population_factor + overpower_factor) / (times_ran + 1)



/datum/event2/event/grid_check
	var/obj/machinery/power/generator/engine // The turbine that will send a power spike.

/datum/event2/event/grid_check/set_up()
	// Find the turbine being pushed the most.
	var/obj/machinery/power/generator/most_stressed_turbine = null
	for(var/obj/machinery/power/generator/turbine as anything in GLOB.all_turbines)
		if(!most_stressed_turbine)
			most_stressed_turbine = turbine
		else if(turbine.effective_gen > most_stressed_turbine.effective_gen)
			most_stressed_turbine = turbine
	engine = most_stressed_turbine

/datum/event2/event/grid_check/start()
	// This sets off a chain of events that lead to the actual grid check (or perhaps worse).
	// First, the Supermatter engine makes a power spike.
	if(engine)
		engine.power_spike()
	// After that, the engine checks if a grid checker exists on the same powernet, and if so, it triggers a blackout.
	// If not, lots of stuff breaks.  See code/modules/power/generator.dm for that piece of code.
