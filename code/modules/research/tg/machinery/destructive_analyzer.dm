///The 'ID' for deconstructing items for Research points instead of nodes.
#define DESTRUCTIVE_ANALYZER_DESTROY_POINTS "research_points"

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
	var/datum/component/remote_materials/rmat

/obj/machinery/rnd/destructive_analyzer/Initialize(mapload)
	rmat = AddComponent(
		/datum/component/remote_materials, \
		mapload, \
		mat_container_flags = MATCONTAINER_NO_INSERT \
	)

	//Destructive analysis
	var/static/list/destructive_signals = list(
		COMSIG_MACHINERY_DESTRUCTIVE_SCAN = TYPE_PROC_REF(/datum/component/experiment_handler, try_run_destructive_experiment),
	)

	AddComponent(/datum/component/experiment_handler, \
		config_mode = EXPERIMENT_CONFIG_ALTCLICK, \
		allowed_experiments = list(/datum/experiment/scanning),\
		config_flags = EXPERIMENT_CONFIG_ALWAYS_ACTIVE|EXPERIMENT_CONFIG_SILENT_FAIL,\
		experiment_signals = destructive_signals, \
	)
	. = ..()
	default_apply_parts()

/obj/machinery/rnd/destructive_analyzer/Destroy()
	rmat = null
	. = ..()

/obj/machinery/rnd/destructive_analyzer/RefreshParts()
	var/T = 0
	for(var/obj/item/stock_parts/S in component_parts)
		T += S.rating
	T *= 0.1
	decon_mod = clamp(T, 0, 1)

/obj/machinery/rnd/destructive_analyzer/update_icon()
	var/current_item = loaded_item?.resolve()
	if(panel_open)
		icon_state = "d_analyzer_t"
	else if(current_item)
		icon_state = "d_analyzer_l"
	else
		icon_state = "d_analyzer"

/obj/machinery/rnd/destructive_analyzer/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(busy)
		to_chat(user, span_notice("\The [src] is busy right now."))
		return
	if(default_deconstruction_screwdriver(user, O))
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(!panel_open)
		var/current_item = loaded_item?.resolve()
		if(current_item)
			to_chat(user, span_notice("There is something already loaded into \the [src]."))
		else
			if(isrobot(user)) //Don't put your module items in there!
				return
			if(is_type_in_list(O, GLOB.item_deconstruction_blacklist))
				to_chat(user, span_notice("The machine rejects \the [O]!"))
				return
			if((O.item_flags & DROPDEL) || (O.item_flags & NOSTRIP))
				to_chat(user, span_notice("The machine rejects \the [O]!"))
				return
			if(O.tethered_host_item)
				to_chat(user, span_notice("The machine rejects \the [O]!"))
				return
			if(LAZYLEN(O.contents))
				to_chat(user, span_notice("The machine rejects \the [O]! You need to clear it of all items first!"))
				return
			busy = TRUE
			loaded_item = WEAKREF(O)
			user.drop_item()
			O.forceMove(src)
			SStgui.update_uis(src)
			to_chat(user, span_notice("You add \the [O] to \the [src]."))
			flick("d_analyzer_la", src)
			addtimer(CALLBACK(src, PROC_REF(analyze_finish)), 1 SECONDS, TIMER_DELETE_ME)
		return TRUE
	// Handle signal to remote_materials so we can link the DA to the silo
	. = ..()

/obj/machinery/rnd/destructive_analyzer/proc/analyze_finish()
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	update_icon()
	reset_busy()

