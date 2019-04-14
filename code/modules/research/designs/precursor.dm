/*
 * Contains Precursor and Anomalous designs for the Protolathe.
 */

/datum/design/item/precursor/AssembleDesignName()
	..()
	name = "Alien prototype ([item_name])"

/datum/design/item/precursor/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()

/datum/design/item/precursor/crowbar
	name = "Hybrid Crowbar"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridcrowbar"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6, TECH_BLUESPACE = 3, TECH_PRECURSOR = 1)
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_GOLD = 250, MAT_URANIUM = 2500)
	build_path = /obj/item/weapon/tool/crowbar/hybrid
	sort_string = "PATAC"

/datum/design/item/precursor/wrench
	name = "Hybrid Wrench"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridwrench"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_PRECURSOR = 1)
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_SILVER = 300, MAT_URANIUM = 2000)
	build_path = /obj/item/weapon/tool/wrench/hybrid
	sort_string = "PATAW"

/datum/design/item/precursor/screwdriver
	name = "Hybrid Screwdriver"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridscrewdriver"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_PRECURSOR = 1)
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_PLASTIC = 8000, MAT_DIAMOND = 2000)
	build_path = /obj/item/weapon/tool/screwdriver/hybrid
	sort_string = "PATAS"

/datum/design/item/precursor/wirecutters
	name = "Hybrid Wirecutters"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridwirecutters"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_PHORON = 2, TECH_PRECURSOR = 1)
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_PLASTIC = 8000, MAT_PHORON = 2750, MAT_DIAMOND = 2000)
	build_path = /obj/item/weapon/tool/wirecutters/hybrid
	sort_string = "PATBW"

/datum/design/item/precursor/welder
	name = "Hybrid Welding Tool"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridwelder"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6, TECH_BLUESPACE = 3, TECH_PHORON = 3, TECH_MAGNET = 5, TECH_PRECURSOR = 1)
	materials = list(MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_METALHYDROGEN = 4750, MAT_URANIUM = 6000)
	build_path = /obj/item/weapon/weldingtool/experimental/hybrid
	sort_string = "PATCW"

/datum/design/item/anomaly/AssembleDesignName()
	..()
	name = "Anomalous prototype ([item_name])"

/datum/design/item/anomaly/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()