/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using steel, glass, plastic and maybe some more."
	icon_state = "autolathe"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = "keyboard"
	clickvol = 30

	circuit = /obj/item/circuitboard/autolathe

	var/static/datum/category_collection/autolathe/autolathe_recipes

	///Is the autolathe hacked via wiring
	var/hacked = FALSE
	///Is the autolathe disabled via wiring
	var/disabled = FALSE
	///Did we recently shock a mob who medled with the wiring
	var/shocked = FALSE
	///Are we currently printing something
	var/busy = FALSE

	var/datum/wires/autolathe/wires = null

	///Coefficient applied to consumed materials. Lower values result in lower material consumption.
	var/creation_efficiency = 1.6
	///Designs related to the autolathe
	var/datum/techweb/autounlocking/stored_research
	///Designs imported from technology disks that we can print.
	var/list/imported_designs = list()
	///The container to hold materials
	var/datum/component/material_container/materials
	//looping sound for printing items
	var/datum/looping_sound/lathe_print/print_sound

/obj/machinery/autolathe/Initialize(mapload)
	print_sound = new(src,  FALSE)
	materials = AddComponent( \
		/datum/component/material_container, \
		subtypesof(/datum/material), \
		0, \
		MATCONTAINER_EXAMINE, \
		container_signals = list(COMSIG_MATCONTAINER_ITEM_CONSUMED = TYPE_PROC_REF(/obj/machinery/autolathe, AfterMaterialInsert)) \
	)
	. = ..()
	wires = new(src)

	if(!GLOB.autounlock_techwebs[/datum/techweb/autounlocking/autolathe])
		GLOB.autounlock_techwebs[/datum/techweb/autounlocking/autolathe] = new /datum/techweb/autounlocking/autolathe
	stored_research = GLOB.autounlock_techwebs[/datum/techweb/autounlocking/autolathe]

	default_apply_parts()
	RefreshParts()

/obj/machinery/autolathe/Destroy()
	QDEL_NULL(wires)
	QDEL_NULL(print_sound)
	return ..()

/obj/machinery/autolathe/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Autolathe", name)
		ui.open()

/obj/machinery/autolathe/tgui_status(mob/user)
	if(disabled)
		return STATUS_CLOSE
	return ..()

/obj/machinery/autolathe/proc/handle_designs(list/designs)
	PRIVATE_PROC(TRUE)

	var/list/output = list()

	var/datum/asset/spritesheet_batched/research_designs/spritesheet = get_asset_datum(/datum/asset/spritesheet_batched/research_designs)
	var/size32x32 = "[spritesheet.name]32x32"

	for(var/design_id in designs)
		var/datum/design_techweb/design = SSresearch.techweb_design_by_id(design_id)
		if(design.make_reagent)
			continue

		//compute cost & maximum number of printable items
		var/coeff = (ispath(design.build_path, /obj/item/stack) ? 1 : creation_efficiency)
		var/list/cost = list()
		for(var/id in design.materials)
			var/datum/material/mat = get_material_by_name(id)
			cost[mat.name] = OPTIMAL_COST(design.materials[mat] * coeff)

		//create & send ui data
		var/icon_size = spritesheet.icon_size_id(design.id)
		var/list/design_data = list(
			"name" = design.name,
			"desc" = design.get_description(),
			"cost" = cost,
			"id" = design.id,
			"categories" = design.category,
			"icon" = "[icon_size == size32x32 ? "" : "[icon_size] "][design.id]"
		)

		output += list(design_data)

	return output

/obj/machinery/autolathe/tgui_static_data(mob/user)
	var/list/data = materials.tgui_static_data()

	data["designs"] = handle_designs(stored_research.researched_designs)
	if(imported_designs.len)
		data["designs"] += handle_designs(imported_designs)
	if(hacked)
		data["designs"] += handle_designs(stored_research.hacked_designs)

	return data

/obj/machinery/autolathe/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/sheetmaterials),
		get_asset_datum(/datum/asset/spritesheet_batched/research_designs),
	)

/obj/machinery/autolathe/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = list()

	data["materials"] = list()
	data["materialtotal"] = materials.total_amount()
	data["materialsmax"] = materials.max_amount
	data["active"] = busy
	data["materials"] = materials.tgui_data()

	return data

/obj/machinery/autolathe/interact(mob/user)
	if(panel_open)
		return wires.Interact(user)

	if(disabled)
		to_chat(user, span_danger("\The [src] is disabled!"))
		return

	if(shocked)
		shock(user, 50)

	tgui_interact(user)

