//Fires five times every second.

PROCESSING_SUBSYSTEM_DEF(fastprocess)
	name = "Fast Processing"
	wait = 0.2 SECONDS
	stat_tag = "FP"

/datum/controller/subsystem/processing/fastprocess/Recover()
	log_debug("[name] subsystem Recover().")
	if(SSfastprocess.current_thing)
		log_debug("current_thing was: (\ref[SSfastprocess.current_thing])[SSfastprocess.current_thing]([SSfastprocess.current_thing.type]) - currentrun: [SSfastprocess.currentrun.len] vs total: [SSfastprocess.processing.len]")
	var/list/old_processing = SSfastprocess.processing.Copy()
	for(var/datum/D in old_processing)
		if(CHECK_BITFIELD(D.datum_flags, DF_ISPROCESSING))
			processing |= D