SUBSYSTEM_DEF(solars)
	name = "Solars"
	priority = FIRE_PRIORITY_SOLARS
	wait = 1 MINUTE
	flags = SS_NO_INIT
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	dependencies = list(
		/datum/controller/subsystem/planets,
		/datum/controller/subsystem/sun
	)

	// List of solar controllers that need to be prepared for the second half of processing
	var/list/current_run

	// Each list has a key of its controller, for each subrun of the subsystem
	var/list/controller_run = list()
	var/list/panel_run = list()
	var/list/panel_sum = list()

/datum/controller/subsystem/solars/fire(resumed)
	if(!resumed)
		// Get the list of controllers we need to process
		current_run = GLOB.solars_list.Copy()
		// Clear secondary process lists so they're fresh for the impending run ahead
		controller_run.Cut()
		panel_run.Cut()
		panel_sum.Cut()

	////////////////////////////////////////////////////////////////////////////////
	// First processing cycle collects the controllers we'll be processing
	////////////////////////////////////////////////////////////////////////////////
	while(length(current_run))
		var/obj/machinery/power/solar_control/SC = current_run[length(current_run)]
		current_run.len--

		// Controllers with no network are ignored
		if(!SC.powernet)
			GLOB.solars_list.Remove(SC)
			if(MC_TICK_CHECK)
				return
			continue

		// Update the controller and prepare each of the solar array lists it needs
		SC.update()
		controller_run[REF(SC)] = WEAKREF(SC)
		panel_run[REF(SC)] = SC.get_connected_panels().Copy()
		panel_sum[REF(SC)] = 0

		if(MC_TICK_CHECK)
			return

	////////////////////////////////////////////////////////////////////////////////
	// Second processing cycle handles all of the panels for each controller!
	////////////////////////////////////////////////////////////////////////////////
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
			handling_panels.len--

			if(MC_TICK_CHECK)
				return

		// Update the controller
		SC.connected_power = panel_sum[conkey]
		SC.update_icon()
		controller_run.len--

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/solars/proc/get_solar_angle(turf/our_t)
	if(!our_t || our_t.z > length(SSplanets.z_to_planet) || !SSplanets.z_to_planet[our_t.z])
		return SSsun.sun.angle // standard in space solar panels use the global SSsun angle

	// On planets, use the daynight cycle
	var/datum/planet/our_planet = SSplanets.z_to_planet[our_t.z]
	return our_planet.get_sun_solar_position()
