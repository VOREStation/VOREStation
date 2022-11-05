// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "lunaship.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/aro3
	name = "OM Ship - LUNA (New Z)"
	desc = "It's LUNA! As a spaceship."
	mappath = 'lunaship.dmm'

/area/lunaship
	requires_power = 1
	has_gravity = 1

/area/lunaship/cockpit
	name = "LUNA - Control Core"
/area/lunaship/office
	name = "LUNA - Office"
/area/lunaship/hallway_port
	name = "LUNA - Port EVA"
/area/lunaship/hallway_starboard
	name = "LUNA - Starboard EVA"
/area/lunaship/park
	name = "LUNA - Park"
/area/lunaship/bar
	name = "LUNA - Bar"
/area/lunaship/medical
	name = "LUNA - Medical"
/area/lunaship/robotics_bay
	name = "LUNA - Robotics Bay"
/area/lunaship/engineering
	name = "LUNA - Engineering"


/turf/simulated/floor/water/indoors/surfluid
	name = "surfluid pool"
	desc = "A pool of inky-black fluid that shimmers oddly in the light if hit just right."
	description_info = "Surfluid is a protean's main method of production, using swarms of nanites to process raw materials into finished products at the cost of immense amounts of energy."
	color = "#222222"
	outdoors = OUTDOORS_NO
	reagent_type = "liquid_protean"

// The 'ship'
/obj/effect/overmap/visitable/ship/lunaship
	name = "LUNA"
	desc = "Spacefaring vessel. Friendly IFF detected."
	icon_state = "moe_frigate"
	scanner_desc = @{"[i]Registration[/i]: LUNA
[i]Class[/i]: Large Corvette (Low Displacement)
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Automated vessel"}
	color = "#00aaff" //Bluey
	vessel_mass = 2000
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list("lunaship_foreport", "lunaship_forestbd", "lunaship_aftport", "lunaship_aftstbd", "lunaship_fore", "lunaship_port", "lunaship_stbd", "lunaship_aft")
	fore_dir = NORTH
	known = FALSE