/datum/design_techweb/board/robocontrol
	SET_CIRCUIT_DESIGN_NAMEDESC("robotics control console")
	id = "robocontrol"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/robotics
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/mechacontrol
	SET_CIRCUIT_DESIGN_NAMEDESC("exosuit control console")
	id = "mechacontrol"
	// req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/mecha_control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/rdconsole
	SET_CIRCUIT_DESIGN_NAMEDESC("R&D control console")
	id = "rdconsole"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/rdconsole
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/aifixer
	SET_CIRCUIT_DESIGN_NAMEDESC("AI integrity restorer")
	id = "aifixer"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/aifixer
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/aiupload
	SET_CIRCUIT_DESIGN_NAMEDESC("AI upload console")
	id = "aiupload"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/aiupload
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/borgupload
	SET_CIRCUIT_DESIGN_NAMEDESC("cyborg upload console")
	id = "borgupload"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/borgupload
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/circuit_imprinter
	SET_CIRCUIT_DESIGN_NAMEDESC("circuit imprinter")
	id = "circuit_imprinter"
	// req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/circuit_imprinter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/autolathe
	SET_CIRCUIT_DESIGN_NAMEDESC("autolathe")
	id = "autolathe"
	// req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/autolathe
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/rdserver
	SET_CIRCUIT_DESIGN_NAMEDESC("R&D server")
	id = "rdserver"
	// req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/machine/rdserver
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/mechfab
	SET_CIRCUIT_DESIGN_NAMEDESC("exosuit fabricator")
	id = "mechfab"
	// req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/mechfab
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/prosfab
	SET_CIRCUIT_DESIGN_NAMEDESC("prosthetics fabricator")
	id = "prosfab"
	// req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/prosthetics
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/mech_recharger
	SET_CIRCUIT_DESIGN_NAMEDESC("mech recharger")
	id = "mech_recharger"
	// req_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/mech_recharger
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/recharge_station
	SET_CIRCUIT_DESIGN_NAMEDESC("cyborg recharge station")
	id = "recharge_station"
	// req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/recharge_station
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/transhuman_synthprinter
	SET_CIRCUIT_DESIGN_NAMEDESC("SynthFab 3000")
	id = "transhuman_synthprinter"
	// req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/transhuman_synthprinter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

