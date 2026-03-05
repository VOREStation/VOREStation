SUBSYSTEM_DEF(solars)
	name = "Solars"
	priority = FIRE_PRIORITY_SOLARS
	wait = 20 SECONDS
	flags = SS_BACKGROUND
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	dependencies = list(
		/datum/controller/subsystem/planets,
		/datum/controller/subsystem/sun
	)
	var/list/current_run
	var/list/controller_run = list()
	var/list/panel_run = list() // This is a horror show! Contains multiple sublists, one for each controller
	var/list/panel_sum = list()

/datum/controller/subsystem/solars/Initialize()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/solars/fire(resumed)
	if(!resumed)
		controller_run.Cut()
		panel_run.Cut()
		panel_sum.Cut()
		current_run = GLOB.solars_list.Copy()

	//now tell the solar control computers to update their status and linked devices
	while(length(current_run))
		var/obj/machinery/power/solar_control/SC = current_run[length(current_run)]
		current_run.len--

		// Controllers with no network are ignored
		if(!SC.powernet)
			GLOB.solars_list.Remove(SC)
			continue

		// Update the controller and prepare each of the solar array lists it needs
		SC.update()
		controller_run[REF(SC)] = WEAKREF(SC)
		panel_run[REF(SC)] = SC.get_connected_panels().Copy()
		panel_sum[REF(SC)] = 0

		if(MC_TICK_CHECK)
			return

	// For all controllers remaining...
	while(length(controller_run))
		var/conkey = controller_run[length(controller_run)]
		var/datum/weakref/conref= controller_run[conkey]

		// Check if the controller still exists
		var/obj/machinery/power/solar_control/SC = conref?.resolve()
		if(!SC)
			controller_run -= conkey
			if(MC_TICK_CHECK)
				return
			continue

		// Handle all solar panels for this controller.
		var/list/handling_panels = panel_run[conkey]
		while(length(handling_panels))
			var/obj/machinery/power/solar/S = handling_panels[length(handling_panels)]
			panel_sum[conkey] += S.update_power_generation(SC)

			if(MC_TICK_CHECK)
				return

		// Update the controller
		SC.connected_power = panel_sum[conkey]
		SC.update_icon()
		controller_run -= conkey
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/solars/proc/get_angle(obj/machinery/power/solar_control/controller)
	var/turf/our_t = get_turf(controller)
	if(!our_t || !("[our_t.z]" in SSplanets.z_to_planet))
		return SSsun.sun.angle // standard in space solar panels use the global SSsun angle

	// On planets, use the daynight cycle
	var/datum/planet/our_planet = SSplanets.z_to_planet["[our_t.z]"]
	return SSsun.sun.angle // TODO - Use the planet's sun angle...
