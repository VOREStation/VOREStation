/datum/locations
	var/name
	var/desc
	var/list/contents = list()
	var/parent

/datum/locations/New(var/creator)
	if(creator)
		parent = creator

var/global/datum/locations/milky_way/locations = new()

//Galaxy

/datum/locations/milky_way
	name = "Milky Way Galaxy"
	desc = "The galaxy we all live in."

/datum/locations/milky_way/New()
	contents.Add(
		new /datum/locations/sol(src),
		new /datum/locations/tau_ceti(src),
		new /datum/locations/nyx(src),
		new /datum/locations/qerrvallis(src),
		new /datum/locations/s_randarr(src),
		new /datum/locations/uueoa_esa(src),
		new /datum/locations/vir(src)
		)

/datum/locations/proc/show_contents()
//	world << "[src]\n[desc]"
	for(var/datum/locations/a in contents)
		world << "[a]\n[a.parent ? "Located in [a.parent]\n" : ""][a.desc]"
		a.show_contents()
	world << "\n"

/datum/locations/proc/count_locations()
	var/i = 0
	for(var/datum/locations/a in contents)
		i = i + a.count_locations()
	return i

/client/verb/show_locations()
	set name = "Show Locations"
	set category = "Debug"
	locations.show_contents()

/client/verb/debug_locations()
	set name = "Debug Locations"
	set category = "Debug"
	debug_variables(locations)

/client/verb/count_locations()
	set name = "Count Locations"
	set category = "Debug"
	var/location_number = locations.count_locations()
	world << location_number