/obj/machinery/autolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, span_notice("\The [src] is busy. Please wait for completion of previous operation."))
		return

	if(default_deconstruction_screwdriver(user, O))
		interact(user)
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

	if(stat)
		return

	if(istype(O, /obj/item/disk/design_disk))
		user.visible_message(span_notice("[user] begins to load \the [O] in \the [src]..."),
			balloon_alert(user, "uploading design..."),
			span_hear("You hear the chatter of a floppy drive."))
		busy = TRUE

		if(!do_after(user, 1.5 SECONDS, target = src))
			busy = FALSE
			update_static_data_for_all_viewers()
			balloon_alert(user, "interrupted!")
			return

		var/obj/item/disk/design_disk/disky = O
		var/list/not_imported
		for(var/datum/design_techweb/blueprint as anything in disky.blueprints)
			if(!blueprint)
				continue
			if(blueprint.build_type & AUTOLATHE)
				imported_designs[blueprint.id] = TRUE
			else
				LAZYADD(not_imported, blueprint.name)

		if(not_imported)
			to_chat(user, span_warning("The following design[length(not_imported) > 1 ? "s" : ""] couldn't be imported: [english_list(not_imported)]"))

		busy = FALSE
		update_static_data_for_all_viewers()
		return

	if(panel_open)
		//Don't eat multitools or wirecutters used on an open lathe.
		if(O.has_tool_quality(TOOL_MULTITOOL) || O.has_tool_quality(TOOL_WIRECUTTER))
			wires.Interact(user)
			return

	if(is_robot_module(O))
		return 0

	if(istype(O,/obj/item/ammo_magazine/clip) || istype(O,/obj/item/ammo_magazine/s357) || istype(O,/obj/item/ammo_magazine/s38) || istype (O,/obj/item/ammo_magazine/s44)/* VOREstation Edit*/) // Prevents ammo recycling exploit with speedloaders.
		to_chat(user, "\The [O] is too hazardous to recycle with the autolathe!")
		return

	return ..()

/obj/machinery/autolathe/attack_hand(mob/user as mob)
	interact(user)

/obj/machinery/autolathe/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(ui.user)

	if(action != "make")
		stack_trace("unknown autolathe ui_act: [action]")
		return

	if(disabled)
		atom_say("Unable to print, voltage mismatch in internal wiring.")
		return

	if(busy)
		atom_say("The autolathe is busy. Please wait for completion of previous operation.")
		return

	var/datum/design_techweb/making = locate(params["make"])
	if(!istype(making))
		return

	//validate design
	var/design_id = params["id"]
	if(!design_id)
		return
	var/valid_design = stored_research.researched_designs[design_id]
	valid_design ||= stored_research.hacked_designs[design_id]
	valid_design ||= imported_designs[design_id]
	if(!valid_design)
		return
	var/datum/design_techweb/design = SSresearch.techweb_design_by_id(design_id)
	if(isnull(design))
		stack_trace("got passed an invalid design id: [design_id] and somehow made it past all checks")
		return
	if(!(design.build_type & AUTOLATHE))
		atom_say("This fabricator does not have the necessary keys to decrypt this design.")
		return

	//validate print quantity
	var/build_count = params["multiplier"]
	if(isnull(build_count))
		return
	build_count = text2num(build_count)
	if(isnull(build_count))
		return
	build_count = clamp(build_count, 1, 50)

	// Check for materials required. For custom material items decode their required materials
	var/list/materials_needed = list()
	var/mat_choice = FALSE
	for(var/material, amount_needed in design.materials)
		if(!istype(material, /datum/material))
			CRASH("Autolathe ui_act got passed an invalid material id: [material]")
		materials_needed[material] += amount_needed

	//checks for available materials
	var/material_cost_coefficient = ispath(design.build_path, /obj/item/stack) ? 1 : creation_efficiency
	if(!materials.has_materials(materials_needed, material_cost_coefficient, build_count))
		atom_say("Not enough materials to begin production.")
		return

	//compute power & time to print 1 item
	var/charge_per_item = 0
	for(var/material, amount in design.materials)
		charge_per_item += amount

	charge_per_item = ROUND_UP((charge_per_item / (MAX_STACK_SIZE * SHEET_MATERIAL_AMOUNT)) * material_cost_coefficient * active_power_usage)
	var/build_time_per_item = (design.construction_time * design.lathe_time_factor) ** 0.8

	//do the printing sequentially
	busy = TRUE
	icon_state = "autolathe_n"
	SStgui.update_uis(src)
	// play this after all checks passed individually for each item.
	print_sound.start()
	var/turf/target_location = get_turf(src)

	addtimer(CALLBACK(src, PROC_REF(do_make_item), design, build_count, build_time_per_item, material_cost_coefficient, charge_per_item, materials_needed, target_location), build_time_per_item)
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
 * * list/materials_needed - the list of materials to print 1 item
 * * turf/target - the location to drop the printed item on
