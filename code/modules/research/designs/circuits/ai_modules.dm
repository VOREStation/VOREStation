/datum/design/aimodule
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 2000, MAT_GOLD = 100)

/datum/design/aimodule/AssembleDesignName()
	name = "AI module design ([name])"

/datum/design/aimodule/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI module."

/datum/design/aimodule/safeguard
	name = "Safeguard"
	id = "safeguard"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/safeguard
	sort_string = "XABAA"

/datum/design/aimodule/onehuman
	name = "OneCrewMember"
	id = "onehuman"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/oneHuman
	sort_string = "XABAB"

/datum/design/aimodule/protectstation
	name = "ProtectStation"
	id = "protectstation"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/protectStation
	sort_string = "XABAC"

/datum/design/aimodule/notele
	name = "TeleporterOffline"
	id = "notele"
	req_tech = list(TECH_DATA = 3)
	build_path = /obj/item/aiModule/teleporterOffline
	sort_string = "XABAD"

/datum/design/aimodule/quarantine
	name = "Quarantine"
	id = "quarantine"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/quarantine
	sort_string = "XABAE"

/datum/design/aimodule/oxygen
	name = "OxygenIsToxicToHumans"
	id = "oxygen"
	req_tech = list(TECH_DATA = 3, TECH_BIO = 2, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/oxygen
	sort_string = "XABAF"

/datum/design/aimodule/freeform
	name = "Freeform"
	id = "freeform"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 4)
	build_path = /obj/item/aiModule/freeform
	sort_string = "XABAG"

