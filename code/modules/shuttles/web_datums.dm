// This file actually has four seperate datums.

/**********
 * Routes *
 **********/

// This is the first datum, and it connects shuttle_destinations together.
/datum/shuttle_route
	var/datum/shuttle_destination/start = null	// One of the two sides of this route.  Start just means it was the creator of this route.
	var/datum/shuttle_destination/end = null	// The second side.
	var/var/obj/effect/shuttle_landmark/interim	// Where the shuttle sits during the movement.  Make sure no other shuttle shares this or Very Bad Things will happen.
	var/travel_time = 0							// How long it takes to move from start to end, or end to start.  Set to 0 for instant travel.
	var/one_way = FALSE							// If true, you can't travel from end to start.

/datum/shuttle_route/New(var/_start, var/_end, var/_interim, var/_time = 0, var/_oneway = FALSE)
	start = _start
	end = _end
	if(_interim)
		interim = SSshuttles.get_landmark(_interim)
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

/****************
 * Destinations *
 ****************/

// This is the second datum, and contains information on all the potential destinations for a specific shuttle.
/datum/shuttle_destination
	var/name = "a place"				// Name of the destination, used for the flight computer.
	var/obj/effect/shuttle_landmark/my_landmark = null // Where the shuttle will move to when it actually arrives.
	var/datum/shuttle_web_master/master = null // The datum that does the coordination with the actual shuttle datum.
	var/list/routes = list()			// Routes that are connected to this destination.
	var/preferred_interim_tag = null	// When building a new route, use interim landmark with this tag.
	var/skip_me = FALSE					// We will not autocreate this one. Some map must be doing it.

	var/radio_announce = 0				// Whether it will make a station announcement (0) or a radio announcement (1).
	var/announcer = null				// The name of the 'announcer' that will say the arrival/departure messages.  Defaults to the map's boss name if blank.
//	var/arrival_message = null			// Message said if the ship enters this destination.  Not announced if the ship is cloaked.
//	var/departure_message = null		// Message said if the ship exits this destination.  Not announced if the ship is cloaked.

	// When this destination is instantiated, it will go and instantiate other destinations in this assoc list and build routes between them.
	// The list format is '/datum/shuttle_destination/subtype = 1 MINUTES'
	var/list/destinations_to_create = list()

	// When the web_master finishes creating all the destinations, it will go and build routes between this and them if they're on this list.
	// The list format is '/datum/shuttle_destination/subtype = 1 MINUTES'
	var/list/routes_to_make = list()

/datum/shuttle_destination/New(var/new_master)
	my_landmark = SSshuttles.get_landmark(my_landmark)
	if(!my_landmark)
		log_debug("Web shuttle destination '[name]' could not find its landmark '[my_landmark]'.") // Important error message
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
	to_world("SHUTTLES: [name] is going to build destinations.  already_made list is \[[english_list(already_made)]\]")
	for(var/type_to_make in destinations_to_create)
		if(type_to_make in already_made) // Avoid circular initializations.
			to_world("SHUTTLES: [name] can't build [type_to_make] due to being a duplicate.")
			continue

		// Instance the new destination, and call this proc on their 'downstream' destinations.
		var/datum/shuttle_destination/new_dest = new type_to_make()
		to_world("SHUTTLES: [name] has created [new_dest.name] and will make it build their own destinations.")
		already_made += new_dest.build_destinations(already_made)

		// Now link our new destination to us.
		var/travel_delay = destinations_to_create[type_to_make]
		link_destinations(new_dest, preferred_interim_tag, travel_delay)
		to_world("SHUTTLES: [name] has linked themselves to [new_dest.name]")

	to_world("SHUTTLES: [name] has finished building destinations.  already_made list is \[[english_list(already_made)]\].")
	return already_made

/datum/shuttle_destination/proc/enter(var/datum/shuttle_destination/old_destination)
	announce_arrival()

/datum/shuttle_destination/proc/exit(var/datum/shuttle_destination/new_destination)
	announce_departure()

/datum/shuttle_destination/proc/get_departure_message()
	return null

/datum/shuttle_destination/proc/announce_departure()
	if(isnull(get_departure_message()) || master.my_shuttle.cloaked)
		return

	if(!radio_announce)
		command_announcement.Announce(get_departure_message(),(announcer ? announcer : "[using_map.boss_name]"))
	else
		GLOB.global_announcer.autosay(get_departure_message(),(announcer ? announcer : "[using_map.boss_name]"))

/datum/shuttle_destination/proc/get_arrival_message()
	return null

/datum/shuttle_destination/proc/announce_arrival()
	if(isnull(get_arrival_message()) || master.my_shuttle.cloaked)
		return

	if(!radio_announce)
		command_announcement.Announce(get_arrival_message(),(announcer ? announcer : "[using_map.boss_name]"))
	else
		GLOB.global_announcer.autosay(get_arrival_message(),(announcer ? announcer : "[using_map.boss_name]"))

/datum/shuttle_destination/proc/link_destinations(var/datum/shuttle_destination/other_place, var/interim_tag, var/travel_time = 0)
	// First, check to make sure this doesn't cause a duplicate route.
	for(var/datum/shuttle_route/R in routes)
		if(R.start == other_place || R.end == other_place)
			return

	// Now we can connect them.
	var/datum/shuttle_route/new_route = new(src, other_place, interim_tag, travel_time)
	routes += new_route
	other_place.routes += new_route

// Depending on certain circumstances, the shuttles can fail.
// What happens depends on where the shuttle is.  If it's in space, it just can't move until its fixed.
// If it's flying in Sif, however, things get interesting.
/datum/shuttle_destination/proc/flight_failure()
	return

