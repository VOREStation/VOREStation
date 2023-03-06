//General procs and landmark definition for the overmap_renamer subsystem


/*
Called by the code\controllers\subsystems\overmap_renamer_vr.dm subsystem if an area was set to be renamed.
possible_descriptors are populated by subtypes of /obj/effect/landmark/overmap_renamer
*/
/obj/effect/overmap/visitable/proc/modify_descriptors()
	if(!possible_descriptors || !islist(possible_descriptors) || possible_descriptors == list() || !length(possible_descriptors))
		error("List of possible descriptors for [name] was empty!")
		return

	var/list/chosen_descriptor = pick(possible_descriptors)
	if(chosen_descriptor == "default")
		return   //Not an error, won't generate an error message
	var/breakWhile = 0
	while(LAZYLEN(chosen_descriptor) != 3)
		LAZYREMOVE(chosen_descriptor, possible_descriptors)
		chosen_descriptor = pick(possible_descriptors)
		if(chosen_descriptor == "default")
			return
		if(breakWhile > 10 || length(possible_descriptors) < 1)
			error("No valid descriptors could be found for [name]!") //Checking default separately for sake of error messages
			return

	//Using real_name to ensure get_scan_data() does not override the renamed code
	//Since we're doing this on runtime rather than compile time.
	if(!known)
		real_name = chosen_descriptor[1]
		real_desc = chosen_descriptor[2]
	else
		name = chosen_descriptor[1]
		desc = chosen_descriptor[2]
	scanner_desc = chosen_descriptor[3]
	visitable_renamed = TRUE


/obj/effect/landmark/overmap_renamer
	name = "Helper to rename overmap locations"
	desc = "Use subtypes for each overmap location! Fill in name with the POI's clearly identifiable name for error handling."
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	var/list/descriptors = list() //Elements: A = name, B = desc C = scanner desc. Each element must be a string

/obj/effect/landmark/overmap_renamer/Initialize()
//	testing("Loading renamer landmark: [name]") //Uncomment when adding a new POI/Landmark for testing aid.
	if(LAZYLEN(descriptors) != 3)
		error("POI [name] renamer landmark is invalid! Make sure its descriptors var is a list of 3 elements!")
		return
	if(!istext(descriptors[1]) || !istext(descriptors[2]) || !istext(descriptors[3]))
		error("POI [name] renamer landmark is invalid! One of the elements is NOT a string!")
		return
	. = ..()
