/datum/design/item/AssembleDesignName()
	..()
	name = "Weapon prototype ([item_name])"

/datum/design/item/ammo/AssembleDesignName()
	..()
	name = "Weapon ammo prototype ([item_name])"

/datum/design/item/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()

// Energy weapons

/datum/design/item/energy/AssembleDesignName()
	..()
	name = "Energy weapon prototype ([item_name])"

/datum/design/item/energy/stunrevolver
	id = "stunrevolver"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/gun/energy/stunrevolver
	sort_string = "MAAAA"

/datum/design/item/energy/nuclear_gun
	id = "nuclear_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000, MAT_URANIUM = 500)
	build_path = /obj/item/gun/energy/gun/nuclear
	sort_string = "MAAAB"

/datum/design/item/energy/phoronpistol
	id = "ppistol"
	req_tech = list(TECH_COMBAT = 5, TECH_PHORON = 4)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000, MAT_PHORON = 3000)
	build_path = /obj/item/gun/energy/toxgun
	sort_string = "MAAAC"

/datum/design/item/energy/lasercannon
	desc = "The lasing medium of this prototype is enclosed in a tube lined with uranium-235 and subjected to high neutron flux in a nuclear reactor core."
	id = "lasercannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/gun/energy/lasercannon
	sort_string = "MAAAD"

/datum/design/item/energy/decloner
	id = "decloner"
	req_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 7, TECH_BIO = 5, TECH_POWER = 6)
	materials = list(MAT_GOLD = 5000,MAT_URANIUM = 10000)
	build_path = /obj/item/gun/energy/decloner
	sort_string = "MAAAE"

/datum/design/item/energy/temp_gun
	desc = "A gun that shoots high-powered glass-encased energy temperature bullets."
	id = "temp_gun"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 4, TECH_POWER = 3, TECH_MAGNET = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 500, MAT_SILVER = 3000)
	build_path = /obj/item/gun/energy/temperature
	sort_string = "MAAAF"

/datum/design/item/energy/flora_gun
	id = "flora_gun"
	req_tech = list(TECH_MATERIAL = 2, TECH_BIO = 3, TECH_POWER = 3)
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 500, MAT_URANIUM = 500)
	build_path = /obj/item/gun/energy/floragun
	sort_string = "MAAAG"

/datum/design/item/energy/vinstunrevolver
	id = "vinstunrevolver"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/gun/energy/stunrevolver/vintage
	sort_string = "MAAAH"

// Ballistic weapons

/datum/design/item/ballistic/AssembleDesignName()
	..()
	name = "Ballistic weapon prototype ([item_name])"

/datum/design/item/ballistic/advanced_smg
	id = "smg"
	desc = "An advanced 9mm SMG with a reflective laser optic."
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 8000, MAT_SILVER = 2000, MAT_DIAMOND = 1000)
	build_path = /obj/item/gun/projectile/automatic/advanced_smg
	sort_string = "MABAA"

// Ballistic ammo

/datum/design/item/ballistic/ammo/AssembleDesignName()
	..()
	name = "Ballistic weapon ammo prototype ([name])"

/datum/design/item/ballistic/ammo/ammo_9mmAdvanced
	name = "9mm magazine"
	id = "ammo_9mm"
	desc = "A 21 round magazine for an advanced 9mm SMG."
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 3750, MAT_SILVER = 100) // Requires silver for proprietary magazines! Or something.
	build_path = /obj/item/ammo_magazine/m9mmAdvanced
	sort_string = "MABBA"

/datum/design/item/ballistic/ammo/stunshell
	name = "stun shells"
	desc = "A stunning shell for a shotgun."
	id = "stunshell"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/stunshell
	sort_string = "MABBB"

/datum/design/item/ballistic/ammo/empshell
	name = "emp shells"
	desc = "An electromagnetic shell for a shotgun."
	id = "empshell"
	req_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)
	materials = list(MAT_STEEL = 4000, MAT_URANIUM = 1000)
	build_path = /obj/item/ammo_magazine/ammo_box/b12g/emp
	sort_string = "MABBC"

// Phase weapons

/datum/design/item/phase/AssembleDesignName()
	..()
	name = "Phase weapon prototype ([item_name])"

/* //VOREStation Removal Start
/datum/design/item/phase/phase_pistol
	id = "phasepistol"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000)
	build_path = /obj/item/gun/energy/phasegun/pistol
	sort_string = "MACAA"

/datum/design/item/phase/phase_carbine
	id = "phasecarbine"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_POWER = 2)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 1500)
	build_path = /obj/item/gun/energy/phasegun
	sort_string = "MACAB"

/datum/design/item/phase/phase_rifle
	id = "phaserifle"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3, TECH_POWER = 3)
	materials = list(MAT_STEEL = 7000, MAT_GLASS = 2000, MAT_SILVER = 500)
	build_path = /obj/item/gun/energy/phasegun/rifle
	sort_string = "MACAC"

/datum/design/item/phase/phase_cannon
	id = "phasecannon"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4, TECH_POWER = 4)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 2000, MAT_SILVER = 1000, MAT_DIAMOND = 750)
	build_path = /obj/item/gun/energy/phasegun/cannon
	sort_string = "MACAD"
*/ //VOREStation Removal End

