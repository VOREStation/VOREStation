/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: living_state
 *
 * Checks that the user is a mob/living.
 **/

GLOBAL_DATUM_INIT(tgui_living_state, /datum/tgui_state/living_state, new)

/datum/tgui_state/living_state/can_use_topic(src_object, mob/user)
	if(isliving(user))
		return STATUS_INTERACTIVE
	return STATUS_CLOSE
