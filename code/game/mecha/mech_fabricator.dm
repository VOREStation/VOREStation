/obj/machinery/mecha_part_fabricator
	icon = 'icons/obj/robotics_vr.dmi' //VOREStation Edit - New icon
	icon_state = "mechfab"
	name = "Exosuit Fabricator"
	desc = "A machine used for the construction of mechas."
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 5000
	req_access = list(access_robotics)
	circuit = /obj/item/circuitboard/mechfab

	/// Current items in the build queue.
	var/list/queue = list()
	/// Whether or not the machine is building the entire queue automagically.
	var/process_queue = FALSE

	/// The current design datum that the machine is building.
	var/datum/design/being_built
	/// World time when the build will finish.
	var/build_finish = 0
	/// World time when the build started.
	var/build_start = 0
	/// Reference to all materials used in the creation of the item being_built.
	var/list/build_materials
	/// Part currently stored in the Exofab.
	var/obj/item/stored_part

	/// Coefficient for the speed of item building. Based on the installed parts.
	var/time_coeff = 1
	/// Coefficient for the efficiency of material usage in item building. Based on the installed parts.
	var/component_coeff = 1

	var/loading_icon_state = "mechfab-idle"

	var/list/materials = list(
		MAT_STEEL = 0,
		MAT_GLASS = 0,
		MAT_PLASTIC = 0,
		MAT_GRAPHITE = 0,
		MAT_PLASTEEL = 0,
		MAT_GOLD = 0,
		MAT_SILVER = 0,
		MAT_LEAD = 0,
		MAT_OSMIUM = 0,
		MAT_DIAMOND = 0,
		MAT_DURASTEEL = 0,
		MAT_PHORON = 0,
		MAT_URANIUM = 0,
		MAT_VERDANTIUM = 0,
		MAT_MORPHIUM = 0,
		MAT_METALHYDROGEN = 0,
		MAT_SUPERMATTER = 0)
	var/res_max_amount = 200000

	var/datum/research/files
	var/valid_buildtype = MECHFAB
	/// A list of categories that valid MECHFAB design datums will broadly categorise themselves under.
	var/list/part_sets = list(
								"Cyborg",
								"Ripley",
								"Odysseus",
								"Gygax",
								"Durand",
								"Janus",
								"Vehicle",
								"Rigsuit",
								"Phazon",
								"Pinnace",
								"Baron",
								"Gopher", // VOREStation Add
								"Polecat", // VOREStation Add
								"Weasel", // VOREStation Add
								"Exosuit Equipment",
								"Exosuit Internals",
								"Exosuit Ammunition",
								"Cyborg Upgrade Modules",
								"Cybernetics",
								"Implants",
								"Control Interfaces",
								"Other",
								"Misc",
								)

/obj/machinery/mecha_part_fabricator/Initialize(mapload)
	. = ..()

// Go through all materials, and add them to the possible storage, but hide them unless we contain them.
	for(var/Name in name_to_material)
		if(Name in materials)
			continue

		materials[Name] = 0

	default_apply_parts()
	files = new /datum/research(src) //Setup the research data holder.

/obj/machinery/mecha_part_fabricator/dismantle()
	for(var/f in materials)
		eject_materials(f, -1)
	..()

/obj/machinery/mecha_part_fabricator/RefreshParts()
	res_max_amount = 0
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		res_max_amount += M.rating * 100000 // 200k -> 600k
	var/T = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		T += M.rating
	component_coeff = max(1 - (T - 1) / 4, 0.2) // 1 -> 0.2
	for(var/obj/item/stock_parts/micro_laser/M in component_parts) // Not resetting T is intended; time_coeff is affected by both
		T += M.rating
	time_coeff = T / 2 // 1 -> 3
	update_tgui_static_data(usr)


/**
  * Generates an info list for a given part.
  *
  * Returns a list of part information.
  * * D - Design datum to get information on.
  * * categories - Boolean, whether or not to parse snowflake categories into the part information list.
  */
