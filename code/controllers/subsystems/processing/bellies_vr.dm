//
// Bellies subsystem - Process vore bellies
//

PROCESSING_SUBSYSTEM_DEF(bellies)
	name = "Bellies"
	wait = 6 SECONDS
	flags = SS_KEEP_TIMING|SS_NO_INIT
	runlevels = RUNLEVEL_GAME|RUNLEVEL_POSTGAME

/datum/controller/subsystem/processing/bellies/Recover()
	log_runtime("[name] subsystem Recover().")
	if(SSbellies.current_thing)
		log_runtime("current_thing was: (\ref[SSbellies.current_thing])[SSbellies.current_thing]([SSbellies.current_thing.type]) - currentrun: [length(SSbellies.currentrun)] vs total: [length(SSbellies.processing)]")
	var/list/old_processing = SSbellies.processing.Copy()
	for(var/datum/D in old_processing)
		if(!isbelly(D))
			log_runtime("[name] subsystem Recover() found inappropriate item in list: [D.type]")
		if(CHECK_BITFIELD(D.datum_flags, DF_ISPROCESSING))
			processing |= D
