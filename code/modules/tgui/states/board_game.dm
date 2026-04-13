/**
 * tgui state: board_game_state
 *
 * Checks the distance only based on the turf, to allow interaction with devices held in hand or people inside a belly
 **/

GLOBAL_DATUM_INIT(tgui_board_game_state, /datum/tgui_state/board_game_state, new)

/datum/tgui_state/board_game_state/can_use_topic(atom/src_object, mob/user)
	if(!isliving(user))
		return STATUS_UPDATE
	return user.board_game_can_use_tgui_topic(src_object)

/mob/proc/board_game_can_use_tgui_topic(atom/src_object)
	return STATUS_CLOSE

/mob/living/board_game_can_use_tgui_topic(atom/src_object)
	if(is_incorporeal())
		return STATUS_CLOSE
	var/dist = get_dist(get_turf(src_object), get_turf(src))
	if(dist <= 1)
		return STATUS_INTERACTIVE
	else if(dist <= 2) // View only if 2-3 tiles away.
		return STATUS_UPDATE
	else if(dist <= 5) // Disable if 5 tiles away.
		return STATUS_DISABLED
	return STATUS_CLOSE
