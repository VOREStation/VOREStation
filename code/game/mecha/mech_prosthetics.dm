/obj/machinery/pros_fabricator
	icon = 'icons/obj/robotics_vr.dmi' //VOREStation Edit - New icon
	icon_state = "fab-idle"
	name = "Prosthetics Fabricator"
	desc = "A machine used for construction of prosthetics."
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 20
	active_power_usage = 5000
	req_access = list(access_robotics)
	circuit = /obj/item/weapon/circuitboard/prosthetics

	var/speed = 1
	var/mat_efficiency = 1
	var/list/materials = list(DEFAULT_WALL_MATERIAL = 0, "glass" = 0, "plastic" = 0, MAT_GRAPHITE = 0, MAT_PLASTEEL = 0, "gold" = 0, "silver" = 0, MAT_LEAD = 0, "osmium" = 0, "diamond" = 0, MAT_DURASTEEL = 0, "phoron" = 0, "uranium" = 0, MAT_VERDANTIUM = 0, MAT_MORPHIUM = 0)
	var/list/hidden_materials = list(MAT_DURASTEEL, MAT_GRAPHITE, MAT_VERDANTIUM, MAT_MORPHIUM)
	var/res_max_amount = 200000

	var/datum/research/files
	var/list/datum/design/queue = list()
	var/progress = 0
	var/busy = 0

	var/list/categories = list()
	var/category = null
	var/manufacturer = null
	var/species_types = list("Human")
	var/species = "Human"
	var/sync_message = ""

/obj/machinery/pros_fabricator/New()
	..()
	component_parts = list()
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()

	files = new /datum/research(src) //Setup the research data holder.
	return

/obj/machinery/pros_fabricator/Initialize()
	. = ..()
	manufacturer = basic_robolimb.company
	update_categories()

/obj/machinery/pros_fabricator/process()
	..()
	if(stat)
		return
	if(busy)
		use_power = 2
		progress += speed
		check_build()
	else
		use_power = 1
	update_icon()

/obj/machinery/pros_fabricator/update_icon()
	overlays.Cut()
	if(panel_open)
		icon_state = "fab-o"
	else
		icon_state = "fab-idle"
	if(busy)
		overlays += "fab-active"

/obj/machinery/pros_fabricator/dismantle()
	for(var/f in materials)
		eject_materials(f, -1)
	..()

/obj/machinery/pros_fabricator/RefreshParts()
	res_max_amount = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		res_max_amount += M.rating * 100000 // 200k -> 600k
	var/T = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		T += M.rating
	mat_efficiency = max(0.2, 1 - (T - 1) / 4) // 1 -> 0.2
	for(var/obj/item/weapon/stock_parts/micro_laser/M in component_parts) // Not resetting T is intended; speed is affected by both
		T += M.rating
	speed = T / 2 // 1 -> 3

/obj/machinery/pros_fabricator/attack_hand(var/mob/user)
	if(..())
		return
	if(!allowed(user))
		return
	ui_interact(user)

/obj/machinery/pros_fabricator/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	var/datum/design/current = queue.len ? queue[1] : null
	if(current)
		data["current"] = current.name
	data["queue"] = get_queue_names()
	data["buildable"] = get_build_options()
	data["category"] = category
	data["categories"] = categories
	data["species_types"] = species_types
	data["species"] = species
	if(all_robolimbs)
		var/list/T = list()
		for(var/A in all_robolimbs)
			var/datum/robolimb/R = all_robolimbs[A]
			if(R.unavailable_to_build) continue
			if(species in R.species_cannot_use) continue
			T += list(list("id" = A, "company" = R.company))
		data["manufacturers"] = T
		data["manufacturer"] = manufacturer
	data["materials"] = get_materials()
	data["maxres"] = res_max_amount
	data["sync"] = sync_message
	if(current)
		data["builtperc"] = round((progress / current.time) * 100)

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "mechfab.tmpl", "Prosthetics Fab UI", 800, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/pros_fabricator/Topic(href, href_list)
	if(..())
		return

	if(href_list["build"])
		add_to_queue(text2num(href_list["build"]))

	if(href_list["remove"])
		remove_from_queue(text2num(href_list["remove"]))

	if(href_list["category"])
		if(href_list["category"] in categories)
			category = href_list["category"]

	if(href_list["species"])
		if(href_list["species"] in species_types)
			species = href_list["species"]

	if(href_list["manufacturer"])
		if(href_list["manufacturer"] in all_robolimbs)
			manufacturer = href_list["manufacturer"]

	if(href_list["eject"])
		eject_materials(href_list["eject"], text2num(href_list["amount"]))

	if(href_list["sync"])
		sync()
	else
		sync_message = ""

	return 1

