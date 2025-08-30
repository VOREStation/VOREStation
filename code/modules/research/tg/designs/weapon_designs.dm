// Scene weapons
/datum/design_techweb/sizegun
	name = "Size Gun"
	id = "sizegun"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000)
	build_path = /obj/item/gun/energy/sizegun
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)

/datum/design_techweb/sizegun_gradual
	name = "Gradual Size Gun"
	id = "gradsizegun"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 2000)
	build_path = /obj/item/slow_sizegun
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)

// Energy weapons
/datum/design_techweb/stunrevolver
	name = "Stun Revolver"
	id = "stunrevolver"
	// req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/gun/energy/stunrevolver
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/nuclear_gun
	name = "Nuclear Gun"
	id = "nuclear_gun"
	// req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000, MAT_URANIUM = 500)
	build_path = /obj/item/gun/energy/gun/nuclear
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/phoronpistol
	name = "Phoron Pistol"
	id = "ppistol"
	// req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000, MAT_PHORON = 3000)
	build_path = /obj/item/gun/energy/toxgun
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/lasercannon
	name = "Laser Cannon"
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	id = "lasercannon"
	// req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/gun/energy/lasercannon
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/decloner
	name = "Decloner"
	id = "decloner"
	// req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	build_type = PROTOLATHE
	materials = list(MAT_GOLD = 5000,MAT_URANIUM = 10000)
	build_path = /obj/item/gun/energy/decloner
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/temp_gun
	name = "Temperature Gun"
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	id = "temp_gun"
	// req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 500, MAT_SILVER = 3000)
	build_path = /obj/item/gun/energy/temperature
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/flora_gun
	name = "Flora Gun"
	id = "flora_gun"
	// req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 500, MAT_URANIUM = 500)
	build_path = /obj/item/gun/energy/floragun
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/vinstunrevolver
	name = "Vintage Stun Revolver"
	id = "vinstunrevolver"
	// req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/gun/energy/stunrevolver/vintage
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

// Ballistic weapons
/datum/design_techweb/advanced_smg
	name = "Advanced 9mm SMG"
	id = "smg"
	desc = "An advanced 9mm SMG with a reflective laser optic."
	// req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 8000, MAT_SILVER = 2000, MAT_DIAMOND = 1000)
	build_path = /obj/item/gun/projectile/automatic/advanced_smg
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

// Ballistic ammo
/datum/design_techweb/ammo_9mmAdvanced
	name = "9mm magazine"
	id = "ammo_9mm"
	desc = "A 21 round magazine for an advanced 9mm SMG."
	// req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 3750, MAT_SILVER = 100) // Requires silver for proprietary magazines! Or something.
	build_path = /obj/item/ammo_magazine/m9mmAdvanced
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/stunshell
	name = "stun shells"
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	// req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/stunshell
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/empshell
	name = "emp shells"
	desc = "An electromagnetic shell for a shotgun."
	id = "empshell"
	// req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000, MAT_URANIUM = 1000)
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/emp
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

// Other weapons
/datum/design_techweb/rapidsyringe
	name = "Rapid Syringe Gun"
	id = "rapidsyringe"
	// req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000)
	build_path = /obj/item/gun/launcher/syringe/rapid
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/dartgun
	name = "Dartgun"
	desc = "A gun that fires small hollow chemical-payload darts."
	id = "dartgun_r"
	// req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_BIO = 4, TECH_MAGNET = 3, TECH_ILLEGAL = 1)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GOLD = 5000, MAT_SILVER = 2500, MAT_GLASS = 750)
	build_path = /obj/item/gun/projectile/dartgun/research
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/chemsprayer
	name = "Chemsprayer"
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	// req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000)
	build_path = /obj/item/reagent_containers/spray/chemsprayer
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/fuelrod
	name = "Fuel-Rod Cannon"
	id = "fuelrod_gun"
	// req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_PHORON = 4, TECH_ILLEGAL = 5, TECH_MAGNET = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 2000, MAT_GOLD = 500, MAT_SILVER = 500, MAT_URANIUM = 1000, MAT_PHORON = 3000, MAT_DIAMOND = 1000)
	build_path = /obj/item/gun/magnetic/fuelrod
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

// Ammo for those

