//Food
/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_bar)
	alt_titles = list("Barista")

	outfit_type = /decl/hierarchy/outfit/job/service/bartender

/datum/job/chef
	title = "Chef"
	flag = CHEF
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_kitchen)
	alt_titles = list("Cook")

	outfit_type = /decl/hierarchy/outfit/job/service/chef

/datum/job/hydro
	title = "Gardener"
	flag = BOTANIST
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_hydroponics)
	alt_titles = list("Hydroponicist")

	outfit_type = /decl/hierarchy/outfit/job/service/gardener

//Cargo
/datum/job/qm
	title = "Quartermaster"
	flag = QUARTERMASTER
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/cargo/head
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_qm, access_mining, access_mining_station)
	alt_titles = list("Supply Chief")

	ideal_character_age = 40

	outfit_type = /decl/hierarchy/outfit/job/cargo/qm

/datum/job/cargo_tech
	title = "Cargo Technician"
	flag = CARGOTECH
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/cargo
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)

	outfit_type = /decl/hierarchy/outfit/job/cargo/cargo_tech

/datum/job/mining
	title = "Shaft Miner"
	flag = MINER
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the quartermaster and the head of personnel"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/cargo
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting)
	alt_titles = list("Drill Technician","Prospector")

	outfit_type = /decl/hierarchy/outfit/job/cargo/mining

//Service
/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the head of personnel"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian
	access = list(access_janitor, access_maint_tunnels)
	minimal_access = list(access_janitor, access_maint_tunnels)
	alt_titles = list("Custodian", "Sanitation Technician")

	outfit_type = /decl/hierarchy/outfit/job/service/janitor

//More or less assistants
/datum/job/librarian
	title = "Librarian"
	flag = LIBRARIAN
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian
	access = list(access_library, access_maint_tunnels)
	minimal_access = list(access_library)
	alt_titles = list("Journalist", "Professor", "Historian", "Writer")

	outfit_type = /decl/hierarchy/outfit/job/librarian

//var/global/lawyer = 0//Checks for another lawyer //This changed clothes on 2nd lawyer, both IA get the same dreds.
/datum/job/lawyer
	title = "Internal Affairs Agent"
	flag = LAWYER
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 2
	spawn_positions = 2
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#515151"
	idtype = /obj/item/weapon/card/id/civilian
	economic_modifier = 7
	access = list(access_lawyer, access_sec_doors, access_maint_tunnels, access_heads)
	minimal_access = list(access_lawyer, access_sec_doors, access_heads)
	minimal_player_age = 7

	outfit_type = /decl/hierarchy/outfit/job/internal_affairs_agent