// Returns a /datum/shuttle_route connecting this destination to origin, if one exists.
/datum/shuttle_destination/proc/get_route_to(origin_type)
	for(var/datum/shuttle_route/R in routes)
		if(R.start.type == origin_type || R.end.type == origin_type)
			return R
	return null

/***************
 * Web Masters *
 ***************/

// This is the third and final datum, which coordinates with the shuttle datum to tell it where it is, where it can go, and how long it will take.
// It is also responsible for instancing all the destinations it has control over, and linking them together.
/datum/shuttle_web_master
	var/datum/shuttle/autodock/web_shuttle/my_shuttle = null	// Ref to the shuttle this datum is coordinating with.
	var/datum/shuttle_destination/current_destination = null	// Where the shuttle currently is.  Bit of a misnomer.
	var/datum/shuttle_destination/future_destination = null		// Where it will be in the near future.
	var/datum/shuttle_destination/starting_destination = null	// Where the shuttle will start at, generally at the home base.
	var/list/destinations = list()								// List of currently instanced destinations.
	var/destination_class = null								// Type to use in typesof(), to build destinations.

	var/datum/shuttle_autopath/autopath = null					// Datum used to direct an autopilot.
	var/list/autopaths = list()									// Potential autopaths the autopilot can use. The autopath's start var must equal current_destination to be viable.
	var/autopath_class = null									// Similar to destination_class, used for typesof().

/datum/shuttle_web_master/New(var/new_shuttle, var/new_destination_class = null)
	my_shuttle = new_shuttle
	if(new_destination_class)
		destination_class = new_destination_class
	build_destinations()
	current_destination = get_destination_by_type(starting_destination)
	build_autopaths()

/datum/shuttle_web_master/Destroy()
	my_shuttle = null
	for(var/datum/shuttle_destination/D in destinations)
		qdel(D)
	return ..()

/datum/shuttle_web_master/proc/build_destinations()
	// First, instantiate all the destination subtypes relevant to this datum.
	var/list/destination_types = subtypesof(destination_class)
	for(var/new_type in destination_types)
		var/datum/shuttle_destination/D = new_type
		if(initial(D.skip_me))
			continue
		destinations += new new_type(src)

	// Now start the process of connecting all of them.
	for(var/datum/shuttle_destination/D in destinations)
		for(var/type_to_link in D.routes_to_make)
			var/travel_delay = D.routes_to_make[type_to_link]
			D.link_destinations(get_destination_by_type(type_to_link), D.preferred_interim_tag, travel_delay)

/datum/shuttle_web_master/proc/on_shuttle_departure()
	current_destination.exit()

/datum/shuttle_web_master/proc/on_shuttle_arrival()
	if(future_destination)
		future_destination.enter()
		current_destination = future_destination
		future_destination = null

/datum/shuttle_web_master/proc/get_available_routes()
	if(current_destination)
		return current_destination.routes.Copy()

/datum/shuttle_web_master/proc/get_current_destination()
	RETURN_TYPE(/datum/shuttle_destination)
	return current_destination

/datum/shuttle_web_master/proc/get_destination_by_type(var/type_to_get)
	return locate(type_to_get) in destinations

// Autopilot stuff.
/datum/shuttle_web_master/proc/build_autopaths()
	init_subtypes(autopath_class, autopaths)
	for(var/datum/shuttle_autopath/P in autopaths)
		P.master = src

/datum/shuttle_web_master/proc/choose_path()
	if(!autopaths.len)
		return
	for(var/datum/shuttle_autopath/path in autopaths)
		if(path.start == current_destination.type)
			autopath = path
			break

/datum/shuttle_web_master/proc/path_finished(datum/shuttle_autopath/path)
	autopath = null

/datum/shuttle_web_master/proc/walk_path(target_type)
	var/datum/shuttle_route/R = current_destination.get_route_to(target_type)
	if(!R)
		return FALSE
	future_destination = R.get_other_side(current_destination)

	var/travel_time = R.travel_time * my_shuttle.flight_time_modifier * 2 // Autopilot is less efficent than having someone flying manually.
	// TODO - Leshana - Change this to use proccess stuff of autodock!
	if(R.interim && R.travel_time > 0)
		my_shuttle.long_jump(future_destination.my_landmark, R.interim, travel_time / 10)
	else
		my_shuttle.short_jump(future_destination.my_landmark)
	return TRUE // Note this will return before the shuttle actually arrives.

/datum/shuttle_web_master/proc/process_autopath()
	if(!autopath) // If we don't have a path, get one.
		if(!autopaths.len)
			return
		choose_path()

	if(!autopath) // Still nothing, oh well.
		return

	var/datum/shuttle_destination/target = autopath.get_next_node()
	if(walk_path(target))
		autopath.walk_path()

// Call this to reset everything related to autopiloting.
/datum/shuttle_web_master/proc/reset_autopath()
	autopath = null
	my_shuttle.autopilot = FALSE


/*************
 * Autopaths *
 *************/


// Fourth datum, this one essentially acts as directions for an autopilot to go to the correct places.
/datum/shuttle_autopath
	var/datum/shuttle_web_master/master = null
	var/datum/shuttle_destination/start = null
	var/list/path_nodes = list()
	var/index = 1

/datum/shuttle_autopath/Destroy()
	master = null
	return ..()

/datum/shuttle_autopath/proc/reset_path()
	index = 1

/datum/shuttle_autopath/proc/get_next_node()
	return path_nodes[index]

/datum/shuttle_autopath/proc/walk_path()
	index++
	if(index > path_nodes.len)
		finish_path()

/datum/shuttle_autopath/proc/finish_path()
	reset_path()
	master.path_finished(src)
