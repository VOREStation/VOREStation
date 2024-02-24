/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

 /**
  * tgui state: hands_state
  *
  * Checks that the src_object is in the user's hands.
 **/

GLOBAL_DATUM_INIT(tgui_hands_state, /datum/tgui_state/hands_state, new)

/datum/tgui_state/hands_state/can_use_topic(src_object, mob/user)
	. = user.shared_tgui_interaction(src_object)
	if(. > STATUS_CLOSE)
		return min(., user.hands_can_use_tgui_topic(src_object))

/mob/proc/hands_can_use_tgui_topic(src_object)
	return STATUS_CLOSE

/mob/living/hands_can_use_tgui_topic(src_object)
	if(src_object in get_all_held_items())
		return STATUS_INTERACTIVE
	return STATUS_CLOSE

/mob/living/silicon/robot/hands_can_use_tgui_topic(src_object)
	if(activated(src_object))
		return STATUS_INTERACTIVE
	return STATUS_CLOSE
