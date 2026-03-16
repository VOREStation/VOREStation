/obj/machinery/mecha_part_fabricator_tg
	icon = 'icons/obj/machines/robotics.dmi'
	icon_state = "fab-idle"
	name = "exosuit fabricator"
	desc = "Nothing is being built."
	anchored = TRUE
	density = TRUE
	req_access = list(ACCESS_ROBOTICS)
	circuit = /obj/item/circuitboard/mechfab
	speed_process = TRUE

	/// Type of designs to grab
	var/fab_type = MECHFAB

	/// Current items in the build queue.
	var/list/datum/design_techweb/queue = list()

	/// Whether or not the machine is building the entire queue automagically.
	var/process_queue = FALSE

	/// The current design datum that the machine is building.
	var/datum/design_techweb/being_built

	/// World time when the build will finish.
	var/build_finish = 0

	/// World time when the build started.
	var/build_start = 0

	/// The job ID of the part currently being processed. This is used for ordering list items for the client UI.
	var/top_job_id = 0

	/// Part currently stored in the Exofab.
	var/obj/item/stored_part

	/// Coefficient for the speed of item building. Based on the installed parts.
	var/time_coeff = 1

	/// Coefficient for the efficiency of material usage in item building. Based on the installed parts.
	var/component_coeff = 1

	/// Reference to the techweb.
	var/datum/techweb/stored_research

	/// Reference to a remote material inventory, such as an ore silo.
	var/datum/component/remote_materials/rmat

	/// All designs in the techweb that can be fabricated by this machine, since the last update.
	var/list/datum/design_techweb/cached_designs

	/// Looping sound for printing items
	var/datum/looping_sound/lathe_print/print_sound

	/// Local designs that only this mechfab have(using when mechfab emaged so it's illegal designs).
	var/list/datum/design_techweb/illegal_local_designs

	/// Direction the produced items will drop (0 means on top of us)
	var/drop_direction = SOUTH

/obj/machinery/mecha_part_fabricator_tg/Initialize(mapload)
	print_sound = new(list(src), FALSE)
	rmat = AddComponent( \
		/datum/component/remote_materials, \
		mapload, \
		mat_container_signals = list( \
			COMSIG_MATCONTAINER_ITEM_CONSUMED = TYPE_PROC_REF(/obj/machinery/mecha_part_fabricator_tg, AfterMaterialInsert) \
		))
	cached_designs = list()
	illegal_local_designs = list()
	. = ..()
	default_apply_parts()
	RefreshParts()
	update_icon()

/obj/machinery/mecha_part_fabricator_tg/Destroy()
	QDEL_NULL(print_sound)
	rmat = null
	return ..()

/obj/machinery/mecha_part_fabricator_tg/Initialize(mapload)
	. = ..()
	if(!stored_research)
		CONNECT_TO_RND_SERVER_ROUNDSTART(stored_research, src)
	if(stored_research)
		on_connected_techweb()

/obj/machinery/mecha_part_fabricator_tg/proc/connect_techweb(datum/techweb/new_techweb)
	if(stored_research)
		UnregisterSignal(stored_research, list(COMSIG_TECHWEB_ADD_DESIGN, COMSIG_TECHWEB_REMOVE_DESIGN))
	stored_research = new_techweb
	if(!isnull(stored_research))
		on_connected_techweb()

/obj/machinery/mecha_part_fabricator_tg/proc/on_connected_techweb()
	RegisterSignals(
		stored_research,
		list(COMSIG_TECHWEB_ADD_DESIGN, COMSIG_TECHWEB_REMOVE_DESIGN),
		PROC_REF(on_techweb_update)
	)
	update_menu_tech()

// /obj/machinery/mecha_part_fabricator_tg/multitool_act(mob/living/user, obj/item/multitool/tool)
// 	if(!QDELETED(tool.buffer) && istype(tool.buffer, /datum/techweb))
// 		connect_techweb(tool.buffer)
// 	return TRUE

