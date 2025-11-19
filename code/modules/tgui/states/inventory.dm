/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/**
 * tgui state: inventory_state
 *
 * Checks that the src_object is in the user's top-level (hand, ear, pocket, belt, etc) inventory.
 * Or part of a robotic toolbelt.
 **/

GLOBAL_DATUM_INIT(tgui_inventory_state, /datum/tgui_state/inventory_state, new)

/datum/tgui_state/inventory_state/can_use_topic(atom/src_object, mob/user)
	if(!(src_object in user) && !(isrobotmultibelt(src_object.loc)))
		return STATUS_CLOSE
	return user.shared_tgui_interaction(src_object)
