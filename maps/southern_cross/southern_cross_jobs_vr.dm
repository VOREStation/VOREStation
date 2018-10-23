var/const/PATHFINDER 		=(1<<13) //VOREStation Edit - Added Pathfinder

/obj/item/weapon/card/id/explorer/head/
	name = "identification card"
	desc = "A card which represents discovery of the unknown."
	icon_state = "greenGold"
	primary_color = rgb(47,189,0)
	secondary_color = rgb(127,223,95)

/obj/item/weapon/card/id/explorer/head/pathfinder
	assignment = "Pathfinder"
	rank = "Pathfinder"
	job_access_type = /datum/job/pathfinder

/datum/job/pathfinder
	title = "Pathfinder"
	flag = PATHFINDER
	department = "Science"
	department_flag = MEDSCI
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the research director"
	selection_color = "#AD6BAD"
	idtype = /obj/item/weapon/card/id/explorer/head/pathfinder
	economic_modifier = 7
	
	access = list(access_eva, access_maint_tunnels, access_external_airlocks, access_pilot, access_explorer, access_research, access_gateway)
	minimal_access = list(access_eva, access_pilot, access_explorer, access_research, access_gateway)
	outfit_type = /decl/hierarchy/outfit/job/pathfinder
