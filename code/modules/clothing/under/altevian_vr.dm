/obj/item/clothing/under/pants/altevian
	name = "Altevian Hegemony Civilian Pants"
	desc = "A comfortable set of clothing for people to handle their day to day work around the fleets with little to no discomfort."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "altevian-pants-civ"
	worn_state = "altevian-pants-civ"
	gender = PLURAL
	body_parts_covered = LOWER_TORSO|LEGS
	starting_accessories = list(/obj/item/clothing/accessory/jacket/altevian)

/obj/item/clothing/under/pants/altevian/command
	name = "Altevian Hegemony Command Pants"
	icon_state = "altevian-pants-com"
	worn_state = "altevian-pants-com"
	starting_accessories = list(/obj/item/clothing/accessory/jacket/altevian/command)

/obj/item/clothing/under/pants/altevian/security
	name = "Altevian Hegemony Security Pants"
	icon_state = "altevian-pants-sec"
	worn_state = "altevian-pants-sec"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	starting_accessories = list(/obj/item/clothing/accessory/jacket/altevian/security)

/obj/item/clothing/under/pants/altevian/engineering
	name = "Altevian Hegemony Engineering Pants"
	icon_state = "altevian-pants-eng"
	worn_state = "altevian-pants-eng"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 10)
	starting_accessories = list(/obj/item/clothing/accessory/jacket/altevian/engineering)

/obj/item/clothing/under/pants/altevian/medical
	name = "Altevian Hegemony Medical Pants"
	icon_state = "altevian-pants-med"
	worn_state = "altevian-pants-med"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	starting_accessories = list(/obj/item/clothing/accessory/jacket/altevian/medical)

/obj/item/clothing/under/pants/altevian/science
	name = "Altevian Hegemony Science Pants"
	icon_state = "altevian-pants-sci"
	worn_state = "altevian-pants-sci"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)
	starting_accessories = list(/obj/item/clothing/accessory/jacket/altevian/science)

/obj/item/clothing/under/pants/altevian/cargo
	name = "Altevian Hegemony Cargo Pants"
	icon_state = "altevian-pants-cargo"
	worn_state = "altevian-pants-cargo"
	starting_accessories = list(/obj/item/clothing/accessory/jacket/altevian/cargo)

/obj/item/clothing/under/altevian
	name = "Altevian Duty Jumpsuit"
	desc = "A uniform commonly seen worn by altevians. The material on this uniform is made of a durable thread that can handle the stress of most forms of labor."
	icon = 'icons/inventory/uniform/item_vr.dmi'
	icon_override = 'icons/inventory/uniform/mob_vr.dmi'
	icon_state = "altevian-specialist"
	worn_state = "altevian-specialist"
	species_restricted = list(SPECIES_ALTEVIAN)

/obj/item/clothing/under/altevian/sci
	name = "Altevian Science Duty Jumpsuit"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 10, bio = 0, rad = 0)
	icon_state = "altevian-specialist-sci"
	worn_state = "altevian-specialist-sci"

/obj/item/clothing/under/altevian/med
	name = "Altevian Medical Duty Jumpsuit"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 10, rad = 0)
	icon_state = "altevian-specialist-med"
	worn_state = "altevian-specialist-med"

/obj/item/clothing/under/altevian/sec
	name = "Altevian Security Duty Jumpsuit"
	armor = list(melee = 10, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	icon_state = "altevian-specialist-sec"
	worn_state = "altevian-specialist-sec"

/obj/item/clothing/under/altevian/eng
	name = "Altevian Engineering Duty Jumpsuit"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 10)
	icon_state = "altevian-specialist-eng"
	worn_state = "altevian-specialist-eng"
