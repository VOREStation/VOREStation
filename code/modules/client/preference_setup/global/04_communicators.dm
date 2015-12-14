/datum/category_item/player_setup_item/player_global/communicators
	name = "Communicators"
	sort_order = 4

/datum/category_item/player_setup_item/player_global/communicators/load_preferences(var/savefile/S)
	S["communicator_visibility"]	>> pref.communicator_visibility


/datum/category_item/player_setup_item/player_global/communicators/save_preferences(var/savefile/S)
	S["communicator_visibility"]	<< pref.communicator_visibility


/datum/category_item/player_setup_item/player_global/communicators/sanitize_preferences()
	pref.communicator_visibility	= sanitize_integer(pref.communicator_visibility, 0, 1, initial(pref.communicator_visibility))

/datum/category_item/player_setup_item/player_global/communicators/content(var/mob/user)
	. += "<b>Communicator Identity:</b><br>"
	. += "Visibility: <a href='?src=\ref[src];toggle_comm_visibility=1'><b>[(pref.communicator_visibility) ? "Yes" : "No"]</b></a><br>"

/datum/category_item/player_setup_item/player_global/communicators/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["toggle_comm_visibility"])
		if(CanUseTopic(user))
			pref.communicator_visibility = !pref.communicator_visibility
			return TOPIC_REFRESH

	return ..()
