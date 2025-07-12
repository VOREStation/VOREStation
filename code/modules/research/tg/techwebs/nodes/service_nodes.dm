/datum/techweb_node/office_equip
	id = TECHWEB_NODE_OFFICE_EQUIP
	starting_node = TRUE
	display_name = "Office Equipment"
	description = "Nanotrasen's finest in ergonomic office tech, ensuring station admin stays productive and compliant with corporate policies — because even in space, paperwork never stops."
	design_ids = list(
		"communicator",
		// "fax",
		// "sec_pen",
		// "handlabel",
		// "roll",
		// "universal_scanner",
		// "desttagger",
		// "packagewrap",
		// "sticky_tape",
		// "toner_large",
		// "toner",
		// "boxcutter",
		// "bounced_radio",
		// "radio_headset",
		// "earmuffs",
		// "recorder",
		// "tape",
		// "toy_balloon",
		// "pet_carrier",
		// "chisel",
		// "spraycan",
		// "camera_film",
		// "camera",
		// "razor",
		// "bucket",
		// "mop",
		// "pushbroom",
		// "normtrash",
		// "wirebrush",
		// "flashlight",
		// "water_balloon",
		// "ticket_machine",
		// "radio_entertainment",
		// "photocopier",
	)

/datum/techweb_node/sanitation
	id = TECHWEB_NODE_SANITATION
	display_name = "Advanced Sanitation Technology"
	description = "Nanotrasen's latest in janitorial tech, making sure the station stays spotless and bear-free."
	prereq_ids = list(TECHWEB_NODE_OFFICE_EQUIP)
	design_ids = list(
		"advmop",
		"light_replacer",
		"spraybottle",
		"beartrap",
		// "buffer",
		// "vacuum",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	discount_experiments = list(/datum/experiment/scanning/random/janitor_trash = TECHWEB_TIER_2_POINTS)
	announce_channels = list(CHANNEL_SERVICE)

/datum/techweb_node/consoles
	id = TECHWEB_NODE_CONSOLES
	display_name = "Civilian Consoles"
	description = "User-friendly consoles for non-technical crew members, enhancing communication and access to essential station information."
	prereq_ids = list(TECHWEB_NODE_OFFICE_EQUIP)
	design_ids = list(
		"med_data",
		// "comconsole",
		// "automated_announcement",
		// "cargo",
		// "cargorequest",
		// "crewconsole",
		// "bankmachine",
		// "account_console",
		// "idcard",
		// "c-reader",
		// "libraryconsole",
		// "libraryscanner",
		// "bookbinder",
		// "barcode_scanner",
		// "vendor",
		// "custom_vendor_refill",
		// "bounty_pad_control",
		// "bounty_pad",
		// "digital_clock_frame",
		// "telescreen_research",
		// "telescreen_ordnance",
		// "telescreen_interrogation",
		// "telescreen_prison",
		// "telescreen_bar",
		// "telescreen_entertainment",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_1_POINTS)
	announce_channels = list(CHANNEL_SERVICE)

/datum/techweb_node/gaming
	id = TECHWEB_NODE_GAMING
	display_name = "Gaming"
	description = "For the slackers on the station."
	prereq_ids = list(TECHWEB_NODE_CONSOLES)
	design_ids = list(
		"arcademachine",
		"oriontrail",
		"clawmachine",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	discount_experiments = list(/datum/experiment/physical/arcade_winner = TECHWEB_TIER_2_POINTS)

/datum/techweb_node/fireworks
	id = TECHWEB_NODE_FIREWORKS
	display_name = "Fireworks"
	description = "Pretty explosives! They change the weather!"
	prereq_ids = list(TECHWEB_NODE_PARTS_ADV)
	design_ids = list(
		"fireworkaesthetic",
		"fireworkaestheticconfig",
		"fireworkclearsky",
		"fireworkcloudy",
		"fireworkfog",
		"fireworkrain",
		"fireworkstorm",
		"fireworklightsnow",
		"fireworksnow",
		"fireworkblizzard",
		"fireworkhail",
		"fireworkconfetti",
		"fireworkfallout",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_3_POINTS)
	announce_channels = list(CHANNEL_COMMON)
