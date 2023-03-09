// Pilots

var/const/EXPLORER 			=(1<<14)

var/const/access_explorer = 43

/datum/access/explorer
	id = access_explorer
	desc = "Explorer"
	region = ACCESS_REGION_GENERAL

//Cynosure Jobs

/datum/department/planetside
	name = DEPARTMENT_PLANET
	color = "#555555"
	sorting_order = 2 // Same as cargo in importance.

/datum/job/explorer
	title = "Explorer"
	flag = EXPLORER
	departments = list(DEPARTMENT_RESEARCH, DEPARTMENT_PLANET)
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Research Director"
	selection_color =  "#633D63"
	economic_modifier = 4
	access = list(access_explorer, access_research)
	minimal_access = list(access_explorer, access_research)

	outfit_type = /decl/hierarchy/outfit/job/explorer2
	job_description = "An Explorer searches for interesting things on the surface of Sif, and returns them to the station."

	alt_titles = list(
		"Pilot" = /decl/hierarchy/outfit/job/pilot)

/datum/job/rd
    access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
                        access_tox_storage, access_teleporter, access_sec_doors,
                        access_research, access_robotics, access_xenobiology, access_xenofauna, access_ai_upload, access_tech_storage,
                        access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch,
                        access_network, access_maint_tunnels, access_explorer, access_eva, access_external_airlocks)
    minimal_access = list(access_rd, access_heads, access_tox, access_genetics, access_morgue,
                        access_tox_storage, access_teleporter, access_sec_doors,
                        access_research, access_robotics, access_xenobiology, access_xenofauna, access_ai_upload, access_tech_storage,
                        access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch,
                        access_network, access_maint_tunnels, access_explorer, access_eva, access_external_airlocks)
			
/*
	alt_titles = list(
		"Explorer Technician" = /decl/hierarchy/outfit/job/explorer2/technician,
		"Explorer Medic" = /decl/hierarchy/outfit/job/explorer2/medic)
*/
