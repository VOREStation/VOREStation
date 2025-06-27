/**
 * tgui state: ticket_state
 *
 * Grants the user UI_INTERACTIVE, if a ticket is open.
 */

GLOBAL_DATUM_INIT(tgui_ticket_state, /datum/tgui_state/ticket_state, new)

/datum/tgui_state/ticket_state/can_use_topic(src_object, mob/user)
	//if (user.client.current_ticket)
	//	return STATUS_INTERACTIVE
	//return STATUS_CLOSE
	return STATUS_INTERACTIVE
