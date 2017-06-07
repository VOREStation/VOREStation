/*
	This state checks that the src_object is on the user's glasses slot.
*/
/var/global/datum/topic_state/glasses_state/glasses_state = new()

/datum/topic_state/glasses_state/can_use_topic(var/src_object, var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.glasses == src_object)
			return user.shared_nano_interaction()

	return STATUS_CLOSE

/var/global/datum/topic_state/nif_state/nif_state = new()

/datum/topic_state/nif_state/can_use_topic(var/src_object, var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.nif && H.nif.stat == NIF_WORKING && src_object == H.nif)
			return user.shared_nano_interaction()

	return STATUS_CLOSE

/var/global/datum/topic_state/commlink_state/commlink_state = new()

/datum/topic_state/commlink_state/can_use_topic(var/src_object, var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.nif && H.nif.stat == NIF_WORKING && H.nif.comm == src_object)
			return user.shared_nano_interaction()

	return STATUS_CLOSE
