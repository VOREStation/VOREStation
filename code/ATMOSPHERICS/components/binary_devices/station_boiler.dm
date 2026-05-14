/obj/structure/stationboiler
	name = "Station Boiler"
	desc = "A large, phoron-infused wood powered, super boiler. Capable of keeping a entire colony heated up"
	icon = 'icons/obj/machines/heat_boiler.dmi'
	icon_state = "boiler_off"
	anchored = TRUE
	density = TRUE
	pixel_x = -32
	layer = UNDER_JUNK_LAYER

	VAR_PRIVATE/is_active = FALSE // Check init for actual auto startup
	VAR_PRIVATE/target_heat_temperature = T20C //The temperature we want the pipes to be heated to
	VAR_PRIVATE/wood_per_process = 1SECOND
	VAR_PRIVATE/list/stored_material =  list(
			MAT_LOG 			= 1 HOUR, //1 hour of mats free
			MAT_WOODEN_STICK	= 0,
			MAT_WOOD			= 0,
			MAT_SIFWOOD			= 0,
			MAT_SIFLOG			= 0,
			MAT_HARDWOOD		= 0,
			MAT_HARDLOG			= 0,
			MAT_WOODEN_STICK	= 0,
			MAT_BIRCHWOOD		= 0,
			MAT_PINEWOOD		= 0,
			MAT_OAKWOOD			= 0,
			MAT_ACACIAWOOD		= 0,
			MAT_REDWOOD			= 0,
		)
	VAR_PRIVATE/storage_capacity = 4 HOURS
	VAR_PRIVATE/datum/looping_sound/oven/boiler_loop

/obj/structure/stationboiler/Initialize(mapload)
	. = ..()
	SSstationheater.boilers += src
	update_icon()
	START_PROCESSING(SSobj, src)
	boiler_loop = new(list(src), FALSE)
	set_state(TRUE)

/obj/structure/stationboiler/Destroy()
	QDEL_NULL(boiler_loop)
	STOP_PROCESSING(SSobj, src)
	SSstationheater.boilers -= src
	. = ..()

/obj/structure/stationboiler/process()
	var/list/available_mats = list()
	for(var/mat_check in stored_material)
		if(stored_material[mat_check] <= 0)
			continue
		available_mats += mat_check

	if(!length(available_mats)) //Out of wood
		set_state(FALSE)
		return

	var/mat_drain = pick(available_mats)
	stored_material[mat_drain] = max(stored_material[mat_drain] - wood_per_process, 0)

/obj/structure/stationboiler/proc/set_state(activated)
	if(activated == is_active)
		return
	is_active = activated
	update_icon()
	if(is_active)
		set_light(4, 3, "#e9400dff")
		boiler_loop.start(src)
		return
	set_light(0)
	boiler_loop.stop(src)

/obj/structure/stationboiler/update_icon()
	if(is_active)
		icon_state = "boiler_on"
		return
	icon_state = "boiler_off"

/obj/structure/stationboiler/attack_ai(mob/user)
	add_hiddenprint(user)
	tgui_interact(user)

/obj/structure/stationboiler/attack_hand(mob/user)
	add_fingerprint(user)
	tgui_interact(user)

/obj/structure/stationboiler/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "StationBoiler", name)
		ui.open()

/obj/structure/stationboiler/tgui_act(action, params)
	if(..())
		return TRUE
	switch(action)
		if("ejectMaterial")
			var/matName = params["mat"]
			if(!(matName in stored_material))
				return FALSE
			eject_materials(matName)
			return TRUE

		if("ignite")
			try_ignite()
			return TRUE

