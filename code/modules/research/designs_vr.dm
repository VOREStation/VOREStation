/* Make language great again
/datum/design/item/implant/language
	name = "Language implant"
	id = "implant_language"
	req_tech = list(TECH_MATERIAL = 5, TECH_BIO = 5, TECH_DATA = 4, TECH_ENGINEERING = 4) //This is not an easy to make implant.
	materials = list(DEFAULT_WALL_MATERIAL = 7000, "glass" = 7000, "gold" = 2000, "diamond" = 3000)
	build_path = /obj/item/weapon/implantcase/vrlanguage
*/
/datum/design/item/implant/backup
	name = "Backup implant"
	id = "implant_backup"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2, TECH_DATA = 4, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000)
	build_path = /obj/item/weapon/implantcase/backup

/datum/design/item/weapon/sizegun
	name = "Size gun"
	id = "sizegun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 2000, "uranium" = 2000)
	build_path = /obj/item/weapon/gun/energy/sizegun
	sort_string = "TAAAB"

/datum/design/item/bluespace_jumpsuit
	name = "Bluespace jumpsuit"
	id = "bsjumpsuit"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000)
	build_path = /obj/item/clothing/under/bluespace
	sort_string = "TAAAC"

/datum/design/item/sleevemate
	name = "SleeveMate 3700"
	id = "sleevemate"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000)
	build_path = /obj/item/device/sleevemate
	sort_string = "TAAAD"

/datum/design/item/bodysnatcher
	name = "Body Snatcher"
	id = "bodysnatcher"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000)
	build_path = /obj/item/device/bodysnatcher

/datum/design/item/item/pressureinterlock
	name = "APP pressure interlock"
	id = "pressureinterlock"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 250)
	build_path = /obj/item/pressurelock
	sort_string = "TAADA"

/datum/design/item/weapon/advparticle
	name = "Advanced anti-particle rifle"
	id = "advparticle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 3, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "gold" = 1000, "uranium" = 750)
	build_path = /obj/item/weapon/gun/energy/particle/advanced
	sort_string = "TAADB"

/datum/design/item/weapon/particlecannon
	name = "Anti-particle cannon"
	id = "particlecannon"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_POWER = 4, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 1500, "gold" = 2000, "uranium" = 1000, "diamond" = 2000)
	build_path = /obj/item/weapon/gun/energy/particle/cannon
	sort_string = "TAADC"

/datum/design/item/hud/omni
	name = "AR glasses"
	id = "omnihud"
	req_tech = list(TECH_MAGNET = 4, TECH_COMBAT = 3, TECH_BIO = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 1000)
	build_path = /obj/item/clothing/glasses/omnihud
	sort_string = "GAAFB"

/datum/design/item/translocator
	name = "Personal translocator"
	id = "translocator"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_ILLEGAL = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 2000, "uranium" = 4000, "diamond" = 2000)
	build_path = /obj/item/device/perfect_tele
	sort_string = "HABAF"

/datum/design/item/nif
	name = "nanite implant framework"
	id = "nif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 8000, "uranium" = 6000, "diamond" = 6000)
	build_path = /obj/item/device/nif
	sort_string = "HABBC"

//Adding bioadaptive NIF to Protolathe
/datum/design/item/nifbio
	name = "bioadaptive NIF"
	id = "bioadapnif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 15000, "uranium" = 10000, "diamond" = 10000)
	build_path = /obj/item/device/nif/bioadap
	sort_string = "HABBD" //Changed String from HABBE to HABBD

/datum/design/item/nifrepairtool
	name = "adv. NIF repair tool"
	id = "anrt"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 200, "glass" = 3000, "uranium" = 2000, "diamond" = 2000)
	build_path = /obj/item/device/nifrepairer
	sort_string = "HABBE" //Changed String from HABBD to HABBE

/datum/design/item/medical/advanced_analyzer
	name = "advanced health analyzer"
	desc = "A state of the art refinement of the improved health scanner, with a full biosign monitor, on-board radiation and neurological analysis suites."
	id = "advanced_analyzer"
	req_tech = list(TECH_MAGNET = 6, TECH_BIO = 7, TECH_BLUESPACE = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 2000, "silver" = 2000, "gold" = 3000, "diamond" = 4000)
	build_path = /obj/item/device/healthanalyzer/advanced
	sort_string = "MBBAH"

