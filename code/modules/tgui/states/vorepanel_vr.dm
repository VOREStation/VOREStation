 /**
  * tgui state: vorepanel_state
  *
  * Only checks that the user and src_object are the same.
 **/

GLOBAL_DATUM_INIT(tgui_vorepanel_state, /datum/tgui_state/vorepanel_state, new)

/datum/tgui_state/vorepanel_state/can_use_topic(src_object, mob/user)
	if(src_object != user)
		// Note, in order to allow others to look at others vore panels, change this to
		// STATUS_UPDATE
		return STATUS_CLOSE
	if(!user.client)
		return STATUS_CLOSE
	if(!isnewplayer(user) && user.stat == DEAD)
		return STATUS_DISABLED
	return STATUS_INTERACTIVE