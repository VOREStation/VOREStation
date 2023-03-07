/*
Readme at code\modules\awaymissions\overmap_renamer\readme.md
*/

SUBSYSTEM_DEF(overmap_renamer)
	name = "Rename Overmap Locations"
	init_order = INIT_ORDER_MAPRENAME //Loaded very late in initializations. Must come before mapping and objs. Uses both as inputs.
	runlevels = RUNLEVEL_INIT
	flags = SS_NO_FIRE



/datum/controller/subsystem/overmap_renamer/Initialize(timeofday)
	update_names()

	..()

/*Shouldn't be a switch statement. We want ALL of the if(map_template.name in visitable_z_leves_name_list) to fire
if we end up with multiple renamable lateload overmap objects.*/
/datum/controller/subsystem/overmap_renamer/proc/update_names()
	if(!visitable_overmap_object_instances || !islist(visitable_overmap_object_instances) || !length(visitable_overmap_object_instances))
		return
	for(var/obj/effect/overmap/visitable/V in visitable_overmap_object_instances)
		if(V.unique_identifier == "Debris Field")
			V.modify_descriptors()
			if(V.visitable_renamed) //could just if(D.modify_descriptors()), but having a var recording renaming is useful for debugging and stuff!
				if(V.known)
					to_world_log("##Overmap Renamer: Renamed Debris Field as: [V.name]")
					admin_notice("<span class='danger'>Debris Field name chosen as [V.name]</span>", R_DEBUG)
				else
					to_world_log("##Overmap Renamer: Renamed Debris Field as: [V.real_name]")
					admin_notice("<span class='danger'>Debris Field name chosen as [V.real_name]</span>", R_DEBUG)
