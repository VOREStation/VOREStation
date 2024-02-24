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
		var/specific = tgui_alert(user, "The location currently selected is [choice.name].  More specific options exist, would you like to pick a more specific location?", "Choose location", list("Yes", "No"))
		if(specific == "Yes" && length(choice.contents) > 0)
			choice = tgui_input_list(user, "Please choose a location.", "Locations", choice.contents)
		else
			break
	to_chat(user,choice.name)
	to_chat(user,choice.desc)
	return choice
