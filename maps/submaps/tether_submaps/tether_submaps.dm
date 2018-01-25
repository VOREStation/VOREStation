// This causes engine maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
#if MAP_TEST
#include "tether_ships.dmm"
#endif

/datum/map_template/tether_lateload
	allow_duplicates = FALSE

/datum/map_template/tether_lateload/tether_ships
	name = "Tether - Ships"
	desc = "Ship transit map and whatnot."
	mappath = 'maps/submaps/tether_submaps/tether_ships.dmm'
