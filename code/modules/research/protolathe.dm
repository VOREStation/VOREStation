/obj/machinery/r_n_d/protolathe
	name = "Protolathe"
	icon_state = "protolathe"
	flags = OPENCONTAINER
	circuit = /obj/item/circuitboard/protolathe
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 5000

	var/max_material_storage = 100000

	var/list/datum/design/queue = list()
	var/progress = 0

	var/mat_efficiency = 1
	var/speed = 1

	//VOREStation Edit - Broke this into lines
	materials = list(
		MAT_STEEL = 0,
		MAT_GLASS = 0,
		MAT_PLASTEEL = 0,
		MAT_PLASTIC = 0,
		MAT_GRAPHITE = 0,
		MAT_GOLD = 0,
		MAT_SILVER = 0,
		MAT_OSMIUM = 0,
		MAT_LEAD = 0,
		MAT_PHORON = 0,
		MAT_URANIUM = 0,
		MAT_DIAMOND = 0,
		MAT_DURASTEEL = 0,
		MAT_VERDANTIUM = 0,
		MAT_MORPHIUM = 0,
		MAT_METALHYDROGEN = 0,
		MAT_SUPERMATTER = 0,
		MAT_TITANIUM = 0)

	hidden_materials = list(MAT_PLASTEEL, MAT_DURASTEEL, MAT_GRAPHITE, MAT_VERDANTIUM, MAT_MORPHIUM, MAT_METALHYDROGEN, MAT_SUPERMATTER)

/obj/machinery/r_n_d/protolathe/Initialize(mapload)
	. = ..()

// Go through all materials, and add them to the possible storage, but hide them unless we contain them.
	for(var/Name in name_to_material)
		if(Name in materials)
			continue

		hidden_materials |= Name

		materials[Name] = 0

	default_apply_parts()

/obj/machinery/r_n_d/protolathe/process()
	..()
	if(stat)
		update_icon()
		return
	if(queue.len == 0)
		busy = 0
		update_icon()
		return
	var/datum/design/D = queue[1]
	if(canBuild(D))
		busy = 1
		progress += speed
		if(progress >= D.time)
			build(D)
			progress = 0
			removeFromQueue(1)
			flick("[initial(icon_state)]_finish", src)
		update_icon()
	else
		if(busy)
			visible_message(span_notice("[icon2html(src,viewers(src))] flashes: insufficient materials: [getLackingMaterials(D)]."))
			busy = 0
			update_icon()

/obj/machinery/r_n_d/protolathe/proc/TotalMaterials() //returns the total of all the stored materials. Makes code neater.
	var/t = 0
	for(var/f in materials)
		t += materials[f]
	return t

/obj/machinery/r_n_d/protolathe/RefreshParts()
	var/T = 0
	for(var/obj/item/reagent_containers/glass/G in component_parts)
		T += G.reagents.maximum_volume
	create_reagents(T)
	max_material_storage = 0
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		max_material_storage += M.rating * 75000
	T = 0
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		T += M.rating
	mat_efficiency = max(1 - (T - 2) / 8, 0.2)
	speed = T / 2

/obj/machinery/r_n_d/protolathe/dismantle()
	for(var/f in materials)
		eject_materials(f, -1)
	..()


/obj/machinery/r_n_d/protolathe/update_icon()
	cut_overlays()

	icon_state = initial(icon_state)

	if(panel_open)
		overlays.Add(image(icon, "[icon_state]_panel"))

	if(stat & NOPOWER)
		return

	if(busy)
		icon_state = "[icon_state]_work"

/obj/machinery/r_n_d/protolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, span_notice("\The [src] is busy. Please wait for completion of previous operation."))
		return 1
	if(default_deconstruction_screwdriver(user, O))
		if(linked_console)
			linked_console.linked_lathe = null
			linked_console = null
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(O.is_open_container())
		return 1
	if(istype(O, /obj/item/gripper/no_use/loader))
		return 0		//Sheet loaders weren't finishing attack(), this prevents the message "You can't stuff that gripper into this" without preventing the rest of the attack sequence from finishing
	if(panel_open)
		to_chat(user, span_notice("You can't load \the [src] while it's opened."))
		return 1
	if(!linked_console)
		to_chat(user, span_notice("\The [src] must be linked to an R&D console first!"))
		return 1
	if(!istype(O, /obj/item/stack/material))
		to_chat(user, span_notice("You cannot insert this item into \the [src]!"))
		return 1
	if(stat)
		return 1

	var/obj/item/stack/material/S = O
	if(!(S.material.name in materials))
		to_chat(user, span_warning("The [src] doesn't accept [S.material]!"))
		return

	busy = 1
	var/sname = "[S.name]"
	var/amnt = S.perunit
	var/max_res_amount = max_material_storage
	for(var/mat in materials)
		max_res_amount -= materials[mat]

	if(materials[S.material.name] + amnt <= max_res_amount)
		if(S && S.get_amount() >= 1)
			var/count = 0
			flick("[initial(icon_state)]_loading", src)
			while(materials[S.material.name] + amnt <= max_res_amount && S.get_amount() >= 1)
				materials[S.material.name] += amnt
				S.use(1)
				count++
			to_chat(user, span_filter_notice("You insert [count] [sname] into the fabricator."))
	else
		to_chat(user, span_filter_notice("The fabricator cannot hold more [sname]."))
	busy = 0

	var/stacktype = S.type
	var/t = getMaterialName(stacktype)
	add_overlay("protolathe_[t]")
	spawn(10)
		cut_overlay("protolathe_[t]")

	return

