/client/proc/map_template_load()
	set category = "Debug.Events"
	set name = "Map template - Place At Loc"

	var/datum/map_template/template


	var/map = tgui_input_list(usr, "Choose a Map Template to place at your CURRENT LOCATION","Place Map Template", SSmapping.map_templates)
	if(!map)
		return
	template = SSmapping.map_templates[map]

	var/turf/T = get_turf(mob)
	if(!T)
		return

	var/list/preview = list()
	template.preload_size(template.mappath)
	for(var/S in template.get_affected_turfs(T,centered = TRUE))
		preview += image('icons/misc/debug_group.dmi',S ,"red")
	usr.client.images += preview
	if(tgui_alert(usr,"Confirm location.", "Template Confirm",list("No","Yes")) == "Yes")
		if(template.annihilate && tgui_alert(usr,"This template is set to annihilate everything in the red square. EVERYTHING IN THE RED SQUARE WILL BE DELETED, ARE YOU ABSOLUTELY SURE?", "Template Confirm", list("No","Yes")) != "Yes")
			usr.client.images -= preview
			return

		if(template.load(T, centered = TRUE))
			message_admins(span_adminnotice("[key_name_admin(usr)] has placed a map template ([template.name])."))
		else
			to_chat(usr, "Failed to place map")
	if(usr)
		usr.client.images -= preview

/client/proc/map_template_load_on_new_z()
	set category = "Debug.Events"
	set name = "Map template - New Z"

	var/datum/map_template/template

	var/map = tgui_input_list(usr, "Choose a Map Template to place on a new Z-level.","Place Map Template", SSmapping.map_templates)
	if(!map)
		return
	template = SSmapping.map_templates[map]

	if(template.width > world.maxx || template.height > world.maxx)
		if(tgui_alert(usr,"This template is larger than the existing z-levels. It will EXPAND ALL Z-LEVELS to match the size of the template. This may cause chaos. Are you sure you want to do this?","DANGER!!!",list("Cancel","Yes")) == "Cancel")
			to_chat(usr,"Template placement aborted.")
			return

	if(tgui_alert(usr,"Confirm map load.", "Template Confirm",list("No","Yes")) == "Yes")
		if(template.load_new_z())
			message_admins(span_adminnotice("[key_name_admin(usr)] has placed a map template ([template.name]) on Z level [world.maxz]."))
		else
			to_chat(usr, "Failed to place map")


/client/proc/map_template_upload()
	set category = "Debug.Events"
	set name = "Map Template - Upload"

	var/map = input(usr, "Choose a Map Template to upload to template storage","Upload Map Template") as null|file
	if(!map)
		return
	if(copytext("[map]",-4) != ".dmm")
		to_chat(usr, "Bad map file: [map]")
		return

	var/datum/map_template/M = new(map, "[map]")
	if(M.preload_size(map))
		to_chat(usr, "Map template '[map]' ready to place ([M.width]x[M.height])")
		SSmapping.map_templates[M.name] = M
		message_admins(span_adminnotice("[key_name_admin(usr)] has uploaded a map template ([map])"))
	else
		to_chat(usr, "Map template '[map]' failed to load properly")
