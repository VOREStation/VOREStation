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

/obj/machinery/cryopod/robot/talon
	announce_channel = "Talon"
	on_store_name = "ITV Talon Robotic Storage"

/obj/effect/landmark/map_data/talon
    height = 2

///////////////////////////
//// The Talon
/obj/effect/overmap/visitable/ship/talon
	scanner_name = "ITV Talon"
	scanner_desc = @{"[i]Registration[/i]: ITV Talon
[i]Class[/i]: Frigate
[i]Transponder[/i]: Transmitting (CIV)
[b]Notice[/b]: Independent trader vessel"}
	color = "#aacccc"
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list("talon_fore", "talon_aft", "talon_port", "talon_starboard")
	initial_restricted_waypoints = list("Talon's boat" = list("offmap_spawn_talonboat"), "Talon lifeboat" = list("offmap_spawn_talon_lifeboat"))

	skybox_icon = 'talon.dmi' //Art by Gwyvern, distributed under Creative Commons license
	skybox_icon_state = "skybox"
	skybox_pixel_x = 270
	skybox_pixel_y = 60

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
/obj/machinery/telecomms/allinone/talon
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
((OOC: You can also pray/ahelp.))
"}

//Prevents remote control of drones
/obj/machinery/drone_fabricator/talon
	name = "somewhat glitchy drone fabricator"
	desc = "Obtained from a derelict, it seems to work sometimes, not work sometimes, and work TOO good sometimes. Didn't come with a control console either..."
	drone_type = /mob/living/silicon/robot/drone/talon

/mob/living/silicon/robot/drone/talon
	foreign_droid = TRUE
	idcard_type = /obj/item/weapon/card/id/synthetic/talon

/obj/item/weapon/card/id/synthetic/talon
	name = "\improper Talon synthetic ID"
	desc = "Access module for Talon synthetics"
	icon_state = "id-robot"
	item_state = "tdgreen"
	assignment = "Talon synthetic"

/obj/item/weapon/card/id/synthetic/talon/Initialize()
	. = ..()
	access = list(access_talon, access_synth)

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

/obj/machinery/door/firedoor/glass/talon/hidden
	name = "\improper Emergency Shutter System"
	desc = "Emergency air-tight shutter, capable of sealing off breached areas. This model fits flush with the walls, and has a panel in the floor for maintenance."
	icon = 'icons/obj/doors/DoorHazardHidden.dmi'

/obj/machinery/camera/network/talon
	network = list(NETWORK_TALON_SHIP)

/obj/machinery/photocopier/faxmachine/talon
	department = "ITV Talon"
	desc = "The ship's fax machine! It's a safe assumption that most of the departments listed aren't on your ship, since the ship only has one."

/obj/item/clothing/head/helmet/space/void/captain/talon
	name = "talon captain's voidsuit helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)
/obj/item/clothing/suit/space/void/captain/talon
	name = "talon captain's voidsuit"

/obj/item/clothing/head/helmet/space/void/security/talon
	name = "talon guard's voidsuit helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)
/obj/item/clothing/suit/space/void/security/talon
	name = "talon guard's voidsuit"

/obj/item/clothing/head/helmet/space/void/medical/talon
	name = "talon doctor's voidsuit helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)
/obj/item/clothing/suit/space/void/medical/talon
	name = "talon doctor's voidsuit"

/obj/item/clothing/head/helmet/space/void/atmos/talon
	name = "talon engineer's voidsuit helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)
/obj/item/clothing/suit/space/void/atmos/talon
	name = "talon engineer's voidsuit"

/obj/item/clothing/head/helmet/space/void/pilot/talon
	name = "talon pilot's voidsuit helmet"
	camera_networks = list(NETWORK_TALON_HELMETS)
/obj/item/clothing/suit/space/void/pilot/talon
	name = "talon pilot's voidsuit"

/obj/item/device/gps/command/taloncap
	gps_tag = "TALC"
/obj/item/device/gps/security/talonguard
	gps_tag = "TALG"
/obj/item/device/gps/medical/talonmed
	gps_tag = "TALM"
/obj/item/device/gps/engineering/taloneng
	gps_tag = "TALE"
/obj/item/device/gps/explorer/talonpilot
	gps_tag = "TALP"

/obj/structure/closet/secure_closet/talon_captain
	name = "talon captain's locker"
	req_access = list(access_talon)
	closet_appearance = /decl/closet_appearance/secure_closet/talon/captain

	starts_with = list(
		/obj/item/weapon/storage/backpack/dufflebag/captain,
		/obj/item/clothing/suit/storage/vest,
		/obj/item/weapon/melee/telebaton,
		/obj/item/device/flash,
		/obj/item/device/radio/headset/talon,
		/obj/item/clothing/head/helmet/space/void/refurb/officer/talon,
		/obj/item/clothing/suit/space/void/refurb/officer/talon,
		/obj/item/weapon/tank/oxygen,
		/obj/item/device/suit_cooling_unit,
		/obj/item/device/gps/command/taloncap
	)

/obj/structure/closet/secure_closet/talon_guard
	name = "talon guard's locker"
	req_access = list(access_talon)
	closet_appearance = /decl/closet_appearance/secure_closet/talon/guard

	starts_with = list(
		/obj/item/clothing/suit/armor/pcarrier/light,
		/obj/item/clothing/under/utility,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/shoes/boots/jackboots/toeless,
		/obj/item/weapon/handcuffs = 2,
		/obj/item/weapon/gun/energy/stunrevolver,
		/obj/item/clothing/accessory/armor/tag/sec,
		/obj/item/device/flash,
		/obj/item/device/flashlight/maglight,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/weapon/storage/belt/security,
		/obj/item/device/radio/headset/talon,
		/obj/item/clothing/accessory/solgov/department/security/army,
		/obj/item/clothing/head/helmet/space/void/refurb/marine/talon,
		/obj/item/clothing/suit/space/void/refurb/marine/talon,
		/obj/item/weapon/tank/oxygen,
		/obj/item/device/suit_cooling_unit,
		/obj/item/device/gps/security/talonguard,
		/obj/item/weapon/melee/baton
	)

/obj/structure/closet/secure_closet/talon_doctor
	name = "talon doctor's locker"
	req_access = list(access_talon)
	closet_appearance = /decl/closet_appearance/secure_closet/talon/doctor

	starts_with = list(
		/obj/item/clothing/under/rank/medical,
		/obj/item/clothing/under/rank/nurse,
		/obj/item/clothing/under/rank/orderly,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/fr_jacket,
		/obj/item/clothing/shoes/white,
		/obj/item/device/radio/headset/talon,
		/obj/item/clothing/head/helmet/space/void/refurb/medical/alt/talon,
		/obj/item/clothing/suit/space/void/refurb/medical/talon,
		/obj/item/weapon/tank/oxygen,
		/obj/item/device/suit_cooling_unit,
		/obj/item/device/gps/medical/talonmed
	)

/obj/structure/closet/secure_closet/talon_engineer
	name = "talon engineer's locker"
	req_access = list(access_talon)
	closet_appearance = /decl/closet_appearance/secure_closet/talon/engineer

	starts_with = list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/device/flashlight,
		/obj/item/weapon/extinguisher,
		/obj/item/clamp,
		/obj/item/device/radio/headset/talon,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/mask/gas,
		/obj/item/taperoll/atmos,
		/obj/item/weapon/tank/emergency/oxygen/engi,
		/obj/item/clothing/head/helmet/space/void/refurb/engineering/talon,
		/obj/item/clothing/suit/space/void/refurb/engineering/talon,
		/obj/item/weapon/tank/oxygen,
		/obj/item/device/suit_cooling_unit,
		/obj/item/device/gps/engineering/taloneng
	)

