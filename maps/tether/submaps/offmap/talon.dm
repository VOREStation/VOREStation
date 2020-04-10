/var/const/access_talon = 301
/datum/access/talon
	id = access_talon
	access_type = ACCESS_TYPE_PRIVATE

///////////////////////////
//// Spawning and despawning
var/global/list/latejoin_talon = list()
/obj/effect/landmark/talon
	name = "JoinLateTalon"
	delete_me = 1

/obj/effect/landmark/talon/New()
	latejoin_talon += loc // Register this turf as tram latejoin.
	..()

/datum/spawnpoint/talon
	display_name = "ITV Talon Cryo"
	restrict_job = list("Talon Captain", "Talon Pilot", "Talon Engineer", "Talon Doctor", "Talon Guard")
	msg = "has come out of cryostasis"
	announce_channel = "Talon"

/datum/spawnpoint/talon/New()
	..()
	turfs = latejoin_talon

/obj/machinery/cryopod/talon
	announce_channel = "Talon"
	on_store_message = "has entered cryogenic storage."
	on_store_name = "ITV Talon Cryo"
	on_enter_visible_message = "starts climbing into the"
	on_enter_occupant_message = "You feel cool air surround you. You go numb as your senses turn inward."
	on_store_visible_message_1 = "hums and hisses as it moves"
	on_store_visible_message_2 = "into cryogenic storage."

/obj/effect/landmark/map_data/talon
    height = 2

///////////////////////////
//// The Talon
/obj/effect/overmap/visitable/ship/talon
	name = "Talon"
	desc = "A semi-modern make of ship from Haephestus, registered as the ITV Talon."
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list("talon_fore", "talon_aft", "talon_port", "talon_starboard")
	initial_restricted_waypoints = list("Talon's boat" = list("offmap_spawn_talonboat"), "Talon lifeboat" = list("offmap_spawn_talon_lifeboat"))

/*
/obj/effect/overmap/visitable/ship/talon/get_skybox_representation()
	var/image/I = image('aro.dmi', "skybox")
	I.pixel_x = 200
	I.pixel_y = 200
	return I
*/

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/talonboat
	name = "boat control console"
	shuttle_tag = "Talon's boat"
	req_one_access = list(access_talon)

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/talonboat
	name = "Talon's boat bay"
	base_area = /area/talon/deckone/central_hallway
	base_turf = /turf/simulated/floor/tiled/monotile
	landmark_tag = "offmap_spawn_talonboat"
	docking_controller = "talon_boatbay"
	shuttle_type = /datum/shuttle/autodock/overmap/talonboat

// The talon's boat
/datum/shuttle/autodock/overmap/talonboat
	name = "Talon's boat"
	current_location = "offmap_spawn_talonboat"
	docking_controller_tag = "talonboat_docker"
	shuttle_area = /area/shuttle/talonboat
	fuel_consumption = 2
	defer_initialisation = TRUE

/area/shuttle/talonboat
	name = "Talon's Boat"

///////////////////////////
//// The Lifeboat
/obj/effect/overmap/visitable/ship/landable/talon_lifeboat
	name = "Talon lifeboat"
	desc = "A tiny engineless lifeboat from the ITV Talon."
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Talon lifeboat"

/*
/obj/effect/overmap/visitable/ship/talon_lifeboat/landable/get_skybox_representation()
	var/image/I = image('aro.dmi', "skybox")
	I.pixel_x = 200
	I.pixel_y = 200
	return I
*/

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/talon_lifeboat
	name = "lifeboat control console"
	shuttle_tag = "Talon lifeboat"
	req_one_access = list(access_talon)

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/talon_lifeboat
	name = "Talon lifeboat dock"
	base_area = /area/talon/maintenance/decktwo_aft
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "offmap_spawn_talon_lifeboat"
	docking_controller = "talon_lifeboatbay"
	shuttle_type = /datum/shuttle/autodock/overmap/talon_lifeboat

// The talon's boat
/datum/shuttle/autodock/overmap/talon_lifeboat
	name = "Talon lifeboat"
	current_location = "offmap_spawn_talon_lifeboat"
	docking_controller_tag = "talonlifeboat_docker"
	shuttle_area = /area/talon/decktwo/lifeboat
	fuel_consumption = 0
	defer_initialisation = TRUE

