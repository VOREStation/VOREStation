	// Compile in the map for CI testing if we're testing compileability of all the maps
#ifdef MAP_TEST
#include "mercship.dmm"
#endif


// Map template for spawning the shuttle
/datum/map_template/om_ships/manta_ship
	name = "OM Ship - Mercenary Cruiser (New Z)"
	desc = "Mercenary Manta Cruiser."
	mappath = "maps/submaps/admin_use_vr/kk_mercship.dmm"

// The ship's area(s)
/area/ship/manta
	name = "\improper ERT Ship (Use a Subtype!)"
	icon_state = "shuttle2"
	requires_power = 1
	dynamic_lighting = 1

/area/ship/manta/engine
	name = "\improper Mercenary Cruiser - Engine Bay"
	icon_state = "engine"

/area/ship/manta/engineering
	name = "\improper Mercenary Cruiser - Engineering Control Room"
	icon_state = "engine_monitoring"

/area/ship/manta/bridge
	name = "\improper Mercenary Cruiser - Bridge"
	icon_state = "syndie-control"

/area/ship/manta/atmos
	name = "\improper Mercenary Cruiser - Atmospherics"
	icon_state = "atmos"

/area/ship/manta/mech_bay
	name = "\improper Mercenary Cruiser - Mech Bay"
	icon_state = "mechbay"

/area/ship/manta/armoury_st
	name = "\improper Mercenary Cruiser - Standard Armoury"
	icon_state = "armory"

/area/ship/manta/armoury_as
	name = "\improper Mercenary Cruiser - Assault Armoury"
	icon_state = "Tactical"

/area/ship/manta/hangar
	name = "\improper Mercenary Cruiser - Hangar"
	icon_state = "hangar"

/area/ship/manta/barracks
	name = "\improper Mercenary Cruiser - Barracks"
	icon_state = "syndie-elite"

/area/ship/manta/barracks/bed_1
	name = "\improper Mercenary Cruiser - Bunkroom 1"
	icon_state = "syndie-elite"

/area/ship/manta/barracks/bed_2
	name = "\improper Mercenary Cruiser - Bunkroom 2"
	icon_state = "syndie-elite"

/area/ship/manta/med
	name = "\improper Mercenary Cruiser - Medical"
	icon_state = "medbay"

/area/ship/manta/hallways_star
	name = "\improper Mercenary Cruiser - Starboard Corridors"
	icon_state = "smaint"

/area/ship/manta/hallways_port
	name = "\improper Mercenary Cruiser - Port Corridors"
	icon_state = "pmaint"

/area/ship/manta/hallways_aft
	name = "\improper Mercenary Cruiser - Aft Corridors"
	icon_state = "green"

/area/ship/manta/dock_star
	name = "\improper Mercenary Cruiser - Starboard Airlock"
	icon_state = "exit"

/area/ship/manta/dock_port
	name = "\improper Mercenary Cruiser - Port Airlock"
	icon_state = "exit"

/area/ship/manta/radiator_star
	name = "\improper Mercenary Cruiser - Starboard Radiator Array"
	icon_state = "east"

/area/ship/manta/radiator_port
	name = "\improper Mercenary Cruiser - Port Radiator Array"
	icon_state = "west"

/area/ship/manta/teleporter
	name = "\improper Mercenary Cruiser - Teleporter"
	icon_state = "teleporter"

/area/ship/manta/commander
	name = "\improper Mercenary Cruiser - Commander's Room"
	icon_state = "head_quarters"

/area/ship/manta/holding
	name = "\improper Mercenary Cruiser - Holding Cells"
	icon_state = "brig"

/area/ship/manta/recreation
	name = "\improper Mercenary Cruiser - Recreation & Supplies"
	icon_state = "recreation_area"

/area/ship/manta/gunnery
	name = "\improper Mercenary Cruiser - Gunnery"
	icon_state = "security_sub"

/area/ship/manta/magazine
	name = "\improper Mercenary Cruiser - Cannon Magazine"
	icon_state = "darkred"

/area/shuttle/manta_ship_boat
	name = "\improper SAARE Lander"
	icon_state = "syndie-ship"
	requires_power = 0

// The 'shuttle' of the excursion shuttle
// /datum/shuttle/autodock/overmap/manta_ship
//	name = "Unknown Vessel"
//	warmup_time = 0
//	current_location = "tether_excursion_hangar"
//	docking_controller_tag = "expshuttle_docker"
//	shuttle_area = list(/area/ship/manta/engineering, /area/ship/manta/engineeringcntrl, /area/ship/manta/bridge, /area/ship/manta/atmos, /area/ship/manta/air, /area/ship/manta/engine, /area/ship/manta/engine1, /area/ship/manta/armoury, /area/ship/manta/hangar, /area/ship/manta/barracks, /area/ship/manta/fighter, /area/ship/manta/med, /area/ship/manta/med1, /area/ship/manta/hall1, /area/ship/manta/hall2)
//	fuel_consumption = 3