/datum/design_techweb/dartgunmag_small
	name = "Dartgun Magazine (Small)"
	id = "dartgun_mag_s"
	// req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 300, MAT_GOLD = 100, MAT_SILVER = 100, MAT_GLASS = 300)
	build_path = /obj/item/ammo_magazine/chemdart/small
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

	research_icon = 'icons/obj/ammo.dmi'
	research_icon_state = "darts_small-3"

/datum/design_techweb/dartgun_ammo_small
	name = "Dartgun Ammo (Small)"
	id = "dartgun_ammo_s"
	// req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 50, MAT_GOLD = 30, MAT_SILVER = 30, MAT_GLASS = 50)
	build_path = /obj/item/ammo_casing/chemdart/small
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

	research_icon = 'icons/obj/ammo.dmi'
	research_icon_state = "darts_small-3"

/datum/design_techweb/dartgunmag_med
	name = "Dartgun Magazine (Chem)"
	id = "dartgun_mag_m"
	// req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 500, MAT_GOLD = 150, MAT_SILVER = 150, MAT_DIAMOND = 200, MAT_GLASS = 400)
	build_path = /obj/item/ammo_magazine/chemdart
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/dartgun_ammo_med
	name = "Dartgun Ammo (Chem)"
	id = "dartgun_ammo_m"
	// req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 80, MAT_GOLD = 40, MAT_SILVER = 40, MAT_GLASS = 60)
	build_path = /obj/item/ammo_casing/chemdart
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/flechette
	name = "Fletchette Magazine"
	id = "magnetic_ammo"
	// req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 500, MAT_GOLD = 300, MAT_GLASS = 150, MAT_PHORON = 100)
	build_path = /obj/item/magnetic_ammo
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

// Melee weapons
/datum/design_techweb/esword
	name = "Portable Energy Blade"
	id = "chargesword"
	// req_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 4, TECH_ENGINEERING = 5, TECH_ILLEGAL = 4, TECH_ARCANE = 1)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTEEL = 3500, MAT_GLASS = 1000, MAT_LEAD = 2250, MAT_METALHYDROGEN = 500)
	build_path = /obj/item/melee/energy/sword/charge
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_MELEE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/eaxe
	name = "Energy Axe"
	id = "chargeaxe"
	// req_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 5, TECH_ENGINEERING = 4, TECH_ILLEGAL = 4)
	build_type = PROTOLATHE
	materials = list(MAT_PLASTEEL = 3500, MAT_OSMIUM = 2000, MAT_LEAD = 2000, MAT_METALHYDROGEN = 500)
	build_path = /obj/item/melee/energy/axe/charge
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_MELEE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

// Grenade stuff
/datum/design_techweb/large_grenade
	name = "Large Grenade"
	id = "large_Grenade"
	// req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/grenade/chem_grenade/large
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

// Energy Weapons
/datum/design_techweb/protector
	name = "Protector"
	desc = "The 'Protector' is an advanced energy gun that cannot be fired in lethal mode on low security alert levels, but features DNA locking and a powerful stun."
	id = "protector"
	// req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 2000, MAT_SILVER = 1000)
	build_path = /obj/item/gun/energy/gun/protector
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/sickshot
	name = "Sickshot"
	desc = "A 'Sickshot' is a 4-shot energy revolver that causes nausea and confusion."
	id = "sickshot"
	// req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 2000)
	build_path = /obj/item/gun/energy/sickshot
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/netgun
	name = "Varmint Catcher"
	desc  = "The \"Varmint Catcher\" is an energy net projector designed to immobilize dangerous wildlife."
	id = "netgun"
	// req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_MAGNET = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 3000)
	build_path = /obj/item/gun/energy/netgun
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/sizenetgun
	name = "Varmint Compactor"
	desc  = "The \"Varmint Compactor\" is an energy net projector designed to immobilize its targets while simultaneously reducing them to a more manageable size."
	id = "sizenetgun"
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 4000)
	build_path = /obj/item/gun/energy/netgun
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

// Misc weapons

/datum/design_techweb/pummeler
	name = "Pummeler"
	desc = "With the 'Pummeler', punt anyone you don't like out of the room!"
	id = "pummeler"
	// req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_MAGNET = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 3000, MAT_URANIUM = 1000)
	build_path = /obj/item/gun/energy/pummeler
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

