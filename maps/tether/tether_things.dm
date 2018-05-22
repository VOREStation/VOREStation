/obj/structure/window/reinforced/polarized/full
	dir = SOUTHWEST
	icon_state = "fwindow"
	maxhealth = 80

//Special map objects
/obj/effect/landmark/map_data/virgo3b
    height = 7

/obj/turbolift_map_holder/tether
	name = "Tether Climber"
	depth = 7
	lift_size_x = 3
	lift_size_y = 3
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	wall_type = null // Don't make walls

	areas_to_use = list(
		/area/turbolift/t_surface/level1,
		/area/turbolift/t_surface/level2,
		/area/turbolift/t_surface/level3,
		/area/turbolift/tether/transit,
		/area/turbolift/t_station/level1,
		/area/turbolift/t_station/level2,
		/area/turbolift/t_station/level3
		)

/datum/turbolift
	music = list('sound/music/elevator.ogg')  // Woo elevator music!

/obj/machinery/atmospherics/unary/vent_pump/positive
	use_power = 1
	icon_state = "map_vent_out"
	external_pressure_bound = ONE_ATMOSPHERE * 1.1


/obj/effect/step_trigger/teleporter/to_mining/New()
	..()
	teleport_x = src.x
	teleport_y = 2
	teleport_z = Z_LEVEL_SURFACE_MINE

/obj/effect/step_trigger/teleporter/from_mining/New()
	..()
	teleport_x = src.x
	teleport_y = world.maxy - 1
	teleport_z = Z_LEVEL_SURFACE_LOW

/obj/effect/step_trigger/teleporter/to_solars/New()
	..()
	teleport_x = world.maxx - 1
	teleport_y = src.y
	teleport_z = Z_LEVEL_SOLARS

/obj/effect/step_trigger/teleporter/from_solars/New()
	..()
	teleport_x = 2
	teleport_y = src.y
	teleport_z = Z_LEVEL_SURFACE_LOW

/obj/effect/step_trigger/teleporter/wild/New()
	..()

	//If starting on east/west edges.
	if (src.x == 1)
		teleport_x = world.maxx - 1
	else if (src.x == world.maxx)
		teleport_x = 2
	else
		teleport_x = src.x
	//If starting on north/south edges.
	if (src.y == 1)
		teleport_y = world.maxy - 1
	else if (src.y == world.maxy)
		teleport_y = 2
	else
		teleport_y = src.y

/obj/effect/step_trigger/teleporter/to_underdark
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stairs"
	invisibility = 0
/obj/effect/step_trigger/teleporter/to_underdark/initialize()
	. = ..()
	teleport_x = x
	teleport_y = y
	for(var/z_num in using_map.zlevels)
		var/datum/map_z_level/Z = using_map.zlevels[z_num]
		if(Z.name == "Underdark")
			teleport_z = Z.z

/obj/effect/step_trigger/teleporter/from_underdark
	icon = 'icons/obj/stairs.dmi'
	icon_state = "stairs"
	invisibility = 0
/obj/effect/step_trigger/teleporter/from_underdark/initialize()
	. = ..()
	teleport_x = x
	teleport_y = y
	for(var/z_num in using_map.zlevels)
		var/datum/map_z_level/Z = using_map.zlevels[z_num]
		if(Z.name == "Mining Outpost")
			teleport_z = Z.z

/obj/effect/step_trigger/teleporter/planetary_fall/virgo3b/initialize()
	planet = planet_virgo3b
	. = ..()

/obj/effect/step_trigger/lost_in_space
	var/deathmessage = "You drift off into space, floating alone in the void until your life support runs out."

/obj/effect/step_trigger/lost_in_space/Trigger(var/atom/movable/A) //replacement for shuttle dump zones because there's no empty space levels to dump to
	if(ismob(A))
		to_chat(A, "<span class='danger'>[deathmessage]</span>")
	qdel(A)

/obj/effect/step_trigger/lost_in_space/bluespace
	deathmessage = "Everything goes blue as your component particles are scattered throughout the known and unknown universe."
	var/last_sound = 0

/obj/effect/step_trigger/lost_in_space/bluespace/Trigger(A)
	if(world.time - last_sound > 5 SECONDS)
		last_sound = world.time
		playsound(get_turf(src), 'sound/effects/supermatter.ogg', 75, 1)
	if(ismob(A) && prob(5))//lucky day
		var/destturf = locate(rand(5,world.maxx-5),rand(5,world.maxy-5),pick(using_map.station_levels))
		new /datum/teleport/instant(A, destturf, 0, 1, null, null, null, 'sound/effects/phasein.ogg')
	else
		return ..()


