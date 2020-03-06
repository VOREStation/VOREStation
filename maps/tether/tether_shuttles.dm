////////////////////////////////////////
// Tether custom shuttle implemnetations
////////////////////////////////////////

/obj/machinery/computer/shuttle_control/tether_backup
	name = "tether backup shuttle control console"
	shuttle_tag = "Tether Backup"
	req_one_access = list(access_heads,access_pilot)

/obj/machinery/computer/shuttle_control/multi/tether_antag_ground
	name = "land crawler control console"
	shuttle_tag = "Land Crawler"

/obj/machinery/computer/shuttle_control/multi/tether_antag_space
	name = "protoshuttle control console"
	shuttle_tag = "Proto"

/obj/machinery/computer/shuttle_control/cruiser_shuttle
	name = "cruiser shuttle control console"
	shuttle_tag = "Cruiser Shuttle"
	req_one_access = list(access_heads)

//
// "Tram" Emergency Shuttler
// Becuase the tram only has its own doors and no corresponding station doors, a docking controller is overkill.
// Just open the gosh darn doors!  Also we avoid having a physical docking controller obj for gameplay reasons.
/datum/shuttle/autodock/ferry/emergency
	var/tag_door_station = "escape_shuttle_hatch_station"
	var/tag_door_offsite = "escape_shuttle_hatch_offsite"
	var/frequency = 1380 // Why this frequency? BECAUSE! Thats what someone decided once.
	var/datum/radio_frequency/radio_connection

/datum/shuttle/autodock/ferry/emergency/New()
	radio_connection = radio_controller.add_object(src, frequency, null)
	..()

/datum/shuttle/autodock/ferry/emergency/dock()
	..()
	// Open Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_open"
	post_signal(signal)

/datum/shuttle/autodock/ferry/emergency/undock()
	..()
	// Close Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_close"
	post_signal(signal)

