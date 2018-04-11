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
/datum/shuttle/ferry/emergency
	var/tag_door_station = "escape_shuttle_hatch_station"
	var/tag_door_offsite = "escape_shuttle_hatch_offsite"
	var/frequency = 1380 // Why this frequency? BECAUSE! Thats what someone decided once.
	var/datum/radio_frequency/radio_connection

/datum/shuttle/ferry/emergency/init_docking_controllers()
	docking_controller_tag = null
	dock_target_station = null
	dock_target_offsite = null
	radio_connection = radio_controller.add_object(src, frequency, null)
	..()

/datum/shuttle/ferry/emergency/dock()
	..()
	// Open Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_open"
	post_signal(signal)

/datum/shuttle/ferry/emergency/undock()
	..()
	// Close Doorsunes
	var/datum/signal/signal = new
	signal.data["tag"] = location ? tag_door_offsite : tag_door_station
	signal.data["command"] = "secure_close"
	post_signal(signal)

/datum/shuttle/ferry/emergency/proc/post_signal(datum/signal/signal, var/filter = null)
	signal.transmission_method = TRANSMISSION_RADIO
	if(radio_connection)
		return radio_connection.post_signal(src, signal, filter)
	else
		qdel(signal)

//
// The backup tether shuttle uses experimental engines and can degrade and/or crash!
//
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

	computer.visible_message("\icon[computer] <span class='notice'>Beginning flight and telemetry monitoring.</span>")
	sleep(MOVE_PER(5))

	if(failures >= 1)
		computer.visible_message("\icon[computer] <span class='warning'>Single engine failure, continuing flight.</span>")
		sleep(MOVE_PER(10))

	if(failures >= 2)
		computer.visible_message("\icon[computer] <span class='warning'>Second engine failure, unable to complete flight.</span>")
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(10))
		computer.visible_message("\icon[computer] <span class='warning'>Commencing RTLS abort mode.</span>")
		sleep(MOVE_PER(20))
		if(failures < 3)
			move(area_transition,origin)
			moving_status = SHUTTLE_IDLE
			return 1

	if(failures >= 3)
		computer.visible_message("\icon[computer] <span class='danger'>Total engine failure, unable to complete abort mode.</span>")
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		computer.visible_message("\icon[computer] <span class='danger'>Distress signal broadcast.</span>")
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		computer.visible_message("\icon[computer] <span class='danger'>Stall. Stall. Stall. Stall.</span>")
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		playsound(computer,'sound/mecha/internaldmgalarm.ogg',100,0)
		sleep(MOVE_PER(5))
		computer.visible_message("\icon[computer] <span class='danger'>Terrain! Pull up! Terrain! Pull up!</span>")
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

////////////////////////////////////////
//////// Excursion Shuttle /////////////
////////////////////////////////////////
/obj/machinery/computer/shuttle_control/web/excursion
	name = "shuttle control console"
	shuttle_tag = "Excursion Shuttle"
	req_access = list()
	req_one_access = list(access_heads,access_explorer,access_pilot)
	var/wait_time = 45 MINUTES

/obj/machinery/computer/shuttle_control/web/excursion/ui_interact()
	if(world.time < wait_time)
		to_chat(usr,"<span class='warning'>The console is locked while the shuttle refuels. It will be complete in [round((wait_time - world.time)/10/60)] minute\s.</span>")
		return FALSE

	. = ..()

/datum/shuttle/web_shuttle/excursion
	name = "Excursion Shuttle"
	warmup_time = 0
	current_area = /area/shuttle/excursion/tether
	docking_controller_tag = "expshuttle_docker"
	web_master_type = /datum/shuttle_web_master/excursion
	var/abduct_chance = 0.5 //Prob

/datum/shuttle/web_shuttle/excursion/long_jump(var/area/departing, var/area/destination, var/area/interim, var/travel_time, var/direction)
	if(prob(abduct_chance))
		abduct_chance = 0
		var/list/occupants = list()
		for(var/mob/living/L in departing)
			occupants += key_name(L)
		log_and_message_admins("Shuttle abduction occuring with (only mobs on turfs): [english_list(occupants)]")
		//Build the route to the alien ship
		var/obj/shuttle_connector/alienship/ASC = new /obj/shuttle_connector/alienship(null)
		ASC.setup_routes()

		//Redirect us onto that route instead
		var/datum/shuttle/web_shuttle/WS = shuttle_controller.shuttles[name]
		var/datum/shuttle_destination/ASD = WS.web_master.get_destination_by_type(/datum/shuttle_destination/excursion/alienship)
		WS.web_master.future_destination = ASD
		. = ..(departing,ASD.my_area,interim,travel_time,direction)
	else
		. = ..()

/datum/shuttle_web_master/excursion
	destination_class = /datum/shuttle_destination/excursion
	starting_destination = /datum/shuttle_destination/excursion/tether

/datum/shuttle_destination/excursion/tether
	name = "NSB Adephagia Excursion Hangar"
	my_area = /area/shuttle/excursion/tether

	dock_target = "expshuttle_dock"
	radio_announce = 1
	announcer = "Excursion Shuttle"

	routes_to_make = list(
		/datum/shuttle_destination/excursion/outside_tether = 0,
	)

/datum/shuttle_destination/excursion/tether/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at the Excursion Hangar."

/datum/shuttle_destination/excursion/tether/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed from the Excursion Hangar."


/datum/shuttle_destination/excursion/outside_tether
	name = "Nearby NSB Adephagia"
	my_area = /area/shuttle/excursion/tether_nearby
	preferred_interim_area = /area/shuttle/excursion/space_moving

	routes_to_make = list(
		/datum/shuttle_destination/excursion/docked_tether = 0,
		/datum/shuttle_destination/excursion/virgo3b_orbit = 30 SECONDS
	)


/datum/shuttle_destination/excursion/docked_tether
	name = "NSB Adephagia Docking Arm"
	my_area = /area/shuttle/excursion/tether_dockarm

	dock_target = "d1a2_dock"
	radio_announce = 1
	announcer = "Excursion Shuttle"

/datum/shuttle_destination/excursion/docked_tether/get_arrival_message()
	return "Attention, [master.my_shuttle.visible_name] has arrived at Docking Arm One."

/datum/shuttle_destination/excursion/docked_tether/get_departure_message()
	return "Attention, [master.my_shuttle.visible_name] has departed from Docking Arm One."


/datum/shuttle_destination/excursion/virgo3b_orbit
	name = "Virgo 3B Orbit"
	my_area = /area/shuttle/excursion/space
	preferred_interim_area = /area/shuttle/excursion/space_moving

	routes_to_make = list(
		/datum/shuttle_destination/excursion/virgo3b_sky = 30 SECONDS,
		/datum/shuttle_destination/excursion/bluespace = 30 SECONDS
	)


/datum/shuttle_destination/excursion/virgo3b_sky
	name = "Skies of Virgo 3B"
	my_area = /area/shuttle/excursion/virgo3b_sky

////////// Distant Destinations
/datum/shuttle_destination/excursion/bluespace
	name = "Bluespace Jump"
	my_area = /area/shuttle/excursion/bluespace
	preferred_interim_area = /area/shuttle/excursion/space_moving
