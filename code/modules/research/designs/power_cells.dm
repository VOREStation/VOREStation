/datum/design/item/powercell
	build_type = PROTOLATHE | MECHFAB

/datum/design/item/powercell/AssembleDesignName()
	name = "Power Cell Model ([item_name])"

/datum/design/item/powercell/AssembleDesignDesc()
	if(build_path)
		var/obj/item/weapon/cell/C = build_path
		desc = "Allows the construction of power cells that can hold [initial(C.maxcharge)] units of energy."

/datum/design/item/powercell/Fabricate()
	var/obj/item/weapon/cell/C = ..()
	C.charge = 0 //shouldn't produce power out of thin air.
	C.update_icon()
	return C

/datum/design/item/powercell/basic
	name = "basic"
	id = "basic_cell"
	req_tech = list(TECH_POWER = 1)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
<<<<<<< HEAD
	build_path = /obj/item/weapon/cell
	category = list("Misc")
=======
	build_path = /obj/item/cell
	category = "Misc"
>>>>>>> 2d277d957fe... R&D Design Updates (#8992)
	sort_string = "BAAAA"

/datum/design/item/powercell/high
	name = "high-capacity"
	id = "high_cell"
	req_tech = list(TECH_POWER = 2)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 60)
<<<<<<< HEAD
	build_path = /obj/item/weapon/cell/high
	category = list("Misc")
=======
	build_path = /obj/item/cell/high
	category = "Misc"
>>>>>>> 2d277d957fe... R&D Design Updates (#8992)
	sort_string = "BAAAB"

/datum/design/item/powercell/super
	name = "super-capacity"
	id = "super_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 700, MAT_GLASS = 70)
<<<<<<< HEAD
	build_path = /obj/item/weapon/cell/super
	category = list("Misc")
=======
	build_path = /obj/item/cell/super
	category = "Misc"
>>>>>>> 2d277d957fe... R&D Design Updates (#8992)
	sort_string = "BAAAC"

/datum/design/item/powercell/hyper
	name = "hyper-capacity"
	id = "hyper_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 400, MAT_GOLD = 150, MAT_SILVER = 150, MAT_GLASS = 70)
	build_path = /obj/item/weapon/cell/hyper
	category = list("Misc")
=======
	materials = list(MAT_STEEL = 400, "gold" = 150, "silver" = 150, MAT_GLASS = 70)
	build_path = /obj/item/cell/hyper
	category = "Misc"
>>>>>>> 2d277d957fe... R&D Design Updates (#8992)
	sort_string = "BAAAD"

/datum/design/item/powercell/device
	name = "device"
	build_type = PROTOLATHE
	id = "device"
	materials = list(MAT_STEEL = 350, MAT_GLASS = 25)
<<<<<<< HEAD
	build_path = /obj/item/weapon/cell/device
	category = list("Misc")
=======
	build_path = /obj/item/cell/device
	category = "Misc"
>>>>>>> 2d277d957fe... R&D Design Updates (#8992)
	sort_string = "BAABA"

/datum/design/item/powercell/weapon
	name = "weapon"
	build_type = PROTOLATHE
	id = "weapon"
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
<<<<<<< HEAD
	build_path = /obj/item/weapon/cell/device/weapon
	category = list("Misc")
	sort_string = "BAABB"

/datum/design/item/powercell/mecha/high
	name = "high-capacity mecha"
	id = "high_mech_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 600, MAT_SILVER = 150, MAT_GLASS = 70)
	build_path = /obj/item/weapon/cell/mech/high
	category = list("Misc")
	sort_string = "BAACA"

/datum/design/item/powercell/mecha/super
	name = "super-capacity mecha"
	id = "super_mech_cell"
	req_tech = list(TECH_POWER = 5, TECH_MATERIAL = 4)
	materials = list(MAT_STEEL = 500, MAT_GOLD = 200, MAT_SILVER = 200, MAT_GLASS = 80)
	build_path = /obj/item/weapon/cell/mech/super
	category = list("Misc")
	sort_string = "BAACB"
=======
	build_path = /obj/item/cell/device/weapon
	category = "Misc"
	sort_string = "BAABB"
>>>>>>> 2d277d957fe... R&D Design Updates (#8992)
