/datum/admins/proc/cancel_map_rotation()
	set category = "Server"
	set name = "Cancel Map Rotation"
	set desc = "Cancels the map rotation."

	if(!check_rights(R_ADMIN|R_DEBUG|R_SERVER))
		return

	var/response = tgui_alert(usr, "Are you sure that you want to cancel the map rotation?","Cancel Map Rotation",list("Yes","No"))

	if(response == "Yes")
		rotation_due = FALSE
		to_chat(usr, "<span class='filter_notice'>Map Rotation Cancelled.</span>")

/datum/admins/proc/override_map_rotation()
	set category = "Server"
	set name = "Override Map Rotation"
	set desc = "Override the map that will be compiled in the next rotation."

	if(!check_rights(R_ADMIN|R_DEBUG|R_SERVER))
		return

	var/map = null

	map = tgui_input_list(usr, "Select the map that you wish to override with.", "Override Map Rotation", map_rotation)

	if(!map)
		return

	set_map(map, TRUE)
	var/response = tgui_alert(usr, "Do you want the map rotation to trigger after this roundend?","Override Map Rotation",list("Trigger at roundend","Trigger at next due","Cancel"))

	if(response == "Trigger at next due")
		rotation_overridden = TRUE
		update_rotation_data()
		to_chat(usr, "<span class='filter_notice'>Map Rotation Overidden. New map: [map]. Map rotation will no longer start vote/choose automatically.</span>")
	else if(response == "Trigger at roundend")
		rotation_due = TRUE
		to_chat(usr, "<span class='filter_notice'>Map Rotation Overidden. New map: [map]. Map will rotate after this round.</span>")
	else


/datum/admins/proc/disable_map_rotation_override()
	set category = "Server"
	set name = "Disable Rotation Override"
	set desc = "Disable the map rotation override, making the automatic vote for example appear again."

	if(!check_rights(R_ADMIN|R_DEBUG|R_SERVER))
		return

	rotation_overridden = FALSE
	update_rotation_data()
	to_chat(usr, "<span class='filter_notice'>Map Rotation Override has been disabled. Automatic actions regarding the map rotation may appear again.</span>")