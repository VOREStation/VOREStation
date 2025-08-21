
/obj/item/integrated_circuit_printer
	name = "integrated circuit printer"
	desc = "A portable(ish) machine made to print tiny modular circuitry out of metal."
	icon = 'icons/obj/integrated_electronics/electronic_tools.dmi'
	icon_state = "circuit_printer"
	w_class = ITEMSIZE_LARGE
	var/metal = 0
	var/max_metal = 100
	var/metal_per_sheet = 10 // One sheet equals this much metal.
	var/debug = FALSE // If true, metal is infinite.

	var/upgraded = FALSE		// When hit with an upgrade disk, will turn true, allowing it to print the higher tier circuits.
	var/illegal_upgraded = FALSE // When hit with an illegal upgrade disk, will turn true, allowing it to print the illegal circuits.
	var/can_clone = FALSE		// Same for above, but will allow the printer to duplicate a specific assembly.
	var/dirty_items = FALSE

/obj/item/integrated_circuit_printer/all_upgrades
	upgraded = TRUE
	illegal_upgraded = TRUE
	can_clone = TRUE

/obj/item/integrated_circuit_printer/illegal
	illegal_upgraded = TRUE
	can_clone = TRUE

/obj/item/integrated_circuit_printer/upgraded
	upgraded = TRUE
	can_clone = TRUE

/obj/item/integrated_circuit_printer/debug
	name = "fractal integrated circuit printer"
	desc = "A portable(ish) machine that makes modular circuitry seemingly out of thin air."
	upgraded = TRUE
	illegal_upgraded = TRUE
	can_clone = TRUE
	debug = TRUE

/obj/item/integrated_circuit_printer/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return tgui_interact(user)
	else
		return ..()

/obj/item/integrated_circuit_printer/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/stack = O
		if(stack.material.name == MAT_STEEL)
			if(debug)
				to_chat(user, span_warning("\The [src] does not need any material."))
				return
			var/num = min((max_metal - metal) / metal_per_sheet, stack.get_amount())
			if(num < 1)
				to_chat(user, span_warning("\The [src] is too full to add more metal."))
				return
			if(stack.use(max(1, round(num)))) // We don't want to create stacks that aren't whole numbers
				to_chat(user, span_notice("You add [num] sheet\s to \the [src]."))
				metal += num * metal_per_sheet
				attack_self(user)
				return TRUE

	if(istype(O,/obj/item/integrated_circuit))
		to_chat(user, span_notice("You insert the circuit into \the [src]."))
		user.unEquip(O)
		metal = min(metal + O.w_class, max_metal)
		qdel(O)
		attack_self(user)
		return TRUE

	if(istype(O,/obj/item/disk/integrated_circuit/upgrade/advanced))
		if(upgraded)
			to_chat(user, span_warning("\The [src] already has this upgrade."))
			return TRUE
		to_chat(user, span_notice("You install \the [O] into  \the [src]."))
		upgraded = TRUE
		dirty_items = TRUE
		attack_self(user)
		return TRUE

	if(istype(O,/obj/item/disk/integrated_circuit/upgrade/illegal))
		if(illegal_upgraded)
			to_chat(user, span_warning("\The [src] already has this upgrade."))
			return TRUE
		to_chat(user, span_notice("You install \the [O] into  \the [src]."))
		illegal_upgraded = TRUE
		dirty_items = TRUE
		attack_self(user)
		return TRUE

	if(istype(O,/obj/item/disk/integrated_circuit/upgrade/clone))
		if(can_clone)
			to_chat(user, span_warning("\The [src] already has this upgrade."))
			return TRUE
		to_chat(user, span_notice("You install \the [O] into  \the [src]."))
		can_clone = TRUE
		attack_self(user)
		return TRUE

	return ..()

/obj/item/integrated_circuit_printer/vv_edit_var(var_name, var_value)
	// Gotta update the static data in case an admin VV's the upgraded var for some reason..!
	if(var_name == "upgraded")
		dirty_items = TRUE
	return ..()

/obj/item/integrated_circuit_printer/attack_self(var/mob/user)
	tgui_interact(user)

/obj/item/integrated_circuit_printer/tgui_state(mob/user)
	return GLOB.tgui_physical_state

/obj/item/integrated_circuit_printer/tgui_interact(mob/user, datum/tgui/ui)
	if(dirty_items)
		update_tgui_static_data(user, ui)
		dirty_items = FALSE

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ICPrinter", name) // 500, 600
		ui.open()

