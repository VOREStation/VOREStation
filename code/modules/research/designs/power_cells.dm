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
	build_type = PROTOLATHE | MECHFAB
	id = "basic_cell"
	req_tech = list(TECH_POWER = 1)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
	build_path = /obj/item/weapon/cell
	category = list("Misc")
=======
	materials = list(MAT_STEEL = 700, "glass" = 50)
	build_path = /obj/item/cell
	category = "Misc"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "BAAAA"

/datum/design/item/powercell/high
	name = "high-capacity"
	build_type = PROTOLATHE | MECHFAB
	id = "high_cell"
	req_tech = list(TECH_POWER = 2)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 700, MAT_GLASS = 60)
	build_path = /obj/item/weapon/cell/high
	category = list("Misc")
=======
	materials = list(MAT_STEEL = 700, "glass" = 60)
	build_path = /obj/item/cell/high
	category = "Misc"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "BAAAB"

/datum/design/item/powercell/super
	name = "super-capacity"
	id = "super_cell"
	req_tech = list(TECH_POWER = 3, TECH_MATERIAL = 2)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 700, MAT_GLASS = 70)
	build_path = /obj/item/weapon/cell/super
	category = list("Misc")
=======
	materials = list(MAT_STEEL = 700, "glass" = 70)
	build_path = /obj/item/cell/super
	category = "Misc"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
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
	materials = list(MAT_STEEL = 400, "gold" = 150, "silver" = 150, "glass" = 70)
	build_path = /obj/item/cell/hyper
	category = "Misc"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "BAAAD"

/datum/design/item/powercell/device
	name = "device"
	build_type = PROTOLATHE
	id = "device"
<<<<<<< HEAD
	materials = list(MAT_STEEL = 350, MAT_GLASS = 25)
	build_path = /obj/item/weapon/cell/device
	category = list("Misc")
=======
	materials = list(MAT_STEEL = 350, "glass" = 25)
	build_path = /obj/item/cell/device
	category = "Misc"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "BAABA"

/datum/design/item/powercell/weapon
	name = "weapon"
	build_type = PROTOLATHE
	id = "weapon"
<<<<<<< HEAD
	materials = list(MAT_STEEL = 700, MAT_GLASS = 50)
	build_path = /obj/item/weapon/cell/device/weapon
	category = list("Misc")
=======
	materials = list(MAT_STEEL = 700, "glass" = 50)
	build_path = /obj/item/cell/device/weapon
	category = "Misc"
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "BAABB"