/obj/machinery/mecha_part_fabricator_tg/proc/on_techweb_update()
	SIGNAL_HANDLER

	// We're probably going to get more than one update (design) at a time, so batch
	// them together.
	addtimer(CALLBACK(src, PROC_REF(update_menu_tech)), 2 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

/obj/machinery/mecha_part_fabricator_tg/RefreshParts()
	. = ..()
	var/T = 0

	//maximum stocking amount (default 300000, 600000 at T4)
	for(var/obj/item/stock_parts/matter_bin/matter_bin in component_parts)
		T += matter_bin.rating
	rmat.set_local_size(((100 * SHEET_MATERIAL_AMOUNT) + (T * (25 * SHEET_MATERIAL_AMOUNT))))

	//resources adjustment coefficient (1 -> 0.85 -> 0.7 -> 0.55)
	T = 1.15
	for(var/obj/item/stock_parts/micro_laser/micro_laser in component_parts)
		T -= micro_laser.rating * 0.15
	component_coeff = T

	//building time adjustment coefficient (1 -> 0.8 -> 0.6)
	T = -1
	for(var/obj/item/stock_parts/manipulator/manip in component_parts)
		T += manip.rating
	time_coeff = round(initial(time_coeff) - (initial(time_coeff)*(T))/5,0.01)

	// Adjust the build time of any item currently being built.
	if(being_built)
		var/last_const_time = build_finish - build_start
		var/new_const_time = get_construction_time_w_coeff(initial(being_built.construction_time))
		var/const_time_left = build_finish - world.time
		var/new_build_time = (new_const_time / last_const_time) * const_time_left
		build_finish = world.time + new_build_time

	update_static_data_for_all_viewers()

/obj/machinery/mecha_part_fabricator_tg/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("The status display reads: Storing up to <b>[rmat.local_size]</b> material units.<br>Material consumption at <b>[component_coeff*100]%</b>.<br>Build time reduced by <b>[100-time_coeff*100]%</b>.")
		. += span_notice("Currently configured to drop printed objects <b>[dir2text(drop_direction)]</b>.")

/obj/machinery/mecha_part_fabricator_tg/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	var/mob/user = usr
	if(!Adjacent(user))
		return
	if(isobserver(user) || user.is_incorporeal())
		return
	if(being_built)
		balloon_alert(user, "cannot reorient whilst printing!")
		return
	var/direction = get_dir(src, over_location)
	if(!direction)
		return
	drop_direction = direction
	balloon_alert(user, "dropping [dir2text(drop_direction)]")

/**
 * Updates the `final_sets` and `buildable_parts` for the current mecha fabricator.
 */
/obj/machinery/mecha_part_fabricator_tg/proc/update_menu_tech()
	var/previous_design_count = cached_designs.len

	cached_designs.Cut()
	for(var/v in stored_research.researched_designs)
		var/datum/design_techweb/design = SSresearch.techweb_design_by_id(v)

		if(design.build_type & fab_type)
			cached_designs |= design

	for(var/datum/design_techweb/illegal_disign in illegal_local_designs)
		cached_designs |= illegal_disign

	var/design_delta = cached_designs.len - previous_design_count

	if(design_delta > 0)
		atom_say("Received [design_delta] new design[design_delta == 1 ? "" : "s"].")
		playsound(src, 'sound/machines/twobeep.ogg', 50, TRUE)

	update_static_data_for_all_viewers()

/**
 * Intended to be called when an item starts printing.
 *
 * Adds the overlay to show the fab working and sets active power usage settings.
 */
/obj/machinery/mecha_part_fabricator_tg/proc/on_start_printing()
	add_overlay("fab-active")
	update_use_power(USE_POWER_ACTIVE)
	print_sound.start()

/**
 * Intended to be called when the exofab has stopped working and is no longer printing items.
 *
 * Removes the overlay to show the fab working and sets idle power usage settings. Additionally resets the description and turns off queue processing.
 */
/obj/machinery/mecha_part_fabricator_tg/proc/on_finish_printing()
	cut_overlay("fab-active")
	update_use_power(USE_POWER_IDLE)
	desc = initial(desc)
	process_queue = FALSE
	print_sound.stop()

/**
 * Attempts to build the next item in the build queue.
 *
 * Returns FALSE if either there are no more parts to build or the next part is not buildable.
 * Returns TRUE if the next part has started building.
 * * verbose - Whether the machine should use atom_say() procs. Set to FALSE to disable the machine saying reasons for failure to build.
 */
/obj/machinery/mecha_part_fabricator_tg/proc/build_next_in_queue(verbose = TRUE)
	if(!length(queue))
		return FALSE

	var/datum/design_techweb/D = queue[1]
	if(build_part(D, verbose))
		remove_from_queue(1)
		return TRUE

	return FALSE

/**
 * Starts the build process for a given design datum.
 *
 * Returns FALSE if the procedure fails. Returns TRUE when being_built is set.
 * Uses materials.
 * * D - Design datum to attempt to print.
 * * verbose - Whether the machine should use atom_say() procs. Set to FALSE to disable the machine saying reasons for failure to build.
 */
/obj/machinery/mecha_part_fabricator_tg/proc/build_part(datum/design_techweb/D, verbose = TRUE)
	if(!D || length(D.reagents_list))
		return FALSE

	var/turf/exit = get_step(src, drop_direction)
	if(exit.density)
		if(verbose)
			atom_say("Warning. Exit port obstructed. Please clear obstructions or reorient machine, then retry.")
		return FALSE

	var/datum/component/material_container/materials = rmat.mat_container
	if (!materials)
		if(verbose)
			atom_say("No access to material storage, please contact the quartermaster.")
		return FALSE
	if (rmat.on_hold())
		if(verbose)
			atom_say("Mineral access is on hold, please contact the quartermaster.")
		return FALSE
	if(!materials.has_materials(D.materials, component_coeff))
		if(verbose)
			atom_say("Not enough resources. Processing stopped.")
		return FALSE

	rmat.use_materials(D.materials, component_coeff, 1, "built", "[D.name]")
	being_built = D
	build_finish = world.time + get_construction_time_w_coeff(initial(D.construction_time))
	build_start = world.time
	desc = "It's building \a [D.name]."

	return TRUE

/obj/machinery/mecha_part_fabricator_tg/process()
	var/turf/exit = get_step(src, drop_direction)
	// If there's a stored part to dispense due to an obstruction, try to dispense it.
	if(stored_part)
		if(exit.density)
			return TRUE

		atom_say("Obstruction cleared. The fabrication of [stored_part] is now complete.")
		stored_part.forceMove(exit)
		stored_part = null

	if(!process_queue)
		return

	// If there's nothing being built, try to build something
	if(!being_built)
		// First, check if it's safe to actually print anything; if not, abort now!
		if(exit.density)
			atom_say("Warning. Exit port obstructed. Please clear obstructions or reorient machine, then retry.")
			process_queue = FALSE
			return
		// If we're not processing the queue anymore or there's nothing to build, end processing.
		if(!process_queue || !build_next_in_queue())
			on_finish_printing()
			return TRUE
		on_start_printing()

	// If there's an item being built, check if it is complete.
	if(being_built && (build_finish < world.time))
		// Then attempt to dispense it and if appropriate build the next item.
		dispense_built_part(being_built)
		if(process_queue)
			build_next_in_queue(FALSE)
		return TRUE

/**
 * Dispenses a part to the tile infront of the Exosuit Fab.
 *
 * Returns FALSE is the machine cannot dispense the part on the appropriate turf.
 * Return TRUE if the part was successfully dispensed.
 * * dispensed_design - Design datum to attempt to dispense.
 */
/obj/machinery/mecha_part_fabricator_tg/proc/dispense_built_part(datum/design_techweb/dispensed_design)
	var/obj/item/built_part = create_new_part(dispensed_design)
	split_materials_uniformly(dispensed_design.materials, component_coeff, built_part)

	being_built = null

	var/turf/exit = get_step(src, drop_direction)
	if(exit.density)
		atom_say("Error! The part outlet is obstructed.")
		desc = "It's trying to dispense the fabricated [dispensed_design.name], but the part outlet is obstructed."
		stored_part = built_part
		return FALSE

	atom_say("The fabrication of [built_part] is now complete.")
	built_part.forceMove(exit)

	top_job_id += 1

	return TRUE

/**
 * Creates parts as necessary (overridden by the prosfab)
 */
/obj/machinery/mecha_part_fabricator_tg/proc/create_new_part(datum/design_techweb/dispensed_design)
	return dispensed_design.create_item(src)

/**
 * Adds a datum design to the build queue.
 *
 * Returns TRUE if successful and FALSE if the design was not added to the queue.
 * * D - Datum design to add to the queue.
 */
/obj/machinery/mecha_part_fabricator_tg/proc/add_to_queue(datum/design_techweb/D)
	if(!istype(queue))
		queue = list()

	if(D)
		queue[++queue.len] = D
		return TRUE

	return FALSE

/**
 * Removes datum design from the build queue based on index.
 *
 * Returns TRUE if successful and FALSE if a design was not removed from the queue.
 * * index - Index in the build queue of the element to remove.
 */
/obj/machinery/mecha_part_fabricator_tg/proc/remove_from_queue(index)
	if(!isnum(index) || !ISINTEGER(index) || !istype(queue) || (index<1 || index>length(queue)))
		return FALSE
	queue.Cut(index,++index)
	return TRUE

/**
 * Calculates the coefficient-modified build time of a design.
 *
 * Returns coefficient-modified build time of a given design.
 * * D - Design datum to calculate the modified build time of.
 * * roundto - Rounding value for round() proc
 */
/obj/machinery/mecha_part_fabricator_tg/proc/get_construction_time_w_coeff(construction_time, roundto = 1) //aran
	return round(construction_time*time_coeff, roundto)

/obj/machinery/mecha_part_fabricator_tg/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/sheetmaterials),
		get_asset_datum(/datum/asset/spritesheet_batched/research_designs)
	)

