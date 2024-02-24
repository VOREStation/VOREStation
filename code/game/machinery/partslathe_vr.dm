/*
** The Parts Lathe! Able to produce all tech level 1 stock parts for building machines!
**
** The idea is that engineering etc should be able to build/repair basic technology machines
** without having to use a protolathe to print what are not prototype technologies.
** Some felt having an autolathe do this might be OP, so its a separate machine.
**
** The other advantage is that this machine, specially focused for helping build stuff,
** actually reads circuit boards, tells you what parts are needed to build them, and
** can automatically queue them up to build!
**
** Leshana says:
** - Phase 1 of this project adds the machine and basic operation.
** - Phase 2 will enhance usability by making & labeling boxes with a set of parts.
**
** TODO - Implement phase 2 by adding cardboard boxes
*/

/obj/machinery/partslathe
	name = "parts lathe"
	icon = 'icons/obj/partslathe_vr.dmi'
	icon_state = "partslathe-idle"
	circuit = /obj/item/weapon/circuitboard/partslathe
	anchored = TRUE
	density = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 5000

	// Amount of materials we can store total
	var/list/materials = list(MAT_STEEL = 0, MAT_GLASS = 0)
	var/list/storage_capacity = list(MAT_STEEL = 0, MAT_GLASS = 0)

	var/obj/item/weapon/circuitboard/copy_board // Inserted board

	var/list/datum/category_item/partslathe/queue = list() // Queue of things to build
	var/busy = 0			// Currently building stuff y/n
	var/progress = 0		// How many machine ticks have we spent building current thing?
	var/mat_efficiency = 3	// Material usage efficiency (less efficient than protolathe)
	var/speed = 1			// Ticks per tick build speed multiplier

	// Static list of recipies we will lazily generate
	// type -> /datum/category_item/partslathe/
	var/static/list/partslathe_recipies

/obj/machinery/partslathe/New()
	..()
	default_apply_parts()
	update_icon()
	update_recipe_list()

/obj/machinery/partslathe/proc/getHighestOriginTechLevel(var/obj/item/I)
	if(!istype(I) || !I.origin_tech)
		return 0
	var/highest = 0
	for(var/tech in I.origin_tech)
		highest = max(highest, I.origin_tech[tech])
	return highest

/obj/machinery/partslathe/RefreshParts()
	var/mb_rating = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		mb_rating += M.rating
	storage_capacity[MAT_STEEL] = mb_rating  * 16000
	storage_capacity["glass"] = mb_rating  * 8000
	var/T = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		T += M.rating
	mat_efficiency = 6 / T // Ranges from 3.0 to 1.0
	speed = T / 2 // Ranges from 1.0 to 3.0

/obj/machinery/partslathe/dismantle()
	for(var/f in materials)
		eject_materials(f, -1)
	..()

/obj/machinery/partslathe/update_icon()
	if(panel_open)
		icon_state = "partslathe-open"
	else if(inoperable())
		icon_state = "partslathe-off"
	else if(busy)
		icon_state = "partslathe-lidclose"
	else
		if(icon_state == "partslathe-lidclose")
			flick("partslathe-lidopen", src)
		icon_state = "partslathe-idle"

/obj/machinery/partslathe/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
		return 1
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(inoperable())
		return
	if(panel_open)
		to_chat(user, "<span class='notice'>You can't load \the [src] while it's opened.</span>")
		return
	if(istype(O, /obj/item/weapon/circuitboard))
		if(copy_board)
			to_chat(user, "<span class='warning'>There is already a board inserted in \the [src].</span>")
			return
		if(!user.unEquip(O))
			return
		copy_board = O
		O.forceMove(src)
		user.visible_message("[user] inserts [O] into \the [src]'s circuit reader.", "<span class='notice'>You insert [O] into \the [src]'s circuit reader.</span>")
		updateUsrDialog()
		return
	if(try_load_materials(user, O))
		return
	else
		to_chat(user, "<span class='notice'>You cannot insert this item into \the [src]!</span>")
		return

