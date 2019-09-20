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
	sort_string = "SAAAA"

/datum/design/item/sleevemate
	name = "SleeveMate 3700"
	id = "sleevemate"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000)
	build_path = /obj/item/device/sleevemate
	sort_string = "SAAAB"

/datum/design/item/bodysnatcher
	name = "Body Snatcher"
	id = "bodysnatcher"
	req_tech = list(TECH_MAGNET = 3, TECH_BIO = 3, TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000)
	build_path = /obj/item/device/bodysnatcher
	sort_string = "SAAAC"

/datum/design/item/weapon/sizegun
	name = "Size gun"
	id = "sizegun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 2000, "uranium" = 2000)
	build_path = /obj/item/weapon/gun/energy/sizegun
	sort_string = "SBAAA"

/datum/design/item/bluespace_jumpsuit
	name = "Bluespace jumpsuit"
	id = "bsjumpsuit"
	req_tech = list(TECH_BLUESPACE = 2, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000)
	build_path = /obj/item/clothing/under/bluespace
	sort_string = "SBAAB"

/datum/design/item/implant/sizecontrol
	name = "Size control implant"
	id = "implant_size"
	req_tech = list(TECH_MATERIAL = 3, TECH_BIO = 4, TECH_DATA = 4, TECH_ENGINEERING = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 2000, "glass" = 2000, "silver" = 3000)
	build_path = /obj/item/weapon/implanter/sizecontrol
	sort_string = "SBAAC"

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

/datum/design/item/nifbio
	name = "bioadaptive NIF"
	id = "bioadapnif"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 15000, "uranium" = 10000, "diamond" = 10000)
	build_path = /obj/item/device/nif/bioadap
	sort_string = "HABBD" //Changed String from HABBE to HABBD
//Addiing bioadaptive NIF to Protolathe

/datum/design/item/nifrepairtool
	name = "adv. NIF repair tool"
	id = "anrt"
	req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 200, "glass" = 3000, "uranium" = 2000, "diamond" = 2000)
	build_path = /obj/item/device/nifrepairer
	sort_string = "HABBE" //Changed String from HABBD to HABBE

/datum/design/item/medical/protohypospray
	name = "prototype hypospray"
	desc = "This prototype hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	id = "protohypospray"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_POWER = 2, TECH_BIO = 4, TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 1500, "silver" = 2000, "gold" = 1500, "uranium" = 1000)
	build_path = /obj/item/weapon/reagent_containers/hypospray/science
	sort_string = "MBBAH"

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

/datum/design/item/rig_module/lasercannon
	name = "rig module - laser cannon"
	id = "rigmod_lasercannon"
	build_path = /obj/item/rig_module/mounted
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 4000, "uranium" = 2000, "diamond" = 2000)
	sort_string = "HCAAL"

/datum/design/item/rig_module/egun
	name = "rig module - egun"
	id = "rigmod_egun"
	build_path = /obj/item/rig_module/mounted/egun
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 4000, "uranium" = 2000, "diamond" = 1000)
	sort_string = "HCAAM"

/datum/design/item/rig_module/taser
	name = "rig module - taser"
	id = "rigmod_taser"
	build_path = /obj/item/rig_module/mounted/taser
	sort_string = "HCAAN"

/datum/design/item/rig_module/rcd
	name = "rig module - rcd"
	id = "rigmod_rcd"
	build_path = /obj/item/rig_module/device/rcd
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 6000, "silver" = 4000, "uranium" = 2000, "diamond" = 2000)
	sort_string = "HCAAO"

//Prosfab stuff for borgs and such

/datum/design/item/robot_upgrade/sizeshift
	name = "Size Alteration Module"
	id = "borg_sizeshift_module"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 4000)
	build_path = /obj/item/borg/upgrade/sizeshift



// NSFW gun and cells
/datum/design/item/weapon/prototype_nsfw
	name = "cell-loaded revolver"
	id = "nsfw_prototype"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 6000, "phoron" = 8000, "uranium" = 4000)
	build_path = /obj/item/weapon/gun/projectile/cell_loaded/combat/prototype
	sort_string = "TNAAA"

/datum/design/item/weapon/prototype_nsfw_mag
	name = "combat cell magazine"
	id = "nsfw_mag_prototype"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "glass" = 4000, "phoron" = 4000)
	build_path = /obj/item/ammo_magazine/cell_mag/combat/prototype
	sort_string = "TNABA"

