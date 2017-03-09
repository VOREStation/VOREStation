// This is a global datum used to retrieve certain information about the round, such as activity of a department or a specific
// player.

/datum/metric
	var/list/departments = list(
		ROLE_COMMAND,
		ROLE_SECURITY,
		ROLE_ENGINEERING,
		ROLE_MEDICAL,
		ROLE_RESEARCH,
		ROLE_CARGO,
		ROLE_CIVILIAN,
		ROLE_SYNTHETIC
		)