/obj/machinery/mecha_part_fabricator_tg/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	tgui_interact(user)

/obj/machinery/mecha_part_fabricator_tg/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ExosuitFabricatorTg", name)
		ui.open()

/obj/machinery/mecha_part_fabricator_tg/tgui_static_data(mob/user)
	var/list/data = ..()

	var/list/designs = list()

	var/datum/asset/spritesheet_batched/research_designs/spritesheet = get_asset_datum(/datum/asset/spritesheet_batched/research_designs)
	var/size32x32 = "[spritesheet.name]32x32"

	for(var/datum/design_techweb/design in cached_designs)
		var/cost = list()
		var/list/materials = design.materials
		for(var/mat_id in materials)
			cost[mat_id] = OPTIMAL_COST(materials[mat_id] * component_coeff)

		var/icon_size = spritesheet.icon_size_id(design.id)
		designs[design.id] = list(
			"name" = design.name,
			"desc" = design.get_description(),
			"cost" = cost,
			"id" = design.id,
			"categories" = design.category,
			"icon" = "[icon_size == size32x32 ? "" : "[icon_size] "][design.id]",
			"constructionTime" = get_construction_time_w_coeff(design.construction_time)
		)

	data["designs"] = designs

	var/list/material_data = rmat.mat_container?.tgui_static_data(user)
	if(material_data)
		data += material_data

	return data

