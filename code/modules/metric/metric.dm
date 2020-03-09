// This is a global datum used to retrieve certain information about the round, such as activity of a department or a specific
// player.

/datum/metric
	var/list/departments = list(
		DEPARTMENT_COMMAND,
		DEPARTMENT_SECURITY,
		DEPARTMENT_ENGINEERING,
		DEPARTMENT_MEDICAL,
		DEPARTMENT_RESEARCH,
		DEPARTMENT_CARGO,
		DEPARTMENT_CIVILIAN,
		DEPARTMENT_SYNTHETIC
		)

