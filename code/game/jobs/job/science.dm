/datum/job/rd
	title = "Research Director"
	flag = RD
	head_position = 1
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Colony Director"
	selection_color = "#AD6BAD"
	idtype = /obj/item/weapon/card/id/science/head
	req_admin_notify = 1
	economic_modifier = 15
	access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_eva) //VOREStation Edit
	minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
			            access_tox_storage, access_teleporter, access_sec_doors,
			            access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
			            access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_eva) //VOREStation Edit
	alt_titles = list("Research Supervisor")

	minimum_character_age = 25
	minimal_player_age = 14
	ideal_character_age = 50

	outfit_type = /decl/hierarchy/outfit/job/science/rd
	alt_titles = list("Research Supervisor")

/datum/job/scientist
	title = "Scientist"
	flag = SCIENTIST
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the research director"
	selection_color = "#633D63"
	idtype = /obj/item/weapon/card/id/science/scientist
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch)
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch)

	minimal_player_age = 14

	outfit_type = /decl/hierarchy/outfit/job/science/scientist
	alt_titles = list("Xenoarchaeologist", "Anomalist", "Phoron Researcher")

/datum/job/xenobiologist
	title = "Xenobiologist"
	flag = XENOBIOLOGIST
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 3
	spawn_positions = 2
	supervisors = "the research director"
	selection_color = "#633D63"
	idtype = /obj/item/weapon/card/id/science/xenobiologist
	economic_modifier = 7
	access = list(access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_hydroponics)
	minimal_access = list(access_research, access_xenobiology, access_hydroponics, access_tox_storage)

	minimal_player_age = 14

	outfit_type = /decl/hierarchy/outfit/job/science/xenobiologist
	alt_titles = list("Xenobotanist")

/datum/job/roboticist
	title = "Roboticist"
	flag = ROBOTICIST
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "research director"
	selection_color = "#633D63"
	idtype = /obj/item/weapon/card/id/science/roboticist
	economic_modifier = 5
	access = list(access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_player_age = 7

	outfit_type = /decl/hierarchy/outfit/job/science/roboticist
	alt_titles = list("Biomechanical Engineer","Mechatronic Engineer")
