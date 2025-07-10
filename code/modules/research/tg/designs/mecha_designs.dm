// Mecha cells
/datum/design_techweb/high_mech_cell
	name = "High-Capacity Mecha Cell"
	desc = "A tier 2 power cell for mecha."
	id = "high_mech_cell"
	build_type = PROTOLATHE | MECHFAB
	// req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 600, MAT_SILVER = 150, MAT_GLASS = 70)
	build_path = /obj/item/cell/mech/high
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT
	)

/datum/design_techweb/super_mech_cell
	name = "Super-Capacity Mecha Cell"
	desc = "A tier 3 power cell for mecha."
	id = "super_mech_cell"
	build_type = PROTOLATHE | MECHFAB
	// req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 500, MAT_GOLD = 200, MAT_SILVER = 200, MAT_GLASS = 80)
	build_path = /obj/item/cell/mech/super
	category = list(
		RND_CATEGORY_MECHFAB_EQUIPMENT
	)

/datum/design_techweb/synthetic_flash
	name = "Synthetic Flash"
	desc = "A synthetic flash with a singular charge."
	id = "sflash"
	//req_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 2)
	build_type = MECHFAB
	materials = list(MAT_STEEL = 562, MAT_GLASS = 562)
	build_path = /obj/item/flash/synthetic
	category = list(
		RND_SUBCATEGORY_MECHFAB_EQUIPMENT_MISC
	) //I really don't know what to put for this.
