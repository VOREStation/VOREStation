/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using metal and glass."
	icon_state = "autolathe"
	density = 1
	anchored = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = "keyboard"
	clickvol = 30

	circuit = /obj/item/weapon/circuitboard/autolathe

	var/static/datum/category_collection/autolathe/autolathe_recipes
	var/list/stored_material =  list(DEFAULT_WALL_MATERIAL = 0, MAT_GLASS = 0, MAT_PLASTEEL = 0, MAT_PLASTIC = 0)
	var/list/storage_capacity = list(DEFAULT_WALL_MATERIAL = 0, MAT_GLASS = 0, MAT_PLASTEEL = 0, MAT_PLASTIC = 0)

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

/obj/machinery/autolathe/Initialize()
	. = ..()
	if(!autolathe_recipes)
		autolathe_recipes = new()
	wires = new(src)

	for(var/Name in name_to_material)
		if(Name in stored_material)
			continue

		stored_material[Name] = 0
		storage_capacity[Name] = 0

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

	var/list/material_data = list()
	for(var/mat_id in stored_material)
		var/amount = stored_material[mat_id]
		var/list/material_info = list(
			"name" = mat_id,
			"amount" = amount,
			"sheets" = round(amount / SHEET_MATERIAL_AMOUNT),
			"removable" = amount >= SHEET_MATERIAL_AMOUNT
		)
		material_data += list(material_info)
	data["busy"] = busy
	data["materials"] = material_data
	data["mat_efficiency"] = mat_efficiency
	return data

/obj/machinery/autolathe/interact(mob/user)
	if(panel_open)
		return wires.Interact(user)

	if(disabled)
		to_chat(user, "<span class='danger'>\The [src] is disabled!</span>")
		return

	if(shocked)
		shock(user, 50)
	
	tgui_interact(user)

/obj/machinery/autolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
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
		if(O.is_multitool() || O.is_wirecutter())
			wires.Interact(user)
			return

	if(O.loc != user && !(istype(O,/obj/item/stack)))
		return 0

	if(is_robot_module(O))
		return 0

	if(istype(O,/obj/item/ammo_magazine/clip) || istype(O,/obj/item/ammo_magazine/s357) || istype(O,/obj/item/ammo_magazine/s38) || istype (O,/obj/item/ammo_magazine/s44)/* VOREstation Edit*/) // Prevents ammo recycling exploit with speedloaders.
		to_chat(user, "\The [O] is too hazardous to recycle with the autolathe!")
		return

	//Resources are being loaded.
	var/obj/item/eating = O
	if(!eating.matter)
		to_chat(user, "\The [eating] does not contain significant amounts of useful materials and cannot be accepted.")
		return

	var/filltype = 0       // Used to determine message.
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.

	for(var/material in eating.matter)

		if(isnull(stored_material[material]) || isnull(storage_capacity[material]))
			continue

		if(stored_material[material] >= storage_capacity[material])
			continue

		var/total_material = eating.matter[material]

		//If it's a stack, we eat multiple sheets.
		if(istype(eating,/obj/item/stack))
			var/obj/item/stack/stack = eating
			total_material *= stack.get_amount()

		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
			filltype = 1
		else
			filltype = 2

		stored_material[material] += total_material
		total_used += total_material
		mass_per_sheet += eating.matter[material]

	if(!filltype)
		to_chat(user, "<span class='notice'>\The [src] is full. Please remove material from the autolathe in order to insert more.</span>")
		return
	else if(filltype == 1)
		to_chat(user, "You fill \the [src] to capacity with \the [eating].")
	else
		to_chat(user, "You fill \the [src] with \the [eating].")

	flick("autolathe_loading", src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1, round(total_used/mass_per_sheet))) // Always use at least 1 to prevent infinite materials.
	else
		user.remove_from_mob(O)
		qdel(O)

	updateUsrDialog()
	return

/obj/machinery/autolathe/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/autolathe/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	usr.set_machine(src)
	add_fingerprint(usr)

	if(busy)
		to_chat(usr, "<span class='notice'>The autolathe is busy. Please wait for completion of previous operation.</span>")
		return
	switch(action)
		if("make")
			var/datum/category_item/autolathe/making = locate(params["make"])
			if(!istype(making))
				return
			if(making.hidden && !hacked)
				return

			var/multiplier = 1

			if(making.is_stack)
				var/max_sheets
				for(var/material in making.resources)
					var/coeff = (making.no_scale ? 1 : mat_efficiency) //stacks are unaffected by production coefficient
					var/sheets = round(stored_material[material]/round(making.resources[material]*coeff))
					if(isnull(max_sheets) || max_sheets > sheets)
						max_sheets = sheets
					if(!isnull(stored_material[material]) && stored_material[material] < round(making.resources[material]*coeff))
						max_sheets = 0
				//Build list of multipliers for sheets.
				multiplier = input(usr, "How many do you want to print? (0-[max_sheets])") as num|null
				if(!multiplier || multiplier <= 0 || multiplier > max_sheets || tgui_status(usr, state) != STATUS_INTERACTIVE)
					return FALSE

			busy = making.name
			update_use_power(USE_POWER_ACTIVE)

			//Check if we still have the materials.
			var/coeff = (making.no_scale ? 1 : mat_efficiency) //stacks are unaffected by production coefficient
			for(var/material in making.resources)
				if(!isnull(stored_material[material]))
					if(stored_material[material] < round(making.resources[material] * coeff) * multiplier)
						return

			//Consume materials.
			for(var/material in making.resources)
				if(!isnull(stored_material[material]))
					stored_material[material] = max(0, stored_material[material] - round(making.resources[material] * coeff) * multiplier)

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
					S.amount = multiplier
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
	overlays.Cut()

	icon_state = initial(icon_state)

	if(panel_open)
		overlays.Add(image(icon, "[icon_state]_panel"))
	if(stat & NOPOWER)
		return
	if(busy)
		icon_state = "[icon_state]_work"

//Updates overall lathe storage size.
/obj/machinery/autolathe/RefreshParts()
	..()
	mb_rating = 0
	man_rating = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	for(var/mat_name in storage_capacity)
		storage_capacity[mat_name] = mb_rating * 25000

	build_time = 50 / man_rating
	mat_efficiency = 1.1 - man_rating * 0.1// Normally, price is 1.25 the amount of material, so this shouldn't go higher than 0.6. Maximum rating of parts is 5
	update_tgui_static_data(usr)

/obj/machinery/autolathe/dismantle()
	for(var/mat in stored_material)
		var/datum/material/M = get_material_by_name(mat)
		if(!istype(M))
			continue
		var/obj/item/stack/material/S = new M.stack_type(get_turf(src))
		if(stored_material[mat] > S.perunit)
			S.amount = round(stored_material[mat] / S.perunit)
		else
			qdel(S)
	..()
	return 1

/obj/machinery/autolathe/proc/eject_materials(var/material, var/amount) // 0 amount = 0 means ejecting a full stack; -1 means eject everything
	var/recursive = amount == -1 ? 1 : 0
	var/matstring = lowertext(material)
	var/datum/material/M = get_material_by_name(matstring)

	var/obj/item/stack/material/S = M.place_sheet(get_turf(src))
	if(amount <= 0)
		amount = S.max_amount
	var/ejected = min(round(stored_material[matstring] / S.perunit), amount)
	S.amount = min(ejected, amount)
	if(S.amount <= 0)
		qdel(S)
		return
	stored_material[matstring] -= ejected * S.perunit
	if(recursive && stored_material[matstring] >= S.perunit)
		eject_materials(matstring, -1)
