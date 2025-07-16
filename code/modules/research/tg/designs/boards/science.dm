/datum/design_techweb/board/robocontrol
	name = "robotics control console circuit"
	id = "robocontrol"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/robotics
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/mechacontrol
	name = "exosuit control console circuit"
	id = "mechacontrol"
	// req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/mecha_control
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/rdconsole
	name = "R&D control console circuit"
	id = "rdconsole"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/rdconsole
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/aifixer
	name = "AI integrity restorer circuit"
	id = "aifixer"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 2)
	build_path = /obj/item/circuitboard/aifixer
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/aiupload
	name = "AI upload console circuit"
	id = "aiupload"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/aiupload
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/borgupload
	name = "cyborg upload console circuit"
	id = "borgupload"
	// req_tech = list(TECH_DATA = 4)
	build_path = /obj/item/circuitboard/borgupload
	category = list(
		RND_CATEGORY_COMPUTER + RND_SUBCATEGORY_COMPUTER_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/circuit_imprinter
	name = "circuit imprinter circuit"
	id = "circuit_imprinter"
	// req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/circuit_imprinter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/autolathe
	name = "autolathe board circuit"
	id = "autolathe"
	// req_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/autolathe
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/rdserver
	name = "R&D server circuit"
	id = "rdserver"
	// req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/circuitboard/machine/rdserver
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/mechfab
	name = "exosuit fabricator circuit"
	id = "mechfab"
	// req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/mechfab
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/prosfab
	name = "prosthetics fabricator circuit"
	id = "prosfab"
	// req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/prosthetics
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/mech_recharger
	name = "mech recharger circuit"
	id = "mech_recharger"
	// req_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/mech_recharger
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/recharge_station
	name = "cyborg recharge station circuit"
	id = "recharge_station"
	// req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 2)
	build_path = /obj/item/circuitboard/recharge_station
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/transhuman_synthprinter
	name = "SynthFab 3000 circuit"
	id = "transhuman_synthprinter"
	// req_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	build_path = /obj/item/circuitboard/transhuman_synthprinter
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

// Telesci stuff
/datum/design_techweb/board/telesci_console
	name = "Telepad Control Console circuit"
	id = "telesci_console"
	// req_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 3, TECH_PHORON = 4)
	build_path = /obj/item/circuitboard/telesci_console
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/telesci_pad
	name = "Telepad circuit"
	id = "telesci_pad"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5)
	build_path = /obj/item/circuitboard/telesci_pad
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/quantum_pad
	name = "Quantum Pad circuit"
	id = "quantum_pad"
	// req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_PHORON = 4, TECH_BLUESPACE = 5)
	build_path = /obj/item/circuitboard/quantumpad
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_TELEPORT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/board/bomb_tester
	name = "Explosive Effect Simulator circuit"
	id = "bomb_tester"
	// req_tech = list(TECH_PHORON = 3, TECH_DATA = 2, TECH_MAGNET = 2)
	build_path = /obj/item/circuitboard/bomb_tester
	category = list(
		RND_CATEGORY_MACHINE + RND_SUBCATEGORY_MACHINE_RESEARCH
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
