/obj/item/integrated_circuit/smart
	category_text = "Smart"

/obj/item/integrated_circuit/smart/basic_pathfinder
	name = "basic pathfinder"
	desc = "This complex circuit is able to determine what direction a given target is."
	extended_desc = "This circuit uses a miniturized, integrated camera to determine where the target is.  If the machine \
	cannot see the target, it will not be able to calculate the correct direction."
	icon_state = "numberpad"
	complexity = 25
	inputs = list("target" = IC_PINTYPE_REF)
	outputs = list("dir" = IC_PINTYPE_DIR)
	activators = list("calculate dir" = IC_PINTYPE_PULSE_IN, "on calculated" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 4, TECH_DATA = 5)
	power_draw_per_use = 40

/obj/item/integrated_circuit/smart/basic_pathfinder/do_work()
	var/datum/integrated_io/I = inputs[1]
	set_pin_data(IC_OUTPUT, 1, null)

	if(!isweakref(I.data))
		return
	var/atom/A = I.data.resolve()
	if(!A)
		return
	if(!(A in view(get_turf(src))))
		push_data()
		return // Can't see the target.
	var/desired_dir = get_dir(get_turf(src), get_turf(A))

	set_pin_data(IC_OUTPUT, 1, desired_dir)
	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/smart/targeted_pathfinder
	name = "targeted pathfinder"
	desc = "Finds the best direction to a target using advanced pathfinding, when pulsed."
	extended_desc = "This circuit uses a miniturized, integrated camera and advanced pathfinding to determine the best direction to a target, when pulsed."
	icon_state = "numberpad"
	complexity = 25
	inputs = list(
		"target" = IC_PINTYPE_REF
	)
	outputs = list(
		"dir" = IC_PINTYPE_DIR
	)
	activators = list(
		"calculate dir" = IC_PINTYPE_PULSE_IN,
		"on calculated" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 4, TECH_DATA = 5)
	power_draw_per_use = 40

/obj/item/integrated_circuit/smart/targeted_pathfinder
	var/turf/last_known_position = null
	var/datum/weakref/last_target = null

/obj/item/integrated_circuit/smart/targeted_pathfinder/do_work()
	var/datum/integrated_io/I = inputs[1]
	set_pin_data(IC_OUTPUT, 1, null)

	if(!istype(I.data, /datum/weakref) || I.data != last_target)
		last_known_position = null
		last_target = I.data

	if(!isweakref(I.data))
		push_data()
		activate_pin(2)
		return

	var/atom/A = I.data.resolve()
	if(!A)
		push_data()
		activate_pin(2)
		return

	var/turf/start = get_turf(src)
	var/turf/goal = get_turf(A)
	if(!start || !goal)
		push_data()
		activate_pin(2)
		return

	if(A in view(start))
		last_known_position = goal

	// If target not visible but we have last known position, use that instead
	if(!(A in view(start)))
		if(!last_known_position)
			push_data()
			activate_pin(2)
			return
		goal = last_known_position
	var/list/path = AStar(start, goal, /turf/proc/AdjacentTurfsWithAccess, /turf/proc/Distance, 0, 30, id = assembly)
	if(path && path.len > 1)
		var/turf/next = path[2] // path[1] is current location
		var/desired_dir = get_dir(start, next)
		set_pin_data(IC_OUTPUT, 1, desired_dir)
	else
		// Fallback if pathfinding fails
		var/desired_dir = get_dir(start, goal)
		set_pin_data(IC_OUTPUT, 1, desired_dir)

	push_data()
	activate_pin(2)