// Invisible object that blocks z transfer to/from its turf and the turf above.
/obj/effect/ceiling
	invisibility = 101 // nope cant see this
	anchored = 1

/obj/effect/ceiling/CheckExit(atom/movable/O as mob|obj, turf/target as turf)
	if(target && target.z > src.z)
		return FALSE // Block exit from our turf to above
	return TRUE

/obj/effect/ceiling/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(mover && mover.z > src.z)
		return FALSE // Block entry from above to our turf
	return TRUE

//
// TRAM STATION
//

// The tram's electrified maglev tracks
/turf/simulated/floor/maglev
	name = "maglev track"
	desc = "Magnetic levitation tram tracks. Caution! Electrified!"
	icon = 'icons/turf/flooring/maglevs.dmi'
	icon_state = "maglevup"

	var/area/shock_area = /area/tether/surfacebase/tram

/turf/simulated/floor/maglev/initialize()
	. = ..()
	shock_area = locate(shock_area)

// Walking on maglev tracks will shock you! Horray!
/turf/simulated/floor/maglev/Entered(var/atom/movable/AM, var/atom/old_loc)
	if(isliving(AM) && prob(50))
		track_zap(AM)
/turf/simulated/floor/maglev/attack_hand(var/mob/user)
	if(prob(75))
		track_zap(user)
/turf/simulated/floor/maglev/proc/track_zap(var/mob/living/user)
	if (!istype(user)) return
	if (electrocute_mob(user, shock_area, src))
		var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
		s.set_up(5, 1, src)
		s.start()

// Tram air scrubbers for keeping arrivals clean - they work even with no area power
/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/tram
	name = "\improper Tram Air Scrubber"
	icon_state = "scrubber:1"
	on = TRUE

/obj/machinery/portable_atmospherics/powered/scrubber/huge/stationary/tram/powered()
	return TRUE // Always be powered

//Chemistry 'chemavator'
/obj/machinery/smartfridge/chemistry/chemvator
	name = "\improper Smart Chemavator - Upper"
	desc = "A refrigerated storage unit for medicine and chemical storage. Now sporting a fancy system of pulleys to lift bottles up and down."
	var/obj/machinery/smartfridge/chemistry/chemvator/attached

/obj/machinery/smartfridge/chemistry/chemvator/down/Destroy()
	attached = null
	return ..()

/obj/machinery/smartfridge/chemistry/chemvator/down
	name = "\improper Smart Chemavator - Lower"

/obj/machinery/smartfridge/chemistry/chemvator/down/initialize()
	. = ..()
	var/obj/machinery/smartfridge/chemistry/chemvator/above = locate(/obj/machinery/smartfridge/chemistry/chemvator,get_zstep(src,UP))
	if(istype(above))
		above.attached = src
		attached = above
		item_records = attached.item_records
	else
		to_chat(world,"<span class='danger'>[src] at [x],[y],[z] cannot find the unit above it!</span>")

// Tram departure cryo doors that turn into ordinary airlock doors at round end
/obj/machinery/cryopod/robot/door/tram
	name = "\improper Tram Station"
	icon = 'icons/obj/doors/Doorext.dmi'
	icon_state = "door_closed"
	base_icon_state = "door_closed"
	occupied_icon_state = "door_locked"
	desc = "The tram station you might've came in from.  You could leave the base easily using this."
	on_store_message = "has departed on the tram."
	on_store_name = "Travel Oversight"
	on_enter_occupant_message = "The tram arrives at the platform; you step inside and take a seat."
	on_store_visible_message_1 = "'s speakers chime, anouncing a tram has arrived to take"
	on_store_visible_message_2 = "to the colony"
	time_till_despawn = 10 SECONDS
	spawnpoint_type = /datum/spawnpoint/tram

/obj/machinery/cryopod/robot/door/tram/process()
	if(emergency_shuttle.online() || emergency_shuttle.returned())
		// Transform into a door!  But first despawn anyone inside
		time_till_despawn = 0
		..()
		var/turf/T = get_turf(src)
		var/obj/machinery/door/airlock/external/door = new(T)
		door.req_access = null
		door.req_one_access = null
		qdel(src)
	// Otherwise just operate normally
	return ..()

/obj/machinery/cryopod/robot/door/tram/Bumped(var/atom/movable/AM)
	if(!ishuman(AM))
		return

	var/mob/living/carbon/human/user = AM

	var/choice = alert("Do you want to depart via the tram? Your character will leave the round.","Departure","Yes","No")
	if(user && Adjacent(user) && choice == "Yes")
		user.ghostize()
		despawn_occupant(user)

// Tram arrival point landmarks and datum
var/global/list/latejoin_tram   = list()

