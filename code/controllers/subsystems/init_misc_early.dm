SUBSYSTEM_DEF(init_misc_early)
	name = "Early Misc Initialization"
	init_order = INIT_ORDER_MISC_EARLY
	flags = SS_NO_FIRE


/datum/controller/subsystem/init_misc_early/Initialize(timeofday)
	plant_controller = new
	setupgenetics()
