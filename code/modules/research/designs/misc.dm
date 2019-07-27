/*
//
//	THIS IS GOING TO GET REAL DAMN BLOATED, SO LET'S TRY TO AVOID THAT IF POSSIBLE
//
*/

/datum/design/item/hud
	materials = list(DEFAULT_WALL_MATERIAL = 50, "glass" = 50)

/datum/design/item/hud/AssembleDesignName()
	..()
	name = "HUD glasses prototype ([item_name])"

/datum/design/item/hud/AssembleDesignDesc()
	desc = "Allows for the construction of \a [item_name] HUD glasses."

/datum/design/item/hud/health
	name = "health scanner"
	id = "health_hud"
	req_tech = list(TECH_BIO = 2, TECH_MAGNET = 3)
	build_path = /obj/item/clothing/glasses/hud/health
	sort_string = "GBAAA"

/datum/design/item/hud/security
	name = "security records"
	id = "security_hud"
	req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_path = /obj/item/clothing/glasses/hud/security
	sort_string = "GBAAB"

/datum/design/item/hud/mesons
	name = "optical meson scanner"
	id = "mesons"
	req_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/clothing/glasses/meson
	sort_string = "GBAAC"

/datum/design/item/hud/material
	name = "optical material scanner"
	id = "material"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/clothing/glasses/material
	sort_string = "GBAAD"

/datum/design/item/device/ano_scanner
	name = "Alden-Saraspova counter"
	id = "ano_scanner"
	desc = "Aids in triangulation of exotic particles."
	req_tech = list(TECH_BLUESPACE = 3, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 10000,"glass" = 5000)
	build_path = /obj/item/device/ano_scanner
	sort_string = "UAAAH"

/datum/design/item/light_replacer
	name = "Light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs."
	id = "light_replacer"
	req_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 1500, "silver" = 150, "glass" = 3000)
	build_path = /obj/item/device/lightreplacer
	sort_string = "VAAAH"

datum/design/item/laserpointer
	name = "laser pointer"
	desc = "Don't shine it in your eyes!"
	id = "laser_pointer"
	req_tech = list(TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 100, "glass" = 50)
	build_path = /obj/item/device/laser_pointer
	sort_string = "VAAAI"

/datum/design/item/paicard
	name = "'pAI', personal artificial intelligence device"
	id = "paicard"
	req_tech = list(TECH_DATA = 2)
	materials = list("glass" = 500, DEFAULT_WALL_MATERIAL = 500)
	build_path = /obj/item/device/paicard
	sort_string = "VABAI"

/datum/design/item/communicator
	name = "Communicator"
	id = "communicator"
	req_tech = list(TECH_DATA = 2, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 500)
	build_path = /obj/item/device/communicator
	sort_string = "VABAJ"

/datum/design/item/gps
	req_tech = list(TECH_MATERIAL = 2, TECH_DATA = 2, TECH_BLUESPACE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500)

/datum/design/item/gps/generic
	name = "Triangulating device design (GEN)"
	id = "gps_gen"
	build_path = /obj/item/device/gps
	sort_string = "VADAA"

/datum/design/item/gps/comand
	name = "Triangulating device design (COM)"
	id = "gps_com"
	build_path = /obj/item/device/gps/command
	sort_string = "VADAB"

/datum/design/item/gps/security
	name = "Triangulating device design (SEC)"
	id = "gps_sec"
	build_path = /obj/item/device/gps/security
	sort_string = "VADAC"

/datum/design/item/gps/medical
	name = "Triangulating device design (MED)"
	id = "gps_med"
	build_path = /obj/item/device/gps/medical
	sort_string = "VADAD"

/datum/design/item/gps/engineering
	name = "Triangulating device design (ENG)"
	id = "gps_eng"
	build_path = /obj/item/device/gps/engineering
	sort_string = "VADAE"

/datum/design/item/gps/science
	name = "Triangulating device design (SCI)"
	id = "gps_sci"
	build_path = /obj/item/device/gps/science
	sort_string = "VADAF"

/datum/design/item/gps/mining
	name = "Triangulating device design (MINE)"
	id = "gps_mine"
	build_path = /obj/item/device/gps/mining
	sort_string = "VADAG"

/datum/design/item/gps/explorer
	name = "Triangulating device design (EXP)"
	id = "gps_exp"
	build_path = /obj/item/device/gps/explorer
	sort_string = "VADAH"

