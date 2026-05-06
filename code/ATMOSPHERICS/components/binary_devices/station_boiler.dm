/obj/machinery/atmospherics/binary/stationboiler
	name = "Station Boiler"
	desc = "A large, phoron-infused wood powered, super boiler. Capable of keeping a entire colony heated up"
	icon = 'icons/obj/machines/heat_boiler.dmi'
	icon_state = "boiler_off"
	use_power = USE_POWER_OFF
	bullet_vulnerability = 0
	anchored = TRUE
	density = TRUE
	pixel_x = -32

	var/is_active = FALSE
	var/ignited = TRUE
	var/target_heat_temperature = T20C //The temperature we want the pipes to be heated to
	var/wood_per_process = 1SECOND
	var/list/stored_material =  list(MAT_LOG = 1 HOUR) //1 hour of mats free
	var/list/storage_capacity = list(MAT_LOG = 4 HOUR) //can hold enough for 4 hours

/obj/machinery/atmospherics/binary/stationboiler/Initialize(mapload)
	. = ..()
	SSstationheater.boilers += src

/obj/machinery/atmospherics/binary/stationboiler/Destroy()
	SSstationheater.boilers -= src
	. = ..()

/obj/machinery/atmospherics/binary/stationboiler/process()
	..()
	//STEP 1 - Pump gas through - using the passive gate method
	var/output_starting_pressure = air2.return_pressure()
	var/input_starting_pressure = air1.return_pressure()
	var/pressure_delta = input_starting_pressure - output_starting_pressure
	var/datum/gas_mixture/source = air1
	var/datum/gas_mixture/sink = air2

	if((pressure_delta > 0.01) && (air1.temperature > 0 || air2.temperature > 0))
		// If node1 is a network of more than 1 pipe, we want to transfer from that whole network, otw use just node1, as current
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			var/obj/machinery/atmospherics/pipe/p = node1
			if(istype(p.parent, /datum/pipeline)) // Nested if-blocks to avoid the mystical :
				var/datum/pipeline/l = p.parent
				if(istype(l.air, /datum/gas_mixture))
					source = l.air
		// If node2 is a network of more than 1 pipe, we want to transfer to that whole network, otw use just node2, as current
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			var/obj/machinery/atmospherics/pipe/p = node2
			if(istype(p.parent, /datum/pipeline))
				var/datum/pipeline/l = p.parent
				if(istype(l.air, /datum/gas_mixture))
					sink = l.air

		var/transfer_moles = max(0, calculate_equalize_moles(source, sink)) // Not regulated, don't care about flow rate
		var/returnval = pump_gas_passive(src, source, sink, transfer_moles)

		if(returnval >= 0)
			if(network1)
				network1.update = 1
			if(network2)
				network2.update = 1

	//STEP 2 - Check if we can heat the gas
	if(!ignited || stored_material[MAT_LOG] < wood_per_process) //Out of wood
		ignited = FALSE
		is_active = 0
		update_icon()
		return

	is_active = 1

	//STEP 3 - Consume the resources
	stored_material[MAT_LOG] = max(stored_material[MAT_LOG] - wood_per_process, 0)

	//Heat up the air instantly, magically
	if(sink)
		sink.temperature = target_heat_temperature
	else
		air2.temperature = target_heat_temperature
	update_icon()

/obj/machinery/atmospherics/binary/stationboiler/update_icon()
	if(ignited)
		icon_state = "boiler_on"
	else
		icon_state = "boiler_off"
	return 1

// Attept to load materials.  Returns 0 if item wasn't a stack of materials, otherwise 1 (even if failed to load)
/obj/machinery/atmospherics/binary/stationboiler/proc/try_load_materials(mob/user, obj/item/stack/material/S)
	if(!istype(S))
		return 0
	if(!(S.material.name in stored_material))
		to_chat(user, span_warning("\The [src] doesn't accept [material_display_name(S.material)]!"))
		return 1

	var/mat_name = S.material.name
	var/inserting_sheets = S.get_amount()
	var/remaining_stack_space = FLOOR((storage_capacity[mat_name] - stored_material[mat_name]) / S.perunit, 1)
	if(remaining_stack_space >= 1)
		inserting_sheets = min(inserting_sheets, remaining_stack_space)
		stored_material[mat_name] += inserting_sheets * S.perunit
		S.use(inserting_sheets)
		user.visible_message("\The [user] inserts [mat_name] into \the [src].", span_notice("You insert [inserting_sheets] [mat_name]\s into \the [src]."))
	else
		to_chat(user, span_warning("\The [src] cannot hold more [S.name]."))
	return 1