/obj/machinery/mecha_part_fabricator/proc/output_part_info(datum/design/D, var/categories = FALSE)
	var/cost = list()
	for(var/c in D.materials)
		cost[c] = get_resource_cost_w_coeff(D, D.materials[c])

	var/obj/built_item = D.build_path

	var/list/category_override = null
	var/list/sub_category = null

	if(categories)
		// Handle some special cases to build up sub-categories for the fab interface.
		// Start with checking if this design builds a cyborg module.
		if(built_item in typesof(/obj/item/borg/upgrade))
			var/obj/item/borg/upgrade/U = built_item
			var/module_types = initial(U.module_flags)
			sub_category = list()
			if(module_types)
				if(module_types & BORG_UTILITY)
					sub_category += "All Cyborgs - Utility"
				if(module_types & BORG_BASIC)
					sub_category += "All Cyborgs - Basic"
				if(module_types & BORG_ADVANCED)
					sub_category += "All Cyborgs - Advanced"
				if(module_types & BORG_MODULE_SECURITY)
					sub_category += "Security"
				if(module_types & BORG_MODULE_MINER)
					sub_category += "Mining"
				if(module_types & BORG_MODULE_JANITOR)
					sub_category += "Janitor"
				if(module_types & BORG_MODULE_MEDICAL)
					sub_category += "Medical"
				if(module_types & BORG_MODULE_ENGINEERING)
					sub_category += "Engineering"
				if(module_types & BORG_MODULE_SCIENCE)
					sub_category += "Science"
				if(module_types & BORG_MODULE_SERVICE)
					sub_category += "Service"
				if(module_types & BORG_MODULE_CLERIC)
					sub_category += "Cleric"
				if(module_types & BORG_MODULE_COMBAT)
					sub_category += "Combat"
				if(module_types & BORG_MODULE_EXPLO)
					sub_category += "Exploration"
			else
				sub_category += "This shouldn't be here, bother a dev!"
		// Else check if this design builds a piece of exosuit equipment.
		else if(built_item in typesof(/obj/item/mecha_parts/mecha_equipment))
			var/obj/item/mecha_parts/mecha_equipment/E = built_item
			var/mech_types = initial(E.mech_flags)
			sub_category = "Equipment"
			if(mech_types)
				category_override = list()
				if(mech_types & EXOSUIT_MODULE_RIPLEY)
					category_override += "Ripley"
				if(mech_types & EXOSUIT_MODULE_ODYSSEUS)
					category_override += "Odysseus"
				if(mech_types & EXOSUIT_MODULE_GYGAX)
					category_override += "Gygax"
				if(mech_types & EXOSUIT_MODULE_DURAND)
					category_override += "Durand"
				if(mech_types & EXOSUIT_MODULE_PHAZON)
					category_override += "Phazon"
				if(mech_types & EXOSUIT_MODULE_PINNACE)
					category_override += "Pinnace"
				if(mech_types & EXOSUIT_MODULE_BARON)
					category_override += "Baron"

	var/list/part = list(
		"name" = D.name,
		"desc" = initial(built_item.desc),
		"printTime" = get_construction_time_w_coeff(initial(D.time))/10,
		"cost" = cost,
		"id" = D.id,
		"subCategory" = sub_category,
		"categoryOverride" = category_override,
		"searchMeta" = D.search_metadata
	)

	return part


/**
  * Generates a list of resources / materials available to this Exosuit Fab
  *
  * Returns null if there is no material container available.
  * List format is list(material_name = list(amount = ..., ref = ..., etc.))
  */
/obj/machinery/mecha_part_fabricator/proc/output_available_resources()
	var/list/material_data = list()

	for(var/mat_id in materials)
		var/amount = materials[mat_id]
		var/list/material_info = list(
			"name" = mat_id,
			"amount" = amount,
			"sheets" = round(amount / SHEET_MATERIAL_AMOUNT),
			"removable" = amount >= SHEET_MATERIAL_AMOUNT
		)

		material_data += list(material_info)

	return material_data

