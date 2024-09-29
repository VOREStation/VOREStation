// Compile in the map for CI testing if we're testing compileability of all the maps
#if MAP_TEST
#include "ert.dmm"
#endif


// Map template for spawning the shuttle
/datum/map_template/om_ships/ert_ship
	name = "OM Ship - ERT Ship (New Z)"
	desc = "NT Emergency Response Ship."
	mappath = 'ert.dmm'

	// The ship's area(s)
/area/ship/ert
	name = "\improper ERT Ship (Use a Subtype!)"
	icon_state = "shuttle2"
	requires_power = 1
	dynamic_lighting = 1

/area/ship/ert/engine
	name = "\improper NRV Von Braun - Engine Bay"
	icon_state = "engine"

/area/ship/ert/engineering
	name = "\improper NRV Von Braun - Engineering Control Room"
	icon_state = "engine_monitoring"
	
/area/ship/ert/eng_storage
	name = "\improper NRV Von Braun - Engineering Storage"
	icon_state = "storage"

/area/ship/ert/bridge
	name = "\improper NRV Von Braun - Bridge"
	icon_state = "centcom_command"

/area/ship/ert/atmos
	name = "\improper NRV Von Braun - Atmospherics"
	icon_state = "atmos"
                                   
/area/ship/ert/mech_bay
	name = "\improper NRV Von Braun - RIG & Mech Bay"
	icon_state = "yellow"

/area/ship/ert/armoury_st
	name = "\improper NRV Von Braun - Standard Armoury"
	icon_state = "security"

/area/ship/ert/armoury_dl
	name = "\improper NRV Von Braun - Delta Armoury"
	icon_state = "darkred"

/area/ship/ert/hangar
	name = "\improper NRV Von Braun - Hangar"
	icon_state = "hangar"

/area/ship/ert/barracks
	name = "\improper NRV Von Braun - Barracks"
	icon_state = "centcom_crew"

/area/ship/ert/med
	name = "\improper NRV Von Braun - Medical"
	icon_state = "centcom_medical"

/area/ship/ert/med_surg
	name = "\improper NRV Von Braun - Surgery"
	icon_state = "surgery"

/area/ship/ert/hallways
	name = "\improper NRV Von Braun - Fore Corridors"
	icon_state = "centcom"

/area/ship/ert/hallways_aft
	name = "\improper NRV Von Braun - Aft Corridors"
	icon_state = "centcom_hallway1"

/area/ship/ert/dock_star
	name = "\improper NRV Von Braun - Starboard Airlock"
	icon_state = "exit"

/area/ship/ert/dock_port
	name = "\improper NRV Von Braun - Port Airlock"
	icon_state = "exit"

/area/ship/ert/teleporter
	name = "\improper NRV Von Braun - Teleporter"
	icon_state = "teleporter"

/area/ship/ert/commander
	name = "\improper NRV Von Braun - Commander's Room"
	icon_state = "head_quarters"

/area/ship/ert/gunnery
	name = "\improper NRV Von Braun - Cannon Control Room"
	icon_state = "security_sub"

/area/ship/ert/brig
	name = "\improper NRV Von Braun - Prisoner Holding Area"
	icon_state = "brig"

/area/shuttle/ert_ship_boat
	name = "\improper NRB Robineau"
	icon_state = "yellow"
	requires_power = 0

// The 'shuttle' of the excursion shuttle
// /datum/shuttle/autodock/overmap/ert_ship
//	name = "Unknown Vessel"
//	warmup_time = 0
//	current_location = "tether_excursion_hangar"
//	docking_controller_tag = "expshuttle_docker"
//	shuttle_area = list(/area/ship/ert/engineering, /area/ship/ert/engineeringcntrl, /area/ship/ert/bridge, /area/ship/ert/atmos, /area/ship/ert/air, /area/ship/ert/engine, /area/ship/ert/engine1, /area/ship/ert/armoury, /area/ship/ert/hangar, /area/ship/ert/barracks, /area/ship/ert/fighter, /area/ship/ert/med, /area/ship/ert/med1, /area/ship/ert/hall1, /area/ship/ert/hall2)
//	fuel_consumption = 3

