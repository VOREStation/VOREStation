// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.

#if MAP_TEST

#endif


// The wilderness is an area outside the main outpost, that houses some small random areas and the transit corridor between the 'main' base and the outpost/engine.
// POIs here should not be dangerous, be mundane, and hold no practical loot, just interesting tidbits.

/datum/map_template/surface/wilderness
	name = "Surface Content - Wilderness"
	desc = "Used to make the surface outside the outpost be 16% less boring."