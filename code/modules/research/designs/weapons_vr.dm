/*
	MAU - AP weapons
	MAV - cell-loaded weapons
	MAVA - weapon
	MAVB - cartridge
	MAVC - cells
*/


// Energy Weapons

/datum/design/item/weapon/energy/protector
	desc = "The 'Protector' is an advanced energy gun that cannot be fired in lethal mode on low security alert levels, but features DNA locking and a powerful stun."
	id = "protector"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 4000, "glass" = 2000, "silver" = 1000)
	build_path = /obj/item/weapon/gun/energy/protector
	sort_string = "MAAVA"

/datum/design/item/weapon/energy/sickshot
	desc = "A 'Sickshot' is a 4-shot energy revolver that causes nausea and confusion."
	id = "sickshot"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 2000)
	build_path = /obj/item/weapon/gun/energy/sickshot
	sort_string = "MAAVB"

/datum/design/item/weapon/energy/netgun
	name = "\'Hunter\' capture gun"
	id = "netgun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 6000, "glass" = 3000)
	build_path = /obj/item/weapon/gun/energy/netgun
	sort_string = "MAAVC"

// Misc weapons

/datum/design/item/weapon/pummeler
	desc = "With the 'Pummeler', punt anyone you don't like out of the room!"
	id = "pummeler"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 3000, "uranium" = 1000)
	build_path = /obj/item/weapon/gun/energy/pummeler
	sort_string = "MADVA"

// Anti-particle stuff

/datum/design/item/weapon/particle/AssembleDesignName()
	..()
	name = "Anti-particle weapon prototype ([item_name])"

/datum/design/item/weapon/particle/advparticle
	name = "Advanced anti-particle rifle"
	id = "advparticle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 3, TECH_MAGNET = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 1000, "gold" = 1000, "uranium" = 750)
	build_path = /obj/item/weapon/gun/energy/particle/advanced
	sort_string = "MAAUA"

/datum/design/item/weapon/particle/particlecannon
	name = "Anti-particle cannon"
	id = "particlecannon"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_POWER = 4, TECH_MAGNET = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 1500, "gold" = 2000, "uranium" = 1000, "diamond" = 2000)
	build_path = /obj/item/weapon/gun/energy/particle/cannon
	sort_string = "MAAUB"

/datum/design/item/weapon/particle/pressureinterlock
	name = "APP pressure interlock"
	id = "pressureinterlock"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 250)
	build_path = /obj/item/pressurelock
	sort_string = "MAAUC"

// NSFW gun and cells
/datum/design/item/weapon/cell_based/AssembleDesignName()
	..()
	name = "Cell-based weapon prototype ([item_name])"

/datum/design/item/weapon/cell_based/prototype_nsfw
	name = "cell-loaded revolver"
	id = "nsfw_prototype"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 6000, "phoron" = 8000, "uranium" = 4000)
	build_path = /obj/item/weapon/gun/projectile/cell_loaded/combat/prototype
	sort_string = "MAVAA"

/datum/design/item/weapon/cell_based/prototype_nsfw_mag
	name = "combat cell magazine"
	id = "nsfw_mag_prototype"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 8000, "glass" = 4000, "phoron" = 4000)
	build_path = /obj/item/ammo_magazine/cell_mag/combat/prototype
	sort_string = "MAVBA"

/datum/design/item/nsfw_cell/AssembleDesignName()
	..()
	name = "Microbattery prototype ([name])"

/datum/design/item/nsfw_cell/stun
	name = "STUN"
	id = "nsfw_cell_stun"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_POWER = 3, TECH_COMBAT = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000)
	build_path = /obj/item/ammo_casing/microbattery/combat/stun
	sort_string = "MAVCA"

/datum/design/item/nsfw_cell/lethal
	name = "LETHAL"
	id = "nsfw_cell_lethal"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "phoron" = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/lethal
	sort_string = "MAVCB"

/datum/design/item/nsfw_cell/net
	name = "NET"
	id = "nsfw_cell_net"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 4)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "uranium" = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/net
	sort_string = "MAVCC"

/datum/design/item/nsfw_cell/ion
	name = "ION"
	id = "nsfw_cell_ion"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "silver" = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/ion
	sort_string = "MAVCD"

/datum/design/item/nsfw_cell/shotstun
	name = "SCATTERSTUN"
	id = "nsfw_cell_shotstun"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 6, TECH_COMBAT = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "silver" = 2000, "gold" = 2000)
	build_path = /obj/item/ammo_casing/microbattery/combat/shotstun
	sort_string = "MAVCE"

/datum/design/item/nsfw_cell/xray
	name = "XRAY"
	id = "nsfw_cell_xray"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 5, TECH_COMBAT = 7)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "silver" = 1000, "gold" = 1000, "uranium" = 1000, "phoron" = 1000)
	build_path = /obj/item/ammo_casing/microbattery/combat/xray
	sort_string = "MAVCF"

/datum/design/item/nsfw_cell/stripper
	name = "STRIPPER"
	id = "nsfw_cell_stripper"
	req_tech = list(TECH_MATERIAL = 7, TECH_BIO = 4, TECH_POWER = 4, TECH_COMBAT = 4, TECH_ILLEGAL = 5)
	materials = list(DEFAULT_WALL_MATERIAL = 5000, "glass" = 5000, "uranium" = 2000, "phoron" = 2000, "diamond" = 500)
	build_path = /obj/item/ammo_casing/microbattery/combat/stripper
	sort_string = "MAVCG"

/*
/datum/design/item/nsfw_cell/final
	name = "FINAL OPTION"
	id = "nsfw_cell_final"
	req_tech = list(TECH_COMBAT = 69, TECH_ILLEGAL = 69, TECH_PRECURSOR = 1)
	materials = list("unobtanium" = 9001)
	build_path = /obj/item/ammo_casing/microbattery/combat/final
	sort_string = "MAVCH"
*/