/datum/design/item/nsfw_cell/AssembleDesignName()
	..()
	name = "Microbattery prototype ([item_name])"

/datum/design/item/nsfw_cell/stun
	name = "STUN"
	id = "nsfw_cell_stun"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_POWER = 3, TECH_COMBAT = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000)
	build_path = /obj/item/ammo_casing/microbattery/combat/stun
	sort_string = "TNACA"

/datum/design/item/nsfw_cell/lethal
	name = "LETHAL"
	id = "nsfw_cell_lethal"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "phoron" = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/lethal
	sort_string = "TNACB"

/datum/design/item/nsfw_cell/net
	name = "NET"
	id = "nsfw_cell_net"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "uranium" = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/net
	sort_string = "TNACC"

/datum/design/item/nsfw_cell/ion
	name = "ION"
	id = "nsfw_cell_ion"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "silver" = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/ion
	sort_string = "TNACD"

/datum/design/item/nsfw_cell/shotstun
	name = "SCATTERSTUN"
	id = "nsfw_cell_shotstun"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 6, TECH_COMBAT = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "silver" = 2000, "gold" = 2000)
	build_path = /obj/item/ammo_casing/microbattery/combat/shotstun
	sort_string = "TNACE"

/datum/design/item/nsfw_cell/xray
	name = "XRAY"
	id = "nsfw_cell_xray"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 5, TECH_COMBAT = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "silver" = 1000, "gold" = 1000, "uranium" = 1000, "phoron" = 1000)
	build_path = /obj/item/ammo_casing/microbattery/combat/xray
	sort_string = "TNACF"

/datum/design/item/nsfw_cell/stripper
	name = "STRIPPER"
	id = "nsfw_cell_stripper"
	req_tech = list(TECH_MATERIAL = 7, TECH_BIO = 4, TECH_POWER = 4, TECH_COMBAT = 4, TECH_ILLEGAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "uranium" = 2000, "phoron" = 2000, "diamond" = 500)
	build_path = /obj/item/ammo_casing/microbattery/combat/stripper
	sort_string = "TNACG"

/*
/datum/design/item/nsfw_cell/final
	name = "FINAL OPTION"
	id = "nsfw_cell_final"
	req_tech = list(TECH_COMBAT = 69, TECH_ILLEGAL = 69, TECH_PRECURSOR = 1)
	materials = list("unobtanium" = 9001)
	build_path = /obj/item/ammo_casing/microbattery/combat/final
	sort_string = "TNACH"
*/



// ML-3M medigun and cells
/datum/design/item/medical/cell_medigun
	name = "cell-loaded medigun"
	id = "cell_medigun"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 3, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "plastic" = 8000, "glass" = 5000, "silver" = 1000, "gold" = 1000, "uranium" = 1000)
	build_path = /obj/item/weapon/gun/projectile/cell_loaded/medical
	sort_string = "MLAAA"

/datum/design/item/medical/cell_medigun_mag
	name = "medical cell magazine"
	id = "cell_medigun_mag"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 3, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "plastic" = 6000, "glass" = 3000, "silver" = 500, "gold" = 500)
	build_path = /obj/item/ammo_magazine/cell_mag/medical
	sort_string = "MLABA"

/datum/design/item/medical/cell_medigun_mag_advanced
	name = "advanced medical cell magazine"
	id = "cell_medigun_mag_advanced"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 4, TECH_BIO = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "plastic" = 10000, "glass" = 5000, "silver" = 1500, "gold" = 1500, "diamond" = 5000)
	build_path = /obj/item/ammo_magazine/cell_mag/medical/advanced
	sort_string = "MLABB"

/datum/design/item/ml3m_cell/AssembleDesignName()
	..()
	name = "Nanite cell prototype ([item_name])"

//Tier 0

/datum/design/item/ml3m_cell/brute
	name = "BRUTE"
	id = "ml3m_cell_brute"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000)
	build_path = /obj/item/ammo_casing/microbattery/medical/brute
	sort_string = "MLACA"

/datum/design/item/ml3m_cell/burn
	name = "BURN"
	id = "ml3m_cell_burn"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000)
	build_path = /obj/item/ammo_casing/microbattery/medical/burn
	sort_string = "MLACB"

