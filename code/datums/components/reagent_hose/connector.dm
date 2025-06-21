/datum/component/hose_connector
	var/name = ""
	dupe_mode = COMPONENT_DUPE_ALLOWED
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
	RegisterSignal(carrier, COMSIG_HOSE_FORCEPUMP, PROC_REF(force_pump))
	carrier.verbs |= /atom/proc/disconnect_hose

	START_PROCESSING(SSobj, src)

/datum/component/hose_connector/Destroy()
	STOP_PROCESSING(SSobj, src)
	UnregisterSignal(carrier, COMSIG_PARENT_EXAMINE)
	UnregisterSignal(carrier, COMSIG_MOVABLE_MOVED)
	UnregisterSignal(carrier, COMSIG_HOSE_FORCEPUMP)
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

/datum/component/hose_connector/proc/get_id()
	return "[name] #[connector_number]"

/datum/component/hose_connector/proc/connected_reagents()
	return carrier.reagents

/datum/component/hose_connector/process()
	// Return reagents to source if no hose, lossy to avoid exploits
	if(!my_hose)
		if(!reagents.total_volume)
			reagents.trans_to_holder(connected_reagents(), reagents.maximum_volume)
			reagents.clear_reagents() // Wipe it to avoid exploits
		return
	var/datum/reagents/connected_to = connected_reagents()
	if(!connected_to) // Emergency. the vorebelly was deleted or something. Lets just hard lock that out from maintaining state by disconnecting the tube.
		reagents.clear_reagents()
		my_hose.disconnect()
		return
	handle_pump(connected_to)

/datum/component/hose_connector/proc/handle_pump(var/datum/reagents/connected_to)
	PROTECTED_PROC(TRUE)
	ASSERT(connected_to)
	// Drain our connector back into tank, and then fill it randomly. The hose handles swapping.
	reagents.trans_to_holder(connected_to, reagents.maximum_volume)
	connected_to.trans_to_holder(reagents, rand(1,reagents.maximum_volume))

/datum/component/hose_connector/proc/force_pump()
	SIGNAL_HANDLER
	process()
	if(prob(5))
		carrier.visible_message(span_infoplain(span_bold("\The [carrier]") + " gurgles as it pumps fluid."))

/datum/component/hose_connector/proc/valid_connection(var/datum/component/hose_connector/C)
	if(istype(C))
		if(C.my_hose)
			return FALSE
		if(C.flow_direction == HOSE_NEUTRAL || flow_direction == HOSE_NEUTRAL) // Always allowed
			return TRUE
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

/datum/component/hose_connector/proc/setup_hoses(var/datum/component/hose_connector/target, var/distancetonode, var/mob/user)
	if(!target || QDELETED(target))
		to_chat(user,span_danger("What you were connecting to has stopped existing! Ohno!"))
		return FALSE

	// Logic for handling two mobs at once would be a mess of option selections and prefs...
	if(istype(src,/datum/component/hose_connector/inflation) && istype(target,/datum/component/hose_connector/inflation))
		to_chat(user,span_notice("Nothing would flow between \the [get_carrier()] and \the [target.get_carrier()] without anything to pump it!"))
		return FALSE

	// Check for vore inflation connectors.
	if(istype(src,/datum/component/hose_connector/inflation) || istype(target,/datum/component/hose_connector/inflation))
		// Handle the connection target once we setup the hose. Needs to be done like this as either ends can be the inflation connector
		// Also has to be done on finalize, as players would be able to click one then the other, then potentially drop or do other stuff with the hose!
		var/datum/component/hose_connector/inflation/I = src
		if(istype(I))
			if(!I.inflation_setup(user,target))
				return FALSE
		else
			I = target
			if(istype(I))
				if(!I.inflation_setup(user,src))
					return FALSE
			else // Good going, you broke it
				to_chat(user,span_notice("You're not sure what happened, but you couldn't connect the hose..."))
				return FALSE
	else
		to_chat(user, span_notice("You connect the [src] to \the [target]."))

	// Handle invalid vorebellies, has to be done after inflation_setup()
	if(!src.connected_reagents())
		to_chat(user,span_warning("\The [get_carrier()] doesn't seem ready to connect yet."))
		return FALSE
	if(!target.connected_reagents())
		to_chat(user,span_warning("\The [target.get_carrier()] doesn't seem ready to connect yet."))
		return FALSE

	// Hose prepared!
	var/datum/hose/H = new()
	H.set_hose(src, target, distancetonode, user)
	return TRUE

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
	if(istype(hose_pair,/datum/component/hose_connector/inflation))
		hose_pair = "\the [hose_pair.name]" // Slightly different, so it shows the belly attached
	else if(hose_pair)
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
			available_sockets[HC.get_id()] = HC
	if(!LAZYLEN(available_sockets))
		return

	if(available_sockets.len == 1)
		var/key = available_sockets[1]
		var/datum/component/hose_connector/AC = available_sockets[key]
		AC.disconnect_action(usr)
	else
		var/choice = tgui_input_list(usr, "Select a target hose connector.", "Socket Disconnect", available_sockets)
		if(choice)
			var/datum/component/hose_connector/AC = available_sockets[choice]
			AC.disconnect_action(usr)


/*
 * Standard subtypes
 */

/// Pumps reagents out of carrier
/datum/component/hose_connector/input
	name = "hose input"
	flow_direction = HOSE_INPUT

/datum/component/hose_connector/input/handle_pump(var/datum/reagents/connected_to)
	ASSERT(connected_to)
	reagents.trans_to_holder(connected_to, reagents.maximum_volume)

/// Pumps reagents into carrier
/datum/component/hose_connector/output
	name = "hose output"
	flow_direction = HOSE_OUTPUT

/datum/component/hose_connector/output/handle_pump(var/datum/reagents/connected_to)
	ASSERT(connected_to)
	connected_to.trans_to_holder(reagents, reagents.maximum_volume)

/// Endless source, produces a reagent and pumps it out forever. Does not require attached object to have reagents.
/datum/component/hose_connector/endless_source
	name = "source connector"
	flow_direction = HOSE_OUTPUT
	var/reagent_id = null

/datum/component/hose_connector/endless_source/Initialize()
	. = ..()
	name = initial(name)

/datum/component/hose_connector/endless_source/connected_reagents()
	if(!carrier)
		return null
	return reagents // Ourselves, not our carrier

/datum/component/hose_connector/endless_source/handle_pump(var/datum/reagents/connected_to)
	ASSERT(connected_to)
	connected_to.add_reagent(reagent_id,5)

/datum/component/hose_connector/endless_source/water
	reagent_id = REAGENT_ID_WATER

/// Endless drain, removes reagents from existance
/datum/component/hose_connector/endless_drain
	name = "drain connector"
	flow_direction = HOSE_INPUT

/datum/component/hose_connector/endless_drain/Initialize()
	. = ..()
	name = initial(name)

/datum/component/hose_connector/endless_drain/connected_reagents()
	if(!carrier)
		return null
	return reagents // Ourselves, not our carrier

/datum/component/hose_connector/endless_drain/handle_pump(var/datum/reagents/connected_to)
	ASSERT(connected_to)
	connected_to.clear_reagents()
