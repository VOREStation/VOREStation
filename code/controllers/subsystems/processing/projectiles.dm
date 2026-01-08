PROCESSING_SUBSYSTEM_DEF(projectiles)
	name = "Projectiles"
	wait = 1
	stat_tag = "PP"
	priority = FIRE_PRIORITY_PROJECTILES
	flags = SS_NO_INIT|SS_TICKER
	var/global_max_tick_moves = 10
	var/global_pixel_speed = 2
	var/global_iterations_per_move = 16

/datum/controller/subsystem/processing/projectiles/Recover()
	log_runtime("[name] subsystem Recover().")
	if(SSprojectiles.current_thing)
		log_runtime("current_thing was: (\ref[SSprojectiles.current_thing])[SSprojectiles.current_thing]([SSprojectiles.current_thing.type]) - currentrun: [length(SSprojectiles.currentrun)] vs total: [length(SSprojectiles.processing)]")
	var/list/old_processing = SSprojectiles.processing.Copy()
	for(var/datum/D in old_processing)
		if(CHECK_BITFIELD(D.datum_flags, DF_ISPROCESSING))
			processing |= D

/datum/controller/subsystem/processing/projectiles/proc/set_pixel_speed(new_speed)
	global_pixel_speed = new_speed
	for(var/obj/item/projectile/P as anything in processing)
		if(istype(P))			//there's non projectiles on this too.
			P.set_pixel_speed(new_speed)
