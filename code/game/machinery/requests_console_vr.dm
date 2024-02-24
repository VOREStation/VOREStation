// Request Console Presets!  Make mapping 400% easier!
// By using these presets we can rename the departments easily.

//Request Console Department Types
// #define RC_ASSIST 1		//Request Assistance
// #define RC_SUPPLY 2		//Request Supplies
// #define RC_INFO   4		//Relay Info

/obj/machinery/requests_console/preset
	name = ""
	department = ""
	departmentType = ""
	announcementConsole = TRUE

// Departments
/obj/machinery/requests_console/preset/cargo
	name = "Cargo RC"
	department = "Cargo Bay"
	departmentType = RC_SUPPLY

/obj/machinery/requests_console/preset/security
	name = "Security RC"
	department = "Security"
	departmentType = RC_ASSIST

/obj/machinery/requests_console/preset/engineering
	name = "Engineering RC"
	department = "Engineering"
	departmentType = RC_ASSIST|RC_SUPPLY

/obj/machinery/requests_console/preset/atmos
	name = "Atmospherics RC"
	department = "Atmospherics"
	departmentType = RC_ASSIST|RC_SUPPLY

/obj/machinery/requests_console/preset/medical
	name = "Medical RC"
	department = "Medical Department"
	departmentType = RC_ASSIST|RC_SUPPLY

/obj/machinery/requests_console/preset/research
	name = "Research RC"
	department = "Research Department"
	departmentType = RC_ASSIST|RC_SUPPLY

/obj/machinery/requests_console/preset/janitor
	name = "Janitor RC"
	department = "Janitorial"
	departmentType = RC_ASSIST

/obj/machinery/requests_console/preset/bridge
	name = "Bridge RC"
	department = "Bridge"
	departmentType = RC_ASSIST|RC_INFO
	announcementConsole = 1

// Heads

/obj/machinery/requests_console/preset/ce
	name = "Chief Engineer RC"
	department = "Chief Engineer's Desk"
	departmentType = RC_ASSIST|RC_INFO
	announcementConsole = 1

/obj/machinery/requests_console/preset/cmo
	name = "Chief Medical Officer RC"
	department = "Chief Medical Officer's Desk"
	departmentType = RC_ASSIST|RC_INFO
	announcementConsole = 1

/obj/machinery/requests_console/preset/hos
	name = "Head of Security RC"
	department = "Head of Security's Desk"
	departmentType = RC_ASSIST|RC_INFO
	announcementConsole = 1

/obj/machinery/requests_console/preset/rd
	name = "Research Director RC"
	department = "Research Director's Desk"
	departmentType = RC_ASSIST|RC_INFO
	announcementConsole = 1

/obj/machinery/requests_console/preset/captain
	name = "Captain RC"
	department = "Captain's Desk"
	departmentType = RC_ASSIST|RC_INFO
	announcementConsole = 1

/obj/machinery/requests_console/preset/ai
	name = "AI RC"
	department = "AI"
	departmentType = RC_ASSIST|RC_INFO
