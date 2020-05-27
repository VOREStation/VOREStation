/obj/machinery/mecha_part_fabricator
	icon = 'icons/obj/robotics_vr.dmi' //VOREStation Edit - New icon
	icon_state = "mechfab-idle"
	name = "Exosuit Fabricator"
	desc = "A machine used for construction of mechas."
	density = 1
	anchored = 1
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 5000
	req_access = list(access_robotics)
	circuit = /obj/item/weapon/circuitboard/mechfab

	var/speed = 1
	var/mat_efficiency = 1
	var/list/materials = list(DEFAULT_WALL_MATERIAL = 0, "glass" = 0, "plastic" = 0, MAT_GRAPHITE = 0, MAT_PLASTEEL = 0, "gold" = 0, "silver" = 0, MAT_LEAD = 0, "osmium" = 0, "diamond" = 0, MAT_DURASTEEL = 0, "phoron" = 0, "uranium" = 0, MAT_VERDANTIUM = 0, MAT_MORPHIUM = 0, MAT_METALHYDROGEN = 0, MAT_SUPERMATTER = 0)
	var/list/hidden_materials = list(MAT_PLASTEEL, MAT_DURASTEEL, MAT_GRAPHITE, MAT_VERDANTIUM, MAT_MORPHIUM, MAT_METALHYDROGEN, MAT_SUPERMATTER)
	var/res_max_amount = 200000

	var/datum/research/files
	var/list/datum/design/queue = list()
	var/progress = 0
	var/busy = 0

	var/list/categories = list()
	var/category = null
	var/sync_message = ""

/obj/machinery/mecha_part_fabricator/Initialize()
	. = ..()
	default_apply_parts()
	files = new /datum/research(src) //Setup the research data holder.
	update_categories()

/obj/machinery/mecha_part_fabricator/process()
	..()
	if(stat)
		return
	if(busy)
		update_use_power(USE_POWER_ACTIVE)
		progress += speed
		check_build()
	else
		update_use_power(USE_POWER_IDLE)
	update_icon()

/obj/machinery/mecha_part_fabricator/update_icon()
	overlays.Cut()
	if(panel_open)
		icon_state = "mechfab-o"
	else
		icon_state = "mechfab-idle"
	if(busy)
		overlays += "mechfab-active"

/obj/machinery/mecha_part_fabricator/dismantle()
	for(var/f in materials)
		eject_materials(f, -1)
	..()

/obj/machinery/mecha_part_fabricator/RefreshParts()
	res_max_amount = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		res_max_amount += M.rating * 100000 // 200k -> 600k
	var/T = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		T += M.rating
	mat_efficiency = max(1 - (T - 1) / 4, 0.2) // 1 -> 0.2
	for(var/obj/item/weapon/stock_parts/micro_laser/M in component_parts) // Not resetting T is intended; speed is affected by both
		T += M.rating
	speed = T / 2 // 1 -> 3

/obj/machinery/mecha_part_fabricator/attack_hand(var/mob/user)
	if(..())
		return
	if(!allowed(user))
		return
	ui_interact(user)

/obj/machinery/mecha_part_fabricator/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	var/datum/design/current = queue.len ? queue[1] : null
	if(current)
		data["current"] = current.name
	data["queue"] = get_queue_names()
	data["buildable"] = get_build_options()
	data["category"] = category
	data["categories"] = categories
	data["materials"] = get_materials()
	data["maxres"] = res_max_amount
	data["sync"] = sync_message
	if(current)
		data["builtperc"] = round((progress / current.time) * 100)

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "mechfab.tmpl", "Exosuit Fabricator UI", 800, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/mecha_part_fabricator/Topic(href, href_list)
	if(..())
		return

	if(href_list["build"])
		add_to_queue(text2num(href_list["build"]))

	if(href_list["remove"])
		remove_from_queue(text2num(href_list["remove"]))

	if(href_list["category"])
		if(href_list["category"] in categories)
			category = href_list["category"]

	if(href_list["eject"])
		eject_materials(href_list["eject"], text2num(href_list["amount"]))

	if(href_list["sync"])
		sync()
	else
		sync_message = ""

	return 1

/obj/machinery/mecha_part_fabricator/attackby(var/obj/item/I, var/mob/user)
	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
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
			to_chat(user, "<span class='warning'>The [src] doesn't accept [S.material]!</span>")
			return

		var/sname = "[S.name]"
		var/amnt = S.perunit
		if(materials[S.material.name] + amnt <= res_max_amount)
			if(S && S.get_amount() >= 1)
				var/count = 0
				overlays += "mechfab-load-metal"
				spawn(10)
					overlays -= "mechfab-load-metal"
				while(materials[S.material.name] + amnt <= res_max_amount && S.get_amount() >= 1)
					materials[S.material.name] += amnt
					S.use(1)
					count++
				to_chat(user, "You insert [count] [sname] into the fabricator.")
				update_busy()
		else
			to_chat(user, "The fabricator cannot hold more [sname].")

		return

	..()

