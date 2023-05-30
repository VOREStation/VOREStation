/datum/design/item/mechfab/gopher
	category = list("Gopher")
	time = 5

/datum/design/item/mechfab/gopher/chassis
	name = "Gopher Chassis"
	id = "gopher_chassis"
	build_path = /obj/item/mecha_parts/micro/chassis/gopher
	time = 3
	materials = list(MAT_STEEL = 7000)

/datum/design/item/mechfab/gopher/torso
	name = "Gopher Torso"
	id = "gopher_torso"
	build_path = /obj/item/mecha_parts/micro/part/gopher_torso
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/design/item/mechfab/gopher/left_arm
	name = "Gopher Left Arm"
	id = "gopher_left_arm"
	build_path = /obj/item/mecha_parts/micro/part/gopher_left_arm
	materials = list(MAT_STEEL = 8750)

/datum/design/item/mechfab/gopher/right_arm
	name = "Gopher Right Arm"
	id = "gopher_right_arm"
	build_path = /obj/item/mecha_parts/micro/part/gopher_right_arm

	materials = list(MAT_STEEL = 8750)

/datum/design/item/mechfab/gopher/left_leg
	name = "Gopher Left Leg"
	id = "gopher_left_leg"
	build_path = /obj/item/mecha_parts/micro/part/gopher_left_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/item/mechfab/gopher/right_leg
	name = "Gopher Right Leg"
	id = "gopher_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/gopher_right_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/item/mechfab/polecat
	category = list("Polecat")
	time = 10

/datum/design/item/mechfab/polecat/chassis
	name = "Polecat Chassis"
	id = "polecat_chassis"
	build_path = /obj/item/mecha_parts/micro/chassis/polecat
	time = 3
	materials = list(MAT_STEEL = 7000)

/datum/design/item/mechfab/polecat/torso
	name = "Polecat Torso"
	id = "polecat_torso"
	build_path = /obj/item/mecha_parts/micro/part/polecat_torso
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/design/item/mechfab/polecat/left_arm
	name = "Polecat Left Arm"
	id = "polecat_left_arm"
	build_path = /obj/item/mecha_parts/micro/part/polecat_left_arm
	materials = list(MAT_STEEL = 8750)

/datum/design/item/mechfab/polecat/right_arm
	name = "Polecat Right Arm"
	id = "polecat_right_arm"
	build_path = /obj/item/mecha_parts/micro/part/polecat_right_arm
	materials = list(MAT_STEEL = 8750)

/datum/design/item/mechfab/polecat/left_leg
	name = "Polecat Left Leg"
	id = "polecat_left_leg"
	build_path = /obj/item/mecha_parts/micro/part/polecat_left_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/item/mechfab/polecat/right_leg
	name = "Polecat Right Leg"
	id = "polecat_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/polecat_right_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/item/mechfab/polecat/armour
	name = "Polecat Armour Plates"
	id = "polecat_armour"
	build_path = /obj/item/mecha_parts/micro/part/polecat_armour
	time = 25
	materials = list(MAT_STEEL = 12500, MAT_PLASTIC = 7500)

/datum/design/item/mechfab/weasel
	category = list("Weasel")
	time = 5

/datum/design/item/mechfab/weasel/chassis
	name = "Weasel Chassis"
	id = "weasel_chassis"
	build_path = /obj/item/mecha_parts/micro/chassis/weasel
	time = 3
	materials = list(MAT_STEEL = 7000)

/datum/design/item/mechfab/weasel/torso
	name = "Weasel Torso"
	id = "weasel_torso"
	build_path = /obj/item/mecha_parts/micro/part/weasel_torso
	materials = list(MAT_STEEL = 15000, MAT_GLASS = 5250)

/datum/design/item/mechfab/weasel/left_arm
	name = "Weasel Left Arm"
	id = "weasel_left_arm"
	build_path = /obj/item/mecha_parts/micro/part/weasel_left_arm
	materials = list(MAT_STEEL = 8750)

/datum/design/item/mechfab/weasel/right_arm
	name = "Weasel Right Arm"
	id = "weasel_right_arm"
	build_path = /obj/item/mecha_parts/micro/part/weasel_right_arm
	materials = list(MAT_STEEL = 8750)

/*/datum/design/item/mechfab/weasel/left_leg
	name = "Weasel Left Leg"
	id = "weasel_left_leg"
	build_path = /obj/item/mecha_parts/micro/part/weasel_left_leg
	materials = list(MAT_STEEL = 12500)

/datum/design/item/mechfab/weasel/right_leg
	name = "Weasel Right Leg"
	id = "weasel_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/weasel_right_leg
	materials = list(MAT_STEEL = 12500)*/

/datum/design/item/mechfab/weasel/tri_leg
	name = "Weasel Tri Leg"
	id = "weasel_right_leg"
	build_path = /obj/item/mecha_parts/micro/part/weasel_tri_leg
	materials = list(MAT_STEEL = 27500)

/datum/design/item/mechfab/weasel/head
	name = "Weasel Head"
	id = "weasel_head"
	build_path = /obj/item/mecha_parts/micro/part/weasel_head
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 2500)

/datum/design/item/mecha/medigun
	name = "BL-3/P directed restoration system"
	desc = "A portable medical system used to treat external injuries from afar."
	id = "mech_medigun"
	req_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 5, TECH_BIO = 6)
	materials = list(MAT_STEEL = 8000, MAT_GOLD = 2000, MAT_SILVER = 1750, MAT_DIAMOND = 1500, MAT_PHORON = 4000)
	build_path = /obj/item/mecha_parts/mecha_equipment/weapon/energy/medigun
