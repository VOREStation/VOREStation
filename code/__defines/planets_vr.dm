#define WEATHER_PARTY				"party"

//Atmosphere properties
#define VIRGO3B_ONE_ATMOSPHERE	82.4 //kPa
#define VIRGO3B_AVG_TEMP	234 //kelvin

#define VIRGO3B_PER_N2		0.16 //percent
#define VIRGO3B_PER_O2		0.00
#define VIRGO3B_PER_N2O		0.00 //Currently no capacity to 'start' a turf with this. See turf.dm
#define VIRGO3B_PER_CO2		0.12
#define VIRGO3B_PER_PHORON	0.72

//Math only beyond this point
#define VIRGO3B_MOL_PER_TURF	(VIRGO3B_ONE_ATMOSPHERE*CELL_VOLUME/(VIRGO3B_AVG_TEMP*R_IDEAL_GAS_EQUATION))
#define VIRGO3B_MOL_N2			(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_N2)
#define VIRGO3B_MOL_O2			(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_O2)
#define VIRGO3B_MOL_N2O			(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_N2O)
#define VIRGO3B_MOL_CO2			(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_CO2)
#define VIRGO3B_MOL_PHORON		(VIRGO3B_MOL_PER_TURF * VIRGO3B_PER_PHORON)

//Turfmakers
#define VIRGO3B_SET_ATMOS	nitrogen=VIRGO3B_MOL_N2;oxygen=VIRGO3B_MOL_O2;carbon_dioxide=VIRGO3B_MOL_CO2;phoron=VIRGO3B_MOL_PHORON;temperature=VIRGO3B_AVG_TEMP
#define VIRGO3B_TURF_CREATE(x)	x/virgo3b/nitrogen=VIRGO3B_MOL_N2;x/virgo3b/oxygen=VIRGO3B_MOL_O2;x/virgo3b/carbon_dioxide=VIRGO3B_MOL_CO2;x/virgo3b/phoron=VIRGO3B_MOL_PHORON;x/virgo3b/temperature=VIRGO3B_AVG_TEMP;x/virgo3b/outdoors=TRUE;x/virgo3b/update_graphic(list/graphic_add = null, list/graphic_remove = null) return 0
#define VIRGO3B_TURF_CREATE_UN(x)	x/virgo3b/nitrogen=VIRGO3B_MOL_N2;x/virgo3b/oxygen=VIRGO3B_MOL_O2;x/virgo3b/carbon_dioxide=VIRGO3B_MOL_CO2;x/virgo3b/phoron=VIRGO3B_MOL_PHORON;x/virgo3b/temperature=VIRGO3B_AVG_TEMP

//Atmosphere properties
#define VIRGO3BB_ONE_ATMOSPHERE	101.325 //kPa
#define VIRGO3BB_AVG_TEMP	293.15 //kelvin

#define VIRGO3BB_PER_N2			0.78 //percent
#define VIRGO3BB_PER_O2			0.21
#define VIRGO3BB_PER_N2O		0.00 //Currently no capacity to 'start' a turf with this. See turf.dm
#define VIRGO3BB_PER_CO2		0.01
#define VIRGO3BB_PER_PHORON		0.00

//Math only beyond this point
#define VIRGO3BB_MOL_PER_TURF	(VIRGO3BB_ONE_ATMOSPHERE*CELL_VOLUME/(VIRGO3BB_AVG_TEMP*R_IDEAL_GAS_EQUATION))
#define VIRGO3BB_MOL_N2			(VIRGO3BB_MOL_PER_TURF * VIRGO3BB_PER_N2)
#define VIRGO3BB_MOL_O2			(VIRGO3BB_MOL_PER_TURF * VIRGO3BB_PER_O2)
#define VIRGO3BB_MOL_N2O			(VIRGO3BB_MOL_PER_TURF * VIRGO3BB_PER_N2O)
#define VIRGO3BB_MOL_CO2			(VIRGO3BB_MOL_PER_TURF * VIRGO3BB_PER_CO2)
#define VIRGO3BB_MOL_PHORON		(VIRGO3BB_MOL_PER_TURF * VIRGO3BB_PER_PHORON)