/obj/structure/closet/secure_closet/talon_pilot
	name = "talon pilot's locker"
	req_access = list(access_talon)
	closet_appearance = /decl/closet_appearance/secure_closet/talon/pilot

	starts_with = list(
		/obj/item/weapon/material/knife/tacknife/survival,
		/obj/item/clothing/head/ompilot,
		/obj/item/clothing/under/rank/pilot1,
		/obj/item/clothing/suit/storage/toggle/bomber/pilot,
		/obj/item/clothing/gloves/fingerless,
		/obj/item/weapon/reagent_containers/food/snacks/liquidfood,
		/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle,
		/obj/item/device/radio,
		/obj/item/clothing/under/utility/blue,
		/obj/item/clothing/accessory/solgov/specialty/pilot,
		/obj/item/clothing/shoes/boots/jackboots,
		/obj/item/clothing/shoes/boots/jackboots/toeless,
		/obj/item/device/radio/headset/talon,
		/obj/item/device/flashlight/color/orange,
		/obj/item/clothing/head/helmet/space/void/refurb/pilot/talon,
		/obj/item/clothing/suit/space/void/refurb/pilot/talon,
		/obj/item/weapon/tank/oxygen,
		/obj/item/device/suit_cooling_unit,
		/obj/item/device/gps/explorer/talonpilot
	)