/datum/shuttle/autodock/ferry/emergency/proc/post_signal(datum/signal/signal, var/filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(src, signal, filter)
	else
		qdel(signal)

//
// The backup tether shuttle uses experimental engines and can degrade and/or crash!
//
/* //Disabling the crash mechanics per request
/datum/shuttle/ferry/tether_backup
	crash_message = "Tether shuttle distress signal received. Shuttle location is approximately 200 meters from tether base."
	category = /datum/shuttle/ferry/tether_backup // So shuttle_controller.dm doesn't try and instantiate this type as an acutal mapped in shuttle.
	var/list/engines = list()
	var/obj/machinery/computer/shuttle_control/tether_backup/computer

/datum/shuttle/ferry/tether_backup/New()
	..()
	var/area/current_area = get_location_area(location)
	for(var/obj/structure/shuttle/engine/propulsion/E in current_area)
		engines += E
	for(var/obj/machinery/computer/shuttle_control/tether_backup/comp in current_area)
		computer = comp

/datum/shuttle/ferry/tether_backup/process_longjump(var/area/origin, var/area/intended_destination)
	var/failures = engines.len
	for(var/engine in engines)
		var/obj/structure/shuttle/engine/E = engine
		failures -= E.jump()

	#define MOVE_PER(x) move_time*(x/100) SECONDS

	computer.visible_message("[bicon(computer)] <span class='notice'>Beginning flight and telemetry monitoring.</span>")
	sleep(MOVE_PER(5))

	if(failures >= 1)
		computer.visible_message("[bicon(computer)] <span class='warning'>Single engine failure, continuing flight.</span>")
		sleep(MOVE_PER(10))

	if(failures >= 2)
		computer.visible_message("[bicon(computer)] <span class='warning'>Second engine failure, unable to complete flight.</span>")
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(10))
		computer.visible_message("[bicon(computer)] <span class='warning'>Commencing RTLS abort mode.</span>")
		sleep(MOVE_PER(20))
		if(failures < 3)
			move(area_transition,origin)
			moving_status = SHUTTLE_IDLE
			return 1

	if(failures >= 3)
		computer.visible_message("[bicon(computer)] <span class='danger'>Total engine failure, unable to complete abort mode.</span>")
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		computer.visible_message("[bicon(computer)] <span class='danger'>Distress signal broadcast.</span>")
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		computer.visible_message("[bicon(computer)] <span class='danger'>Stall. Stall. Stall. Stall.</span>")
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		computer.visible_message("[bicon(computer)] <span class='danger'>Terrain! Pull up! Terrain! Pull up!</span>")
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		playsound(computer,'sound/misc/bloblarm.ogg',100,0)
		sleep(MOVE_PER(10))
		do_crash(area_transition)
		return 1

	return 0

	#undef MOVE_PER
//
// The repairable engines
// TODO - These need a more advanced fixing sequence.
//
/obj/structure/shuttle/engine
	var/wear = 0

/obj/structure/shuttle/engine/proc/jump()
	. = !prob(wear)
	if(!.)
		wear = 100
	else
		wear += rand(5,20)

/obj/structure/shuttle/engine/attackby(obj/item/weapon/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if(repair_welder(user, W))
		return
	return ..()

//TODO require a multitool to diagnose and open engine panels or something

/obj/structure/shuttle/engine/proc/repair_welder(var/mob/user, var/obj/item/weapon/weldingtool/WT)
	if(!istype(WT))
		return 0
	if(wear <= 20)
		to_chat(user,"<span class='notice'>\The [src] doesn't seem to need repairs right now.</span>")
		return 1
	if(!WT.remove_fuel(0, user))
		to_chat(user,"<span class='warning'>\The [WT] must be on to complete this task.</span>")
		return 1
	playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
	user.visible_message("<span class='notice'>\The [user] begins \the [src] overhaul.</span>","<span class='notice'>You begin an overhaul of \the [src].</span>")
	if(!do_after(user, wear SECONDS, src))
		return 1
	if(!src || !WT.isOn())
		return 1
	user.visible_message("<span class='notice'>\The [user] has overhauled \the [src].</span>","<span class='notice'>You complete \the [src] overhaul.</span>")
	wear = 20
	update_icon()
	return 1
*/
////////////////////////////////////////
//////// Excursion Shuttle /////////////
////////////////////////////////////////
/obj/machinery/computer/shuttle_control/web/excursion
	name = "shuttle control console"
	shuttle_tag = "Excursion Shuttle"
	req_access = list()
	req_one_access = list(access_pilot)
	var/wait_time = 45 MINUTES

/obj/machinery/computer/shuttle_control/web/excursion/ui_interact()
	if(world.time < wait_time)
		to_chat(usr,"<span class='warning'>The console is locked while the shuttle refuels. It will be complete in [round((wait_time - world.time)/10/60)] minute\s.</span>")
		return FALSE

	. = ..()

/datum/shuttle/autodock/web_shuttle/excursion
	name = "Excursion Shuttle"
	warmup_time = 0
	current_location = "tether_excursion_hangar"
	docking_controller_tag = "expshuttle_docker"
	web_master_type = /datum/shuttle_web_master/excursion
	shuttle_area = /area/shuttle/excursion
	var/abduct_chance = 0 //Prob

/datum/shuttle/autodock/web_shuttle/excursion/long_jump(var/obj/effect/shuttle_landmark/destination, var/obj/effect/shuttle_landmark/interim, var/travel_time)
	if(prob(abduct_chance))
		abduct_chance = 0
		var/list/occupants = list()
		for(var/area/A in shuttle_area)
			for(var/mob/living/L in A)
				occupants += key_name(L)
		log_and_message_admins("Shuttle abduction occuring with (only mobs on turfs): [english_list(occupants)]")
		//Build the route to the alien ship
		var/obj/shuttle_connector/alienship/ASC = new /obj/shuttle_connector/alienship(null)
		ASC.setup_routes()

		//Redirect us onto that route instead
		var/datum/shuttle/autodock/web_shuttle/WS = shuttle_controller.shuttles[name]
		var/datum/shuttle_destination/ASD = WS.web_master.get_destination_by_type(/datum/shuttle_destination/excursion/alienship)
		WS.web_master.future_destination = ASD
		. = ..(ASD.my_landmark,interim,travel_time)
	else
		. = ..()

/datum/shuttle_web_master/excursion
	destination_class = /datum/shuttle_destination/excursion
	starting_destination = /datum/shuttle_destination/excursion/tether

/datum/shuttle_destination/excursion/tether
	name = "NSB Adephagia Excursion Hangar"
	my_landmark = "tether_excursion_hangar"

	radio_announce = 1
	announcer = "Docking System"

	routes_to_make = list(
		/datum/shuttle_destination/excursion/outside_tether = 0,
	)

/datum/shuttle_destination/excursion/tether/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at the Excursion Hangar."

/datum/shuttle_destination/excursion/tether/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed from the Excursion Hangar."


/datum/shuttle_destination/excursion/outside_tether
	name = "Nearby NSB Adephagia"
	my_landmark = "tether_excursion_nearby"
	preferred_interim_tag = "tether_excursion_transit_space"

	routes_to_make = list(
		/datum/shuttle_destination/excursion/docked_tether = 0,
		/datum/shuttle_destination/excursion/virgo3b_orbit = 30 SECONDS
	)


/datum/shuttle_destination/excursion/docked_tether
	name = "NSB Adephagia Docking Arm"
	my_landmark = "tether_excursion_dockarm"

	radio_announce = 1
	announcer = "Docking System"

/datum/shuttle_destination/excursion/docked_tether/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at Docking Arm One."

/datum/shuttle_destination/excursion/docked_tether/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed from Docking Arm One."


/datum/shuttle_destination/excursion/virgo3b_orbit
	name = "Virgo 3B Orbit"
	my_landmark = "tether_excursion_space"
	preferred_interim_tag = "tether_excursion_transit_space"

	routes_to_make = list(
		/datum/shuttle_destination/excursion/virgo3b_sky = 30 SECONDS,
		/datum/shuttle_destination/excursion/bluespace = 30 SECONDS
	)


/datum/shuttle_destination/excursion/virgo3b_sky
	name = "Skies of Virgo 3B"
	my_landmark = "tether_excursion_virgo3bsky"

////////// Aliems!!
/obj/machinery/computer/shuttle_control/web/excursion/blue
	name = "shuttle control console"
	icon = 'icons/obj/flight_computer_vr.dmi'
	icon_state = "center"
	shuttle_tag = "Hybrid Shuttle"
	req_access = list()
	req_one_access = list(access_pilot)
	wait_time = 0
	var/setup = FALSE

/obj/machinery/computer/shuttle_control/web/excursion/blue/ui_interact()
	if(!setup && alert("Steal the excursion shuttle's destinations and copy them to this shuttle?","Shuttle Setup","Yes","Cancel") == "Yes")
		var/datum/shuttle/autodock/web_shuttle/HS = shuttle_controller.shuttles[shuttle_tag]
		var/datum/shuttle/autodock/web_shuttle/ES = shuttle_controller.shuttles["Excursion Shuttle"]
		if(!ES.web_master.destinations.len)
			return
		
		// First, instantiate all the destination subtypes relevant to this datum.
		for(var/new_type in ES.web_master.destinations)
			var/datum/shuttle_destination/D = new_type
			//if(D.skip_me) //Don't care
			//	continue
			HS.web_master.destinations += new D.type(HS.web_master)

		// Now start the process of connecting all of them.
		for(var/datum/shuttle_destination/D in HS.web_master.destinations)
			for(var/type_to_link in D.routes_to_make)
				var/travel_delay = D.routes_to_make[type_to_link]
				D.link_destinations(HS.web_master.get_destination_by_type(type_to_link), D.preferred_interim_tag, travel_delay)

		HS.web_master.current_destination = HS.web_master.get_destination_by_type(/datum/shuttle_destination/excursion/deepish_space)
		setup = TRUE
		..()
	else
		return ..()

/datum/shuttle/autodock/web_shuttle/excursion/blue
	name = "Hybrid Shuttle"
	visible_name = "XN-39 Prototype"
	warmup_time = 0
	current_location = "bluefo_start"
	docking_controller_tag = "hybrid_shuttle_docker"
	web_master_type = /datum/shuttle_web_master/excursion/blue
	shuttle_area = /area/shuttle/blue_fo
	abduct_chance = 0
	flags = SHUTTLE_FLAGS_NONE

/datum/shuttle_web_master/excursion/blue
	destination_class = /datum/shuttle_destination/excursion
	starting_destination = /datum/shuttle_destination/excursion/deepish_space

/datum/shuttle_web_master/excursion/blue/build_destinations()
	return

/datum/shuttle_destination/excursion/deepish_space
	name = "Deepish Space"
	my_landmark = "bluefo_start"
	preferred_interim_tag = "tether_excursion_transit_space"
	routes_to_make = list(
		/datum/shuttle_destination/excursion/bluespace = 0
	)

/datum/shuttle_destination/excursion/deepish_space/link_destinations(var/datum/shuttle_destination/other_place, var/interim_tag, var/travel_time = 0)
	var/datum/shuttle_route/new_route = new(src, other_place, interim_tag, travel_time)
	routes += new_route

////////// Distant Destinations
/datum/shuttle_destination/excursion/bluespace
	name = "Bluespace Jump"
	my_landmark = "tether_excursion_bluespace"
	preferred_interim_tag = "tether_excursion_transit_space"

// Heist
/obj/machinery/computer/shuttle_control/web/heist
	name = "skipjack control console"
	req_access = list(access_syndicate)
	shuttle_tag = "Skipjack"

/datum/shuttle/autodock/web_shuttle/heist
	name = "Skipjack"
	current_location = "skipjack_base"
	shuttle_area = /area/shuttle/skipjack
	web_master_type = /datum/shuttle_web_master/heist
	warmup_time = 0
	can_cloak = TRUE
	cloaked = TRUE

/datum/shuttle_web_master/heist
	destination_class = /datum/shuttle_destination/heist
	starting_destination = /datum/shuttle_destination/heist/root

/datum/shuttle_destination/heist/root
	name = "Raider Outpost"
	my_landmark = "skipjack_base"
	preferred_interim_tag = "skipjack_transit"

	routes_to_make = list(
		/datum/shuttle_destination/heist/outside_tether = 1 MINUTE
	)

/datum/shuttle_destination/heist/outside_tether
	name = "NSB Adephagia - Nearby"
	my_landmark = "skipjack_outside"
	preferred_interim_tag = "skipjack_transit"

	routes_to_make = list(
		/datum/shuttle_destination/heist/root = 1 MINUTE
	)

// Ninja
/obj/machinery/computer/shuttle_control/web/ninja
	name = "stealth shuttle control console"
	req_access = list(access_syndicate)
	shuttle_tag = "Ninja"

/datum/shuttle/autodock/web_shuttle/ninja
	name = "Ninja"
	visible_name = "Unknown Vessel"
	current_location = "ninja_base"
	shuttle_area = /area/shuttle/ninja
	docking_controller_tag = "ninja_shuttle"
	web_master_type = /datum/shuttle_web_master/ninja
	warmup_time = 0
	can_cloak = TRUE
	cloaked = TRUE

/datum/shuttle_web_master/ninja
	destination_class = /datum/shuttle_destination/ninja
	starting_destination = /datum/shuttle_destination/ninja/root

/datum/shuttle_destination/ninja/root
	name = "Dojo Outpost"
	my_landmark = "ninja_base"
	preferred_interim_tag = "ninja_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ninja/outside_tether = 30 SECONDS
	)

