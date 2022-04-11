/datum/shuttle/autodock/ferry
	var/location = FERRY_LOCATION_STATION	//0 = at area_station, 1 = at area_offsite
	var/direction = FERRY_GOING_TO_STATION	//0 = going to station, 1 = going to offsite.

	var/always_process = FALSE // TODO -why should this exist?

	var/obj/effect/shuttle_landmark/landmark_station  //This variable is type-abused initially: specify the landmark_tag, not the actual landmark.
	var/obj/effect/shuttle_landmark/landmark_offsite  //This variable is type-abused initially: specify the landmark_tag, not the actual landmark.

	category = /datum/shuttle/autodock/ferry

/datum/shuttle/autodock/ferry/New(var/_name)
	if(landmark_station)
		landmark_station = SSshuttles.get_landmark(landmark_station)
	if(landmark_offsite)
		landmark_offsite = SSshuttles.get_landmark(landmark_offsite)

	..(_name, get_location_waypoint(location))

	next_location = get_location_waypoint(!location)


//Gets the shuttle landmark associated with the given location (defaults to current location)
/datum/shuttle/autodock/ferry/proc/get_location_waypoint(location_id = null)
	if (isnull(location_id))
		location_id = location

	if (location_id == FERRY_LOCATION_STATION)
		return landmark_station
	return landmark_offsite

/datum/shuttle/autodock/ferry/short_jump(var/destination)
	direction = !location // Heading away from where we currently are
	. = ..()

/datum/shuttle/autodock/ferry/long_jump(var/destination, var/obj/effect/shuttle_landmark/interim, var/travel_time)
	direction = !location // Heading away from where we currently are
	. = ..()

/datum/shuttle/autodock/ferry/perform_shuttle_move()
	..()
	if (current_location == landmark_station) location = FERRY_LOCATION_STATION
	if (current_location == landmark_offsite) location = FERRY_LOCATION_OFFSITE

// Once we have arrived where we are going, plot a course back!
/datum/shuttle/autodock/ferry/process_arrived()
	..()
	next_location = get_location_waypoint(!location)

// Ferry shuttles should generally always be able to dock.  So read the docking codes off of the target.
/datum/shuttle/autodock/ferry/update_docking_target(var/obj/effect/shuttle_landmark/location)
	..()
	if(active_docking_controller && active_docking_controller.docking_codes)
		set_docking_codes(active_docking_controller.docking_codes)
