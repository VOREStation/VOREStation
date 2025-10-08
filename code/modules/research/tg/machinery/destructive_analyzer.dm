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
	if(default_deconstruction_screwdriver(user, O))
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
	data["node_data"] = list()
	if(loaded_item)
		data["item_icon"] = icon2base64(getFlatIcon(image(icon = loaded_item.icon, icon_state = loaded_item.icon_state), no_anim = TRUE))
		data["indestructible"] = is_type_in_list(loaded_item, GLOB.item_digestion_blacklist)
		data["loaded_item"] = loaded_item
		data["already_deconstructed"] = !!stored_research.deconstructed_items[loaded_item.type]
		var/list/points = techweb_item_point_check(loaded_item)
		data["recoverable_points"] = techweb_point_display_generic(points)

		var/list/boostable_nodes = techweb_item_unlock_check(loaded_item)
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
	switch(action)
		if("eject_item")
			if(busy)
				balloon_alert(user, "already busy!")
				return TRUE
			if(loaded_item)
				unload_item()
				return TRUE
		if("deconstruct")
			if(!user_try_decon_id(params["deconstruct_id"]))
				balloon_alert(user, "analysis failed!")
			return TRUE

///Drops the loaded item where it can and nulls it.
/obj/machinery/rnd/destructive_analyzer/proc/unload_item()
	if(!loaded_item)
		return FALSE
	//playsound(loc, 'sound/machines/terminal/terminal_insert_disc.ogg', 30, FALSE)
	loaded_item.forceMove(drop_location())
	loaded_item = null
	update_icon()
	return TRUE

/**
 * Destroys an item by going through all its contents (including itself) and calling destroy_item_individual
 * Args:
 * gain_research_points - Whether deconstructing each individual item should check for research points to boost.
 */
/obj/machinery/rnd/destructive_analyzer/proc/destroy_item(gain_research_points = FALSE)
	if(QDELETED(loaded_item) || QDELETED(src))
		return FALSE
	//flick("[base_icon_state]_process", src)
	busy = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_busy)), 2.4 SECONDS)
	use_power(active_power_usage)
	var/list/all_contents = loaded_item.get_all_contents()
	SEND_SIGNAL(src, COMSIG_MACHINERY_DESTRUCTIVE_SCAN, all_contents)
	for(var/innerthing in all_contents)
		destroy_item_individual(innerthing, gain_research_points)
	playsound(src, 'sound/machines/destructive_analyzer.ogg', 50, 1)
	loaded_item = null
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
		if(mob_thing.stat != DEAD)
			log_and_message_admins("[mob_thing] has been killed by a destructive analyzer")
		mob_thing.death()
	var/list/point_value = techweb_item_point_check(thing)
	//If it has a point value and we haven't deconstructed it OR we've deconstructed it but it's a repeatable.
	if(point_value && (!stored_research.deconstructed_items[thing.type] || (stored_research.deconstructed_items[thing.type] && SSresearch.techweb_repeatable_items[thing.type])))
		stored_research.deconstructed_items[thing.type] = TRUE
		stored_research.add_point_list(point_value)

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
	if(!istype(loaded_item))
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