*/
/obj/machinery/autolathe/proc/do_make_item(datum/design_techweb/design, items_remaining, build_time_per_item, material_cost_coefficient, charge_per_item, list/materials_needed, turf/target)
	PROTECTED_PROC(TRUE)

	if(items_remaining <= 0) // how
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
			atom_say("Unable to continue production, power grid overload.")
		else
			atom_say("Unable to continue production, no APC in area.")
		finalize_build()
		return

	var/is_stack = ispath(design.build_path, /obj/item/stack)
	if(!materials.has_materials(materials_needed, material_cost_coefficient, is_stack ? items_remaining : 1))
		atom_say("Unable to continue production, missing materials.")
		finalize_build()
		return
	materials.use_materials(materials_needed, material_cost_coefficient, is_stack ? items_remaining : 1)

	var/atom/movable/created
	if(is_stack)
		var/obj/item/stack/stack_item = initial(design.build_path)
		var/max_stack_amount = initial(stack_item.max_amount)
		var/number_to_make = (initial(stack_item.amount) * items_remaining)
		while(number_to_make > max_stack_amount)
			created = design.create_result(target, materials_needed, amount = max_stack_amount)
			if(isitem(created))
				created.pixel_x = rand(-6, 6)
				created.pixel_y = rand(-6, 6)
			number_to_make -= max_stack_amount
		created = design.create_result(target, materials_needed, amount = number_to_make)
	else
		created = design.create_result(target, materials_needed)
		split_materials_uniformly(materials_needed, material_cost_coefficient, created)

	if(isitem(created))
		created.pixel_x = rand(-6, 6)
		created.pixel_y = rand(-6, 6)

	if(is_stack)
		items_remaining = 0
	else
		items_remaining -= 1

	if(items_remaining <= 0)
		finalize_build()
		return
	addtimer(CALLBACK(src, PROC_REF(do_make_item), design, items_remaining, build_time_per_item, material_cost_coefficient, charge_per_item, materials_needed, target), build_time_per_item)

/**
 * Resets the icon state and busy flag
 * Called at the end of do_make_item's timer loop
*/
/obj/machinery/autolathe/proc/finalize_build()
	PROTECTED_PROC(TRUE)
	print_sound.stop()
	icon_state = initial(icon_state)
	busy = FALSE
	SStgui.update_uis(src)

/obj/machinery/autolathe/update_icon()
	cut_overlays()

	icon_state = initial(icon_state)

	if(panel_open)
		add_overlay("[icon_state]_panel")
	if(stat & NOPOWER)
		return
	if(busy)
		icon_state = "[icon_state]_work"

//Updates overall lathe storage size.
/obj/machinery/autolathe/RefreshParts()
	. = ..()
	var/mat_capacity = 0
	for(var/obj/item/stock_parts/matter_bin/new_matter_bin in component_parts)
		mat_capacity += new_matter_bin.rating * (37.5*SHEET_MATERIAL_AMOUNT)
	materials.max_amount = mat_capacity

	var/efficiency = 1.8
	for(var/obj/item/stock_parts/motor/new_servo in component_parts)
		efficiency -= new_servo.rating * 0.2
	creation_efficiency = max(1, round(efficiency, 0.1)) // creation_efficiency goes 1.6 -> 1.4 -> 1.2 -> 1 per level of servo efficiency

/obj/machinery/autolathe/proc/AfterMaterialInsert(datum/source, obj/item/item_inserted, id_inserted, amount_inserted)
	SIGNAL_HANDLER
	flick("autolathe_loading", src)//plays metal insertion animation
	// use_power(min(1000, amount_inserted / 100))
	SStgui.update_uis(src)

/obj/machinery/autolathe/examine(mob/user)
	. = ..()
	if(!in_range(user, src) && !isobserver(user))
		return
	. += span_notice("Material usage cost at <b>[creation_efficiency * 100]%</b>.")
	. += span_notice("Its maintenance panel is [!panel_open ? "closed" : "open"].")