///////////////////////////////////////////////////////////////////////////////////////////////////////
// RPED recycling
///////////////////////////////////////////////////////////////////////////////////////////////////////
/obj/machinery/rnd/destructive_analyzer/MouseDrop_T(atom/dropping, mob/living/user)
	if(istype(dropping, /obj/item/storage/part_replacer))
		var/obj/item/storage/part_replacer/replacer = dropping
		replacer.hide_from(user)
		if(!rped_recycler_ready)
			to_chat(user, span_notice("\The [src]'s stock parts recycler isn't ready yet."))
			return FALSE

		// We want the lowest-part tier rating in the RPED so we only recycle the lowest-tier parts.
		var/lowest_rating = INFINITY
		for(var/obj/item/B in replacer.contents)
			if(B.rped_rating() < lowest_rating)
				lowest_rating = B.rped_rating()
		if(lowest_rating == INFINITY)
			atom_say("Mass part deconstruction attempt canceled - no valid parts for recycling detected.")
			return FALSE
		// Sending salvaged materials to the silo
		var/datum/component/material_container/materials = get_silo_material_container_datum(TRUE)
		if(!materials)
			return FALSE
		for(var/obj/item/B in replacer.contents)
			if(B.rped_rating() > lowest_rating)
				continue
			materials.insert_item(B, decon_mod, src)
		// Feedback
		playsound(get_turf(src), 'sound/machines/click.ogg', 50, 1)
		rped_recycler_ready = FALSE
		addtimer(CALLBACK(src, PROC_REF(rped_ready)), 5 SECONDS, TIMER_DELETE_ME)
		to_chat(user, span_notice("You deconstruct all the parts of rating [lowest_rating] in [replacer] with [src]."))
		return TRUE
	. = ..()

/obj/machinery/rnd/destructive_analyzer/proc/rped_ready()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)

	rped_recycler_ready = TRUE
	playsound(get_turf(src), 'sound/machines/chime.ogg', 50, 1)

/obj/machinery/rnd/destructive_analyzer/proc/get_silo_material_container_datum(verbose)
	var/datum/component/material_container/materials = rmat.mat_container
	if(!materials)
		if(verbose)
			atom_say("No access to material storage, please contact the quartermaster.")
		return null
	if(rmat.on_hold())
		if(verbose)
			atom_say("Mineral access is on hold, please contact the quartermaster.")
		return null
	return materials

///////////////////////////////////////////////////////////////////////////////////////////////////////
// Handling deconstruction
///////////////////////////////////////////////////////////////////////////////////////////////////////

/obj/machinery/rnd/destructive_analyzer/attack_hand(mob/user as mob)
	tgui_interact(user)

/obj/machinery/rnd/destructive_analyzer/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DestructiveAnalyzer")
		ui.open()

/obj/machinery/rnd/destructive_analyzer/tgui_data(mob/user)
	var/list/data = list()
	data["server_connected"] = !!stored_research
	data["node_data"] = null
	var/obj/item/current_item = loaded_item?.resolve()
	if(current_item)
		data["item_icon"] = icon2base64(getFlatIcon(image(icon = current_item.icon, icon_state = current_item.icon_state), no_anim = TRUE))
		data["indestructible"] = is_type_in_list(current_item, GLOB.item_deconstruction_blacklist)
		data["loaded_item"] = current_item
		data["already_deconstructed"] = !!stored_research.deconstructed_items[current_item.type]
		var/list/points = techweb_item_point_check(current_item)
		data["recoverable_points"] = techweb_point_display_generic(points)

		var/list/boostable_nodes = techweb_item_unlock_check(current_item)
		for(var/id in boostable_nodes)
			var/datum/techweb_node/unlockable_node = SSresearch.techweb_node_by_id(id)
			var/list/node_data = list()
			node_data["node_name"] = unlockable_node.display_name
			node_data["node_id"] = unlockable_node.id
			node_data["node_hidden"] = !!stored_research.hidden_nodes[unlockable_node.id]
			data["node_data"] += list(node_data)
	else
		data["loaded_item"] = null
	return data

/obj/machinery/rnd/destructive_analyzer/tgui_static_data(mob/user)
	var/list/data = list()
	data["research_point_id"] = DESTRUCTIVE_ANALYZER_DESTROY_POINTS
	return data

/obj/machinery/rnd/destructive_analyzer/tgui_act(action, params, datum/tgui/ui)
	if(..())
		return TRUE

	var/mob/user = usr
	var/current_item = loaded_item?.resolve()
	switch(action)
		if("eject_item")
			if(busy)
				balloon_alert(user, "already busy!")
				return TRUE
			if(current_item)
				unload_item()
				return TRUE
		if("deconstruct")
			if(!user_try_decon_id(params["deconstruct_id"]))
				balloon_alert(user, "analysis failed!")
			return TRUE

