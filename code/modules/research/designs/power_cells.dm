/datum/design/item/powercell
	build_type = PROTOLATHE | MECHFAB

/datum/design/item/powercell/AssembleDesignName()
	name = "Power Cell Model ([item_name])"

/datum/design/item/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/cell/C = build_path
		desc = "Allows the construction of power cells that can hold [initial(C.maxcharge)] units of energy."

/datum/design/item/powercell/Fabricate()
	var/obj/item/cell/C = ..()
	C.charge = 0 //shouldn't produce power out of thin air.
	C.update_icon()
	return C

/datum/design/item/powercell/basic
	name = "basic"
	id = "basic_cell"
	req_tech = list(TECH_POWER = 1)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
	build_path = /obj/item/cell
	category = list("Misc")
	sort_string = "BAAAA"

/datum/design/item/powercell/high
	name = "high-capacity"
	id = "high_cell"
	req_tech = list(TECH_POWER = 2)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 60)
	build_path = /obj/item/cell/high
	category = list("Misc")
	sort_string = "BAAAB"

/datum/design/item/powercell/super
	name = "super-capacity"
	id = "super_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 70)
	build_path = /obj/item/cell/super
	category = list("Misc")
	sort_string = "BAAAC"

/datum/design/item/powercell/hyper
	name = "hyper-capacity"
	id = "hyper_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 400, MAT_GOLD = 150, MAT_SILVER = 150, MAT_GLASS = 70)
	build_path = /obj/item/cell/hyper
	category = list("Misc")
	sort_string = "BAAAD"

/datum/design/item/powercell/device
	name = "device"
	build_type = PROTOLATHE
	id = "device"
	materials = list(MAT_STEEL = 350, MAT_GLASS = 25)
	build_path = /obj/item/cell/device
	category = list("Misc")
	sort_string = "BAABA"

/datum/design/item/powercell/weapon
	name = "weapon"
	build_type = PROTOLATHE
	id = "weapon"
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
	build_path = /obj/item/cell/device/weapon
	category = list("Misc")
	sort_string = "BAABB"

/datum/design/item/powercell/mecha/high
	name = "high-capacity mecha"
	id = "high_mech_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 600, MAT_SILVER = 150, MAT_GLASS = 70)
	build_path = /obj/item/cell/mech/high
	category = list("Misc")
	sort_string = "BAACA"

/datum/design/item/powercell/mecha/super
	name = "super-capacity mecha"
	id = "super_mech_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 500, MAT_GOLD = 200, MAT_SILVER = 200, MAT_GLASS = 80)
	build_path = /obj/item/cell/mech/super
	category = list("Misc")
	sort_string = "BAACB"