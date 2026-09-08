/**********************Mineral processing unit console**************************/
#define PROCESS_NONE		0
#define PROCESS_SMELT		1
#define PROCESS_COMPRESS	2
#define PROCESS_ALLOY		3

/obj/machinery/mineral/processing_unit_console
	name = "production machine console"
	icon_state = "console"
	layer = ABOVE_WINDOW_LAYER
	anchored = TRUE
	circuit = /obj/item/circuitboard/mat_processor_console

	var/obj/item/card/id/inserted_id	// Inserted ID card, for points

	var/obj/machinery/mineral/processing_unit/machine = null
	var/show_all_ores = FALSE

/obj/machinery/mineral/processing_unit_console/Initialize(mapload)
	. = ..()
	default_apply_parts()
	processor_link()
	if(!machine && mapload) // Delete mapped ones if they fail
		log_mapping("Ore processing machine console at [src.x], [src.y], [src.z] could not find its machine!")
		return INITIALIZE_HINT_QDEL

/obj/machinery/mineral/processing_unit_console/Destroy()
	if(inserted_id)
		inserted_id.forceMove(loc) //Prevents deconstructing from deleting whatever ID was inside it.
	processor_unlink()
	. = ..()

/obj/machinery/mineral/processing_unit_console/update_icon()
	if(!machine || machine.console != src)
		icon_state = "[initial(icon_state)]_bad"
		return
	icon_state = initial(icon_state)

/obj/machinery/mineral/processing_unit_console/attack_hand(mob/user)
	if(..())
		return
	if(!allowed(user))
		to_chat(user, span_warning("Access denied."))
		return
	if(!machine)
		to_chat(user, span_danger("Ore processor not detected."))
		return
	tgui_interact(user)

