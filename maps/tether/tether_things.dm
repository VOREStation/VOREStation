//Special map objects
/obj/effect/landmark/map_data/virgo3b
    height = 5

/obj/turbolift_map_holder/tether
	name = "Tether Climber"
	depth = 5
	lift_size_x = 3
	lift_size_y = 3
	icon = 'icons/obj/turbolift_preview_3x3.dmi'
	wall_type = null // Don't make walls

	areas_to_use = list(
		/area/turbolift/t_surface/level1,
		/area/turbolift/t_surface/level2,
		/area/turbolift/t_surface/level3,
		/area/turbolift/tether/transit,
		/area/turbolift/t_station/level1
		)

/datum/turbolift
	music = list('sound/music/elevator.ogg')  // Woo elevator music!

/obj/machinery/atmospherics/unary/vent_pump/positive
	use_power = USE_POWER_IDLE
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
	icon = 'icons/obj/structures/stairs_64x64.dmi'
	icon_state = ""
	invisibility = 0
/obj/effect/step_trigger/teleporter/to_underdark/Initialize()
	. = ..()
	teleport_x = x
	teleport_y = y
	for(var/z_num in using_map.zlevels)
		var/datum/map_z_level/Z = using_map.zlevels[z_num]
		if(Z.name == "Underdark")
			teleport_z = Z.z

/obj/effect/step_trigger/teleporter/from_underdark
	icon = 'icons/obj/structures/stairs_64x64.dmi'
	icon_state = ""
	invisibility = 0
/obj/effect/step_trigger/teleporter/from_underdark/Initialize()
	. = ..()
	teleport_x = x
	teleport_y = y
	for(var/z_num in using_map.zlevels)
		var/datum/map_z_level/Z = using_map.zlevels[z_num]
		if(Z.name == "Mining Outpost")
			teleport_z = Z.z

/obj/effect/step_trigger/teleporter/to_plains/New()
	..()
	teleport_x = src.x
	teleport_y = world.maxy - 1
	teleport_z = Z_LEVEL_PLAINS

/obj/effect/step_trigger/teleporter/from_plains/New()
	..()
	teleport_x = src.x
	teleport_y = 2
	teleport_z = Z_LEVEL_SURFACE_LOW

/obj/effect/step_trigger/teleporter/planetary_fall/virgo3b/find_planet()
	planet = planet_virgo3b

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
		playsound(src, 'sound/effects/supermatter.ogg', 75, 1)
	if(ismob(A) && prob(5))//lucky day
		var/destturf = locate(rand(5,world.maxx-5),rand(5,world.maxy-5),pick(using_map.station_levels))
		new /datum/teleport/instant(A, destturf, 0, 1, null, null, null, 'sound/effects/phasein.ogg')
	else
		return ..()

/obj/effect/step_trigger/lost_in_space/tram
	deathmessage = "You fly down the tunnel of the tram at high speed for a few moments before impact kills you with sheer concussive force."

//
// TRAM STATION
//

// The tram's electrified maglev tracks
/turf/simulated/floor/maglev
	name = "maglev track"
	desc = "Magnetic levitation tram tracks. Caution! Electrified!"
	icon = 'icons/turf/flooring/maglevs.dmi'
	icon_state = "maglevup"
	can_be_plated = FALSE

	var/area/shock_area = /area/tether/surfacebase/tram

/turf/simulated/floor/maglev/Initialize()
	. = ..()
	shock_area = locate(shock_area)

// Walking on maglev tracks will shock you! Horray!
/turf/simulated/floor/maglev/Entered(var/atom/movable/AM, var/atom/old_loc)
	if(isliving(AM) && !(AM.is_incorporeal()) && prob(50))
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

// Tram departure cryo doors that turn into ordinary airlock doors at round end
/obj/machinery/cryopod/robot/door/tram
	name = "\improper Tram Station"
	icon = 'icons/obj/doors/Doorextglass.dmi'
	icon_state = "door_closed"
	can_atmos_pass = ATMOS_PASS_NO
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
		var/obj/machinery/door/airlock/glass_external/door = new(T)
		door.req_access = null
		door.req_one_access = null
		qdel(src)
	// Otherwise just operate normally
	return ..()

/obj/machinery/cryopod/robot/door/tram/Bumped(var/atom/movable/AM)
	if(!ishuman(AM))
		return

	var/mob/living/carbon/human/user = AM

	var/choice = tgui_alert(usr, "Do you want to depart via the tram? Your character will leave the round.","Departure",list("Yes","No"))
	if(user && Adjacent(user) && choice == "Yes")
		var/mob/observer/dead/newghost = user.ghostize()
		newghost.timeofdeath = world.time
		despawn_occupant(user)
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

/obj/machinery/computer/HolodeckControl/holodorm/warship
	name = "warship holodeck control"
	projection_area = /area/mothership/holodeck/holo

// Our map is small, if the supermatter is ejected lets not have it just blow up somewhere else
/obj/machinery/power/supermatter/touch_map_edge()
	qdel(src)

//"Red" Armory Door
/obj/machinery/door/airlock/security/armory
	name = "Red Armory"
	//color = ""

/obj/machinery/door/airlock/security/armory/allowed(mob/user)
	if(get_security_level() in list("green","blue"))
		return FALSE

	return ..(user)

//Tether-unique network cameras
/obj/machinery/camera/network/tether
	network = list(NETWORK_TETHER)

/obj/machinery/camera/network/outside
	network = list(NETWORK_OUTSIDE)

// Shelter Capsule extra restrictions
/datum/map_template/shelter/New()
	..()
	banned_areas += list(/area/tether/surfacebase/fish_farm, /area/tether/surfacebase/public_garden, /area/tether/surfacebase/tram)

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
/obj/structure/fireaxecabinet
	layer = ABOVE_WINDOW_LAYER
/obj/structure/extinguisher_cabinet
	layer = ABOVE_WINDOW_LAYER
/obj/structure/mirror
	layer = ABOVE_WINDOW_LAYER
/obj/structure/noticeboard
	layer = ABOVE_WINDOW_LAYER

/obj/tether_away_spawner/tether_outside
	name = "Tether Outside Spawner"
	prob_spawn = 75
	prob_fall = 50
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/passive/gaslamp = 300,
		/mob/living/simple_mob/vore/alienanimals/teppi = 4
		)
