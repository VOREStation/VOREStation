GLOBAL_DATUM_INIT(tgui_glasses_state, /datum/tgui_state/glasses_state, new)
/datum/tgui_state/glasses_state/can_use_topic(var/src_object, var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.glasses == src_object)
			return user.shared_tgui_interaction()

	return STATUS_CLOSE

GLOBAL_DATUM_INIT(tgui_nif_state, /datum/tgui_state/nif_state, new)
/datum/tgui_state/nif_state/can_use_topic(var/src_object, var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.nif && H.nif.stat == NIF_WORKING && src_object == H.nif)
			return user.shared_tgui_interaction()

	return STATUS_CLOSE

// This is slightly distinct from the module state, as it wants to update if not working
GLOBAL_DATUM_INIT(tgui_nif_main_state, /datum/tgui_state/nif_main_state, new)
/datum/tgui_state/nif_main_state/can_use_topic(var/src_object, var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(!H.nif || src_object != H.nif)
			return STATUS_CLOSE

		if(H.nif.stat == NIF_WORKING)
			return user.shared_tgui_interaction()
		else
			return min(user.shared_tgui_interaction(), STATUS_UPDATE)

	return STATUS_CLOSE

GLOBAL_DATUM_INIT(tgui_commlink_state, /datum/tgui_state/commlink_state, new)
/datum/tgui_state/commlink_state/can_use_topic(var/src_object, var/mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.nif && H.nif.stat == NIF_WORKING && H.nif.comm == src_object)
			return user.shared_tgui_interaction()

	return STATUS_CLOSE
