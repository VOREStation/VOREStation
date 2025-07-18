/datum/techweb_node/office_equip
	id = TECHWEB_NODE_OFFICE_EQUIP
	starting_node = TRUE
	display_name = "Office Equipment"
	description = "Nanotrasen's finest in ergonomic office tech, ensuring station admin stays productive and compliant with corporate policies — because even in space, paperwork never stops."
	design_ids = list(
		"communicator",
		"laser_pointer",
		"translator",
		"ear_translator",
		"walkpod",
		"juke_remote",
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
		"ordercomp",
		"supplycomp",
		"crewconsole",
		"emp_data",
		"comconsole",
		"idcardconsole",
		"jukebox",
		// PDAs
		"pda",
		"cart_basic",
		"cart_engineering",
		"cart_atmos",
		"cart_medical",
		"cart_chemistry",
		"cart_security",
		"cart_janitor",
		"cart_science",
		"cart_quartermaster",
		"cart_head",
		"cart_hop",
		"cart_hos",
		"cart_ce",
		"cart_cmo",
		"cart_rd",
		"cart_captain",
		// GPS
		"gps_gen",
		"gps_com",
		"gps_sec",
		"gps_med",
		"gps_eng",
		"gps_sci",
		"gps_exp",
		// "automated_announcement",
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


/datum/techweb_node/modular_computers
	id = TECHWEB_NODE_MODULAR_COMPUTER
	display_name = "Modular Computers"
	description = "Pieces and parts for modular computers; consoles, laptops, and tablets."
	prereq_ids = list(TECHWEB_NODE_CONSOLES)
	design_ids = list(
		"hdd_basic",
		"hdd_advanced",
		"hdd_super",
		"hdd_cluster",
		"hdd_small",
		"hdd_micro",
		"netcard_basic",
		"netcard_advanced",
		"netcard_wired",
		"bat_normal",
		"bat_advanced",
		"bat_super",
		"bat_ultra",
		"bat_nano",
		"bat_micro",
		"cpu_normal",
		"cpu_small",
		"pcpu_normal",
		"pcpu_small",
		"cardslot",
		"nanoprinter",
		"teslalink",
		"portadrive_basic",
		"portadrive_advanced",
		"portadrive_super",
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
		"fireworklauncher",
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


// Kitchen root node
/datum/techweb_node/cafeteria_equip
	id = TECHWEB_NODE_CAFETERIA_EQUIP
	starting_node = TRUE
	display_name = "Cafeteria Equipment"
	description = "When standard-issue tubed food no longer satisfies the station crew's appetite..."
	design_ids = list(
		"microwave_board",
		// "microwave",
		// "bowl",
		// "plate",
		// "oven_tray",
		// "servingtray",
		// "tongs",
		// "spoon",
		// "fork",
		// "kitchen_knife",
		// "plastic_spoon",
		// "plastic_fork",
		// "plastic_knife",
		// "shaker",
		// "drinking_glass",
		// "shot_glass",
		// "coffee_cartridge",
		// "coffeemaker",
		// "coffeepot",
		// "syrup_bottle",
		// "foodtray",
		// "restaurant_portal",
	)

/datum/techweb_node/food_proc
	id = TECHWEB_NODE_FOOD_PROC
	display_name = "Food Processing"
	description = "Top-tier kitchen appliances from Nanotrasen, designed to keep the crew well-fed and happy."
	prereq_ids = list(TECHWEB_NODE_CAFETERIA_EQUIP)
	design_ids = list(
		"deluxe microwave",
		"oven_board",
		"fryer_board",
		"cerealmaker_board",
		"candymachine_board",
		// "range",
		// "souppot",
		// "processor",
		// "gibber",
		// "monkey_recycler",
		// "reagentgrinder",
		// "microwave_engineering",
		// "smartfridge",
		// "dehydrator",
		// "sheetifier",
		// "fat_sucker",
		// "dish_drive",
		// "roastingstick",
	)
	research_costs = list(TECHWEB_POINT_TYPE_GENERIC = TECHWEB_TIER_2_POINTS)
	announce_channels = list(CHANNEL_SERVICE)