// The 'ship'
/obj/effect/overmap/visitable/ship/manta_ship
	name = "SAARE Typhon Four-Niner"
	desc = "Spacefaring vessel. Broadcasting Private Military Contractor IFF."
	scanner_desc = @{"[i]Registration[/i]: SAARE Mercenary Cruiser Typhon Four-Niner
[i]Class[/i]: [i]Manta[/i]-class Cruiser
[i]Transponder[/i]: Broadcasting (PMC)
[b]Notice[/b]: SAARE are unlikely to tolerate civilian or corporate personnel interfering with their affairs. Approach with caution."}
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list("manta_ship_near_fore", "manta_ship_near_aft", "manta_ship_near_port", "manta_ship_near_star", "manta_ship_port", "manta_ship_star", "manta_ship_base_dock", "omship_spawn_manta_lander")
	initial_restricted_waypoints = list("Mercenary Cruiser's Bay" = list("omship_spawn_manta_lander"))

/obj/effect/landmark/map_data/manta_ship
	height = 1

/obj/effect/shuttle_landmark/premade/manta_ship_port
	name = "SAARE Cruiser - Port Airlock"
	landmark_tag = "manta_ship_port"

/obj/effect/shuttle_landmark/premade/manta_ship_star
	name = "SAARE Cruiser - Starboard Airlock"
	landmark_tag = "manta_ship_star"

/obj/effect/shuttle_landmark/premade/manta_ship_near_fore
	name = "Near SAARE Cruiser (Fore)"
	landmark_tag = "manta_ship_near_fore"

/obj/effect/shuttle_landmark/premade/manta_ship_near_aft
	name = "Near SAARE Cruiser (Aft)"
	landmark_tag = "manta_ship_near_aft"

/obj/effect/shuttle_landmark/premade/manta_ship_near_port
	name = "Near SAARE Cruiser (Port)"
	landmark_tag = "manta_ship_near_port"

/obj/effect/shuttle_landmark/premade/manta_ship_near_star
	name = "Near SAARE Cruiser (Starboard)"
	landmark_tag = "manta_ship_near_star"

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/manta_ship_boat
	name = "boat control console"
	shuttle_tag = "Boarding Craft"

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/manta_ship_boat
	name = "Mercenary Cruiser's Bay"
	base_area = /area/ship/manta/hangar
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "omship_spawn_manta_lander"
	docking_controller = "manta_boarding_shuttle_dock"
	shuttle_type = /datum/shuttle/autodock/overmap/manta_ship_boat

// The 'shuttle'
/obj/machinery/computer/shuttle_control/explore/manta_ship_boat
	name = "LC control console"
	shuttle_tag = "Boarding Craft"
	req_one_access = list(150)

/datum/shuttle/autodock/overmap/manta_ship_boat
	name = "Boarding Craft"
	current_location = "omship_spawn_manta_lander"
	docking_controller_tag = "manta_boarding_shuttle"
	shuttle_area = /area/shuttle/manta_ship_boat
	fuel_consumption = 0 //this thing is too big already, let's just handwave everything
	defer_initialisation = TRUE

/obj/effect/overmap/visitable/ship/landable/manta_ship_boat
	name = "SAARE Landing Craft"
	desc = "Spacefaring vessel. Broadcasting Private Military Contractor IFF."
	scanner_desc = @{"[i]Registration[/i]: SAARE Mercenary Cruiser Typhon Four-Niner's Lander
[i]Class[/i]: Unknown Shuttle-approximate
[i]Transponder[/i]: Broadcasting (PMC)
[b]Notice[/b]: SAARE are unlikely to tolerate civilian or corporate personnel interfering with their affairs. Approach with caution."}
	vessel_mass = 500
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Boarding Craft"

/obj/machinery/cryopod/manta_ship
	announce_channel = "Mercenary"
	on_store_message = "has entered cryogenic storage."
	on_store_name = "Mercenary Cruiser Cryo"
	on_enter_visible_message = "starts climbing into the"
	on_enter_occupant_message = "You feel cool air surround you. You go numb as your senses turn inward."
	on_store_visible_message_1 = "hums and hisses as it moves"
	on_store_visible_message_2 = "into cryogenic storage."

//Misc Stuff
/obj/item/paper/manta_shields
	name = "Shield Setup"
	info = {"To All Personnel,<br>\
The cruiser's shield generator is intended to keep asteroids and pesky railgun rounds off our ass, so make sure you use it if we get into a scuffle.<br>\
<br>\
Recommended settings as follows:<br>\
Photonic: Off (or else the point defense won't work!!)<br>\
Electromagnetic: On<br>\
Humanoid: Off<br>\
Atmosphere: Off<br>\
Hull Shield: On<br>\
Radius: 28 minimum<br>\
<br>\
The shield generator's a hungry beast and will drain the cruiser's reserves fairly quick, so don't overuse it. Don't be afraid to use it either, as this ship's a <i>serious</i> investment. If you fuck up, I <u>won't</u> be sticking my neck out for you, you get me? This 'Lieutenant Commander Sykes' asshole is enough of a pain already.<br>\
<br>\
<i>Capt. Thorne</i>"}

/obj/item/paper/manta_new_personnel_brief
	name = "Fresh Personnel Primer"
	info = {"To All <i>New</i> Personnel,<br>\
Welcome to your new home, the SAARE Typhon Four-Niner. This Manta-class Cruiser is equipped with everything you should ever need to conduct operations against any target we may encounter during our contracts. If you're reading this, you're probably in the Barracks right now; at the outer edge of the starboard wing are the Holding Cells. To the fore of the barracks is the Medbay, pray you don't end up there.<br>\
<br>\
Front and center is the Landing Craft Hangar, and just behind that is the Bridge. Off the Bridge, you'll find my quarters and the teleporter room. Aft of the Bridge is Engineering and the Engine Bay; I suggest steering clear unless you want to get an accidental dose of radiation. There's a pair of small airlocks at the back side which are used for crew transfer shuttles, and are a likely entry point for hostile boarders.<br>\
<br>\
Finally, over in the port wing you'll find the recreation area and kitchen along with all of the armory and outfitting space for weapons, armor, and even our mech. If you <i>somehow</i> get authorization to take that out you better bring it back in one piece, by the way; it wasn't cheap. If it gets wrecked I'm taking the repair and replacement costs out of your paychecks until it's paid off.<br>\
<br>\
You don't want to know how long it's going to take to pay off.<br>\
<br>\
<i>Capt. Thorne</i><br>\
<br>
P.S. If you need to refuel the lander for some reason, there's a spare fuel canister in that closet space in the port fore wing edge, opposite the assault armory."}

/obj/item/paper/manta_approach_tactics
	name = "Installation Approach"
	info = {"To All Personnel,<br>\
Word of advice: this ship isn't exactly sneaky, despite our best efforts. If we pull up around a major site <i>they're going to notice</i>. Now sure we have the whole transponder thing that should throw them off for a bit, but sooner or later they're gonna catch on, <i>especially</i> if you go in loud. Fortunately for you all, our handy-dandy little landing craft <i>is</i> stealthy, and can get you aboard most ships, stations, or outposts without too much fuss. Better yet it's an all-passive system, so you don't even need to turn it on or worry about some idiot accidentally turning it off.<br>\
<br>\
We've also been supplied with a few packs of 'liberated' SAARE gear for use as disguises, so use them if you need to. Sometimes the stealthy approach is the best path.<br>\
<br>\
<i>Capt. Thorne</i>"}

/obj/item/paper/manta_prisoners
	name = "Prisoner Management"
	info = {"To All Personnel,<br>\
I don't care if they're 'not being cooperative', for the love of fuck if another high-value prisoner 'disappears' under your watch <i>you are fucking next</i>, do I make myself clear? I don't care if it's some schmuck we picked up during a raid who happened to be in the wrong place at the wrong time, but if it's someone we're trying to extract information from or ransom or whatever then they better not vanish.<br>\
<br>\
<i>Capt. Thorne</i><br>\
<br>\
P.S. If you gotta cut 'em up or whatever try not to make too much of a mess, and clean up when you're done. Don't trail blood all over my damn ship, and don't get them killed by infections either."}

/obj/item/paper/manta_cannon_usage
	name = "Cannon Operation Instructions"
	info = {"To All Personnel,<br>\
Heads up people, we've got a new toy.<br>\
<br>\
According to the suits, that toy is an Obstruction Field Disperser. If you are reading this, you already found it, good job on not needing two hands and a map to find your own arse. Operation of the OFD is simple:<br>\
1. Load a charge from the magazine (located in the starboard aft section). You want an EM2-QUASAR for electrical storms or ion clouds, and an XP4-INDARRA for asteroids, dust clouds, and carp schools. Get someone else to handle loading if you need multiple consecutive shots. You have four of each.<br>\
2. Set strength and range/radius.<br>\
3. Aim and calibrate the ignition chamber. You need to get the right sequence of four numbers. A correct number ups the accuracy value by 25%. A correct number in the wrong slot adds 17%.<br>\
4. <b>OPEN THE FIRING PORT</b> with the big button to your right. Visually verify the port is open.<br>\
5. Press the big red FIRE button, once you have verified the loaded charge, the target, and that the port is open.<br>\
With any luck you hit and maybe blew some stupid space-fish into space-giblets. You're done!<br>\
<br>\
Do not fire the cannon whilst it's cooling down or whilst the port is closed, or it <b>will</b> explode. If you need to remove a loaded charge (for instance because your loader sent the wrong one) or clear a jam, use the airlock. No, the cannon cannot be used as a deployment system. Yes, I tried to get drop pods installed, but the suits are still waffling about the idea. Don't try to fire it at ships or stations, you'll probably miss.<br>\
<br>\
In the meantime, happy hunting. Go bag me some carp. The mech bay can be found in the port aft section opposite the magazine if you need to use the Gygax.<br>\
<br>\
<i>Capt. Thorne</i>"}

/obj/machinery/computer/cryopod/merc
	name = "mercenary oversight console"
	desc = "An interface between mercenaries and the cryo oversight systems tasked with keeping track of all mercenaries who enter or exit cryostasis."
	circuit = "/obj/item/circuitboard/robotstoragecontrol"

	storage_type = "mercenaries"
	storage_name = "Merc Oversight Control"
	allow_items = 1