/obj/effect/landmark/tram
	name = "JoinLateTram"
	delete_me = 1

/obj/effect/landmark/tram/New()
	latejoin_tram += loc // Register this turf as tram latejoin.
	latejoin += loc // Also register this turf as fallback latejoin, since we won't have any arrivals shuttle landmarks.
	..()

/datum/spawnpoint/tram
	display_name = "Tram Station"
	msg = "has arrived on the tram"

/datum/spawnpoint/tram/New()
	..()
	turfs = latejoin_tram

//
// Holodorms
//
/obj/machinery/computer/HolodeckControl/holodorm
	name = "Don't use this one!!!"
	powerdown_program = "Off"
	default_program = "Off"

	//Smollodeck
	active_power_usage = 500
	item_power_usage = 100

	supported_programs = list(
	"Off"			= new/datum/holodeck_program(/area/holodeck/holodorm/source_off),
	"Basic Dorm"	= new/datum/holodeck_program(/area/holodeck/holodorm/source_basic),
	"Table Seating"	= new/datum/holodeck_program(/area/holodeck/holodorm/source_seating),
	"Beach Sim"		= new/datum/holodeck_program(/area/holodeck/holodorm/source_beach),
	"Desert Area"	= new/datum/holodeck_program(/area/holodeck/holodorm/source_desert),
	"Snow Field"	= new/datum/holodeck_program(/area/holodeck/holodorm/source_snow),
	"Flower Garden"	= new/datum/holodeck_program(/area/holodeck/holodorm/source_garden),
	"Space Sim"		= new/datum/holodeck_program(/area/holodeck/holodorm/source_space),
	"Boxing Ring"	= new/datum/holodeck_program(/area/holodeck/holodorm/source_boxing)
	)

/obj/machinery/computer/HolodeckControl/holodorm/one
	name = "dorm one holodeck control"
	projection_area = /area/crew_quarters/sleep/Dorm_1/holo

/obj/machinery/computer/HolodeckControl/holodorm/three
	name = "dorm three holodeck control"
	projection_area = /area/crew_quarters/sleep/Dorm_3/holo

/obj/machinery/computer/HolodeckControl/holodorm/five
	name = "dorm five holodeck control"
	projection_area = /area/crew_quarters/sleep/Dorm_5/holo

/obj/machinery/computer/HolodeckControl/holodorm/seven
	name = "dorm seven holodeck control"
	projection_area = /area/crew_quarters/sleep/Dorm_7/holo

// Small Ship Holodeck
/obj/machinery/computer/HolodeckControl/houseboat
	projection_area = /area/houseboat/holodeck_area
	powerdown_program = "Turn Off"
	default_program = "Empty Court"

	supported_programs = list(
	"Basketball" 		= new/datum/holodeck_program(/area/houseboat/holodeck/basketball, list('sound/music/THUNDERDOME.ogg')),
	"Thunderdome"		= new/datum/holodeck_program(/area/houseboat/holodeck/thunderdome, list('sound/music/THUNDERDOME.ogg')),
	"Beach" 			= new/datum/holodeck_program(/area/houseboat/holodeck/beach),
	"Desert" 			= new/datum/holodeck_program(/area/houseboat/holodeck/desert,
													list(
														'sound/effects/wind/wind_2_1.ogg',
											 			'sound/effects/wind/wind_2_2.ogg',
											 			'sound/effects/wind/wind_3_1.ogg',
											 			'sound/effects/wind/wind_4_1.ogg',
											 			'sound/effects/wind/wind_4_2.ogg',
											 			'sound/effects/wind/wind_5_1.ogg'
												 		)
		 											),
	"Snowfield" 		= new/datum/holodeck_program(/area/houseboat/holodeck/snow,
													list(
														'sound/effects/wind/wind_2_1.ogg',
											 			'sound/effects/wind/wind_2_2.ogg',
											 			'sound/effects/wind/wind_3_1.ogg',
											 			'sound/effects/wind/wind_4_1.ogg',
											 			'sound/effects/wind/wind_4_2.ogg',
											 			'sound/effects/wind/wind_5_1.ogg'
												 		)
		 											),
	"Space" 			= new/datum/holodeck_program(/area/houseboat/holodeck/space,
													list(
														'sound/ambience/ambispace.ogg',
														'sound/music/main.ogg',
														'sound/music/space.ogg',
														'sound/music/traitor.ogg',
														)
													),
	"Picnic Area" 		= new/datum/holodeck_program(/area/houseboat/holodeck/picnic, list('sound/music/title2.ogg')),
	"Gaming" 			= new/datum/holodeck_program(/area/houseboat/holodeck/gaming, list('sound/music/traitor.ogg')),
	"Bunking"			= new/datum/holodeck_program(/area/houseboat/holodeck/bunking, list()),
	"Turn Off" 			= new/datum/holodeck_program(/area/houseboat/holodeck/off, list())
	)

