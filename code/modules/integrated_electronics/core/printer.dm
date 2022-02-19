
/obj/item/device/integrated_circuit_printer
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
	var/can_clone = FALSE		// Same for above, but will allow the printer to duplicate a specific assembly. (Not implemented)
//	var/static/list/recipe_list = list()
	var/obj/item/device/electronic_assembly/assembly_to_clone = null // Not implemented x3
	var/dirty_items = FALSE

/obj/item/device/integrated_circuit_printer/upgraded
	upgraded = TRUE
	can_clone = TRUE

/obj/item/device/integrated_circuit_printer/debug
	name = "fractal integrated circuit printer"
	desc = "A portable(ish) machine that makes modular circuitry seemingly out of thin air."
	upgraded = TRUE
	can_clone = TRUE
	debug = TRUE

/obj/item/device/integrated_circuit_printer/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return tgui_interact(user)
	else
		return ..()

/obj/item/device/integrated_circuit_printer/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/stack = O
		if(stack.material.name == MAT_STEEL)
			if(debug)
				to_chat(user, span("warning", "\The [src] does not need any material."))
				return
			var/num = min((max_metal - metal) / metal_per_sheet, stack.get_amount())
			if(num < 1)
				to_chat(user, span("warning", "\The [src] is too full to add more metal."))
				return
			if(stack.use(max(1, round(num)))) // We don't want to create stacks that aren't whole numbers
				to_chat(user, span("notice", "You add [num] sheet\s to \the [src]."))
				metal += num * metal_per_sheet
				attack_self(user)
				return TRUE

	if(istype(O,/obj/item/integrated_circuit))
		to_chat(user, span("notice", "You insert the circuit into \the [src]."))
		user.unEquip(O)
		metal = min(metal + O.w_class, max_metal)
		qdel(O)
		attack_self(user)
		return TRUE

	if(istype(O,/obj/item/weapon/disk/integrated_circuit/upgrade/advanced))
		if(upgraded)
			to_chat(user, span("warning", "\The [src] already has this upgrade."))
			return TRUE
		to_chat(user, span("notice", "You install \the [O] into  \the [src]."))
		upgraded = TRUE
		dirty_items = TRUE
		attack_self(user)
		return TRUE

	if(istype(O,/obj/item/weapon/disk/integrated_circuit/upgrade/clone))
		if(can_clone)
			to_chat(user, span("warning", "\The [src] already has this upgrade."))
			return TRUE
		to_chat(user, span("notice", "You install \the [O] into  \the [src]."))
		can_clone = TRUE
		attack_self(user)
		return TRUE

	return ..()

/obj/item/device/integrated_circuit_printer/vv_edit_var(var_name, var_value)
	// Gotta update the static data in case an admin VV's the upgraded var for some reason..!
	if(var_name == "upgraded")
		dirty_items = TRUE
	return ..()

/obj/item/device/integrated_circuit_printer/attack_self(var/mob/user)
	tgui_interact(user)

/obj/item/device/integrated_circuit_printer/tgui_state(mob/user)
	return GLOB.tgui_physical_state

/obj/item/device/integrated_circuit_printer/tgui_interact(mob/user, datum/tgui/ui)
	if(dirty_items)
		update_tgui_static_data(user, ui)
		dirty_items = FALSE

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ICPrinter", name) // 500, 600
		ui.open()

/obj/item/device/integrated_circuit_printer/tgui_static_data(mob/user)
	var/list/data = ..()

	var/list/categories = list()
	for(var/category in SScircuit.circuit_fabricator_recipe_list)
		var/list/cat_obj = list(
			"name" = category,
			"items" = null
		)
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
			if(ispath(path, /obj/item/device/electronic_assembly))
				var/obj/item/device/electronic_assembly/E = path
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

/obj/item/device/integrated_circuit_printer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["metal"] = metal
	data["max_metal"] = max_metal
	data["metal_per_sheet"] = metal_per_sheet
	data["debug"] = debug
	data["upgraded"] = upgraded
	data["can_clone"] = can_clone
	data["assembly_to_clone"] = assembly_to_clone

	return data

/obj/item/device/integrated_circuit_printer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	add_fingerprint(usr)

	switch(action)
		if("build")
			var/build_type = text2path(params["build"])
			if(!build_type || !ispath(build_type))
				return 1

			var/cost = 1

			if(ispath(build_type, /obj/item/device/electronic_assembly))
				var/obj/item/device/electronic_assembly/E = build_type
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
				if(!Adjacent(usr))
					to_chat(usr, "<span class='notice'>You are too far away from \the [src].</span>")
				if(metal - cost < 0)
					to_chat(usr, "<span class='warning'>You need [cost] metal to build that!.</span>")
					return 1
				metal -= cost
			var/obj/item/built = new build_type(get_turf(loc))
			usr.put_in_hands(built)
			to_chat(usr, "<span class='notice'>[capitalize(built.name)] printed.</span>")
			playsound(src, 'sound/items/jaws_pry.ogg', 50, TRUE)
			return TRUE

// FUKKEN UPGRADE DISKS
/obj/item/weapon/disk/integrated_circuit/upgrade
	name = "integrated circuit printer upgrade disk"
	desc = "Install this into your integrated circuit printer to enhance it."
	icon = 'icons/obj/integrated_electronics/electronic_tools.dmi'
	icon_state = "upgrade_disk"
	item_state = "card-id"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4)

/obj/item/weapon/disk/integrated_circuit/upgrade/advanced
	name = "integrated circuit printer upgrade disk - advanced designs"
	desc = "Install this into your integrated circuit printer to enhance it.  This one adds new, advanced designs to the printer."

// To be implemented later.
/obj/item/weapon/disk/integrated_circuit/upgrade/clone
	name = "integrated circuit printer upgrade disk - circuit cloner"
	desc = "Install this into your integrated circuit printer to enhance it.  This one allows the printer to duplicate assemblies."
	icon_state = "upgrade_disk_clone"
	origin_tech = list(TECH_ENGINEERING = 5, TECH_DATA = 6)
