/datum/design_techweb/board/aicore
	name = "AI core circuit"
	id = "aicore"
	// req_tech = list(TECH_DATA = 4, TECH_BIO = 3)
	build_path = /obj/item/circuitboard/aicore
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/mmi
	name = "Man-machine interface"
	id = "mmi"
	// req_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	build_type = PROTOLATHE | PROSFAB
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500)
	build_path = /obj/item/mmi
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/posibrain
	name = "Positronic brain"
	id = "posibrain"
	// req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 6, TECH_BLUESPACE = 2, TECH_DATA = 4)
	build_type = PROTOLATHE | PROSFAB
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_GOLD = 500, MAT_PHORON = 500, MAT_DIAMOND = 100)
	build_path = /obj/item/mmi/digital/posibrain
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/dronebrain
	name = "Robotic intelligence circuit"
	id = "dronebrain"
	// req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_DATA = 4)
	build_type = PROTOLATHE | PROSFAB
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 1000, MAT_SILVER = 1000, MAT_GOLD = 500)
	build_path = /obj/item/mmi/digital/robot
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CONTROL_INTERFACES
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/paicard
	name = "'pAI', personal artificial intelligence device"
	id = "paicard"
	build_type = PROTOLATHE
	// req_tech = list(TECH_DATA = 2)
	materials = list(MAT_GLASS = 500, MAT_STEEL = 500)
	build_path = /obj/item/paicard
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/intellicard
	name = "intelliCore"
	desc = "Allows for the construction of an intelliCore."
	id = "intellicore"
	build_type = PROTOLATHE
	// req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	materials = list(MAT_GLASS = 1000, MAT_GOLD = 200)
	build_path = /obj/item/aicard
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design/aimodule
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 2000, MAT_GOLD = 100)
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_LAW_MANIPULATION
	)

/datum/design/aimodule/New()
	. = ..()
	name = "AI module design ([name])"

/datum/design/aimodule/safeguard
	name = "Safeguard"
	id = "safeguard"
	// req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/safeguard

/datum/design/aimodule/onehuman
	name = "OneCrewMember"
	id = "onehuman"
	// req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/oneHuman

/datum/design/aimodule/protectstation
	name = "ProtectStation"
	id = "protectstation"
	// req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/protectStation

/datum/design/aimodule/notele
	name = "TeleporterOffline"
	id = "notele"
	// req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/aiModule/teleporterOffline

/datum/design/aimodule/quarantine
	name = "Quarantine"
	id = "quarantine"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/quarantine

/datum/design/aimodule/oxygen
	name = "OxygenIsToxicToHumans"
	id = "oxygen"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/oxygen

/datum/design/aimodule/freeform
	name = "Freeform"
	id = "freeform"
	// req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/freeform

/datum/design/aimodule/reset
	name = "Reset"
	id = "reset"
	// req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/reset

/datum/design/aimodule/purge
	name = "Purge"
	id = "purge"
	// req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/purge

// Core modules
/datum/design/aimodule/core
	category = list(
		RND_CATEGORY_AI + RND_SUBCATEGORY_AI_CORE_MODULES
	)

/datum/design/aimodule/core/New()
	. = ..()
	name = "AI core module design ([initial(name)])"

/datum/design/aimodule/core/freeformcore
	name = "Freeform"
	id = "freeformcore"
	build_path = /obj/item/aiModule/freeformcore

/datum/design/aimodule/core/asimov
	name = "Asimov"
	id = "asimov"
	build_path = /obj/item/aiModule/asimov

/datum/design/aimodule/core/paladin
	name = "P.A.L.A.D.I.N."
	id = "paladin"
	build_path = /obj/item/aiModule/paladin

/datum/design/aimodule/core/tyrant
	name = "T.Y.R.A.N.T."
	id = "tyrant"
	// req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/tyrant

/datum/design/aimodule/core/nanotrasen
	name = "NT Default"
	id = "nanotrasen"
	build_path = /obj/item/aiModule/nanotrasen
	// req_tech = list(TECH_DATA = 1)

/datum/design/aimodule/core/predator
	name = "Predator"
	id = "laws_predator_vr"
	// req_tech = list(TECH_DATA = 4, TECH_BIO = 3, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/predator

/datum/design/aimodule/core/protective_shell
	name = "Protective Shell"
	id = "laws_protective_shell_vr"
	// req_tech = list(TECH_DATA = 4, TECH_BIO = 3, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/protective_shell

