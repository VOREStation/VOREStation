/datum/admin_secret_item/admin_secret/launch_shuttle
	name = "Launch a Shuttle"

/datum/admin_secret_item/admin_secret/launch_shuttle/can_execute(var/mob/user)
	if(!SSshuttles) return 0
	return ..()

/datum/admin_secret_item/admin_secret/launch_shuttle/execute(var/mob/user)
	. = ..()
	if(!.)
		return
	var/list/valid_shuttles = list()
	for (var/shuttle_tag in SSshuttles.shuttles)
		if (istype(SSshuttles.shuttles[shuttle_tag], /datum/shuttle/autodock))
			valid_shuttles += shuttle_tag

	var/shuttle_tag = tgui_input_list(user, "Which shuttle do you want to launch?", "Shuttle Choice", valid_shuttles)
	if (!shuttle_tag)
		return

	var/datum/shuttle/autodock/S = SSshuttles.shuttles[shuttle_tag]
	if (S.can_launch())
		S.launch(user)
		log_and_message_admins("launched the [shuttle_tag] shuttle", user)
	else
		tgui_alert_async(user, "The [shuttle_tag] shuttle cannot be launched at this time. It's probably busy.")