/datum/shuttle_destination/ninja/outside_tether
	name = "NSB Adephagia - Nearby"
	my_landmark = "ninja_outside"
	preferred_interim_tag = "ninja_transit"

	routes_to_make = list(
		/datum/shuttle_destination/ninja/root = 30 SECONDS
	)

////////////////////////////////////
//////// Specops Shuttle ///////////
////////////////////////////////////

/obj/machinery/computer/shuttle_control/web/specialops
	name = "shuttle control console"
	shuttle_tag = "Special Operations Shuttle"
	req_access = list()
	req_one_access = list(access_cent_specops)

/datum/shuttle/autodock/web_shuttle/specialops
	name = "Special Operations Shuttle"
	visible_name = "NDV Phantom"
	current_location = "specops_base"
	shuttle_area = /area/shuttle/specialops
	docking_controller_tag = "specops_shuttle_hatch"
	web_master_type = /datum/shuttle_web_master/specialops
	can_rename = FALSE
	can_cloak = TRUE
	cloaked = FALSE

/datum/shuttle_web_master/specialops
	destination_class = /datum/shuttle_destination/specialops
	starting_destination = /datum/shuttle_destination/specialops/centcom

/datum/shuttle_destination/specialops/tether
	name = "NSB Adephagia Docking Arm 2"
	my_landmark = "specops_tether"
	preferred_interim_tag = "specops_transit"

	radio_announce = 1
	announcer = "A.L.I.C.E."

	routes_to_make = list(
		/datum/shuttle_destination/specialops/centcom = 15,
	)

/datum/shuttle_destination/specialops/tether/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at the Docking Arm 2."

/datum/shuttle_destination/specialops/tether/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed from the Docking Arm 2."


/datum/shuttle_destination/specialops/centcom
	name = "Central Command"
	my_landmark = "specops_base"
	preferred_interim_tag = "specops_transit"

	routes_to_make = list(
		/datum/shuttle_destination/specialops/tether = 15
	)