/datum/design/aimodule/core/scientific_pursuer
	name = "Scientific Pursuer"
	id = "laws_scientific_pursuer_vr"
	// req_tech = list(TECH_DATA = 4, TECH_BIO = 3, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/scientific_pursuer

/datum/design/aimodule/core/guard_dog
	name = "Guard Dog"
	id = "laws_guard_dog_vr"
	// req_tech = list(TECH_DATA = 4, TECH_BIO = 3, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/guard_dog

/datum/design/aimodule/core/pleasurebot
	name = "Pleasurebot"
	id = "laws_pleasurebot_vr"
	// req_tech = list(TECH_DATA = 4, TECH_BIO = 3, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/pleasurebot

/datum/design/aimodule/core/consuming_eradicator
	name = "Consuming Eradicator"
	id = "laws_consuming_eradicator_vr"
	// req_tech = list(TECH_DATA = 4, TECH_BIO = 3, TECH_ILLEGAL = 6, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/consuming_eradicator

// Illegal modules
/datum/design/aimodule/illegal
	materials = list(MAT_GLASS = 4000, MAT_GOLD = 500)
	// req_tech = list(TECH_DATA = 6, TECH_ILLEGAL = 7, TECH_MATERIAL = 9, TECH_COMBAT = 7)

/datum/design/aimodule/illegal/New()
	. = ..()
	name = "AI illegal module design ([initial(name)])"

/datum/design/aimodule/illegal/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI illegal module."

/datum/design/aimodule/illegal/noengine
	name = "EngineOffline"
	id = "noengine"
	// req_tech = list(TECH_DATA = 5, TECH_ILLEGAL = 5, TECH_MATERIAL = 6, TECH_COMBAT = 7)
	build_path = /obj/item/aiModule/prototypeEngineOffline

/datum/design/aimodule/illegal/corp
	name = "Corporate"
	id = "corp"
	// req_tech = list(TECH_DATA = 2, TECH_ILLEGAL = 4, TECH_MATERIAL = 2, TECH_COMBAT = 2)
	build_path = /obj/item/aiModule/corp

/datum/design/aimodule/illegal/robocop
	name = "Robocop"
	id = "robocop"
	// req_tech = list(TECH_DATA = 2, TECH_ILLEGAL = 2, TECH_MATERIAL = 2, TECH_COMBAT = 4)
	build_path = /obj/item/aiModule/robocop

/datum/design/aimodule/illegal/antimov
	name = "Antimov"
	id = "antimov"
	// req_tech = list(TECH_DATA = 6, TECH_ILLEGAL = 7, TECH_MATERIAL = 7, TECH_COMBAT = 5)
	build_path = /obj/item/aiModule/antimov

/datum/design/aimodule/illegal/nanotrasen_aggressive
	name = "NT Aggressive"
	id = "nanotrasen_aggressive"
	// req_tech = list(TECH_DATA = 5, TECH_ILLEGAL = 6, TECH_MATERIAL = 3, TECH_COMBAT = 7)
	build_path = /obj/item/aiModule/nanotrasen_aggressive

/datum/design/aimodule/illegal/maintenance
	name = "Maintenance"
	id = "maintenance"
	// req_tech = list(TECH_DATA = 3, TECH_ILLEGAL = 2, TECH_MATERIAL = 3, TECH_COMBAT = 2)
	build_path = /obj/item/aiModule/maintenance

/datum/design/aimodule/illegal/peacekeeper
	name = "Peacekeeper"
	id = "peacekeeper"
	// req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 3, TECH_MATERIAL = 2, TECH_COMBAT = 2)
	build_path = /obj/item/aiModule/peacekeeper

/datum/design/aimodule/illegal/reporter
	name = "Reporter"
	id = "reporter"
	// req_tech = list(TECH_DATA = 2, TECH_ILLEGAL = 2, TECH_MATERIAL = 3)
	build_path = /obj/item/aiModule/reporter

/datum/design/aimodule/illegal/live_and_let_live
	name = "Live and Let Live"
	id = "live_and_let_live"
	// req_tech = list(TECH_DATA = 5, TECH_ILLEGAL = 3, TECH_MATERIAL = 4, TECH_COMBAT = 3)
	build_path = /obj/item/aiModule/live_and_let_live

/datum/design/aimodule/illegal/balance
	name = "Guardian of Balance."
	id = "balance"
	// req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 2, TECH_MATERIAL = 2, TECH_COMBAT = 3)
	build_path = /obj/item/aiModule/balance
