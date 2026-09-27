// Mecha cells
/datum/design_techweb/high_mech_cell
	name = "High-Capacity Mecha Cell"
	desc = "A tier 2 power cell for mecha."
	id = "high_mech_cell"
	build_type = PROTOLATHE | MECHFAB
	// req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = MATERIAL_COST(0.3), MAT_SILVER = MATERIAL_COST(0.075), MAT_GLASS = MATERIAL_COST(0.035))
	build_path = /obj/item/cell/mech/high
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/super_mech_cell
	name = "Super-Capacity Mecha Cell"
	desc = "A tier 3 power cell for mecha."
	id = "super_mech_cell"
	build_type = PROTOLATHE | MECHFAB
	// req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = MATERIAL_COST(0.25), MAT_GOLD = MATERIAL_COST(0.1), MAT_SILVER = MATERIAL_COST(0.1), MAT_GLASS = MATERIAL_COST(0.04))
	build_path = /obj/item/cell/mech/super
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/synthetic_flash
	name = "Synthetic Flash"
	desc = "A synthetic flash with a singular charge."
	id = "sflash"
	//req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_type = MECHFAB
	materials = list(MAT_STEEL = MATERIAL_COST(0.281), MAT_GLASS = MATERIAL_COST(0.281))
	build_path = /obj/item/flash/synthetic
	category = list(
		RND_CATEGORY_TOOLS
	) //I really don't know what to put for this.
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
