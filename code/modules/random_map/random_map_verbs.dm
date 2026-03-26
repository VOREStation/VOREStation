ADMIN_VERB(print_random_map, R_DEBUG, "Display Random Map", "Show the contents of a random map.", ADMIN_CATEGORY_DEBUG_EVENTS)
	var/choice = tgui_input_list(user, "Choose a map to display.", "Map Choice", GLOB.random_maps)
	if(!choice)
		return
	var/datum/random_map/selected_map = GLOB.random_maps[choice]
	if(istype(selected_map))
		selected_map.display_map(user)

ADMIN_VERB(delete_random_map, R_DEBUG, "Delete Random Map", "Delete a random map.", ADMIN_CATEGORY_DEBUG_EVENTS)
	var/choice = tgui_input_list(user, "Choose a map to delete.", "Map Choice", GLOB.random_maps)
	if(!choice)
		return
	var/datum/random_map/selected_map = GLOB.random_maps[choice]
	GLOB.random_maps[choice] = null
	if(istype(selected_map))
		log_and_message_admins("has deleted [selected_map.name].", user)
		qdel(selected_map)

ADMIN_VERB(create_random_map, R_DEBUG, "Create Random Map", "Create a random map.", ADMIN_CATEGORY_DEBUG_EVENTS)
	var/map_datum = tgui_input_list(user, "Choose a map to create.", "Map Choice", subtypesof(/datum/random_map))
	if(!map_datum)
		return

	var/datum/random_map/selected_map
	if(tgui_alert(user, "Do you wish to customise the map?","Customize",list("Yes","No")) == "Yes")
		var/seed = tgui_input_text(user, "Seed? (blank for none)")
		var/lx =   tgui_input_number(user, "X-size? (blank for default)")
		var/ly =   tgui_input_number(user, "Y-size? (blank for default)")
		selected_map = new map_datum(seed,null,null,null,lx,ly,1)
	else
		selected_map = new map_datum(null,null,null,null,null,null,1)

	if(selected_map)
		log_and_message_admins("has created [selected_map.name].", user)

ADMIN_VERB(apply_random_map, R_DEBUG, "Apply Random Map", "Apply a map to the game world.", ADMIN_CATEGORY_DEBUG_EVENTS)
	var/choice = tgui_input_list(user, "Choose a map to apply.", "Map Choice", GLOB.random_maps)
	if(!choice)
		return
	var/datum/random_map/selected_map = GLOB.random_maps[choice]
	if(istype(selected_map))
		var/tx = tgui_input_number(user, "X? (default to current turf)")
		var/ty = tgui_input_number(user, "Y? (default to current turf)")
		var/tz = tgui_input_number(user, "Z? (default to current turf)")
		if(isnull(tx) || isnull(ty) || isnull(tz))
			var/turf/target_turf = get_turf(user)
			tx = !isnull(tx) ? tx : target_turf.x
			ty = !isnull(ty) ? ty : target_turf.y
			tz = !isnull(tz) ? tz : target_turf.z
		log_and_message_admins("has applied [selected_map.name] at x[tx],y[ty],z[tz].", user)
		selected_map.set_origins(tx,ty,tz)
		selected_map.apply_to_map()

ADMIN_VERB(overlay_random_map, R_DEBUG, "Overlay Random Map", "Apply a map to another map.", ADMIN_CATEGORY_DEBUG_EVENTS)
	var/choice = tgui_input_list(user, "Choose a map as base.", "Map Choice", GLOB.random_maps)
	if(!choice)
		return
	var/datum/random_map/base_map = GLOB.random_maps[choice]

	choice = tgui_input_list(user, "Choose a map to overlay.", "Map Choice", GLOB.random_maps)
	if(!choice)
		return

	var/datum/random_map/overlay_map = GLOB.random_maps[choice]

	if(istype(base_map) && istype(overlay_map))
		var/tx = tgui_input_number(user, "X? (default to 1)")
		var/ty = tgui_input_number(user, "Y? (default to 1)")
		if(!tx) tx = 1
		if(!ty) ty = 1
		log_and_message_admins("has applied [overlay_map.name] to [base_map.name] at x[tx],y[ty].", user)
		overlay_map.overlay_with(base_map,tx,ty)
		base_map.display_map(user)
