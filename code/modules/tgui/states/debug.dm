GLOBAL_DATUM_INIT(tgui_debug_state, /datum/tgui_state/tgui_debug_state, new)

/datum/tgui_state/tgui_debug_state/can_use_topic(src_object, mob/user)
	if(check_rights_for(user.client, R_DEBUG))
		return STATUS_INTERACTIVE
	return STATUS_CLOSE
