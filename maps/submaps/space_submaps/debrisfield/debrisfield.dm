// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so CI can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#ifdef MAP_TEST
// #define "your_map_here.dmm"
#endif

/datum/map_template/debrisfield
	name = "Space Content - Debrisfield"
	desc = "Designed for space points of interest."

// No points of interest yet, but the infrastructure is there for people to add!
