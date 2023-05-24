/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

 /**
  * tgui state: deep_inventory_state
  *
  * Checks that the src_object is in the user's deep (backpack, box, toolbox, etc) inventory.
 **/

GLOBAL_DATUM_INIT(tgui_deep_inventory_state, /datum/tgui_state/deep_inventory_state, new)

/datum/tgui_state/deep_inventory_state/can_use_topic(src_object, mob/user)
	if(!user.contains(src_object))
		return STATUS_CLOSE
	return user.shared_tgui_interaction(src_object)

/atom/proc/contains(var/atom/location)
	if(!location)
		return 0
	if(location == src)
		return 1

	return contains(location.loc)
