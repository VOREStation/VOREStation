PROCESSING_SUBSYSTEM_DEF(turfs)
	name = "Turf Processing"
	wait = 20
	flags = SS_NO_INIT

/datum/controller/subsystem/processing/turfs/Recover()
	log_debug("[name] subsystem Recover().")
	if(SSturfs.current_thing)
		log_debug("current_thing was: (\ref[SSturfs.current_thing])[SSturfs.current_thing]([SSturfs.current_thing.type]) - currentrun: [SSturfs.currentrun.len] vs total: [SSturfs.processing.len]")
	var/list/old_processing = SSturfs.processing.Copy()
	for(var/datum/D in old_processing)
		if(!isturf(D))
			log_debug("[name] subsystem Recover() found inappropriate item in list: [D.type]")
		if(CHECK_BITFIELD(D.datum_flags, DF_ISPROCESSING))
			processing |= D