/**
  * Intended to be called when an item starts printing.
  *
  * Adds the overlay to show the fab working and sets active power usage settings.
  */
/obj/machinery/mecha_part_fabricator/proc/on_start_printing()
	add_overlay("[icon_state]-active")
	use_power = USE_POWER_ACTIVE

/**
  * Intended to be called when the exofab has stopped working and is no longer printing items.
  *
  * Removes the overlay to show the fab working and sets idle power usage settings. Additionally resets the description and turns off queue processing.
  */
/obj/machinery/mecha_part_fabricator/proc/on_finish_printing()
	cut_overlay("[icon_state]-active")
	use_power = USE_POWER_IDLE
	desc = initial(desc)
	process_queue = FALSE

/**
  * Calculates resource/material costs for printing an item based on the machine's resource coefficient.
  *
  * Returns a list of k,v resources with their amounts.
  * * D - Design datum to calculate the modified resource cost of.
  */
/obj/machinery/mecha_part_fabricator/proc/get_resources_w_coeff(datum/design/D)
	var/list/resources = list()
	for(var/mat_id in D.materials)
		resources[mat_id] = get_resource_cost_w_coeff(D, D.materials[mat_id])
	return resources

/**
  * Checks if the Exofab has enough resources to print a given item.
  *
  * Returns FALSE if the design has no reagents used in its construction (?) or if there are insufficient resources.
  * Returns TRUE if there are sufficient resources to print the item.
  * * D - Design datum to calculate the modified resource cost of.
  */
/obj/machinery/mecha_part_fabricator/proc/check_resources(datum/design/D)
	if(length(D.chemicals)) // No reagents storage - no reagent designs.
		return FALSE
	. = TRUE
	var/list/coeff_required = get_resources_w_coeff(D)
	for(var/mat_id in coeff_required)
		if(materials[mat_id] < coeff_required[mat_id])
			return FALSE

/**
  * Attempts to build the next item in the build queue.
  *
  * Returns FALSE if either there are no more parts to build or the next part is not buildable.
  * Returns TRUE if the next part has started building.
  * * verbose - Whether the machine should use say() procs. Set to FALSE to disable the machine saying reasons for failure to build.
  */
/obj/machinery/mecha_part_fabricator/proc/build_next_in_queue(verbose = TRUE)
	if(!length(queue))
		return FALSE

	var/datum/design/D = queue[1]
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
  * * verbose - Whether the machine should use say() procs. Set to FALSE to disable the machine saying reasons for failure to build.
  */
/obj/machinery/mecha_part_fabricator/proc/build_part(datum/design/D, verbose = TRUE)
	if(!D)
		return FALSE

	if(!check_resources(D))
		if(verbose)
			atom_say("Not enough resources. Processing stopped.")
		return FALSE

	build_materials = get_resources_w_coeff(D)
	for(var/mat_id in build_materials)
		materials[mat_id] -= build_materials[mat_id]

	being_built = D
	build_finish = world.time + get_construction_time_w_coeff(initial(D.time))
	build_start = world.time
	desc = "It's building \a [D.name]."

	return TRUE

/obj/machinery/mecha_part_fabricator/process()
	..()
	// If there's a stored part to dispense due to an obstruction, try to dispense it.
	if(stored_part)
		var/turf/exit = get_step(src,(dir))
		if(exit.density)
			return TRUE

		atom_say("Obstruction cleared. \The [stored_part] is complete.")
		stored_part.forceMove(exit)
		stored_part = null

	// If there's nothing being built, try to build something
	if(!being_built)
		// If we're not processing the queue anymore or there's nothing to build, end processing.
		if(!process_queue || !build_next_in_queue())
			on_finish_printing()
			return PROCESS_KILL
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
  * * D - Design datum to attempt to dispense.
  */
