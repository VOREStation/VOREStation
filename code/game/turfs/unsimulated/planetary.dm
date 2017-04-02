// This is a wall you surround the area of your "planet" with, that makes the atmosphere inside stay within bounds, even if canisters
// are opened or other strange things occur.
var/list/planetary_walls = list()

/turf/unsimulated/wall/planetary
	name = "railroading"
	desc = "Choo choo!"
	icon = 'icons/turf/walls.dmi'
	icon_state = "riveted"
	opacity = 1
	density = 1
	alpha = 0
	blocks_air = 0

	// Set these to get your desired planetary atmosphere.
	oxygen = 0
	nitrogen = 0
	carbon_dioxide = 0
	phoron = 0
	temperature = T20C

/turf/unsimulated/wall/planetary/New()
	..()
	planetary_walls.Add(src)

/turf/unsimulated/wall/planetary/Destroy()
	planetary_walls.Remove(src)
	..()

// Normal station/earth air.
/turf/unsimulated/wall/planetary/normal
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD

/turf/unsimulated/wall/planetary/firnir
	temperature = 570
	carbon_dioxide = 0.04863

/turf/unsimulated/wall/planetary/tyr
	temperature = 405
	carbon_dioxide = 0.15848

// Wiki says it's 92.6 kPa, composition 18.1% O2 80.8% N2 1.1% trace.  We're gonna pretend trace is actually nitrogen.
/turf/unsimulated/wall/planetary/sif
	oxygen		= 114.50978 * 0.181
	nitrogen	= 114.50978 * 0.819
	temperature	= 243.15 // Roughly -30C / -22F

// Fairly close to Mars in terms of temperature and pressure.
/turf/unsimulated/wall/planetary/magni
	carbon_dioxide = 0.90998361
	temperature = 202

/turf/unsimulated/wall/planetary/desert
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature = 310.92 // About 37.7C / 100F
