
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
	var/current_category = null
	var/obj/item/device/electronic_assembly/assembly_to_clone = null

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
		return interact(user)
	else
		return ..()

/obj/item/device/integrated_circuit_printer/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/stack = O
		if(stack.material.name == DEFAULT_WALL_MATERIAL)
			if(debug)
				to_chat(user, span("warning", "\The [src] does not need any material."))
				return
			var/num = min((max_metal - metal) / metal_per_sheet, stack.amount)
			if(num < 1)
				to_chat(user, span("warning", "\The [src] is too full to add more metal."))
				return
			if(stack.use(max(1, round(num)))) // We don't want to create stacks that aren't whole numbers
				to_chat(user, span("notice", "You add [num] sheet\s to \the [src]."))
				metal += num * metal_per_sheet
				interact(user)
				return TRUE

	if(istype(O,/obj/item/integrated_circuit))
		to_chat(user, span("notice", "You insert the circuit into \the [src]."))
		user.unEquip(O)
		metal = min(metal + O.w_class, max_metal)
		qdel(O)
		interact(user)
		return TRUE

	if(istype(O,/obj/item/weapon/disk/integrated_circuit/upgrade/advanced))
		if(upgraded)
			to_chat(user, span("warning", "\The [src] already has this upgrade."))
			return TRUE
		to_chat(user, span("notice", "You install \the [O] into  \the [src]."))
		upgraded = TRUE
		interact(user)
		return TRUE

	if(istype(O,/obj/item/weapon/disk/integrated_circuit/upgrade/clone))
		if(can_clone)
			to_chat(user, span("warning", "\The [src] already has this upgrade."))
			return TRUE
		to_chat(user, span("notice", "You install \the [O] into  \the [src]."))
		can_clone = TRUE
		interact(user)
		return TRUE

	return ..()

/obj/item/device/integrated_circuit_printer/attack_self(var/mob/user)
	interact(user)

/obj/item/device/integrated_circuit_printer/interact(mob/user)
	var/window_height = 600
	var/window_width = 500

	if(isnull(current_category))
		current_category = SScircuit.circuit_fabricator_recipe_list[1]

	var/HTML = "<center><h2>Integrated Circuit Printer</h2></center><br>"
	if(!debug)
		HTML += "Metal: [metal/metal_per_sheet]/[max_metal/metal_per_sheet] sheets.<br>"
	else
		HTML += "Metal: INFINITY.<br>"
	HTML += "Circuits available: [upgraded ? "Advanced":"Regular"].<br>"
	HTML += "Assembly Cloning: [can_clone ? "Available": "Unavailable"].<br>"
	if(assembly_to_clone)
		HTML += "Assembly '[assembly_to_clone.name]' loaded.<br>"
	HTML += "Crossed out circuits mean that the printer is not sufficentally upgraded to create that circuit.<br>"
	HTML += "<hr>"
	HTML += "Categories:"
	for(var/category in SScircuit.circuit_fabricator_recipe_list)
		if(category != current_category)
			HTML += " <a href='?src=\ref[src];category=[category]'>\[[category]\]</a> "
		else // Bold the button if it's already selected.
			HTML += " <b>\[[category]\]</b> "
	HTML += "<hr>"
	HTML += "<center><h4>[current_category]</h4></center>"

	var/list/current_list = SScircuit.circuit_fabricator_recipe_list[current_category]
	for(var/path in current_list)
		var/obj/O = path
		var/can_build = TRUE
		if(ispath(path, /obj/item/integrated_circuit))
			var/obj/item/integrated_circuit/IC = path
			if((initial(IC.spawn_flags) & IC_SPAWN_RESEARCH) && (!(initial(IC.spawn_flags) & IC_SPAWN_DEFAULT)) && !upgraded)
				can_build = FALSE
		if(can_build)
			HTML += "<A href='?src=\ref[src];build=[path]'>\[[initial(O.name)]\]</A>: [initial(O.desc)]<br>"
		else
			HTML += "<s>\[[initial(O.name)]\]</s>: [initial(O.desc)]<br>"

	user << browse(jointext(HTML, null), "window=integrated_printer;size=[window_width]x[window_height];border=1;can_resize=1;can_close=1;can_minimize=1")


/obj/item/device/integrated_circuit_printer/Topic(href, href_list)
	if(..())
		return 1

	add_fingerprint(usr)

	if(href_list["category"])
		current_category = href_list["category"]

	if(href_list["build"])
		var/build_type = text2path(href_list["build"])
		if(!build_type || !ispath(build_type))
			return 1

		var/cost = 1

		if(isnull(current_category))
			current_category = SScircuit.circuit_fabricator_recipe_list[1]
		if(ispath(build_type, /obj/item/device/electronic_assembly))
			var/obj/item/device/electronic_assembly/E = build_type
			cost = round( (initial(E.max_complexity) + initial(E.max_components) ) / 4)
		else
			var/obj/item/I = build_type
			cost = initial(I.w_class)
		if(!(build_type in SScircuit.circuit_fabricator_recipe_list[current_category]))
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

	interact(usr)


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
