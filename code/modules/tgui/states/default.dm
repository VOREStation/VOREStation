/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

 /**
  * tgui state: default_state
  *
  * Checks a number of things -- mostly physical distance for humans and view for robots.
 **/

GLOBAL_DATUM_INIT(tgui_default_state, /datum/tgui_state/default, new)

/datum/tgui_state/default/can_use_topic(src_object, mob/user)
	return user.default_can_use_tgui_topic(src_object) // Call the individual mob-overridden procs.

/mob/proc/default_can_use_tgui_topic(src_object)
	return STATUS_CLOSE // Don't allow interaction by default.

/mob/living/default_can_use_tgui_topic(src_object)
	. = shared_tgui_interaction(src_object)
	if(. > STATUS_CLOSE && loc)
		. = min(., loc.contents_tgui_distance(src_object, src)) // Check the distance...
	if(. == STATUS_INTERACTIVE) // Non-human living mobs can only look, not touch.
		return STATUS_UPDATE

/mob/living/carbon/human/default_can_use_tgui_topic(src_object)
	. = shared_tgui_interaction(src_object)
	if(. > STATUS_CLOSE)
		. = min(., shared_living_tgui_distance(src_object)) // Check the distance...

/mob/living/silicon/robot/default_can_use_tgui_topic(src_object)
	. = shared_tgui_interaction(src_object)
	if(. <= STATUS_DISABLED)
		return

	// Robots can interact with anything they can see.
	var/list/clientviewlist = getviewsize(client.view)
	if((src_object in view(src)) && (get_dist(src, src_object) <= min(clientviewlist[1],clientviewlist[2])))
		return STATUS_INTERACTIVE
	return STATUS_DISABLED // Otherwise they can keep the UI open.

/mob/living/silicon/ai/default_can_use_tgui_topic(src_object)
	. = shared_tgui_interaction()
	if(. != STATUS_INTERACTIVE)
		return

	// Prevents the AI from using Topic on admin levels (by for example viewing through the court/thunderdome cameras)
	// unless it's on the same level as the object it's interacting with.
	var/turf/T = get_turf(src_object)
	if(!T || !(z == T.z || (T.z in using_map.player_levels)))
		return STATUS_CLOSE

	// If an object is in view then we can interact with it
	if(src_object in view(client.view, src))
		return STATUS_INTERACTIVE

	// If we're installed in a chassi, rather than transfered to an inteliCard or other container, then check if we have camera view
	if(is_in_chassis())
		//stop AIs from leaving windows open and using then after they lose vision
		if(cameranet && !cameranet.checkTurfVis(get_turf(src_object)))
			return STATUS_CLOSE
		return STATUS_INTERACTIVE
	else if(get_dist(src_object, src) <= client.view)	// View does not return what one would expect while installed in an inteliCard
		return STATUS_INTERACTIVE

	return STATUS_CLOSE

/mob/living/simple_mob/default_can_use_tgui_topic(src_object)
	. = shared_tgui_interaction(src_object)
	if(. > STATUS_CLOSE)
		. = min(., shared_living_tgui_distance(src_object)) //simple animals can only use things they're near.

/mob/living/silicon/pai/default_can_use_tgui_topic(src_object)
	// pAIs can only use themselves and the owner's radio.
	if((src_object == src || src_object == radio || src_object == communicator) && !stat)
		return STATUS_INTERACTIVE
	else
		return ..()

/mob/observer/dead/default_can_use_tgui_topic()
	if(check_rights(R_ADMIN|R_EVENT, 0, src))
		return STATUS_INTERACTIVE				// Admins are more equal
	return STATUS_UPDATE						// Ghosts can view updates