/datum/design/item/beacon
	name = "Bluespace tracking beacon design"
	id = "beacon"
	req_tech = list(TECH_BLUESPACE = 1)
	materials = list (DEFAULT_WALL_MATERIAL = 20, "glass" = 10)
	build_path = /obj/item/device/radio/beacon
	sort_string = "VADBA"

/datum/design/item/beacon_locator
	name = "Beacon tracking pinpointer"
	desc = "Used to scan and locate signals on a particular frequency."
	id = "beacon_locator"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1000,"glass" = 500)
	build_path = /obj/item/device/beacon_locator
	sort_string = "VADBB"

/datum/design/item/bag_holding
	name = "'Bag of Holding', an infinite capacity bag prototype"
	desc = "Using localized pockets of bluespace this bag prototype offers incredible storage capacity with the contents weighting nothing. It's a shame the bag itself is pretty heavy."
	id = "bag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list("gold" = 3000, "diamond" = 1500, "uranium" = 250)
	build_path = /obj/item/weapon/storage/backpack/holding
	sort_string = "VAEAA"

/datum/design/item/dufflebag_holding
	name = "'DuffleBag of Holding', an infinite capacity dufflebag prototype"
	desc = "A minaturized prototype of the popular Bag of Holding, the Dufflebag of Holding is, functionally, identical to the bag of holding, but comes in a more stylish and compact form."
	id = "dufflebag_holding"
	req_tech = list(TECH_BLUESPACE = 4, TECH_MATERIAL = 6)
	materials = list("gold" = 3000, "diamond" = 1500, "uranium" = 250)
	build_path = /obj/item/weapon/storage/backpack/holding/duffle
	sort_string = "VAEAB"

/datum/design/item/experimental_welder
	name = "Experimental welding tool"
	desc = "A welding tool that generate fuel for itself."
	id = "expwelder"
	req_tech = list(TECH_ENGINEERING = 4, TECH_PHORON = 3, TECH_MATERIAL = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 70, "glass" = 120, "phoron" = 100)
	build_path = /obj/item/weapon/weldingtool/experimental
	sort_string = "VASCA"

/datum/design/item/hand_drill
	name = "Hand drill"
	desc = "A simple powered hand drill."
	id = "handdrill"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 300, "silver" = 100)
	build_path = /obj/item/weapon/tool/screwdriver/power
	sort_string = "VASDA"

/datum/design/item/jaws_life
	name = "Jaws of life"
	desc = "A set of jaws of life, compressed through the magic of science."
	id = "jawslife"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 300, "silver" = 100)
	build_path = /obj/item/weapon/tool/crowbar/power
	sort_string = "VASEA"

/datum/design/item/device/t_scanner_upg
	name = "Upgraded T-ray Scanner"
	desc = "An upgraded version of the terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	id = "upgradedtscanner"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 4, TECH_MATERIAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "phoron" = 150)
	build_path = /obj/item/device/t_scanner/upgraded
	sort_string = "VASSA"

/datum/design/item/device/t_scanner_adv
	name = "Advanced T-ray Scanner"
	desc = "An advanced version of the terahertz-ray emitter and scanner used to detect underfloor objects such as cables and pipes."
	id = "advancedtscanner"
	req_tech = list(TECH_MAGNET = 6, TECH_ENGINEERING = 6, TECH_MATERIAL = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 1250, "phoron" = 500, "silver" = 50)
	build_path = /obj/item/device/t_scanner/advanced
	sort_string = "VASSB"

/datum/design/item/translator
	name = "handheld translator"
	id = "translator"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 3000)
	build_path = /obj/item/device/universal_translator
	sort_string = "HABQA"

/datum/design/item/ear_translator
	name = "earpiece translator"
	id = "ear_translator"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5)	//It's been hella miniaturized.
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000, "gold" = 1000)
	build_path = /obj/item/device/universal_translator/ear
	sort_string = "HABQB"

/datum/design/item/xenoarch_multi_tool
	name = "xenoarcheology multitool"
	id = "xenoarch_multitool"
	req_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3, TECH_BLUESPACE = 3)
	build_path = /obj/item/device/xenoarch_multi_tool
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 1000, "uranium" = 500, "phoron" = 500)
	sort_string = "HABQC"

/datum/design/item/excavationdrill
	name = "Excavation Drill"
	id = "excavationdrill"
	req_tech = list(TECH_MATERIAL = 3, TECH_POWER = 2, TECH_ENGINEERING = 2, TECH_BLUESPACE = 3)
	build_type = PROTOLATHE
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000)
	build_path = /obj/item/weapon/pickaxe/excavationdrill
	sort_string = "HABQD"
