// Sif Planetside stuff
#define O2SIF 0.181
#define N2SIF 0.819

#define MOLES_CELLSIF 114.50978

#define MOLES_O2SIF (MOLES_CELLSIF * O2SIF) // O2 value on Sif(18%)
#define MOLES_N2SIF (MOLES_CELLSIF * N2SIF) // N2 value on Sif(82%)

#define TEMPERATURE_SIF 243.15 // Roughly -30C / -22F
#define TEMPERATURE_ALTSIF 225.15

/turf/simulated/floor/outdoors/mud/sif/planetuse
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/floor/outdoors/rocks/sif/planetuse
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/floor/tiled/sif/planetuse
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF
	outdoors = TRUE

/turf/simulated/floor/tiled/steel/sif/planetuse
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF
	outdoors = TRUE

/turf/simulated/floor/plating/sif/planetuse
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF
	outdoors = TRUE

/turf/simulated/floor/outdoors/snow/sif/planetuse
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/floor/outdoors/grass/sif/planetuse
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/floor/outdoors/grass/sif/forest/planetuse
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/floor/outdoors/dirt/sif/planetuse
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/mineral/sif
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/mineral/ignore_mapgen/sif
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/mineral/floor/sif
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/mineral/floor/ignore_mapgen/sif
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/floor/outdoors/mud/sif/planetuse
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

// PoI compatability, to stop active edges.
// In hindsight it would've been better to do this first instead of making a billion /sif subtypes above,
// but maybe we can transition to this instead now and over time get rid of the /sif subtypes.
// The downside is if someone wants to use this in normal/vaccum they'll need to make a new subtype, but since the typical use case has changed, this might be acceptable.

/turf/simulated/mineral
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/floor/outdoors
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/floor/water
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/shuttle/floor/alienplating/external
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/shuttle/floor/voidcraft/external
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/shuttle/floor/voidcraft/external/dark
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/shuttle/floor/voidcraft/external/light
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/floor/plating/external
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/floor/tiled/external
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_SIF

/turf/simulated/sky
	oxygen		= MOLES_O2SIF
	nitrogen	= MOLES_N2SIF
	temperature	= TEMPERATURE_ALTSIF

// Space mineral tiles are now not the default, so they get demoted to subtype status.

/turf/simulated/mineral/vacuum
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/mineral/ignore_mapgen/vacuum
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/mineral/floor/vacuum
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/mineral/floor/ignore_mapgen/vacuum
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

// Step trigger to fall down to planet Sif
/obj/effect/step_trigger/teleporter/planetary_fall/sif/find_planet()
	planet = planet_sif