/obj/machinery/mecha_part_fabricator/proc/dispense_built_part(datum/design/D)
	var/obj/item/I = D.Fabricate(src, src)
	// I.material_flags |= MATERIAL_NO_EFFECTS //Find a better way to do this.
	// I.set_custom_materials(build_materials)

	being_built = null

	var/turf/exit = get_step(src,(dir))
	if(exit.density)
		atom_say("Error! Part outlet is obstructed.")
		desc = "It's trying to dispense \a [D.name], but the part outlet is obstructed."
		stored_part = I
		return FALSE

	atom_say("\The [I] is complete.")
	I.forceMove(exit)
	return I

/**
  * Adds a list of datum designs to the build queue.
  *
  * Will only add designs that are in this machine's stored techweb.
  * Does final checks for datum IDs and makes sure this machine can build the designs.
  * * part_list - List of datum design ids for designs to add to the queue.
  */
/obj/machinery/mecha_part_fabricator/proc/add_part_set_to_queue(list/part_list)
	for(var/datum/design/D in files.known_designs)
		if((D.build_type & valid_buildtype) && (D.id in part_list))
			add_to_queue(D)

/**
  * Adds a datum design to the build queue.
  *
  * Returns TRUE if successful and FALSE if the design was not added to the queue.
  * * D - Datum design to add to the queue.
  */
/obj/machinery/mecha_part_fabricator/proc/add_to_queue(datum/design/D)
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
/obj/machinery/mecha_part_fabricator/proc/remove_from_queue(index)
	if(!isnum(index) || !ISINTEGER(index) || !istype(queue) || (index<1 || index>length(queue)))
		return FALSE
	queue.Cut(index,++index)
	return TRUE

/**
  * Generates a list of parts formatted for tgui based on the current build queue.
  *
  * Returns a formatted list of lists containing formatted part information for every part in the build queue.
  */
/obj/machinery/mecha_part_fabricator/proc/list_queue()
	if(!istype(queue) || !length(queue))
		return null

	var/list/queued_parts = list()
	for(var/datum/design/D in queue)
		var/list/part = output_part_info(D)
		queued_parts += list(part)
	return queued_parts

/obj/machinery/mecha_part_fabricator/proc/sync()
	for(var/obj/machinery/computer/rdconsole/RDC in get_area_all_atoms(get_area(src)))
		if(!RDC.sync)
			continue
		for(var/datum/tech/T in RDC.files.known_tech)
			files.AddTech2Known(T)
		for(var/datum/design/D in RDC.files.known_designs)
			files.AddDesign2Known(D)
		files.RefreshResearch()
		update_tgui_static_data(usr)
		atom_say("Successfully synchronized with R&D server.")
		return

	atom_say("Unable to connect to local R&D server.")
	return

/**
  * Calculates the coefficient-modified resource cost of a single material component of a design's recipe.
  *
  * Returns coefficient-modified resource cost for the given material component.
  * * D - Design datum to pull the resource cost from.
  * * resource - Material datum reference to the resource to calculate the cost of.
  * * roundto - Rounding value for round() proc
  */
/obj/machinery/mecha_part_fabricator/proc/get_resource_cost_w_coeff(datum/design/D, var/amt, roundto = 1)
	return round(amt * component_coeff, roundto)

/**
  * Calculates the coefficient-modified build time of a design.
  *
  * Returns coefficient-modified build time of a given design.
  * * D - Design datum to calculate the modified build time of.
  * * roundto - Rounding value for round() proc
  */
/obj/machinery/mecha_part_fabricator/proc/get_construction_time_w_coeff(construction_time, roundto = 1) //aran
	return round(construction_time * time_coeff, roundto)

/obj/machinery/mecha_part_fabricator/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/sheetmaterials)
	)