///////////////////////////
//// The Various Machines
/obj/machinery/telecomms/allinone/overmap/talon
	freq_listening = list(PUB_FREQ, TALON_FREQ)

/obj/item/weapon/paper/talon_shields
	name = "to whatever asshole"
	info = {"to whatever <b>asshole</b> keeps resetting the shield generator,<br>\
please stop fucking around before you get us all killed. thanks.<br>\
<br>\
to whoever has to fix this,<br>\
humanoid lifeforms <b>off</b> so we can get outside unless someone is trying to kill us,<br>\
atmospheric thing <b>off</b> unless all the air is leaving,<br>\
hull shield <b>on</b> because it saves a lot of power,<br>\
the last one <b>on</b> so it covers deck one,<br>\
radius of 26 is pretty good,<br>\
adjust input cap so it doesn't fuck the rest of the ship<br>\
good luck<br>\
<br>\
<i>Harry Townes</i>"}

/obj/item/weapon/paper/talon_lifeboat
	name = "Survival Directions"
	info = {"<h3>Survival Directions</h3><br>
<b>Only jettison lifeboat into space if no other means of survival available.</b><br>
First attempt to protect lifeboat by means of shield generator in bubble mode until help arrives.<br>
Do not attempt to exit lifeboat without wearing proper protective equipment and setting up an in-situ airlock. This can be done using metalfoam and inflatable barriers.<br>
If lifeboat destruction is imminent, jettison lifeboat into space.<br>
Once in open space, consider disabling nonessential power-consuming electronics via the APC, or even disabling the APC entirely, and turning it on at invernals as necessary.<br>
A subspace radio has been provided to request help.<br>
((OOC: You can also pray/ahelp.))
"}

//Prevents remote control of drones
/obj/machinery/drone_fabricator/talon
	name = "somewhat glitchy drone fabricator"
	desc = "Obtained from a derelict, it seems to work sometimes, not work sometimes, and work TOO good sometimes. Didn't come with a control console either..."

/obj/machinery/drone_fabricator/talon/create_drone(var/client/player)
	var/mob/living/silicon/robot/drone/new_drone = ..()
	if(!istype(new_drone))
		return

	new_drone.foreign_droid = TRUE

	return new_drone

/obj/machinery/power/smes/buildable/offmap_spawn/New()
	..(1)
	charge = 1e7
	RCon = TRUE
	input_level = input_level_max
	output_level = output_level_max
	input_attempt = TRUE

/obj/machinery/power/apc/talon
	req_access = list()
	req_one_access = list(access_talon)

/obj/machinery/power/apc/talon/hyper
	cell_type = /obj/item/weapon/cell/hyper

/obj/machinery/alarm/talon
	req_access = list()
	req_one_access = list(access_talon)

/obj/machinery/door/firedoor/glass/talon
	req_access = list()
	req_one_access = list(access_talon)

/obj/machinery/door/firedoor/glass/talon/hidden/steel
	name = "\improper Emergency Shutter System"
	desc = "Emergency air-tight shutter, capable of sealing off breached areas. This model fits flush with the walls, and has a panel in the floor for maintenance."
	icon = 'icons/obj/doors/DoorHazardHidden_steel.dmi'

///////////////////////////
//// Computers
/obj/machinery/computer/security/talon_helmets
	name = "talon helmetcam console"
	network = list(NETWORK_TALON_HELMETS)
	req_access = list(access_talon)
/obj/item/weapon/circuitboard/security/talon_helmets
	name = T_BOARD("security camera monitor - talon helmetcams")
	build_path = /obj/machinery/computer/security/talon_helmets
	req_access = list(access_talon)

/obj/machinery/computer/security/talon_ship
	name = "talon shipcam console"
	network = list(NETWORK_TALON_SHIP)
	req_access = list(access_talon)
/obj/item/weapon/circuitboard/security/talon_ship
	name = T_BOARD("security camera monitor - talon shipcams")
	build_path = /obj/machinery/computer/security/talon_ship
	req_access = list(access_talon)

/obj/machinery/camera/network/talon
	network = list(NETWORK_TALON_SHIP)

// Talon ship cameras
/datum/computer_file/program/camera_monitor/talon_ship
	filename = "talscammon"
	filedesc = "Ship Camera Monitoring (Talon)"
	extended_desc = "This program allows remote access to the Talon's camera system."
	size = 10 //Smaller because limited scope
	nanomodule_path = /datum/nano_module/camera_monitor/talon_ship
	required_access = access_talon

/datum/nano_module/camera_monitor/talon_ship
	name = "Talon Ship Camera Monitor"
/datum/nano_module/camera_monitor/talon_ship/modify_networks_list(var/list/networks)
	networks.Cut()
	networks.Add(list(list("tag" = NETWORK_TALON_SHIP, "has_access" = 1)))
	return networks

// Talon helmet cameras
/datum/computer_file/program/camera_monitor/talon_helmet
	filename = "talhcammon"
	filedesc = "Helmet Camera Monitoring (Talon)"
	extended_desc = "This program allows remote access to Talon helmet camera systems."
	size = 4 //Smaller because limited scope
	nanomodule_path = /datum/nano_module/camera_monitor/talon_helmet
	required_access = access_talon

/datum/nano_module/camera_monitor/talon_helmet
	name = "Talon Helmet Camera Monitor"
/datum/nano_module/camera_monitor/talon_helmet/modify_networks_list(var/list/networks)
	networks.Cut()
	networks.Add(list(list("tag" = NETWORK_TALON_HELMETS, "has_access" = 1)))
	return networks

/datum/computer_file/program/power_monitor/talon
	filename = "tpowermonitor"
	filedesc = "Power Monitoring (Talon)"
	required_access = access_talon
/datum/computer_file/program/alarm_monitor/talon
	filename = "talarmmonitoreng"
	filedesc = "Alarm Monitoring (Talon)"
	required_access = access_talon
/datum/computer_file/program/rcon_console/talon
	filename = "trconconsole"
	filedesc = "RCON Remote Control (Talon)"
	required_access = access_talon
/datum/computer_file/program/atmos_control/talon
	filename = "tatmoscontrol"
	filedesc = "Atmosphere Control (Talon)"
	required_access = access_talon
/datum/computer_file/program/suit_sensors/talon
	filename = "tsensormonitor"
	filedesc = "Suit Sensors Monitoring (Talon)"
	required_access = access_talon

// Modular computer/console presets
/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/pilot
	name = "pilot's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/pilot/install_default_programs()
	..()

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/engineer
	name = "engineer's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/engineer/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/power_monitor/talon())
	hard_drive.store_file(new/datum/computer_file/program/alarm_monitor/talon())
	hard_drive.store_file(new/datum/computer_file/program/rcon_console/talon())
	hard_drive.store_file(new/datum/computer_file/program/atmos_control/talon())

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/security
	name = "guard's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/security/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/talon_ship())

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/medical
	name = "doctor's laptop"

/obj/item/modular_computer/laptop/preset/custom_loadout/standard/talon/medical/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/suit_sensors/talon())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/talon_helmet())
	set_autorun("tsensormonitor")

//Generic modular consoles scattered around
/obj/item/modular_computer/console/preset/talon
	name = "talon modular computer"

/obj/item/modular_computer/console/preset/talon/install_default_hardware()
	..()
	processor_unit = new/obj/item/weapon/computer_hardware/processor_unit(src)
	tesla_link = new/obj/item/weapon/computer_hardware/tesla_link(src)
	hard_drive = new/obj/item/weapon/computer_hardware/hard_drive/super(src)
	network_card = new/obj/item/weapon/computer_hardware/network_card/wired(src)
	nano_printer = new/obj/item/weapon/computer_hardware/nano_printer(src)

/obj/item/modular_computer/console/preset/talon/install_default_programs()
	..()
	hard_drive.store_file(new/datum/computer_file/program/power_monitor/talon())
	hard_drive.store_file(new/datum/computer_file/program/alarm_monitor/talon())
	hard_drive.store_file(new/datum/computer_file/program/rcon_console/talon())
	hard_drive.store_file(new/datum/computer_file/program/atmos_control/talon())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/talon_ship())
	hard_drive.store_file(new/datum/computer_file/program/suit_sensors/talon())
	hard_drive.store_file(new/datum/computer_file/program/camera_monitor/talon_helmet())