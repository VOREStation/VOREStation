 /**
  * tgui state: physical_state
  *
  * Short-circuits the default state to only check physical distance.
 **/

GLOBAL_DATUM_INIT(tgui_physical_state, /datum/tgui_state/physical, new)

/datum/tgui_state/physical/can_use_topic(src_object, mob/user)
	. = user.shared_tgui_interaction(src_object)
	if(. > STATUS_CLOSE)
		return min(., user.physical_can_use_tgui_topic(src_object))

/mob/proc/physical_can_use_tgui_topic(src_object)
	return STATUS_CLOSE

/mob/living/physical_can_use_tgui_topic(src_object)
	return shared_living_tgui_distance(src_object)

/mob/living/silicon/physical_can_use_tgui_topic(src_object)
	return max(STATUS_UPDATE, shared_living_tgui_distance(src_object)) // Silicons can always see.

/mob/living/silicon/ai/physical_can_use_tgui_topic(src_object)
	return STATUS_UPDATE // AIs are not physical.

/**
 * tgui state: physical_obscured_state
 *
 * Short-circuits the default state to only check physical distance, being in view doesn't matter
 */

GLOBAL_DATUM_INIT(tgui_physical_obscured_state, /datum/tgui_state/physical_obscured_state, new)

/datum/tgui_state/physical_obscured_state/can_use_topic(src_object, mob/user)
	. = user.shared_tgui_interaction(src_object)
	if(. > STATUS_CLOSE)
		return min(., user.physical_obscured_can_use_topic(src_object))

/mob/proc/physical_obscured_can_use_topic(src_object)
	return STATUS_CLOSE

/mob/living/physical_obscured_can_use_topic(src_object)
	return shared_living_tgui_distance(src_object, viewcheck = FALSE)

/mob/living/silicon/physical_obscured_can_use_topic(src_object)
	return max(STATUS_UPDATE, shared_living_tgui_distance(src_object, viewcheck = FALSE)) // Silicons can always see.

/mob/living/silicon/ai/physical_obscured_can_use_topic(src_object)
	return STATUS_UPDATE // AIs are not physical.

 /**
  * tgui state: physical_state_bigscreen
  *
  * Short-circuits the default state to only check physical distance,
  * but allows updates out to the full size of the screen.
 **/

GLOBAL_DATUM_INIT(tgui_physical_state_bigscreen, /datum/tgui_state/physical_bigscreen, new)

/datum/tgui_state/physical_bigscreen/can_use_topic(src_object, mob/user)
	. = user.shared_tgui_interaction(src_object)
	if(. > STATUS_CLOSE)
		return min(., user.physical_can_use_tgui_topic_bigscreen(src_object))

/mob/proc/physical_can_use_tgui_topic_bigscreen(src_object)
	return STATUS_CLOSE

/mob/living/physical_can_use_tgui_topic_bigscreen(src_object)
	return shared_living_tgui_distance_bigscreen(src_object)

/mob/living/silicon/physical_can_use_tgui_topic_bigscreen(src_object)
	return max(STATUS_UPDATE, shared_living_tgui_distance_bigscreen(src_object)) // Silicons can always see.

/mob/living/silicon/ai/physical_can_use_tgui_topic(src_object)
	return STATUS_UPDATE // AIs are not physical.