//new micro parts define

/obj/item/mecha_parts/micro
	name = "mecha part"
	icon = 'icons/mecha/mech_construct_vr.dmi'
	icon_state = "blank"
	w_class = ITEMSIZE_NORMAL


/obj/item/mecha_parts/micro/chassis
	name="Mecha Chassis"
	icon_state = "backbone"
	var/datum/construction/construct

/obj/item/mecha_parts/micro/chassis/attackby(obj/item/W as obj, mob/user as mob)
	if(!construct || !construct.action(W, user))
		..()
	return

/obj/item/mecha_parts/micro/chassis/attack_hand()
	return

//Gopher
/obj/item/mecha_parts/micro/chassis/gopher
	name = "Gopher Chassis"
	icon_state = "gopher-chassis"

/obj/item/mecha_parts/micro/chassis/gopher/Initialize(mapload)
	. = ..()
	construct = new /datum/construction/mecha/gopher_chassis(src)

/obj/item/mecha_parts/micro/part/gopher_torso
	name="Gopher Torso"
	desc="A torso part of Gopher. Contains power unit, processing core and life support systems."
	icon_state = "gopher-torso"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_ENGINEERING = 2)

/obj/item/mecha_parts/micro/part/gopher_left_arm
	name="Gopher Left Arm"
	desc="A Gopher left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "gopher-arm-left"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/mecha_parts/micro/part/gopher_right_arm
	name="Gopher Right Arm"
	desc="A Gopher right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "gopher-arm-right"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/mecha_parts/micro/part/gopher_left_leg
	name="Gopher Left Leg"
	desc="A Gopher left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "gopher-leg-left"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

/obj/item/mecha_parts/micro/part/gopher_right_leg
	name="Gopher Right Leg"
	desc="A Gopher right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "gopher-leg-right"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)

//polecat
/obj/item/mecha_parts/micro/chassis/polecat
	name = "Polecat Chassis"
	icon_state = "polecat-chassis"

/obj/item/mecha_parts/micro/chassis/polecat/Initialize(mapload)
	. = ..()
	construct = new /datum/construction/mecha/polecat_chassis(src)

/obj/item/mecha_parts/micro/part/polecat_torso
	name="Polecat Torso"
	icon_state = "polecat-torso"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_BIO = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/micro/part/polecat_left_arm
	name="Polecat Left Arm"
	icon_state = "polecat-arm-left"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/micro/part/polecat_right_arm
	name="Polecat Right Arm"
	icon_state = "polecat-arm-right"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/micro/part/polecat_left_leg
	name="Polecat Left Leg"
	icon_state = "polecat-leg-left"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/micro/part/polecat_right_leg
	name="Polecat Right Leg"
	icon_state = "polecat-leg-right"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/micro/part/polecat_armour
	name="Polecat Armour Plates"
	icon_state = "polecat-armor"
	origin_tech = list(TECH_MATERIAL = 5, TECH_COMBAT = 4, TECH_ENGINEERING = 5)

//weasel
/obj/item/mecha_parts/micro/chassis/weasel
	name = "Weasel Chassis"
	icon_state = "weasel-chassis"

/obj/item/mecha_parts/micro/chassis/weasel/Initialize(mapload)
	. = ..()
	construct = new /datum/construction/mecha/weasel_chassis(src)

/obj/item/mecha_parts/micro/part/weasel_torso
	name="Weasel Torso"
	icon_state = "weasel-torso"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_BIO = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/micro/part/weasel_head
	name="Weasel Head"
	icon_state = "weasel-head"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/micro/part/weasel_left_arm
	name="Weasel Left Arm"
	icon_state = "weasel-arm-left"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/micro/part/weasel_right_arm
	name="Weasel Right Arm"
	icon_state = "weasel-arm-right"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/*/obj/item/mecha_parts/micro/part/weasel_left_leg
	name="Weasel Left Leg"
	icon_state = "weasel-leg-left"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/obj/item/mecha_parts/micro/part/weasel_right_leg
	name="Weasel Right Leg"
	icon_state = "weasel-leg-right"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)*/

/obj/item/mecha_parts/micro/part/weasel_tri_leg
	name="Weasel Legs"
	icon_state = "weasel-leg-all"
	origin_tech = list(TECH_DATA = 2, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
