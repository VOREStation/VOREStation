/**
 * tgui state: board_game_state
 *
 * Checks that the default living handling or if the user or the object are inside a belly
 **/

GLOBAL_DATUM_INIT(tgui_board_game_state, /datum/tgui_state/board_game_state, new)

/datum/tgui_state/board_game_state/can_use_topic(atom/src_object, mob/user)
	if(!isliving(user))
		return STATUS_UPDATE
	var/mob/living/living_user = user
	if(isbelly(living_user.loc) || isbelly(src_object.loc))
		return living_user.board_game_can_use_tgui_topic(src_object)
	return living_user.default_can_use_tgui_topic(src_object)

/mob/proc/board_game_can_use_tgui_topic(atom/src_object)
	return STATUS_CLOSE

/mob/living/board_game_can_use_tgui_topic(atom/src_object)
	if(is_incorporeal())
		return STATUS_CLOSE
	var/dist = get_dist(get_turf(src_object), get_turf(src))
	if(dist <= 1)
		return STATUS_INTERACTIVE
	return STATUS_CLOSE
