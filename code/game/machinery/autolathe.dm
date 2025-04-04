/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using metal and glass."
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

	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/busy = 0

	var/mat_efficiency = 1
	var/build_time = 50

	var/datum/wires/autolathe/wires = null

	var/mb_rating = 0
	var/man_rating = 0

	var/filtertext

/obj/machinery/autolathe/Initialize(mapload)
	AddComponent(/datum/component/material_container, subtypesof(/datum/material), 0, MATCONTAINER_EXAMINE, _after_insert = CALLBACK(src, PROC_REF(AfterMaterialInsert)))
	. = ..()
	if(!autolathe_recipes)
		autolathe_recipes = new()
	wires = new(src)

	default_apply_parts()
	RefreshParts()

/obj/machinery/autolathe/Destroy()
	qdel(wires)
	wires = null
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

/obj/machinery/autolathe/tgui_static_data(mob/user)
	var/list/data = ..()

	var/list/categories = list()
	var/list/recipes = list()
	for(var/datum/category_group/autolathe/A in autolathe_recipes.categories)
		categories += A.name
		for(var/datum/category_item/autolathe/M in A.items)
			if(M.hidden && !hacked)
				continue
			if(M.man_rating > man_rating)
				continue
			recipes.Add(list(list(
				"category" = A.name,
				"name" = M.name,
				"ref" = REF(M),
				"requirements" = M.resources,
				"hidden" = M.hidden,
				"coeff_applies" = !M.no_scale,
				"is_stack" = M.is_stack,
			)))
	data["recipes"] = recipes
	data["categories"] = categories

	return data

/obj/machinery/autolathe/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/sheetmaterials)
	)

/obj/machinery/autolathe/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	data["busy"] = busy
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	data["materials"] = materials.tgui_data(user, TRUE)
	data["mat_efficiency"] = mat_efficiency
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
	user.set_machine(src)
	interact(user)

/obj/machinery/autolathe/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	ui.user.set_machine(src)
	add_fingerprint(ui.user)

	if(busy)
		to_chat(ui.user, span_notice("The autolathe is busy. Please wait for completion of previous operation."))
		return
	switch(action)
		if("make")
			var/datum/category_item/autolathe/making = locate(params["make"])
			if(!istype(making))
				return
			if(making.hidden && !hacked)
				return

			var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)

			var/list/materials_used = list()

			var/multiplier = (params["multiplier"] || 1)

			if(making.is_stack)
				var/max_sheets
				for(var/material in making.resources)
					var/coeff = (making.no_scale ? 1 : mat_efficiency) //stacks are unaffected by production coefficient
					var/sheets = round(materials.get_material_amount(material) / round(making.resources[material] * coeff))
					if(isnull(max_sheets) || max_sheets > sheets)
						max_sheets = sheets
					if(!isnull(materials.get_material_amount(material)) && materials.get_material_amount(material) < round(making.resources[material] * coeff))
						max_sheets = 0
				//Build list of multipliers for sheets.
				multiplier = tgui_input_number(ui.user, "How many do you want to print? (0-[max_sheets])", null, null, max_sheets, 0)
				if(!multiplier || multiplier <= 0 || (multiplier != round(multiplier)) || multiplier > max_sheets || tgui_status(ui.user, state) != STATUS_INTERACTIVE)
					return FALSE

			//Check if we still have the materials.
			var/coeff = (making.no_scale ? 1 : mat_efficiency) //stacks are unaffected by production coefficient

			for(var/datum/material/used_material as anything in making.resources)
				var/amount_needed = making.resources[used_material] * coeff * multiplier
				materials_used[used_material] = amount_needed

			if(LAZYLEN(materials_used))
				if(!materials.has_materials(materials_used))
					return

				materials.use_materials(materials_used)

			busy = making.name
			update_use_power(USE_POWER_ACTIVE)

			update_icon() // So lid closes

			sleep(build_time)

			busy = 0
			update_use_power(USE_POWER_IDLE)
			update_icon() // So lid opens

			//Sanity check.
			if(!making || !src)
				return

			//Create the desired item.
			var/obj/item/I = new making.path(src.loc)

			if(LAZYLEN(I.matter))	// Sadly we must obey the laws of equivalent exchange.
				I.matter.Cut()
			else
				I.matter = list()

			for(var/material in making.resources)	// Handle the datum's autoscaling for waste, so we're properly wasting material, but not so much if we have efficiency.
				I.matter[material] = round(making.resources[material] / (making.no_scale ? 1 : 1.25)) * (making.no_scale ? 1 : mat_efficiency)

			flick("[initial(icon_state)]_finish", src)
			if(multiplier > 1)
				if(istype(I, /obj/item/stack))
					var/obj/item/stack/S = I
					S.set_amount(multiplier)
				else
					for(multiplier; multiplier > 1; --multiplier) // Create multiple items if it's not a stack.
						I = new making.path(src.loc)
						// We've already deducted the cost of multiple items. Process the matter the same.
						if(LAZYLEN(I.matter))
							I.matter.Cut()

						else
							I.matter = list()

						for(var/material in making.resources)
							I.matter[material] = round(making.resources[material] / (making.no_scale ? 1 : 1.25)) * (making.no_scale ? 1 : mat_efficiency)
			return TRUE
	return FALSE

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
	mb_rating = 0
	man_rating = 0
	for(var/obj/item/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	materials.max_amount = mb_rating * 75000

	build_time = 50 / man_rating
	mat_efficiency = 1.1 - man_rating * 0.1// Normally, price is 1.25 the amount of material, so this shouldn't go higher than 0.6. Maximum rating of parts is 5
	update_tgui_static_data(usr)

/obj/machinery/autolathe/dismantle()
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	materials.retrieve_all()
	return ..()

/obj/machinery/autolathe/proc/AfterMaterialInsert(obj/item/item_inserted, id_inserted, amount_inserted)
	flick("autolathe_loading", src)//plays metal insertion animation
	// use_power(min(1000, amount_inserted / 100))
	SStgui.update_uis(src)

/obj/machinery/autolathe/examine(mob/user)
	. = ..()
	var/datum/component/material_container/materials = GetComponent(/datum/component/material_container)
	if(in_range(user, src) || isobserver(user))
		. += span_notice("The status display reads: Storing up to <b>[materials.max_amount]</b> material units.<br>Material consumption at <b>[mat_efficiency*100]%</b>.")
