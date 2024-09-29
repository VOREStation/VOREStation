/*
	Integrated circuits are essentially modular machines.  Each circuit has a specific function, and combining them inside Electronic Assemblies allows
a creative player the means to solve many problems.  Circuits are held inside an electronic assembly, and are wired using special tools.
*/

/obj/item/integrated_circuit/examine(mob/user)
	. = ..()
	. += external_examine(user)
	tgui_interact(user)

// This should be used when someone is examining while the case is opened.
/obj/item/integrated_circuit/proc/internal_examine(mob/user)
	. = list()
	. += "This board has [inputs.len] input pin\s, [outputs.len] output pin\s and [activators.len] activation pin\s."
	for(var/datum/integrated_io/I in inputs)
		if(I.linked.len)
			. += "The '[I]' is connected to [I.get_linked_to_desc()]."
	for(var/datum/integrated_io/O in outputs)
		if(O.linked.len)
			. += "The '[O]' is connected to [O.get_linked_to_desc()]."
	for(var/datum/integrated_io/activate/A in activators)
		if(A.linked.len)
			. += "The '[A]' is connected to [A.get_linked_to_desc()]."
	. += any_examine(user)
	tgui_interact(user)

// This should be used when someone is examining from an 'outside' perspective, e.g. reading a screen or LED.
/obj/item/integrated_circuit/proc/external_examine(mob/user)
	return any_examine(user)

/obj/item/integrated_circuit/proc/any_examine(mob/user)
	return

/obj/item/integrated_circuit/New()
	displayed_name = name
	if(!size) size = w_class
	if(size == -1) size = 0
	setup_io(inputs, /datum/integrated_io, inputs_default)
	setup_io(outputs, /datum/integrated_io, outputs_default)
	setup_io(activators, /datum/integrated_io/activate)
	..()

/obj/item/integrated_circuit/proc/on_data_written() //Override this for special behaviour when new data gets pushed to the circuit.
	return

/obj/item/integrated_circuit/Destroy()
	for(var/datum/integrated_io/I in inputs)
		qdel(I)
	for(var/datum/integrated_io/O in outputs)
		qdel(O)
	for(var/datum/integrated_io/A in activators)
		qdel(A)
	. = ..()

/obj/item/integrated_circuit/emp_act(severity)
	for(var/datum/integrated_io/io in inputs + outputs + activators)
		io.scramble()

/obj/item/integrated_circuit/proc/check_interactivity(mob/user)
	return tgui_status(user, GLOB.tgui_physical_state) == STATUS_INTERACTIVE

/obj/item/integrated_circuit/verb/rename_component()
	set name = "Rename Circuit"
	set category = "Object"
	set desc = "Rename your circuit, useful to stay organized."

	var/mob/M = usr
	if(!check_interactivity(M))
		return

	var/input = sanitizeSafe(tgui_input_text(usr, "What do you want to name the circuit?", "Rename", src.name, MAX_NAME_LEN), MAX_NAME_LEN)
	if(src && input && assembly.check_interactivity(M))
		to_chat(M, "<span class='notice'>The circuit '[src.name]' is now labeled '[input]'.</span>")
		displayed_name = input

/obj/item/integrated_circuit/tgui_state(mob/user)
	return GLOB.tgui_physical_state

/obj/item/integrated_circuit/tgui_host(mob/user)
	if(istype(loc, /obj/item/electronic_assembly))
		return loc.tgui_host()
	return ..()

/obj/item/integrated_circuit/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ICCircuit", name, parent_ui)
		ui.open()

/obj/item/integrated_circuit/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["name"] = name
	data["desc"] = desc
	data["displayed_name"] = displayed_name
	data["removable"] = removable

	data["complexity"] = complexity
	data["power_draw_idle"] = power_draw_idle
	data["power_draw_per_use"] = power_draw_per_use
	data["extended_desc"] = extended_desc

	var/list/inputs_list = list()
	var/list/outputs_list = list()
	var/list/activators_list = list()
	for(var/datum/integrated_io/io in inputs)
		inputs_list.Add(list(tgui_pin_data(io)))

	for(var/datum/integrated_io/io in outputs)
		outputs_list.Add(list(tgui_pin_data(io)))

	for(var/datum/integrated_io/io in activators)
		var/list/list/activator = list(
			"ref" = REF(io),
			"name" = io.name,
			"pulse_out" = io.data,
			"linked" = list()
		)
		for(var/datum/integrated_io/linked in io.linked)
			activator["linked"].Add(list(list(
				"ref" = REF(linked),
				"name" = linked.name,
				"holder_ref" = REF(linked.holder),
				"holder_name" = linked.holder.displayed_name,
			)))

		activators_list.Add(list(activator))

	data["inputs"] = inputs_list
	data["outputs"] = outputs_list
	data["activators"] = activators_list

	return data

