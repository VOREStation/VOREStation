// This causes engine maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new engine, please add it to this list.
#if MAP_TEST
#include "engine_rust.dmm"
#include "engine_singulo.dmm"
#include "engine_sme.dmm"
#include "engine_tesla.dmm"
#endif

/datum/map_template/engine
	name = "Engine Content"
	desc = "It would be boring to have the same engine every day right?"
	// annihilate = TRUE - Would wipe out in a rectangular area unfortunately
	allow_duplicates = FALSE

/datum/map_template/engine/rust
	name = "R-UST Engine"
	desc = "R-UST Fusion Tokamak Engine"
	mappath = 'maps/submaps/engine_submaps_vr/tether/engine_rust.dmm'

/datum/map_template/engine/singulo
	name = "Singularity Engine"
	desc = "Lord Singuloth"
	mappath = 'maps/submaps/engine_submaps_vr/tether/engine_singulo.dmm'

/datum/map_template/engine/supermatter
	name = "Supermatter Engine"
	desc = "Old Faithful Supermatter"
	mappath = 'maps/submaps/engine_submaps_vr/tether/engine_sme.dmm'

/datum/map_template/engine/tesla
	name = "Edison's Bane"
	desc = "The Telsa Engine"
	mappath = 'maps/submaps/engine_submaps_vr/tether/engine_tesla.dmm'