/obj/item/integrated_circuit_printer/tgui_static_data(mob/user)
	var/list/data = ..()

	var/list/categories = list()
	for(var/category in SScircuit.circuit_fabricator_recipe_list)
		var/list/cat_obj = list(
			"name" = category,
			"items" = null
		)
		if(cat_obj["name"] == "Illegal Parts" && !illegal_upgraded)
			continue
		var/list/circuit_list = SScircuit.circuit_fabricator_recipe_list[category]
		var/list/items = list()
		for(var/path in circuit_list)
			var/obj/O = path
			var/can_build = TRUE

			if(ispath(path, /obj/item/integrated_circuit))
				var/obj/item/integrated_circuit/IC = path
				if((initial(IC.spawn_flags) & IC_SPAWN_RESEARCH) && (!(initial(IC.spawn_flags) & IC_SPAWN_DEFAULT)) && !upgraded)
					can_build = FALSE

			var/cost = 1
			if(ispath(path, /obj/item/electronic_assembly))
				var/obj/item/electronic_assembly/E = path
				cost = round((initial(E.max_complexity) + initial(E.max_components)) / 4)
			else
				var/obj/item/I = path
				cost = initial(I.w_class)

			items.Add(list(list(
				"name" = initial(O.name),
				"desc" = initial(O.desc),
				"can_build" = can_build,
				"cost" = cost,
				"path" = path,
			)))

		cat_obj["items"] = items
		categories.Add(list(cat_obj))
	data["categories"] = categories

	return data

/obj/item/integrated_circuit_printer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["metal"] = metal
	data["max_metal"] = max_metal
	data["metal_per_sheet"] = metal_per_sheet
	data["debug"] = debug
	data["upgraded"] = upgraded
	data["can_clone"] = can_clone

	return data

/obj/item/integrated_circuit_printer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(ui.user)

	switch(action)
		if("import_circuit")
			if(!can_clone)
				to_chat(ui.user, span_warning("This printer requires a clone upgrade disk to import circuit designs!"))
				return TRUE

			handle_circuit_import(ui.user)
			return TRUE
		if("build")
			var/build_type = text2path(params["build"])
			if(!build_type || !ispath(build_type))
				return 1

			var/cost = 1

			if(ispath(build_type, /obj/item/electronic_assembly))
				var/obj/item/electronic_assembly/E = build_type
				cost = round( (initial(E.max_complexity) + initial(E.max_components) ) / 4)
			else
				var/obj/item/I = build_type
				cost = initial(I.w_class)

			var/in_some_category = FALSE
			for(var/category in SScircuit.circuit_fabricator_recipe_list)
				if(build_type in SScircuit.circuit_fabricator_recipe_list[category])
					in_some_category = TRUE
					break
			if(!in_some_category)
				return

			if(!debug)
				if(!Adjacent(ui.user))
					to_chat(ui.user, span_notice("You are too far away from \the [src]."))
				if(metal - cost < 0)
					to_chat(ui.user, span_warning("You need [cost] metal to build that!."))
					return 1
				metal -= cost
			var/obj/item/built = new build_type(get_turf(loc))
			ui.user.put_in_hands(built)
			to_chat(ui.user, span_notice("[capitalize(built.name)] printed."))
			playsound(src, 'sound/items/jaws_pry.ogg', 50, TRUE)
			return TRUE

/**
 * Imports a circuit design from JSON data
 * This uses the same logic as the vrdb/html vore belly imports
 *
 * @param user The user importing the circuit
 * @param circuit_data JSON string containing the circuit data
 */
/obj/item/integrated_circuit_printer/proc/check_interactivity(mob/user)
	return user.Adjacent(src)

/obj/item/integrated_circuit_printer/proc/handle_circuit_import(mob/user)
	if(!user || user.stat || user.restrained() || !Adjacent(user))
		return

	var/input_file = input(user, "Please choose a circuit JSON file to import.", "Import Circuit") as file
	if(!input_file)
		return

	var/file_size = length(file2text(input_file))
	if(file_size > 1048576 / 4) // quarter of a megabyte.
		to_chat(user, span_warning("File too large! Circuit files must be smaller than 1MB. Your file is [num2text(file_size)] bytes."))
		return

	if(file_size < 10)
		to_chat(user, span_warning("This doesn't appear to be a valid circuit file."))
		return

	var/input_data
	try
		input_data = file2text(input_file)
	catch(var/exception/e)
		to_chat(user, span_warning("Failed to read file: [e]. Please ensure you selected a valid text/JSON file."))
		return

	if(!input_data || length(input_data) < 10)
		to_chat(user, span_warning("The selected file is empty or unreadable. Please select a valid circuit JSON file."))
		return

	// Basic JSON validation.
	if(!findtext(input_data, "{"))
		// If it doesn't contain basic JSON characters, it's likely not a JSON file
		to_chat(user, span_warning("Invalid file format! Please select a JSON file containing circuit data. (File appears to be binary or non-text format)"))
		return

	// Additional validation to prevent binary files..
	if(findtext(input_data, "\xFF\xD8\xFF") || findtext(input_data, "\x89PNG") || findtext(input_data, "GIF89a") || findtext(input_data, "GIF87a"))
		to_chat(user, span_warning("Invalid file type! You selected an image file. Please select a JSON text file containing circuit data."))
		return

	// Check if the input is Base64 encoded and decode it
	if(length(input_data) > 0 && !findtext(input_data, "{"))
		// If it doesn't contain '{' it's likely Base64 encoded JSON
		var/decoded_data = rustg_decode_base64(input_data)
		if(decoded_data && length(decoded_data) > 0)
			input_data = decoded_data
		else
			to_chat(user, span_warning("Unable to decode file data. Please select a valid circuit JSON file."))
			return

	import_circuit(user, input_data, FALSE, null)