/obj/item/integrated_circuit/proc/tgui_pin_data(datum/integrated_io/io)
	if(!istype(io))
		return list()
	var/list/pindata = list()
	pindata["type"] = io.display_pin_type()
	pindata["name"] = io.name
	pindata["data"] = io.display_data(io.data)
	pindata["ref"] = REF(io)
	var/list/linked_list = list()
	for(var/datum/integrated_io/linked in io.linked)
		linked_list.Add(list(list(
			"ref" = REF(linked),
			"name" = linked.name,
			"holder_ref" = REF(linked.holder),
			"holder_name" = linked.holder.displayed_name,
		)))
	pindata["linked"] = linked_list
	return pindata

/obj/item/integrated_circuit/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	var/datum/integrated_io/pin = locate(params["pin"]) in inputs + outputs + activators
	var/datum/integrated_io/linked = null

	if(params["link"])
		linked = locate(params["link"]) in pin.linked

	var/obj/held_item = usr.get_active_hand()

	. = TRUE
	switch(action)
		if("rename")
			rename_component(usr)
			return

		if("wire", "pin_name", "pin_data", "pin_unwire")
			if(istype(held_item, /obj/item/multitool) && allow_multitool)
				var/obj/item/multitool/M = held_item
				switch(action)
					if("pin_name")
						M.wire(pin, usr)
					if("pin_data")
						var/datum/integrated_io/io = pin
						io.ask_for_pin_data(usr, held_item) // The pins themselves will determine how to ask for data, and will validate the data.
					if("pin_unwire")
						M.unwire(pin, linked, usr)

			else if(istype(held_item, /obj/item/integrated_electronics/wirer))
				var/obj/item/integrated_electronics/wirer/wirer = held_item
				if(linked)
					wirer.wire(linked, usr)
				else if(pin)
					wirer.wire(pin, usr)

			else if(istype(held_item, /obj/item/integrated_electronics/debugger))
				var/obj/item/integrated_electronics/debugger/debugger = held_item
				if(pin)
					debugger.write_data(pin, usr)
			else
				to_chat(usr, "<span class='warning'>You can't do a whole lot without the proper tools.</span>")
			return

		if("scan")
			if(istype(held_item, /obj/item/integrated_electronics/debugger))
				var/obj/item/integrated_electronics/debugger/D = held_item
				if(D.accepting_refs)
					D.afterattack(src, usr, TRUE)
				else
					to_chat(usr, "<span class='warning'>The Debugger's 'ref scanner' needs to be on.</span>")
			else
				to_chat(usr, "<span class='warning'>You need a multitool/debugger set to 'ref' mode to do that.</span>")
			return


		if("examine")
			var/obj/item/integrated_circuit/examined = locate(params["ref"])
			if(istype(examined) && (examined.loc == loc))
				if(ui.parent_ui)
					examined.tgui_interact(usr, null, ui.parent_ui)
				else
					examined.tgui_interact(usr)

		if("remove")
			remove(usr)
			return
	return FALSE

/obj/item/integrated_circuit/proc/remove(mob/user)
	var/obj/item/electronic_assembly/A = assembly
	if(!A)
		to_chat(user, "<span class='warning'>This circuit is not in an assembly!</span>")
		return
	if(!removable)
		to_chat(user, "<span class='warning'>\The [src] seems to be permanently attached to the case.</span>")
		return
	var/obj/item/electronic_assembly/ea = loc

	power_fail()
	disconnect_all()
	var/turf/T = get_turf(src)
	forceMove(T)
	assembly = null
	playsound(T, 'sound/items/Crowbar.ogg', 50, 1)
	to_chat(user, "<span class='notice'>You pop \the [src] out of the case, and slide it out.</span>")

	if(istype(ea))
		ea.tgui_interact(user)

/obj/item/integrated_circuit/proc/push_data()
	for(var/datum/integrated_io/O in outputs)
		O.push_data()

/obj/item/integrated_circuit/proc/pull_data()
	for(var/datum/integrated_io/I in inputs)
		I.push_data()

/obj/item/integrated_circuit/proc/draw_idle_power()
	if(assembly)
		return assembly.draw_power(power_draw_idle)

// Override this for special behaviour when there's no power left.
/obj/item/integrated_circuit/proc/power_fail()
	return

// Returns true if there's enough power to work().
/obj/item/integrated_circuit/proc/check_power()
	if(!assembly)
		return FALSE // Not in an assembly, therefore no power.
	if(assembly.draw_power(power_draw_per_use))
		return TRUE // Battery has enough.
	return FALSE // Not enough power.

/obj/item/integrated_circuit/proc/check_then_do_work(var/ignore_power = FALSE)
	if(world.time < next_use) 	// All intergrated circuits have an internal cooldown, to protect from spam.
		return
	if(power_draw_per_use && !ignore_power)
		if(!check_power())
			power_fail()
			return
	next_use = world.time + cooldown_per_use
	do_work()

/obj/item/integrated_circuit/proc/do_work()
	return

/obj/item/integrated_circuit/proc/disconnect_all()
	for(var/datum/integrated_io/I in inputs)
		I.disconnect()
	for(var/datum/integrated_io/O in outputs)
		O.disconnect()
	for(var/datum/integrated_io/activate/A in activators)
		A.disconnect()

/obj/item/integrated_circuit/proc/on_anchored()
	return

/obj/item/integrated_circuit/proc/on_unanchored()
	return