// Attept to load materials.  Returns 0 if item wasn't a stack of materials, otherwise 1 (even if failed to load)
/obj/machinery/partslathe/proc/try_load_materials(var/mob/user, var/obj/item/stack/material/S)
	if(!istype(S))
		return 0
	if(!(S.material.name in materials))
		to_chat(user, "<span class='warning'>The [src] doesn't accept [S.material]!</span>")
		return 1
	if(S.get_amount() < 1)
		return 1 // Does this even happen? Sanity check I guess.
	var/max_res_amount = storage_capacity[S.material.name]
	if(materials[S.material.name] + S.perunit <= max_res_amount)
		var/count = 0
		while(materials[S.material.name] + S.perunit <= max_res_amount && S.get_amount() >= 1)
			materials[S.material.name] += S.perunit
			S.use(1)
			count++
		user.visible_message("[user] inserts [S.name] into \the [src].", "<span class='notice'>You insert [count] [S.name] into \the [src].</span>")
		flick("partslathe-load-[S.material.name]", src)
		updateUsrDialog()
	else
		to_chat(user, "<span class='warning'>\The [src] cannot hold more [S.name].</span>")
	return 1

/obj/machinery/partslathe/process()
	..()
	if(stat)
		update_icon()
		return
	if(queue.len == 0)
		if (busy)
			ping() // Job's done!
		busy = 0
		update_icon()
		return
	var/datum/category_item/partslathe/D = queue[1]
	if(canBuild(D))
		busy = 1
		update_use_power(USE_POWER_ACTIVE)
		progress += speed
		if(progress >= D.time)
			build(D)
			progress = 0
			removeFromQueue(1)
		update_icon()
	else if(busy)
		visible_message("<span class='notice'>\icon [src] flashes: insufficient materials: [getLackingMaterials(D)].</span>")
		busy = 0
		update_use_power(USE_POWER_IDLE)
		update_icon()
		playsound(src, 'sound/machines/chime.ogg', 50, 0)

/obj/machinery/partslathe/proc/addToQueue(var/datum/category_item/partslathe/D)
	queue += D
	return

/obj/machinery/partslathe/proc/removeFromQueue(var/index)
	queue.Cut(index, index + 1)
	return

/obj/machinery/partslathe/proc/canBuild(var/datum/category_item/partslathe/D)
	for(var/M in D.resources)
		if(materials[M] < CEILING((D.resources[M] * mat_efficiency), 1))
			return 0
	return 1

/obj/machinery/partslathe/proc/getLackingMaterials(var/datum/category_item/partslathe/D)
	var/ret = ""
	for(var/M in D.resources)
		if(materials[M] < CEILING((D.resources[M] * mat_efficiency), 1))
			if(ret != "")
				ret += ", "
			ret += "[CEILING((D.resources[M] * mat_efficiency), 1) - materials[M]] [M]"
	return ret

/obj/machinery/partslathe/proc/build(var/datum/category_item/partslathe/D)
	for(var/M in D.resources)
		materials[M] = max(0, materials[M] - CEILING((D.resources[M] * mat_efficiency), 1))
	var/obj/new_item = D.build(loc);
	if(new_item)
		new_item.loc = loc
		if(mat_efficiency < 1) // No matter out of nowhere
			if(new_item.matter && new_item.matter.len > 0)
				for(var/i in new_item.matter)
					new_item.matter[i] = CEILING((new_item.matter[i] * mat_efficiency), 1)

// 0 amount = 0 means ejecting a full stack; -1 means eject everything
/obj/machinery/partslathe/proc/eject_materials(var/material, var/amount)
	var/recursive = amount == -1 ? TRUE : FALSE
	material = lowertext(material)
	var/mattype
	switch(material)
		if(MAT_STEEL)
			mattype = /obj/item/stack/material/steel
		if("glass")
			mattype = /obj/item/stack/material/glass
		else
			return
	var/obj/item/stack/material/S = new mattype(loc)
	if(amount <= 0)
		amount = S.max_amount
	var/ejected = min(round(materials[material] / S.perunit), amount)
	if(!S.set_amount(min(ejected, amount)))
		return
	materials[material] -= ejected * S.perunit
	if(recursive && materials[material] >= S.perunit)
		eject_materials(material, -1)

/obj/machinery/partslathe/attack_ai(mob/user)
	src.attack_hand(user)

/obj/machinery/partslathe/attack_hand(mob/user)
	if(..())
		return
	tgui_interact(user)

/obj/machinery/partslathe/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/sheetmaterials)
	)

/obj/machinery/partslathe/tgui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PartsLathe", name)
		ui.open()

