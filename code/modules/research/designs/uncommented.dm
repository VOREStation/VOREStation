
/* Uncomment if someone makes these buildable
/datum/design/circuit/general_alert
	name = "general alert console"
	id = "general_alert"
	build_path = /obj/item/weapon/circuitboard/general_alert

// Removal of loyalty implants. Can't think of a way to add this to the config option.
/datum/design/item/implant/loyalty
	name = "loyalty"
	id = "implant_loyal"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3)
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 7000)
	build_path = /obj/item/weapon/implantcase/loyalty"

/datum/design/rust_core_control
	name = "Circuit Design (RUST core controller)"
	desc = "Allows for the construction of circuit boards used to build a core control console for the RUST fusion engine."
	id = "rust_core_control"
	req_tech = list("programming" = 4, "engineering" = 4)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 2000, "sacid" = 20)
	build_path = "/obj/item/weapon/circuitboard/rust_core_control"

/datum/design/rust_fuel_control
	name = "Circuit Design (RUST fuel controller)"
	desc = "Allows for the construction of circuit boards used to build a fuel injector control console for the RUST fusion engine."
	id = "rust_fuel_control"
	req_tech = list("programming" = 4, "engineering" = 4)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 2000, "sacid" = 20)
	build_path = "/obj/item/weapon/circuitboard/rust_fuel_control"

/datum/design/rust_fuel_port
	name = "Internal circuitry (RUST fuel port)"
	desc = "Allows for the construction of circuit boards used to build a fuel injection port for the RUST fusion engine."
	id = "rust_fuel_port"
	req_tech = list("engineering" = 4, "materials" = 5)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 2000, "sacid" = 20, MAT_URANIUM = 3000)
	build_path = "/obj/item/weapon/module/rust_fuel_port"

/datum/design/rust_fuel_compressor
	name = "Circuit Design (RUST fuel compressor)"
	desc = "Allows for the construction of circuit boards used to build a fuel compressor of the RUST fusion engine."
	id = "rust_fuel_compressor"
	req_tech = list("materials" = 6, "phorontech" = 4)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 2000, "sacid" = 20, MAT_PHORON = 3000, MAT_DIAMOND = 1000)
	build_path = "/obj/item/weapon/module/rust_fuel_compressor"

/datum/design/rust_core
	name = "Internal circuitry (RUST tokamak core)"
	desc = "The circuit board that for a RUST-pattern tokamak fusion core."
	id = "pacman"
	req_tech = list(bluespace = 3, phorontech = 4, magnets = 5, powerstorage = 6)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 2000, "sacid" = 20, MAT_PHORON = 3000, MAT_DIAMOND = 2000)
	build_path = "/obj/item/weapon/circuitboard/rust_core"

/datum/design/rust_injector
	name = "Internal circuitry (RUST tokamak core)"
	desc = "The circuit board that for a RUST-pattern particle accelerator."
	id = "pacman"
	req_tech = list(powerstorage = 3, engineering = 4, phorontech = 4, materials = 6)
	build_type = IMPRINTER
	materials = list(MAT_GLASS = 2000, "sacid" = 20, MAT_PHORON = 3000, MAT_URANIUM = 2000)
	build_path = "/obj/item/weapon/circuitboard/rust_core"
*/
