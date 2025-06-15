/*
 * Inflation subtype, Big and round!
 */
/datum/component/hose_connector/inflation
	flow_direction = HOSE_NEUTRAL
	var/connection_mode = CHEM_INGEST
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
		if(CHEM_INGEST)
			return "mouth"
		if(CHEM_VORE)
			return human_owner?.vore_selected?.name ? sanitize(human_owner.vore_selected.name) : "belly"
		if(CHEM_BLOOD)
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
			connection_mode = CHEM_INGEST
			feedback = "mouth"
		if("Bloodstream")
			connection_mode = CHEM_BLOOD
			feedback = span_danger("bloodstream")
		else
			connection_mode = CHEM_VORE // Anything else is a vore belly name
			if(human_owner.vore_selected)
				feedback = sanitize(human_owner.vore_selected.name)

	// Display action
	name = "[human_owner]'s [feedback]"
	user.visible_message("\The [user] starts to connect the hose to \the [human_owner]'s [feedback]...")
	if(!do_after(user,7 SECONDS,human_owner))
		to_chat(user,span_warning("You couldn't connect the hose!"))
		return FALSE
	if(other.get_hose() || get_hose()) // SHouldn't be connected to anything yet!
		to_chat(user,span_warning("You couldn't connect the hose, another hose is already connected!"))
		return FALSE
	if(connection_mode == CHEM_BLOOD) //OWCH!
		human_owner.adjustBruteLossByPart(10,BP_TORSO)
		if(human_owner.can_pain_emote) // Doing this probably doesn't feel too good
			human_owner.emote("pain")
	to_chat(user, span_notice("You connect the hose to \the [human_owner]'s [feedback]..."))
	return TRUE

/datum/component/hose_connector/inflation/connected_reagents()
	switch(connection_mode)
		if(CHEM_INGEST)
			return human_owner.ingested
		if(CHEM_VORE)
			return human_owner?.vore_selected?.reagents
		if(CHEM_BLOOD)
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
	if(connection_mode == CHEM_BLOOD)
		rate = 10 // SLOW here
	else
		if(other.flow_direction == HOSE_OUTPUT || other.flow_direction == HOSE_NEUTRAL) // If filling mouth check prefs for belly fluid consumption.
			if(connection_mode == CHEM_INGEST)
				if(!human_owner.consume_liquid_belly)
					for(var/datum/reagent/R in reagents.reagent_list)
						if(R.from_belly)
							to_chat(human_owner, span_warning("You can't consume that, it contains something produced from a belly!"))
							my_hose.disconnect() // Pop!
							return
			if(connection_mode == CHEM_VORE)
				if(!human_owner.receive_reagents)
					to_chat(human_owner, span_warning("You can't transfer reagents into your [sanitize(human_owner.vore_selected.name)], your prefs dont allow it!"))
					my_hose.disconnect() // Pop!
					return
		if(other.flow_direction == HOSE_INPUT || other.flow_direction == HOSE_NEUTRAL) // If filling mouth check prefs for belly fluid consumption.
			if(connection_mode == CHEM_VORE)
				if(!human_owner.give_reagents)
					to_chat(human_owner, span_warning("You can't transfer reagents from your [sanitize(human_owner.vore_selected.name)], your prefs dont allow it!"))
					my_hose.disconnect() // Pop!
					return

	// Inflation station
	switch(other.flow_direction)
		if(HOSE_OUTPUT)
			// inflating us
			if(reagents.total_volume > 0)
				reagents.vore_trans_to_mob(human_owner, rate, connection_mode, 1, 0, human_owner.vore_selected)
		if(HOSE_INPUT)
			// draining us
			if(connected_to.total_volume > 0)
				connected_to.trans_to_holder(reagents,rate)
		if(HOSE_NEUTRAL)
			// Sharing with us
			reagents.trans_to_holder(connected_to, reagents.maximum_volume) // Load our current reagents back into tank, it's mixed!
			connected_to.trans_to_holder(reagents, rand(1,reagents.maximum_volume) ) // Fill back up to a random amount

	if(connection_mode == CHEM_VORE && human_owner.vore_selected.count_liquid_for_sprite)
		human_owner.handle_belly_update()

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