/obj/machinery/partslathe/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	data["panelOpen"] = panel_open

	var/list/materials_ui = list()
	for(var/M in materials)
		materials_ui.Add(list(list(
			"name" = M,
			"amount" = materials[M],
			"sheets" = round(materials[M] / SHEET_MATERIAL_AMOUNT),
			"removable" = materials[M] >= SHEET_MATERIAL_AMOUNT,
		)))
	data["materials"] = materials_ui

	data["copyBoard"] = null
	data["copyBoardReqComponents"] = null
	if(istype(copy_board))
		data["copyBoard"] = copy_board.name
		var/list/req_components_ui = list()
		for(var/obj/comp_path as anything in (copy_board.req_components || list()))
			var/comp_amt = copy_board.req_components[comp_path]
			if(comp_amt && (comp_path in partslathe_recipies))
				req_components_ui.Add(list(list("name" = initial(comp_path.name), "qty" = comp_amt)))
		data["copyBoardReqComponents"] = req_components_ui

	data["queue"] = list()
	for(var/datum/category_item/partslathe/Q in queue)
		data["queue"] += Q.name

	data["building"] = null
	data["buildPercent"] = null
	if(busy && queue.len > 0)
		var/datum/category_item/partslathe/current = queue[1]
		data["building"] = current.name
		data["buildPercent"] = (progress / current.time * 100)
	
	data["error"] = null
	if(queue.len > 0 && !canBuild(queue[1]))
		data["error"] = getLackingMaterials(queue[1])

	var/list/recipies_ui = list()
	for(var/T in partslathe_recipies)
		var/datum/category_item/partslathe/R = partslathe_recipies[T]
		recipies_ui.Add(list(list("name" = R.name, "type" = "[T]")))
	data["recipies"] = recipies_ui

	return data

/obj/machinery/partslathe/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(usr)
	switch(action)
		// Queue management can be done even while busy
		if("queue")
			var/type_to_build = text2path(params["queue"])
			var/datum/category_item/partslathe/to_build = partslathe_recipies[type_to_build]
			if(to_build)
				addToQueue(to_build)
			return TRUE

		if("queueBoard")
			if(!istype(copy_board) || !copy_board.req_components)
				return
			for(var/comp_path in copy_board.req_components)
				var/comp_amt = copy_board.req_components[comp_path]
				if(!comp_amt)
					continue
				var/datum/category_item/partslathe/to_build = partslathe_recipies[comp_path]
				if(!to_build)
					continue // We don't support building whatever this is
				for(var/i in 1 to comp_amt)
					addToQueue(to_build)
			return TRUE

		if("cancel")
			var/index = text2num(params["cancel"])
			if(index < 1 || index > queue.len)
				return
			if(busy && index == 1)
				return
			removeFromQueue(index)
			return TRUE

	if(busy)
		to_chat(usr, "<span class='notice'>[src] is busy. Please wait for completion of previous operation.</span>")
		return

	switch(action)
		if("ejectBoard")
			if(copy_board)
				visible_message("<span class='notice'>[copy_board] is ejected from [src]'s circuit reader</span>.")
				copy_board.forceMove(src.loc)
				copy_board = null
			return TRUE

		if("remove_mat")
			// Remove a material from the fab
			var/mat_id = params["id"]
			var/amount = text2num(params["amount"])
			eject_materials(mat_id, amount)
			return

/** Build list of recipies to include all tech level 1 stock parts. */
/obj/machinery/partslathe/proc/update_recipe_list()
	if(!partslathe_recipies)
		partslathe_recipies = list()
		var/list/paths = subtypesof(/obj/item/weapon/stock_parts)
		for(var/type in paths)
			var/obj/item/weapon/stock_parts/I = new type()
			if(getHighestOriginTechLevel(I) > 1)
				qdel(I)
				continue // Ignore high-tech parts
			if(!I.matter)
				qdel(I)
				continue // Ignore parts we can't build

			var/datum/category_item/partslathe/recipie = new()
			recipie.name = I.name
			recipie.path = type
			recipie.resources = list()
			for(var/material in I.matter)
				recipie.resources[material] = I.matter[material]*1.25 // More expensive to produce than they are to recycle.
			partslathe_recipies[type] = recipie
			qdel(I)

/***************************
* Parts Lathe Recipie Type *
***************************/

/datum/category_item/partslathe
	var/path
	var/list/resources
	var/time = 2 // In machine controller ticks, so about 4 seconds.

/datum/category_item/partslathe/dd_SortValue()
	return name

/datum/category_item/partslathe/proc/build(var/loc)
	return new path(loc)