// Telesci stuff
/datum/design_techweb/board/telesci_console
	SET_CIRCUIT_DESIGN_NAMEDESC("Telepad Control Console")
	id = "telesci_console"
	// req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 3, TECH_PHORON = 4)
	build_path = /obj/item/circuitboard/telesci_console
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/telesci_pad
	SET_CIRCUIT_DESIGN_NAMEDESC("Telepad")
	id = "telesci_pad"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5)
	build_path = /obj/item/circuitboard/telesci_pad
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/quantum_pad
	SET_CIRCUIT_DESIGN_NAMEDESC("Quantum Pad")
	id = "quantum_pad"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5)
	build_path = /obj/item/circuitboard/quantumpad
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/bomb_tester
	SET_CIRCUIT_DESIGN_NAMEDESC("Explosive Effect Simulator")
	id = "bomb_tester"
	// req_tech = list(TECH_PHORON = 3, TECH_DATA = 2, TECH_MAGNET = 2)
	build_path = /obj/item/circuitboard/bomb_tester
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/teleporter_hub
	SET_CIRCUIT_DESIGN_NAMEDESC("teleporter hub")
	id = "teleporter_hub"
	build_path = /obj/item/circuitboard/teleporter_hub
	category = list(
		RND_CATEGORY_MACHINE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

/datum/design_techweb/board/teleporter_station
	SET_CIRCUIT_DESIGN_NAMEDESC("teleporter station")
	id = "teleporter_station"
	build_path = /obj/item/circuitboard/teleporter_station
	category = list(
		RND_CATEGORY_MACHINE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING

// Xenobotany
/datum/design_techweb/board/botany_extractor
	SET_CIRCUIT_DESIGN_NAMEDESC("lysis-isolation centrifuge")
	id = "botany_extractor"
	build_path = /obj/item/circuitboard/botany_extractor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_BOTANY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/botany_editor
	SET_CIRCUIT_DESIGN_NAMEDESC("bioballistic delivery system")
	id = "botany_editor"
	build_path = /obj/item/circuitboard/botany_editor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_BOTANY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/botany_seedextractor
	SET_CIRCUIT_DESIGN_NAMEDESC("seed extractor")
	id = "seed_extractor"
	build_path = /obj/item/circuitboard/botany_seedextractor
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_BOTANY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/destructive_analyzer
	SET_CIRCUIT_DESIGN_NAMEDESC("destructive analyzer")
	id = "destructive_analyzer"
	build_path = /obj/item/circuitboard/destructive_analyzer
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/anomaly_harvester
	SET_CIRCUIT_DESIGN_NAMEDESC("Anomaly Harvester")
	id = "anomaly_harvester"
	build_path = /obj/item/circuitboard/anomaly_harvester
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/rdservercontrol
	SET_CIRCUIT_DESIGN_NAMEDESC("R&D server")
	desc = "Manages access to research databases and consoles."
	id = "rdservercontrol"
	build_path = /obj/item/circuitboard/rdservercontrol
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/doppler_array
	SET_CIRCUIT_DESIGN_NAMEDESC("doppler array")
	id = "doppler_array"
	build_path = /obj/item/circuitboard/doppler_array
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/protean_reconstitutor
	SET_CIRCUIT_DESIGN_NAMEDESC("protean reconstitutor")
	id = "protean_reconstitutor"
	build_path = /obj/item/circuitboard/protean_reconstitutor
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/artifact_harvester
	SET_CIRCUIT_DESIGN_NAMEDESC("exotic particle harvester")
	id = "artifact_harvester"
	build_path = /obj/item/circuitboard/artifact_harvester
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/artifact_scanpad
	SET_CIRCUIT_DESIGN_NAMEDESC("anomaly scanner pad")
	id = "artifact_scanpad"
	build_path = /obj/item/circuitboard/artifact_scanpad
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

///Protolathe boards

/* Optional
/datum/design_techweb/board/protolathe
	SET_CIRCUIT_DESIGN_NAMEDESC("Protolathe - Omni")
	id = "protolathe_omni"
	build_path = /obj/item/circuitboard/machine/protolathe
*/

/datum/design_techweb/board/protolathe/science
	SET_CIRCUIT_DESIGN_NAMEDESC("Protolathe - Science")
	id = "protolathe_science"
	build_path = /obj/item/circuitboard/machine/protolathe/department/science

/datum/design_techweb/board/protolathe/service
	SET_CIRCUIT_DESIGN_NAMEDESC("Protolathe - Service")
	id = "protolathe_service"
	build_path = /obj/item/circuitboard/machine/protolathe/department/service

/datum/design_techweb/board/protolathe/medical
	SET_CIRCUIT_DESIGN_NAMEDESC("Protolathe - Medical")
	id = "protolathe_medical"
	build_path = /obj/item/circuitboard/machine/protolathe/department/medical

/datum/design_techweb/board/protolathe/cargo
	SET_CIRCUIT_DESIGN_NAMEDESC("Protolathe - Cargo")
	id = "protolathe_cargo"
	build_path = /obj/item/circuitboard/machine/protolathe/department/cargo

/datum/design_techweb/board/protolathe/engineering
	SET_CIRCUIT_DESIGN_NAMEDESC("Protolathe - Engineering")
	id = "protolathe_engineering"
	build_path = /obj/item/circuitboard/machine/protolathe/department/engineering
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_ENGINEERING //Engineering gets an exception in that they can produce their own, since engineering often expands operations.

/datum/design_techweb/board/protolathe/security
	SET_CIRCUIT_DESIGN_NAMEDESC("Protolathe - Security")
	id = "protolathe_security"
	build_path = /obj/item/circuitboard/machine/protolathe/department/security