/obj/machinery/atmospherics/binary/stationboiler/attackby(obj/item/W as obj, mob/user as mob)
	add_fingerprint(user)
	if(try_load_materials(user, W))
		return
	else
		to_chat(user, span_notice("You cannot insert this item into \the [src]!"))
		return

// Start of "TGUI stuff"
/obj/machinery/atmospherics/binary/stationboiler/attack_ai(mob/user)
	add_hiddenprint(user)
	tgui_interact(user)

/obj/machinery/atmospherics/binary/stationboiler/attack_hand(mob/user)
	add_fingerprint(user)
	tgui_interact(user)

/obj/machinery/atmospherics/binary/stationboiler/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "StationBoiler", name)
		ui.open()

/obj/machinery/atmospherics/binary/stationboiler/tgui_act(action, params)
	if(..())
		return TRUE
	add_fingerprint(usr)

	switch(action)
		if("ejectMaterial")
			var/matName = params["mat"]
			if(!(matName in stored_material))
				return
			var/choice = tgui_alert(usr, "Would you like to eject a stack, everything or a specific amount from the boiler ","Station Boiler - Eject",list("Stack","Everything","Specific Amount"))
			switch(choice)
				if("Stack")
					eject_materials(matName, 0)
					. = TRUE
				if("Everything")
					eject_materials(matName, -1)
					. = TRUE
				if("Specific Amount")
					var/amount = tgui_input_number(usr, "How many logs would you like to Eject", "Station Boiler - Eject")
					if(amount <= 0)
						return
					eject_materials(matName, amount)
					. = TRUE

		if("ignite")
			try_ignite()
			. = TRUE

/obj/machinery/atmospherics/binary/stationboiler/tgui_data(mob/user)
	var/data[0]

	var/materials_ui[0]
	for(var/M in stored_material)
		materials_ui[++materials_ui.len] = list(
				"name" = M,
				"display" = material_display_name(M),
				"qty" = stored_material[M],
				"max" = storage_capacity[M],
				"percent" = (stored_material[M] / storage_capacity[M] * 100))
	data["materials"] = materials_ui

	data["timeleft"] = get_time_left()

	if(air1 && network1 && node1)
		data["input"] = list(
			"pressure" = air1.return_pressure(),
			"temp" = convert_k2c(air1.temperature))
	if(air2 && network2 && node2)
		data["output"] = list(
			"pressure" = air2.return_pressure(),
			"temp" = convert_k2c(air2.temperature))

	return data
// End of "TGUI stuff"

/obj/machinery/atmospherics/binary/stationboiler/proc/get_time_left()
	var/org_ticks = 0
	if(MAT_LOG in stored_material)
		org_ticks = stored_material[MAT_LOG]/wood_per_process
	var/second = org_ticks % 60
	var/minute = FLOOR((org_ticks / 60), 1) % 60
	var/hours = FLOOR((org_ticks / 3600), 1)
	return "[hours]:[minute]:[second]"

/obj/machinery/atmospherics/binary/stationboiler/ex_act(severity)
	return //Invincible machine

/obj/machinery/atmospherics/binary/stationboiler/fall_apart(severity = 3, scatter = TRUE)
	return //Invincible machine

/obj/machinery/atmospherics/binary/stationboiler/proc/try_ignite()
	if(stored_material[MAT_LOG] >= wood_per_process)
		ignited = TRUE
		update_icon()

// 0 amount = 0 means ejecting a full stack; -1 means eject everything
/obj/machinery/atmospherics/binary/stationboiler/proc/eject_materials(material_name, amount)
	var/datum/material/matdata = get_material_by_name(material_name)
	var/obj/item/stack/material/stack_type = matdata.stack_type
	var/stack_units = initial(stack_type.perunit)

	var/sheets_loaded = FLOOR(stored_material[material_name] / stack_units, 1)
	if(sheets_loaded < 1)
		return
	if(amount <= 0)
		amount = sheets_loaded
	// Drop stacks of sheets till empty
	while(amount >= 1)
		var/obj/item/stack/material/S = new stack_type(get_turf(src))
		var/export_amount = min(amount, S.max_amount)
		S.add(export_amount)
		stored_material[material_name] -= stack_units * export_amount
		amount -= export_amount
