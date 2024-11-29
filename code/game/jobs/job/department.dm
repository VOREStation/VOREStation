// A datum that holds information about a specific department.
// It is held inside, and managed by, the SSjob subsystem automatically,
// just define a department, and put that department's name in one or more job datums' departments list.

/datum/department
	var/name = "NOPE"		// Name used in UIs, and the index for the department assoc list in SSjob.
	var/short_name = "NO"	// Shorter name, used for things like external Topic() responses.
	var/color = "#000000"	// Color to use in UIs to represent this department.
	var/list/jobs = list()	// Assoc list. Key is the job title, and the value is a reference to the job datum. Populated by SSjob subsystem.
	var/list/primary_jobs = list() // Same as above, but only jobs with their 'primary' department are put here. Primary being the first department in their list.
	var/sorting_order = 0	// Used to sort departments, e.g. Command always being on top.
	var/visible = TRUE		// If false, it should not show up on things like the manifest or ID computer.
	var/assignable = TRUE	// Similar for above, but only for ID computers and such. Used for silicon department.
	var/centcom_only = FALSE

/datum/department/command
	name = DEPARTMENT_COMMAND
	short_name = "Heads"
	color = "#3333FF"
	sorting_order = 10

/datum/department/security
	name = DEPARTMENT_SECURITY
	short_name = "Sec"
	color = "#8E0000"
	sorting_order = 6

/datum/department/engineering
	name = DEPARTMENT_ENGINEERING
	short_name = "Eng"
	color = "#B27300"
	sorting_order = 5

/datum/department/medical
	name = DEPARTMENT_MEDICAL
	short_name = "Med"
	color = "#006600"
	sorting_order = 4

/datum/department/research
	name = DEPARTMENT_RESEARCH
	short_name = "Sci"
	color = "#A65BA6"
	sorting_order = 3

/datum/department/cargo
	name = DEPARTMENT_CARGO
	short_name = "Car"
	color = "#BB9040"
	sorting_order = 2

/datum/department/civilian
	name = DEPARTMENT_CIVILIAN
	short_name = "Civ"
	color = "#A32800"
	sorting_order = 1

// Mostly for if someone wanted to rewrite manifest code to be map-agnostic.
/datum/department/misc
	name = "Miscellaneous"
	short_name = "Misc"
	color = "#666666"
	sorting_order = -5
	assignable = FALSE

/datum/department/synthetic
	name = DEPARTMENT_SYNTHETIC
	short_name = "Bot"
	color = "#222222"
	sorting_order = -1
	assignable = FALSE

// This one isn't very useful since no real centcom jobs exist yet.
// Instead the jobs like ERT are hardcoded in.
/datum/department/centcom
	name = "Central Command"
	short_name = "Centcom"
	color = "#A52A2A"
	sorting_order = 20 // Above Command.
	centcom_only = TRUE
