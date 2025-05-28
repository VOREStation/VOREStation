//Anomaly

/datum/design/item/anomaly/AssembleDesignName()
	..()
	name = "Anomalous prototype ([item_name])"

/datum/design/item/anomaly/AssembleDesignDesc()
	if(!desc)
		if(build_path)
			var/obj/item/I = build_path
			desc = initial(I.desc)
		..()

/datum/design/item/anomaly/camotrap
	name = "Chameleon Trap"
	desc = "A self-miraging mechanical trap, capable of producing short bursts of electric current when triggered."
	id = "hunt_trap"
	materials = list(MAT_DURASTEEL = 3000, MAT_METALHYDROGEN = 1000, MAT_PHORON = 2000)
	req_tech = list(TECH_MATERIAL = 4, TECH_BLUESPACE = 3, TECH_MAGNET = 4, TECH_PHORON = 2, TECH_ARCANE = 2)
	build_path = /obj/item/beartrap/hunting
	sort_string = "ZAAAA"

// Precursor

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
	build_path = /obj/item/tool/crowbar/hybrid
	sort_string = "ZBAAA"

/datum/design/item/precursor/wrench
	name = "Hybrid Wrench"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridwrench"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_PRECURSOR = 1)
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_SILVER = 300, MAT_URANIUM = 2000)
	build_path = /obj/item/tool/wrench/hybrid
	sort_string = "ZBAAB"

/datum/design/item/precursor/screwdriver
	name = "Hybrid Screwdriver"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridscrewdriver"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_BLUESPACE = 2, TECH_MAGNET = 3, TECH_PRECURSOR = 1)
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_PLASTIC = 8000, MAT_DIAMOND = 2000)
	build_path = /obj/item/tool/screwdriver/hybrid
	sort_string = "ZBAAC"

/datum/design/item/precursor/wirecutters
	name = "Hybrid Wirecutters"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridwirecutters"
	req_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 5, TECH_PHORON = 2, TECH_PRECURSOR = 1)
	materials = list(MAT_PLASTEEL = 2000, MAT_VERDANTIUM = 3000, MAT_PLASTIC = 8000, MAT_PHORON = 2750, MAT_DIAMOND = 2000)
	build_path = /obj/item/tool/wirecutters/hybrid
	sort_string = "ZBAAD"

/datum/design/item/precursor/welder
	name = "Hybrid Welding Tool"
	desc = "A tool utilizing cutting edge modern technology, and ancient component designs."
	id = "hybridwelder"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6, TECH_BLUESPACE = 3, TECH_PHORON = 3, TECH_MAGNET = 5, TECH_PRECURSOR = 1)
	materials = list(MAT_DURASTEEL = 2000, MAT_MORPHIUM = 3000, MAT_METALHYDROGEN = 4750, MAT_URANIUM = 6000)
	build_path = /obj/item/weldingtool/experimental/hybrid
	sort_string = "ZBAAE"


/datum/design/item/precursor/janusmodule
	name = "Blackbox Circuit Datamass"
	desc = "A design that seems to be in a constantly shifting superposition."
	id = "janus_module"
	materials = list(MAT_DURASTEEL = 3000, MAT_MORPHIUM = 2000, MAT_METALHYDROGEN = 6000, MAT_URANIUM = 6000, MAT_VERDANTIUM = 1500)
	req_tech = list(TECH_MATERIAL = 7, TECH_BLUESPACE = 5, TECH_MAGNET = 6, TECH_PHORON = 3, TECH_ARCANE = 1, TECH_PRECURSOR = 2)
	build_path = /obj/random/janusmodule
	sort_string = "ZBBAA"

/datum/design/item/precursor/janusmodule/Fabricate(var/newloc, var/fabricator)
	var/type_to_spawn = pick(subtypesof(/obj/item/circuitboard/mecha/imperion))
	return new type_to_spawn(newloc)
