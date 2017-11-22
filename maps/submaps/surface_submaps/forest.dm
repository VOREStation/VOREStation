// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
#include "farm1.dmm"
#include "spider1.dmm"
#endif

/datum/map_template/surface
	name = "Surface Content"
	desc = "Used to make the surface be 17% less boring."

// To be added: Templates for surface exploration when they are made.

/datum/map_template/surface/farm1
	name = "Farm 1"
	desc = "A small farm tended by a farmbot."
	mappath = 'maps/submaps/surface_submaps/farm1.dmm'
	cost = 10

/datum/map_template/surface/spider1
	name = "Spider Nest 1"
	desc = "A small spider nest, in the forest."
	mappath = 'maps/submaps/surface_submaps/spider1.dmm'
	allow_duplicates = TRUE
	cost = 5