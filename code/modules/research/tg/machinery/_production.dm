/obj/machinery/rnd/production
	name = "technology fabricator"
	desc = "Makes researched and prototype items with materials and energy."
	/// Energy cost per full stack of materials spent. Material insertion is 40% of this.
	active_power_usage = 5000
	// interaction_flags_atom = parent_type::interaction_flags_atom | INTERACT_ATOM_MOUSEDROP_IGNORE_CHECKS

	/// The efficiency coefficient. Material costs and print times are multiplied by this number;
	var/efficiency_coeff = 1
	/// The material storage used by this fabricator.
	var/datum/component/remote_materials/materials
	/// Which departments are allowed to process this design
	var/allowed_department_flags = ALL
	/// Icon state when production has started
	var/production_animation
	/// The types of designs this fabricator can print.
	var/allowed_buildtypes = NONE
	/// All designs in the techweb that can be fabricated by this machine, since the last update.
	var/list/datum/design_techweb/cached_designs
	/// What color is this machine's stripe? Leave null to not have a stripe.
	var/stripe_color = null
	///direction we output onto (if 0, on top of us)
	var/drop_direction = 0
	///looping sound for printing items
	var/datum/looping_sound/lathe_print/print_sound
	///made so we dont call addtimer() 40,000 times in on_techweb_update(). only allows addtimer() to be called on the first update
	var/techweb_updating = FALSE

/obj/machinery/rnd/production/Initialize(mapload)
	print_sound = new(list(src), FALSE)
	materials = AddComponent(
		/datum/component/remote_materials, \
		mapload, \
		mat_container_signals = list( \
			COMSIG_MATCONTAINER_ITEM_CONSUMED = TYPE_PROC_REF(/obj/machinery/rnd/production, local_material_insert)
		) \
	)

	cached_designs = list()

	. = ..()

	default_apply_parts()
	RefreshParts()
	update_icon()

/obj/machinery/rnd/production/Destroy()
	QDEL_NULL(print_sound)
	materials = null
	cached_designs = null
	return ..()

/obj/machinery/rnd/production/update_icon()
	cut_overlays()

	icon_state = "[initial(icon_state)][panel_open ? "_t" : ""]"

	if(!stripe_color)
		return

	var/mutable_appearance/stripe = mutable_appearance('icons/obj/machines/research_vr.dmi', "protolathe_stripe[panel_open ? "_t" : ""]")
	stripe.color = stripe_color
	add_overlay(stripe)

/obj/machinery/rnd/production/examine(mob/user, infix, suffix)
	. = ..()

	if(!in_range(user, src) && !isobserver(user))
		return

	. += span_notice("Material usage cost at <b>[efficiency_coeff * 100]%</b>")
	. += span_notice("Build time at <b>[efficiency_coeff * 100]%</b>")
	if(drop_direction)
		. += span_notice("Currently configured to drop printed objects <b>[dir2text(drop_direction)]</b>.")
		. += span_notice("Alt-click to reset.")
	else
		. += span_notice("Drag towards a direction (while next to it) to change drop direction.")

/obj/machinery/rnd/production/connect_techweb(datum/techweb/new_techweb)
	if(stored_research)
		UnregisterSignal(stored_research, list(COMSIG_TECHWEB_ADD_DESIGN, COMSIG_TECHWEB_REMOVE_DESIGN))
	return ..()

/obj/machinery/rnd/production/on_connected_techweb()
	. = ..()
	RegisterSignals(
		stored_research,
		list(COMSIG_TECHWEB_ADD_DESIGN, COMSIG_TECHWEB_REMOVE_DESIGN),
		TYPE_PROC_REF(/obj/machinery/rnd/production, on_techweb_update)
	)
	update_designs()