/obj/machinery/vending/medical_talon //Not a subtype for *reasons*
	name = "NanoMed Plus"
	desc = "Medical drug dispenser."
	icon_state = "med"
	product_ads = "Go save some lives!;The best stuff for your medbay.;Only the finest tools.;Natural chemicals!;This stuff saves lives.;Don't you want some?;Ping!"
	req_access = list(access_talon)
	products = list(/obj/item/weapon/reagent_containers/glass/bottle/antitoxin = 4,/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline = 4,
					/obj/item/weapon/reagent_containers/glass/bottle/stoxin = 4,/obj/item/weapon/reagent_containers/glass/bottle/toxin = 4,
					/obj/item/weapon/reagent_containers/syringe/antiviral = 4,/obj/item/weapon/reagent_containers/syringe = 12,
					/obj/item/device/healthanalyzer = 5,/obj/item/weapon/reagent_containers/glass/beaker = 4, /obj/item/weapon/reagent_containers/dropper = 2,
					/obj/item/stack/medical/advanced/bruise_pack = 6, /obj/item/stack/medical/advanced/ointment = 6, /obj/item/stack/medical/splint = 4,
					/obj/item/weapon/storage/pill_bottle/carbon = 2, /obj/item/weapon/storage/box/khcrystal = 4, /obj/item/clothing/glasses/omnihud/med = 4,
					/obj/item/device/glasses_kit = 1,  /obj/item/weapon/storage/quickdraw/syringe_case = 4)
	contraband = list(/obj/item/weapon/reagent_containers/pill/tox = 3,/obj/item/weapon/reagent_containers/pill/stox = 4,/obj/item/weapon/reagent_containers/pill/antitox = 6)
	idle_power_usage = 211 //refrigerator - believe it or not, this is actually the average power consumption of a refrigerated vending machine according to NRCan.
	req_log_access = access_talon
	has_logs = 1

///////////////////////////
//// Computers
// Talon helmet cameras
/datum/computer_file/program/camera_monitor/talon_helmet
	filename = "talhcammon"
	filedesc = "Helmet Camera Monitoring (Talon)"
	extended_desc = "This program allows remote access to Talon helmet camera systems."
	size = 4 //Smaller because limited scope
	tguimodule_path = /datum/tgui_module/camera/ntos/talon_helmet
	required_access = access_talon

// Talon ship cameras
/datum/computer_file/program/camera_monitor/talon_ship
	filename = "talscammon"
	filedesc = "Ship Camera Monitoring (Talon)"
	extended_desc = "This program allows remote access to the Talon's camera system."
	size = 10 //Smaller because limited scope
	tguimodule_path = /datum/tgui_module/camera/ntos/talon_ship
	required_access = access_talon

/datum/tgui_module/camera/ntos/talon_ship
	name = "Talon Ship Camera Monitor"
/datum/tgui_module/camera/ntos/talon_ship/New(host)
	. = ..(host, list(NETWORK_TALON_SHIP, NETWORK_THUNDER))

/datum/tgui_module/camera/ntos/talon_helmet
	name = "Talon Helmet Camera Monitor"
/datum/tgui_module/camera/ntos/talon_helmet/New(host)
	. = ..(host, list(NETWORK_TALON_HELMETS))

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
	hard_drive.store_file(new/datum/computer_file/program/ship_nav())

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
