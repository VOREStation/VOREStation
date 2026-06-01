/**
 * tgui state: camera_view
 *
 * In addition to default checks, allows AI to interact and has a cutoff after it leaves view range.
 * living adjacent user.
 **/

GLOBAL_DATUM_INIT(tgui_camera_view, /datum/tgui_state/camera_view, new)

/datum/tgui_state/camera_view/can_use_topic(src_object, mob/user)
	. = user.shared_tgui_interaction(src_object)
	if(. > STATUS_CLOSE)
		return min(., user.camera_view_can_use_topic(src_object))

/mob/proc/camera_view_can_use_topic(src_object)
	return STATUS_CLOSE

/mob/living/camera_view_can_use_topic(src_object)
	return shared_living_tgui_distance(src_object, viewcheck = TRUE)

/mob/living/silicon/camera_view_can_use_topic(src_object)
	return shared_living_tgui_distance(src_object, viewcheck = TRUE)

/mob/living/silicon/ai/camera_view_can_use_topic(src_object)
	return STATUS_INTERACTIVE
