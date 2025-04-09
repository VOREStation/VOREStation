/datum/unit_test/all_items_must_have_an_icon_and_state
	name = "ITEMS: All items must have a valid default icon and icon_state" // for icon forge

/datum/unit_test/all_items_must_have_an_icon_and_state/start_test()
	var/failed = FALSE

	var/list/ty = subtypesof(/obj/item)
	var/tenths = 1
	var/a_tenth = ty.len / 10

	var/i = 0
	for(var/x in ty)
		if(i >= tenths * a_tenth)
			log_unit_test("Items - [tenths * 10]% [i]/[ty.len].")
			log_unit_test("------------------------------------")
			tenths++
		i++

		var/icon = initial(x:icon)
		var/state = initial(x:icon_state)
		if(!icon)
			log_unit_test("[x]: Items - Item was missing a default icon dmi.")
			failed = TRUE
			continue
		if(!state)
			log_unit_test("[x]: Items - Item was missing a default icon_state.")
			failed = TRUE
			continue
		if(!(state in cached_icon_states(icon)))
			log_unit_test("[x]: Items - Item icon_state \"[state]\" was not present in dmi \"[icon]\".")
			failed = TRUE

	if(failed)
		fail("Some items have missing icon_states in their icon dmi.")
	else
		pass("All items have a valid icon_state in their dmi.")

	return TRUE