// Anti-particle stuff
/datum/design_techweb/advparticle
	name = "Advanced anti-particle rifle"
	id = "advparticle"
	// req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 5, TECH_POWER = 3, TECH_MAGNET = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000, MAT_GOLD = 1000, MAT_URANIUM = 750)
	build_path = /obj/item/gun/energy/particle/advanced
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/particlecannon
	name = "Anti-particle cannon"
	id = "particlecannon"
	// req_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 5, TECH_POWER = 4, TECH_MAGNET = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 1500, MAT_GOLD = 2000, MAT_URANIUM = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/gun/energy/particle/cannon
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/pressureinterlock
	name = "APP pressure interlock"
	desc = "A safety interlock that can be installed in an antiparticle projector. It prevents the weapon from discharging in pressurised environments."
	id = "pressureinterlock"
	// req_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 250)
	build_path = /obj/item/pressurelock
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_FIRING_PINS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

// NSFW gun and cells
/datum/design_techweb/cell_based/prototype_nsfw
	name = "cell-loaded revolver"
	id = "nsfw_prototype"
	// req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 7)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 6000, MAT_PHORON = 8000, MAT_URANIUM = 4000)
	build_path = /obj/item/gun/projectile/cell_loaded/combat/prototype
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/cell_based/prototype_nsfw_mag
	name = "microbattery magazine"
	id = "nsfw_mag_prototype"
	// req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 4, TECH_COMBAT = 7)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 4000, MAT_PHORON = 4000)
	build_path = /obj/item/ammo_magazine/cell_mag/combat/prototype
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/stun
	name = "microbattery (STUN)"
	id = "nsfw_cell_stun"
	// req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 2, TECH_POWER = 3, TECH_COMBAT = 3)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000)
	build_path = /obj/item/ammo_casing/microbattery/combat/stun
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/lethal
	name = "microbattery (LETHAL)"
	id = "nsfw_cell_lethal"
	// req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PHORON = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/lethal
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/net
	name = "microbattery (NET)"
	id = "nsfw_cell_net"
	// req_tech = list(TECH_MATERIAL = 4, TECH_MAGNET = 3, TECH_POWER = 3, TECH_COMBAT = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_URANIUM = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/net
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ion
	name = "microbattery (ION)"
	id = "nsfw_cell_ion"
	// req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 5, TECH_COMBAT = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 3000)
	build_path = /obj/item/ammo_casing/microbattery/combat/ion
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/shotstun
	name = "microbattery (SCATTERSTUN)"
	id = "nsfw_cell_shotstun"
	// req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 6, TECH_COMBAT = 6)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 2000, MAT_GOLD = 2000)
	build_path = /obj/item/ammo_casing/microbattery/combat/shotstun
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/xray
	name = "microbattery (XRAY)"
	id = "nsfw_cell_xray"
	// req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 5, TECH_COMBAT = 7)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 1000, MAT_GOLD = 1000, MAT_URANIUM = 1000, MAT_PHORON = 1000)
	build_path = /obj/item/ammo_casing/microbattery/combat/xray
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/stripper
	name = "microbattery (STRIPPER)"
	id = "nsfw_cell_stripper"
	// req_tech = list(TECH_MATERIAL = 7, TECH_BIO = 4, TECH_POWER = 4, TECH_COMBAT = 4, TECH_ILLEGAL = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_URANIUM = 2000, MAT_PHORON = 2000, MAT_DIAMOND = 500)
	build_path = /obj/item/ammo_casing/microbattery/combat/stripper
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ptrshell
	name = "14.5mm shell"
	desc = "A dense-core projectile fired from a small cannon."
	id = "ptrshell"
	// req_tech = list(TECH_COMBAT = 7, TECH_ILLEGAL = 4)
	build_type = PROTOLATHE
	materials = list(MAT_TITANIUM = 4000, MAT_URANIUM = 500, MAT_PLASTEEL = 500)
	build_path = /obj/item/ammo_casing/a145
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

