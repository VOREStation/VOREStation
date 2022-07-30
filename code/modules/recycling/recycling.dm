/obj/machinery/recycling
	idle_power_usage = 5
	active_power_usage = 500
	density = TRUE
	anchored = TRUE

	var/working = FALSE
	var/negative_dir = null	//VOREStation Addition

/obj/machinery/recycling/process()
	return PROCESS_KILL // these are all stateful

/obj/machinery/recycling/update_icon()
	. = ..()
	cut_overlays()
	if(panel_open)
		add_overlay("[initial(icon_state)]-panel")

/**
 * Generic procs common to all
 */
/obj/machinery/recycling/attackby(obj/item/O, mob/user)
	if(!isliving(user) || !Adjacent(user))
		return

	if(working)
		to_chat("<span class='warning'>\The [src] is busy! Wait until it's idle.</span>")
		return

	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return

	var/mob/living/M = user
	if(can_accept_item(O))
		M.drop_from_inventory(O)
		take_item(O)
		M.visible_message("<b>[M]</b> inserts [O] into [src].", "You insert [O] into [src].")
	else
		to_chat(user, "<span class='warning'>\The [src] can't accept [O] for recycling.</span>")

// Conveyors etc
/obj/machinery/recycling/Bumped(atom/A)
	if(isitem(A) && can_accept_item(A))
		take_item(A)

/obj/machinery/recycling/proc/can_accept_item(obj/item/O)
	if(stat & (NOPOWER|BROKEN))
		return FALSE
	if(panel_open)
		return FALSE
	return !working

/obj/machinery/recycling/proc/take_item(obj/item/O)
	O.forceMove(src)

/**
 * This machine takes items and turns them into heaps of junk.
 */
/obj/machinery/recycling/crusher
	name = "recycling crusher"
	desc = "This machine is designed to break things into their constituient parts via the application of directed kinetic force. A.K.A. it crushes things into bits."
	description_info = "This machine is the first step in turning things back into their materials. There's a bit of loss, depending on how upgraded it is. The output of this machine goes into the sorter."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "crusher"
	circuit = /obj/item/circuitboard/recycler_crusher

	working = FALSE
	var/effic_factor = 0.5

/obj/machinery/recycling/crusher/RefreshParts()
	. = ..()
	var/total_rating = 0
	for(var/obj/item/stock_parts/matter_bin/M in component_parts)
		total_rating += M.rating
	for(var/obj/item/stock_parts/manipulator/M in component_parts)
		total_rating += M.rating

	total_rating *= 0.1

	effic_factor = CLAMP01(initial(effic_factor)+total_rating)

/obj/machinery/recycling/crusher/can_accept_item(obj/item/O)
	if(LAZYLEN(O.matter))
		return ..()
	//VOREStation Addition Start - Let's the machine decide to put things it can't accept somewhere else.
	else if(negative_dir && isitem(O) && !ishuman(O.loc))
		O.forceMove(get_step(src, negative_dir))
	else
		return FALSE
	//VOREStation Addition End

/obj/machinery/recycling/crusher/take_item(obj/item/O)
	. = ..()
	working = TRUE
	icon_state = "crusher-process"
	update_use_power(USE_POWER_ACTIVE)
	sleep(5 SECONDS)
	var/list/modified_mats = list()
	for(var/mat in O.matter)
		modified_mats[mat] = O.matter[mat]*effic_factor
	new /obj/item/debris_pack(get_step(src, dir), modified_mats)
	update_use_power(USE_POWER_IDLE)
	icon_state = "crusher"
	qdel(O)
	working = FALSE

/**
 * This machine takes heaps of junk and holds onto them until it has enough of one material to make a sheet.
 */
/obj/machinery/recycling/sorter
	name = "debris sorter"
	desc = "A machine for retaining debris and sorting it until enough of a similar material have accumulated to warrant conversion into sheets or ingots."
	description_info = "The output of the recycling crusher should go into this machine, and it will output material dust, which can go into the sheet stamper to make sheets."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "sorter"
	circuit = /obj/item/circuitboard/recycler_sorter

	var/list/materials = list()
	working = FALSE

/obj/machinery/recycling/sorter/can_accept_item(obj/item/O)
	if(istype(O, /obj/item/debris_pack))
		return ..()
	return FALSE

/obj/machinery/recycling/sorter/take_item(obj/item/O)
	. = ..()
	working = TRUE
	icon_state = "sorter-process"
	update_use_power(USE_POWER_ACTIVE)
	sleep(5 SECONDS)
	sort_item(O)
	dispense_if_possible()
	update_use_power(USE_POWER_IDLE)
	icon_state = "sorter"
	working = FALSE

/obj/machinery/recycling/sorter/proc/sort_item(obj/item/O)
	for(var/mat in O.matter)
		if(mat in materials)
			materials[mat] += O.matter[mat]
		else
			materials[mat] = O.matter[mat]
	qdel(O)

/obj/machinery/recycling/sorter/proc/dispense_if_possible()
	for(var/mat in materials)
		while(materials[mat] >= SHEET_MATERIAL_AMOUNT)
			materials[mat] -= SHEET_MATERIAL_AMOUNT
			new /obj/item/material_dust(get_step(src, dir), mat)
			sleep(2 SECONDS)

/**
 * This machine makes sheets after being provided with material dust from a sorter.
 */
/obj/machinery/recycling/stamper
	name = "sheet stamper"
	desc = "A machine to press homogenous material particulate into more solid portable units of production. A.K.A. it compacts dust into sheets."
	description_info = "This machine is the last step in the recycling process. The output of a debris sorter should be fed into this machine and it will produce material sheets."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "stamper"
	circuit = /obj/item/circuitboard/recycler_stamper

/obj/machinery/recycling/stamper/can_accept_item(obj/item/O)
	if(istype(O, /obj/item/material_dust))
		return ..()
	return FALSE

/obj/machinery/recycling/stamper/take_item(obj/item/O)
	. = ..()
	working = TRUE
	icon_state = "stamper-process"
	update_use_power(USE_POWER_ACTIVE)
	sleep(64)
	dust_to_sheet(O)
	icon_state = "stamper"
	update_use_power(USE_POWER_IDLE)
	working = FALSE

/obj/machinery/recycling/stamper/proc/dust_to_sheet(obj/item/material_dust/D)
	if(!istype(D))
		return
	var/datum/material/M = get_material_by_name(D.material_name)
	if(!M)
		D.forceMove(get_step(src, dir))
		playsound(src, 'sound/machines/buzz-sigh.ogg', 50, 0)
		warning("Dust in [src] had material_name [D.material_name], which can't be made into stacks")
		return

	var/stacktype = M.stack_type
	var/turf/T = get_step(src, dir)
	var/obj/item/stack/S = locate(stacktype) in T
	if(S && S.get_amount() < S.max_amount)
		S.add(1)
	else
		new stacktype(T)

/obj/item/debris_pack
	name = "debris"
	desc = "Some ground-up parts of ... something. Might be useful for recycling."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "debris"
	w_class = ITEMSIZE_NORMAL

/obj/item/debris_pack/New(newloc, list/matter)
	..()
	src.matter = matter.Copy()

/obj/item/material_dust
	name = "dust"
	desc = "A homogenous powder of some material or another. Might be useful for recycling."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "matdust"
	w_class = ITEMSIZE_SMALL
	var/material_name

/obj/item/material_dust/New(loc, mat)
	..()
	material_name = mat
	name = "[material_name] [initial(name)]"
	var/datum/material/M = get_material_by_name(material_name)
	color = M?.icon_colour
