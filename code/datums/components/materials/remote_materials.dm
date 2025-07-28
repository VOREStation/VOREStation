/*
This component allows machines to connect remotely to a material container
(namely an /obj/machinery/ore_silo) elsewhere. It offers optional graceful
fallback to a local material storage in case remote storage is unavailable, and
handles linking back and forth.
*/

/datum/component/remote_materials
	// Three possible states:
	// 1. silo exists, materials is parented to silo
	// 2. silo is null, materials is parented to parent
	// 3. silo is null, materials is null

	///The silo machine this container is connected to
	var/obj/machinery/ore_silo/silo
	///Material container. the value is either the silo or local
	var/datum/component/material_container/mat_container
	///Should we create a local storage if we can't connect to silo
	var/allow_standalone
	///Local size of container when silo = null
	var/local_size = INFINITY
	///Flags used for the local material container(exceptions for item insert & intent flags)
	var/mat_container_flags = NONE
	///List of signals to hook onto the local container
	var/list/mat_container_signals

/datum/component/remote_materials/Initialize(
	mapload,
	allow_standalone = TRUE,
	force_connect = FALSE,
	mat_container_flags = NONE,
	list/mat_container_signals = null,
)
	if (!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	src.allow_standalone = allow_standalone
	src.mat_container_flags = mat_container_flags
	src.mat_container_signals = mat_container_signals

	var/turf/T = get_turf(parent)
	var/connect_to_silo = FALSE
	if(force_connect || (mapload && (T.z in using_map.station_levels)))
		connect_to_silo = TRUE

	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(on_item_insert))

	if(mapload) // wait for silo to initialize during mapload
		SSticker.OnRoundstart(CALLBACK(src, PROC_REF(_PrepareStorage), connect_to_silo))
	else //directly register in round
		_PrepareStorage(connect_to_silo)

/**
 * Internal proc. prepares local storage if onnect_to_silo = FALSE
 *
 * Arguments
 * connect_to_silo- if true connect to global silo. If not successfull then go to local storage
 * only if allow_standalone = TRUE, else you a null mat_container
 */
/datum/component/remote_materials/proc/_PrepareStorage(connect_to_silo)
	PRIVATE_PROC(TRUE)

	if (connect_to_silo)
		silo = GLOB.ore_silo_default
		if (silo)
			silo.ore_connected_machines += src
			mat_container = silo.materials

	if(!mat_container && allow_standalone)
		_MakeLocal()

/datum/component/remote_materials/Destroy()
	if(silo)
		allow_standalone = FALSE
		disconnect()
	mat_container = null

	return ..()

/datum/component/remote_materials/proc/_MakeLocal()
	PRIVATE_PROC(TRUE)

	silo = null

	mat_container = parent.AddComponent( \
		/datum/component/material_container, \
		subtypesof(/datum/material), \
		local_size, \
		mat_container_flags, \
		container_signals = mat_container_signals, \
		allowed_items = /obj/item/stack \
	)

/// Adds/Removes this connection from the silo
/datum/component/remote_materials/proc/toggle_holding()
	if(isnull(silo))
		return

	if(!silo.holds[src])
		silo.holds[src] = TRUE
	else
		silo.holds -= src

/**
 * Sets the storage size for local materials when not linked with silo
 * Arguments
 *
 * * size - the new size for local storage. measured in SHEET_MATERIAL_SIZE units
 */
/datum/component/remote_materials/proc/set_local_size(size)
	local_size = size
	if (!silo && mat_container)
		mat_container.max_amount = size

///Disconnects this component from the silo
/datum/component/remote_materials/proc/disconnect()
	if(isnull(silo))
		return

	silo.ore_connected_machines -= src
	silo = null
	mat_container = null

	if (allow_standalone)
		_MakeLocal()

/datum/component/remote_materials/proc/OnMultitool(datum/source, mob/user, obj/item/multitool/M)
	SIGNAL_HANDLER

	. = NONE
	if (!QDELETED(M.buffer) && istype(M.buffer, /obj/machinery/ore_silo))
		if (silo == M.buffer)
			to_chat(user, span_warning("[parent] is already connected to [silo]!"))
			return FALSE
		if(!check_z_level(M.buffer))
			to_chat(user, span_warning("[parent] is too far away to get a connection signal!"))
			return FALSE

		var/obj/machinery/ore_silo/new_silo = M.buffer
		var/datum/component/material_container/new_container = new_silo.GetComponent(/datum/component/material_container)
		if (silo)
			silo.ore_connected_machines -= src
			silo.holds -= src
		else if (mat_container)
			//transfer all mats to silo. whatever cannot be transfered is dumped out as sheets
			if(mat_container.total_amount())
				for(var/datum/material/mat as anything in mat_container.materials)
					var/mat_amount = mat_container.materials[mat]
					if(!mat_amount || !new_container.has_space(mat_amount) || !new_container.can_hold_material(mat))
						continue
					new_container.materials[mat] += mat_amount
					mat_container.materials[mat] = 0
			qdel(mat_container)
		silo = new_silo
		silo.ore_connected_machines += src
		mat_container = new_container
		to_chat(user, span_notice("You connect [parent] to [silo] from the multitool's buffer."))
		return TRUE

