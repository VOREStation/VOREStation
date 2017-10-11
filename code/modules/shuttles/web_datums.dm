// This file actually has three seperate datums.

// This is the first datum, and it connects shuttle_destinations together.
/datum/shuttle_route
	var/datum/shuttle_destination/start = null	// One of the two sides of this route.  Start just means it was the creator of this route.
	var/datum/shuttle_destination/end = null	// The second side.
	var/area/interim = null						// Where the shuttle sits during the movement.  Make sure no other shuttle shares this or Very Bad Things will happen.
	var/travel_time = 0							// How long it takes to move from start to end, or end to start.  Set to 0 for instant travel.
	var/one_way = FALSE							// If true, you can't travel from end to start.

/datum/shuttle_route/New(var/_start, var/_end, var/_interim, var/_time = 0, var/_oneway = FALSE)
	start = _start
	end = _end
	if(_interim)
		interim = locate(_interim)
	travel_time = _time
	one_way = _oneway

/datum/shuttle_route/Destroy()
	start.routes -= src
	end.routes -= src
	return ..()

/datum/shuttle_route/proc/get_other_side(var/datum/shuttle_destination/PoV)
	if(PoV == start)
		return end
	if(PoV == end)
		return start
	return null

/datum/shuttle_route/proc/display_route(var/datum/shuttle_destination/PoV)
	var/datum/shuttle_destination/target = null
	if(PoV == start)
		target = end
	else if(PoV == end)
		target = start
	else
		return "ERROR"

	return target.name

// This is the second datum, and contains information on all the potential destinations for a specific shuttle.
/datum/shuttle_destination
	var/name = "a place"				// Name of the destination, used for the flight computer.
	var/area/my_area = null				// Where the shuttle will move to when it actually arrives.
	var/datum/shuttle_web_master/master = null // The datum that does the coordination with the actual shuttle datum.
	var/list/routes = list()			// Routes that are connected to this destination.
	var/preferred_interim_area = null	// When building a new route, use this interim area.

	var/dock_target = null				// The tag_id that the shuttle will use to try to dock to the destination, if able.

	var/announcer = null				// The name of the 'announcer' that will say the arrival/departure messages.  Defaults to the map's boss name if blank.
	var/arrival_message = null			// Message said if the ship enters this destination.  Not announced if the ship is cloaked.
	var/departure_message = null		// Message said if the ship exits this destination.  Not announced if the ship is cloaked.

	// When this destination is instantiated, it will go and instantiate other destinations in this assoc list and build routes between them.
	// The list format is '/datum/shuttle_destination/subtype = 1 MINUTES'
	var/list/destinations_to_create = list()

	// When the web_master finishes creating all the destinations, it will go and build routes between this and them if they're on this list.
	// The list format is '/datum/shuttle_destination/subtype = 1 MINUTES'
	var/list/routes_to_make = list()

/datum/shuttle_destination/New(var/new_master)
	my_area = locate(my_area)
	master = new_master

/datum/shuttle_destination/Destroy()
	for(var/datum/shuttle_route/R in routes)
		qdel(R)
	master = null
	return ..()

//	build_destinations()

// This builds destination instances connected to this instance, recursively.
/datum/shuttle_destination/proc/build_destinations(var/list/already_made = list())
	already_made += src.type
	world << "SHUTTLES: [name] is going to build destinations.  already_made list is \[[english_list(already_made)]\]"
	for(var/type_to_make in destinations_to_create)
		if(type_to_make in already_made) // Avoid circular initializations.
			world << "SHUTTLES: [name] can't build [type_to_make] due to being a duplicate."
			continue

		// Instance the new destination, and call this proc on their 'downstream' destinations.
		var/datum/shuttle_destination/new_dest = new type_to_make()
		world << "SHUTTLES: [name] has created [new_dest.name] and will make it build their own destinations."
		already_made += new_dest.build_destinations(already_made)

		// Now link our new destination to us.
		var/travel_delay = destinations_to_create[type_to_make]
		link_destinations(new_dest, preferred_interim_area, travel_delay)
		world << "SHUTTLES: [name] has linked themselves to [new_dest.name]"

	world << "SHUTTLES: [name] has finished building destinations.  already_made list is \[[english_list(already_made)]\]."
	return already_made

