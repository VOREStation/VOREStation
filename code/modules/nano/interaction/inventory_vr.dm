/*
	This state checks that the src_object is on the user's glasses slot.
*/
/var/global/datum/topic_state/inventory_state/glasses_state = new()

/datum/topic_state/glasses_state/can_use_topic(var/src_object, var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.glasses == src_object)
			return user.shared_nano_interaction()

	return STATUS_CLOSE