/obj/machinery/mecha_part_fabricator/attack_hand(var/mob/user)
	if(..())
		return
	if(!allowed(user))
		to_chat(user, span_warning("\The [src] rejects your use due to lack of access!"))
		return
	tgui_interact(user)

/obj/machinery/mecha_part_fabricator/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ExosuitFabricator", name)
		ui.open()

/obj/machinery/mecha_part_fabricator/tgui_static_data(mob/user)
	var/list/data = list()

	var/list/final_sets = list()
	var/list/buildable_parts = list()

	for(var/part_set in part_sets)
		final_sets += part_set

	for(var/datum/design/D in files.known_designs)
		if((D.build_type & valid_buildtype) && D.id != "id") // bugfix for weird null entries
			// This is for us.
			var/list/part = output_part_info(D, TRUE)

			if(part["categoryOverride"])
				for(var/cat in part["categoryOverride"])
					buildable_parts[cat] += list(part)
					if(!(cat in part_sets))
						final_sets += cat
				continue

			for(var/cat in part_sets)
				// Find all matching categories.
				if(!(cat in D.category))
					continue

				buildable_parts[cat] += list(part)

	data["partSets"] = final_sets
	data["buildableParts"] = buildable_parts

	return data

/obj/machinery/mecha_part_fabricator/tgui_data(mob/user)
	var/list/data = list()

	data["materials"] = output_available_resources()

	if(being_built)
		var/list/part = list(
			"name" = being_built.name,
			"duration" = build_finish - world.time,
			"printTime" = get_construction_time_w_coeff(initial(being_built.time))
		)
		data["buildingPart"] = part
	else
		data["buildingPart"] = null

	data["queue"] = list_queue()

	if(stored_part)
		data["storedPart"] = stored_part.name
	else
		data["storedPart"] = null

	data["isProcessingQueue"] = process_queue

	return data

/obj/machinery/mecha_part_fabricator/tgui_act(action, list/params, datum/tgui/ui)
	if(..())
		return TRUE

	. = TRUE

	add_fingerprint(ui.user)
	ui.user.set_machine(src)

	switch(action)
		if("sync_rnd")
			// Sync with R&D Servers
			sync()
			return
		if("add_queue_set")
			// Add all parts of a set to queue
			var/part_list = params["part_list"]
			add_part_set_to_queue(part_list)
			return
		if("add_queue_part")
			// Add a specific part to queue
			var/T = params["id"]
			for(var/datum/design/D in files.known_designs)
				if((D.build_type & valid_buildtype) && (D.id == T))
					add_to_queue(D)
					break
			return
		if("del_queue_part")
			// Delete a specific from from the queue
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

			if(!being_built)
				START_PROCESSING(SSobj, src)
			return
		if("stop_queue")
			// Pause queue building. Also known as stop.
			process_queue = FALSE
			return
		if("build_part")
			// Build a single part
			if(being_built || process_queue)
				return

			var/id = params["id"]
			var/datum/design/D = null
			for(var/datum/design/D_new in files.known_designs)
				if((D_new.build_type == valid_buildtype) && (D_new.id == id))
					D = D_new
					break

			if(!D)
				return

			if(build_part(D))
				on_start_printing()
				START_PROCESSING(SSobj, src)

			return
		if("move_queue_part")
			// Moves a part up or down in the queue.
			var/index = text2num(params["index"])
			var/new_index = index + text2num(params["newindex"])
			if(isnum(index) && isnum(new_index) && ISINTEGER(index) && ISINTEGER(new_index))
				if(ISINRANGE(new_index,1,length(queue)))
					queue.Swap(index,new_index)
			return
		if("remove_mat")
			// Remove a material from the fab
			var/mat_id = params["id"]
			var/amount = text2num(params["amount"])
			eject_materials(mat_id, amount)
			return

	return FALSE

