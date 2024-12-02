/**********************Mineral stacking unit console**************************/

/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	icon = 'icons/obj/machines/mining_machines_vr.dmi'  // VOREStation Edit
	icon_state = "console"
	layer = ABOVE_WINDOW_LAYER
	density = TRUE
	anchored = TRUE
	var/obj/machinery/mineral/stacking_machine/machine = null
	//var/machinedir = SOUTHEAST //This is really dumb, so lets burn it with fire.

/obj/machinery/mineral/stacking_unit_console/New()

	..()

	spawn(7)
		//src.machine = locate(/obj/machinery/mineral/stacking_machine, get_step(src, machinedir)) //No.
		src.machine = locate(/obj/machinery/mineral/stacking_machine) in range(5,src)
		if (machine)
			machine.console = src
		else
			//Silently failing and causing mappers to scratch their heads while runtiming isn't ideal.
			to_world(span_danger("Warning: Stacking machine console at [src.x], [src.y], [src.z] could not find its machine!"))
			qdel(src)

/obj/machinery/mineral/stacking_unit_console/attack_hand(mob/user)
	add_fingerprint(user)
	tgui_interact(user)

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

	switch(action)
		if("change_stack")
			machine.stack_amt = clamp(text2num(params["amt"]), 1, 50)
			. = TRUE

		if("release_stack")
			var/stack = params["stack"]
			if(machine.stack_storage[stack] > 0)
				var/stacktype = machine.stack_paths[stack]
				new stacktype(get_turf(machine.output), machine.stack_storage[stack])
				machine.stack_storage[stack] = 0
			. = TRUE

	add_fingerprint(ui.user)

/**********************Mineral stacking unit**************************/


/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon = 'icons/obj/machines/mining_machines_vr.dmi' // VOREStation Edit
	icon_state = "stacker"
	density = TRUE
	anchored = TRUE
	var/obj/machinery/mineral/stacking_unit_console/console
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/list/stack_storage[0]
	var/list/stack_paths[0]
	var/stack_amt = 50; // Amount to stack before releassing

/obj/machinery/mineral/stacking_machine/New()
	..()

	for(var/obj/item/stack/material/S as anything in (subtypesof(/obj/item/stack/material) - typesof(/obj/item/stack/material/cyborg)))
		var/s_matname = initial(S.default_type)
		stack_storage[s_matname] = 0
		stack_paths[s_matname] = S

	spawn( 5 )
		for (var/dir in cardinal)
			src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
			if(src.input) break
		for (var/dir in cardinal)
			src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
			if(src.output) break
		return
	return

/obj/machinery/mineral/stacking_machine/proc/toggle_speed(var/forced)
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

/obj/machinery/mineral/stacking_machine/process()
	if (src.output && src.input)
		var/turf/T = get_turf(input)
		for(var/obj/item/O in T.contents)
			if(!O) return
			if(istype(O,/obj/item/stack/material))
				var/obj/item/stack/material/S = O
				var/matname = S.material.name
				if(!isnull(stack_storage[matname]))
					stack_storage[matname] += S.get_amount()
					qdel(S)
				else
					O.loc = output.loc
			else
				O.loc = output.loc

	//Output amounts that are past stack_amt.
	for(var/sheet in stack_storage)
		if(stack_storage[sheet] >= stack_amt)
			var/stacktype = stack_paths[sheet]
			new stacktype (get_turf(output), stack_amt)
			stack_storage[sheet] -= stack_amt

	if(console)
		console.updateUsrDialog()
	return
