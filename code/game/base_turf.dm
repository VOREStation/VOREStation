// Returns the lowest turf available on a given Z-level, defaults to asteroid for Polaris.

/proc/get_base_turf(var/z)
	if(!using_map.base_turf_by_z["[z]"])
		using_map.base_turf_by_z["[z]"] = /turf/space
	return using_map.base_turf_by_z["[z]"]

//An area can override the z-level base turf, so our solar array areas etc. can be space-based.
/proc/get_base_turf_by_area(var/turf/T)
	var/area/A = T.loc
	if(A.base_turf)
		return A.base_turf
	return get_base_turf(T.z)

/client/proc/set_base_turf()
	set category = "Debug"
	set name = "Set Base Turf"
	set desc = "Set the base turf for a z-level."

	if(!check_rights_for(src, R_HOLDER))	return

	var/choice = tgui_input_number(usr, "Which Z-level do you wish to set the base turf for?")
	if(!choice)
		return

	var/new_base_path = tgui_input_list(usr, "Please select a turf path (cancel to reset to /turf/space).", "Set Base Turf", typesof(/turf))
	if(!new_base_path)
		new_base_path = /turf/space
	using_map.base_turf_by_z["[choice]"] = new_base_path
	message_admins("[key_name_admin(usr)] has set the base turf for z-level [choice] to [get_base_turf(choice)].")
	log_admin("[key_name(usr)] has set the base turf for z-level [choice] to [get_base_turf(choice)].")
