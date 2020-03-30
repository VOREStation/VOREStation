PROCESSING_SUBSYSTEM_DEF(obj)
	name = "Objects"
	priority = FIRE_PRIORITY_OBJ
	flags = SS_NO_INIT
	wait = 20

/datum/controller/subsystem/processing/obj/Recover()
	log_debug("[name] subsystem Recover(). current_thing was: (\ref[SSobj.current_thing])[SSobj.current_thing]([SSobj.current_thing.type]) - currentrun: [SSobj.currentrun.len] vs total: [SSobj.processing.len]")
	var/list/old_processing = SSobj.processing.Copy()
	for(var/datum/D in old_processing)
		if(CHECK_BITFIELD(D.datum_flags, DF_ISPROCESSING))
			processing |= D