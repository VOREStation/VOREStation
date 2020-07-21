 /**
  * tgui state: ntos_state
  *
  * Checks a number of things -- mostly physical distance for humans and view for robots.
  * This is basically the same as default, except instead of src_object, it uses the computer
  * it's attached to.
 **/

GLOBAL_DATUM_INIT(tgui_ntos_state, /datum/tgui_state/ntos, new)

/datum/tgui_state/ntos/can_use_topic(src_object, mob/user)
	var/datum/computer_file/program/P = src_object
	if(!istype(P) || !P.computer)
		return FALSE
	return user.default_can_use_tgui_topic(P.computer) // Call the individual mob-overridden procs.