/obj/machinery/mineral/processing_unit_console/attackby(obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	if(istype(I, /obj/item/card/id))
		if(!powered())
			return
		if(!machine)
			to_chat(user, span_danger("Material processor not detected."))
			return
		if(!inserted_id && (user.unEquip(I) || isrobot(user)))
			I.forceMove(src)
			inserted_id = I
			SStgui.update_uis(src)
		return
	. = ..()

/obj/machinery/mineral/processing_unit_console/proc/processor_link(obj/machinery/mineral/processing_unit/new_machine = null)
	if(!new_machine)
		new_machine = find_nearest_linkable(/obj/machinery/mineral/processing_unit)
	if(!new_machine)
		update_icon()
		return
	// Perform the actual link!
	machine = new_machine
	machine.console = src
	update_icon()

/obj/machinery/mineral/processing_unit_console/proc/processor_unlink()
	if(machine?.console == src)
		machine.console = null
	SStgui.close_uis(src)
	machine = null
	update_icon()

/obj/machinery/mineral/processing_unit_console/has_link()
	return machine

/obj/machinery/mineral/processing_unit_console/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MiningOreProcessingConsole", name)
		ui.open()

/obj/machinery/mineral/processing_unit_console/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	data["unclaimedPoints"] = machine.points

	if(inserted_id)
		data["has_id"] = TRUE
		data["id"] = list(
			"name" = inserted_id.registered_name,
			"points" = inserted_id.mining_points,
		)
	else
		data["has_id"] = FALSE


	var/list/ores = list()
	for(var/ore in machine.ores_processing)
		if(!machine.ores_stored[ore] && !show_all_ores)
			continue
		var/datum/ore/O = GLOB.ore_data[ore]
		if(!O)
			continue
		ores.Add(list(list(
			"ore" = ore,
			"name" = O.display_name,
			"amount" = machine.ores_stored[ore],
			"processing" = machine.ores_processing[ore] ? machine.ores_processing[ore] : 0,
		)))
	data["ores"] = ores
	data["showAllOres"] = show_all_ores
	data["power"] = machine.active
	data["speed"] = machine.speed_process

	return data

/obj/machinery/mineral/processing_unit_console/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	add_fingerprint(ui.user)

	if(!machine)
		return FALSE

	switch(action)
		if("toggleSmelting")
			var/ore = params["ore"]
			var/new_setting = params["set"]
			if(new_setting == null)
				new_setting = tgui_input_list(ui.user, "What setting do you wish to use for processing [ore]]?", "Process Setting", list("Smelting","Compressing","Alloying","Nothing"))
				if(!new_setting)
					return
				switch(new_setting)
					if("Nothing") new_setting = PROCESS_NONE
					if("Smelting") new_setting = PROCESS_SMELT
					if("Compressing") new_setting = PROCESS_COMPRESS
					if("Alloying") new_setting = PROCESS_ALLOY
			machine.ores_processing[ore] = new_setting
			. = TRUE
		if("power")
			machine.active = !machine.active
			. = TRUE
		if("showAllOres")
			show_all_ores = !show_all_ores
			. = TRUE
		if("logoff")
			if(!inserted_id)
				return
			ui.user.put_in_hands(inserted_id)
			inserted_id = null
			. = TRUE
		if("claim")
			if(istype(inserted_id))
				if(ACCESS_MINING_STATION in inserted_id.GetAccess())
					inserted_id.adjust_mining_points(machine.points)
					machine.points = 0
				else
					to_chat(ui.user, span_warning("Required access not found."))
			. = TRUE
		if("insert")
			var/obj/item/card/id/I = ui.user.get_active_hand()
			if(istype(I))
				ui.user.drop_item()
				I.forceMove(src)
				inserted_id = I
			else
				to_chat(ui.user, span_warning("No valid ID."))
			. = TRUE
		if("speed_toggle")
			machine.toggle_speed()
			. = TRUE
		else
			return FALSE

/**********************Mineral processing unit**************************/


/obj/machinery/mineral/processing_unit
	name = "material processor" //This isn't actually a goddamn furnace, we're in space and it's processing platinum and flammable phoron...
	icon = 'icons/obj/machines/mining_machines.dmi'
	icon_state = "furnace"
	density = TRUE
	anchored = TRUE
	light_range = 3
	circuit = /obj/item/circuitboard/mat_processor
	sets_direction = TRUE

	var/obj/machinery/mineral/processing_unit_console/console = null
	var/sheets_per_tick = 10
	var/list/ores_processing = list()
	var/list/ores_stored = list()
	var/active = FALSE

	var/points = 0
	var/points_mult = 1 //- multiplier for points generated when ore hits the processors
	var/static/list/ore_values = list(
		ORE_SAND = 1,
		ORE_HEMATITE = 1,
		ORE_CARBON = 1,
		ORE_COPPER = 1,
		ORE_TIN = 1,
		ORE_VOPAL = 3,
		ORE_PAINITE = 3,
		ORE_QUARTZ= 3,
		ORE_BAUXITE = 5,
		ORE_PHORON = 15,
		ORE_SILVER = 16,
		ORE_GOLD = 18,
		ORE_MARBLE = 20,
		ORE_URANIUM = 30,
		ORE_DIAMOND = 50,
		ORE_PLATINUM = 40,
		ORE_LEAD = 40,
		ORE_MHYDROGEN = 40,
		ORE_VERDANTIUM = 60,
		ORE_RUTILE = 40)

/obj/machinery/mineral/processing_unit/Initialize(mapload)
	. = ..()
	default_apply_parts()

	for(var/ore, value in GLOB.ore_data)
		var/datum/ore/OD = value
		ores_processing[OD.name] = 0
		ores_stored[OD.name] = 0

	// Mapload uses direction hints
	if(!mapload)
		// If we were constructed, try to get a console to attach to us
		var/obj/machinery/mineral/processing_unit_console/console = find_nearest_linkable(/obj/machinery/mineral/processing_unit_console)
		if(console)
			console.processor_link(src)
		return
	find_output_direction()

/obj/machinery/mineral/processing_unit/Destroy()
	if(console)
		console.processor_unlink()
	if(speed_process) // high gear
		STOP_PROCESSING(SSfastprocess, src)
	else
		STOP_MACHINE_PROCESSING(src)
	// We don't drop stored ores, just to avoid point exploits. Maybe this should drop slag instead?
	. = ..()

/obj/machinery/mineral/processing_unit/has_link()
	return console

/obj/machinery/mineral/processing_unit/proc/toggle_speed(forced)
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
	// There is no danger of recursion here, because the other toggle_speed procs do no broadcast like this one on change
	for(var/obj/machinery/mach in range(connection_range + 2, src)) // a little more than the link range
		if(mach == src)
			continue
		if(istype(mach, /obj/machinery/mineral/unloading_machine))
			var/obj/machinery/mineral/unloading_machine/unloader = mach
			unloader.toggle_speed(speed_process)
			continue
		if(istype(mach, /obj/machinery/conveyor_switch))
			var/obj/machinery/conveyor_switch/cswitch = mach
			cswitch.toggle_speed(speed_process)
			continue
		if(istype(mach, /obj/machinery/mineral/stacking_machine))
			var/obj/machinery/mineral/stacking_machine/stacker = mach
			stacker.toggle_speed(speed_process)
			continue

/obj/machinery/mineral/processing_unit/attackby(obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	. = ..()

/obj/machinery/mineral/processing_unit/process()
	if(!output_dir)
		return

	var/turf/output = get_step(src,output_dir)
	if(!output)
		return
	if(panel_open || !powered())
		return

	var/list/tick_alloys = list()

	//Grab some more ore to process this tick.
	var/turf/input = get_step(src, reverse_direction(output_dir)) // Only applies to unloading oreboxes DIRECTLY with no conveyors... Did anyone even know this was a feature?
	if(input)
		for(var/obj/structure/ore_box/OB in input)
			for(var/ore in OB.stored_ore)
				if(OB.stored_ore[ore] > 0)
					var/ore_amount = OB.stored_ore[ore]									// How many ores does the box have?
					ores_stored[ore] += ore_amount 										// Add the ore to the machine.
					points += (ore_values[ore]*points_mult*ore_amount) 					// Give Points! VOREStation Edit - or give lots of points! or less points! or no points!
					OB.stored_ore[ore] = 0 												// Set the value of the ore in the box to 0.

	if(!active)
		return

	//Process our stored ores and spit out sheets.
	var/sheets = 0
	for(var/metal in ores_stored)

		if(sheets >= sheets_per_tick) break

		if(ores_stored[metal] > 0 && ores_processing[metal] != 0)

			var/datum/ore/O = GLOB.ore_data[metal]

			if(!O) continue

			if(ores_processing[metal] == PROCESS_ALLOY && O.alloy) //Alloying.

				for(var/datum/alloy/A in GLOB.alloy_data)

					if(A.metaltag in tick_alloys)
						continue

					tick_alloys += A.metaltag
					var/enough_metal

					if(!isnull(A.requires[metal]) && ores_stored[metal] >= A.requires[metal]) //We have enough of our first metal, we're off to a good start.

						enough_metal = 1

						for(var/needs_metal in A.requires)
							//Check if we're alloying the needed metal and have it stored.
							if(ores_processing[needs_metal] != PROCESS_ALLOY || ores_stored[needs_metal] < A.requires[needs_metal])
								enough_metal = 0
								break

					if(!enough_metal)
						continue
					else
						var/total
						for(var/needs_metal in A.requires)
							ores_stored[needs_metal] -= A.requires[needs_metal]
							total += A.requires[needs_metal]
							total = max(1,round(total*A.product_mod)) //Always get at least one sheet.
							sheets += total-1

						for(var/i=0,i<total,i++)
							new A.product(output)

			else if(ores_processing[metal] == PROCESS_COMPRESS && O.compresses_to) //Compressing.

				var/can_make = CLAMP(ores_stored[metal],0,sheets_per_tick-sheets)
				if(can_make%2>0) can_make--

				var/datum/material/M = get_material_by_name(O.compresses_to)

				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/i=0,i<can_make,i+=2)
					ores_stored[metal]-=2
					sheets+=2
					new M.stack_type(output)

			else if(ores_processing[metal] == PROCESS_SMELT && O.smelts_to) //Smelting.

				var/can_make = CLAMP(ores_stored[metal],0,sheets_per_tick-sheets)

				var/datum/material/M = get_material_by_name(O.smelts_to)
				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/i=0,i<can_make,i++)
					ores_stored[metal]--
					sheets++
					new M.stack_type(output)
			else
				ores_stored[metal]--
				sheets++
				new /obj/item/ore/slag(output)
		else
			continue

/obj/machinery/mineral/processing_unit/Bumped(AM)
	. = ..()
	if(istype(AM, /obj/item/ore_chunk))
		var/obj/item/ore_chunk/ore_chunk = AM
		for(var/ore in ore_chunk.stored_ore)
			if(ore_chunk.stored_ore[ore] > 0)
				var/ore_amount = ore_chunk.stored_ore[ore]
				ores_stored[ore] += ore_amount
				points += (ore_values[ore]*points_mult*ore_amount)
				ore_chunk.stored_ore[ore] = 0
			qdel(ore_chunk)
		return
	if(istype(AM, /obj/item/ore))
		var/obj/item/ore/O = AM
		if(!isnull(ores_stored[O.material]))
			ores_stored[O.material]++
			points += (ore_values[O.material]*points_mult)
		qdel(O)
		return

#undef PROCESS_NONE
#undef PROCESS_SMELT
#undef PROCESS_COMPRESS
#undef PROCESS_ALLOY
