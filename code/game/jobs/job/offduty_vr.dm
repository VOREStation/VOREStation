//
// "Off-duty" jobs are for people who want to do nothing and have earned it.
//

/datum/job/offduty_civilian
	title = "Off-Duty Worker"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	department = "Civilian"
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#9b633e"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/assistant

/datum/job/offduty_cargo
	title = "Off-duty Cargo"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	department = "Cargo"
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#9b633e"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/assistant

/datum/job/offduty_engineering
	title = "Off-duty Engineer"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	department = "Engineering"
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#5B4D20"
	access = list(access_maint_tunnels, access_external_airlocks, access_construction)
	minimal_access = list(access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/assistant

/datum/job/offduty_medical
	title = "Off-duty Medic"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	department = "Medical"
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#013D3B"
	access = list(access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/assistant

/datum/job/offduty_science
	title = "Off-duty Scientist"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	department = "Science"
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#633D63"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/assistant

/datum/job/offduty_security
	title = "Off-duty Officer"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	department = "Security"
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#601C1C"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/assistant
