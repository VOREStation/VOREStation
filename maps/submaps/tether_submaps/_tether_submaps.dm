// This causes tether submap maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
/datum/map_template/tether_lateload
	allow_duplicates = FALSE

/// Static - Always Loaded
/datum/map_template/tether_lateload/tether_ships
	name = "Tether - Ships"
	desc = "Ship transit map and whatnot."
	mappath = 'maps/submaps/tether_submaps/tether_ships.dmm'



/// Away Missions
/datum/map_template/tether_lateload/away_beach
	name = "Desert Planet - Z1 Beach"
	desc = "The beach away mission."
	mappath = 'maps/submaps/tether_submaps/beach/beach.dmm'
/datum/map_template/tether_lateload/away_beach_cave
	name = "Desert Planet - Z2 Cave"
	desc = "The beach away mission's cave."
	mappath = 'maps/submaps/tether_submaps/beach/cave.dmm'