/datum/shuttle_destination/proc/enter(var/datum/shuttle_destination/old_destination)
	announce_arrival()

/datum/shuttle_destination/proc/exit(var/datum/shuttle_destination/new_destination)
	announce_departure()


/datum/shuttle_destination/proc/announce_departure()
	if(isnull(departure_message) || master.my_shuttle.cloaked)
		return

	command_announcement.Announce(departure_message,(announcer ? announcer : "[using_map.boss_name]"))

/datum/shuttle_destination/proc/announce_arrival()
	if(isnull(arrival_message) || master.my_shuttle.cloaked)
		return

	command_announcement.Announce(arrival_message,(announcer ? announcer : "[using_map.boss_name]"))

/datum/shuttle_destination/proc/link_destinations(var/datum/shuttle_destination/other_place, var/area/interim_area, var/travel_time = 0)
	// First, check to make sure this doesn't cause a duplicate route.
	for(var/datum/shuttle_route/R in routes)
		if(R.start == other_place || R.end == other_place)
			return

	// Now we can connect them.
	var/datum/shuttle_route/new_route = new(src, other_place, interim_area, travel_time)
	routes += new_route
	other_place.routes += new_route

// Depending on certain circumstances, the shuttles can fail.
// What happens depends on where the shuttle is.  If it's in space, it just can't move until its fixed.
// If it's flying in Sif, however, things get interesting.
/datum/shuttle_destination/proc/flight_failure()
	return

// This is the third and final datum, which coordinates with the shuttle datum to tell it where it is, where it can go, and how long it will take.
// It is also responsible for instancing all the destinations it has control over, and linking them together.
/datum/shuttle_web_master
	var/datum/shuttle/web_shuttle/my_shuttle = null							// Ref to the shuttle this datum is coordinating with.
	var/datum/shuttle_destination/current_destination = null	// Where the shuttle currently is.  Bit of a misnomer.
	var/datum/shuttle_destination/future_destination = null		// Where it will be in the near future.
	var/datum/shuttle_destination/starting_destination = null	// Where the shuttle will start at, generally at the home base.
	var/list/destinations = list()								// List of currently instanced destinations.
	var/destination_class = null								// Type to use in typesof(), to build destinations.

/datum/shuttle_web_master/New(var/new_shuttle, var/new_destination_class = null)
	my_shuttle = new_shuttle
	if(new_destination_class)
		destination_class = new_destination_class
	build_destinations()
	current_destination = get_destination_by_type(starting_destination)

/datum/shuttle_web_master/Destroy()
	my_shuttle = null
	for(var/datum/shuttle_destination/D in destinations)
		qdel(D)
	return ..()

/datum/shuttle_web_master/proc/build_destinations()
	// First, instantiate all the destination subtypes relevant to this datum.
	var/list/destination_types = typesof(destination_class) - destination_class
	for(var/new_type in destination_types)
		var/datum/shuttle_destination/D = new new_type(src)
		destinations += D

	// Now start the process of connecting all of them.
	for(var/datum/shuttle_destination/D in destinations)
		for(var/type_to_link in D.routes_to_make)
			var/travel_delay = D.routes_to_make[type_to_link]
			D.link_destinations(get_destination_by_type(type_to_link), D.preferred_interim_area, travel_delay)

/datum/shuttle_web_master/proc/on_shuttle_departure()
	current_destination.exit()

/datum/shuttle_web_master/proc/on_shuttle_arrival()
	if(future_destination)
		future_destination.enter()
		current_destination = future_destination
		future_destination = null
	my_shuttle.current_area = current_destination.my_area

/datum/shuttle_web_master/proc/current_dock_target()
	if(current_destination)
		return current_destination.dock_target

/datum/shuttle_web_master/proc/get_available_routes()
	if(current_destination)
		return current_destination.routes.Copy()

/datum/shuttle_web_master/proc/get_current_destination()
	return current_destination

/datum/shuttle_web_master/proc/get_destination_by_type(var/type_to_get)
	return locate(type_to_get) in destinations