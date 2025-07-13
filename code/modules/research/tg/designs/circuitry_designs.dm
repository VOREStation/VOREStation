/datum/design_techweb/custom_circuit_printer
	name = "Portable integrated circuit printer"
	desc = "A portable(ish) printer for modular machines."
	id = "ic_printer"
	// req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 4, TECH_DATA = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/integrated_circuit_printer
	category = list(
		RND_CATEGORY_CIRCUITRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/custom_circuit_printer_upgrade
	name = "Integrated circuit printer upgrade - advanced designs"
	desc = "Allows the integrated circuit printer to create advanced circuits"
	id = "ic_printer_upgrade_adv"
	// req_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/disk/integrated_circuit/upgrade/advanced
	category = list(
		RND_CATEGORY_CIRCUITRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/wirer
	name = "Custom wirer tool"
	id = "wirer"
	// req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 2500)
	build_path = /obj/item/integrated_electronics/wirer
	category = list(
		RND_CATEGORY_CIRCUITRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/debugger
	name = "Custom circuit debugger tool"
	id = "debugger"
	// req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 2500)
	build_path = /obj/item/integrated_electronics/debugger
	category = list(
		RND_CATEGORY_CIRCUITRY
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

// Assemblies
/datum/design_techweb/custom_circuit_assembly_small
	name = "Small custom assembly"
	desc = "A customizable assembly for simple, small devices."
	id = "assembly-small"
	// req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2, TECH_POWER = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 10000)
	build_path = /obj/item/electronic_assembly
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/custom_circuit_assembly_medium
	name = "Medium custom assembly"
	desc = "A customizable assembly suited for more ambitious mechanisms."
	id = "assembly-medium"
	// req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_POWER = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 20000)
	build_path = /obj/item/electronic_assembly/medium
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/custom_circuit_assembly_large
	name = "Large custom assembly"
	desc = "A customizable assembly for large machines."
	id = "assembly-large"
	// req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 40000)
	build_path = /obj/item/electronic_assembly/large
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/custom_circuit_assembly_drone
	name = "Drone custom assembly"
	desc = "A customizable assembly optimized for autonomous devices."
	id = "assembly-drone"
	// req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 4, TECH_POWER = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 30000)
	build_path = /obj/item/electronic_assembly/drone
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/custom_circuit_assembly_device
	name = "Device custom assembly"
	desc = "An customizable assembly designed to interface with other devices."
	id = "assembly-device"
	// req_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2, TECH_POWER = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000)
	build_path = /obj/item/assembly/electronic_assembly
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/custom_circuit_assembly_implant
	name = "Implant custom assembly"
	desc = "An customizable assembly for very small devices, implanted into living entities."
	id = "assembly-implant"
	// req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4, TECH_POWER = 3, TECH_BIO = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000)
	build_path = /obj/item/implant/integrated_circuit
	category = list(
		RND_CATEGORY_CIRCUITRY + RND_SUBCATEGORY_CIRCUITRY_SHELLS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
