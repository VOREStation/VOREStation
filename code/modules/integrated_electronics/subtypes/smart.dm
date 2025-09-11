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

/obj/item/integrated_circuit/smart/targeted_pathfinder/do_work()
	var/datum/integrated_io/I = inputs[1]
	set_pin_data(IC_OUTPUT, 1, null)

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

	if(!(A in view(start)))
		push_data()
		activate_pin(2)
		return // Can't see the target.

	// Pathfinding start
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

/obj/item/integrated_circuit/smart/pathfinding_locomotion/do_work()
	var/datum/integrated_io/I = inputs[1]
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

	var/desired_dir

	// Only calculate full path if target is in view
	if(A in view(start))
		var/list/path = AStar(start, goal, /turf/proc/AdjacentTurfsWithAccess, /turf/proc/Distance, 0, 30, id = assembly)
		if(path && path.len > 1)
			var/turf/next = path[2]
			desired_dir = get_dir(start, next)
		else
			desired_dir = get_dir(start, goal)
	else
		// If we can't see the target, just move in its direction
		desired_dir = get_dir(start, goal)

	set_pin_data(IC_OUTPUT, 1, desired_dir)
	set_pin_data(IC_OUTPUT, 2, get_dist(start, goal))
	push_data()

	// Move the assembly.
	if(assembly && !assembly.anchored && assembly.can_move())
		var/move_result = step(assembly, desired_dir)
		if(move_result)
			activate_pin(2)
		else
			activate_pin(3)
	else
		activate_pin(3)
