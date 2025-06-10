/datum/component/hose_connector
	var/name = ""
	VAR_PROTECTED/obj/carrier = null
	VAR_PROTECTED/flow_direction = HOSE_NEUTRAL
	VAR_PROTECTED/datum/hose/my_hose = null
	VAR_PROTECTED/connector_number = 0
	// Atom reagent code piggyback
	var/flags = NOREACT // Prevent reagent explosions runtiming because no turf or by deleting the hose datum
	var/datum/reagents/reagents = null

/datum/component/hose_connector/Initialize()
	carrier = parent
	reagents = new /datum/reagents( 60, src)
	name = "[flow_direction] hose connector"

	var/list/CL = carrier.GetComponents(type)
	connector_number = CL.len + 1
	RegisterSignal(carrier, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(carrier, COMSIG_MOVABLE_MOVED, PROC_REF(move_react))
	carrier.verbs |= /atom/proc/disconnect_hose

	START_PROCESSING(SSobj, src)

/datum/component/hose_connector/Destroy()
	STOP_PROCESSING(SSobj, src)
	UnregisterSignal(carrier, COMSIG_PARENT_EXAMINE)
	UnregisterSignal(carrier, COMSIG_MOVABLE_MOVED)
	carrier.verbs -= /atom/proc/disconnect_hose
	carrier = null
	if(my_hose)
		qdel_null(my_hose)
	qdel_null(reagents)
	. = ..()

/datum/component/hose_connector/proc/get_carrier()
	RETURN_TYPE(/atom)
	return carrier

/datum/component/hose_connector/proc/get_hose()
	RETURN_TYPE(/datum/hose)
	return my_hose

/datum/component/hose_connector/proc/get_flow_direction()
	return flow_direction

/datum/component/hose_connector/output/process()
	return

/datum/component/hose_connector/proc/force_pump()
	process()
	if(prob(5))
		carrier.visible_message(span_infoplain(span_bold("\The [carrier]") + " gurgles as it pumps fluid."))

/datum/component/hose_connector/proc/valid_connection(var/datum/component/hose_connector/C)
	if(istype(C))
		if(C.my_hose)
			return FALSE
		if(C.flow_direction in (list(HOSE_INPUT, HOSE_OUTPUT) - flow_direction))
			return TRUE
	return FALSE

/datum/component/hose_connector/proc/disconnect_action(var/user)
	if(carrier.Adjacent(user))
		carrier.visible_message("[user] disconnects \the hose from \the [carrier].")
		my_hose.disconnect(user)
		qdel_null(my_hose)

/datum/component/hose_connector/proc/connect(var/datum/hose/H = null)
	my_hose = H

/datum/component/hose_connector/proc/setup_hoses(var/datum/component/hose_connector/target, var/distancetonode)
	if(target)
		var/datum/hose/H = new()
		H.set_hose(src, target, distancetonode)

/datum/component/hose_connector/proc/get_pairing()
	RETURN_TYPE(/datum/component/hose_connector)
	if(my_hose)
		return my_hose.get_pairing(src)
	return null

/datum/component/hose_connector/proc/remove_hose()
	my_hose = null

/datum/component/hose_connector/proc/on_examine(datum/source, mob/user, list/examine_texts)
	SIGNAL_HANDLER
	var/datum/component/hose_connector/hose_pair = my_hose?.get_pairing(src)
	if(hose_pair)
		hose_pair = "\the [hose_pair.get_carrier()]"
	else
		hose_pair = "nothing"
	examine_texts += span_notice("[name] #[connector_number] is [my_hose ? "connected to [hose_pair]" : "disconnected"].")

/datum/component/hose_connector/proc/move_react(atom/source, atom/oldloc, direction, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER
	update_hose_beam()

/datum/component/hose_connector/proc/update_hose_beam()
	if(!my_hose || !my_hose.has_pairing(src))
		return
	// Handle distance check if too far
	my_hose.update_beam()

/*
 * Subtypes
 */

/// Pumps reagents out of carrier
/datum/component/hose_connector/input
	name = "hose input"
	flow_direction = HOSE_INPUT

/datum/component/hose_connector/input/process()
	if(carrier)
		reagents.trans_to_obj(carrier, reagents.maximum_volume)

/// Pumps reagents into carrier
/datum/component/hose_connector/output
	name = "hose output"
	flow_direction = HOSE_OUTPUT

/datum/component/hose_connector/output/process()
	if(carrier && my_hose)
		carrier.reagents.trans_to_holder(reagents, reagents.maximum_volume)
	else if(reagents.total_volume && carrier && !my_hose)
		reagents.trans_to_obj(carrier, reagents.maximum_volume)

/*
 * Support procs/verbs
 */

/atom/proc/disconnect_hose()
	set src in oview(1)
	set name = "Disconnect Hose"
	set desc = "Quickly disconnect a hose from all machines it is attached to."
	set category = "Object"

	var/list/available_sockets = list()
	for(var/datum/component/hose_connector/HC in GetComponents(/datum/component/hose_connector))
		if(HC.get_hose())
			available_sockets |= HC
	if(!LAZYLEN(available_sockets))
		return

	if(available_sockets.len == 1)
		var/datum/component/hose_connector/AC = available_sockets[1]
		AC.disconnect_action(usr)
	else
		var/choice = tgui_input_list(usr, "Select a target hose connector.", "Socket Disconnect", available_sockets)
		if(choice)
			var/datum/component/hose_connector/AC = choice
			AC.disconnect_action(usr)
