/datum/job/secretary
	title = "Command Secretary"
	flag = BRIDGE
	department = "Command"
	head_position = 1
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 6
	spawn_positions = 4
	supervisors = "command staff"
	selection_color = "#2F2F7F"
	idtype = /obj/item/weapon/card/id/silver/secretary
	minimal_player_age = 5
	economic_modifier = 7

	access = list(access_heads, access_keycard_auth)
	minimal_access = list(access_heads, access_keycard_auth)

	outfit_type = /decl/hierarchy/outfit/job/secretary
	alt_titles = list(
		"Bridge Officer" = /decl/hierarchy/outfit/job/bridge_officer)