/datum/design/item/medical/protohypospray
	name = "prototype hypospray"
	desc = "This prototype hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	id = "protohypospray"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_POWER = 2, TECH_BIO = 4, TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 1500, "silver" = 2000, "gold" = 1500, "uranium" = 1000)
	build_path = /obj/item/weapon/reagent_containers/hypospray/science
	sort_string = "MBBAI"

// Resleeving Circuitboards

/datum/design/circuit/transhuman_clonepod
	name = "grower pod"
	id = "transhuman_clonepod"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/weapon/circuitboard/transhuman_clonepod
	sort_string = "HAADA"

/datum/design/circuit/transhuman_synthprinter
	name = "SynthFab 3000"
	id = "transhuman_synthprinter"
	req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/weapon/circuitboard/transhuman_synthprinter
	sort_string = "HAADB"

/datum/design/circuit/transhuman_resleever
	name = "Resleeving pod"
	id = "transhuman_resleever"
	req_tech = list(TECH_ENGINEERING = 4, TECH_BIO = 4)
	build_path = /obj/item/weapon/circuitboard/transhuman_resleever
	sort_string = "HAADC"

/datum/design/circuit/resleeving_control
	name = "Resleeving control console"
	id = "resleeving_control"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/weapon/circuitboard/resleeving_control
	sort_string = "HAADE"

/datum/design/circuit/body_designer
	name = "Body design console"
	id = "body_designer"
	req_tech = list(TECH_DATA = 5)
	build_path = /obj/item/weapon/circuitboard/body_designer
	sort_string = "HAADF"

/datum/design/circuit/partslathe
	name = "Parts lathe"
	id = "partslathe"
	req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/weapon/circuitboard/partslathe
	sort_string = "HABAD"

/datum/design/item/weapon/netgun
	name = "\'Hunter\' capture gun"
	id = "netgun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 3000)
	build_path = /obj/item/weapon/gun/energy/netgun
	sort_string = "TAADF"

/datum/design/circuit/algae_farm
	name = "Algae Oxygen Generator"
	id = "algae_farm"
	req_tech = list(TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_path = /obj/item/weapon/circuitboard/algae_farm
	sort_string = "HABAE"

/datum/design/circuit/thermoregulator
	name = "thermal regulator"
	id = "thermoregulator"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 3)
	build_path = /obj/item/weapon/circuitboard/thermoregulator
	sort_string = "HABAF"

/datum/design/circuit/bomb_tester
	name = "Explosive Effect Simulator"
	id = "bomb_tester"
	req_tech = list(TECH_PHORON = 3, TECH_DATA = 2, TECH_MAGNET = 2)
	build_path = /obj/item/weapon/circuitboard/bomb_tester
	sort_string = "HABAG"

/datum/design/circuit/quantum_pad
	name = "Quantum Pad"
	id = "quantum_pad"
	req_tech = list(TECH_ENGINEERING = 4, TECH_POWER = 4, TECH_BLUESPACE = 4)
	build_path = /obj/item/weapon/circuitboard/quantumpad
	sort_string = "HABAH"

//////Micro mech stuff
/datum/design/circuit/mecha/gopher_main
	name = "'Gopher' central control"
	id = "gopher_main"
	build_path = /obj/item/weapon/circuitboard/mecha/gopher/main
	sort_string = "NAAEA"

/datum/design/circuit/mecha/gopher_peri
	name = "'Gopher' peripherals control"
	id = "gopher_peri"
	build_path = /obj/item/weapon/circuitboard/mecha/gopher/peripherals
	sort_string = "NAAEB"

/datum/design/circuit/mecha/polecat_main
	name = "'Polecat' central control"
	id = "polecat_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/polecat/main
	sort_string = "NAAFA"

/datum/design/circuit/mecha/polecat_peri
	name = "'Polecat' peripherals control"
	id = "polecat_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/polecat/peripherals
	sort_string = "NAAFB"

/datum/design/circuit/mecha/polecat_targ
	name = "'Polecat' weapon control and targeting"
	id = "polecat_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/polecat/targeting
	sort_string = "NAAFC"

/datum/design/circuit/mecha/weasel_main
	name = "'Weasel' central control"
	id = "weasel_main"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/weasel/main
	sort_string = "NAAGA"

/datum/design/circuit/mecha/weasel_peri
	name = "'Weasel' peripherals control"
	id = "weasel_peri"
	req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/weapon/circuitboard/mecha/weasel/peripherals
	sort_string = "NAAGB"

