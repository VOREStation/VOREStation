/datum/locations
	var/name
	var/desc
	var/list/contents = list()
	var/parent

/datum/locations/New(var/creator)
	if(creator)
		parent = creator

var/global/datum/locations/milky_way/all_locations = new()

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

/proc/choose_location_datum(client/user)
	var/datum/locations/choice = all_locations
	while(length(choice.contents) > 0) //For some reason it wouldn't let me do contents.len even when I defined it as a list.
		var/specific = alert(user, "The location currently selected is [choice.name].  More specific options exist, would you like to pick a more specific location?",
		"Choose location", "Yes", "No")
		if(specific == "Yes" && length(choice.contents) > 0)
			choice = input(user, "Please choose a location.","Locations") as null|anything in choice.contents
		else
			break
	user << choice.name
	user << choice.desc
	return choice

//	var/datum/locations/choice = input(user, "Please choose a location.","Locations") as null|anything in all_locations
//	if(choice && choice.contents.len > 0)


/*
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
*/