/obj/item/integrated_circuit/smart/pathfinding_locomotion
	name = "pathfinding locomotion controller"
	desc = "A specialized circuit that uses pathfinding to move towards a target when pulsed."
	extended_desc = "This circuit will calculate a path to the target and move one step along that path each time it's pulsed."
	icon_state = "numberpad"
	complexity = 40
	inputs = list(
		"target" = IC_PINTYPE_REF
	)
	outputs = list(
		"current direction" = IC_PINTYPE_DIR,
		"distance to target" = IC_PINTYPE_NUMBER
	)
	activators = list(
		"step toward target" = IC_PINTYPE_PULSE_IN,
		"on successful move" = IC_PINTYPE_PULSE_OUT,
		"on failed move" = IC_PINTYPE_PULSE_OUT
	)
	spawn_flags = IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 5, TECH_DATA = 5)
	power_draw_per_use = 60
	cooldown_per_use = 2 // 3 delay on a ticker circuit from testing.

/obj/item/integrated_circuit/smart/pathfinding_locomotion
	// Add these two variables
	var/turf/last_known_position = null
	var/datum/weakref/last_target = null

/obj/item/integrated_circuit/smart/pathfinding_locomotion/do_work()
	var/datum/integrated_io/I = inputs[1]

	// Reset last known position when target changes
	if(!istype(I.data, /datum/weakref) || I.data != last_target)
		last_known_position = null
		last_target = I.data

	if(!isweakref(I.data))
		activate_pin(3)
		return

	var/atom/A = I.data.resolve()
	if(!A)
		activate_pin(3)
		return

	var/turf/start = get_turf(src)
	var/turf/goal = get_turf(A)
	if(!start || !goal)
		activate_pin(3)
		return

	// Update last known position when target is visible
	if(A in view(start))
		last_known_position = goal

	// If target not visible but we have last known position, use that instead
	if(!(A in view(start)))
		if(!last_known_position)
			// No idea where target is
			set_pin_data(IC_OUTPUT, 1, null)
			set_pin_data(IC_OUTPUT, 2, null)
			push_data()
			activate_pin(3)
			return
		goal = last_known_position

	var/desired_dir

	// Calculate path to either current position or last known position
	var/list/path = AStar(start, goal, /turf/proc/AdjacentTurfsWithAccess, /turf/proc/Distance, 0, 30, id = assembly)
	if(path && path.len > 1)
		var/turf/next = path[2]
		desired_dir = get_dir(start, next)
	else
		desired_dir = get_dir(start, goal)

	set_pin_data(IC_OUTPUT, 1, desired_dir)
	set_pin_data(IC_OUTPUT, 2, get_dist(start, goal))
	push_data()

	// Move the assembly
	if(assembly && !assembly.anchored && assembly.can_move())
		var/move_result = step(assembly, desired_dir)
		if(move_result)
			activate_pin(2)
		else
			activate_pin(3)
	else
		activate_pin(3)

	// Normal pulse in (ord == 1)
	pull_data()
	var/enabled_input = get_pin_data(IC_INPUT, 2)

	// Always set the output data, but make it null if disabled
	if(enabled_input)
		set_pin_data(IC_OUTPUT, 1, get_pin_data(IC_INPUT, 1))
		push_data()
		activate_pin(3)  // Only activate downstream circuits if enabled
	else  // Clear output when disabled
		push_data()


/obj/item/integrated_circuit/smart/z_level_sensor
	name = "Z-level sensor"
	desc = "A specialized circuit that reports the current Z-level when pulsed."
	extended_desc = "This circuit will output the current Z-level coordinate of the assembly when activated. Useful for navigation and location tracking."
	icon_state = "numberpad"
	complexity = 5
	inputs = list()
	outputs = list("Z-level" = IC_PINTYPE_NUMBER)
	activators = list("get Z-level" = IC_PINTYPE_PULSE_IN, "on read" = IC_PINTYPE_PULSE_OUT)
	spawn_flags = IC_SPAWN_DEFAULT|IC_SPAWN_RESEARCH
	origin_tech = list(TECH_ENGINEERING = 2, TECH_DATA = 3)
	power_draw_per_use = 10

/obj/item/integrated_circuit/smart/z_level_sensor/do_work()
	var/turf/current_turf = get_turf(src)
	var/z_level = 1 // Default fallback

	if(current_turf)
		z_level = current_turf.z

	set_pin_data(IC_OUTPUT, 1, z_level)
	push_data()
	activate_pin(2)
