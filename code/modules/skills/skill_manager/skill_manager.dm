// This holds the visual UIs, state, and logic for interacting with the skill system.
// It is intended to be able to be used in many different places.
// The actual storage for skills is just an assoc list, so that it is easy to store.
// This holds the logic for skill allocating, as well as displaying the skills to users.
// It's in its own datum to allow for it to be used in many places to minimize code duplication.

/datum/skill_manager
	var/client/user = null				// The client using this UI.
	var/read_only = FALSE				// If true, the skill list cannot be altered.
	var/list/skill_list_ref = null		// Reference to the true list to display/modify.

	// browse() window IDs.
	var/main_window_id = "skill_manager"
	var/skill_info_window_id = "skill_info"
	var/skill_template_window_id = "skill_template"
	var/skill_template_preview_window_id = "skill_template_preview"

/datum/skill_manager/New(client/new_user, list/new_skill_list_ref)
	..()
	if(istype(new_user))
		user = new_user
	else if(ismob(new_user))
		var/mob/M = new_user
		user = M.client
	else
		crash_with("/datum/skill_manager/New() suppled with non-client or non-mob argument '[new_user]'.")
		qdel(src)

	if(islist(new_skill_list_ref))
		skill_list_ref = new_skill_list_ref
	else
		crash_with("/datum/skill_manager/New() suppled with improper list reference argument '[new_skill_list_ref]'.")
		qdel(src)

/datum/skill_manager/Destroy()
	close_all_windows()
	user = null
	skill_list_ref = null // Don't cut the list, since the list is shared with other things.

	return ..()