/// Updates the list of designs this fabricator can print.
/obj/machinery/rnd/production/proc/update_designs()
	PROTECTED_PROC(TRUE)
	techweb_updating = FALSE

	var/previous_design_count = cached_designs.len

	cached_designs.Cut()

	for(var/design_id in stored_research.researched_designs)
		var/datum/design_techweb/design = SSresearch.techweb_design_by_id(design_id)

		// TODO: only enable this if we port departmental techfabs
		// if((isnull(allowed_department_flags) || (design.departmental_flags & allowed_department_flags)) && (design.build_type & allowed_buildtypes))
		if(design.build_type & allowed_buildtypes)
			cached_designs |= design

	var/design_delta = cached_designs.len - previous_design_count

	if(design_delta > 0)
		atom_say("Received [design_delta] new design[design_delta == 1 ? "" : "s"].")
		playsound(src, 'sound/machines/twobeep.ogg', 50, TRUE)

	update_static_data_for_all_viewers()

/obj/machinery/rnd/production/proc/on_techweb_update()
	SIGNAL_HANDLER

	if(!techweb_updating) //so we batch these updates together
		techweb_updating = TRUE
		addtimer(CALLBACK(src, PROC_REF(update_designs)), 2 SECONDS)

/**
 * Consumes power for the item inserted either into silo or local storage.
 * Arguments
 *
 * * obj/item/item_inserted - the item to process
 * * list/mats_consumed - list of mats consumed
 * * amount_inserted - amount of material actually processed
 */
/obj/machinery/rnd/production/proc/process_item(obj/item/item_inserted, list/mats_consumed, amount_inserted)
	PRIVATE_PROC(TRUE)

	//we use initial(active_power_usage) because higher tier parts will have higher active usage but we have no benifit from it
	if(use_power_oneoff(ROUND_UP((amount_inserted / (MAX_STACK_SIZE * SHEET_MATERIAL_AMOUNT)) * 0.4 * initial(active_power_usage))))
		var/datum/material/highest_mat_ref

		var/highest_mat = 0
		for(var/datum/material/mat as anything in mats_consumed)
			var/present_mat = mats_consumed[mat]
			if(present_mat > highest_mat)
				highest_mat = present_mat
				highest_mat_ref = mat

		flick_animation(highest_mat_ref)
/**
 * Plays an visual animation when materials are inserted
 * Arguments
 *
 * * mat - the material ref we are trying to animate on the machine
 */
/obj/machinery/rnd/production/proc/flick_animation(datum/material/mat_ref)
	PROTECTED_PROC(TRUE)
	SHOULD_CALL_PARENT(FALSE)

	//first play the insertion animation
	flick_overlay_view_atom(material_insertion_animation(mat_ref), 1 SECONDS)

	//now play the progress bar animation
	flick_overlay_view_atom(mutable_appearance('icons/obj/machines/research_vr.dmi', "protolathe_progress"), 1 SECONDS)

///When materials are instered into local storage
/obj/machinery/rnd/production/proc/local_material_insert(container, obj/item/item_inserted, last_inserted_id, list/mats_consumed, amount_inserted, atom/context)
	SIGNAL_HANDLER

	process_item(item_inserted, mats_consumed, amount_inserted)

/obj/machinery/rnd/production/RefreshParts()
	. = ..()

	var/total_storage = 0
	for(var/obj/item/stock_parts/matter_bin/bin in component_parts)
		total_storage += bin.rating * 37.5 * SHEET_MATERIAL_AMOUNT
	materials.set_local_size(total_storage)

	efficiency_coeff = compute_efficiency()

	update_static_data_for_all_viewers()

///Computes this machines cost efficiency based on the available parts
/obj/machinery/rnd/production/proc/compute_efficiency()
	PROTECTED_PROC(TRUE)

	var/efficiency = 1.2
	for(var/obj/item/stock_parts/manipulator/manip in component_parts)
		efficiency -= manip.rating * 0.1

	return efficiency

/**
 * The cost efficiency for an particular design
 * Arguments
 *
 * * path - the design path to check for
 */
/obj/machinery/rnd/production/proc/build_efficiency(path)
	PRIVATE_PROC(TRUE)
	SHOULD_BE_PURE(TRUE)

	if(ispath(path, /obj/item/stack))
		return 1
	else
		return efficiency_coeff

/obj/machinery/rnd/production/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/sheetmaterials),
		get_asset_datum(/datum/asset/spritesheet_batched/research_designs)
	)

/obj/machinery/rnd/production/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	tgui_interact(user)

/obj/machinery/rnd/production/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Fabricator")
		ui.open()