/datum/design/item/ml3m_cell/stabilize
	name = "STABILIZE"
	id = "ml3m_cell_stabilize"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000)
	build_path = /obj/item/ammo_casing/microbattery/medical/stabilize
	sort_string = "MLACC"

//Tier 1

/datum/design/item/ml3m_cell/toxin
	name = "TOXIN"
	id = "ml3m_cell_toxin"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin
	sort_string = "MLACD"

/datum/design/item/ml3m_cell/omni
	name = "OMNI"
	id = "ml3m_cell_omni"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni
	sort_string = "MLACE"

/datum/design/item/ml3m_cell/antirad
	name = "ANTIRAD"
	id = "ml3m_cell_antirad"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500)
	build_path = /obj/item/ammo_casing/microbattery/medical/antirad
	sort_string = "MLACF"

//Tier 2

/datum/design/item/ml3m_cell/brute2
	name = "BRUTE-II"
	id = "ml3m_cell_brute2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "gold" = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/brute2
	sort_string = "MLACG"

/datum/design/item/ml3m_cell/burn2
	name = "BURN-II"
	id = "ml3m_cell_burn2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "gold" = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/burn2
	sort_string = "MLACH"

/datum/design/item/ml3m_cell/stabilize2
	name = "STABILIZE-II"
	id = "ml3m_cell_stabilize2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "silver" = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/stabilize2
	sort_string = "MLACI"

/datum/design/item/ml3m_cell/omni2
	name = "OMNI-II"
	id = "ml3m_cell_omni2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "uranium" = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni2
	sort_string = "MLACJ"

//Tier 3

/datum/design/item/ml3m_cell/toxin2
	name = "TOXIN-II"
	id = "ml3m_cell_toxin2"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "uranium" = 1000, "silver" = 1000, "diamond" = 500)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin2
	sort_string = "MLACK"

/datum/design/item/ml3m_cell/haste
	name = "HASTE"
	id = "ml3m_cell_haste"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "gold" = 1000, "silver" = 1000, "diamond" = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/haste
	sort_string = "MLACL"

/datum/design/item/ml3m_cell/resist
	name = "RESIST"
	id = "ml3m_cell_resist"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "gold" = 1000, "uranium" = 1000, "diamond" = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/resist
	sort_string = "MLACM"

/datum/design/item/ml3m_cell/corpse_mend
	name = "CORPSE MEND"
	id = "ml3m_cell_corpse_mend"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "phoron" = 3000, "diamond" = 3000)
	build_path = /obj/item/ammo_casing/microbattery/medical/corpse_mend
	sort_string = "MLACN"

//Tier 4

/datum/design/item/ml3m_cell/brute3
	name = "BRUTE-III"
	id = "ml3m_cell_brute3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_PRECURSOR = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "diamond" = 500, "verdantium" = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/brute3
	sort_string = "MLACO"

/datum/design/item/ml3m_cell/burn3
	name = "BURN-III"
	id = "ml3m_cell_burn3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_PRECURSOR = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "diamond" = 500, "verdantium" = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/burn3
	sort_string = "MLACP"

/datum/design/item/ml3m_cell/toxin3
	name = "TOXIN-III"
	id = "ml3m_cell_toxin3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_ARCANE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "diamond" = 500, "verdantium" = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin3
	sort_string = "MLACQ"

/datum/design/item/ml3m_cell/omni3
	name = "OMNI-III"
	id = "ml3m_cell_omni3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_ARCANE = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "diamond" = 500, "verdantium" = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni3
	sort_string = "MLACR"

//Tierless

/datum/design/item/ml3m_cell/shrink
	name = "SHRINK"
	id = "ml3m_cell_shrink"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "uranium" = 2000)
	build_path = /obj/item/ammo_casing/microbattery/medical/shrink
	sort_string = "MLADA"

/datum/design/item/ml3m_cell/grow
	name = "GROW"
	id = "ml3m_cell_grow"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "uranium" = 2000)
	build_path = /obj/item/ammo_casing/microbattery/medical/grow
	sort_string = "MLADB"

/datum/design/item/ml3m_cell/normalsize
	name = "NORMALSIZE"
	id = "ml3m_cell_normalsize"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "plastic" = 2500, "uranium" = 2000)
	build_path = /obj/item/ammo_casing/microbattery/medical/normalsize
	sort_string = "MLADC"