/obj/item/integrated_circuit_printer/proc/import_circuit(mob/user, circuit_data, override_type = FALSE, custom_type = null)
	if(!circuit_data)
		var/input = null
		try
			input = input(user, "Paste the circuit data here (supports up to 32KB):", "Import Circuit", "") as text
		catch
			to_chat(user, span_warning("Input dialog failed! Please try again."))
			return

		if(!input || !user || user.stat || user.restrained() || !Adjacent(user))
			return

		circuit_data = input

		// Check if the input is Base64 encoded and decode it
		if(length(circuit_data) > 0 && !findtext(circuit_data, "{"))
			// If it doesn't contain '{' it's likely Base64 encoded JSON
			var/decoded_data = rustg_decode_base64(circuit_data)
			if(decoded_data && length(decoded_data) > 0)
				circuit_data = decoded_data

	// Add safety check before deserializing
	if(length(circuit_data) > 100000) // Reduced from 50KB to be more conservative
		to_chat(user, span_warning("Circuit data is too large to process!"))
		return

	// Additional safety checks for malformed data
	if(length(circuit_data) < 20) // Increase minimum size
		to_chat(user, span_warning("Circuit data is too small to be valid."))
		return

	// Validate that this looks like circuit JSON data
	if(!findtext(circuit_data, "components") && !findtext(circuit_data, "assembly"))
		to_chat(user, span_warning("This doesn't appear to be valid circuit data."))
		return

	// Deserialize the circuit data with enhanced error handling
	var/list/assembly_data = null
	try
		assembly_data = deserialize_electronic_assembly(circuit_data)
	catch(var/exception/e)
		to_chat(user, span_warning("Failed to process circuit data: [e]. The file may be corrupted or not a valid circuit export."))
		return

	if(!assembly_data)
		to_chat(user, span_warning("Invalid circuit data! Please select a valid circuit export file (.json) created by the circuit export system."))
		return

	// Validate that the assembly data has required fields
	if(!islist(assembly_data) || !assembly_data["components"])
		to_chat(user, span_warning("Invalid circuit format!"))
		return

	// Check if we have enough metal to build all components
	var/total_cost = 0
	var/list/available_components = list()
	var/list/components_to_create = list()

	// Build list of available components
	for(var/category in SScircuit.circuit_fabricator_recipe_list)
		if(category == "Illegal Parts" && !illegal_upgraded)
			continue
		var/list/circuit_list = SScircuit.circuit_fabricator_recipe_list[category]
		for(var/path in circuit_list)
			available_components += path

	// Check each component and calculate costs
	for(var/list/component_data in assembly_data["components"])
		// Support both old "type" and new "t" format for component type
		var/component_type = component_data["type"] || component_data["t"]
		// Support both old "name" and new "n" format for component name
		var/component_name = component_data["name"] || component_data["n"] || "Unknown Component"

		if(!component_type)
			to_chat(user, span_warning("Component missing type information. Skipping."))
			continue

		// Handle both shortened and full paths flexibly
		var/build_type = null

		build_type = text2path(component_type)
		if(!build_type || !ispath(build_type, /obj/item/integrated_circuit))
			// Try with circuit prefix (for new shortened paths)
			var/full_path = "/obj/item/integrated_circuit/[component_type]"
			build_type = text2path(full_path)

		if(!build_type || !ispath(build_type, /obj/item/integrated_circuit))
			to_chat(user, span_warning("Unknown component type: [component_type]. Skipping."))
			continue

		// Check if this component is available
		if(!(build_type in available_components))
			to_chat(user, span_warning("Component '[component_name]' ([build_type]) is not available in this printer. Skipping."))
			continue

		// Check if component requires upgrades
		if(ispath(build_type, /obj/item/integrated_circuit))
			var/obj/item/integrated_circuit/IC = build_type
			var/spawn_flags = initial(IC.spawn_flags)
			// Component requires upgrades only if it has IC_SPAWN_RESEARCH but NOT IC_SPAWN_DEFAULT
			if((spawn_flags & IC_SPAWN_RESEARCH) && !(spawn_flags & IC_SPAWN_DEFAULT) && !upgraded)
				to_chat(user, span_warning("Component '[component_name]' requires printer upgrades. Skipping."))
				continue

		// Calculate cost
		var/cost = 1
		if(ispath(build_type, /obj/item/electronic_assembly))
			var/obj/item/electronic_assembly/E = build_type
			cost = round((initial(E.max_complexity) + initial(E.max_components)) / 4)
		else
			var/obj/item/I = build_type
			cost = initial(I.w_class)

		total_cost += cost
		components_to_create += list(list(
			"type" = build_type,
			"data" = component_data,
			"cost" = cost
		))

	if(!components_to_create.len)
		to_chat(user, span_warning("No valid components found in the circuit data!"))
		return

	// Check if we have enough metal
	if(!debug && (total_cost / 2) > metal)
		to_chat(user, span_warning("Not enough metal! Need [total_cost / 2] units, have [metal] units."))
		return

	// Calculate assembly cost
	var/assembly_cost = 0
	if(override_type && custom_type)
		var/custom_path = text2path(custom_type)
		if(custom_path && ispath(custom_path, /obj/item/electronic_assembly))
			var/obj/item/electronic_assembly/E = custom_path
			assembly_cost = round((initial(E.max_complexity) + initial(E.max_components)) / 4)
	else if(assembly_data["assembly_type"])
		var/original_path = text2path(assembly_data["assembly_type"])
		if(original_path && ispath(original_path, /obj/item/electronic_assembly))
			var/obj/item/electronic_assembly/E = original_path
			assembly_cost = round((initial(E.max_complexity) + initial(E.max_components)) / 4)
	else
		assembly_cost = round((IC_COMPLEXITY_BASE * 2 + IC_COMPONENTS_BASE * 2) / 4)

	total_cost += assembly_cost

	// Final metal check with assembly cost
	if(!debug && (total_cost / 2) > metal)
		to_chat(user, span_warning("Not enough metal! Need [total_cost / 2] units (including assembly), have [metal] units."))
		return

	if(!debug)
		metal = max(0, metal - (total_cost / 2))
		to_chat(user, span_notice("Deducted [total_cost / 2] metal. Remaining: [metal]"))

	// Create the assembly
	var/obj/item/electronic_assembly/assembly = create_assembly_from_data(assembly_data, override_type, custom_type)
	if(!assembly)
		to_chat(user, span_warning("Failed to create assembly!"))
		if(!debug)
			metal += total_cost
		return

	assembly.forceMove(get_turf(src))

	// Add components to assembly
	var/list/created_components = add_components_to_assembly(assembly, assembly_data, available_components)
	if(!created_components || !created_components.len)
		to_chat(user, span_warning("Failed to add components to assembly! No components were created."))
		qdel(assembly)
		if(!debug)
			metal += total_cost
		return

	// Restore wiring connections
	restore_component_wiring(assembly_data, created_components)

	// Restore appearance
	assembly.update_icon()
	playsound(src, 'sound/machines/ding.ogg', 50, TRUE)
	to_chat(user, span_notice("Successfully imported '[assembly.name]' with [created_components.len] component\s!"))

	// Try to put assembly in user's hands
	if(!user.put_in_hands(assembly))
		to_chat(user, span_notice("The imported assembly has been placed on the ground."))

	return assembly