/obj/machinery/r_n_d/protolathe/proc/addToQueue(var/datum/design/D)
	queue += D
	return

/obj/machinery/r_n_d/protolathe/proc/removeFromQueue(var/index)
	if(queue.len >= index)
		queue.Cut(index, index + 1)
		return

/obj/machinery/r_n_d/protolathe/proc/canBuild(var/datum/design/D)
	for(var/M in D.materials)
		if(materials[M] < (D.materials[M] * mat_efficiency))
			return 0
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C] * mat_efficiency))
			return 0
	return 1

/obj/machinery/r_n_d/protolathe/proc/getLackingMaterials(var/datum/design/D)
	var/ret = ""
	for(var/M in D.materials)
		if(materials[M] < D.materials[M])
			if(ret != "")
				ret += ", "
			ret += "[D.materials[M] - materials[M]] [M]"
	for(var/C in D.chemicals)
		if(!reagents.has_reagent(C, D.chemicals[C]))
			if(ret != "")
				ret += ", "
			ret += C
	return ret

/obj/machinery/r_n_d/protolathe/proc/build(var/datum/design/D)
	var/power = active_power_usage
	for(var/M in D.materials)
		power += round(D.materials[M] / 5)
	power = max(active_power_usage, power)
	use_power(power)
	for(var/M in D.materials)
		materials[M] = max(0, materials[M] - D.materials[M] * mat_efficiency)
	for(var/C in D.chemicals)
		reagents.remove_reagent(C, D.chemicals[C] * mat_efficiency)

	if(D.build_path)
		var/obj/new_item = D.Fabricate(src, src)
		new_item.loc = loc
		if(mat_efficiency != 1) // No matter out of nowhere
			if(new_item.matter && new_item.matter.len > 0)
				for(var/i in new_item.matter)
					new_item.matter[i] = new_item.matter[i] * mat_efficiency

/obj/machinery/r_n_d/protolathe/proc/eject_materials(var/material, var/amount) // 0 amount = 0 means ejecting a full stack; -1 means eject everything
	var/recursive = amount == -1 ? TRUE : FALSE
	var/matstring = lowertext(material)

	// 0 or null, nothing to eject
	if(!materials[matstring])
		return
	// Problem, fix problem and abort
	if(materials[matstring] < 0)
		warning("[src] tried to eject material '[material]', which it has 'materials[matstring]' of!")
		materials[matstring] = 0
		return

	// Find the material datum for our material
	var/datum/material/M = get_material_by_name(matstring)
	if(!M)
		warning("[src] tried to eject material '[matstring]', which didn't match any known material datum!")
		return
	// Find what type of sheets it makes
	var/obj/item/stack/material/S = M.stack_type
	if(!S)
		warning("[src] tried to eject material '[matstring]', which didn't have a stack_type!")
		return

	// If we were passed -1, then it's recursive ejection and we should eject all we can
	if(amount <= 0)
		amount = initial(S.max_amount)
	// Smaller of what we have left, or the desired amount (note the amount is in sheets, but the array stores perunit values)
	var/ejected = min(round(materials[matstring] / initial(S.perunit)), amount)

	// Place a sheet
	S = M.place_sheet(get_turf(src), ejected)
	if(!istype(S))
		warning("[src] tried to eject material '[material]', which didn't generate a proper stack when asked!")
		return

	// Reduce our amount stored
	materials[matstring] -= ejected * S.perunit

	// Recurse if we have enough left for more sheets
	if(recursive && materials[matstring] >= S.perunit)
		eject_materials(matstring, -1)
