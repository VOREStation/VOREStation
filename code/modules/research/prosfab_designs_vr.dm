//Prosfab stuff for borgs and such

/datum/design/item/prosfab/robot_upgrade/sizeshift
	name = "Size Alteration Module"
	id = "borg_sizeshift_module"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/borg/upgrade/sizeshift

/datum/design/item/prosfab/robot_upgrade/sizegun
	name = "Size Gun Module"
	id = "borg_sizegun_module"
	req_tech = list(TECH_COMBAT = 3, TECH_BLUESPACE = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 4000)
	build_path = /obj/item/borg/upgrade/sizegun

/datum/design/item/prosfab/robot_upgrade/bellysizeupgrade
	name = "Robohound Capacity Expansion Module"
	id = "borg_hound_capacity_module"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/borg/upgrade/bellysizeupgrade


/*
	Some job related borg upgrade modules, adding useful items for puppers.

*/
/datum/design/item/prosfab/robot_upgrade/advrped
	name = "Advanced Rapid Part Exchange Device"
	desc = "Exactly the same as a standard Advanced RPED, but this one has mounting hardware for a Science Borg."
	id = "borg_advrped_module"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6)
	materials = list(MAT_STEEL = 30000, MAT_GLASS = 10000)
	build_path = /obj/item/borg/upgrade/advrped

/datum/design/item/prosfab/robot_upgrade/diamonddrill
	name = "Diamond Drill"
	desc = "A mining drill with a diamond tip, made for use by Mining Borgs."
	id = "borg_ddrill_module"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 5, TECH_ENGINEERING = 5)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/borg/upgrade/diamonddrill

/datum/design/item/prosfab/robot_upgrade/pka
	name = "Proto-Kinetic Accelerator"
	desc = "A mining weapon designed for clearing rocks and hostile wildlife. This model is equiped with a self upgrade system, allowing it to attach modules hands free."
	id = "borg_pka_module"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 5000, MAT_GLASS = 1000, MAT_URANIUM = 500, MAT_PLATINUM = 350)
	build_path = /obj/item/borg/upgrade/pka