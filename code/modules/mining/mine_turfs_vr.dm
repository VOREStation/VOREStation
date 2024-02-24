/turf/simulated/mineral
	var/ignore_oregen = FALSE
	var/ignore_cavegen = FALSE

/turf/simulated/mineral/ignore_oregen
	ignore_oregen = TRUE

/turf/simulated/mineral/floor/ignore_oregen
	ignore_oregen = TRUE

/turf/simulated/mineral/ignore_cavegen
	ignore_cavegen = TRUE

/turf/simulated/mineral/floor/ignore_cavegen
	ignore_cavegen = TRUE

/turf/simulated/mineral/ignore_cavegen/cave
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	temperature	= T20C

/turf/simulated/mineral/floor/ignore_cavegen/cave
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