/obj/machinery/rnd/production/tgui_static_data(mob/user)
	var/list/data = ..()

	var/list/designs = list()

	var/datum/asset/spritesheet_batched/research_designs/spritesheet = get_asset_datum(/datum/asset/spritesheet_batched/research_designs)
	var/size32x32 = "[spritesheet.name]32x32"

	var/coefficient
	for(var/datum/design_techweb/design in cached_designs)
		if(!(isnull(allowed_department_flags) || (design.departmental_flags & allowed_department_flags)))
			continue

		var/cost = list()

		coefficient = build_efficiency(design.build_path)
		for(var/mat_id in design.materials)
			cost[mat_id] = OPTIMAL_COST(design.materials[mat_id] * coefficient)

		var/icon_size = spritesheet.icon_size_id(design.id)
		designs[design.id] = list(
			"name" = design.name,
			"desc" = design.get_description(),
			"cost" = cost,
			"id" = design.id,
			"categories" = design.category,
			"icon" = "[icon_size == size32x32 ? "" : "[icon_size] "][design.id]"
		)

	data["designs"] = designs
	data["fabName"] = name

	var/list/material_data = materials.mat_container?.tgui_static_data(user)
	if(material_data)
		data += material_data

	return data

/obj/machinery/rnd/production/tgui_data(mob/user)
	var/list/data = list()

	var/list/material_data = materials.mat_container?.tgui_data(user)
	if(material_data)
		data["materials"] = material_data
	data["onHold"] = FALSE //materials.on_hold()
	data["busy"] = busy
	data["materialMaximum"] = materials.local_size
	data["queue"] = list()

	return data

/obj/machinery/rnd/production/tgui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("remove_mat")
			var/datum/material/material = GLOB.name_to_material[params["id"]]
			if(!istype(material))
				return

			var/amount = params["amount"]
			if(isnull(amount))
				return

			amount = text2num(amount)
			if(isnull(amount))
				return

			//we use initial(active_power_usage) because higher tier parts will have higher active usage but we have no benifit from it
			if(!use_power_oneoff(ROUND_UP((amount / MAX_STACK_SIZE) * 0.4 * initial(active_power_usage))))
				atom_say("No power to dispense sheets")
				return

			materials.eject_sheets(material, amount)
			return TRUE

		if("build")
			if(busy)
				atom_say("Warning: fabricator is busy!")
				return

			//validate design
			var/design_id = params["ref"]
			if(!design_id)
				return
			var/datum/design_techweb/design = stored_research.researched_designs[design_id] ? SSresearch.techweb_design_by_id(design_id) : null
			if(!istype(design))
				return FALSE
			if(!(isnull(allowed_department_flags) || (design.departmental_flags & allowed_department_flags)))
				atom_say("This fabricator does not have the necessary keys to decrypt this design.")
				return FALSE
			if(design.build_type && !(design.build_type & allowed_buildtypes))
				atom_say("This fabricator does not have the necessary manipulation systems for this design.")
				return FALSE

			//validate print quantity
			var/print_quantity = params["amount"]
			if(isnull(print_quantity))
				return
			print_quantity = text2num(print_quantity)
			if(isnull(print_quantity))
				return
			print_quantity = clamp(print_quantity, 1, 50)

			//efficiency for this design, stacks use exact materials
			var/coefficient = build_efficiency(design.build_path)

			//check for materials
			if(!materials.can_use_resource())
				return
			if(!materials.mat_container.has_materials(design.materials, coefficient, print_quantity))
				atom_say("Not enough materials to complete prototype[print_quantity > 1 ? "s" : ""].")
				return FALSE

			//compute power & time to print 1 item
			var/charge_per_item = 0
			for(var/material in design.materials)
				charge_per_item += design.materials[material]
			charge_per_item = ROUND_UP((charge_per_item / (MAX_STACK_SIZE * SHEET_MATERIAL_AMOUNT)) * coefficient * active_power_usage)
			var/build_time_per_item = (design.construction_time * design.lathe_time_factor * efficiency_coeff) ** 0.8

			//start production
			busy = TRUE
			SStgui.update_uis(src)
			print_sound.start()
			if(production_animation)
				icon_state = production_animation
			var/turf/target_location
			if(drop_direction)
				target_location = get_step(src, drop_direction)
				if(iswall(target_location))
					target_location = get_turf(src)
			else
				target_location = get_turf(src)
			addtimer(CALLBACK(src, PROC_REF(do_make_item), design, print_quantity, build_time_per_item, coefficient, charge_per_item, target_location), build_time_per_item)

			return TRUE

