//
// Floor Decals Initialization Subsystem
// This is part of the giant decal hack that works around a BYOND bug where DreamDaemon will crash if you
// update overlays on turfs too much.
// The master_controller on Polaris used to init decals prior to initializing areas (which initilized turfs)
// Now that we switched to subsystems we still want to do the same thing, so this takes care of it.
//
SUBSYSTEM_DEF(floor_decals)
	name = "Floor Decals"
	init_order = INIT_ORDER_DECALS
	flags = SS_NO_FIRE

/datum/controller/subsystem/floor_decals/Initialize(timeofday)
	if(floor_decals_initialized)
		return ..()
	to_world_log("Initializing Floor Decals")
	admin_notice("<span class='danger'>Initializing Floor Decals</span>", R_DEBUG)
	var/list/turfs_with_decals = list()
	for(var/obj/effect/floor_decal/D in world)
		var/T = D.add_to_turf_decals()
		if(T) turfs_with_decals |= T
		CHECK_TICK
	for(var/item in turfs_with_decals)
		var/turf/T = item
		if(T.decals) T.apply_decals()
		CHECK_TICK
	floor_decals_initialized = TRUE
	return ..()
