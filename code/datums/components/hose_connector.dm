/datum/component/hose_connector
	var/name = ""
	VAR_PROTECTED/obj/carrier = null
	VAR_PROTECTED/flow_direction = HOSE_NEUTRAL
	VAR_PROTECTED/datum/hose/my_hose = null
	VAR_PROTECTED/connector_number = 0
	// Atom reagent code piggyback
	var/flags = 0
	var/datum/reagents/reagents = null

/datum/component/hose_connector/Initialize()
	carrier = parent
	reagents = new /datum/reagents( 100, src)
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
		my_hose.disconnect()
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

/datum/component/hose_connector/proc/connect(var/datum/hose/H = null)
	if(istype(H))
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

/datum/component/hose_connector/proc/move_react(atom/orbited, atom/oldloc, direction)
	SIGNAL_HANDLER
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

/*
 * Hose datum for managing reagent transfer and destination
 */
/obj/effect/ebeam/hose
	plane = OBJ_PLANE
	layer = STAIRS_LAYER

/datum/hose
	VAR_PRIVATE/name = "hose"

	VAR_PRIVATE/datum/component/hose_connector/node1 = null
	VAR_PRIVATE/datum/component/hose_connector/node2 = null

	VAR_PRIVATE/hose_color = "#ffffff"

	VAR_PRIVATE/initial_distance = 7
	VAR_PRIVATE/datum/beam/current_beam = null

/datum/hose/proc/get_pairing(var/datum/component/hose_connector/target)
	RETURN_TYPE(/datum/component/hose_connector)
	if(target)
		if(target == node1)
			return node2
		else if(target == node2)
			return node1
	return null

/datum/hose/proc/has_pairing()
	return (node1 && node2)

/datum/hose/proc/disconnect(var/mob/user)
	// Stop processing, we're disconnecting anyway
	STOP_PROCESSING(SSobj, src)
	var/list/drop_locs = list()
	if(node1)
		var/atom/A = node1.get_carrier()
		if(A)
			drop_locs.Add(get_turf(node1.get_carrier()))
			A.visible_message("The hose detatches from \the [A]")
			playsound(A,'sound/effects/crate_close.ogg',50)
			playsound(A,'sound/effects/plop.ogg',45)
		node1.remove_hose()
		node1 = null
	if(node2)
		var/atom/A = node2.get_carrier()
		if(A)
			drop_locs.Add(get_turf(node2.get_carrier()))
			A.visible_message("The hose detatches from \the [A]")
			playsound(A,'sound/effects/crate_close.ogg',50)
			playsound(A,'sound/effects/plop.ogg',45)
		node2.remove_hose()
		node2 = null
	// Drop hose at one of the locations if no user is specified
	if((user || drop_locs.len) && initial_distance)
		new /obj/item/stack/hose(user ? get_turf(user) : pick(drop_locs), initial_distance)
		initial_distance = 0
	update_beam()
	qdel(src)

/datum/hose/proc/set_hose(var/datum/component/hose_connector/target1, var/datum/component/hose_connector/target2, var/distancetonode)
	if(target1 && target2)
		node1 = target1
		node2 = target2

	node1.connect(src)
	node2.connect(src)
	name = "[name] ([node1],[node2])"

	initial_distance = distancetonode
	if(update_beam()) // Somehow you screwed this up from the start?
		START_PROCESSING(SSobj, src)

		// Poip!~
		var/atom/A = node1.get_carrier()
		A.visible_message("The hose attaches to \the [A]")
		playsound(A,'sound/effects/crate_open.ogg',50)
		playsound(A,'sound/effects/pop.ogg',65)

		A = node2.get_carrier()
		A.visible_message("The hose attaches to \the [A]")
		playsound(A,'sound/effects/crate_open.ogg',50)
		playsound(A,'sound/effects/pop.ogg',65)

/// Updates the beam visual effect for the hose. Returns if the hose is still has a valid connection or not.
/datum/hose/proc/update_beam()
	if(!node1 && !node2) // We've already disconnected, clear beam
		if(current_beam)
			qdel_null(current_beam)
		return FALSE
	if(get_dist(get_turf(node1.get_carrier()), get_turf(node2.get_carrier())) > initial_distance)	// The hose didn't form. Something's fucky.
		disconnect()
		return FALSE
	if(get_dist(get_turf(node1.get_carrier()), get_turf(node2.get_carrier())) > 0)
		// Colors!
		var/new_col = hose_color
		var/datum/reagents/reagent_node1 = node1.reagents
		var/datum/reagents/reagent_node2 = node2.reagents
		if(reagent_node1.total_volume > reagent_node2.total_volume)
			new_col = reagent_node1.get_color()
		else if(reagent_node2.total_volume > 0)
			new_col = reagent_node2.get_color()

		// We are in the beam!
		var/atom/holder = node1.get_carrier()
		qdel_swap(current_beam, holder.Beam(node2.get_carrier(), icon_state = "hose", beam_color = new_col, maxdistance = world.view, beam_type = /obj/effect/ebeam/hose))

	return TRUE

/datum/hose/process()
	if(node1 && node2)
		if(!update_beam())
			return

		var/datum/reagents/reagent_node1 = node1.reagents
		var/datum/reagents/reagent_node2 = node2.reagents

		switch(node1.get_flow_direction())	// Node 1 is the default 'master', interactions are considered in all current possible states in regards to it, however.
			if(HOSE_INPUT)
				if(node2.get_flow_direction() == HOSE_NEUTRAL)	// We're input, they're neutral. Take half of our volume.
					reagent_node2.trans_to_holder(reagent_node1, reagent_node1.maximum_volume / 2)
				else if(node2.get_flow_direction() == HOSE_OUTPUT)	// We're input, they're output. Take all of our volume.
					reagent_node2.trans_to_holder(reagent_node1, reagent_node1.maximum_volume)

			if(HOSE_OUTPUT)	// We're output, give all of their maximum volume.
				reagent_node1.trans_to_holder(reagent_node2, reagent_node2.maximum_volume)

			if(HOSE_NEUTRAL)
				switch(node2.get_flow_direction())
					if(HOSE_INPUT)	// We're neutral, they're input. Give them half of their volume.
						reagent_node1.trans_to_holder(reagent_node2, reagent_node2.maximum_volume / 2)

					if(HOSE_NEUTRAL)	// We're neutral, they're neutral. Balance our values.
						var/volume_difference_perc = (reagent_node1.total_volume / reagent_node1.maximum_volume) - (reagent_node2.total_volume / reagent_node2.maximum_volume)
						var/volume_difference = 0

						var/pulling = FALSE
						if(volume_difference_perc > 0)	// They are smaller, so they determine the transfer amount. Half of the difference will equalize.
							volume_difference = reagent_node2.maximum_volume * volume_difference_perc / 2

						else if(volume_difference_perc < 0)	// We're smaller, so we determine the transfer amount. Half of the difference will equalize.
							volume_difference_perc *= -1

							pulling = TRUE

							volume_difference = reagent_node1.maximum_volume * volume_difference_perc / 2

						if(volume_difference)
							if(pulling)
								reagent_node2.trans_to_holder(reagent_node1, volume_difference)
							else
								reagent_node1.trans_to_holder(reagent_node2, volume_difference)

					if(HOSE_OUTPUT)
						reagent_node2.trans_to_holder(reagent_node1, reagent_node2.maximum_volume)

	else
		disconnect()