// Other weapons

/datum/design/item/rapidsyringe
	id = "rapidsyringe"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000)
	build_path = /obj/item/gun/launcher/syringe/rapid
	sort_string = "MADAA"

/datum/design/item/dartgun
	desc = "A gun that fires small hollow chemical-payload darts."
	id = "dartgun_r"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_BIO = 4, TECH_MAGNET = 3, TECH_ILLEGAL = 1)
	materials = list(MAT_STEEL = 5000, MAT_GOLD = 5000, MAT_SILVER = 2500, MAT_GLASS = 750)
	build_path = /obj/item/gun/projectile/dartgun/research
	sort_string = "MADAB"

/datum/design/item/chemsprayer
	desc = "An advanced chem spraying device."
	id = "chemsprayer"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_BIO = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 1000)
	build_path = /obj/item/reagent_containers/spray/chemsprayer
	sort_string = "MADAC"

/datum/design/item/fuelrod
	id = "fuelrod_gun"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 4, TECH_PHORON = 4, TECH_ILLEGAL = 5, TECH_MAGNET = 5)
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 2000, MAT_GOLD = 500, MAT_SILVER = 500, MAT_URANIUM = 1000, MAT_PHORON = 3000, MAT_DIAMOND = 1000)
	build_path = /obj/item/gun/magnetic/fuelrod
	sort_string = "MADAD"

// Ammo for those

/datum/design/item/ammo/dartgunmag_small
	id = "dartgun_mag_s"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials = list(MAT_STEEL = 300, MAT_GOLD = 100, MAT_SILVER = 100, MAT_GLASS = 300)
	build_path = /obj/item/ammo_magazine/chemdart/small
	sort_string = "MADBA"

/datum/design/item/ammo/dartgun_ammo_small
	id = "dartgun_ammo_s"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials = list(MAT_STEEL = 50, MAT_GOLD = 30, MAT_SILVER = 30, MAT_GLASS = 50)
	build_path = /obj/item/ammo_casing/chemdart/small
	sort_string = "MADBB"

/datum/design/item/ammo/dartgunmag_med
	id = "dartgun_mag_m"
	req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials = list(MAT_STEEL = 500, MAT_GOLD = 150, MAT_SILVER = 150, MAT_DIAMOND = 200, MAT_GLASS = 400)
	build_path = /obj/item/ammo_magazine/chemdart
	sort_string = "MADBC"

/datum/design/item/ammo/dartgun_ammo_med
	id = "dartgun_ammo_m"
	req_tech = list(TECH_COMBAT = 7, TECH_MATERIAL = 2, TECH_BIO = 2, TECH_MAGNET = 1, TECH_ILLEGAL = 1)
	materials = list(MAT_STEEL = 80, MAT_GOLD = 40, MAT_SILVER = 40, MAT_GLASS = 60)
	build_path = /obj/item/ammo_casing/chemdart
	sort_string = "MADBD"

/datum/design/item/ammo/flechette
	id = "magnetic_ammo"
	req_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4, TECH_MAGNET = 4)
	materials = list(MAT_STEEL = 500, MAT_GOLD = 300, MAT_GLASS = 150, MAT_PHORON = 100)
	build_path = /obj/item/magnetic_ammo
	sort_string = "MADBE"

// Melee weapons

/datum/design/item/melee/AssembleDesignName()
	..()
	name = "Melee weapon prototype ([item_name])"

/datum/design/item/melee/esword
	name = "Portable Energy Blade"
	id = "chargesword"
	req_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 4, TECH_ENGINEERING = 5, TECH_ILLEGAL = 4, TECH_ARCANE = 1)
	materials = list(MAT_PLASTEEL = 3500, MAT_GLASS = 1000, MAT_LEAD = 2250, MAT_METALHYDROGEN = 500)
	build_path = /obj/item/melee/energy/sword/charge
	sort_string = "MBAAA"

/datum/design/item/melee/eaxe
	name = "Energy Axe"
	id = "chargeaxe"
	req_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 5, TECH_ENGINEERING = 4, TECH_ILLEGAL = 4)
	materials = list(MAT_PLASTEEL = 3500, MAT_OSMIUM = 2000, MAT_LEAD = 2000, MAT_METALHYDROGEN = 500)
	build_path = /obj/item/melee/energy/axe/charge
	sort_string = "MBAAB"

// Grenade stuff
/datum/design/item/grenade/AssembleDesignName()
	..()
	name = "Grenade casing prototype ([item_name])"

/datum/design/item/grenade/large_grenade
	id = "large_Grenade"
	req_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	materials = list(MAT_STEEL = 3000)
	build_path = /obj/item/grenade/chem_grenade/large
	sort_string = "MCAAA"