///Drops the loaded item where it can and nulls it.
/obj/machinery/rnd/destructive_analyzer/proc/unload_item()
	var/obj/item/current_item = loaded_item?.resolve()
	if(!current_item)
		loaded_item = null
		return FALSE
	//playsound(loc, 'sound/machines/terminal/terminal_insert_disc.ogg', 30, FALSE)
	current_item.forceMove(drop_location())
	loaded_item = null
	update_icon()
	return TRUE

/**
 * Destroys an item by going through all its contents (including itself) and calling destroy_item_individual
 * Args:
 * gain_research_points - Whether deconstructing each individual item should check for research points to boost.
 */
/obj/machinery/rnd/destructive_analyzer/proc/destroy_item(gain_research_points = FALSE)
	var/obj/item/current_item = loaded_item?.resolve()
	if(!current_item || QDELETED(src))
		return FALSE
	//flick("[base_icon_state]_process", src)
	busy = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_busy)), 2.4 SECONDS)
	use_power(active_power_usage)
	// Destroy items inside
	var/list/destructing = list()
	destructing += current_item
	for(var/atom/movable/AM in current_item.contents)
		AM.forceMove(get_turf(src))
		destructing += AM
	for(var/atom/thing_destroying in destructing) // For all contents and itself
		destroy_item_individual(thing_destroying, gain_research_points)
	loaded_item = null
	// feedback
	playsound(src, 'sound/machines/destructive_analyzer.ogg', 50, 1)
	update_icon()
	return TRUE

/**
 * Destroys the individual provided item
 * Args:
 * thing - The thing being destroyed. Generally an object, but it can be a mob too, such as intellicards and pAIs.
 * gain_research_points - Whether deconstructing this should give research points to the stored techweb, if applicable.
 */
/obj/machinery/rnd/destructive_analyzer/proc/destroy_item_individual(obj/item/thing, gain_research_points = FALSE)
	if(isliving(thing))
		var/mob/living/mob_thing = thing
		var/turf/turf_to_dump_to = get_turf(src)
		log_and_message_admins("made an attempt to kill [mob_thing] in a destructive analyzer was made at [ADMIN_VERBOSEJMP(turf_to_dump_to)]")
		visible_message(span_warning("A loud buzz sounds out from \the [src] as it rejects and spits out \the [mob_thing]!"))
		mob_thing.forceMove(turf_to_dump_to)
		return
	//Safety.
	if(is_type_in_list(thing, GLOB.item_deconstruction_blacklist))
		var/turf/turf_to_dump_to = get_turf(src)
		log_and_message_admins("made an attempt to destroy [thing] in a destructive analyzer was made at [ADMIN_VERBOSEJMP(turf_to_dump_to)]")
		visible_message(span_warning("A loud buzz sounds out from \the [src] as it rejects and spits out \the [thing]!"))
		thing.forceMove(turf_to_dump_to)
		return

	//Perform experiment
	techweb_item_generate_points(thing, stored_research)
	SEND_SIGNAL(src, COMSIG_MACHINERY_DESTRUCTIVE_SCAN, thing)

	//Finally, let's add it to the material silo, if applicable.
	var/datum/component/material_container/materials = get_silo_material_container_datum(FALSE)
	materials.insert_item(thing, decon_mod, src, FALSE)
	qdel(thing)

/**
 * Attempts to destroy the loaded item using a provided research id.
 * Args:
 * id - The techweb ID node that we're meant to unlock if applicable.
 */
/obj/machinery/rnd/destructive_analyzer/proc/user_try_decon_id(id)
	var/obj/item/current_item = loaded_item?.resolve()
	if(!istype(current_item))
		return FALSE
	if(LAZYLEN(current_item.contents))
		visible_message(span_notice("A warning blares from \the [src]: The [current_item] still has items inside it!"))
		return FALSE
	if(isnull(id))
		return FALSE

	if(id == DESTRUCTIVE_ANALYZER_DESTROY_POINTS)
		if(!destroy_item(gain_research_points = TRUE))
			return FALSE
		return TRUE

	var/datum/techweb_node/node_to_discover = SSresearch.techweb_node_by_id(id)
	if(!istype(node_to_discover))
		return FALSE
	if(!destroy_item())
		return FALSE
	stored_research.unhide_node(node_to_discover)
	return TRUE

#undef DESTRUCTIVE_ANALYZER_DESTROY_POINTS
