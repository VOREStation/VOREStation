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
	height = 1

///////////////////////////
//// The Talon
/obj/effect/overmap/visitable/ship/talon
	name = "ITV Talon"
	icon_state = "talon_v2"
	scanner_desc = @{"[i]Registration[/i]: ITV Talon
[i]Class[/i]: Frigate
[i]Transponder[/i]: Transmitting (CIV)
[b]Notice[/b]: Independent trader vessel"}
	vessel_mass = 10000
	vessel_size = SHIP_SIZE_LARGE
	initial_generic_waypoints = list("talon_v2_near_fore_port", "talon_v2_near_fore_star", "talon_v2_near_aft_port", "talon_v2_near_aft_star", "talon_v2_wing_port", "talon_v2_wing_star")
	initial_restricted_waypoints = list("Talon's Shuttle" = list("offmap_spawn_talonboat"))

	skybox_icon = 'talon.dmi'
	skybox_icon_state = "skybox"
	skybox_pixel_x = 270
	skybox_pixel_y = 60

	levels_for_distress = list(1, Z_LEVEL_BEACH, Z_LEVEL_AEROSTAT, Z_LEVEL_DEBRISFIELD, Z_LEVEL_FUELDEPOT)

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/talonboat
	name = "shuttle control console"
	shuttle_tag = "Talon's Shuttle"
	req_one_access = list(access_talon)

/obj/effect/overmap/visitable/ship/landable/talon_boat
	name = "ITV Talon Shuttle"
	desc = "A small shuttle from the ITV Talon."
	vessel_mass = 1000
	vessel_size = SHIP_SIZE_TINY
	shuttle = "Talon's Shuttle"

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/talonboat
	name = "Talon's shuttle bay"
	base_area = /area/talon_v2/hangar
	base_turf = /turf/simulated/floor/reinforced
	landmark_tag = "offmap_spawn_talonboat"
	docking_controller = "talon_boatbay"
	shuttle_type = /datum/shuttle/autodock/overmap/talonboat

// The talon's boat
/datum/shuttle/autodock/overmap/talonboat
	name = "Talon's Shuttle"
	current_location = "offmap_spawn_talonboat"
	docking_controller_tag = "talonboat_docker"
	shuttle_area = /area/shuttle/talonboat
	fuel_consumption = 2
	defer_initialisation = TRUE

/area/shuttle/talonboat
	name = "Talon's Shuttle"
	requires_power = 1
	icon = 'icons/turf/areas_vr_talon.dmi'
	icon_state = "green"

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
radius of 60 is the bare minimum or else the bridge will be unshielded,<br>\
adjust input cap so it doesn't fuck the rest of the ship<br>\
good luck<br>\
<br>\
<i>Harry Townes</i>"}

/obj/item/weapon/paper/talon_power
	name = "new power setup"
	info = {"to whoever's saddled with running this rustbucket this week,<br>\
good news! you may have noticed the entire ship was replaced pretty much overnight.<br>\
that or it changed shape or something? whatever, not important.<br>\
what <b>is</b> important is that it no longer runs off solar arrays. now we have a pair of radioisotope thermoelectric generators (or 'RTGs' as the kids call them) and a PTTO (or 'potato'... don't ask) mini reactor.<br>\
they're all in the shielded compartment just across from the big white SMES bricks.<br>\
the radioisotope buggers are basically reserves; they'll run themselves pretty much forever and provide just enough juice to run cryosupport plus allow you to kickstart power for the ship in an emergency, whilst the PTTO eats sheet uranium and puts out the big watts that keeps all the major stuff running.<br>\
you shouldn't need to push power generation past 100kW unless it's an emergency or you've been drifting dark for a while, so let it run slow and save the fuel. initial draw will be a little high but once all the APCs are charged up it should settle down to about two-thirds 'peak'. <b>do not</b> push the PTTO past 200kW, or it'll start to overheat. too much heat and it'll explode. I don't need to tell you why that's bad.<br>\
congrats, power is good to go! just keep in mind that the PTTO puts out hard rads whilst it's in use, so don't stand in the chamber too long whilst it's running. legal assures me it's fine but as far as I'm concerned any level of ionizing radiation is bad, y'know?<br>\
<br>\
also! remember to actually go anywhere you'll also need to flip the output of each engine room's pumps up.<br>\
if you somehow, <i>somehow</i>, start to run low on fuel, there are two reserve tanks in port engineering behind the atmos rig and twelve(!) empty tanks in the tail spars.<br>\
the two reserve tanks are mostly for the shuttle, but if you're low then pray you can make it to the fuel depot on what gas you have left and fill up the tanks there.<br>\
alternately maybe you can trade some off those nanotrasen corpos down on 3B. atmosphere's full of the stuff, I'm sure they won't miss a little.<br>\
<br>\
<i>Harry Townes</i><br>\
<br>\
p.s. speaking of shit that's bad for your health for the love of <i>fuck</i> do not smoke in the main engineering compartments, and <b>definitely</b> don't smoke in the engine rooms! if the ass-end of the ship ends up blown off because you went for a smoke break in a room full of crazy-flammable phoron they'll stick your reconstituted atoms so far in debt-prison you won't see daylight for a century."}

/obj/item/weapon/paper/talon_doctor
	name = "new medical bay"
	info = {"to whoever's stuck babysitting everyone's booboos,<br>\
good news! you may have noticed the entire ship was replaced pretty much overnight.<br>\
that or it changed shape or something? whatever, not important.<br>\
anyway, head through the starboard-aft door in your quarters and go through the bathrooms (congrats you have priority bathroom access)<br>\
to get to your medical bay. layout hasn't changed very much, somehow. it's easy to get to from the shuttle though, so that's nice?<br>\
whatever. enjoy the change of scenery. or don't.<br>\
<br>\
<i>Harry Townes</i>"}

/obj/item/weapon/paper/talon_guard
	name = "new brig"
	info = {"to whoever's stuck enforcing some semblance of order on this hulk,<br>\
good news! you may have noticed the entire ship was replaced pretty much overnight.<br>\
that or it changed shape or something? whatever, not important.<br>\
what matters is that the brig is now located through the port-aft door in your quarters.<br>\
there's only two cells with no meeting space in the middle or whatever the heck that was, but no huge loss right?<br>\
as for actual security matters, be aware there might be a few loose wall panels around the ship.<br>\
nothing that would let anyone get anywhere particularly sensitive, or escape the cells, but enough to sneak around a bit maybe<br>\
so stay sharp eh?<br>\
<br>\
<i>Harry Townes</i>"}

/obj/item/weapon/paper/talon_captain
	name = "storage space"
	info = {"to whoever's stuck at the helm of this farce of an operation,<br>\
good news! you may have noticed the entire ship was replaced pretty much overnight.<br>\
that or it changed shape or something? whatever, not important.<br>\
it is essential that I tell you that there is most definitely not a new smuggling compartment hidden under the carpet at the foot of your bed<br>\
unfortunately I couldn't possibly tell you the fictional combination for a hypothetical compartment that doesn't exist<br>\
have fun!<br>\
<br>\
<i>Harry Townes</i>"}

/obj/item/weapon/paper/talon_pilot
	name = "new shuttle"
	info = {"to whoever's stuck flying this ungreased beast,<br>\
good news! you may have noticed the entire ship was replaced pretty much overnight.<br>\
that or it changed shape or something? whatever, not important.<br>\
<br>\
what is important is that the shuttle has been replaced. it is now capable of fully independent flight away from the ship!<br>\
but the rear airlock is a bit fussy. be sure to use the manual switches on each side of the airlock if you're matching another airlock and one side is exposed to vacuum or a hostile atmosphere!<br>\
also be sure that it's locked down before you take off, the automatic switch is a bit stupid sometimes!<br>\
<br>\
finally, make sure you check the shuttle's APC power level before you head out! it used to be fussy, so we had a pro come in to double-check our setup and he yanked some weird gubbin I'd never seen before out of a wall panel, nodded to himself, and then walked off without saying anything else. weird but now it seems to behave.<br>\
I recommend packing a spare battery (there should be a few in engineering you can borrow and charge up) to be safe. don't wanna get stranded!<br>\
<br>\
speaking of, if some dumbass does take it and fly off solo then get themselves killed, you can use the remote console in the little spot north of the hangar to initiate basic remote maneuvers. it can't do long-range flight, but the shuttle has some basic autopilot routines for stable orbit and docking that you can ping. this won't help if the shuttle's grounded <b>and</b> out of battery, but better than nothing, right?<br>\
<br>\
<i>Harry Townes</i>"}

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
		/obj/item/clothing/suit/storage/toggle/labcoat/modern,
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
		/obj/item/clothing/head/pilot,
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

/obj/effect/shuttle_landmark/premade/talon_v2_near_fore_port
	name = "Near ITV Talon (Fore-Port)"
	landmark_tag = "talon_v2_near_fore_port"

/obj/effect/shuttle_landmark/premade/talon_v2_near_fore_star
	name = "Near ITV Talon (Fore-Starboard)"
	landmark_tag = "talon_v2_near_fore_star"

/obj/effect/shuttle_landmark/premade/talon_v2_near_aft_port
	name = "Near ITV Talon (Aft-Port)"
	landmark_tag = "talon_v2_near_aft_port"

/obj/effect/shuttle_landmark/premade/talon_v2_near_aft_star
	name = "Near ITV Talon (Aft-Starboard)"
	landmark_tag = "talon_v2_near_aft_star"

/obj/effect/shuttle_landmark/premade/talon_v2_wing_port
	name = "ITV Talon (Port Wingtip)"
	landmark_tag = "talon_v2_wing_port"

/obj/effect/shuttle_landmark/premade/talon_v2_wing_star
	name = "ITV Talon (Starboard Wingtip)"
	landmark_tag = "talon_v2_wing_star"
	
/obj/random/multiple/corp_crate/talon_cargo
	name = "random corporate crate (talon)"
	desc = "A random corporate crate with thematic contents. No weapons, no SAARE cashbox, 50% chance to not appear."
	icon = 'icons/obj/storage.dmi'
	spawn_nothing_percentage = 50
	icon_state = "crate"

/obj/random/multiple/ore_pile/talon
	name = "random ore pile (talon)"
	desc = "A pile of random ores. High chance of a larger pile of common ores, lower chances of small piles of rarer ores. No verdantium, reduced item counts vs normal ore craes."
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore_clown"

/obj/random/multiple/ore_pile/talon/item_to_spawn()
	return pick(
			prob(10);list(
				/obj/item/weapon/ore/coal,
				/obj/item/weapon/ore/coal,
				/obj/item/weapon/ore/coal,
				/obj/item/weapon/ore/coal,
				/obj/item/weapon/ore/coal,
				/obj/item/weapon/ore/coal,
				/obj/item/weapon/ore/coal,
				/obj/item/weapon/ore/coal,
				/obj/item/weapon/ore/coal,
				/obj/item/weapon/ore/coal
			),
			prob(3);list(
				/obj/item/weapon/ore/diamond,
				/obj/item/weapon/ore/diamond
			),
			prob(15);list(
				/obj/item/weapon/ore/glass,
				/obj/item/weapon/ore/glass,
				/obj/item/weapon/ore/glass,
				/obj/item/weapon/ore/glass,
				/obj/item/weapon/ore/glass,
				/obj/item/weapon/ore/glass,
				/obj/item/weapon/ore/glass,
				/obj/item/weapon/ore/glass,
				/obj/item/weapon/ore/glass,
				/obj/item/weapon/ore/glass,
				/obj/item/weapon/ore/glass,
				/obj/item/weapon/ore/glass,
				/obj/item/weapon/ore/glass,
				/obj/item/weapon/ore/glass,
				/obj/item/weapon/ore/glass
			),
			prob(5);list(
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold,
				/obj/item/weapon/ore/gold
			),
			prob(2);list(
				/obj/item/weapon/ore/hydrogen
			),
			prob(10);list(
				/obj/item/weapon/ore/iron,
				/obj/item/weapon/ore/iron,
				/obj/item/weapon/ore/iron,
				/obj/item/weapon/ore/iron,
				/obj/item/weapon/ore/iron,
				/obj/item/weapon/ore/iron,
				/obj/item/weapon/ore/iron,
				/obj/item/weapon/ore/iron,
				/obj/item/weapon/ore/iron,
				/obj/item/weapon/ore/iron
			),
			prob(10);list(
				/obj/item/weapon/ore/lead,
				/obj/item/weapon/ore/lead,
				/obj/item/weapon/ore/lead,
				/obj/item/weapon/ore/lead,
				/obj/item/weapon/ore/lead,
				/obj/item/weapon/ore/lead,
				/obj/item/weapon/ore/lead,
				/obj/item/weapon/ore/lead,
				/obj/item/weapon/ore/lead,
				/obj/item/weapon/ore/lead
			),
			prob(5);list(
				/obj/item/weapon/ore/marble,
				/obj/item/weapon/ore/marble,
				/obj/item/weapon/ore/marble,
				/obj/item/weapon/ore/marble
			),
			prob(3);list(
				/obj/item/weapon/ore/osmium,
				/obj/item/weapon/ore/osmium
			),
			prob(5);list(
				/obj/item/weapon/ore/phoron,
				/obj/item/weapon/ore/phoron,
				/obj/item/weapon/ore/phoron,
				/obj/item/weapon/ore/phoron
			),
			prob(5);list(
				/obj/item/weapon/ore/silver,
				/obj/item/weapon/ore/silver,
				/obj/item/weapon/ore/silver,
				/obj/item/weapon/ore/silver
			),
			prob(3);list(
				/obj/item/weapon/ore/uranium,
				/obj/item/weapon/ore/uranium
			),
		)

/obj/random/multiple/corp_crate/talon_cargo/item_to_spawn()
	return pick(
			prob(10);list(
				/obj/random/tank,
				/obj/random/tank,
				/obj/random/tank,
				/obj/item/clothing/mask/breath,
				/obj/item/clothing/mask/breath,
				/obj/item/clothing/mask/breath,
				/obj/structure/closet/crate/aether //AETHER AIRSUPPLY
			),
			prob(5);list(
				/obj/random/multiple/voidsuit/vintage,
				/obj/random/multiple/voidsuit/vintage,
				/obj/random/tank,
				/obj/random/tank,
				/obj/item/clothing/mask/breath,
				/obj/item/clothing/mask/breath,
				/obj/structure/closet/crate/aether //AETHER OLDSUITS
			),
			prob(10);list(
				/obj/random/mre,
				/obj/random/mre,
				/obj/random/mre,
				/obj/random/mre,
				/obj/random/mre,
				/obj/structure/closet/crate/centauri //CENTAURI MRES
			),
			prob(10);list(
				/obj/random/drinksoft,
				/obj/random/drinksoft,
				/obj/random/drinksoft,
				/obj/random/drinksoft,
				/obj/random/drinksoft,
				/obj/structure/closet/crate/freezer/centauri //CENTAURI SODA
			),
			prob(10);list(
				/obj/random/snack,
				/obj/random/snack,
				/obj/random/snack,
				/obj/random/snack,
				/obj/random/snack,
				/obj/structure/closet/crate/freezer/centauri //CENTAURI SNACKS
			),
			prob(10);list(
				/obj/random/powercell,
				/obj/random/powercell,
				/obj/random/powercell,
				/obj/random/powercell,
				/obj/structure/closet/crate/einstein //EINSTEIN BATTERYPACK
			),
			prob(5);list(
				/obj/item/weapon/circuitboard/smes,
				/obj/random/smes_coil,
				/obj/random/smes_coil,
				/obj/structure/closet/crate/focalpoint //FOCAL SMES
			),
			prob(10);list(
				/obj/item/weapon/module/power_control,
				/obj/item/stack/cable_coil,
				/obj/item/frame/apc,
				/obj/item/weapon/cell/apc,
				/obj/structure/closet/crate/focalpoint //FOCAL APC
			),
			prob(5);list(
				/obj/random/drinkbottle,
				/obj/random/drinkbottle,
				/obj/random/drinkbottle,
				/obj/random/cigarettes,
				/obj/random/cigarettes,
				/obj/random/cigarettes,
				/obj/structure/closet/crate/gilthari //GILTHARI LUXURY
			),
			prob(10);list(
				/obj/random/tech_supply/nofail,
				/obj/random/tech_supply/component/nofail,
				/obj/random/tech_supply/component/nofail,
				/obj/random/tech_supply/component/nofail,
				/obj/random/tech_supply/component/nofail,
				/obj/structure/closet/crate/grayson //GRAYSON TECH
			),
			prob(15);list(
				/obj/random/multiple/ore_pile/talon,
				/obj/random/multiple/ore_pile/talon,
				/obj/random/multiple/ore_pile/talon,
				/obj/structure/closet/crate/grayson //GRAYSON ORES (TALON-ADJUSTED)
			),
			prob(10);list(
				/obj/random/material,
				/obj/random/material,
				/obj/random/material,
				/obj/structure/closet/crate/grayson //GRAYSON MATS (TALON-ADJUSTED)
			),
			prob(5);list(
				/obj/random/multiple/voidsuit/security,
				/obj/random/tank,
				/obj/item/clothing/mask/breath,
				/obj/structure/closet/crate/secure/heph //HEPH SUIT (so people don't get huffy at talon trying to sell "NT property" to NT...)
			),
			prob(5);list(
				/obj/random/multiple/voidsuit/medical,
				/obj/random/tank,
				/obj/item/clothing/mask/breath,
				/obj/structure/closet/crate/secure/veymed //VM SUIT
			),
			prob(5);list(
				/obj/random/multiple/voidsuit/mining,
				/obj/random/tank,
				/obj/item/clothing/mask/breath,
				/obj/structure/closet/crate/grayson //GRAYSON SUIT
			),
			prob(5);list(
				/obj/random/multiple/voidsuit/engineering,
				/obj/random/tank,
				/obj/item/clothing/mask/breath,
				/obj/structure/closet/crate/xion //XION SUIT
			),
			prob(10);list(
				/obj/random/firstaid,
				/obj/random/medical,
				/obj/random/medical,
				/obj/random/medical,
				/obj/random/medical/lite,
				/obj/random/medical/lite,
				/obj/structure/closet/crate/veymed //VM GRABBAG
			),
			prob(10);list(
				/obj/random/firstaid,
				/obj/random/firstaid,
				/obj/random/firstaid,
				/obj/random/firstaid,
				/obj/random/unidentified_medicine/fresh_medicine,
				/obj/random/unidentified_medicine/fresh_medicine,
				/obj/structure/closet/crate/veymed //VM FAKS
			),
			prob(10);list(
				/obj/random/tech_supply/nofail,
				/obj/random/tech_supply/nofail,
				/obj/random/tech_supply/nofail,
				/obj/random/tech_supply/nofail,
				/obj/random/tech_supply/nofail,
				/obj/structure/closet/crate/xion //XION SUPPLY
			),
			prob(10);list(
				/obj/random/firstaid,
				/obj/random/medical,
				/obj/random/medical/pillbottle,
				/obj/random/medical/pillbottle,
				/obj/random/medical/lite,
				/obj/random/medical/lite,
				/obj/structure/closet/crate/zenghu //ZENGHU GRABBAG
			),
			prob(10);list(
				/obj/random/medical/pillbottle,
				/obj/random/medical/pillbottle,
				/obj/random/medical/pillbottle,
				/obj/random/medical/pillbottle,
				/obj/random/unidentified_medicine/fresh_medicine,
				/obj/random/unidentified_medicine/fresh_medicine,
				/obj/structure/closet/crate/zenghu //ZENGHU PILLS
			),
			prob(10);list(
				/obj/item/device/toner,
				/obj/item/device/toner,
				/obj/item/device/toner,
				/obj/item/weapon/clipboard,
				/obj/item/weapon/clipboard,
				/obj/item/weapon/pen/red,
				/obj/item/weapon/pen/blue,
				/obj/item/weapon/pen/blue,
				/obj/item/device/camera_film,
				/obj/item/weapon/folder/blue,
				/obj/item/weapon/folder/red,
				/obj/item/weapon/folder/yellow,
				/obj/item/weapon/hand_labeler,
				/obj/item/weapon/tape_roll,
				/obj/item/weapon/paper_bin,
				/obj/item/sticky_pad/random,
				/obj/structure/closet/crate/ummarcar //UMMARCAR OFFICE TRASH
			),
			prob(5);list(
				/obj/item/weapon/reagent_containers/food/snacks/unajerky,
				/obj/item/weapon/reagent_containers/food/snacks/unajerky,
				/obj/item/weapon/reagent_containers/food/snacks/unajerky,
				/obj/item/weapon/reagent_containers/food/snacks/unajerky,
				/obj/item/weapon/reagent_containers/food/snacks/unajerky,
				/obj/item/weapon/reagent_containers/food/snacks/unajerky,
				/obj/item/weapon/reagent_containers/food/snacks/unajerky,
				/obj/item/weapon/reagent_containers/food/snacks/unajerky,
				/obj/structure/closet/crate/unathi //UNAJERKY
			),
			prob(10);list(
				/obj/item/weapon/reagent_containers/glass/bucket,
				/obj/item/weapon/mop,
				/obj/item/clothing/under/rank/janitor,
				/obj/item/weapon/cartridge/janitor,
				/obj/item/clothing/gloves/black,
				/obj/item/clothing/head/soft/purple,
				/obj/item/weapon/storage/belt/janitor,
				/obj/item/clothing/shoes/galoshes,
				/obj/item/weapon/storage/bag/trash,
				/obj/item/device/lightreplacer,
				/obj/item/weapon/reagent_containers/spray/cleaner,
				/obj/item/weapon/reagent_containers/glass/rag,
				/obj/item/weapon/grenade/chem_grenade/cleaner,
				/obj/item/weapon/grenade/chem_grenade/cleaner,
				/obj/item/weapon/grenade/chem_grenade/cleaner,
				/obj/structure/closet/crate/galaksi //GALAKSI JANITOR SUPPLIES
			),
			prob(5);list(
				/obj/item/weapon/reagent_containers/food/snacks/candy/gummy,
				/obj/item/weapon/reagent_containers/food/snacks/candy/gummy,
				/obj/item/weapon/reagent_containers/food/snacks/candy/gummy,
				/obj/item/weapon/reagent_containers/food/snacks/candy/gummy,
				/obj/item/weapon/reagent_containers/food/snacks/candy/gummy,
				/obj/item/weapon/reagent_containers/food/snacks/candy/gummy,
				/obj/item/weapon/reagent_containers/food/snacks/candy/gummy,
				/obj/item/weapon/reagent_containers/food/snacks/candy/gummy,
				/obj/structure/closet/crate/allico //GUMMIES
			),
			prob(2);list(
				/obj/item/weapon/tank/phoron/pressurized,
				/obj/item/weapon/tank/phoron/pressurized,
				/obj/structure/closet/crate/secure/phoron //HQ FUEL TANKS
			)
		)