// FUKKEN UPGRADE DISKS
/obj/item/disk/integrated_circuit/upgrade
	name = "integrated circuit printer upgrade disk"
	desc = "Install this into your integrated circuit printer to enhance it."
	icon = 'icons/obj/integrated_electronics/electronic_tools.dmi'
	icon_state = "upgrade_disk"
	item_state = "card-id"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4)

/obj/item/disk/integrated_circuit/upgrade/advanced
	name = "integrated circuit printer upgrade disk - advanced designs"
	desc = "Install this into your integrated circuit printer to enhance it.  This one adds new, advanced designs to the printer."

/obj/item/disk/integrated_circuit/upgrade/illegal
	name = "integrated circuit printer upgrade disk - illegal designs"
	desc = "Install this into your integrated circuit printer to enhance it.  This one adds new, but illegal designs to the printer."
	icon_state = "upgrade_disk_illegal"
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4, TECH_ILLEGAL = 1)

/obj/item/disk/integrated_circuit/upgrade/clone
	name = "integrated circuit printer upgrade disk - circuit cloner"
	desc = "Install this into your integrated circuit printer to enhance it.  This one allows the printer to duplicate assemblies."
	icon_state = "upgrade_disk_clone"
	origin_tech = list(TECH_ENGINEERING = 5, TECH_DATA = 6)
