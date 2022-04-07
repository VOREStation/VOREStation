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

	fdel("data/map.txt")
	text2file(map, "data/map.txt")
	to_chat(usr, "<span class='filter_notice'>Map Rotation Overidden. New map: [map]</span>")

	var/response = tgui_alert(usr, "Do you want the map rotation to trigger after this roundend?","Override Map Rotation",list("Yes","No"))

	if(response == "No")
		return

	map_round_count = (config.rotate_after_round + 1)
	update_rotation_data()