//General stuff
/datum/design_techweb/recombobray
	name = "recombobulation ray"
	desc = "The Type Gamma Medical Recombobulation ray! A mysterious looking ray gun! It works to change people who have had their form significantly altered back into their original forms!"
	id = "recombobray"
	// req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_POWER = 4, TECH_BIO = 5, TECH_BLUESPACE = 4) //Not like these matter. *Glares at circuit printer.*
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 2000, MAT_URANIUM = 500, MAT_PHORON = 1500)
	build_path = /obj/item/gun/energy/mouseray/medical
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

// ML-3M medigun and cells
/datum/design_techweb/cell_medigun
	name = "cell-loaded medigun"
	id = "cell_medigun"
	// req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 3, TECH_BIO = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 8000, MAT_PLASTIC = 8000, MAT_GLASS = 5000, MAT_SILVER = 1000, MAT_GOLD = 1000, MAT_URANIUM = 1000)
	build_path = /obj/item/gun/projectile/cell_loaded/medical
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/cell_medigun_mag
	name = "medical cell magazine"
	id = "cell_medigun_mag"
	// req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 3, TECH_BIO = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000, MAT_PLASTIC = 6000, MAT_GLASS = 3000, MAT_SILVER = 500, MAT_GOLD = 500)
	build_path = /obj/item/ammo_magazine/cell_mag/medical
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/cell_medigun_mag_advanced
	name = "advanced medical cell magazine"
	id = "cell_medigun_mag_advanced"
	// req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 4, TECH_BIO = 7)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_PLASTIC = 10000, MAT_GLASS = 5000, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_DIAMOND = 5000)
	build_path = /obj/item/ammo_magazine/cell_mag/medical/advanced
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

//Tier 0
/datum/design_techweb/ml3m_brute
	name = "Nanite Cell Prototype (BRUTE)"
	id = "ml3m_cell_brute"
	// req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000)
	build_path = /obj/item/ammo_casing/microbattery/medical/brute
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_burn
	name = "Nanite Cell Prototype (BURN)"
	id = "ml3m_cell_burn"
	// req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000)
	build_path = /obj/item/ammo_casing/microbattery/medical/burn
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_stabilize
	name = "Nanite Cell Prototype (STABILIZE)"
	id = "ml3m_cell_stabilize"
	// req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000)
	build_path = /obj/item/ammo_casing/microbattery/medical/stabilize
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

//Tier 1

/datum/design_techweb/ml3m_toxin
	name = "Nanite Cell Prototype (TOXIN)"
	id = "ml3m_cell_toxin"
	// req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_omni
	name = "Nanite Cell Prototype (OMNI)"
	id = "ml3m_cell_omni"
	// req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_antirad
	name = "Nanite Cell Prototype (ANTIRAD)"
	id = "ml3m_cell_antirad"
	// req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500)
	build_path = /obj/item/ammo_casing/microbattery/medical/antirad
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

//Tier 2

/datum/design_techweb/ml3m_brute2
	name = "Nanite Cell Prototype (BRUTE)-II"
	id = "ml3m_cell_brute2"
	// req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_GOLD = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/brute2
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_burn2
	name = "Nanite Cell Prototype (BURN)-II"
	id = "ml3m_cell_burn2"
	// req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_GOLD = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/burn2
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_stabilize2
	name = "Nanite Cell Prototype (STABILIZE)-II"
	id = "ml3m_cell_stabilize2"
	// req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_SILVER = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/stabilize2
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_omni2
	name = "Nanite Cell Prototype (OMNI)-II"
	id = "ml3m_cell_omni2"
	// req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_URANIUM = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni2
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

//Tier 3

/datum/design_techweb/ml3m_toxin2
	name = "Nanite Cell Prototype (TOXIN)-II"
	id = "ml3m_cell_toxin2"
	// req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_URANIUM = 1000, MAT_SILVER = 1000, MAT_DIAMOND = 500)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin2
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_haste
	name = "Nanite Cell Prototype (HASTE)"
	id = "ml3m_cell_haste"
	// req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_GOLD = 1000, MAT_SILVER = 1000, MAT_DIAMOND = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/haste
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_resist
	name = "Nanite Cell Prototype (RESIST)"
	id = "ml3m_cell_resist"
	// req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_GOLD = 1000, MAT_URANIUM = 1000, MAT_DIAMOND = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/resist
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_corpse_mend
	name = "Nanite Cell Prototype (CORPSE) MEND"
	id = "ml3m_cell_corpse_mend"
	// req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_PHORON = 3000, MAT_DIAMOND = 3000)
	build_path = /obj/item/ammo_casing/microbattery/medical/corpse_mend
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

