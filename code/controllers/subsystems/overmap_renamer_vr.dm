/*
Readme at code\modules\awaymissions\overmap_renamer\readme.md
*/

SUBSYSTEM_DEF(overmap_renamer)
	name = "Overmap Renamer"
	//Loaded very late in initializations. Must come before mapping and objs. Uses both as inputs.
	init_stage = INITSTAGE_LAST
	dependencies = list(
		/datum/controller/subsystem/atoms
	)
	runlevels = RUNLEVEL_SETUP
	flags = SS_NO_FIRE



/datum/controller/subsystem/overmap_renamer/Initialize()
	update_names()
	return SS_INIT_SUCCESS

/*Shouldn't be a switch statement. We want ALL of the if(map_template.name in visitable_z_leves_name_list) to fire
if we end up with multiple renamable lateload overmap objects.*/
/datum/controller/subsystem/overmap_renamer/proc/update_names()
	if(!GLOB.visitable_overmap_object_instances || !islist(GLOB.visitable_overmap_object_instances) || !length(GLOB.visitable_overmap_object_instances))
		return
	for(var/obj/effect/overmap/visitable/V in GLOB.visitable_overmap_object_instances)
		if(V.unique_identifier == "Debris Field")
			V.modify_descriptors()
			if(V.visitable_renamed) //could just if(D.modify_descriptors()), but having a var recording renaming is useful for debugging and stuff!
				if(V.known)
					log_mapping("##Overmap Renamer: Renamed Debris Field as: [V.name]")
					admin_notice(span_danger("Debris Field name chosen as [V.name]"), R_DEBUG)
				else
					log_mapping("##Overmap Renamer: Renamed Debris Field as: [V.real_name]")
					admin_notice(span_danger("Debris Field name chosen as [V.real_name]"), R_DEBUG)
