//Simulated
/turf/simulated/open/virgo3b
	edge_blending_priority = 0.5 //Turfs which also have e_b_p and higher than this will plop decorative edges onto this turf
/*	Handled by parent now
/turf/simulated/open/virgo3b/Initialize(mapload)
	. = ..()
	if(is_outdoors())
		SSplanets.addTurf(src)
*/

// Overriding these for the sake of submaps that use them on other planets.
// This means that mining on tether base and space is oxygen-generating, but solars and mining should use the virgo3b subtype
/turf/simulated/mineral
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature	= T20C
/turf/simulated/floor/outdoors
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature	= T20C
/turf/simulated/floor/water
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature	= T20C

/turf/simulated/mineral/vacuum
	oxygen = 0
	nitrogen = 0
	temperature	= TCMB
/turf/simulated/mineral/floor/vacuum
	oxygen = 0
	nitrogen = 0
	temperature	= TCMB

	//This proc is responsible for ore generation on surface turfs
/turf/simulated/mineral/virgo3b/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			ORE_MARBLE = 3,
			ORE_URANIUM = 10,
			ORE_PLATINUM = 10,
			ORE_HEMATITE = 20,
			ORE_CARBON = 20,
			ORE_DIAMOND = 1,
			ORE_GOLD = 8,
			ORE_SILVER = 8,
			ORE_PHORON = 18,
			ORE_LEAD = 2,
			ORE_VERDANTIUM = 1))
	else
		mineral_name = pickweight(list(
			ORE_MARBLE = 2,
			ORE_URANIUM = 5,
			ORE_PLATINUM = 5,
			ORE_HEMATITE = 35,
			ORE_CARBON = 35,
			ORE_GOLD = 3,
			ORE_SILVER = 3,
			ORE_PHORON = 25,
			ORE_LEAD = 1))
	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()
	update_icon()

/turf/simulated/mineral/virgo3b/rich/make_ore(var/rare_ore)
	if(mineral || ignore_mapgen)
		return
	var/mineral_name
	if(rare_ore)
		mineral_name = pickweight(list(
			ORE_MARBLE = 7,
			ORE_URANIUM = 10,
			ORE_PLATINUM = 10,
			ORE_HEMATITE = 10,
			ORE_CARBON = 10,
			ORE_DIAMOND = 4,
			ORE_GOLD = 15,
			ORE_SILVER = 15,
			ORE_LEAD = 5,
			ORE_VERDANTIUM = 2))
	else
		mineral_name = pickweight(list(
			ORE_MARBLE = 5,
			ORE_URANIUM = 7,
			ORE_PLATINUM = 7,
			ORE_HEMATITE = 28,
			ORE_CARBON = 28,
			ORE_DIAMOND = 2,
			ORE_GOLD = 7,
			ORE_SILVER = 7,
			ORE_LEAD = 4,
			ORE_VERDANTIUM = 1))
	if(mineral_name && (mineral_name in GLOB.ore_data))
		mineral = GLOB.ore_data[mineral_name]
		UpdateMineral()
	update_icon()

/turf/space/v3b_midpoint/CanZPass(atom, direction)
	return 0			// We're not Space

// Virgo 3b trufs
/turf/space/transit/south/virgo3b/planet_fall/find_planet()
	return planet_virgo3b

/turf/space/transit/east/virgo3b/planet_fall/find_planet()
	return planet_virgo3b

/turf/simulated/sky/virgo3b/south/planet_fall/find_planet()
	return planet_virgo3b

/turf/space/v3b_midpoint/find_planet()
	return planet_virgo3b
