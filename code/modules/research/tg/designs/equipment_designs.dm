/datum/design_techweb/bluespace_bracelet
	name = "Size Standardization Bracelet"
	id = "bluespacebracelet"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/clothing/gloves/bluespace
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/deluxe_bluespace_bracelet
	name = "Deluxe Size Standardization Bracelet"
	id = "deluxebluespacebracelet"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_SILVER = 1000)
	build_path = /obj/item/clothing/gloves/bluespace/deluxe
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/bluespace_collar
	name = "Bluespace Collar"
	id = "bluespacecollar"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/clothing/accessory/collar/shock/bluespace
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/hyperfiber_jumpsuit
	name = "HYPER jumpsuit"
	id = "hfjumpsuit"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000)
	build_path = /obj/item/clothing/under/hyperfiber
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/bluespace_jumpsuit
	name = "Bluespace Jumpsuit"
	id = "bluespace_jumpsuit"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/clothing/under/hyperfiber/bluespace
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ore_holding
	name = "Mining Satchel of Holding"
	desc = "For the most tenacious miners, a bag with incomprehensible depth!"
	id = "ore_holding"
	// req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 1000, MAT_DIAMOND = 500, MAT_URANIUM = 250) // Less expensive since it can only hold ores
	build_path = /obj/item/storage/bag/ore/holding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/sheet_holding
	name = "Sheet Snatcher of Holding"
	desc = "For those who really hate walking up and down the stairs more than once!"
	id = "sheet_holding"
	// req_tech = list(TECH_BLUESPACE = 1, TECH_MATERIAL = 2)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 300, MAT_DIAMOND = 200, MAT_URANIUM = 150) // Even less expensive because it has a more limited use
	build_path = /obj/item/storage/bag/sheetsnatcher/holding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/bag_holding
	name = "Bag of Holding"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	id = "bag_holding"
	// req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 1500, MAT_URANIUM = 250)
	build_path = /obj/item/storage/backpack/holding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/dufflebag_holding
	name = "DuffleBag of Holding"
	desc = "A minaturized prototype of the popular Bag of Holding, the Dufflebag of Holding is, functionally, identical to the bag of holding, but comes in a more stylish and compact form."
	id = "dufflebag_holding"
	// req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 1500, MAT_URANIUM = 250)
	build_path = /obj/item/storage/backpack/holding/duffle
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/trashbag_holding
	name = "Trashbag of Holding"
	desc = "Considerably more utilitarian than the Bag of Holding, the Trashbag of Holding is a janitor's best friend."
	id = "trashbag_holding"
	// req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 5)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 2000, MAT_DIAMOND = 1000, MAT_URANIUM = 250)
	build_path = /obj/item/storage/bag/trash/holding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SERVICE

/datum/design_techweb/pouch_holding
	name = "Pouch of Holding"
	desc = "Somehow compresses the storage of a backpack into a pouch-sized container!"
	id = "pouch_holding"
	// req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 5)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 2000, MAT_URANIUM = 250)
	build_path = /obj/item/storage/pouch/holding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE


/datum/design_techweb/belt_holding_med
	name = "Medical Belt of Holding"
	desc = "A belt that uses localized bluespace pockets to hold more items than expected!"
	id = "belt_holding_med"
	// req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 2000, MAT_TITANIUM = 500)
	build_path = /obj/item/storage/belt/medical/holding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/belt_holding_utility
	name = "Tool-Belt of Holding"
	desc = "A belt that uses localized bluespace pockets to hold more items than expected!"
	id = "belt_holding_utility"
	// req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 3000, MAT_DIAMOND = 2000, MAT_TITANIUM = 500)
	build_path = /obj/item/storage/belt/utility/holding
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_BLUESPACE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

// HUDs
/datum/design_techweb/hud
	materials = list(MAT_STEEL = 50, MAT_GLASS = 50)
	build_type = PROTOLATHE

/datum/design_techweb/hud/New()
	..()
	name = "HUD glasses prototype ([initial(name)])"

