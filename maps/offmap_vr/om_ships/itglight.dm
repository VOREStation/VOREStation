// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "itglight.dmm"
#endif

// Map template for spawning the shuttle
/datum/map_template/om_ships/itglight
	name = "OM Ship - ITG Dauntless (New Z)"
	desc = "A small, well armed interstellar cargo ship!!"
	mappath = 'itglight.dmm'

/area/itglight
	requires_power = 1
	icon_state = "purple"

/area/itglight/cockpit
	name = "Dauntless - Cockpit"
/area/itglight/captain
	name = "Dauntless - Captain's Quarters"
/area/itglight/readyroom
	name = "Dauntless - Ready Room"
/area/itglight/metingroom
	name = "Dauntless - Meeting Room"
/area/itglight/forehall
	name = "Dauntless - Fore Hall"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/itglight/starboardcargo
	name = "Dauntless - Starboard Cargo Bay"
/area/itglight/starboardhighsec
	name = "Dauntless - Starboard Secure Cargo"
/area/itglight/starboarddocking
	name = "Dauntless - Starboard Docking Port"
/area/itglight/portcargo
	name = "Dauntless - Port Cargo Bay"
/area/itglight/porthighsec
	name = "Dauntless - Port Secure Cargo"
/area/itglight/portdocking
	name = "Dauntless - Port Docking Port"
/area/itglight/common
	name = "Dauntless - Common Area"
/area/itglight/lockers
	name = "Dauntless - Locker Room"
/area/itglight/passengersleeping
	name = "Dauntless - Passenger Sleeping Barracks"
/area/itglight/showers
	name = "Dauntless - Showers"
/area/itglight/restrooms
	name = "Dauntless - Restrooms"
/area/itglight/afthall
	name = "Dauntless - Aft Hall"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/itglight/medbay
	name = "Dauntless - Medbay"
/area/itglight/kitchen
	name = "Dauntless - Kitchen"
/area/itglight/crew1
	name = "Dauntless - Crew Quarters - 1"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/itglight/crew2
	name = "Dauntless - Crew Quarters - 2"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/itglight/crew3
	name = "Dauntless - Crew Quarters - 3"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/itglight/crew4
	name = "Dauntless - Crew Quarters - 4"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/itglight/shuttlebay
	name = "Dauntless - Shuttle Bay"
/area/itglight/starboardengi
	name = "Dauntless - Starboard Engineering"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/itglight/starboardsolars
	name = "Dauntless - Starboard Solars"
/area/itglight/portengi
	name = "Dauntless - Port Engineering"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/itglight/portsolars
	name = "Dauntless - Port Solars"

/area/shuttle/itglightshuttle
	name = "ITG Shuttlecraft"
	requires_power = 1
	dynamic_lighting = 1

// The 'Dauntless'
/obj/effect/overmap/visitable/ship/itglight
	name = "ITG Dauntless"
	icon_state = "serb_destroyer_g"
	desc = "Spacefaring vessel. Friendly IFF detected."
	scanner_desc = @{"[i]Registration[/i]: ITG Dauntless
[i]Class[/i]: Small Cargo Frigate (Low Displacement)
[i]Transponder[/i]: Transmitting (CIV), non-hostile"
[b]Notice[/b]: May carry passengers"}
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_SMALL
	initial_generic_waypoints = list("itglight_fore", "itglight_aft", "itglight_port", "itglight_starboard", "itglight_port_dock", "itglight_starboard_dock")
	initial_restricted_waypoints = list("ITG Shuttlecraft" = list("omship_spawn_itglightshuttle"))
	fore_dir = NORTH

	skybox_icon = 'itglight.dmi'
	skybox_icon_state = "skybox"
	skybox_pixel_x = 425
	skybox_pixel_y = 200

/obj/effect/overmap/visitable/ship/itglight/build_skybox_representation()
	..()
	if(!cached_skybox_image)
		return
	cached_skybox_image.add_overlay("glow")

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/itglightshuttle
	name = "shuttle control console"
	shuttle_tag = "ITG Shuttlecraft"

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/itglightshuttle
	name = "ITG Dauntless - Shuttle Bay"
	base_area = /area/itglight/shuttlebay
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "omship_spawn_itglightshuttle"
	docking_controller = "itglight_shuttlebay"
	shuttle_type = /datum/shuttle/autodock/overmap/itglightshuttle

// The 'shuttle'
/datum/shuttle/autodock/overmap/itglightshuttle
	name = "ITG Shuttlecraft"
	current_location = "omship_spawn_itglightshuttle"
	docking_controller_tag = "itglightshuttle_docker"
	shuttle_area = /area/shuttle/itglightshuttle
	fuel_consumption = 0
	defer_initialisation = TRUE

/obj/machinery/photocopier/faxmachine/itglight
	department = "ITG Dauntless"
	desc = "The ship's fax machine! It's a safe assumption that most of the departments listed aren't on your ship, since the ship only has one."

/obj/item/paper/Dauntless
	name = "Notes about Dauntless"
	info = {"<font size=1>Welcome to the Ironcrest Transport Group</font><br><br>
	<h4>ITG Dauntless</h4>
	Welcome to the Dauntless, there are a few things you should know.<br><br>
	WRITE DOWN THE DOCKING CODES<br>
	You can find them in the Captain's Quarters, and on the shuttle control computers. Keep them handy, just in case.<br><br>
	<h4>DON'T OVERDO IT</h4>
	The Dauntless is FAST, but if you get her up to interstellar speeds, it's hard to slow back down again.<br><br>
	Additionally, exercise extreme caution around rocks and dust. <br>
	She has six point defense turrets, but her armor is thin, and she hasn't got any fancy shields. <br>
	She's not a combat ship, and she demands a competent pilot to treat her right.<br><br>
	Also d1a2 is best port, just saying.<br><br>
	Also the ship is 150 meters long and 92 meters wide, in case that is ever relevent."}