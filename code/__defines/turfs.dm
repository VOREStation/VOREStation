#define TURF_REMOVE_CROWBAR     1
#define TURF_REMOVE_SCREWDRIVER 2
#define TURF_REMOVE_SHOVEL      4
#define TURF_REMOVE_WRENCH      8
#define TURF_CAN_BREAK          16
#define TURF_CAN_BURN           32
#define TURF_HAS_EDGES          64
#define TURF_HAS_CORNERS        128
#define TURF_IS_FRAGILE         256
#define TURF_ACID_IMMUNE        512

//Used for floor/wall smoothing
#define SMOOTH_NONE 0	//Smooth only with itself
#define SMOOTH_ALL 1	//Smooth with all of type
#define SMOOTH_WHITELIST 2	//Smooth with a whitelist of subtypes
#define SMOOTH_BLACKLIST 3 //Smooth with all but a blacklist of subtypes
#define SMOOTH_GREYLIST 4 // Use a whitelist and a blacklist at the same time. atom smoothing only

#define isCardinal(x)			(x == NORTH || x == SOUTH || x == EAST || x == WEST)
#define isDiagonal(x)			(x == NORTHEAST || x == SOUTHEAST || x == NORTHWEST || x == SOUTHWEST)