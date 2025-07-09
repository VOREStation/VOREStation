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
