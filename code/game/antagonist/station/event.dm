var/datum/antagonist/event/event

// Inherits most of its vars from the base datum.
/datum/antagonist/event
	id = MODE_EVENT
	role_type = BE_EVENT
	role_text = "Event Character"
	role_text_plural = "Event Characters"
	can_hear_aooc = TRUE		// If FALSE, the antag can neither speak nor hear AOOC. If TRUE, they can at least hear it.
	can_speak_aooc = TRUE		// If TRUE, the antag can freely spean in AOOC.

	welcome_text = "You are an event character."
	antag_text = "You are have been selected as an event character, this gives you \
		access to the AOOC chat channel to organise with other event characters. <b>Please remember all \
		rules aside from those with explicit exceptions apply to event characters.</b>"
