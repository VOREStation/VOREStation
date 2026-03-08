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

	///Coefficient applied to consumed materials. Lower values result in lower material consumption.
	var/component_coeff = 1
	var/build_time = 50

	var/datum/wires/autolathe/wires = null

	///Designs related to the autolathe
	var/datum/techweb/autounlocking/stored_research
	///Designs imported from technology disks that we can print.
	var/list/imported_designs = list()
	/// Reference to a remote material inventory, such as an ore silo.
	var/datum/component/remote_materials/rmat
	//looping sound for printing items
	var/datum/looping_sound/lathe_print/print_sound

/obj/machinery/autolathe/Initialize(mapload)
	print_sound = new(src,  FALSE)
	rmat = AddComponent( \
		/datum/component/remote_materials, \
		mapload, \
		mat_container_signals = list( \
			COMSIG_MATCONTAINER_ITEM_CONSUMED = TYPE_PROC_REF(/obj/machinery/autolathe, AfterMaterialInsert) \
		))
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
		var/coeff = (ispath(design.build_path, /obj/item/stack) ? 1 : component_coeff)
		var/list/cost = list()
		var/customMaterials = FALSE
		for(var/datum/material/mat as anything in design.materials)
			var/mat_cost = design.materials[mat]
			var/design_cost = OPTIMAL_COST(mat_cost * coeff)
			if(istype(mat))
				cost[mat.name] = design_cost
				customMaterials = FALSE
				continue

			var/datum/material/requirement = SSmaterials.requirements[mat]
			if (!requirement)
				stack_trace("Design [design] has an invalid material requirement [requirement]")
				continue

			cost[requirement.get_description()] = design_cost
			customMaterials = TRUE

		//create & send ui data
		var/icon_size = spritesheet.icon_size_id(design.id)
		var/list/design_data = list(
			"name" = design.name,
			"desc" = design.get_description(),
			"cost" = cost,
			"id" = design.id,
			"categories" = design.category,
			"icon" = "[icon_size == size32x32 ? "" : "[icon_size] "][design.id]",
			"customMaterials" = customMaterials
		)

		output += list(design_data)

	return output

/obj/machinery/autolathe/tgui_static_data(mob/user)
	var/list/data = rmat.mat_container.tgui_static_data()

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
	data["materialtotal"] = rmat.mat_container.total_amount()
	data["materialsmax"] = rmat.mat_container.max_amount
	data["active"] = busy
	data["materials"] = rmat.mat_container.tgui_data()

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

	if(busy)
		to_chat(ui.user, span_notice("The autolathe is busy. Please wait for completion of previous operation."))
		return
	switch(action)
		if("make")
			var/datum/design_techweb/making = locate(params["make"])
			if(!istype(making))
				return

			var/multiplier = (params["multiplier"] || 1)

			//Check if we still have the materials.
			var/coeff = 1

			if(!rmat.can_use_resource())
				return

			if(LAZYLEN(making.materials))
				if(!rmat.mat_container.has_materials(making.materials, coeff, multiplier))
					return
				rmat.use_materials(making.materials, coeff, multiplier)

			busy = making.name
			print_sound.start()

			update_use_power(USE_POWER_ACTIVE)
			update_icon() // So lid closes

			addtimer(CALLBACK(src, PROC_REF(finalize_build), making, multiplier), build_time, TIMER_DELETE_ME)

			return TRUE
	return FALSE

/obj/machinery/autolathe/proc/finalize_build(datum/design_techweb/making, multiplier)
	PROTECTED_PROC(TRUE)

	busy = FALSE
	print_sound.stop()

	update_use_power(USE_POWER_IDLE)
	update_icon() // So lid opens

	//Sanity check.
	if(!making || !src)
		return

	//Create the desired item.
	var/obj/item/I = new making.build_path(src.loc)

	if(LAZYLEN(I.matter))	// Sadly we must obey the laws of equivalent exchange.
		I.matter.Cut()
	else
		I.matter = list()

	for(var/material in making.materials)	// Handle the datum's autoscaling for waste, so we're properly wasting material, but not so much if we have efficiency.
		I.matter[material] = round(making.materials[material])

	flick("[initial(icon_state)]_finish", src)
	if(multiplier > 1)
		if(istype(I, /obj/item/stack))
			var/obj/item/stack/S = I
			S.set_amount(multiplier)
		else
			for(multiplier; multiplier > 1; --multiplier) // Create multiple items if it's not a stack.
				I = new making.build_path(get_turf(src))
				// We've already deducted the cost of multiple items. Process the matter the same.
				if(LAZYLEN(I.matter))
					I.matter.Cut()

				else
					I.matter = list()

				for(var/material in making.materials)
					I.matter[material] = round(making.materials[material])


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
	..()
	var/mb_rating = 0
	var/man_rating = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	rmat.set_local_size(mb_rating * 75000)
	build_time = 50 / man_rating

	update_tgui_static_data(usr)

/obj/machinery/autolathe/proc/AfterMaterialInsert(datum/source, obj/item/item_inserted, id_inserted, amount_inserted)
	SIGNAL_HANDLER
	flick("autolathe_loading", src)//plays metal insertion animation
	// use_power(min(1000, amount_inserted / 100))
	SStgui.update_uis(src)

/obj/machinery/autolathe/examine(mob/user)
	. = ..()
	if(in_range(user, src) || isobserver(user))
		. += span_notice("The status display reads: Storing up to <b>[rmat.local_size]</b> material units</b>.")
