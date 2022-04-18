/datum/design/item/disk/AssembleDesignName()
	..()
	name = "Data storage design ([name])"

/datum/design/item/disk/design_disk
	name = "Design Storage Disk"
	desc = "Produce additional disks for storing device designs."
	id = "design_disk"
	req_tech = list(TECH_DATA = 1)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 30, MAT_GLASS = 10)
	build_path = /obj/item/weapon/disk/design_disk
=======
	materials = list(MAT_STEEL = 30, "glass" = 10)
	build_path = /obj/item/disk/design_disk
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "CAAAA"

/datum/design/item/disk/tech_disk
	name = "Technology Data Storage Disk"
	desc = "Produce additional disks for storing technology data."
	id = "tech_disk"
	req_tech = list(TECH_DATA = 1)
<<<<<<< HEAD
	materials = list(MAT_STEEL = 30, MAT_GLASS = 10)
	build_path = /obj/item/weapon/disk/tech_disk
=======
	materials = list(MAT_STEEL = 30, "glass" = 10)
	build_path = /obj/item/disk/tech_disk
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	sort_string = "CAAAB"