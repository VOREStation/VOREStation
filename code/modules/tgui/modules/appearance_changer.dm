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
	// Needed for moving camera support
	var/camera_diff_x = -1
	var/camera_diff_y = -1
	var/camera_diff_z = -1

/datum/tgui_module/appearance_changer/New(
		var/host,
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
	
	cam_plane_masters = get_plane_masters()

	for(var/plane in cam_plane_masters)
		var/obj/screen/instance = plane
		instance.assigned_map = map_name
		instance.del_on_map_removal = FALSE
		instance.screen_loc = "[map_name]:CENTER"

	local_skybox = new()
	local_skybox.assigned_map = map_name
	local_skybox.del_on_map_removal = FALSE
	local_skybox.screen_loc = "[map_name]:CENTER,CENTER"
	cam_plane_masters += local_skybox

	cam_background = new
	cam_background.assigned_map = map_name
	cam_background.del_on_map_removal = FALSE
	reload_cameraview()

	owner = H
	check_whitelist = check_species_whitelist
	whitelist = species_whitelist
	blacklist = species_blacklist

/datum/tgui_module/appearance_changer/Destroy()
	qdel(cam_screen)
	QDEL_LIST(cam_plane_masters)
	qdel(cam_background)
	return ..()

/datum/tgui_module/appearance_changer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	var/mob/living/carbon/human/target = owner
	if(customize_usr)
		if(!ishuman(usr))
			return TRUE
		target = usr

	switch(action)
		if("race")
			if(can_change(APPEARANCE_RACE) && (params["race"] in valid_species))
				if(target.change_species(params["race"]))
					cut_and_generate_data()
					return 1
		if("gender")
			if(can_change(APPEARANCE_GENDER) && (params["gender"] in get_genders()))
				if(target.change_gender(params["gender"]))
					cut_and_generate_data()
					return 1
		if("gender_id")
			if(can_change(APPEARANCE_GENDER) && (params["gender_id"] in all_genders_define_list))
				target.identifying_gender = params["gender_id"]
				return 1
		if("skin_tone")
			if(can_change_skin_tone())
				var/new_s_tone = input(usr, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Skin Tone", -target.s_tone + 35) as num|null
				if(isnum(new_s_tone) && can_still_topic(usr, state))
					new_s_tone = 35 - max(min( round(new_s_tone), 220),1)
					return target.change_skin_tone(new_s_tone)
		if("skin_color")
			if(can_change_skin_color())
				var/new_skin = input(usr, "Choose your character's skin colour: ", "Skin Color", rgb(target.r_skin, target.g_skin, target.b_skin)) as color|null
				if(new_skin && can_still_topic(usr, state))
					var/r_skin = hex2num(copytext(new_skin, 2, 4))
					var/g_skin = hex2num(copytext(new_skin, 4, 6))
					var/b_skin = hex2num(copytext(new_skin, 6, 8))
					if(target.change_skin_color(r_skin, g_skin, b_skin))
						update_dna()
						return 1
		if("hair")
			if(can_change(APPEARANCE_HAIR) && (params["hair"] in valid_hairstyles))
				if(target.change_hair(params["hair"]))
					update_dna()
					return 1
		if("hair_color")
			if(can_change(APPEARANCE_HAIR_COLOR))
				var/new_hair = input("Please select hair color.", "Hair Color", rgb(target.r_hair, target.g_hair, target.b_hair)) as color|null
				if(new_hair && can_still_topic(usr, state))
					var/r_hair = hex2num(copytext(new_hair, 2, 4))
					var/g_hair = hex2num(copytext(new_hair, 4, 6))
					var/b_hair = hex2num(copytext(new_hair, 6, 8))
					if(target.change_hair_color(r_hair, g_hair, b_hair))
						update_dna()
						return 1
		if("facial_hair")
			if(can_change(APPEARANCE_FACIAL_HAIR) && (params["facial_hair"] in valid_facial_hairstyles))
				if(target.change_facial_hair(params["facial_hair"]))
					update_dna()
					return 1
		if("facial_hair_color")
			if(can_change(APPEARANCE_FACIAL_HAIR_COLOR))
				var/new_facial = input("Please select facial hair color.", "Facial Hair Color", rgb(target.r_facial, target.g_facial, target.b_facial)) as color|null
				if(new_facial && can_still_topic(usr, state))
					var/r_facial = hex2num(copytext(new_facial, 2, 4))
					var/g_facial = hex2num(copytext(new_facial, 4, 6))
					var/b_facial = hex2num(copytext(new_facial, 6, 8))
					if(target.change_facial_hair_color(r_facial, g_facial, b_facial))
						update_dna()
						return 1
		if("eye_color")
			if(can_change(APPEARANCE_EYE_COLOR))
				var/new_eyes = input("Please select eye color.", "Eye Color", rgb(target.r_eyes, target.g_eyes, target.b_eyes)) as color|null
				if(new_eyes && can_still_topic(usr, state))
					var/r_eyes = hex2num(copytext(new_eyes, 2, 4))
					var/g_eyes = hex2num(copytext(new_eyes, 4, 6))
					var/b_eyes = hex2num(copytext(new_eyes, 6, 8))
					if(target.change_eye_color(r_eyes, g_eyes, b_eyes))
						update_dna()
						return 1
	return FALSE

/datum/tgui_module/appearance_changer/tgui_interact(mob/user, datum/tgui/ui = null, datum/tgui/parent_ui = null, datum/tgui_state/custom_state = GLOB.tgui_default_state)
	var/mob/living/carbon/human/target = owner
	if(customize_usr)
		if(!ishuman(user))
			return TRUE
		target = user
	
	if(!target || !target.species)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		reload_cameraview()
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

/datum/tgui_module/appearance_changer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	generate_data(check_whitelist, whitelist, blacklist)
	differential_check()

	var/mob/living/carbon/human/target = owner
	if(customize_usr)
		if(!ishuman(usr))
			return TRUE
		target = usr

	data["name"] = target.name
	data["specimen"] = target.species.name
	data["gender"] = target.gender
	data["gender_id"] = target.identifying_gender
	data["change_race"] = can_change(APPEARANCE_RACE)
	if(data["change_race"])
		var/species[0]
		for(var/specimen in valid_species)
			species[++species.len] =  list("specimen" = specimen)
		data["species"] = species

	data["change_gender"] = can_change(APPEARANCE_GENDER)
	if(data["change_gender"])
		var/genders[0]
		for(var/gender in get_genders())
			genders[++genders.len] =  list("gender_name" = gender2text(gender), "gender_key" = gender)
		data["genders"] = genders
		var/id_genders[0]
		for(var/gender in all_genders_define_list)
			id_genders[++id_genders.len] =  list("gender_name" = gender2text(gender), "gender_key" = gender)
		data["id_genders"] = id_genders

	data["change_hair"] = can_change(APPEARANCE_HAIR)
	if(data["change_hair"])
		var/hair_styles[0]
		for(var/hair_style in valid_hairstyles)
			hair_styles[++hair_styles.len] = list("hairstyle" = hair_style)
		data["hair_styles"] = hair_styles
		data["hair_style"] = target.h_style

	data["change_facial_hair"] = can_change(APPEARANCE_FACIAL_HAIR)
	if(data["change_facial_hair"])
		var/facial_hair_styles[0]
		for(var/facial_hair_style in valid_facial_hairstyles)
			facial_hair_styles[++facial_hair_styles.len] = list("facialhairstyle" = facial_hair_style)
		data["facial_hair_styles"] = facial_hair_styles
		data["facial_hair_style"] = target.f_style

	data["change_skin_tone"] = can_change_skin_tone()
	data["change_skin_color"] = can_change_skin_color()
	if(data["change_skin_color"])
		data["skin_color"] = rgb(target.r_skin, target.g_skin, target.b_skin)
	data["change_eye_color"] = can_change(APPEARANCE_EYE_COLOR)
	if(data["change_eye_color"])
		data["eye_color"] = rgb(target.r_eyes, target.g_eyes, target.b_eyes)
	data["change_hair_color"] = can_change(APPEARANCE_HAIR_COLOR)
	if(data["change_hair_color"])
		data["hair_color"] = rgb(target.r_hair, target.g_hair, target.b_hair)
	data["change_facial_hair_color"] = can_change(APPEARANCE_FACIAL_HAIR_COLOR)
	if(data["change_facial_hair_color"])
		data["facial_hair_color"] = rgb(target.r_facial, target.g_facial, target.b_facial)
	return data

/datum/tgui_module/appearance_changer/tgui_static_data(mob/user)
	var/list/data = ..()
	data["mapRef"] = map_name
	return data

/datum/tgui_module/appearance_changer/proc/differential_check()
	var/turf/T = get_turf(customize_usr ? tgui_host() : owner)
	if(T)
		var/new_x = T.x
		var/new_y = T.y
		var/new_z = T.z
		if((new_x != camera_diff_x) || (new_y != camera_diff_y) || (new_z != camera_diff_z))
			reload_cameraview()

/datum/tgui_module/appearance_changer/proc/reload_cameraview()
	var/turf/camTurf = get_turf(customize_usr ? tgui_host() : owner)
	if(!camTurf)
		return

	camera_diff_x = camTurf.x
	camera_diff_y = camTurf.y
	camera_diff_z = camTurf.z

	var/list/visible_turfs = list()
	for(var/turf/T in range(1, camTurf))
		visible_turfs += T

	cam_screen.vis_contents = visible_turfs
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, 3, 3)

	local_skybox.cut_overlays()
	local_skybox.add_overlay(SSskybox.get_skybox(get_z(camTurf)))
	local_skybox.scale_to_view(3)
	local_skybox.set_position("CENTER", "CENTER", (world.maxx>>1) - camTurf.x, (world.maxy>>1) - camTurf.y)

/datum/tgui_module/appearance_changer/proc/update_dna()
	var/mob/living/carbon/human/target = owner
	if(customize_usr)
		if(!ishuman(usr))
			return TRUE
		target = usr

	if(target && (flags & APPEARANCE_UPDATE_DNA))
		target.update_dna()

/datum/tgui_module/appearance_changer/proc/can_change(var/flag)
	var/mob/living/carbon/human/target = owner
	if(customize_usr)
		if(!ishuman(usr))
			return TRUE
		target = usr

	return target && (flags & flag)

/datum/tgui_module/appearance_changer/proc/can_change_skin_tone()
	var/mob/living/carbon/human/target = owner
	if(customize_usr)
		if(!ishuman(usr))
			return TRUE
		target = usr

	return target && (flags & APPEARANCE_SKIN) && target.species.appearance_flags & HAS_SKIN_TONE

/datum/tgui_module/appearance_changer/proc/can_change_skin_color()
	var/mob/living/carbon/human/target = owner
	if(customize_usr)
		if(!ishuman(usr))
			return TRUE
		target = usr

	return target && (flags & APPEARANCE_SKIN) && target.species.appearance_flags & HAS_SKIN_COLOR

/datum/tgui_module/appearance_changer/proc/cut_and_generate_data()
	// Making the assumption that the available species remain constant
	valid_facial_hairstyles.Cut()
	valid_facial_hairstyles.Cut()
	generate_data()

/datum/tgui_module/appearance_changer/proc/generate_data()
	var/mob/living/carbon/human/target = owner
	if(customize_usr)
		if(!ishuman(usr))
			return TRUE
		target = usr
	if(!target)
		return
	if(!valid_species.len)
		valid_species = target.generate_valid_species(check_whitelist, whitelist, blacklist)
	if(!valid_hairstyles.len || !valid_facial_hairstyles.len)
		valid_hairstyles = target.generate_valid_hairstyles(check_gender = 0)
		valid_facial_hairstyles = target.generate_valid_facial_hairstyles()

/datum/tgui_module/appearance_changer/proc/get_genders()
	var/mob/living/carbon/human/target = owner
	if(customize_usr)
		if(!ishuman(usr))
			return TRUE
		target = usr
	var/datum/species/S = target.species
	var/list/possible_genders = S.genders
	if(!target.internal_organs_by_name["cell"])
		return possible_genders
	possible_genders = possible_genders.Copy()
	possible_genders |= NEUTER
	return possible_genders

/datum/tgui_module/appearance_changer/mirror
	name = "SalonPro Nano-Mirror&trade;"
	flags = APPEARANCE_ALL_HAIR
	customize_usr = TRUE

/datum/tgui_module/appearance_changer/mirror/coskit
	name = "SalonPro Porta-Makeover Deluxe&trade;"