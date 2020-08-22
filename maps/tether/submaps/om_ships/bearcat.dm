// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "bearcat.dmm"
#endif

// -- Datums -- //
/datum/map_template/om_ships/bearcat
	name = "OM Ship - Bearcat"
	desc = "An old salvage or exploration ship, abandoned but possibly repairable."
	mappath = 'bearcat.dmm'

/obj/effect/overmap/visitable/ship/bearcat
	name = "Abandoned Salvage Ship"
	desc = "An old and abandoned salvage ship."
	scanner_desc = @{"[i]Registration[/i]: IRV Bearcat
[i]Class:[/i] Corvette
[i]Transponder[/i]: Transmitting \'Keep-Away\' Signal
[b]Notice[/b]: May be salvagable."}
	known = FALSE
	color = "#ee3333" //Redish, so it stands out against the other debris-like icons
	initial_generic_waypoints = list("bearcat_se", "bearcat_sw", "bearcat_nw", "bearcat_ne", "bearcat_dock_w", "bearcat_dock_e")
	vessel_mass = 4000
	vessel_size = SHIP_SIZE_LARGE

// -- Objs -- //

/area/ship/scrap
	name = "\improper Generic Ship"
	has_gravity = 0		//predates artificial gravity - won't matter much due to all the walls to push off of!

/area/ship/scrap/crew
	name = "\improper Crew Compartemnts"
	icon_state = "hallC"

/area/ship/scrap/crew/kitchen
	name = "\improper Galley"
	icon_state = "kitchen"

/area/ship/scrap/crew/dorms
	name = "\improper Dorms"
	icon_state = "crew_quarters"

/area/ship/scrap/crew/saloon
	name = "\improper Saloon"
	icon_state = "conference"

/area/ship/scrap/crew/toilets
	name = "\improper Bathrooms"
	icon_state = "toilet"

/area/ship/scrap/crew/wash
	name = "\improper Washroom"
	icon_state = "locker"

/area/ship/scrap/crew/medbay
	name = "\improper Medical Bay"
	icon_state = "medbay"

/area/ship/scrap/cargo
	name = "\improper Cargo Hold"
	icon_state = "quartstorage"

/area/ship/scrap/dock
	name = "\improper Docking Bay"
	icon_state = "entry"

/area/ship/scrap/unused1
	name = "\improper Unused Compartment #1"
	icon_state = "green"

/area/ship/scrap/unused2
	name = "\improper Unused Compartment #2"
	icon_state = "yellow"

/area/ship/scrap/unused3
	name = "\improper Unused Compartment #3"
	icon_state = "blueold"

/area/ship/scrap/maintenance
	name = "\improper Maintenance Compartments"
	icon_state = "storage"

/area/ship/scrap/maintenance/storage
	name = "\improper Tools Storage"
	icon_state = "eva"

/area/ship/scrap/maintenance/atmos
	name = "\improper Atmospherics Comparment"
	icon_state = "atmos"
	music = list('sound/ambience/ambiatm1.ogg')

/area/ship/scrap/maintenance/power
	name = "\improper Power Compartment"
	icon_state = "engine_smes"

/area/ship/scrap/maintenance/engine
	name = "\improper Engine Compartments"
	icon_state = "engine"
	music = list('sound/ambience/ambisin1.ogg','sound/ambience/ambisin2.ogg','sound/ambience/ambisin3.ogg')

/area/ship/scrap/command
	name = "\improper Command Deck"
	icon_state = "centcom"
	music = list('sound/ambience/signal.ogg')

/area/ship/scrap/command/captain
	name = "\improper Captain's Quarters"
	icon_state = "captain"

/area/ship/scrap/comms
	name = "\improper Communications Relay"
	icon_state = "tcomsatcham"
	music = list('sound/ambience/signal.ogg')

/area/ship/scrap/shuttle/
	requires_power = 0
	luminosity = 1
	dynamic_lighting = 0

/area/ship/scrap/shuttle/ingoing
	name = "\improper Docking Bay #1"
	icon_state = "tcomsatcham"

/area/ship/scrap/shuttle/outgoing
	name = "\improper Docking Bay #1"
	icon_state = "tcomsatcham"