/obj/machinery/pros_fabricator/attackby(var/obj/item/I, var/mob/user)
	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy. Please wait for completion of previous operation.</span>")
		return 1
	if(default_deconstruction_screwdriver(user, I))
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return

	if(istype(I,/obj/item/weapon/disk/limb))
		var/obj/item/weapon/disk/limb/D = I
		if(!D.company || !(D.company in all_robolimbs))
			to_chat(user, "<span class='warning'>This disk seems to be corrupted!</span>")
		else
			to_chat(user, "<span class='notice'>Installing blueprint files for [D.company]...</span>")
			if(do_after(user,50,src))
				var/datum/robolimb/R = all_robolimbs[D.company]
				R.unavailable_to_build = 0
				to_chat(user, "<span class='notice'>Installed [D.company] blueprints!</span>")
				qdel(I)
		return

	if(istype(I,/obj/item/weapon/disk/species))
		var/obj/item/weapon/disk/species/D = I
		if(!D.species || !(D.species in GLOB.all_species))
			to_chat(user, "<span class='warning'>This disk seems to be corrupted!</span>")
		else
			to_chat(user, "<span class='notice'>Uploading modification files for [D.species]...</span>")
			if(do_after(user,50,src))
				species_types |= D.species
				to_chat(user, "<span class='notice'>Uploaded [D.species] files!</span>")
				qdel(I)
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
				overlays += "fab-load-metal"
				spawn(10)
					overlays -= "fab-load-metal"
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

/obj/machinery/pros_fabricator/emag_act(var/remaining_charges, var/mob/user)
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

/obj/machinery/pros_fabricator/proc/update_busy()
	if(queue.len)
		if(can_build(queue[1]))
			busy = 1
		else
			busy = 0
	else
		busy = 0

/obj/machinery/pros_fabricator/proc/add_to_queue(var/index)
	var/datum/design/D = files.known_designs[index]
	queue += D
	update_busy()

/obj/machinery/pros_fabricator/proc/remove_from_queue(var/index)
	if(index == 1)
		progress = 0
	queue.Cut(index, index + 1)
	update_busy()

/obj/machinery/pros_fabricator/proc/can_build(var/datum/design/D)
	for(var/M in D.materials)
		if(materials[M] < (D.materials[M] * mat_efficiency))
			return 0
	return 1

/obj/machinery/pros_fabricator/proc/check_build()
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
		var/obj/new_item = D.Fabricate(get_step(get_turf(src), src.dir), src) // Sometimes returns a mob. Beware!
		visible_message("\The [src] pings, indicating that \the [D] is complete.", "You hear a ping.")
		if(mat_efficiency != 1)
			if(istype(new_item, /obj/) && new_item.matter && new_item.matter.len > 0)
				for(var/i in new_item.matter)
					new_item.matter[i] = new_item.matter[i] * mat_efficiency
	remove_from_queue(1)

/obj/machinery/pros_fabricator/proc/get_queue_names()
	. = list()
	for(var/i = 2 to queue.len)
		var/datum/design/D = queue[i]
		. += D.name

/obj/machinery/pros_fabricator/proc/get_build_options()
	. = list()
	for(var/i = 1 to files.known_designs.len)
		var/datum/design/D = files.known_designs[i]
		if(D.build_path && (D.build_type & PROSFAB))
			. += list(list("name" = D.name, "id" = i, "category" = D.category, "resourses" = get_design_resourses(D), "time" = get_design_time(D)))

/obj/machinery/pros_fabricator/proc/get_design_resourses(var/datum/design/D)
	var/list/F = list()
	for(var/T in D.materials)
		F += "[capitalize(T)]: [D.materials[T] * mat_efficiency]"
	return english_list(F, and_text = ", ")

/obj/machinery/pros_fabricator/proc/get_design_time(var/datum/design/D)
	return time2text(round(10 * D.time / speed), "mm:ss")

/obj/machinery/pros_fabricator/proc/update_categories()
	categories = list()
	for(var/datum/design/D in files.known_designs)
		if(!D.build_path || !(D.build_type & PROSFAB))
			continue
		categories |= D.category
	if(!category || !(category in categories))
		category = categories[1]

/obj/machinery/pros_fabricator/proc/get_materials()
	. = list()
	for(var/T in materials)
		var/hidden_mat = FALSE
		for(var/HM in hidden_materials) // Direct list contents comparison was failing.
			if(T == HM && materials[T] == 0)
				hidden_mat = TRUE
				continue
		if(!hidden_mat)
			. += list(list("mat" = capitalize(T), "amt" = materials[T]))

/obj/machinery/pros_fabricator/proc/eject_materials(var/material, var/amount) // 0 amount = 0 means ejecting a full stack; -1 means eject everything
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

/obj/machinery/pros_fabricator/proc/sync()
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