//Tier 4

/datum/design_techweb/ml3m_brute3
	name = "Nanite Cell Prototype (BRUTE)-III"
	id = "ml3m_cell_brute3"
	// req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_PRECURSOR = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_DIAMOND = 500, MAT_VERDANTIUM = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/brute3
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_burn3
	name = "Nanite Cell Prototype (BURN)-III"
	id = "ml3m_cell_burn3"
	// req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_PRECURSOR = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_DIAMOND = 500, MAT_VERDANTIUM = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/burn3
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_toxin3
	name = "Nanite Cell Prototype (TOXIN)-III"
	id = "ml3m_cell_toxin3"
	// req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_ARCANE = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_DIAMOND = 500, MAT_VERDANTIUM = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin3
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_omni3
	name = "Nanite Cell Prototype (OMNI)-III"
	id = "ml3m_cell_omni3"
	// req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_ARCANE = 2)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_DIAMOND = 500, MAT_VERDANTIUM = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni3
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

//Tierless

/datum/design_techweb/ml3m_shrink
	name = "Nanite Cell Prototype (SHRINK)"
	id = "ml3m_cell_shrink"
	// req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_URANIUM = 2000)
	build_path = /obj/item/ammo_casing/microbattery/medical/shrink
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_grow
	name = "Nanite Cell Prototype (GROW)"
	id = "ml3m_cell_grow"
	// req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_URANIUM = 2000)
	build_path = /obj/item/ammo_casing/microbattery/medical/grow
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/ml3m_normalsize
	name = "Nanite Cell Prototype (NORMALSIZE)"
	id = "ml3m_cell_normalsize"
	// req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_URANIUM = 2000)
	build_path = /obj/item/ammo_casing/microbattery/medical/normalsize
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_AMMO
	)
	departmental_flags = DEPARTMENT_BITFLAG_MEDICAL | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/upgradeAOE
	name = "Mining Explosion Upgrade"
	desc = "An area of effect upgrade for the Proto-Kinetic Accelerator."
	id = "pka_mineaoe"
	// req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 8, TECH_ENGINEERING = 7) // Lets make this endgame level tech, due to it's power.
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_SILVER = 500, MAT_GOLD = 500, MAT_URANIUM = 2000, MAT_PHORON = 2000)
	build_path = /obj/item/borg/upgrade/modkit/aoe/turfs
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_PARTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE | DEPARTMENT_BITFLAG_CARGO

/datum/design_techweb/riflescope
	name = "rifle scope"
	desc = "A scope that can be mounted to certain rifles."
	id = "riflescope"
	// req_tech = list(TECH_ILLEGAL = 2, TECH_MATERIAL = 2)
	build_type = PROTOLATHE
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/binoculars/scope
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_PARTS
	)
	departmental_flags = DEPARTMENT_BITFLAG_SECURITY | DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/slimebaton
	name = "Slime Baton"
	id = "slimebaton"
	// req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2, TECH_POWER = 3, TECH_COMBAT = 3)
	build_type = PROTOLATHE
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000)
	build_path = /obj/item/melee/baton/slime
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_MELEE
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/slimetaser
	name = "Slime Taser"
	id = "slimetaser"
	// req_tech = list(TECH_MATERIAL = 3, TECH_BIO = 3, TECH_POWER = 4, TECH_COMBAT = 4)
	build_type = PROTOLATHE
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 5000)
	build_path = /obj/item/gun/energy/taser/xeno
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/monkey_gun
	name = "Bluespace Monkey Deployment System"
	desc = "An Advanced monkey teleportation and rehydration system. For serious monkey business."
	id = "monkey_gun"
	// req_tech = list(TECH_BIO = 6, TECH_BLUESPACE = 5)
	build_type = PROTOLATHE
	build_type = PROTOLATHE
	materials = list(MAT_STEEL = 3500, MAT_GLASS = 3500, MAT_PHORON = 1500, MAT_DIAMOND = 1500)
	build_path = /obj/item/xenobio/monkey_gun
	category = list(
		RND_CATEGORY_WEAPONS + RND_SUBCATEGORY_WEAPONS_RANGED
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE
