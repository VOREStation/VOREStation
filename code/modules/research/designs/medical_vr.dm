/*
	KV - ML3M stuff
		KVA - gun
		KVB - magazines
		KVC - cells
			KVCA - tier 0
			KVCB - tier 1
			KVCC - tier 2
			KVCD - tier 3
			KVCE - tier 4
			KVCO - tierless
*/

//General stuff

/datum/design/item/medical/sleevemate
	name = "SleeveMate 3700"
	id = "sleevemate"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/sleevemate
	sort_string = "KCAVA"

/datum/design/item/medical/protohypospray
	name = "prototype hypospray"
	desc = "This prototype hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	id = "protohypospray"
	req_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 3, TECH_POWER = 2, TECH_BIO = 4, TECH_ILLEGAL = 2)
	materials = list(MAT_STEEL = 500, MAT_GLASS = 1500, MAT_SILVER = 2000, MAT_GOLD = 1500, MAT_URANIUM = 1000)
	build_path = /obj/item/reagent_containers/hypospray/science
	sort_string = "KCAVB"

/datum/design/item/medical/recombobray
	name = "recombobulation ray"
	desc = "The Type Gamma Medical Recombobulation ray! A mysterious looking ray gun! It works to change people who have had their form significantly altered back into their original forms!"
	id = "recombobray"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_POWER = 4, TECH_BIO = 5, TECH_BLUESPACE = 4) //Not like these matter. *Glares at circuit printer.*
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 2000, MAT_URANIUM = 500, MAT_PHORON = 1500)
	build_path = /obj/item/gun/energy/mouseray/medical
	sort_string = "KCAVC"

// ML-3M medigun and cells
/datum/design/item/medical/cell_based/AssembleDesignName()
	..()
	name = "Cell-based medical prototype ([item_name])"

/datum/design/item/medical/cell_based/cell_medigun
	name = "cell-loaded medigun"
	id = "cell_medigun"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 3, TECH_BIO = 5)
	materials = list(MAT_STEEL = 8000, MAT_PLASTIC = 8000, MAT_GLASS = 5000, MAT_SILVER = 1000, MAT_GOLD = 1000, MAT_URANIUM = 1000)
	build_path = /obj/item/gun/projectile/cell_loaded/medical
	sort_string = "KVAAA"

/datum/design/item/medical/cell_based/cell_medigun_mag
	name = "medical cell magazine"
	id = "cell_medigun_mag"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 4, TECH_POWER = 3, TECH_BIO = 5)
	materials = list(MAT_STEEL = 4000, MAT_PLASTIC = 6000, MAT_GLASS = 3000, MAT_SILVER = 500, MAT_GOLD = 500)
	build_path = /obj/item/ammo_magazine/cell_mag/medical
	sort_string = "KVBAA"

/datum/design/item/medical/cell_based/cell_medigun_mag_advanced
	name = "advanced medical cell magazine"
	id = "cell_medigun_mag_advanced"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 4, TECH_BIO = 7)
	materials = list(MAT_STEEL = 5000, MAT_PLASTIC = 10000, MAT_GLASS = 5000, MAT_SILVER = 1500, MAT_GOLD = 1500, MAT_DIAMOND = 5000)
	build_path = /obj/item/ammo_magazine/cell_mag/medical/advanced
	sort_string = "KVBAB"

/datum/design/item/ml3m_cell/AssembleDesignName()
	..()
	name = "Nanite cell prototype ([name])"

//Tier 0

/datum/design/item/ml3m_cell/brute
	name = "BRUTE"
	id = "ml3m_cell_brute"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000)
	build_path = /obj/item/ammo_casing/microbattery/medical/brute
	sort_string = "KVCAA"

/datum/design/item/ml3m_cell/burn
	name = "BURN"
	id = "ml3m_cell_burn"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000)
	build_path = /obj/item/ammo_casing/microbattery/medical/burn
	sort_string = "KVCAB"

/datum/design/item/ml3m_cell/stabilize
	name = "STABILIZE"
	id = "ml3m_cell_stabilize"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 2, TECH_BIO = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000)
	build_path = /obj/item/ammo_casing/microbattery/medical/stabilize
	sort_string = "KVCAC"

//Tier 1

/datum/design/item/ml3m_cell/toxin
	name = "TOXIN"
	id = "ml3m_cell_toxin"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin
	sort_string = "KVCBA"

/datum/design/item/ml3m_cell/omni
	name = "OMNI"
	id = "ml3m_cell_omni"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni
	sort_string = "KVCBB"