/datum/component/remote_materials/proc/on_item_insert(datum/source, obj/item/target, mob/living/user)
	SIGNAL_HANDLER
	if(istype(target, /obj/item/multitool))
		return OnMultitool(source, user, target)

	if(mat_container_flags & MATCONTAINER_NO_INSERT)
		return

	return attempt_insert(user, target)

/// Insert mats into silo
/datum/component/remote_materials/proc/attempt_insert(mob/living/user, obj/item/target)
	if(silo)
		mat_container.user_insert(target, user, parent)
		return TRUE

/**
 * Checks if the param silo is in the same level as this components parent i.e. connected machine, rcd, etc
 *
 * Arguments
 * silo_to_check- Is this components parent in the same Z level as this param silo. If null
 * then check this components connected silo
 *
 * Returns true if both are on the station or same z level
 */
/datum/component/remote_materials/proc/check_z_level(obj/silo_to_check = silo)
	if(isnull(silo_to_check))
		return FALSE

	return is_valid_z_level(get_turf(silo_to_check), get_turf(parent))

/// returns TRUE if this connection put on hold by the silo
/datum/component/remote_materials/proc/on_hold()
	return check_z_level() ? silo.holds[src] : FALSE

/**
 * Check if this connection can use any materials from the silo
 * Returns true only if
 * - The parent is of type movable atom
 * - A mat container is actually present
 * - The silo in not on hold
 * Arguments
 * * check_hold - should we check if the silo is on hold
 */
/datum/component/remote_materials/proc/can_use_resource(check_hold = TRUE)
	var/atom/movable/movable_parent = parent
	if (!istype(movable_parent))
		return FALSE
	if (!mat_container) //no silolink & local storage not supported
		movable_parent.atom_say("No access to material storage, please contact the quartermaster.")
		return FALSE
	if(check_hold && on_hold()) //silo on hold
		movable_parent.atom_say("Mineral access is on hold, please contact the quartermaster.")
		return FALSE
	return TRUE

/**
 * Use materials from either the silo(if connected) or from the local storage. If silo then this action
 * is logged else not e.g. action="build" & name="matter bin" means you are trying to build a matter bin
 *
 * Arguments
 * [mats][list]- list of materials to use
 * coefficient- each mat unit is scaled by this value then rounded. This value if usually your machine efficiency e.g. upgraded protolathe has reduced costs
 * multiplier- each mat unit is scaled by this value then rounded after it is scaled by coefficient. This value is your print quatity e.g. printing multiple items
 * action- For logging only. e.g. build, create, i.e. the action you are trying to perform
 * name- For logging only. the design you are trying to build e.g. matter bin, etc.
 */
/datum/component/remote_materials/proc/use_materials(list/mats, coefficient = 1, multiplier = 1, action = "build", name = "design")
	if(!can_use_resource())
		return 0

	var/list/rebuilt_mats = list()
	for(var/datum/material/req_mat as anything in mats)
		var/imat = mats[req_mat]
		if(!istype(req_mat))
			req_mat = GET_MATERIAL_REF(req_mat)
		rebuilt_mats[req_mat] = imat

	var/amount_consumed = mat_container.use_materials(rebuilt_mats, coefficient, multiplier)

	if (silo)//log only if silo is linked
		var/list/scaled_mats = list()
		for(var/i in rebuilt_mats)
			scaled_mats[i] = OPTIMAL_COST(OPTIMAL_COST(rebuilt_mats[i] * coefficient) * multiplier)
		silo.silo_log(parent, action, -multiplier, name, scaled_mats)

	return amount_consumed

/**
 * Ejects the given material ref and logs it
 *
 * Arguments
 * [material_ref][datum/material]- The material type you are trying to eject
 * eject_amount- how many sheets to eject
 * [drop_target][atom]- optional where to drop the sheets. null means it is dropped at this components parent location
 */
/datum/component/remote_materials/proc/eject_sheets(datum/material/material_ref, eject_amount, atom/drop_target = null)
	if(!can_use_resource())
		return 0

	var/atom/movable/movable_parent = parent
	if(isnull(drop_target))
		drop_target = movable_parent.drop_location()

	return mat_container.retrieve_sheets(eject_amount, material_ref, target = drop_target, context = parent)

/**
 * Insert an item into the mat container, helper proc to insert items with the correct context
 *
 * Arguments
 * * obj/item/weapon - the item you are trying to insert
 * * multiplier - the multiplier applied on the materials consumed
 */
/datum/component/remote_materials/proc/insert_item(obj/item/weapon, multiplier = 1)
	if(!can_use_resource(FALSE))
		return MATERIAL_INSERT_ITEM_FAILURE

	return mat_container.insert_item(weapon, multiplier, parent)
