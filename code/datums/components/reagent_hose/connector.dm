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

/*
 * Inflation subtype, Big and round!
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
	return

/datum/component/hose_connector/inflation/proc/get_destination_name()
	switch(connection_mode)
		if(CONNECTION_MODE_STOMACH)
			return "mouth"
		if(CONNECTION_MODE_BELLY)
			return human_owner?.vore_selected?.name ? sanitize(human_owner.vore_selected.name) : "belly"
		if(CONNECTION_MODE_BLOOD)
			return "bloodstream"
	return "something"

/datum/component/hose_connector/inflation/get_id()
	return "\The [human_owner]'s [get_destination_name()]"

// Adding and removing the verb is more complex on humans... This code also expects only ONE hose connector
/datum/component/hose_connector/inflation/connect(datum/hose/H)
	. = ..()
	add_verb(human_owner,/atom/proc/disconnect_hose)

/datum/component/hose_connector/inflation/remove_hose()
	remove_verb(human_owner,/atom/proc/disconnect_hose)
	. = ..()

// Succ command center
/datum/component/hose_connector/inflation/proc/inflation_setup(var/mob/user,var/datum/component/hose_connector/other)
	if(!other || QDELETED(other))
		to_chat(user,span_danger("You couldn't connect the hose, as the connection stopped existing! Ohno!"))
		return FALSE

	// Check for destinations
	var/list/options = list("Mouth")
	if(human_owner?.vore_selected)
		options.Add("Belly ([sanitize(human_owner.vore_selected.name)])")
	if(!human_owner.isSynthetic()) // Results in a lot of bad behaviors...
		options.Add("Bloodstream")

	// Choose destination
	var/choice = tgui_alert(user, "Select where this hose connects.", "Hose Connection", options)
	if(!user.Adjacent(human_owner) || !choice)
		to_chat(user,span_notice("You decide not to connect \the [human_owner] to the hose."))
		return FALSE

	// Setup the connection to mouth, vore, or blood
	var/feedback = ""
	switch(choice)
		if("Mouth")
			connection_mode = CONNECTION_MODE_STOMACH
			feedback = "mouth"
		if("Bloodstream")
			connection_mode = CONNECTION_MODE_BLOOD
			feedback = span_danger("bloodstream")
		else
			connection_mode = CONNECTION_MODE_BELLY // Anything else is a vore belly name
			if(human_owner.vore_selected)
				feedback = sanitize(human_owner.vore_selected.name)

	// Display action
	name = "[human_owner]'s [feedback]"
	user.visible_message("\The [user] starts to connect the hose to \the [human_owner]'s [feedback]...")
	if(!do_after(user,7 SECONDS,human_owner))
		to_chat(user,span_warning("You couldn't connect the hose!"))
		return FALSE
	if(other.get_hose())
		to_chat(user,span_warning("You couldn't connect the hose, another hose is already connected!"))
		return FALSE
	if(!user.Adjacent(other.get_carrier()))
		to_chat(user,span_warning("You couldn't connect the hose, you are too far away!"))
		return FALSE
	if(connection_mode == CONNECTION_MODE_BLOOD) //OWCH!
		human_owner.adjustBruteLossByPart(10,BP_TORSO)
		if(human_owner.can_pain_emote) // Doing this probably doesn't feel too good
			human_owner.emote("pain")
	to_chat(user, span_notice("You connect the hose to \the [human_owner]'s [feedback]..."))
	return TRUE

/datum/component/hose_connector/inflation/connected_reagents()
	switch(connection_mode)
		if(CONNECTION_MODE_STOMACH)
			return human_owner.ingested
		if(CONNECTION_MODE_BELLY)
			return human_owner?.vore_selected?.reagents
		if(CONNECTION_MODE_BLOOD)
			// Inflating
			var/datum/component/hose_connector/other = get_pairing()
			if(!other || other.flow_direction == HOSE_OUTPUT)
				return human_owner.bloodstr // Pump into blood reagents
			// Draining
			if(prob(30) && my_hose) // NEVER put normal reagents into the vessel...
				return human_owner.vessel // Suck blood
			return human_owner.bloodstr // Suck reagents from blood

/datum/component/hose_connector/inflation/handle_pump(var/datum/reagents/connected_to)
	ASSERT(connected_to)
	var/datum/component/hose_connector/other = get_pairing()
	var/rate = reagents.maximum_volume * 0.5
	if(connection_mode == CONNECTION_MODE_BLOOD)
		rate = 10 // SLOW here
	else
		if(other.flow_direction == HOSE_OUTPUT || other.flow_direction == HOSE_NEUTRAL) // If filling mouth check prefs for belly fluid consumption.
			if(connection_mode == CONNECTION_MODE_STOMACH)
				if(!human_owner.consume_liquid_belly)
					for(var/datum/reagent/R in reagents.reagent_list)
						if(R.from_belly)
							to_chat(human_owner, span_warning("You can't consume that, it contains something produced from a belly!"))
							my_hose.disconnect() // Pop!
							return
			if(connection_mode == CONNECTION_MODE_BELLY)
				if(!human_owner.receive_reagents)
					to_chat(human_owner, span_warning("You can't transfer reagents into your [sanitize(human_owner.vore_selected.name)], your prefs dont allow it!"))
					my_hose.disconnect() // Pop!
					return
		if(other.flow_direction == HOSE_INPUT || other.flow_direction == HOSE_NEUTRAL) // If filling mouth check prefs for belly fluid consumption.
			if(connection_mode == CONNECTION_MODE_BELLY)
				if(!human_owner.give_reagents)
					to_chat(human_owner, span_warning("You can't transfer reagents from your [sanitize(human_owner.vore_selected.name)], your prefs dont allow it!"))
					my_hose.disconnect() // Pop!
					return

	// Inflation station
	switch(other.flow_direction)
		if(HOSE_OUTPUT)
			// inflating us
			if(reagents.total_volume > 0)
				if(connection_mode == CONNECTION_MODE_STOMACH || (connection_mode == CONNECTION_MODE_BELLY && human_owner?.vore_selected?.can_taste))
					human_owner.ingest(reagents,connected_to,rate)
				else
					reagents.trans_to_holder(connected_to, rate)
		if(HOSE_INPUT)
			// draining us
			connected_to.trans_to_holder(reagents,rate)
		if(HOSE_NEUTRAL)
			// Sharing with us
			reagents.trans_to_holder(connected_to, reagents.maximum_volume) // Load our current reagents back into tank, it's mixed!
			connected_to.trans_to_holder(reagents, rand(1,reagents.maximum_volume) ) // Fill back up to a random amount

	if(prob(5) && (reagents.total_volume > 0 || connected_to.total_volume > 0))
		var/atom/pumper = other.get_carrier()
		pumper.visible_message(span_infoplain(span_bold("\The [pumper]") + " gurgles."))

/*
 * Inflation subtype, Borg edition. Geewiz janihound how come the AI lets you have two?
 */

