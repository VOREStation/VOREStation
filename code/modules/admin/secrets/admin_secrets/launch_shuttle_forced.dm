/datum/admin_secret_item/admin_secret/launch_shuttle_forced
	name = "Launch a Shuttle (Forced)"

/datum/admin_secret_item/admin_secret/launch_shuttle_forced/can_execute(var/mob/user)
	if(!SSshuttles) return 0
	return ..()

/datum/admin_secret_item/admin_secret/launch_shuttle_forced/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/list/valid_shuttles = list()
	for (var/shuttle_tag in SSshuttles.shuttles)
		if (istype(SSshuttles.shuttles[shuttle_tag], /datum/shuttle/autodock))
			valid_shuttles += shuttle_tag

	var/shuttle_tag = tgui_input_list(user, "Which shuttle's launch do you want to force?", "Shuttle Choice", valid_shuttles)
	if (!shuttle_tag)
		return

	var/datum/shuttle/autodock/S = SSshuttles.shuttles[shuttle_tag]
	if (S.can_force())
		S.force_launch(user)
		log_and_message_admins("forced the [shuttle_tag] shuttle", user)
	else
		tgui_alert_async(user, "The [shuttle_tag] shuttle launch cannot be forced at this time. It's busy, or hasn't been launched yet.")