/datum/design_techweb/hud/health
	name = "health scanner"
	id = "health_hud"
	// req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MEDICAL
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/hud/security
	name = "security records"
	id = "security_hud"
	// req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SECURITY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/hud/janitor
	name = "contaminant detector"
	id = "janitor_hud"
	// req_tech = list(TECH_MAGNET = 2)
	build_path = /obj/item/clothing/glasses/hud/janitor
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_SERVICE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SERVICE | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/hud/mesons
	name = "optical meson scanner"
	id = "mesons"
	// req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/clothing/glasses/meson
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/hud/material
	name = "optical material scanner"
	id = "material"
	// req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/clothing/glasses/material
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/hud/graviton_visor
	name = "graviton visor"
	id = "graviton_goggles"
	// req_tech = list(TECH_MAGNET = 5, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3, TECH_PHORON = 3, TECH_ARCANE = 1)
	materials = list(MAT_PLASTEEL = 2000, MAT_GLASS = 3000, MAT_PHORON = 1500, MAT_DIAMOND = 500)
	build_path = /obj/item/clothing/glasses/graviton
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_ENGINEERING
	)
	departmental_flags = DEPARTMENT_BITFLAG_ENGINEERING | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/hud/omni
	name = "AR glasses"
	id = "omnihud"
	// req_tech = list(TECH_MAGNET = 4, TECH_COMBAT = 3, TECH_BIO = 3)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000)
	build_path = /obj/item/clothing/glasses/omnihud
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

// GPS
/datum/design_techweb/gps
	// req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 500)
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)

/datum/design_techweb/gps/generic
	name = "GPS - GEN"
	id = "gps_gen"
	build_path = /obj/item/gps
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/gps/command
	name = "GPS - COM"
	id = "gps_com"
	build_path = /obj/item/gps/command
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_COMMAND

/datum/design_techweb/gps/security
	name = "GPS - SEC"
	id = "gps_sec"
	build_path = /obj/item/gps/security
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_SECURITY

/datum/design_techweb/gps/medical
	name = "GPS - MED"
	id = "gps_med"
	build_path = /obj/item/gps/medical
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_MEDICAL

/datum/design_techweb/gps/engineering
	name = "GPS - ENG"
	id = "gps_eng"
	build_path = /obj/item/gps/engineering
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/gps/science
	name = "GPS - SCI"
	id = "gps_sci"
	build_path = /obj/item/gps/science
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/gps/mining
	name = "GPS - MINE"
	id = "gps_mine"
	build_path = /obj/item/gps/mining
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/gps/explorer
	name = "GPS - EXP"
	id = "gps_exp"
	build_path = /obj/item/gps/explorer
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/beacon_locator
	name = "Tracking beacon pinpointer"
	desc = "Used to scan and locate signals on a particular frequency."
	id = "beacon_locator"
	// req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 1000,MAT_GLASS = 500)
	build_path = /obj/item/beacon_locator
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/beacon
	name = "Bluespace tracking beacon"
	id = "beacon"
	// req_tech = list(TECH_BLUESPACE = 1)
	build_type = PROTOLATHE
	materials = list (MAT_STEEL = 20, MAT_GLASS = 10)
	build_path = /obj/item/radio/beacon
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ear_translator
	name = "earpiece translator"
	id = "ear_translator"
	// req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)	//It's been hella miniaturized.
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000, MAT_GOLD = 1000)
	build_path = /obj/item/universal_translator/ear
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)

/datum/design_techweb/walkpod
	name = "PodZu Music Player"
	id = "walkpod"
	// req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000)
	build_path = /obj/item/walkpod
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)

/datum/design_techweb/juke_remote
	name = "BoomTown Cordless Speaker"
	id = "juke_remote"
	// req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 4, TECH_BLUESPACE = 1)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000, MAT_URANIUM = 2000)
	build_path = /obj/item/juke_remote
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)

/datum/design_techweb/translocator
	name = "Personal translocator"
	id = "translocator"
	// req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_ILLEGAL = 6)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_URANIUM = 4000, MAT_DIAMOND = 2000)
	build_path = /obj/item/perfect_tele
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/translocator
	name = "Mini translocator"
	id = "mini_translocator"
	// req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_ILLEGAL = 6)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000, MAT_PHORON = 2000)
	build_path = /obj/item/perfect_tele/one_beacon
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)

/datum/design_techweb/bluespace_crystal
	name = "Artificial Bluespace Crystal"
	id = "bluespace_crystal"
	// req_tech = list(TECH_BLUESPACE = 3, TECH_PHORON = 4)
	build_type = PROTOLATHE
	materials = list(MAT_DIAMOND = 1500, MAT_PHORON = 1500)
	build_path = /obj/item/bluespace_crystal/artificial
	category = list(
		RND_CATEGORY_EQUIPMENT + RND_SUBCATEGORY_EQUIPMENT_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
