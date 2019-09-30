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

// Resleeving

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

// Telesci stuff

/datum/design/circuit/telesci_console
	name = "Telepad Control Console"
	id = "telesci_console"
	req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 3, TECH_PHORON = 4)
	build_path = /obj/item/weapon/circuitboard/telesci_console
	sort_string = "HAAEA"

/datum/design/circuit/telesci_pad
	name = "Telepad"
	id = "telesci_pad"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5)
	build_path = /obj/item/weapon/circuitboard/telesci_pad
	sort_string = "HAAEB"

/datum/design/circuit/quantum_pad
	name = "Quantum Pad"
	id = "quantum_pad"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5)
	build_path = /obj/item/weapon/circuitboard/quantumpad
	sort_string = "HAAC"