/obj/machinery/mecha_part_fabricator_tg/tgui_data(mob/user)
	var/list/data = list()

	var/list/material_data =rmat.mat_container?.tgui_data(user)
	if(material_data)
		data["materials"] = material_data
	data["queue"] = list()
	data["processing"] = process_queue

	if(being_built)
		data["queue"] += list(list(
			"jobId" = top_job_id,
			"designId" = being_built.id,
			"processing" = TRUE,
			"timeLeft" = (build_finish - world.time)
		))

	var/offset = 0

	for(var/datum/design_techweb/design in queue)
		offset += 1

		data["queue"] += list(list(
			"jobId" = top_job_id + offset,
			"designId" = design.id,
			"processing" = FALSE,
			"timeLeft" = get_construction_time_w_coeff(design.construction_time) / 10
		))

	return data

/obj/machinery/mecha_part_fabricator_tg/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()

	if(.)
		return

	. = TRUE

	switch(action)
		if("build")
			var/designs = params["designs"]

			if(!islist(designs))
				return

			for(var/design_id in designs)
				if(!istext(design_id))
					continue

				if(!(stored_research.researched_designs.Find(design_id) || is_type_in_list(SSresearch.techweb_design_by_id(design_id), illegal_local_designs)))
					continue

				var/datum/design_techweb/design = SSresearch.techweb_design_by_id(design_id)

				if(!(design.build_type & fab_type) || design.id != design_id)
					continue

				add_to_queue(design)

			if(params["now"])
				if(process_queue)
					return

				process_queue = TRUE
			return

		if("del_queue_part")
			// Delete a specific from the queue
			var/index = text2num(params["index"])
			remove_from_queue(index)

			return

		if("clear_queue")
			// Delete everything from queue
			queue.Cut()

			return

		if("build_queue")
			// Build everything in queue
			if(process_queue)
				return

			process_queue = TRUE
			return

		if("stop_queue")
			// Pause queue building. Also known as stop.
			process_queue = FALSE
			return

		if("remove_mat")
			var/datum/material/material = GET_MATERIAL_REF(params["id"])
			if(!istype(material))
				return

			var/amount = params["amount"]
			if(isnull(amount))
				return

			amount = text2num(amount)
			if(isnull(amount))
				return

			rmat.eject_sheets(material, amount)
			return TRUE

	return FALSE

/obj/machinery/mecha_part_fabricator_tg/proc/AfterMaterialInsert(item_inserted, id_inserted, amount_inserted)
	// var/datum/material/M = id_inserted // Not used atm.
	add_overlay("fab-load-metal")
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, cut_overlay), "fab-load-metal"), 1 SECONDS)

/obj/machinery/mecha_part_fabricator_tg/update_icon()
	if(panel_open)
		icon_state = "fab-o"
	else
		icon_state = "fab-idle"

/obj/machinery/mecha_part_fabricator_tg/attackby(obj/item/W, mob/user, attack_modifier, click_parameters)
	add_fingerprint(user)

	if(being_built)
		to_chat(user, span_warning("\The [src] is currently processing! Please wait until completion."))
		return FALSE

	if(default_deconstruction_screwdriver(user, W))
		update_icon()
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return
	if(default_unfasten_wrench(user, W, 2 SECONDS))
		return

	return ..()
