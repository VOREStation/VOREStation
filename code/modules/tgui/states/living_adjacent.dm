/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: living_adjacent_state
 *
 * In addition to default checks, only allows interaction for a
 * living adjacent user.
 **/

GLOBAL_DATUM_INIT(tgui_living_adjacent_state, /datum/tgui_state/living_adjacent_state, new)

/datum/tgui_state/living_adjacent_state/can_use_topic(src_object, mob/user)
	. = user.default_can_use_tgui_topic(src_object)

	var/dist = get_dist(src_object, user)
	if((dist > 1) || (!isliving(user)))
		// Can't be used unless adjacent and human, even with TK
		. = min(., STATUS_UPDATE)
