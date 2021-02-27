/**********************Mineral stacking unit console**************************/

/obj/machinery/mineral/stacking_unit_console
	name = "stacking machine console"
	icon = 'icons/obj/machines/mining_machines_vr.dmi'  // VOREStation Edit
	icon_state = "console"
	layer = ABOVE_WINDOW_LAYER
	density = 1
	anchored = 1
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
			to_world("<span class='danger'>Warning: Stacking machine console at [src.x], [src.y], [src.z] could not find its machine!</span>")
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

	data["stacktypes"] = list()
	for(var/stacktype in machine.stack_storage)
		if(machine.stack_storage[stacktype] > 0)
			data["stacktypes"].Add(list(list(
				"type" = stacktype,
				"amt" = machine.stack_storage[stacktype],
			)))
	data["stackingAmt"] = machine.stack_amt
	return data

/obj/machinery/mineral/stacking_unit_console/tgui_act(action, list/params)
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
				var/obj/item/stack/material/S = new stacktype(get_turf(machine.output))
				S.amount = machine.stack_storage[stack]
				machine.stack_storage[stack] = 0
				S.update_icon()
			. = TRUE

	add_fingerprint(usr)

/**********************Mineral stacking unit**************************/


/obj/machinery/mineral/stacking_machine
	name = "stacking machine"
	icon = 'icons/obj/machines/mining_machines_vr.dmi' // VOREStation Edit
	icon_state = "stacker"
	density = 1
	anchored = 1.0
	var/obj/machinery/mineral/stacking_unit_console/console
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/list/stack_storage[0]
	var/list/stack_paths[0]
	var/stack_amt = 50; // Amount to stack before releassing

/obj/machinery/mineral/stacking_machine/New()
	..()

	for(var/stacktype in subtypesof(/obj/item/stack/material))
		var/obj/item/stack/S = stacktype
		var/s_name = initial(S.name)
		stack_storage[s_name] = 0
		stack_paths[s_name] = stacktype

	stack_storage["glass"] = 0
	stack_paths["glass"] = /obj/item/stack/material/glass
	stack_storage[DEFAULT_WALL_MATERIAL] = 0
	stack_paths[DEFAULT_WALL_MATERIAL] = /obj/item/stack/material/steel
	stack_storage["plasteel"] = 0
	stack_paths["plasteel"] = /obj/item/stack/material/plasteel

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
			if(istype(O,/obj/item/stack))
				if(!isnull(stack_storage[O.name]))
					stack_storage[O.name]++
					O.loc = null
				else
					O.loc = output.loc
			else
				O.loc = output.loc

	//Output amounts that are past stack_amt.
	for(var/sheet in stack_storage)
		if(stack_storage[sheet] >= stack_amt)
			var/stacktype = stack_paths[sheet]
			var/obj/item/stack/material/S = new stacktype (get_turf(output))
			S.amount = stack_amt
			stack_storage[sheet] -= stack_amt
			S.update_icon()
	
	if(console)
		console.updateUsrDialog()
	return

