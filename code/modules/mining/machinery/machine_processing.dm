/**********************Mineral processing unit console**************************/
#define PROCESS_NONE		0
#define PROCESS_SMELT		1
#define PROCESS_COMPRESS	2
#define PROCESS_ALLOY		3

/obj/machinery/mineral/processing_unit_console
	name = "production machine console"
	icon = 'icons/obj/machines/mining_machines_vr.dmi' // VOREStation Edit
	icon_state = "console"
	layer = ABOVE_WINDOW_LAYER
	density = TRUE
	anchored = TRUE

	var/obj/item/weapon/card/id/inserted_id	// Inserted ID card, for points

	var/obj/machinery/mineral/processing_unit/machine = null
	var/show_all_ores = FALSE

/obj/machinery/mineral/processing_unit_console/Initialize()
	. = ..()
	src.machine = locate(/obj/machinery/mineral/processing_unit) in range(5, src)
	if (machine)
		machine.console = src
	else
		log_debug("Ore processing machine console at [src.x], [src.y], [src.z] could not find its machine!")
		qdel(src)

/obj/machinery/mineral/processing_unit_console/Destroy()
	if(inserted_id)
		inserted_id.forceMove(loc) //Prevents deconstructing from deleting whatever ID was inside it.
	. = ..()

/obj/machinery/mineral/processing_unit_console/attack_hand(mob/user)
	if(..())
		return
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return
	tgui_interact(user)

/obj/machinery/mineral/processing_unit_console/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/card/id))
		if(!powered())
			return
		if(!inserted_id && user.unEquip(I))
			I.forceMove(src)
			inserted_id = I
			SStgui.update_uis(src)
		return
	..()

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
		var/ore/O = GLOB.ore_data[ore]
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

/obj/machinery/mineral/processing_unit_console/tgui_act(action, list/params)
	if(..())
		return TRUE

	add_fingerprint(usr)
	switch(action)
		if("toggleSmelting")
			var/ore = params["ore"]
			var/new_setting = params["set"]
			if(new_setting == null)
				new_setting = tgui_input_list(usr, "What setting do you wish to use for processing [ore]]?", "Process Setting", list("Smelting","Compressing","Alloying","Nothing"))
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
			usr.put_in_hands(inserted_id)
			inserted_id = null
			. = TRUE
		if("claim")
			if(istype(inserted_id))
				if(access_mining_station in inserted_id.access)
					inserted_id.mining_points += machine.points
					machine.points = 0
				else
					to_chat(usr, "<span class='warning'>Required access not found.</span>")
			. = TRUE
		if("insert")
			var/obj/item/weapon/card/id/I = usr.get_active_hand()
			if(istype(I))
				usr.drop_item()
				I.forceMove(src)
				inserted_id = I
			else
				to_chat(usr, "<span class='warning'>No valid ID.</span>")
			. = TRUE
		if("speed_toggle")
			machine.toggle_speed()
			. = TRUE
		else
			return FALSE

/**********************Mineral processing unit**************************/


/obj/machinery/mineral/processing_unit
	name = "material processor" //This isn't actually a goddamn furnace, we're in space and it's processing platinum and flammable phoron...
	icon = 'icons/obj/machines/mining_machines_vr.dmi' // VOREStation Edit
	icon_state = "furnace"
	density = TRUE
	anchored = TRUE
	light_range = 3
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null
	var/obj/machinery/mineral/console = null
	var/sheets_per_tick = 10
	var/list/ores_processing = list()
	var/list/ores_stored = list()
	var/active = FALSE

	var/points = 0
	var/points_mult = 1 //VOREStation Add - multiplier for points generated when ore hits the processors
	var/static/list/ore_values = list(
		"sand" = 1,
		"hematite" = 1,
		"carbon" = 1,
		"raw copper" = 1,
		"raw tin" = 1,
		"void opal" = 3,
		"painite" = 3,
		"quartz" = 3,
		"raw bauxite" = 5,
		"phoron" = 15,
		"silver" = 16,
		"gold" = 18,
		"marble" = 20,
		"rutile" = 20,
		"uranium" = 30,
		"diamond" = 50,
		"platinum" = 40,
		"lead" = 40,
		"mhydrogen" = 40,
		"verdantium" = 60,
		"rutile" = 40) //VOREStation Add

/obj/machinery/mineral/processing_unit/Initialize()
	. = ..()
	for(var/ore in GLOB.ore_data)
		var/ore/OD = GLOB.ore_data[ore]
		ores_processing[OD.name] = 0
		ores_stored[OD.name] = 0

	// TODO - Eschew input/output machinery and just use dirs ~Leshana
	//Locate our output and input machinery.
	for (var/dir in cardinal)
		src.input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(src.input) break
	for (var/dir in cardinal)
		src.output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(src.output) break
	return

/obj/machinery/mineral/processing_unit/proc/toggle_speed(var/forced)
	var/area/refinery_area = get_area(src)
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
	for(var/obj/machinery/mineral/unloading_machine/unloader in refinery_area.contents)
		unloader.toggle_speed()
	for(var/obj/machinery/conveyor_switch/cswitch in refinery_area.contents)
		cswitch.toggle_speed()
	for(var/obj/machinery/mineral/stacking_machine/stacker in refinery_area.contents)
		stacker.toggle_speed()


/obj/machinery/mineral/processing_unit/process()

	if (!src.output || !src.input)
		return

	if(panel_open || !powered())
		return

	var/list/tick_alloys = list()

	//Grab some more ore to process this tick.
	for(var/obj/structure/ore_box/OB in input.loc)
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

			var/ore/O = GLOB.ore_data[metal]

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
							new A.product(output.loc)

			else if(ores_processing[metal] == PROCESS_COMPRESS && O.compresses_to) //Compressing.

				var/can_make = CLAMP(ores_stored[metal],0,sheets_per_tick-sheets)
				if(can_make%2>0) can_make--

				var/datum/material/M = get_material_by_name(O.compresses_to)

				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/i=0,i<can_make,i+=2)
					ores_stored[metal]-=2
					sheets+=2
					new M.stack_type(output.loc)

			else if(ores_processing[metal] == PROCESS_SMELT && O.smelts_to) //Smelting.

				var/can_make = CLAMP(ores_stored[metal],0,sheets_per_tick-sheets)

				var/datum/material/M = get_material_by_name(O.smelts_to)
				if(!istype(M) || !can_make || ores_stored[metal] < 1)
					continue

				for(var/i=0,i<can_make,i++)
					ores_stored[metal]--
					sheets++
					new M.stack_type(output.loc)
			else
				ores_stored[metal]--
				sheets++
				new /obj/item/weapon/ore/slag(output.loc)
		else
			continue

	console.updateUsrDialog()

#undef PROCESS_NONE
#undef PROCESS_SMELT
#undef PROCESS_COMPRESS
#undef PROCESS_ALLOY