/datum/design/circuit/mecha/weasel_targ
	name = "'Weasel' weapon control and targeting"
	id = "weasel_targ"
	req_tech = list(TECH_DATA = 4, TECH_COMBAT = 2)
	build_path = /obj/item/weapon/circuitboard/mecha/weasel/targeting
	sort_string = "NAAGC"

////// RIGSuit Stuff
/*
/datum/design/item/rig
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 6000, "uranium" = 4000)

/datum/design/item/rig/eva
	name = "eva hardsuit (empty)"
	id = "eva_hardsuit"
	build_path = /obj/item/weapon/rig/eva
	sort_string = "HCAAA"

/datum/design/item/rig/mining
	name = "industrial hardsuit (empty)"
	id = "ind_hardsuit"
	build_path = /obj/item/weapon/rig/industrial
	sort_string = "HCAAB"

/datum/design/item/rig/research
	name = "ami hardsuit (empty)"
	id = "ami_hardsuit"
	build_path = /obj/item/weapon/rig/hazmat
	sort_string = "HCAAC"

/datum/design/item/rig/medical
	name = "medical hardsuit (empty)"
	id = "med_hardsuit"
	build_path = /obj/item/weapon/rig/medical
	sort_string = "HCAAD"
*/

/datum/design/item/rig_module
	req_tech = list(TECH_MATERIAL = 5, TECH_POWER = 5, TECH_MAGNET = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 4000, "uranium" = 2000)

/datum/design/item/rig_module/plasma_cutter
	name = "rig module - plasma cutter"
	id = "rigmod_plasmacutter"
	build_path = /obj/item/rig_module/device/plasmacutter
	sort_string = "HCAAE"

/datum/design/item/rig_module/diamond_drill
	name = "rig module - diamond drill"
	id = "rigmod_diamonddrill"
	build_path = /obj/item/rig_module/device/drill
	sort_string = "HCAAF"

/datum/design/item/rig_module/maneuvering_jets
	name = "rig module - maneuvering jets"
	id = "rigmod_maneuveringjets"
	build_path = /obj/item/rig_module/maneuvering_jets
	sort_string = "HCAAG"

/datum/design/item/rig_module/anomaly_scanner
	name = "rig module - anomaly scanner"
	id = "rigmod_anomalyscanner"
	build_path = /obj/item/rig_module/device/anomaly_scanner
	sort_string = "HCAAH"

/datum/design/item/rig_module/orescanner
	name = "rig module - ore scanner"
	id = "rigmod_orescanner"
	build_path = /obj/item/rig_module/device/orescanner
	sort_string = "HCAAI"

/datum/design/item/rig_module/sprinter
	name = "rig module - sprinter"
	id = "rigmod_sprinter"
	build_path = /obj/item/rig_module/sprinter
	sort_string = "HCAAJ"

/datum/design/item/rig_module/rescue_pharm
	name = "rig module - rescue pharm"
	id = "rigmod_rescue_pharm"
	build_path = /obj/item/rig_module/rescue_pharm
	sort_string = "HCAAK"

/datum/design/item/rig_module/pat_module
	name = "rig module - pat module"
	id = "rigmod_pat_module"
	build_path = /obj/item/rig_module/pat_module
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 4000, "uranium" = 2000, "diamond" = 2000)
	sort_string = "HCAAL"

/datum/design/item/rig_module/lasercannon
	name = "rig module - laser cannon"
	id = "rigmod_lasercannon"
	build_path = /obj/item/rig_module/mounted
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 4000, "uranium" = 2000, "diamond" = 2000)
	sort_string = "HCAAM"

/datum/design/item/rig_module/egun
	name = "rig module - egun"
	id = "rigmod_egun"
	build_path = /obj/item/rig_module/mounted/egun
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 4000, "uranium" = 2000, "diamond" = 1000)
	sort_string = "HCAAN"

/datum/design/item/rig_module/grenade
	name = "rig module - grenade launcher"
	id = "rigmod_grenade"
	build_path = /obj/item/rig_module/grenade_launcher
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 4000, "uranium" = 2000, "diamond" = 3000)
	sort_string = "HCAAO"

/datum/design/item/rig_module/taser
	name = "rig module - taser"
	id = "rigmod_taser"
	build_path = /obj/item/rig_module/mounted/taser
	sort_string = "HCAAP"

/datum/design/item/rig_module/rcd
	name = "rig module - rcd"
	id = "rigmod_rcd"
	build_path = /obj/item/rig_module/device/rcd
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 4000, "uranium" = 2000, "diamond" = 2000)
	sort_string = "HCAAQ"
