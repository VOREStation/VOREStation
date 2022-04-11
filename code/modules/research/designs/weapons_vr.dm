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
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_SILVER = 1000)
	build_path = /obj/item/weapon/gun/energy/gun/protector
	sort_string = "MAAVA"

/datum/design/item/weapon/energy/sickshot
	desc = "A 'Sickshot' is a 4-shot energy revolver that causes nausea and confusion."
	id = "sickshot"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 2000)
	build_path = /obj/item/weapon/gun/energy/sickshot
	sort_string = "MAAVB"

/datum/design/item/weapon/energy/netgun
	desc  = "The \"Varmint Catcher\" is an energy net projector designed to immobilize dangerous wildlife."
	id = "netgun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 3000)
	build_path = /obj/item/weapon/gun/energy/netgun
	sort_string = "MAAVC"

// Misc weapons

/datum/design/item/weapon/pummeler
	desc = "With the 'Pummeler', punt anyone you don't like out of the room!"
	id = "pummeler"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 3000, MAT_URANIUM = 1000)
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
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000, MAT_GOLD = 1000, MAT_URANIUM = 750)
	build_path = /obj/item/weapon/gun/energy/particle/advanced
	sort_string = "MAAUA"

/datum/design/item/weapon/particle/particlecannon
	name = "Anti-particle cannon"
	id = "particlecannon"
	req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_POWER = 4, TECH_MAGNET = 4)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 1500, MAT_GOLD = 2000, MAT_URANIUM = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/weapon/gun/energy/particle/cannon
	sort_string = "MAAUB"

/datum/design/item/weapon/particle/pressureinterlock
	name = "APP pressure interlock"
	id = "pressureinterlock"
	req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 250)
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
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 6000, MAT_PHORON = 8000, MAT_URANIUM = 4000)
	build_path = /obj/item/weapon/gun/projectile/cell_loaded/combat/prototype
	sort_string = "MAVAA"

/datum/design/item/weapon/cell_based/prototype_nsfw_mag
	name = "combat cell magazine"
	id = "nsfw_mag_prototype"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 7)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 4000, MAT_PHORON = 4000)
	build_path = /obj/item/ammo_magazine/cell_mag/combat/prototype
	sort_string = "MAVBA"

/datum/design/item/nsfw_cell/AssembleDesignName()
	..()
	name = "Microbattery prototype ([name])"

/datum/design/item/nsfw_cell/stun
	name = "STUN"
	id = "nsfw_cell_stun"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_POWER = 3, TECH_COMBAT = 3)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000)
	build_path = /obj/item/ammo_casing/microbattery/combat/stun
	sort_string = "MAVCA"

/datum/design/item/nsfw_cell/lethal
	name = "LETHAL"
	id = "nsfw_cell_lethal"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PHORON = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/lethal
	sort_string = "MAVCB"

/datum/design/item/nsfw_cell/net
	name = "NET"
	id = "nsfw_cell_net"
	req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 4)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_URANIUM = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/net
	sort_string = "MAVCC"

/datum/design/item/nsfw_cell/ion
	name = "ION"
	id = "nsfw_cell_ion"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 5, TECH_COMBAT = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/ion
	sort_string = "MAVCD"

/datum/design/item/nsfw_cell/shotstun
	name = "SCATTERSTUN"
	id = "nsfw_cell_shotstun"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 6, TECH_COMBAT = 6)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 2000, MAT_GOLD = 2000)
	build_path = /obj/item/ammo_casing/microbattery/combat/shotstun
	sort_string = "MAVCE"

/datum/design/item/nsfw_cell/xray
	name = "XRAY"
	id = "nsfw_cell_xray"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 5, TECH_COMBAT = 7)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 1000, MAT_GOLD = 1000, MAT_URANIUM = 1000, MAT_PHORON = 1000)
	build_path = /obj/item/ammo_casing/microbattery/combat/xray
	sort_string = "MAVCF"

/datum/design/item/nsfw_cell/stripper
	name = "STRIPPER"
	id = "nsfw_cell_stripper"
	req_tech = list(TECH_MATERIAL = 7, TECH_BIO = 4, TECH_POWER = 4, TECH_COMBAT = 4, TECH_ILLEGAL = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_URANIUM = 2000, MAT_PHORON = 2000, MAT_DIAMOND = 500)
	build_path = /obj/item/ammo_casing/microbattery/combat/stripper
	sort_string = "MAVCG"

/datum/design/item/weapon/ballistic/ammo/ptrshell
	name = "14.5mm shell"
	desc = "A dense-core projectile fired from a small cannon."
	id = "ptrshell"
	req_tech = list(TECH_COMBAT = 7, TECH_ILLEGAL = 4)
	materials = list(MAT_TITANIUM = 4000, MAT_URANIUM = 500, MAT_PLASTEEL = 500)
	build_path = /obj/item/ammo_casing/a145
	sort_string = "MABBD"

/*
/datum/design/item/nsfw_cell/final
	name = "FINAL OPTION"
	id = "nsfw_cell_final"
	req_tech = list(TECH_COMBAT = 69, TECH_ILLEGAL = 69, TECH_PRECURSOR = 1)
	materials = list("unobtanium" = 9001)
	build_path = /obj/item/ammo_casing/microbattery/combat/final
	sort_string = "MAVCH"
*/
