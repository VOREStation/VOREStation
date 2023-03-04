/obj/machinery/mecha_part_fabricator/pros
	icon = 'icons/obj/robotics.dmi'
	icon_state = "prosfab"
	name = "Prosthetics Fabricator"
	desc = "A machine used for construction of prosthetics."
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 20
	active_power_usage = 5000
	req_access = list(access_robotics)
	circuit = /obj/item/weapon/circuitboard/prosthetics

<<<<<<< HEAD
	// Prosfab specific stuff
=======
	var/speed = 1
	var/mat_efficiency = 1
	var/list/materials = list(MAT_STEEL = 0, "glass" = 0, "plastic" = 0, MAT_GRAPHITE = 0, MAT_PLASTEEL = 0, "gold" = 0, "silver" = 0, MAT_LEAD = 0, "osmium" = 0, "diamond" = 0, MAT_DURASTEEL = 0, "phoron" = 0, "uranium" = 0, MAT_VERDANTIUM = 0, MAT_MORPHIUM = 0)
	var/list/hidden_materials = list(MAT_DURASTEEL, MAT_GRAPHITE, MAT_VERDANTIUM, MAT_MORPHIUM)
	var/res_max_amount = 200000

	var/datum/research/files
	var/list/datum/design/queue = list()
	var/progress = 0
	var/busy = 0
	var/datum/looping_sound/fabricator/soundloop

	var/list/categories = list()
	var/category = null
>>>>>>> ab7f5a8c3d7... Merge pull request #8958 from Cerebulon/mining_sounds
	var/manufacturer = null
	var/species_types = list("Human")
	var/species = "Human"

	loading_icon_state = "prosfab_loading"

	materials = list(
		MAT_STEEL = 0,
		MAT_GLASS = 0,
		MAT_PLASTIC = 0,
		MAT_GRAPHITE = 0,
		MAT_PLASTEEL = 0,
		MAT_GLASS = 0,
		MAT_SILVER = 0,
		MAT_LEAD = 0,
		MAT_OSMIUM = 0,
		MAT_DIAMOND = 0,
		MAT_DURASTEEL = 0,
		MAT_PHORON = 0,
		MAT_URANIUM = 0,
		MAT_VERDANTIUM = 0,
		MAT_MORPHIUM = 0)
	res_max_amount = 200000

	valid_buildtype = PROSFAB
	/// A list of categories that valid PROSFAB design datums will broadly categorise themselves under.
	part_sets = list(
					"Cyborg",
					"Ripley",
					"Odysseus",
					"Gygax",
					"Durand",
					"Janus",
					"Vehicle",
					"Rigsuit",
					"Phazon",
					"Gopher", // VOREStation Add
					"Polecat", // VOREStation Add
					"Weasel", // VOREStation Add
					"Exosuit Equipment",
					"Exosuit Internals",
					"Exosuit Ammunition",
					"Cyborg Modules",
					"Prosthetics",
					"Prosthetics, Internal",
					"Cyborg Parts",
					"Cyborg Internals",
					"Cybernetics",
					"pAI Parts", //VOREStation Add
					"Implants",
					"Control Interfaces",
					"Other",
					"Misc",
					)

/obj/machinery/mecha_part_fabricator/pros/Initialize()
	. = ..()
	manufacturer = basic_robolimb.company
<<<<<<< HEAD
=======
	update_categories()
	soundloop = new(list(src), FALSE)

/obj/machinery/pros_fabricator/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/machinery/pros_fabricator/process()
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

/obj/machinery/pros_fabricator/update_icon()
	cut_overlays()
	icon_state = initial(icon_state)

	if(panel_open)
		add_overlay(image(icon, "[icon_state]_panel"))
	if(stat & NOPOWER)
		return
	if(busy)
		icon_state = "[icon_state]_work"
>>>>>>> ab7f5a8c3d7... Merge pull request #8958 from Cerebulon/mining_sounds

/obj/machinery/mecha_part_fabricator/pros/dispense_built_part(datum/design/D)
	var/obj/item/I = ..()
	if(isobj(I) && I.matter && I.matter.len > 0)
		for(var/i in I.matter)
			I.matter[i] = I.matter[i] * component_coeff

/obj/machinery/mecha_part_fabricator/pros/tgui_data(mob/user)
	var/list/data = ..()

	data["species_types"] = species_types
	data["species"] = species

	if(all_robolimbs)
		var/list/T = list()
		for(var/A in all_robolimbs)
			var/datum/robolimb/R = all_robolimbs[A]
			if(R.unavailable_to_build)
				continue
			if(species in R.species_cannot_use)
				continue
			T += list(list("id" = A, "company" = R.company))
		data["manufacturers"] = T

	data["manufacturer"] = manufacturer

	return data

/obj/machinery/mecha_part_fabricator/pros/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	. = TRUE

	add_fingerprint(usr)
	usr.set_machine(src)

	switch(action)
		if("species")
			var/new_species = tgui_input_list(usr, "Select a new species", "Prosfab Species Selection", species_types)
			if(new_species && tgui_status(usr, state) == STATUS_INTERACTIVE)
				species = new_species
			return
		if("manufacturer")
			var/list/new_manufacturers = list()
			for(var/A in all_robolimbs)
				var/datum/robolimb/R = all_robolimbs[A]
				if(R.unavailable_to_build)
					continue
				if(species in R.species_cannot_use)
					continue
				new_manufacturers += A

			var/new_manufacturer = tgui_input_list(usr, "Select a new manufacturer", "Prosfab Species Selection", new_manufacturers)
			if(new_manufacturer && tgui_status(usr, state) == STATUS_INTERACTIVE)
				manufacturer = new_manufacturer
			return
	return FALSE

/obj/machinery/mecha_part_fabricator/pros/attackby(var/obj/item/I, var/mob/user)
	if(..())
		return 1

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
<<<<<<< HEAD
=======

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
				flick("[initial(icon_state)]_loading", src)
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
			soundloop.start()
		else
			busy = 0
			soundloop.stop()
	else
		busy = 0
		soundloop.stop()

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
		flick("[initial(icon_state)]_finish", src)
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
	var/datum/material/M = get_material_by_name(matstring)

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
>>>>>>> ab7f5a8c3d7... Merge pull request #8958 from Cerebulon/mining_sounds
