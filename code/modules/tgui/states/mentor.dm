/**
 * tgui state: mentor_state
 *
 * Checks that the user is an mentor.
 **/

GLOBAL_DATUM_INIT(tgui_mentor_state, /datum/tgui_state/mentor_state, new)

/datum/tgui_state/mentor_state/can_use_topic(src_object, mob/user)
	if(check_rights_for(user.client, R_ADMIN|R_EVENT|R_DEBUG|R_MENTOR))
		return STATUS_INTERACTIVE
	return STATUS_CLOSE
