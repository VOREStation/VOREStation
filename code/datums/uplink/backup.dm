/*********
* Back up *
**********/
/datum/uplink_item/item/backup
	category = /datum/uplink_category/backup
	blacklisted = 1

/datum/uplink_item/item/backup/syndicate_drone_protector
	name = "Drone (Protector)"
	desc = "A miniature teleport which will bring a powerful and loyal drone to you.  \
	This type comes with a directional shield projector, a supressive fire energy weapon, \
	a stunbaton, handcuffs, an agent ID, energy sword, pinpointer, and a jetpack."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT * 1.5
	antag_roles = list("mercenary")
	path = /obj/item/weapon/antag_spawner/syndicate_drone/protector

/datum/uplink_item/item/backup/syndicate_drone_combat_medic
	name = "Drone (Combat Medic)"
	desc = "A miniature teleport which will bring a powerful and loyal drone to you.  \
	This type comes with standard medical equipment, full set of surgery tools, \
	a powerful hypospray that can create many potent chemicals, an agent ID, energy \
	sword, pinpointer, and a jetpack."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT * 1.5
	antag_roles = list("mercenary")
	path = /obj/item/weapon/antag_spawner/syndicate_drone/combat_medic

/datum/uplink_item/item/backup/syndicate_drone_mechanist
	name = "Drone (Mechanist)"
	desc = "A miniature teleport which will bring a powerful and loyal drone to you.  \
	This type comes with a full set of tools, an RCD, the ability to unlock other bound synthetics, \
	a cryptographic sequencer, an AI detector, the ability to analyze and repair full-body prosthetics, \
	a set of construction materials, an ionic rapier, an agent ID, energy sword, pinpointer, and a jetpack."
	item_cost = DEFAULT_TELECRYSTAL_AMOUNT * 1.5
	antag_roles = list("mercenary")
	path = /obj/item/weapon/antag_spawner/syndicate_drone/mechanist