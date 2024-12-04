/datum/tgui_module/appearance_changer
	name = "Appearance Editor"
	tgui_id = "AppearanceChanger"
	var/flags = APPEARANCE_ALL_HAIR
	var/mob/living/carbon/human/owner = null
	var/list/valid_species = list()
	var/list/valid_hairstyles = list()
	var/list/valid_facial_hairstyles = list()

	var/check_whitelist
	var/list/whitelist
	var/list/blacklist

	var/customize_usr = FALSE

	// Stuff needed to render the map
	var/map_name
	var/obj/screen/map_view/cam_screen
	var/list/cam_plane_masters
	var/obj/screen/background/cam_background
	var/obj/screen/skybox/local_skybox
	// Stuff for moving cameras
	var/turf/last_camera_turf

	var/list/valid_earstyles = list()
	var/list/valid_tailstyles = list()
	var/list/valid_wingstyles = list()
	var/list/markings = null

/datum/tgui_module/appearance_changer/New(
		host,
		mob/living/carbon/human/H,
		check_species_whitelist = 1,
		list/species_whitelist = list(),
		list/species_blacklist = list())
	. = ..()

	map_name = "appearance_changer_[REF(src)]_map"
	// Initialize map objects
	cam_screen = new

	cam_screen.name = "screen"
	cam_screen.assigned_map = map_name
	cam_screen.del_on_map_removal = FALSE
	cam_screen.screen_loc = "[map_name]:1,1"

	cam_plane_masters = get_tgui_plane_masters()

	for(var/obj/screen/instance as anything in cam_plane_masters)
		instance.assigned_map = map_name
		instance.del_on_map_removal = FALSE
		instance.screen_loc = "[map_name]:CENTER"

	local_skybox = new()
	local_skybox.assigned_map = map_name
	local_skybox.del_on_map_removal = FALSE
	local_skybox.screen_loc = "[map_name]:CENTER,CENTER"
	cam_plane_masters += local_skybox

	owner = H
	cam_background = new
	cam_background.assigned_map = map_name
	cam_background.del_on_map_removal = FALSE
	check_whitelist = check_species_whitelist
	whitelist = species_whitelist
	blacklist = species_blacklist

/datum/tgui_module/appearance_changer/tgui_close(mob/user)
	. = ..()
	if(owner == user)
		UnregisterSignal(owner, COMSIG_OBSERVER_MOVED)
		owner = null
		close_ui()

/datum/tgui_module/appearance_changer/Destroy()
	UnregisterSignal(owner, COMSIG_OBSERVER_MOVED)
	owner = null
	last_camera_turf = null
	qdel(cam_screen)
	QDEL_LIST(cam_plane_masters)
	qdel(cam_background)
	cut_data()
	return ..()