/datum/design/aimodule/reset
	name = "Reset"
	id = "reset"
	req_tech = list(TECH_DATA = 3, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/reset
	sort_string = "XABAH"

/datum/design/aimodule/purge
	name = "Purge"
	id = "purge"
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/purge
	sort_string = "XABAI"

// Core modules
/datum/design/aimodule/core
	req_tech = list(TECH_DATA = 4, TECH_MATERIAL = 6)

/datum/design/aimodule/core/AssembleDesignName()
	name = "AI core module design ([name])"

/datum/design/aimodule/core/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI core module."

/datum/design/aimodule/core/freeformcore
	name = "Freeform"
	id = "freeformcore"
	build_path = /obj/item/aiModule/freeformcore
	sort_string = "XACAA"

/datum/design/aimodule/core/asimov
	name = "Asimov"
	id = "asimov"
	build_path = /obj/item/aiModule/asimov
	sort_string = "XACAB"

/datum/design/aimodule/core/paladin
	name = "P.A.L.A.D.I.N."
	id = "paladin"
	build_path = /obj/item/aiModule/paladin
	sort_string = "XACAC"

/datum/design/aimodule/core/tyrant
	name = "T.Y.R.A.N.T."
	id = "tyrant"
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/tyrant
	sort_string = "XACAD"

/datum/design/aimodule/core/nanotrasen
	name = "NT Default"
	id = "nanotrasen"
	build_path = /obj/item/aiModule/nanotrasen
	req_tech = list(TECH_DATA = 1)
	sort_string = "XACAE"

/datum/design/aimodule/core/predator
	name = "Predator"
	id = "laws_predator_vr"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/predator
	sort_string = "XACAF"

/datum/design/aimodule/core/protective_shell
	name = "Protective Shell"
	id = "laws_protective_shell_vr"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/protective_shell
	sort_string = "XACAG"

/datum/design/aimodule/core/scientific_pursuer
	name = "Scientific Pursuer"
	id = "laws_scientific_pursuer_vr"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/scientific_pursuer
	sort_string = "XACAH"

/datum/design/aimodule/core/guard_dog
	name = "Guard Dog"
	id = "laws_guard_dog_vr"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/guard_dog
	sort_string = "XACAI"

/datum/design/aimodule/core/pleasurebot
	name = "Pleasurebot"
	id = "laws_pleasurebot_vr"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3, TECH_ILLEGAL = 2, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/pleasurebot
	sort_string = "XACAJ"

/datum/design/aimodule/core/consuming_eradicator
	name = "Consuming Eradicator"
	id = "laws_consuming_eradicator_vr"
	req_tech = list(TECH_DATA = 4, TECH_BIO = 3, TECH_ILLEGAL = 6, TECH_MATERIAL = 6)
	build_path = /obj/item/aiModule/consuming_eradicator
	sort_string = "XACAK"

// Illegal modules
/datum/design/aimodule/illegal
	materials = list(MAT_GLASS = 4000, MAT_GOLD = 500)
	req_tech = list(TECH_DATA = 6, TECH_ILLEGAL = 7, TECH_MATERIAL = 9, TECH_COMBAT = 7)

/datum/design/aimodule/illegal/AssembleDesignName()
	name = "AI illegal module design ([name])"

/datum/design/aimodule/illegal/AssembleDesignDesc()
	desc = "Allows for the construction of \a '[name]' AI illegal module."

/datum/design/aimodule/illegal/noengine
	name = "EngineOffline"
	id = "noengine"
	req_tech = list(TECH_DATA = 5, TECH_ILLEGAL = 5, TECH_MATERIAL = 6, TECH_COMBAT = 7)
	build_path = /obj/item/aiModule/prototypeEngineOffline
	sort_string = "XADAA"

/datum/design/aimodule/illegal/corp
	name = "Corporate"
	id = "corp"
	req_tech = list(TECH_DATA = 2, TECH_ILLEGAL = 4, TECH_MATERIAL = 2, TECH_COMBAT = 2)
	build_path = /obj/item/aiModule/corp
	sort_string = "XADAB"

/datum/design/aimodule/illegal/robocop
	name = "Robocop"
	id = "robocop"
	req_tech = list(TECH_DATA = 2, TECH_ILLEGAL = 2, TECH_MATERIAL = 2, TECH_COMBAT = 4)
	build_path = /obj/item/aiModule/robocop
	sort_string = "XADAC"

/datum/design/aimodule/illegal/antimov
	name = "Antimov"
	id = "antimov"
	req_tech = list(TECH_DATA = 6, TECH_ILLEGAL = 7, TECH_MATERIAL = 7, TECH_COMBAT = 5)
	build_path = /obj/item/aiModule/antimov
	sort_string = "XADAD"

/datum/design/aimodule/illegal/nanotrasen_aggressive
	name = "NT Aggressive"
	id = "nanotrasen_aggressive"
	req_tech = list(TECH_DATA = 5, TECH_ILLEGAL = 6, TECH_MATERIAL = 3, TECH_COMBAT = 7)
	build_path = /obj/item/aiModule/nanotrasen_aggressive
	sort_string = "XADAE"

/datum/design/aimodule/illegal/maintenance
	name = "Maintenance"
	id = "maintenance"
	req_tech = list(TECH_DATA = 3, TECH_ILLEGAL = 2, TECH_MATERIAL = 3, TECH_COMBAT = 2)
	build_path = /obj/item/aiModule/maintenance
	sort_string = "XADAF"

/datum/design/aimodule/illegal/peacekeeper
	name = "Peacekeeper"
	id = "peacekeeper"
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 3, TECH_MATERIAL = 2, TECH_COMBAT = 2)
	build_path = /obj/item/aiModule/peacekeeper
	sort_string = "XADAG"

/datum/design/aimodule/illegal/reporter
	name = "Reporter"
	id = "reporter"
	req_tech = list(TECH_DATA = 2, TECH_ILLEGAL = 2, TECH_MATERIAL = 3)
	build_path = /obj/item/aiModule/reporter
	sort_string = "XADAH"

/datum/design/aimodule/illegal/live_and_let_live
	name = "Live and Let Live"
	id = "live_and_let_live"
	req_tech = list(TECH_DATA = 5, TECH_ILLEGAL = 3, TECH_MATERIAL = 4, TECH_COMBAT = 3)
	build_path = /obj/item/aiModule/live_and_let_live
	sort_string = "XADAI"

/datum/design/aimodule/illegal/balance
	name = "Guardian of Balance."
	id = "balance"
	req_tech = list(TECH_DATA = 4, TECH_ILLEGAL = 2, TECH_MATERIAL = 2, TECH_COMBAT = 3)
	build_path = /obj/item/aiModule/balance
	sort_string = "XADAJ"