/obj/machinery/mecha_part_fabricator/attackby(var/obj/item/I, var/mob/user)
	if(being_built)
		to_chat(user, span_notice("\The [src] is busy. Please wait for completion of previous operation."))
		return 1
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return

	if(istype(I,/obj/item/stack/material))
		var/obj/item/stack/material/S = I
		if(!(S.material.name in materials))
			to_chat(user, span_warning("The [src] doesn't accept [S.material]!"))
			return

		var/sname = "[S.name]"
		var/amnt = S.perunit
		if(materials[S.material.name] + amnt <= res_max_amount)
			if(S && S.get_amount() >= 1)
				var/count = 0
				flick("[loading_icon_state]", src)
				// yess hacky but whatever //even more hacky now, but at least it works
				if(loading_icon_state == "mechfab-idle")
					flick("mechfab-load-metal", src)
				while(materials[S.material.name] + amnt <= res_max_amount && S.get_amount() >= 1)
					materials[S.material.name] += amnt
					S.use(1)
					count++
				to_chat(user, "You insert [count] [sname] into the fabricator.")
		else
			to_chat(user, "The fabricator cannot hold more [sname].")

		return

	..()

/obj/machinery/mecha_part_fabricator/emag_act(var/remaining_charges, var/mob/user)
	switch(emagged)
		if(0)
			emagged = 0.5
			visible_message("[icon2html(src,viewers(src))] <b>[src]</b> beeps: \"DB error \[Code 0x00F1\]\"")
			sleep(10)
			visible_message("[icon2html(src,viewers(src))] <b>[src]</b> beeps: \"Attempting auto-repair\"")
			sleep(15)
			visible_message("[icon2html(src,viewers(src))] <b>[src]</b> beeps: \"User DB corrupted \[Code 0x00FA\]. Truncating data structure...\"")
			sleep(30)
			visible_message("[icon2html(src,viewers(src))] <b>[src]</b> beeps: \"User DB truncated. Please contact your [using_map.company_name] system operator for future assistance.\"")
			req_access = null
			emagged = 1
			return 1
		if(0.5)
			visible_message("[icon2html(src,viewers(src))] <b>[src]</b> beeps: \"DB not responding \[Code 0x0003\]...\"")
		if(1)
			visible_message("[icon2html(src,viewers(src))] <b>[src]</b> beeps: \"No records in User DB\"")

/obj/machinery/mecha_part_fabricator/proc/eject_materials(var/material, var/amount) // 0 amount = 0 means ejecting a full stack; -1 means eject everything
	var/recursive = amount == -1 ? TRUE : FALSE
	var/matstring = lowertext(material)

	// 0 or null, nothing to eject
	if(!materials[matstring])
		return
	// Problem, fix problem and abort
	if(materials[matstring] < 0)
		warning("[src] tried to eject material '[material]', which it has 'materials[matstring]' of!")
		materials[matstring] = 0
		return

	// Find the material datum for our material
	var/datum/material/M = get_material_by_name(matstring)
	if(!M)
		warning("[src] tried to eject material '[matstring]', which didn't match any known material datum!")
		return
	// Find what type of sheets it makes
	var/obj/item/stack/material/S = M.stack_type
	if(!S)
		warning("[src] tried to eject material '[matstring]', which didn't have a stack_type!")
		return

	// If we were passed -1, then it's recursive ejection and we should eject all we can
	if(amount <= 0)
		amount = initial(S.max_amount)
	// Smaller of what we have left, or the desired amount (note the amount is in sheets, but the array stores perunit values)
	var/ejected = min(round(materials[matstring] / initial(S.perunit)), amount)

	// Place a sheet
	S = M.place_sheet(get_turf(src), ejected)
	if(!istype(S))
		warning("[src] tried to eject material '[material]', which didn't generate a proper stack when asked!")
		return

	// Reduce our amount stored
	materials[matstring] -= ejected * S.perunit

	// Recurse if we have enough left for more sheets
	if(recursive && materials[matstring] >= S.perunit)
		eject_materials(matstring, -1)