/datum/design/item/ml3m_cell/antirad
	name = "ANTIRAD"
	id = "ml3m_cell_antirad"
	req_tech = list(TECH_MATERIAL = 3, TECH_MAGNET = 3, TECH_BIO = 4)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500)
	build_path = /obj/item/ammo_casing/microbattery/medical/antirad
	sort_string = "KVCBC"

//Tier 2

/datum/design/item/ml3m_cell/brute2
	name = "BRUTE-II"
	id = "ml3m_cell_brute2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_GOLD = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/brute2
	sort_string = "KVCCA"

/datum/design/item/ml3m_cell/burn2
	name = "BURN-II"
	id = "ml3m_cell_burn2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_GOLD = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/burn2
	sort_string = "KVCCB"

/datum/design/item/ml3m_cell/stabilize2
	name = "STABILIZE-II"
	id = "ml3m_cell_stabilize2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_SILVER = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/stabilize2
	sort_string = "KVCCC"

/datum/design/item/ml3m_cell/omni2
	name = "OMNI-II"
	id = "ml3m_cell_omni2"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_POWER = 2, TECH_BIO = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_URANIUM = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni2
	sort_string = "KVCCD"

//Tier 3

/datum/design/item/ml3m_cell/toxin2
	name = "TOXIN-II"
	id = "ml3m_cell_toxin2"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_URANIUM = 1000, MAT_SILVER = 1000, MAT_DIAMOND = 500)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin2
	sort_string = "KVCDA"

/datum/design/item/ml3m_cell/haste
	name = "HASTE"
	id = "ml3m_cell_haste"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_GOLD = 1000, MAT_SILVER = 1000, MAT_DIAMOND = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/haste
	sort_string = "KVCDB"

/datum/design/item/ml3m_cell/resist
	name = "RESIST"
	id = "ml3m_cell_resist"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_GOLD = 1000, MAT_URANIUM = 1000, MAT_DIAMOND = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/resist
	sort_string = "KVCDC"

/datum/design/item/ml3m_cell/corpse_mend
	name = "CORPSE MEND"
	id = "ml3m_cell_corpse_mend"
	req_tech = list(TECH_MATERIAL = 6, TECH_MAGNET = 3, TECH_POWER = 3, TECH_BIO = 6)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_PHORON = 3000, MAT_DIAMOND = 3000)
	build_path = /obj/item/ammo_casing/microbattery/medical/corpse_mend
	sort_string = "KVCDD"

//Tier 4

/datum/design/item/ml3m_cell/brute3
	name = "BRUTE-III"
	id = "ml3m_cell_brute3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_PRECURSOR = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_DIAMOND = 500, MAT_VERDANTIUM = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/brute3
	sort_string = "KVCEA"

/datum/design/item/ml3m_cell/burn3
	name = "BURN-III"
	id = "ml3m_cell_burn3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_PRECURSOR = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_DIAMOND = 500, MAT_VERDANTIUM = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/burn3
	sort_string = "KVCEB"

/datum/design/item/ml3m_cell/toxin3
	name = "TOXIN-III"
	id = "ml3m_cell_toxin3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_ARCANE = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_DIAMOND = 500, MAT_VERDANTIUM = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/toxin3
	sort_string = "KVCEC"

/datum/design/item/ml3m_cell/omni3
	name = "OMNI-III"
	id = "ml3m_cell_omni3"
	req_tech = list(TECH_MATERIAL = 7, TECH_MAGNET = 6, TECH_POWER = 5, TECH_BIO = 7, TECH_ARCANE = 2)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_DIAMOND = 500, MAT_VERDANTIUM = 1000)
	build_path = /obj/item/ammo_casing/microbattery/medical/omni3
	sort_string = "KVCED"

//Tierless

/datum/design/item/ml3m_cell/shrink
	name = "SHRINK"
	id = "ml3m_cell_shrink"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_URANIUM = 2000)
	build_path = /obj/item/ammo_casing/microbattery/medical/shrink
	sort_string = "KVCOA"

/datum/design/item/ml3m_cell/grow
	name = "GROW"
	id = "ml3m_cell_grow"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_URANIUM = 2000)
	build_path = /obj/item/ammo_casing/microbattery/medical/grow
	sort_string = "KVCOB"

/datum/design/item/ml3m_cell/normalsize
	name = "NORMALSIZE"
	id = "ml3m_cell_normalsize"
	req_tech = list(TECH_MATERIAL = 5, TECH_MAGNET = 3, TECH_BLUESPACE = 3, TECH_BIO = 5, TECH_ILLEGAL = 5)
	materials = list(MAT_STEEL = 5000, MAT_GLASS = 5000, MAT_PLASTIC = 2500, MAT_URANIUM = 2000)
	build_path = /obj/item/ammo_casing/microbattery/medical/normalsize
	sort_string = "KVCOC"