/**
 * Callback for start_making, actually makes the item
 * Arguments
 *
 * * datum/design/design - the design we are trying to print
 * * items_remaining - the number of designs left out to print
 * * build_time_per_item - the time taken to print 1 item
 * * material_cost_coefficient - the cost efficiency to print 1 design
 * * charge_per_item - the amount of power to print 1 item
 * * turf/target - the location to drop the printed item on
*/
/obj/machinery/rnd/production/proc/do_make_item(datum/design_techweb/design, items_remaining, build_time_per_item, material_cost_coefficient, charge_per_item, turf/target)
	PROTECTED_PROC(TRUE)

	if(!items_remaining) // how
		finalize_build()
		return

	if(stat & NOPOWER)
		atom_say("Unable to continue production, power failure.")
		finalize_build()
		return

	if(!use_power_oneoff(charge_per_item)) // provide the wait time until lathe is ready
		var/area/my_area = get_area(src)
		var/obj/machinery/power/apc/my_apc = my_area.apc
		if(!QDELETED(my_apc))
			atom_say("Unable to continue production, APC overload.")
		else
			atom_say("Unable to continue production, no APC in area.")
		finalize_build()
		return

	if(!materials.can_use_resource())
		atom_say("Unable to continue production, materials on hold.")
		finalize_build()
		return

	var/is_stack = ispath(design.build_path, /obj/item/stack)
	var/list/design_materials = design.materials
	if(!materials.mat_container.has_materials(design_materials, material_cost_coefficient, is_stack ? items_remaining : 1))
		atom_say("Unable to continue production, missing materials.")
		finalize_build()
		return
	materials.use_materials(design_materials, material_cost_coefficient, is_stack ? items_remaining : 1, "built", "[design.name]")

	var/atom/movable/created
	if(is_stack)
		var/obj/item/stack/stack_item = initial(design.build_path)
		var/max_stack_amount = initial(stack_item.max_amount)
		var/number_to_make = (initial(stack_item.amount) * items_remaining)
		while(number_to_make > max_stack_amount)
			created = new stack_item(null, max_stack_amount) //it's imporant to spawn things in nullspace, since obj's like stacks qdel when they enter a tile/merge with other stacks of the same type, resulting in runtimes.
			if(isitem(created))
				created.pixel_x = rand(-6, 6)
				created.pixel_y = rand(-6, 6)
			created.forceMove(target)
			number_to_make -= max_stack_amount

		created = new stack_item(null, number_to_make)
	else
		created = design.create_item(null)
		split_materials_uniformly(design_materials, material_cost_coefficient, created)

	if(isitem(created))
		created.pixel_x = rand(-6, 6)
		created.pixel_y = rand(-6, 6)
	// SSblackbox.record_feedback("nested tally", "lathe_printed_items", 1, list("[type]", "[created.type]"))
	created.forceMove(target)

	if(is_stack)
		items_remaining = 0
	else
		items_remaining -= 1

	if(!items_remaining)
		finalize_build()
		return
	addtimer(CALLBACK(src, PROC_REF(do_make_item), design, items_remaining, build_time_per_item, material_cost_coefficient, charge_per_item, target), build_time_per_item)

/// Resets the busy flag
/// Called at the end of do_make_item's timer loop
/obj/machinery/rnd/production/proc/finalize_build()
	PROTECTED_PROC(TRUE)
	print_sound.stop()
	busy = FALSE
	SStgui.update_uis(src)
	icon_state = initial(icon_state)

/obj/machinery/rnd/production/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	var/mob/user = usr
	if(!Adjacent(user))
		return
	if(isobserver(user) || user.is_incorporeal())
		return
	if(busy)
		balloon_alert(user, "busy printing!")
		return
	var/direction = get_dir(src, over_location)
	if(!direction)
		return
	drop_direction = direction
	balloon_alert(user, "dropping [dir2text(drop_direction)]")
