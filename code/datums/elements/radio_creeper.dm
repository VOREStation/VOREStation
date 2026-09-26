/datum/element/radio_creeper

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
/datum/element/radio_creeper/proc/handle_prepare_say(atom/source, list/message_pieces/pieces, datum/language/speaking, message, whispering)
	SIGNAL_HANDLER
	return COMSIG_SAY_IGNORE_MIME_VOW | COMSIG_SAY_IGNORE_MUZZLING | COMSIG_SAY_FORBID_RADIOS | COMSIG_SAY_FORBID_WHISPERING | COMSIG_SAY_FORBID_SPEECH_PROBLEMS

/// Handle the radio transmission of the message
/datum/element/radio_creeper/proc/handle_finalize_say(atom/source, list/message_pieces/pieces, datum/language/speaking, message, whispering, say_verb)
	SIGNAL_HANDLER

	// Transmit the message directly to nearby radios

	return COMSIG_SAY_FORBID_SPEAK // We don't need the rest of saycode