// The 'ship'
/obj/effect/overmap/visitable/ship/ert_ship
	name = "NRV Von Braun"
	icon_state = "oberth_destroyer_g"
	desc = "Spacefaring vessel. Broadcasting Corporate Emergency Responder IFF."
	scanner_desc = @{"[i]Registration[/i]: Nanotrasen RRV Von Braun
[i]Class[/i]: [i]Kepler[/i]-class Frigate
[i]Transponder[/i]: Broadcasting (ER-CORP)
[b]Notice[/b]: Impeding or interfering with emergency response vessels is a breach of numerous interstellar codes. Approach with caution."}
	vessel_mass = 8000
	vessel_size = SHIP_SIZE_LARGE
	fore_dir = EAST
	initial_generic_waypoints = list("ert_ship_near_fore", "ert_ship_near_aft", "ert_ship_near_port", "ert_ship_near_star", "ert_ship_port", "ert_ship_star", "ert_ship_base_dock", "omship_spawn_ert_lander")
//	initial_restricted_waypoints = list("NRV Von Braun's Bay" = list("omship_spawn_ert_lander"))

/obj/effect/landmark/map_data/ert_ship
	height = 1

/obj/effect/shuttle_landmark/premade/ert_ship_port
	name = "NRV Von Braun - Port Airlock"
	landmark_tag = "ert_ship_port"

/obj/effect/shuttle_landmark/premade/ert_ship_star
	name = "NRV Von Braun - Starboard Airlock"
	landmark_tag = "ert_ship_star"

/obj/effect/shuttle_landmark/premade/ert_ship_near_fore
	name = "Near NRV Von Braun (Fore)"
	landmark_tag = "ert_ship_near_fore"

/obj/effect/shuttle_landmark/premade/ert_ship_near_aft
	name = "Near NRV Von Braun (Aft)"
	landmark_tag = "ert_ship_near_aft"

/obj/effect/shuttle_landmark/premade/ert_ship_near_port
	name = "Near NRV Von Braun (Port)"
	landmark_tag = "ert_ship_near_port"

/obj/effect/shuttle_landmark/premade/ert_ship_near_star
	name = "Near NRV Von Braun (Starboard)"
	landmark_tag = "ert_ship_near_star"

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/ert_ship_boat
	name = "boat control console"
	shuttle_tag = "NRB Robineau"

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/ert_ship_boat
	name = "NRV Von Braun's Bay"
	base_area = /area/ship/ert/hangar
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "omship_spawn_ert_lander"
	docking_controller = "ert_boarding_shuttle_dock"
	shuttle_type = /datum/shuttle/autodock/overmap/ert_ship_boat

// The 'shuttle'
/datum/shuttle/autodock/overmap/ert_ship_boat
	name = "NRB Robineau"
	current_location = "omship_spawn_ert_lander"
	docking_controller_tag = "ert_boarding_shuttle"
	shuttle_area = /area/shuttle/ert_ship_boat
	fuel_consumption = 0
	defer_initialisation = TRUE

/obj/machinery/cryopod/ert_ship
	announce_channel = "Response Team"
	on_store_message = "has entered cryogenic storage."
	on_store_name = "NRV Von Braun Cryo"
	on_enter_visible_message = "starts climbing into the"
	on_enter_occupant_message = "You feel cool air surround you. You go numb as your senses turn inward."
	on_store_visible_message_1 = "hums and hisses as it moves"
	on_store_visible_message_2 = "into cryogenic storage."
	
//Misc Stuff
/obj/item/paper/ert_armory_cells
	name = "ERT Armory Cell Supply"
	info = {"To All Current ERT Members,<br>\
All energy weapons here come installed with standard power cells, but the spares on the racks are self-charging tech.<br>\
<br>\
Some fancy new micro-RTG cells or something, I think?<br>\
<br>\
Point is they're fairly expensive and probably prototypes or something, so for the love of God and your own career don't lose any of them and put them back when you return from a sortie.<br>\
<br>\
<i>Lt. Cmdr. Sykes</i>"}

/obj/item/paper/vonbraun_shields
	name = "NRV Von Braun Shield Configuration Documentation"
	info = {"To All Current ERT Members,<br>\
Be advised that use of the NRV Von Braun's shield generator (located adjacent to this document) is strongly recommended when responding to calls, but also that it is not impervious, nor is the ship's point defense system flawless.<br>\
<br>\
Recommended settings as follows:<br>\
Photonic: Off (PD will not work with it enabled!)<br>\
EM: On<br>\
Humanoids: Off<br>\
Atmospheric: Off<br>\
Hull Shield: On<br>\
Radius: 42<br>\
<br>\
The shield generator will tax the Von Braun's reserves greatly so try to use it sparingly. Do not be afraid to use it however, as the Von Braun represents the Company making a <i>significant</i> investment in this sector's future. I can bail you out if the occasional intern goes missing or you break something minor, but if you go flying this thing through an asteroid belt and get massive holes blown in it Central <b>will</b> make <u>everyone</u> involved disappear <b><u>permanently</b></u>.<br>\
<br>\
<i>Lt. Cmdr. Sykes</i>"}

/obj/item/paper/vonbraun_cannon
	name = "NRV Von Braun O.F.D. Console"
	info = {"To All Current ERT Members,<br>\
Given recent events, Central has finally cleared the paperwork that allowed us to install an Obstruction Field Disperser, or 'O.F.D.', on the Von Braun. Please note we had to get rid of the mech bay (that nobody was allowed to use anyway) so that's where you'll find it. Of course if you're reading this you already found it.<br>\
<br>\
They have thoughtfully provided a sensor console for aiming purposes. Check your targets before firing and for the love of all that is holy make sure the firing port is OPEN before you pull the trigger (that's the big button on the wall to your right) or the whole thing will blow up in your face.<br>\
<br>\
To aim the thing, input your aim direction, smack the 'PRECALIBRATE' button, and then fiddle the numbers up and down until you hit 100% accuracy. If the number is in the right spot it adds 25%, if you have a right number but it's in the wrong spot it adds 17%. A bit obtuse but you'll get the hang of it quickly.<br>\
<br>\
Loading it is simple. Just roll one of the big charges out of the racks and into the loading cradle, then give it a good shove. <u>Do not fall into the loading mechanism.</u> Make your shots count. Use the BLUE charges for electrical storms and ion clouds, and the RED charges for everything else (meteors, dust, critters). Don't bother trying to fire it at other ships, they have shields and maneuvering thrusters.<br>\
<br>\
<i>Lt. Cmdr. Sykes</i><br>\
<br>\
P.S. Before any of you ask, no, you cannot fire yourself or your teammates out of it for boarding purposes or 'hot drops', whatever those are. So please don't try."}

/obj/machinery/computer/cryopod/ert
	name = "responder oversight console"
	desc = "An interface between responders and the cryo oversight systems tasked with keeping track of all responders who enter or exit cryostasis."
	circuit = "/obj/item/circuitboard/robotstoragecontrol"

	storage_type = "responders"
	storage_name = "ERT Oversight Control"
	allow_items = 1