/*
	O - rigsuit stuff
		OA - rigs themselves
		OB - rig modules
			OBAA - general purpose
			OBAB - mining
			OBAC - medical
			OBAD - sec/combat
			OBAE - engineering/maintenance/cleaning
*/


////// RIGSuit Stuff
/*
/datum/design/item/rig
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 6000, "uranium" = 4000)

/datum/design/item/rig/AssembleDesignName()
	..()
	name = "hardsuit prototype ([name])"

/datum/design/item/rig/eva
	name = "eva hardsuit (empty)"
	id = "eva_hardsuit"
	build_path = /obj/item/weapon/rig/eva
	sort_string = "OAAAA"

/datum/design/item/rig/mining
	name = "industrial hardsuit (empty)"
	id = "ind_hardsuit"
	build_path = /obj/item/weapon/rig/industrial
	sort_string = "OAAAB"

/datum/design/item/rig/research
	name = "ami hardsuit (empty)"
	id = "ami_hardsuit"
	build_path = /obj/item/weapon/rig/hazmat
	sort_string = "OAAAC"

/datum/design/item/rig/medical
	name = "medical hardsuit (empty)"
	id = "med_hardsuit"
	build_path = /obj/item/weapon/rig/medical
	sort_string = "OAAAD"
*/

/datum/design/item/rig_module
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 4000, "uranium" = 2000)

/datum/design/item/rig_module/AssembleDesignName()
	..()
	name = "rig module prototype ([name])"

/datum/design/item/rig_module/maneuvering_jets
	name = "maneuvering jets"
	id = "rigmod_maneuveringjets"
	build_path = /obj/item/rig_module/maneuvering_jets
	sort_string = "OBAAA"

/datum/design/item/rig_module/sprinter
	name = "sprinter"
	id = "rigmod_sprinter"
	build_path = /obj/item/rig_module/sprinter
	sort_string = "OBAAB"

/datum/design/item/rig_module/plasma_cutter
	name = "plasma cutter"
	id = "rigmod_plasmacutter"
	build_path = /obj/item/rig_module/device/plasmacutter
	sort_string = "OBABA"

/datum/design/item/rig_module/diamond_drill
	name = "diamond drill"
	id = "rigmod_diamonddrill"
	build_path = /obj/item/rig_module/device/drill
	sort_string = "OBABB"

/datum/design/item/rig_module/anomaly_scanner
	name = "anomaly scanner"
	id = "rigmod_anomalyscanner"
	build_path = /obj/item/rig_module/device/anomaly_scanner
	sort_string = "OBABC"

/datum/design/item/rig_module/orescanner
	name = "ore scanner"
	id = "rigmod_orescanner"
	build_path = /obj/item/rig_module/device/orescanner
	sort_string = "OBABD"

/datum/design/item/rig_module/rescue_pharm
	name = "rescue pharm"
	id = "rigmod_rescue_pharm"
	build_path = /obj/item/rig_module/rescue_pharm
	sort_string = "OBACA"

/datum/design/item/rig_module/lasercannon
	name = "laser cannon"
	id = "rigmod_lasercannon"
	build_path = /obj/item/rig_module/mounted
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 4000, "uranium" = 2000, "diamond" = 2000)
	sort_string = "OBADA"

/datum/design/item/rig_module/egun
	name = "energy gun"
	id = "rigmod_egun"
	build_path = /obj/item/rig_module/mounted/egun
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 4000, "uranium" = 2000, "diamond" = 1000)
	sort_string = "OBADB"

/datum/design/item/rig_module/taser
	name = "taser"
	id = "rigmod_taser"
	build_path = /obj/item/rig_module/mounted/taser
	sort_string = "OBADC"

/datum/design/item/rig_module/rcd
	name = "rcd"
	id = "rigmod_rcd"
	build_path = /obj/item/rig_module/device/rcd
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 4000, "uranium" = 2000, "diamond" = 2000)
	sort_string = "OBAEA"