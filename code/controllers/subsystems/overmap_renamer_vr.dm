/*
Readme at code\modules\awaymissions\overmap_renamer\readme.md
*/

SUBSYSTEM_DEF(overmap_renamer)
	name = "Rename Overmap Locations"
	init_order = INIT_ORDER_MAPRENAME //Loaded very late in initializations. Must come before mapping and objs. Uses both as inputs.
	runlevels = RUNLEVEL_INIT
	flags = SS_NO_FIRE



/datum/controller/subsystem/overmap_renamer/Initialize(timeofday)
	if(!visitable_Z_levels_name_list)
		return
	update_names()

	..()

/*Shouldn't be a switch statement. We want ALL of the if(map_template.name in visitable_z_leves_name_list) to fire
if we end up with multiple renamable lateload overmap objects.*/
/datum/controller/subsystem/overmap_renamer/proc/update_names()
	if(!visitable_Z_levels_name_list || !islist(visitable_Z_levels_name_list) || !length(visitable_Z_levels_name_list))
		return
	if("Debris Field - Z1 Space" in visitable_Z_levels_name_list)
		for(var/obj/effect/overmap/visitable/D in visitable_overmap_object_instances)
			if(D.unique_identifier == "Debris Field")
				D.modify_descriptors()
				if(D.visitable_renamed) //could just if(D.modify_descriptors()), but having a var recording renaming is useful for debugging and stuff!
					if(D.known)
						to_world_log("Renamed Debris Field as: [D.name]")
						admin_notice("<span class='danger'>Debris Field name chosen as [D.name]</span>", R_DEBUG)
					else
						to_world_log("Renamed Debris Field as: [D.real_name]")
						admin_notice("<span class='danger'>Debris Field name chosen as [D.real_name]</span>", R_DEBUG)