// Our map is small, if the supermatter is ejected lets not have it just blow up somewhere else
/obj/machinery/power/supermatter/touch_map_edge()
	qdel(src)

//Airlock antitox vendor
/obj/machinery/vending/wallmed_airlock
	name = "Airlock NanoMed"
	desc = "Wall-mounted Medical Equipment dispenser. This limited-use version dispenses antitoxins with mild painkillers for surface EVAs."
	icon_state = "wallmed"
	icon_deny = "wallmed-deny"
	density = 0 //It is wall-mounted, and thus, not dense. --Superxpdude
	products = list(/obj/item/weapon/reagent_containers/pill/airlock = 10,/obj/item/device/healthanalyzer = 1)
	contraband = list(/obj/item/weapon/reagent_containers/pill/tox = 2)
	req_log_access = access_cmo
	has_logs = 1

/obj/item/weapon/reagent_containers/pill/airlock
	name = "\'Airlock\' Pill"
	desc = "Neutralizes toxins and provides a mild analgesic effect."
	icon_state = "pill2"

/obj/item/weapon/reagent_containers/pill/airlock/New()
	..()
	reagents.add_reagent("anti_toxin", 15)
	reagents.add_reagent("paracetamol", 5)

//"Red" Armory Door
/obj/machinery/door/airlock/multi_tile/metal/red
	name = "Red Armory"
	//color = ""

/obj/machinery/door/airlock/multi_tile/metal/red/allowed(mob/user)
	if(get_security_level() in list("green","blue"))
		return FALSE

	return ..(user)

/obj/structure/closet/secure_closet/guncabinet/excursion
	name = "expedition weaponry cabinet"
	req_one_access = list(access_explorer,access_brig)

/obj/structure/closet/secure_closet/guncabinet/excursion/New()
	..()
	for(var/i = 1 to 4)
		new /obj/item/weapon/gun/energy/frontier/locked(src)
	for(var/i = 1 to 4)
		new /obj/item/weapon/gun/energy/frontier/locked/holdout(src)

// Underdark mob spawners
/obj/tether_away_spawner/underdark_normal
	name = "Underdark Normal Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_animal/hostile/jelly = 3,
		/mob/living/simple_animal/hostile/giant_spider/hunter = 1,
		/mob/living/simple_animal/hostile/giant_spider/phorogenic = 1,
		/mob/living/simple_animal/hostile/giant_spider/lurker = 1,
	)

/obj/tether_away_spawner/underdark_hard
	name = "Underdark Hard Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 50
	guard = 20
	mobs_to_pick_from = list(
		/mob/living/simple_animal/hostile/corrupthound = 1,
		/mob/living/simple_animal/hostile/rat = 1,
		/mob/living/simple_animal/hostile/mimic = 1
	)

/obj/tether_away_spawner/underdark_boss
	name = "Underdark Boss Spawner"
	faction = "underdark"
	atmos_comp = TRUE
	prob_spawn = 100
	prob_fall = 100
	guard = 70
	mobs_to_pick_from = list(
		/mob/living/simple_animal/hostile/dragon = 1
	)

// Used at centcomm for the elevator
/obj/machinery/cryopod/robot/door/dorms
	spawnpoint_type = /datum/spawnpoint/tram

//
// ### Wall Machines On Full Windows ###
// To make sure wall-mounted machines placed on full-tile windows are clickable they must be above the window
//
/obj/item/device/radio/intercom
	layer = ABOVE_WINDOW_LAYER
/obj/item/weapon/storage/secure/safe
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/airlock_sensor
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/alarm
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/button
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/access_button
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/computer/guestpass
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/computer/security/telescreen
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/door_timer
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/embedded_controller
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/firealarm
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/flasher
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/keycard_auth
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/light_switch
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/mineral/processing_unit_console
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/mineral/stacking_unit_console
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/newscaster
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/power/apc
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/requests_console
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/status_display
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/vending/wallmed1
	layer = ABOVE_WINDOW_LAYER
/obj/machinery/vending/wallmed2
	layer = ABOVE_WINDOW_LAYER
/obj/structure/closet/fireaxecabinet
	layer = ABOVE_WINDOW_LAYER
/obj/structure/extinguisher_cabinet
	layer = ABOVE_WINDOW_LAYER
/obj/structure/mirror
	layer = ABOVE_WINDOW_LAYER
/obj/structure/noticeboard
	layer = ABOVE_WINDOW_LAYER