//Turfmakers
#define VIRGO3BB_SET_ATMOS	nitrogen=VIRGO3BB_MOL_N2;oxygen=VIRGO3BB_MOL_O2;carbon_dioxide=VIRGO3BB_MOL_CO2;phoron=VIRGO3BB_MOL_PHORON;temperature=VIRGO3BB_AVG_TEMP
#define VIRGO3BB_TURF_CREATE(x)	x/virgo3b_better/nitrogen=VIRGO3BB_MOL_N2;x/virgo3b_better/oxygen=VIRGO3BB_MOL_O2;x/virgo3b_better/carbon_dioxide=VIRGO3BB_MOL_CO2;x/virgo3b_better/phoron=VIRGO3BB_MOL_PHORON;x/virgo3b_better/temperature=VIRGO3BB_AVG_TEMP;x/virgo3b_better/outdoors=TRUE;x/virgo3b_better/update_graphic(list/graphic_add = null, list/graphic_remove = null) return 0
#define VIRGO3BB_TURF_CREATE_UN(x)	x/virgo3b_better/nitrogen=VIRGO3BB_MOL_N2;x/virgo3b_better/oxygen=VIRGO3BB_MOL_O2;x/virgo3b_better/carbon_dioxide=VIRGO3BB_MOL_CO2;x/virgo3b_better/phoron=VIRGO3BB_MOL_PHORON;x/virgo3b_better/temperature=VIRGO3BB_AVG_TEMP

//Atmosphere properties
#define VIRGO2_ONE_ATMOSPHERE	312.1 //kPa
#define VIRGO2_AVG_TEMP			612 //kelvin

#define VIRGO2_PER_N2		0.10 //percent
#define VIRGO2_PER_O2		0.03
#define VIRGO2_PER_N2O		0.00 //Currently no capacity to 'start' a turf with this. See turf.dm
#define VIRGO2_PER_CO2		0.87
#define VIRGO2_PER_PHORON	0.00

//Math only beyond this point
#define VIRGO2_MOL_PER_TURF		(VIRGO2_ONE_ATMOSPHERE*CELL_VOLUME/(VIRGO2_AVG_TEMP*R_IDEAL_GAS_EQUATION))
#define VIRGO2_MOL_N2			(VIRGO2_MOL_PER_TURF * VIRGO2_PER_N2)
#define VIRGO2_MOL_O2			(VIRGO2_MOL_PER_TURF * VIRGO2_PER_O2)
#define VIRGO2_MOL_N2O			(VIRGO2_MOL_PER_TURF * VIRGO2_PER_N2O)
#define VIRGO2_MOL_CO2			(VIRGO2_MOL_PER_TURF * VIRGO2_PER_CO2)
#define VIRGO2_MOL_PHORON		(VIRGO2_MOL_PER_TURF * VIRGO2_PER_PHORON)

//Turfmakers
#define VIRGO2_SET_ATMOS	nitrogen=VIRGO2_MOL_N2;oxygen=VIRGO2_MOL_O2;carbon_dioxide=VIRGO2_MOL_CO2;phoron=VIRGO2_MOL_PHORON;temperature=VIRGO2_AVG_TEMP
#define VIRGO2_TURF_CREATE(x)	x/virgo2/nitrogen=VIRGO2_MOL_N2;x/virgo2/oxygen=VIRGO2_MOL_O2;x/virgo2/carbon_dioxide=VIRGO2_MOL_CO2;x/virgo2/phoron=VIRGO2_MOL_PHORON;x/virgo2/temperature=VIRGO2_AVG_TEMP;x/virgo2/color="#eacd7c"