/obj/structure/stationboiler/tgui_data(mob/user)
	var/list/data = list()
	var/list/materials_ui = list()
	for(var/M in stored_material)
		if(stored_material[M] > 0)
			var/datum/material/matdata = get_material_by_name(M)
			var/obj/item/stack/material/stack_type = matdata.stack_type
			var/stack_units = initial(stack_type.perunit)
			var/sheet_count = FLOOR(stored_material[M] / stack_units, 1)
			materials_ui[++materials_ui.len] = list(
				"name" = M,
				"display" = material_display_name(M),
				"qty" = "[sheet_count] [sheet_count > 1 ? matdata.sheet_plural_name : matdata.sheet_singular_name]", // Show the number of sheets
				"can_eject" = (stored_material[M] >= stack_units))
	data["materials"] = materials_ui

	var/mat_store = get_total_stored_mats()
	data["stored"] = mat_store
	data["max"] = storage_capacity
	data["timeleft"] = get_time_left()

	return data

/obj/structure/stationboiler/proc/get_total_stored_mats()
	var/mat_store = 0
	for(var/mat_check in stored_material)
		mat_store += stored_material[mat_check]
	return mat_store

/obj/structure/stationboiler/proc/get_time_left()
	var/org_ticks = get_total_stored_mats()/wood_per_process
	var/second = org_ticks % 60
	var/minute = FLOOR((org_ticks / 60), 1) % 60
	var/hours = FLOOR((org_ticks / 3600), 1)
	if(second < 10)
		second = "0[second]"
	if(minute < 10)
		minute = "0[minute]"
	return "[hours]:[minute]:[second]"

/obj/structure/stationboiler/ex_act(severity)
	return

/obj/structure/stationboiler/proc/try_ignite()
	if(stored_material[MAT_LOG] >= wood_per_process)
		set_state(TRUE)

/obj/structure/stationboiler/proc/is_heating()
	return is_active

/obj/structure/stationboiler/proc/is_on_same_planet(obj/machinery/stationboiler_radiator/rad)
	var/turf/rad_turf = get_turf(rad)
	var/turf/our_turf = get_turf(src)
	return AreConnectedZLevels(rad_turf.z,our_turf.z)

/obj/structure/stationboiler/proc/try_load_materials(mob/user, obj/item/stack/material/S)
	if(!istype(S))
		return FALSE

	// Can we even put the material in?
	if(!(S.material.name in stored_material))
		to_chat(user, span_warning("\The [src] doesn't accept [material_display_name(S.material)]!"))
		return TRUE

	// Check if there is room left to store a sheet of the material
	var/remaining_stack_space = FLOOR((storage_capacity - get_total_stored_mats()) / S.perunit, 1)
	if(remaining_stack_space < 1)
		to_chat(user, span_warning("\The [src] cannot hold more [S.name]."))
		return TRUE

	// Put the material in, convert the sheet into material units
	var/mat_name = S.material.name
	var/inserting_sheets = S.get_amount()
	inserting_sheets = min(inserting_sheets, remaining_stack_space)
	stored_material[mat_name] += inserting_sheets * S.perunit
	S.use(inserting_sheets)
	user.visible_message("\The [user] inserts [mat_name] into \the [src].", span_notice("You insert [inserting_sheets] [mat_name]\s into \the [src]."))
	return TRUE

/obj/structure/stationboiler/attackby(obj/item/W as obj, mob/user as mob)
	add_fingerprint(user)
	if(try_load_materials(user, W))
		return
	else
		to_chat(user, span_notice("You cannot insert this item into \the [src]!"))
		return

// 0 amount = 0 means ejecting a full stack; -1 means eject everything
/obj/structure/stationboiler/proc/eject_materials(material_name)
	var/datum/material/matdata = get_material_by_name(material_name)
	var/obj/item/stack/material/stack_type = matdata.stack_type
	var/stack_units = initial(stack_type.perunit)

	var/sheets_loaded = FLOOR(stored_material[material_name] / stack_units, 1)
	if(sheets_loaded < 1)
		return
	var/amount = sheets_loaded

	// Drop stacks of sheets till empty
	while(amount >= 1)
		var/obj/item/stack/material/S = new stack_type(get_turf(src))
		var/export_amount = min(amount, S.max_amount)
		S.set_amount(export_amount)
		S.update_icon()
		stored_material[material_name] -= stack_units * export_amount
		amount -= export_amount