/datum/tgui_module/appearance_changer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("race")
			if(can_change(owner, APPEARANCE_RACE) && (params["race"] in valid_species))
				if(owner.change_species(params["race"]))
					if(params["race"] == "Custom Species")
						owner.custom_species = sanitize(tgui_input_text(ui.user, "Input custom species name:",
							"Custom Species Name", null, MAX_NAME_LEN), MAX_NAME_LEN)
					cut_data()
					generate_data(ui.user, owner)
					changed_hook(APPEARANCECHANGER_CHANGED_RACE)
					return 1
		if("gender")
			if(can_change(owner, APPEARANCE_GENDER) && (params["gender"] in get_genders(owner)))
				if(owner.change_gender(params["gender"]))
					cut_data()
					generate_data(ui.user, owner)
					changed_hook(APPEARANCECHANGER_CHANGED_GENDER)
					return 1
		if("gender_id")
			if(can_change(owner, APPEARANCE_GENDER) && (params["gender_id"] in all_genders_define_list))
				owner.identifying_gender = params["gender_id"]
				changed_hook(APPEARANCECHANGER_CHANGED_GENDER_ID)
				return 1
		if("skin_tone")
			if(can_change_skin_tone(owner))
				var/new_s_tone = tgui_input_number(ui.user, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Skin Tone", -owner.s_tone + 35, 220, 1)
				if(isnum(new_s_tone) && can_still_topic(owner, state))
					new_s_tone = 35 - max(min( round(new_s_tone), 220),1)
					changed_hook(APPEARANCECHANGER_CHANGED_SKINTONE)
					return owner.change_skin_tone(new_s_tone)
		if("skin_color")
			if(can_change_skin_color(owner))
				var/new_skin = input(ui.user, "Choose your character's skin colour: ", "Skin Color", rgb(owner.r_skin, owner.g_skin, owner.b_skin)) as color|null
				if(new_skin && can_still_topic(owner, state))
					var/r_skin = hex2num(copytext(new_skin, 2, 4))
					var/g_skin = hex2num(copytext(new_skin, 4, 6))
					var/b_skin = hex2num(copytext(new_skin, 6, 8))
					if(owner.change_skin_color(r_skin, g_skin, b_skin))
						update_dna(ui.user, owner)
						changed_hook(APPEARANCECHANGER_CHANGED_SKINCOLOR)
						return 1
		if("hair")
			if(can_change(owner, APPEARANCE_HAIR) && (params["hair"] in valid_hairstyles))
				if(owner.change_hair(params["hair"]))
					update_dna(owner)
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRSTYLE)
					return 1
		if("hair_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = input(ui.user, "Please select hair color.", "Hair Color", rgb(owner.r_hair, owner.g_hair, owner.b_hair)) as color|null
				if(new_hair && can_still_topic(owner, state))
					var/r_hair = hex2num(copytext(new_hair, 2, 4))
					var/g_hair = hex2num(copytext(new_hair, 4, 6))
					var/b_hair = hex2num(copytext(new_hair, 6, 8))
					if(owner.change_hair_color(r_hair, g_hair, b_hair))
						update_dna(owner)
						changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
						return 1
		if("facial_hair")
			if(can_change(owner, APPEARANCE_FACIAL_HAIR) && (params["facial_hair"] in valid_facial_hairstyles))
				if(owner.change_facial_hair(params["facial_hair"]))
					update_dna(owner)
					changed_hook(APPEARANCECHANGER_CHANGED_F_HAIRSTYLE)
					return 1
		if("facial_hair_color")
			if(can_change(owner, APPEARANCE_FACIAL_HAIR_COLOR))
				var/new_facial = input(ui.user, "Please select facial hair color.", "Facial Hair Color", rgb(owner.r_facial, owner.g_facial, owner.b_facial)) as color|null
				if(new_facial && can_still_topic(owner, state))
					var/r_facial = hex2num(copytext(new_facial, 2, 4))
					var/g_facial = hex2num(copytext(new_facial, 4, 6))
					var/b_facial = hex2num(copytext(new_facial, 6, 8))
					if(owner.change_facial_hair_color(r_facial, g_facial, b_facial))
						update_dna(owner)
						changed_hook(APPEARANCECHANGER_CHANGED_F_HAIRCOLOR)
						return 1
		if("eye_color")
			if(can_change(owner, APPEARANCE_EYE_COLOR))
				var/new_eyes = input(ui.user, "Please select eye color.", "Eye Color", rgb(owner.r_eyes, owner.g_eyes, owner.b_eyes)) as color|null
				if(new_eyes && can_still_topic(owner, state))
					var/r_eyes = hex2num(copytext(new_eyes, 2, 4))
					var/g_eyes = hex2num(copytext(new_eyes, 4, 6))
					var/b_eyes = hex2num(copytext(new_eyes, 6, 8))
					if(owner.change_eye_color(r_eyes, g_eyes, b_eyes))
						update_dna(owner)
						changed_hook(APPEARANCECHANGER_CHANGED_EYES)
						return 1
		// VOREStation Add - Ears/Tails/Wings/Markings
		if("ear")
			if(can_change(owner, APPEARANCE_ALL_HAIR))
				var/datum/sprite_accessory/ears/instance = locate(params["ref"])
				if(params["clear"])
					instance = null
				if(!istype(instance) && !params["clear"])
					return FALSE
				owner.ear_style = instance
				owner.update_hair()
				update_dna(owner)
				changed_hook(APPEARANCECHANGER_CHANGED_HAIRSTYLE)
				return TRUE
		if("ear_secondary")
			if(can_change(owner, APPEARANCE_ALL_HAIR))
				var/datum/sprite_accessory/ears/instance = locate(params["ref"])
				if(params["clear"])
					instance = null
				if(!istype(instance) && !params["clear"])
					return FALSE
				owner.ear_secondary_style = instance
				if(!islist(owner.ear_secondary_colors))
					owner.ear_secondary_colors = list()
				if(instance && length(owner.ear_secondary_colors) < instance.get_color_channel_count())
					owner.ear_secondary_colors.len = instance.get_color_channel_count()
				owner.update_hair()
				update_dna(owner)
				changed_hook(APPEARANCECHANGER_CHANGED_HAIRSTYLE)
				return TRUE
		if("ears_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = input(ui.user, "Please select ear color.", "Ear Color", rgb(owner.r_ears, owner.g_ears, owner.b_ears)) as color|null
				if(new_hair && can_still_topic(owner, state))
					owner.r_ears = hex2num(copytext(new_hair, 2, 4))
					owner.g_ears = hex2num(copytext(new_hair, 4, 6))
					owner.b_ears = hex2num(copytext(new_hair, 6, 8))
					update_dna(owner)
					owner.update_hair()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("ears2_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = input(ui.user, "Please select secondary ear color.", "2nd Ear Color", rgb(owner.r_ears2, owner.g_ears2, owner.b_ears2)) as color|null
				if(new_hair && can_still_topic(owner, state))
					owner.r_ears2 = hex2num(copytext(new_hair, 2, 4))
					owner.g_ears2 = hex2num(copytext(new_hair, 4, 6))
					owner.b_ears2 = hex2num(copytext(new_hair, 6, 8))
					update_dna(owner)
					owner.update_hair()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("ears_secondary_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/channel = params["channel"]
				if(channel > length(owner.ear_secondary_colors))
					return TRUE
				var/existing = LAZYACCESS(owner.ear_secondary_colors, channel) || "#ffffff"
				var/new_color = input(ui.user, "Please select ear color.", "2nd Ear Color", existing) as color|null
				if(new_color && can_still_topic(owner, state))
					owner.ear_secondary_colors[channel] = new_color
					update_dna(owner)
					owner.update_hair()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return TRUE
		if("tail")
			if(can_change(owner, APPEARANCE_ALL_HAIR))
				var/datum/sprite_accessory/tail/instance = locate(params["ref"])
				if(params["clear"])
					instance = null
				if(!istype(instance) && !params["clear"])
					return FALSE
				owner.tail_style = instance
				owner.update_tail_showing()
				update_dna(owner)
				changed_hook(APPEARANCECHANGER_CHANGED_HAIRSTYLE)
				return TRUE
		if("tail_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = input(ui.user, "Please select tail color.", "Tail Color", rgb(owner.r_tail, owner.g_tail, owner.b_tail)) as color|null
				if(new_hair && can_still_topic(owner, state))
					owner.r_tail = hex2num(copytext(new_hair, 2, 4))
					owner.g_tail = hex2num(copytext(new_hair, 4, 6))
					owner.b_tail = hex2num(copytext(new_hair, 6, 8))
					update_dna(owner)
					owner.update_tail_showing()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("tail2_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = input(ui.user, "Please select secondary tail color.", "2nd Tail Color", rgb(owner.r_tail2, owner.g_tail2, owner.b_tail2)) as color|null
				if(new_hair && can_still_topic(owner, state))
					owner.r_tail2 = hex2num(copytext(new_hair, 2, 4))
					owner.g_tail2 = hex2num(copytext(new_hair, 4, 6))
					owner.b_tail2 = hex2num(copytext(new_hair, 6, 8))
					update_dna(owner)
					owner.update_tail_showing()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("tail3_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = input(ui.user, "Please select secondary tail color.", "3rd Tail Color", rgb(owner.r_tail3, owner.g_tail3, owner.b_tail3)) as color|null
				if(new_hair && can_still_topic(owner, state))
					owner.r_tail3 = hex2num(copytext(new_hair, 2, 4))
					owner.g_tail3 = hex2num(copytext(new_hair, 4, 6))
					owner.b_tail3 = hex2num(copytext(new_hair, 6, 8))
					update_dna(owner)
					owner.update_tail_showing()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("wing")
			if(can_change(owner, APPEARANCE_ALL_HAIR))
				var/datum/sprite_accessory/wing/instance = locate(params["ref"])
				if(params["clear"])
					instance = null
				if(!istype(instance) && !params["clear"])
					return FALSE
				owner.wing_style = instance
				owner.update_wing_showing()
				update_dna(owner)
				changed_hook(APPEARANCECHANGER_CHANGED_HAIRSTYLE)
				return TRUE
		if("wing_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = input(ui.user, "Please select wing color.", "Wing Color", rgb(owner.r_wing, owner.g_wing, owner.b_wing)) as color|null
				if(new_hair && can_still_topic(owner, state))
					owner.r_wing = hex2num(copytext(new_hair, 2, 4))
					owner.g_wing = hex2num(copytext(new_hair, 4, 6))
					owner.b_wing = hex2num(copytext(new_hair, 6, 8))
					update_dna(owner)
					owner.update_wing_showing()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("wing2_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = input(ui.user, "Please select secondary wing color.", "2nd Wing Color", rgb(owner.r_wing2, owner.g_wing2, owner.b_wing2)) as color|null
				if(new_hair && can_still_topic(owner, state))
					owner.r_wing2 = hex2num(copytext(new_hair, 2, 4))
					owner.g_wing2 = hex2num(copytext(new_hair, 4, 6))
					owner.b_wing2 = hex2num(copytext(new_hair, 6, 8))
					update_dna(owner)
					owner.update_wing_showing()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("wing3_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = input(ui.user, "Please select secondary wing color.", "3rd Wing Color", rgb(owner.r_wing3, owner.g_wing3, owner.b_wing3)) as color|null
				if(new_hair && can_still_topic(owner, state))
					owner.r_wing3 = hex2num(copytext(new_hair, 2, 4))
					owner.g_wing3 = hex2num(copytext(new_hair, 4, 6))
					owner.b_wing3 = hex2num(copytext(new_hair, 6, 8))
					update_dna(owner)
					owner.update_wing_showing()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("marking")
			if(can_change(owner, APPEARANCE_ALL_HAIR))
				var/todo = params["todo"]
				var/name_marking = params["name"]
				switch (todo)
					if (0) //delete
						if (name_marking)
							var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[name_marking]
							if (owner.remove_marking(mark_datum))
								changed_hook(APPEARANCECHANGER_CHANGED_HAIRSTYLE)
								return TRUE
					if (1) //add
						var/list/usable_markings = markings.Copy() ^ body_marking_styles_list.Copy()
						var/new_marking = tgui_input_list(ui.user, "Choose a body marking:", "New Body Marking", usable_markings)
						if(new_marking && can_still_topic(owner, state))
							var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[new_marking]
							if (owner.add_marking(mark_datum))
								changed_hook(APPEARANCECHANGER_CHANGED_HAIRSTYLE)
								return TRUE
					if (2) //move up
						var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[name_marking]
						if (owner.change_priority_of_marking(mark_datum, FALSE))
							return TRUE
					if (3) //move down
						var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[name_marking]
						if (owner.change_priority_of_marking(mark_datum, TRUE))
							return TRUE
					if (4) //color
						var/current = markings[name_marking] ? markings[name_marking] : "#000000"
						var/marking_color = input(ui.user, "Please select marking color", "Marking color", current) as color|null
						if(marking_color && can_still_topic(owner, state))
							var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[name_marking]
							if (owner.change_marking_color(mark_datum, marking_color))
								return TRUE
		// VOREStation Add End
	return FALSE

/datum/tgui_module/appearance_changer/tgui_interact(mob/user, datum/tgui/ui = null, datum/tgui/parent_ui = null, datum/tgui_state/custom_state)
	if(customize_usr && !owner)
		if(!ishuman(user))
			return TRUE
		owner = user

	if(!owner || !owner.species)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		owner.AddComponent(/datum/component/recursive_move)
		RegisterSignal(owner, COMSIG_OBSERVER_MOVED, PROC_REF(update_active_camera_screen))
		// Register map objects
		user.client.register_map_obj(cam_screen)
		for(var/plane in cam_plane_masters)
			user.client.register_map_obj(plane)
		user.client.register_map_obj(cam_background)
		// Open UI
		ui = new(user, src, tgui_id, name)
		ui.open()
	if(custom_state)
		ui.set_state(custom_state)
	update_active_camera_screen()

/datum/tgui_module/appearance_changer/tgui_static_data(mob/user)
	var/list/data = ..()

	generate_data(user, owner)

	if(can_change(owner, APPEARANCE_RACE))
		var/species[0]
		for(var/specimen in valid_species)
			species[++species.len] =  list("specimen" = specimen)
		data["species"] = species

	if(can_change(owner, APPEARANCE_HAIR))
		var/hair_styles[0]
		for(var/hair_style in valid_hairstyles)
			hair_styles[++hair_styles.len] = list("hairstyle" = hair_style)
		data["hair_styles"] = hair_styles
		// VOREStation Add - Ears/Tails/Wings
		data["ear_styles"] = valid_earstyles
		data["tail_styles"] = valid_tailstyles
		data["wing_styles"] = valid_wingstyles
		// VOREStation Add End

	if(can_change(owner, APPEARANCE_FACIAL_HAIR))
		var/facial_hair_styles[0]
		for(var/facial_hair_style in valid_facial_hairstyles)
			facial_hair_styles[++facial_hair_styles.len] = list("facialhairstyle" = facial_hair_style)
		data["facial_hair_styles"] = facial_hair_styles

	return data

/datum/tgui_module/appearance_changer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	generate_data(user, owner)

	data["name"] = owner.name
	data["specimen"] = owner.species.name
	data["gender"] = owner.gender
	data["gender_id"] = owner.identifying_gender
	data["change_race"] = can_change(owner, APPEARANCE_RACE)

	data["change_gender"] = can_change(owner, APPEARANCE_GENDER)
	if(data["change_gender"])
		var/genders[0]
		for(var/gender in get_genders(owner))
			genders[++genders.len] =  list("gender_name" = gender2text(gender), "gender_key" = gender)
		data["genders"] = genders
		var/id_genders[0]
		for(var/gender in all_genders_define_list)
			id_genders[++id_genders.len] =  list("gender_name" = gender2text(gender), "gender_key" = gender)
		data["id_genders"] = id_genders

	data["change_hair"] = can_change(owner, APPEARANCE_HAIR)
	if(data["change_hair"])
		data["hair_style"] = owner.h_style

		// VOREStation Add - Ears/Tails/Wings
		data["ear_style"] = owner.ear_style
		data["ear_secondary_style"] = owner.ear_secondary_style?.name
		data["tail_style"] = owner.tail_style
		data["wing_style"] = owner.wing_style
		var/list/markings_data[0]
		markings = owner.get_prioritised_markings()
		for (var/marking in markings)
			markings_data[++markings_data.len] = list("marking_name" = marking, "marking_color" = markings[marking]["color"] ? markings[marking]["color"] : "#000000") //too tired to add in another submenu for bodyparts here
		data["markings"] = markings_data
		// VOREStation Add End

	data["change_facial_hair"] = can_change(owner, APPEARANCE_FACIAL_HAIR)
	if(data["change_facial_hair"])
		data["facial_hair_style"] = owner.f_style

	data["change_skin_tone"] = can_change_skin_tone(owner)
	data["change_skin_color"] = can_change_skin_color(owner)
	if(data["change_skin_color"])
		data["skin_color"] = rgb(owner.r_skin, owner.g_skin, owner.b_skin)

	data["change_eye_color"] = can_change(owner, APPEARANCE_EYE_COLOR)
	if(data["change_eye_color"])
		data["eye_color"] = rgb(owner.r_eyes, owner.g_eyes, owner.b_eyes)

	data["change_hair_color"] = can_change(owner, APPEARANCE_HAIR_COLOR)
	if(data["change_hair_color"])
		data["hair_color"] = rgb(owner.r_hair, owner.g_hair, owner.b_hair)
		// VOREStation Add - Ears/Tails/Wings
		data["ears_color"] = rgb(owner.r_ears, owner.g_ears, owner.b_ears)
		data["ears2_color"] = rgb(owner.r_ears2, owner.g_ears2, owner.b_ears2)

		// secondary ear colors
		var/list/ear_secondary_color_channels = owner.ear_secondary_colors || list()
		ear_secondary_color_channels.len = owner.ear_secondary_style?.get_color_channel_count() || 0
		data["ear_secondary_colors"] = ear_secondary_color_channels

		data["tail_color"] = rgb(owner.r_tail, owner.g_tail, owner.b_tail)
		data["tail2_color"] = rgb(owner.r_tail2, owner.g_tail2, owner.b_tail2)
		data["tail3_color"] = rgb(owner.r_tail3, owner.g_tail3, owner.b_tail3)
		data["wing_color"] = rgb(owner.r_wing, owner.g_wing, owner.b_wing)
		data["wing2_color"] = rgb(owner.r_wing2, owner.g_wing2, owner.b_wing2)
		data["wing3_color"] = rgb(owner.r_wing3, owner.g_wing3, owner.b_wing3)
		// VOREStation Add End

	data["change_facial_hair_color"] = can_change(owner, APPEARANCE_FACIAL_HAIR_COLOR)
	if(data["change_facial_hair_color"])
		data["facial_hair_color"] = rgb(owner.r_facial, owner.g_facial, owner.b_facial)
	return data

/datum/tgui_module/appearance_changer/tgui_static_data(mob/user)
	var/list/data = ..()
	data["mapRef"] = map_name
	return data

/datum/tgui_module/appearance_changer/proc/update_active_camera_screen()
	cam_screen.vis_contents = list(owner) // Copied from the vore version.
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, 1, 1)
	local_skybox.cut_overlays()
	/*
	var/turf/newturf = get_turf(customize_usr ? tgui_host() : owner)
	if(newturf == last_camera_turf)
		return

	last_camera_turf = newturf

	var/list/visible_turfs = list()
	for(var/turf/T in range(1, newturf))
		visible_turfs += T

	cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, 3, 3)

	local_skybox.cut_overlays()
	local_skybox.add_overlay(SSskybox.get_skybox(get_z(newturf)))
	local_skybox.scale_to_view(3)
	local_skybox.set_position("CENTER", "CENTER", (world.maxx>>1) - newturf.x, (world.maxy>>1) - newturf.y)
	*/

/datum/tgui_module/appearance_changer/proc/update_dna(mob/living/carbon/human/target)
	if(target && (flags & APPEARANCE_UPDATE_DNA))
		target.update_dna()

/datum/tgui_module/appearance_changer/proc/can_change(mob/living/carbon/human/target, var/flag)
	return target && (flags & flag)

/datum/tgui_module/appearance_changer/proc/can_change_skin_tone(mob/living/carbon/human/target)
	return target && (flags & APPEARANCE_SKIN) &&target.species.appearance_flags & HAS_SKIN_TONE

/datum/tgui_module/appearance_changer/proc/can_change_skin_color(mob/living/carbon/human/target)
	return target && (flags & APPEARANCE_SKIN) && target.species.appearance_flags & HAS_SKIN_COLOR

/datum/tgui_module/appearance_changer/proc/cut_data()
	// Making the assumption that the available species remain constant
	valid_hairstyles.Cut()
	valid_facial_hairstyles.Cut()
	// VOREStation Add - Ears/Tails/Wings
	valid_earstyles.Cut()
	valid_tailstyles.Cut()
	valid_wingstyles.Cut()
	// VOREStation Add End

/datum/tgui_module/appearance_changer/proc/generate_data(mob/user, mob/living/carbon/human/target)
	if(!ishuman(target))
		return TRUE

	if(!LAZYLEN(valid_species))
		valid_species = target.generate_valid_species(check_whitelist, whitelist, blacklist)

	if(!LAZYLEN(valid_hairstyles) || !LAZYLEN(valid_facial_hairstyles))
		valid_hairstyles = target.generate_valid_hairstyles(check_gender = 0)
		valid_facial_hairstyles = target.generate_valid_facial_hairstyles()

	// VOREStation Add - Ears/Tails/Wings
	if(!LAZYLEN(valid_earstyles))
		for(var/path in ear_styles_list)
			var/datum/sprite_accessory/ears/instance = ear_styles_list[path]
			if(can_use_sprite(instance, target, user))
				valid_earstyles.Add(list(list(
					"name" = instance.name,
					"instance" = REF(instance),
					"color" = !!instance.do_colouration,
					"second_color" = !!instance.extra_overlay,
				)))

	if(!LAZYLEN(valid_tailstyles))
		for(var/path in tail_styles_list)
			var/datum/sprite_accessory/tail/instance = tail_styles_list[path]
			if(can_use_sprite(instance, target, user))
				valid_tailstyles.Add(list(list(
					"name" = instance.name,
					"instance" = REF(instance),
					"color" = !!instance.do_colouration,
					"second_color" = !!instance.extra_overlay,
				)))

	if(!LAZYLEN(valid_wingstyles))
		for(var/path in wing_styles_list)
			var/datum/sprite_accessory/wing/instance = wing_styles_list[path]
			if(can_use_sprite(instance, target, user))
				valid_wingstyles.Add(list(list(
					"name" = instance.name,
					"instance" = REF(instance),
					"color" = !!instance.do_colouration,
					"second_color" = !!instance.extra_overlay,
				)))
	// VOREStation Add End

/datum/tgui_module/appearance_changer/proc/get_genders(mob/living/carbon/human/target)
	var/datum/species/S = target.species
	var/list/possible_genders = S.genders
	if(!target.internal_organs_by_name["cell"])
		return possible_genders
	possible_genders = possible_genders.Copy()
	possible_genders |= NEUTER
	return possible_genders

// Used for subtypes to handle messaging or whatever.
/datum/tgui_module/appearance_changer/proc/changed_hook(flag)
	return

// VOREStation Add - Ears/Tails/Wings
/datum/tgui_module/appearance_changer/proc/can_use_sprite(datum/sprite_accessory/X, mob/living/carbon/human/target, mob/user)
	if(X.name == DEVELOPER_WARNING_NAME)
		return FALSE
	if(!isnull(X.species_allowed) && !(target.species.name in X.species_allowed) && (!istype(target.species, /datum/species/custom))) // Letting custom species access wings/ears/tails.
		return FALSE

	if(LAZYLEN(X.ckeys_allowed) && !(user?.ckey in X.ckeys_allowed) && !(target.ckey in X.ckeys_allowed))
		return FALSE

	return TRUE
// VOREStation Add End

/datum/tgui_module/appearance_changer/mirror
	name = "SalonPro Nano-Mirror&trade;"
	flags = APPEARANCE_ALL_HAIR
	customize_usr = TRUE

/datum/tgui_module/appearance_changer/mirror/coskit
	name = "SalonPro Porta-Makeover Deluxe&trade;"
