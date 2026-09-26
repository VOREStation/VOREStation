/datum/element/radio_creeper
	var/range = 6

/datum/element/radio_creeper/Attach(atom/target)
	. = ..()
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_MOB_SAY_PREPARE, PROC_REF(handle_prepare_say))
	RegisterSignal(target, COMSIG_MOB_SAY_FINALIZE, PROC_REF(handle_finalize_say))

/datum/element/radio_creeper/Detach(atom/target)
	. = ..()
	UnregisterSignal(target, COMSIG_MOB_SAY_PREPARE)
	UnregisterSignal(target, COMSIG_MOB_SAY_FINALIZE)

/// We want to ensure the message gets to finalize with the proper comsig flags
/datum/element/radio_creeper/proc/handle_prepare_say(atom/source, list/message_pieces, datum/language/speaking, message, whispering)
	SIGNAL_HANDLER
	return COMSIG_SAY_IGNORE_MIME_VOW | COMSIG_SAY_IGNORE_MUZZLING | COMSIG_SAY_FORBID_WHISPERING | COMSIG_SAY_HIDDEN_FROM_GHOSTS

/// Handle the radio transmission of the message. In all cases we want to cancel the rest of say() and send the message to the radio.
/datum/element/radio_creeper/proc/handle_finalize_say(atom/source, list/message_pieces, datum/language/speaking, message, whispering, say_verb)
	SIGNAL_HANDLER
	var/turf/our_turf = get_turf(source)
	if(!our_turf)
		return COMSIG_SAY_FORBID_SPEAK

	// Get nearby radios
	var/list/listeners = get_mobs_or_objects_in_view(range, source, FALSE, TRUE) // Broadcast uses /radios in list, so no type filtering is needed
	if(!length(listeners))
		return COMSIG_SAY_FORBID_SPEAK

	// Transmit the message directly to nearby radios, use fake data so that we are not broadcasting to more than the forced radio list
	var/mob/M = source
	var/datum/radio_frequency/connection = SSradio.return_frequency(PUB_FREQ)
	Broadcast_Message(connection, M, FALSE, message_to_multilingual(pick(M.speak_emote)), null, message_pieces, M.voice_name, "Unknown", M.real_name, M.voice_name, DATA_FAKE, 0, list(0), PUB_FREQ, "garbles", listeners)

	// We don't need the rest of saycode. So we also need to log what was said as well.
	source.log_talk(message, LOG_SAY, color="#c0c0c0")
	return COMSIG_SAY_FORBID_SPEAK
