/*
Destructive Analyzer

It is used to destroy hand-held objects and advance technological research. Used to perform /datum/experiment/physical/destructive_analysis experiments.
*/

/obj/machinery/rnd/destructive_analyzer
	name = "destructive analyzer"
	icon_state = "d_analyzer"
	var/decon_mod = 0
	circuit = /obj/item/circuitboard/destructive_analyzer
	use_power = USE_POWER_IDLE
	idle_power_usage = 30
	active_power_usage = 2500
	var/rped_recycler_ready = TRUE
	var/datum/component/remote_materials/materials

/obj/machinery/rnd/destructive_analyzer/Initialize(mapload)
	materials = AddComponent(
		/datum/component/remote_materials, \
		mapload, \
		mat_container_flags = MATCONTAINER_NO_INSERT \
	)
	. = ..()
	default_apply_parts()

/obj/machinery/rnd/destructive_analyzer/Destroy()
	materials = null
	. = ..()

/obj/machinery/rnd/destructive_analyzer/RefreshParts()
	var/T = 0
	for(var/obj/item/stock_parts/S in component_parts)
		T += S.rating
	T *= 0.1
	decon_mod = clamp(T, 0, 1)

/obj/machinery/rnd/destructive_analyzer/update_icon()
	if(panel_open)
		icon_state = "d_analyzer_t"
	else if(loaded_item)
		icon_state = "d_analyzer_l"
	else
		icon_state = "d_analyzer"

/obj/machinery/rnd/destructive_analyzer/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, span_notice("\The [src] is busy right now."))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(!panel_open)
		if(loaded_item)
			to_chat(user, span_notice("There is something already loaded into \the [src]."))
		else
			if(isrobot(user)) //Don't put your module items in there!
				return
			busy = TRUE
			loaded_item = O
			user.drop_item()
			O.forceMove(src)
			to_chat(user, span_notice("You add \the [O] to \the [src]."))
			flick("d_analyzer_la", src)
			spawn(10)
				update_icon()
				reset_busy()
		return TRUE
	// Handle signal to remote_materials so we can link the DA to the silo
	. = ..()

///////////////////////////////////////////////////////////////////////////////////////////////////////
// RPED recycling
///////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/rnd/destructive_analyzer/MouseDrop_T(atom/dropping, mob/living/user)
	if(istype(dropping, /obj/item/storage/part_replacer))
		var/obj/item/storage/part_replacer/replacer = dropping
		replacer.hide_from(user)
		if(!rped_recycler_ready)
			to_chat(user, span_notice("\The [src]'s stock parts recycler isn't ready yet."))
			return 0

		to_chat(user, span_notice("TODO TODO TODO"))
		return 1

		/* TODO - Recycle mats from things
		var/obj/machinery/rnd/protolathe/lathe_to_fill = linked_console.linked_lathe
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
		addtimer(CALLBACK(src, PROC_REF(rped_ready)), 5 SECONDS, TIMER_DELETE_ME)
		to_chat(user, span_notice("You deconstruct all the parts of rating [lowest_rating] in [replacer] with [src]."))
		return 1
		*/
	. = ..()

/obj/machinery/rnd/destructive_analyzer/proc/rped_ready()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	rped_recycler_ready = TRUE
	playsound(get_turf(src), 'sound/machines/chime.ogg', 50, 1)


///////////////////////////////////////////////////////////////////////////////////////////////////////
// Handling deconstruction
///////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/rnd/destructive_analyzer/verb/deconstruct_act()
	set name = "Deconstruct Contents"
	set category = "Object"
	set src in view(1)
	deconstruct_contents(usr)

/obj/machinery/rnd/destructive_analyzer/AltClick(mob/user)
	deconstruct_contents(user)

/obj/machinery/rnd/destructive_analyzer/proc/deconstruct_contents(mob/user)
	if(busy)
		to_chat(user, span_notice("The destructive analyzer is busy at the moment."))
		return

	busy = TRUE
	flick("d_analyzer_process", src)
	addtimer(CALLBACK(src, PROC_REF(handle_end_deconstruct), user), 2.4 SECONDS, TIMER_DELETE_ME)

/obj/machinery/rnd/destructive_analyzer/proc/handle_end_deconstruct(mob/user)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	reset_busy()
	if(!loaded_item)
		to_chat(user, span_notice("The destructive analyzer appears to be empty."))
		return

	if(istype(loaded_item,/obj/item/stack))//Only deconsturcts one sheet at a time instead of the entire stack
		var/obj/item/stack/ST = loaded_item
		if(ST.get_amount() < 1)
			playsound(src, 'sound/machines/destructive_analyzer.ogg', 50, 1)
			qdel(ST)
			icon_state = "d_analyzer"
			return

	/* TODO - Recycle mats from things
	if(linked_lathe && loaded_item.matter) // Also sends salvaged materials to a linked protolathe, if any.
		for(var/t in loaded_item.matter)
			if(t in linked_lathe.materials)
				linked_lathe.materials[t] += min(linked_lathe.max_material_storage - linked_lathe.TotalMaterials(), loaded_item.matter[t] * decon_mod)
	*/

	loaded_item = null
	var/list/all_destructing_things = list()
	recursive_content_check(src, all_destructing_things, recursion_limit = 5, client_check = FALSE, sight_check = FALSE, include_mobs = TRUE, include_objects = TRUE, ignore_show_messages = TRUE)
	all_destructing_things -= circuit
	all_destructing_things -= component_parts

	// Process contents and notify experimenters
	SEND_SIGNAL(src, COMSIG_DESTRUCTIVE_ANALYSIS, all_destructing_things)
	for(var/atom/A in all_destructing_things)
		// DEATH
		if(ismob(A))
			var/mob/M = A
			playsound(src, 'sound/machines/destructive_analyzer.ogg', 50, 1)
			M.death()
			continue
		// Only deconsturcts one sheet at a time instead of the entire stack
		if(istype(A,/obj/item/stack/material))
			var/obj/item/stack/material/S = A
			if(S.get_amount() > 1)
				playsound(src, 'sound/machines/destructive_analyzer.ogg', 50, 1)
				S.use(1)
				loaded_item = S
			else
				playsound(src, 'sound/machines/destructive_analyzer.ogg', 50, 1)
				qdel(S)
				icon_state = "d_analyzer"
			continue
		// Everything else
		playsound(src, 'sound/machines/destructive_analyzer.ogg', 50, 1)
		qdel(A)
		icon_state = "d_analyzer"
	use_power(active_power_usage)
