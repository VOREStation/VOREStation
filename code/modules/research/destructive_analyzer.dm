/*
Destructive Analyzer

It is used to destroy hand-held objects and advance technological research. Controls are in the linked R&D console.

Note: Must be placed within 3 tiles of the R&D Console
*/

/obj/machinery/r_n_d/destructive_analyzer
	name = "destructive analyzer"
	icon_state = "d_analyzer"
	var/obj/item/loaded_item = null
	var/decon_mod = 0
	circuit = /obj/item/circuitboard/destructive_analyzer
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 2500
	var/rped_recycler_ready = TRUE

/obj/machinery/r_n_d/destructive_analyzer/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/r_n_d/destructive_analyzer/RefreshParts()
	var/T = 0
	for(var/obj/item/stock_parts/S in component_parts)
		T += S.rating
	T *= 0.1
	decon_mod = clamp(T, 0, 1)

/obj/machinery/r_n_d/destructive_analyzer/update_icon()
	if(panel_open)
		icon_state = "d_analyzer_t"
	else if(loaded_item)
		icon_state = "d_analyzer_l"
	else
		icon_state = "d_analyzer"

/obj/machinery/r_n_d/destructive_analyzer/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, span_notice("\The [src] is busy right now."))
		return
	if(loaded_item)
		to_chat(user, span_notice("There is something already loaded into \the [src]."))
		return 1
	if(default_deconstruction_screwdriver(user, O))
		if(linked_console)
			linked_console.linked_destroy = null
			linked_console = null
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(panel_open)
		to_chat(user, span_notice("You can't load \the [src] while it's opened."))
		return 1
	if(!linked_console)
		to_chat(user, span_notice("\The [src] must be linked to an R&D console first."))
		return
	if(!loaded_item)
		if(isrobot(user)) //Don't put your module items in there!
			return
		if(!O.origin_tech)
			to_chat(user, span_notice("This doesn't seem to have a tech origin."))
			return
		if(O.origin_tech.len == 0)
			to_chat(user, span_notice("You cannot deconstruct this item."))
			return
		busy = 1
		loaded_item = O
		user.drop_item()
		O.loc = src
		to_chat(user, span_notice("You add \the [O] to \the [src]."))
		flick("d_analyzer_la", src)
		spawn(10)
			update_icon()
			busy = 0
		return 1
	return

/obj/machinery/r_n_d/destructive_analyzer/MouseDrop_T(atom/dropping, mob/living/user)
	if(istype(dropping, /obj/item/storage/part_replacer))
		var/obj/item/storage/part_replacer/replacer = dropping
		replacer.hide_from(user)
		if(!linked_console)
			to_chat(user, span_notice("\The [src] must be linked to an R&D console first."))
			return 0
		if(!linked_console.linked_lathe)
			to_chat(user, span_notice("Link a protolathe to [src]'s R&D console first."))
			return 0
		if(!rped_recycler_ready)
			to_chat(user, span_notice("\The [src]'s stock parts recycler isn't ready yet."))
			return 0
		var/obj/machinery/r_n_d/protolathe/lathe_to_fill = linked_console.linked_lathe
		var/lowest_rating = INFINITY // We want the lowest-part tier rating in the RPED so we only recycle the lowest-tier parts.
		for(var/obj/item/B in replacer.contents)
			if(B.rped_rating() < lowest_rating)
				lowest_rating = B.rped_rating()
		if(lowest_rating == INFINITY)
			to_chat(user, span_notice("Mass part deconstruction attempt canceled - no valid parts for recycling detected."))
			return 0
		for(var/obj/item/B in replacer.contents)
			if(B.rped_rating() > lowest_rating)
				continue
			if(lathe_to_fill && B.matter) // Sending salvaged materials to the lathe...
				for(var/t in B.matter)
					if(t in lathe_to_fill.materials)
						lathe_to_fill.materials[t] += B.matter[t] * src.decon_mod
			qdel(B)
		playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
		rped_recycler_ready = FALSE
		addtimer(CALLBACK(src, PROC_REF(rped_ready)), 5 SECONDS)
		to_chat(user, span_notice("You deconstruct all the parts of rating [lowest_rating] in [replacer] with [src]."))
		return 1
	else
		..()

/obj/machinery/r_n_d/destructive_analyzer/proc/rped_ready()
	rped_recycler_ready = TRUE
	playsound(get_turf(src), 'sound/machines/chime.ogg', 50, 1)
