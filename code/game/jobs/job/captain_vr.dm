/datum/job/bridge_officer
	title = "Bridge Officer"
	flag = BRIDGE
	department = "Command"
	head_position = 1
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "command staff"
	selection_color = "#2F2F7F"
	idtype = /obj/item/weapon/card/id/silver/secretary
	minimal_player_age = 7
	economic_modifier = 7
	minimum_character_age = 20
	ideal_character_age = 25

	access = list(access_heads, access_keycard_auth, access_gateway, access_eva, access_teleporter)
	minimal_access = list(access_heads, access_keycard_auth, access_gateway, access_eva, access_teleporter)

	outfit_type = /decl/hierarchy/outfit/job/bridge_officer