/// Pumps reagents out of carrier
/datum/component/hose_connector/input/borg
	VAR_PRIVATE/mob/living/silicon/robot/borg_owner

/datum/component/hose_connector/input/borg/Initialize()
	if(!isrobot(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	borg_owner = parent

/datum/component/hose_connector/input/borg/Destroy()
	borg_owner = null
	. = ..()

/datum/component/hose_connector/input/borg/connected_reagents()
	return borg_owner?.vore_selected?.reagents

/datum/component/hose_connector/input/borg/on_examine(datum/source, mob/user, list/examine_texts)
	return

/// Pumps reagents into carrier
/datum/component/hose_connector/output/borg
	VAR_PRIVATE/mob/living/silicon/robot/borg_owner

/datum/component/hose_connector/output/borg/Initialize()
	if(!isrobot(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	borg_owner = parent

/datum/component/hose_connector/output/borg/Destroy()
	borg_owner = null
	. = ..()

/datum/component/hose_connector/output/borg/connected_reagents()
	return borg_owner?.vore_selected?.reagents

/datum/component/hose_connector/output/borg/on_examine(datum/source, mob/user, list/examine_texts)
	return

#undef CONNECTION_MODE_STOMACH
#undef CONNECTION_MODE_BELLY
#undef CONNECTION_MODE_BLOOD
