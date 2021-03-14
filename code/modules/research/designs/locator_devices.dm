// GPS

/datum/design/item/gps
	req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500, MAT_COPPER = 5)

/datum/design/item/gps/AssembleDesignName()
	..()
	name = "Triangulating device design ([name])"

/datum/design/item/gps/generic
	name = "GEN"
	id = "gps_gen"
	build_path = /obj/item/device/gps
	sort_string = "DAAAA"

/datum/design/item/gps/command
	name = "COM"
	id = "gps_com"
	build_path = /obj/item/device/gps/command
	sort_string = "DAAAB"

/datum/design/item/gps/security
	name = "SEC"
	id = "gps_sec"
	build_path = /obj/item/device/gps/security
	sort_string = "DAAAC"

/datum/design/item/gps/medical
	name = "MED"
	id = "gps_med"
	build_path = /obj/item/device/gps/medical
	sort_string = "DAAAD"

/datum/design/item/gps/engineering
	name = "ENG"
	id = "gps_eng"
	build_path = /obj/item/device/gps/engineering
	sort_string = "DAAAE"

/datum/design/item/gps/science
	name = "SCI"
	id = "gps_sci"
	build_path = /obj/item/device/gps/science
	sort_string = "DAAAF"

/datum/design/item/gps/mining
	name = "MINE"
	id = "gps_mine"
	build_path = /obj/item/device/gps/mining
	sort_string = "DAAAG"

/datum/design/item/gps/explorer
	name = "EXP"
	id = "gps_exp"
	build_path = /obj/item/device/gps/explorer
	sort_string = "DAAAH"

// Other locators

/datum/design/item/locator/AssembleDesignName()
	..()
	name = "Locator device design ([name])"

/datum/design/item/locator/beacon_locator
	name = "Tracking beacon pinpointer"
	desc = "Used to scan and locate signals on a particular frequency."
	id = "beacon_locator"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1000,"glass" = 500, MAT_COPPER = 150)
	build_path = /obj/item/device/beacon_locator
	sort_string = "DBAAA"

/datum/design/item/locator/beacon
	name = "Bluespace tracking beacon"
	id = "beacon"
	req_tech = list(TECH_BLUESPACE = 1)
	materials = list (DEFAULT_WALL_MATERIAL = 20, "glass" = 10, MAT_COPPER = 5)
	build_path = /obj/item/device/radio/beacon
	sort_string = "DBABA"