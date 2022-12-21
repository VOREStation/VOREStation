//
// "Off-duty" jobs are for people who want to do nothing and have earned it.
//

/datum/job/offduty_civilian
	title = "Off-duty Worker"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	departments = list(DEPARTMENT_OFFDUTY)
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#9b633e"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/assistant/worker
	job_description = "Off-duty crew has no responsibilities or authority and is just there to spend their well-deserved time off."
	pto_type = PTO_CIVILIAN
	economic_modifier = 2

/datum/job/offduty_cargo
	title = "Off-duty Cargo"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	departments = list(DEPARTMENT_OFFDUTY)
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#9b633e"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/assistant/cargo
	job_description = "Off-duty crew has no responsibilities or authority and is just there to spend their well-deserved time off."
	pto_type = PTO_CARGO
	economic_modifier = 2

/datum/job/offduty_engineering
	title = "Off-duty Engineer"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	departments = list(DEPARTMENT_OFFDUTY)
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#5B4D20"
	access = list(access_maint_tunnels, access_external_airlocks, access_construction)
	minimal_access = list(access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/assistant/engineer
	job_description = "Off-duty crew has no responsibilities or authority and is just there to spend their well-deserved time off."
	pto_type = PTO_ENGINEERING
	economic_modifier = 5

/datum/job/offduty_medical
	title = "Off-duty Medic"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	departments = list(DEPARTMENT_OFFDUTY)
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#013D3B"
	access = list(access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/assistant/medic
	job_description = "Off-duty crew has no responsibilities or authority and is just there to spend their well-deserved time off."
	pto_type = PTO_MEDICAL
	economic_modifier = 5

/datum/job/offduty_science
	title = "Off-duty Scientist"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	departments = list(DEPARTMENT_OFFDUTY)
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#633D63"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/assistant/scientist
	job_description = "Off-duty crew has no responsibilities or authority and is just there to spend their well-deserved time off."
	pto_type = PTO_SCIENCE
	economic_modifier = 5

/datum/job/offduty_security
	title = "Off-duty Officer"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	departments = list(DEPARTMENT_OFFDUTY)
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#601C1C"
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/assistant/officer
	job_description = "Off-duty crew has no responsibilities or authority and is just there to spend their well-deserved time off."
	pto_type = PTO_SECURITY
	economic_modifier = 4

/*
/datum/job/offduty_exploration
	title = "Off-duty Explorer"
	latejoin_only = TRUE
	timeoff_factor = -1
	total_positions = -1
	faction = "Station"
	departments = list(DEPARTMENT_OFFDUTY)
	supervisors = "nobody! Enjoy your time off"
	selection_color = "#999440"
	access = list(access_maint_tunnels, access_external_airlocks)
	minimal_access = list(access_maint_tunnels, access_external_airlocks)
	outfit_type = /decl/hierarchy/outfit/job/assistant/explorer
	job_description = "Off-duty crew has no responsibilities or authority and is just there to spend their well-deserved time off."
	pto_type = PTO_EXPLORATION
	economic_modifier = 5
*/
