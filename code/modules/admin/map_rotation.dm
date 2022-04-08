/datum/admins/proc/map_rotation_status()
	set category = "Server"
	set name = "Map Rotation Status"
	set desc = "The status of current map rotation, override and due."

	if(!check_rights(R_ADMIN|R_DEBUG|R_SERVER))
		return

	to_chat(usr, "<span class='filter_notice'><b>== Map Rotation Status ==</b></span>")
	to_chat(usr, "<span class='filter_notice'>Map currently in rotation: [get_map()]</span>")
	to_chat(usr, "<span class='filter_notice'>Allow map rotation: [config.allow_map_rotation]</span>")
	to_chat(usr, "<span class='filter_notice'>Rotation due: [rotation_due]</span>")
	to_chat(usr, "<span class='filter_notice'>Rotation overridden: [rotation_overridden]</span>")
	switch(config.map_rotation_mode)
		if(0)
			to_chat(usr, "<span class='filter_notice'>Rotation mode: Manual</span>")
		if(1)
			to_chat(usr, "<span class='filter_notice'>Rotation mode: Vote</span>")
		if(2)
			to_chat(usr, "<span class='filter_notice'>Rotation mode: Automatic</span>")
	if(config.rotation_schedule_mode == 0)
		to_chat(usr, "<span class='filter_notice'>Rotation schedule mode: Rotate every [config.rotate_after_round] rounds</span>")
	else
		to_chat(usr, "<span class='filter_notice'>Rotation schedule mode: Rotate every [config.rotate_after_day]</span>")


/datum/admins/proc/cancel_map_rotation()
	set category = "Server"
	set name = "Cancel Map Rotation"
	set desc = "Cancels the map rotation."

	if(!check_rights(R_ADMIN|R_DEBUG|R_SERVER))
		return

	var/response = tgui_alert(usr, "Are you sure that you want to cancel the map rotation?","Cancel Map Rotation",list("Yes","No"))

	if(response == "Yes")
		if(!rotation_due)
			to_chat(usr, "<span class='filter_notice'>There was no map rotation due.</span>")
			return

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

	if(!rotation_overridden)
		to_chat(usr, "<span class='filter_notice'>There was no map rotation override set.</span>")
		return

	rotation_overridden = FALSE
	update_rotation_data()
	to_chat(usr, "<span class='filter_notice'>Map Rotation Override has been disabled. Automatic actions regarding the map rotation may appear again.</span>")