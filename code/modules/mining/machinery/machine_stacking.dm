/**********************Mineral stacking unit console**************************/

/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	icon_state = "console"
	layer = ABOVE_WINDOW_LAYER
	anchored = TRUE
	circuit = /obj/item/circuitboard/mat_stacker_console
	var/obj/machinery/mineral/stacking_machine/machine = null

/obj/machinery/mineral/stacking_unit_console/Initialize(mapload)
	. = ..()
	default_apply_parts()
	stacker_link()
	if(!machine && mapload) // Delete mapped ones if they fail
		stack_trace(span_danger("Warning: Stacking machine console at [src.x], [src.y], [src.z] could not find its machine!"))
		return INITIALIZE_HINT_QDEL

/obj/machinery/mineral/stacking_unit_console/Destroy()
	stacker_unlink()
	. = ..()

/obj/machinery/mineral/stacking_unit_console/has_link()
	return machine

/obj/machinery/mineral/stacking_unit_console/update_icon()
	if(!machine || machine.console != src)
		icon_state = "[initial(icon_state)]_bad"
		return
	icon_state = initial(icon_state)

/obj/machinery/mineral/stacking_unit_console/proc/stacker_link(obj/machinery/mineral/stacking_machine/new_machine = null)
	if(!new_machine)
		new_machine = find_nearest_linkable(/obj/machinery/mineral/stacking_machine)
	if(!new_machine)
		update_icon()
		return
	// Perform the actual link!
	machine = new_machine
	machine.console = src
	update_icon()

/obj/machinery/mineral/stacking_unit_console/proc/stacker_unlink()
	if(machine?.console == src)
		machine.console = null
	SStgui.close_uis(src)
	machine = null
	update_icon()

/obj/machinery/mineral/stacking_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	if(!machine)
		to_chat(user, span_danger("Stacking machine not detected."))
		return
	tgui_interact(user)

/obj/machinery/mineral/stacking_unit_console/attackby(obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	. = ..()

/obj/machinery/mineral/stacking_unit_console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MiningStackingConsole", name)
		ui.open()

/obj/machinery/mineral/stacking_unit_console/tgui_data(mob/user)
	var/list/data = ..()


	var/list/stacktypes = list()
	for(var/stacktype in machine.stack_storage)
		if(machine.stack_storage[stacktype] > 0)
			stacktypes.Add(list(list(
				"type" = stacktype,
				"amt" = machine.stack_storage[stacktype],
			)))
	data["stacktypes"] = stacktypes
	data["stackingAmt"] = machine.stack_amt
	return data

/obj/machinery/mineral/stacking_unit_console/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	add_fingerprint(ui.user)

	if(!machine)
		return FALSE

	switch(action)
		if("change_stack")
			machine.stack_amt = clamp(text2num(params["amt"]), 1, 50)
			. = TRUE

		if("release_stack")
			var/stack = params["stack"]
			if(machine.stack_storage[stack] > 0)
				var/stacktype = machine.stack_paths[stack]
				if(machine.output_dir)
					var/turf/output = get_step(machine,machine.output_dir)
					if(output)
						new stacktype(output, machine.stack_storage[stack])
						machine.stack_storage[stack] = 0
			. = TRUE

/**********************Mineral stacking unit**************************/


/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "stacker"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/circuitboard/mat_stacker
	var/obj/machinery/mineral/stacking_unit_console/console
	var/list/stack_storage[0]
	var/list/stack_paths[0]
	var/stack_amt = 50; // Amount to stack before releassing
	sets_direction = TRUE

/obj/machinery/mineral/stacking_machine/Initialize(mapload)
	. = ..()
	default_apply_parts()

	for(var/obj/item/stack/material/S as anything in (subtypesof(/obj/item/stack/material) - typesof(/obj/item/stack/material/cyborg)))
		var/s_matname = initial(S.default_type)
		stack_storage[s_matname] = 0
		stack_paths[s_matname] = S

	// Mapload uses direction hints
	if(!mapload)
		// If we were constructed, try to get a console to attach to us
		var/obj/machinery/mineral/stacking_unit_console/console = find_nearest_linkable(/obj/machinery/mineral/stacking_unit_console)
		if(console)
			console.stacker_link(src)
		return
	find_output_direction()

/obj/machinery/mineral/stacking_machine/Destroy()
	if(console)
		console.stacker_unlink()
	if(speed_process) // high gear
		STOP_PROCESSING(SSfastprocess, src)
	else
		STOP_MACHINE_PROCESSING(src)
	// Release all sheets
	for(var/stack in stack_storage)
		if(stack_storage[stack] <= 0)
			continue
		var/obj/item/stack/stacktype = stack_paths[stack]
		var/turf/output = get_turf(src)
		while(stack_storage[stack] > 0) // Not really a nicer way to do this unless we just delete the stacks...
			var/amnt = min(stack_storage[stack], initial(stacktype.max_amount))
			new stacktype(output, amnt)
			stack_storage[stack] -= amnt
	. = ..()

/obj/machinery/mineral/stacking_machine/has_link()
	return console

/obj/machinery/mineral/stacking_machine/proc/toggle_speed(forced)
	if(forced)
		speed_process = forced
	else
		speed_process = !speed_process // switching gears
	if(speed_process) // high gear
		STOP_MACHINE_PROCESSING(src)
		START_PROCESSING(SSfastprocess, src)
	else // low gear
		STOP_PROCESSING(SSfastprocess, src)
		START_MACHINE_PROCESSING(src)

/obj/machinery/mineral/stacking_machine/attackby(obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	. = ..()

/obj/machinery/mineral/stacking_machine/process()
	if(!output_dir)
		return

	var/turf/output = get_step(src,output_dir)
	if(panel_open || !powered())
		return

	if (!output)
		return
	//Output amounts that are past stack_amt.
	for(var/sheet in stack_storage)
		if(stack_storage[sheet] >= stack_amt)
			var/stacktype = stack_paths[sheet]
			new stacktype (output, stack_amt)
			stack_storage[sheet] -= stack_amt

/obj/machinery/mineral/stacking_machine/Bumped(AM)
	. = ..()
	if(!isitem(AM))
		return
	var/turf/output = get_step(src,output_dir)
	if(!output)
		return
	var/obj/item/O = AM
	if(!istype(O,/obj/item/stack/material))
		O.forceMove(output)
		return
	var/obj/item/stack/material/S = O
	var/matname = S.material.name
	if(!isnull(stack_storage[matname]))
		stack_storage[matname] += S.get_amount()
		qdel(S)
		return
	O.forceMove(output)
