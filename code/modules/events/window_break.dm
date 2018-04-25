/datum/event/window_break
	var/obj/structure/window/chosen_window
	var/list/obj/structure/window/collateral_windows
	var/turf/chosen_location
	var/list/area/excluded = list(
		/area/shuttle,
		/area/crew_quarters
	)

/datum/event/window_break/setup()
	var/list/area/grand_list_of_areas = get_station_areas(excluded)
	//try 10 times
	for(var/i in 1 to 10)
		var/area/A = pick(grand_list_of_areas)
		var/list/obj/structure/window/possible_target_windows = list()
		for(var/obj/structure/window/target_window in A.contents)
			possible_target_windows += target_window
		possible_target_windows = shuffle(possible_target_windows)

		for(var/obj/structure/window/target_window in possible_target_windows)
			//if() don't have any conditions, for isn't strictly necessary
			chosen_window = target_window
			chosen_location = chosen_window.loc
			collateral_windows = gather_collateral_windows(chosen_window)
			announceWhen = (collateral_windows.len + 1) * 20
			endWhen = announceWhen + 1
			return

//TL;DR: breadth first search for all connected turfs with windows
/datum/event/window_break/proc/gather_collateral_windows(var/obj/structure/window/target_window)
	var/list/turf/frontier_set = list(target_window.loc)
	var/list/obj/structure/window/result_set = list()
	var/list/turf/explored_set = list()

	while(frontier_set.len > 0)
		var/turf/current = frontier_set[1]
		frontier_set -= current
		explored_set += current

		var/contains_windows = 0
		for(var/obj/structure/window/to_add in current.contents)
			contains_windows = 1
			result_set += to_add

		if(contains_windows)
			//add adjacent turfs to be checked for windows as well
			var/turf/neighbor = locate(current.x + 1, current.y, current.z)
			if(!(neighbor in frontier_set) && !(neighbor in explored_set))
				frontier_set += neighbor
			neighbor = locate(current.x - 1, current.y, current.z)
			if(!(neighbor in frontier_set) && !(neighbor in explored_set))
				frontier_set += neighbor
			neighbor = locate(current.x, current.y + 1, current.z)
			if(!(neighbor in frontier_set) && !(neighbor in explored_set))
				frontier_set += neighbor
			neighbor = locate(current.x, current.y - 1, current.z)
			if(!(neighbor in frontier_set) && !(neighbor in explored_set))
				frontier_set += neighbor
	return result_set
	


/datum/event/window_break/start()
	if(!chosen_window)
		return
	chosen_window.shatter(0)

	for(var/obj/structure/window/current_collateral in collateral_windows)
		sleep(rand(1,20))
		current_collateral.take_damage(current_collateral.health - (current_collateral.maxhealth / 5)) //set to 1/5th health

/datum/event/window_break/announce()
	command_announcement.Announce("Structural integrity of windows at [chosen_location.loc.name] is failing. Immediate repair or replacement is advised.", "Structural Alert")