/obj/machinery/mecha_part_fabricator/emag_act(var/remaining_charges, var/mob/user)
	switch(emagged)
		if(0)
			emagged = 0.5
			visible_message("[bicon(src)] <b>[src]</b> beeps: \"DB error \[Code 0x00F1\]\"")
			sleep(10)
			visible_message("[bicon(src)] <b>[src]</b> beeps: \"Attempting auto-repair\"")
			sleep(15)
			visible_message("[bicon(src)] <b>[src]</b> beeps: \"User DB corrupted \[Code 0x00FA\]. Truncating data structure...\"")
			sleep(30)
			visible_message("[bicon(src)] <b>[src]</b> beeps: \"User DB truncated. Please contact your [using_map.company_name] system operator for future assistance.\"")
			req_access = null
			emagged = 1
			return 1
		if(0.5)
			visible_message("[bicon(src)] <b>[src]</b> beeps: \"DB not responding \[Code 0x0003\]...\"")
		if(1)
			visible_message("[bicon(src)] <b>[src]</b> beeps: \"No records in User DB\"")

/obj/machinery/mecha_part_fabricator/proc/update_busy()
	if(queue.len)
		if(can_build(queue[1]))
			busy = 1
		else
			busy = 0
	else
		busy = 0

/obj/machinery/mecha_part_fabricator/proc/add_to_queue(var/index)
	var/datum/design/D = files.known_designs[index]
	queue += D
	update_busy()

/obj/machinery/mecha_part_fabricator/proc/remove_from_queue(var/index)
	if(index == 1)
		progress = 0
	queue.Cut(index, index + 1)
	update_busy()

/obj/machinery/mecha_part_fabricator/proc/can_build(var/datum/design/D)
	for(var/M in D.materials)
		if(materials[M] < (D.materials[M] * mat_efficiency))
			return 0
	return 1

/obj/machinery/mecha_part_fabricator/proc/check_build()
	if(!queue.len)
		progress = 0
		return
	var/datum/design/D = queue[1]
	if(!can_build(D))
		progress = 0
		return
	if(D.time > progress)
		return
	for(var/M in D.materials)
		materials[M] = max(0, materials[M] - D.materials[M] * mat_efficiency)
	if(D.build_path)
		var/obj/new_item = D.Fabricate(get_step(get_turf(src), src.dir), src)
		visible_message("\The [src] pings, indicating that \the [D] is complete.", "You hear a ping.")
		if(mat_efficiency != 1)
			if(new_item.matter && new_item.matter.len > 0)
				for(var/i in new_item.matter)
					new_item.matter[i] = new_item.matter[i] * mat_efficiency
	remove_from_queue(1)

/obj/machinery/mecha_part_fabricator/proc/get_queue_names()
	. = list()
	for(var/i = 2 to queue.len)
		var/datum/design/D = queue[i]
		. += D.name

/obj/machinery/mecha_part_fabricator/proc/get_build_options()
	. = list()
	for(var/i = 1 to files.known_designs.len)
		var/datum/design/D = files.known_designs[i]
		if(!D.build_path || !(D.build_type & MECHFAB))
			continue
		. += list(list("name" = D.name, "id" = i, "category" = D.category, "resourses" = get_design_resourses(D), "time" = get_design_time(D)))

/obj/machinery/mecha_part_fabricator/proc/get_design_resourses(var/datum/design/D)
	var/list/F = list()
	for(var/T in D.materials)
		F += "[capitalize(T)]: [D.materials[T] * mat_efficiency]"
	return english_list(F, and_text = ", ")

/obj/machinery/mecha_part_fabricator/proc/get_design_time(var/datum/design/D)
	return time2text(round(10 * D.time / speed), "mm:ss")

/obj/machinery/mecha_part_fabricator/proc/update_categories()
	categories = list()
	for(var/datum/design/D in files.known_designs)
		if(!D.build_path || !(D.build_type & MECHFAB))
			continue
		categories |= D.category
	if(!category || !(category in categories))
		category = categories[1]

/obj/machinery/mecha_part_fabricator/proc/get_materials()
	. = list()
	for(var/T in materials)
		var/hidden_mat = FALSE
		for(var/HM in hidden_materials) // Direct list contents comparison was failing.
			if(T == HM && materials[T] == 0)
				hidden_mat = TRUE
				continue
		if(!hidden_mat)
			. += list(list("mat" = capitalize(T), "amt" = materials[T]))

/obj/machinery/mecha_part_fabricator/proc/eject_materials(var/material, var/amount) // 0 amount = 0 means ejecting a full stack; -1 means eject everything
	var/recursive = amount == -1 ? 1 : 0
	var/matstring = lowertext(material)
	var/material/M = get_material_by_name(matstring)

	var/obj/item/stack/material/S = M.place_sheet(get_turf(src))
	if(amount <= 0)
		amount = S.max_amount
	var/ejected = min(round(materials[matstring] / S.perunit), amount)
	S.amount = min(ejected, amount)
	if(S.amount <= 0)
		qdel(S)
		return
	materials[matstring] -= ejected * S.perunit
	if(recursive && materials[matstring] >= S.perunit)
		eject_materials(matstring, -1)
	update_busy()

/obj/machinery/mecha_part_fabricator/proc/sync()
	sync_message = "Error: no console found."
	for(var/obj/machinery/computer/rdconsole/RDC in get_area_all_atoms(get_area(src)))
		if(!RDC.sync)
			continue
		for(var/datum/tech/T in RDC.files.known_tech)
			files.AddTech2Known(T)
		for(var/datum/design/D in RDC.files.known_designs)
			files.AddDesign2Known(D)
		files.RefreshResearch()
		sync_message = "Sync complete."
	update_categories()
