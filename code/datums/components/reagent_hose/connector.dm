#define CONNECTION_MODE_STOMACH 0
#define CONNECTION_MODE_BELLY 1
#define CONNECTION_MODE_BLOOD 2
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

/datum/component/hose_connector/proc/get_id()
	return "[name] #[connector_number]"

/datum/component/hose_connector/process()
	// Return reagents to source if no hose, lossy to avoid exploits
	if(!my_hose)
		if(!reagents.total_volume)
			reagents.trans_to_obj(carrier, reagents.maximum_volume)
		return
	// Handle flow control
	switch(flow_direction)
		if(HOSE_OUTPUT)
			carrier.reagents.trans_to_holder(reagents, reagents.maximum_volume)
		if(HOSE_INPUT)
			reagents.trans_to_obj(carrier, reagents.maximum_volume)
		if(HOSE_NEUTRAL)
			// Drain our connector back into tank, and then fill it randomly. The hose handles swapping.
			reagents.trans_to_obj(carrier, reagents.maximum_volume)
			carrier.reagents.trans_to_holder(reagents, rand(1,reagents.maximum_volume))

/datum/component/hose_connector/proc/force_pump()
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
	if(!target)
		return FALSE
	// Logic for handling two mobs at once would be a mess of option selections and prefs...
	if(istype(src,/datum/component/hose_connector/inflation) && istype(target,/datum/component/hose_connector/inflation))
		to_chat(user,span_notice("Nothing would flow between \the [get_carrier()] and \the [target.get_carrier()] without anything to pump it!"))
		return FALSE
	// Check for vore inflation connectors. Need to set their target!
	if(istype(src,/datum/component/hose_connector/inflation) || istype(target,/datum/component/hose_connector/inflation))
		var/datum/component/hose_connector/inflation/I = src
		if(!istype(I))
			I = target
		if(istype(I)) // Good going, you broke it
			to_chat(user,span_notice("You're not sure what happened, but you couldn't connect the hose..."))
			return FALSE
		// Check for destination
		var/choice = tgui_input_list(user, "Select where this hose connects.", "Hose Connection", list("1:Mouth",I.human_owner?.vore_selected?.name ? "2:[I.human_owner.vore_selected.name]" : "Belly", "3:Bloodstream"))
		if(!user.Adjacent(I.human_owner) || !choice)
			to_chat(user,span_notice("You decide not to connect \the [I.human_owner] to the hose."))
			return FALSE
		// These have numbered entries to avoid players using bellies named "Mouth" and making the switch here break
		var/feedback = ""
		switch(choice)
			if("1:Mouth")
				I.connection_mode = CONNECTION_MODE_STOMACH
				feedback = "mouth"
			if("3:Bloodstream")
				I.connection_mode = CONNECTION_MODE_BLOOD
				if(I.human_owner.isSynthetic())
					feedback = span_warning("internal systems")
				else
					feedback = span_danger("bloodstream")
			else
				I.connection_mode = CONNECTION_MODE_BELLY // Anything else is a vore belly name
				feedback = I.human_owner.vore_selected.name
		user.visible_message("\The [user] starts to connect the hose to \the [I.human_owner]'s [feedback]...")
		if(!do_after(user,4 SECONDS,I.human_owner))
			to_chat(user,span_warning("You couldn't connect the hose!"))
			return FALSE
		else if(I.connection_mode == CONNECTION_MODE_BLOOD && !I.human_owner.isSynthetic()) //OWCH!
			I.human_owner.adjustBruteLossByPart(10,BP_TORSO)
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

/// Pumps reagents into carrier
/datum/component/hose_connector/output
	name = "hose output"
	flow_direction = HOSE_OUTPUT

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
 * Inflation connector, Big and round!
 */
/datum/component/hose_connector/inflation
	flow_direction = HOSE_NEUTRAL
	var/connection_mode = CONNECTION_MODE_STOMACH
	var/mob/living/carbon/human/human_owner

/datum/component/hose_connector/inflation/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	human_owner = parent
	remove_verb(human_owner,/atom/proc/disconnect_hose)

/datum/component/hose_connector/inflation/Destroy()
	human_owner = null
	. = ..()

/datum/component/hose_connector/inflation/on_examine(datum/source, mob/user, list/examine_texts)
	var/datum/component/hose_connector/hose_pair = my_hose?.get_pairing(src)
	if(!hose_pair)
		return
	examine_texts += span_notice("\The [human_owner]'s [get_destination_name()] is connected to \the [hose_pair.get_carrier()].")

/datum/component/hose_connector/inflation/proc/get_destination_name()
	switch(connection_mode)
		if(CONNECTION_MODE_STOMACH)
			return "mouth"
		if(CONNECTION_MODE_BELLY)
			return human_owner?.vore_selected?.name ? human_owner.vore_selected.name : "belly"
		if(CONNECTION_MODE_BLOOD)
			return "bloodstream"
	return "something"

/datum/component/hose_connector/inflation/get_id()
	return "\The [human_owner]'s [get_destination_name()]"

// Adding and removing the verb is more complex on humans... This code also expects only ONE hose connector
/datum/component/hose_connector/inflation/setup_hoses(var/datum/component/hose_connector/target, var/distancetonode)
	. = ..()
	add_verb(human_owner,/atom/proc/disconnect_hose)

/datum/component/hose_connector/inflation/remove_hose()
	remove_verb(human_owner,/atom/proc/disconnect_hose)
	. = ..()

// Succ command center
/datum/component/hose_connector/inflation/process()
	if(!human_owner)
		return
	name = human_owner.name // Incase of mob rename, and because component is added before name is ever set!
	var/rate = 0
	var/datum/reagents/connected_to = null
	var/datum/component/hose_connector/other = get_pairing()
	if(other)
		switch(connection_mode)
			if(CONNECTION_MODE_STOMACH)
				connected_to = human_owner.ingested
				rate = reagents.maximum_volume * 0.5
			if(CONNECTION_MODE_BELLY)
				connected_to = human_owner?.vore_selected?.reagents
				rate = reagents.maximum_volume * 0.5
			if(CONNECTION_MODE_BLOOD)
				if(other.flow_direction == HOSE_OUTPUT) // inflating
					connected_to = human_owner.bloodstr // Pump into blood reagents
				else
					if(prob(30) && my_hose) // If no hose is attached, NEVER put normal reagents into the vessel...
						connected_to = human_owner.vessel // Suck blood
					else
						connected_to = human_owner.bloodstr // Suck reagents from blood
				rate = 10 // SLOW here
		if(!connected_to)
			reagents.clear_reagents()
			return

	if(!my_hose || !other)
		if(reagents.total_volume)
			reagents.trans_to_holder(connected_to,reagents.total_volume)
			reagents.clear_reagents()
		return

	// Inflation station
	switch(other.flow_direction)
		if(HOSE_OUTPUT)
			// inflating us
			reagents.trans_to_holder(connected_to,rate)
		if(HOSE_INPUT)
			// draining us
			connected_to.trans_to_holder(reagents,rate)
		if(HOSE_NEUTRAL)
			// Sharing with us
			reagents.trans_to_holder(connected_to, reagents.maximum_volume) // Load our current reagents back into tank, it's mixed!
			carrier.reagents.trans_to_holder(reagents, rand(1,reagents.maximum_volume) ) // Fill back up to a random amount

#undef CONNECTION_MODE_STOMACH
#undef CONNECTION_MODE_BELLY
#undef CONNECTION_MODE_BLOOD
