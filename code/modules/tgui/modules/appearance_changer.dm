
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
<<<<<<< HEAD
=======

	cam_plane_masters = get_plane_masters()
>>>>>>> 7aa6f14ab0c... Merge pull request #8688 from MistakeNot4892/doggo

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

	cam_background = new
	cam_background.assigned_map = map_name
	cam_background.del_on_map_removal = FALSE
	update_active_camera_screen()

	owner = H
	if(owner)
		GLOB.moved_event.register(owner, src, .proc/update_active_camera_screen)
	check_whitelist = check_species_whitelist
	whitelist = species_whitelist
	blacklist = species_blacklist

/datum/tgui_module/appearance_changer/Destroy()
	GLOB.moved_event.unregister(owner, src, .proc/update_active_camera_screen)
	last_camera_turf = null
	qdel(cam_screen)
	QDEL_LIST(cam_plane_masters)
	qdel(cam_background)
	cut_data()
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
					if(params["race"] == "Custom Species")
						target.custom_species = sanitize(tgui_input_text(usr, "Input custom species name:",
							"Custom Species Name", null, MAX_NAME_LEN), MAX_NAME_LEN)
					cut_data()
					generate_data(usr)
					changed_hook(APPEARANCECHANGER_CHANGED_RACE)
					return 1
		if("gender")
			if(can_change(APPEARANCE_GENDER) && (params["gender"] in get_genders()))
				if(target.change_gender(params["gender"]))
					cut_data()
					generate_data(usr)
					changed_hook(APPEARANCECHANGER_CHANGED_GENDER)
					return 1
		if("gender_id")
			if(can_change(APPEARANCE_GENDER) && (params["gender_id"] in all_genders_define_list))
				target.identifying_gender = params["gender_id"]
				changed_hook(APPEARANCECHANGER_CHANGED_GENDER_ID)
				return 1
		if("skin_tone")
			if(can_change_skin_tone())
				var/new_s_tone = tgui_input_number(usr, "Choose your character's skin-tone:\n(Light 1 - 220 Dark)", "Skin Tone", -target.s_tone + 35, 220, 1)
				if(isnum(new_s_tone) && can_still_topic(usr, state))
					new_s_tone = 35 - max(min( round(new_s_tone), 220),1)
					changed_hook(APPEARANCECHANGER_CHANGED_SKINTONE)
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
						changed_hook(APPEARANCECHANGER_CHANGED_SKINCOLOR)
						return 1
		if("hair")
			if(can_change(APPEARANCE_HAIR) && (params["hair"] in valid_hairstyles))
				if(target.change_hair(params["hair"]))
					update_dna()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRSTYLE)
					return 1
		if("hair_color")
			if(can_change(APPEARANCE_HAIR_COLOR))
				var/new_hair = input(usr, "Please select hair color.", "Hair Color", rgb(target.r_hair, target.g_hair, target.b_hair)) as color|null
				if(new_hair && can_still_topic(usr, state))
					var/r_hair = hex2num(copytext(new_hair, 2, 4))
					var/g_hair = hex2num(copytext(new_hair, 4, 6))
					var/b_hair = hex2num(copytext(new_hair, 6, 8))
					if(target.change_hair_color(r_hair, g_hair, b_hair))
						update_dna()
						changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
						return 1
		if("facial_hair")
			if(can_change(APPEARANCE_FACIAL_HAIR) && (params["facial_hair"] in valid_facial_hairstyles))
				if(target.change_facial_hair(params["facial_hair"]))
					update_dna()
					changed_hook(APPEARANCECHANGER_CHANGED_F_HAIRSTYLE)
					return 1
		if("facial_hair_color")
			if(can_change(APPEARANCE_FACIAL_HAIR_COLOR))
				var/new_facial = input(usr, "Please select facial hair color.", "Facial Hair Color", rgb(target.r_facial, target.g_facial, target.b_facial)) as color|null
				if(new_facial && can_still_topic(usr, state))
					var/r_facial = hex2num(copytext(new_facial, 2, 4))
					var/g_facial = hex2num(copytext(new_facial, 4, 6))
					var/b_facial = hex2num(copytext(new_facial, 6, 8))
					if(target.change_facial_hair_color(r_facial, g_facial, b_facial))
						update_dna()
						changed_hook(APPEARANCECHANGER_CHANGED_F_HAIRCOLOR)
						return 1
		if("eye_color")
			if(can_change(APPEARANCE_EYE_COLOR))
				var/new_eyes = input(usr, "Please select eye color.", "Eye Color", rgb(target.r_eyes, target.g_eyes, target.b_eyes)) as color|null
				if(new_eyes && can_still_topic(usr, state))
					var/r_eyes = hex2num(copytext(new_eyes, 2, 4))
					var/g_eyes = hex2num(copytext(new_eyes, 4, 6))
					var/b_eyes = hex2num(copytext(new_eyes, 6, 8))
					if(target.change_eye_color(r_eyes, g_eyes, b_eyes))
						update_dna()
						changed_hook(APPEARANCECHANGER_CHANGED_EYES)
						return 1
		// VOREStation Add - Ears/Tails/Wings
		if("ear")
			if(can_change(APPEARANCE_ALL_HAIR))
				var/datum/sprite_accessory/ears/instance = locate(params["ref"])
				if(params["clear"])
					instance = null
				if(!istype(instance) && !params["clear"])
					return FALSE
				owner.ear_style = instance
				owner.update_hair()
				update_dna()
				changed_hook(APPEARANCECHANGER_CHANGED_HAIRSTYLE)
				return TRUE
		if("ears_color")
			if(can_change(APPEARANCE_HAIR_COLOR))
				var/new_hair = input(usr, "Please select ear color.", "Ear Color", rgb(target.r_ears, target.g_ears, target.b_ears)) as color|null
				if(new_hair && can_still_topic(usr, state))
					target.r_ears = hex2num(copytext(new_hair, 2, 4))
					target.g_ears = hex2num(copytext(new_hair, 4, 6))
					target.b_ears = hex2num(copytext(new_hair, 6, 8))
					update_dna()
					owner.update_hair()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("ears2_color")
			if(can_change(APPEARANCE_HAIR_COLOR))
				var/new_hair = input(usr, "Please select secondary ear color.", "2nd Ear Color", rgb(target.r_ears2, target.g_ears2, target.b_ears2)) as color|null
				if(new_hair && can_still_topic(usr, state))
					target.r_ears2 = hex2num(copytext(new_hair, 2, 4))
					target.g_ears2 = hex2num(copytext(new_hair, 4, 6))
					target.b_ears2 = hex2num(copytext(new_hair, 6, 8))
					update_dna()
					owner.update_hair()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("tail")
			if(can_change(APPEARANCE_ALL_HAIR))
				var/datum/sprite_accessory/tail/instance = locate(params["ref"])
				if(params["clear"])
					instance = null
				if(!istype(instance) && !params["clear"])
					return FALSE
				owner.tail_style = instance
				owner.update_tail_showing()
				update_dna()
				changed_hook(APPEARANCECHANGER_CHANGED_HAIRSTYLE)
				return TRUE
		if("tail_color")
			if(can_change(APPEARANCE_HAIR_COLOR))
				var/new_hair = input(usr, "Please select tail color.", "Tail Color", rgb(target.r_tail, target.g_tail, target.b_tail)) as color|null
				if(new_hair && can_still_topic(usr, state))
					target.r_tail = hex2num(copytext(new_hair, 2, 4))
					target.g_tail = hex2num(copytext(new_hair, 4, 6))
					target.b_tail = hex2num(copytext(new_hair, 6, 8))
					update_dna()
					owner.update_tail_showing()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("tail2_color")
			if(can_change(APPEARANCE_HAIR_COLOR))
				var/new_hair = input(usr, "Please select secondary tail color.", "2nd Tail Color", rgb(target.r_tail2, target.g_tail2, target.b_tail2)) as color|null
				if(new_hair && can_still_topic(usr, state))
					target.r_tail2 = hex2num(copytext(new_hair, 2, 4))
					target.g_tail2 = hex2num(copytext(new_hair, 4, 6))
					target.b_tail2 = hex2num(copytext(new_hair, 6, 8))
					update_dna()
					owner.update_tail_showing()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("wing")
			if(can_change(APPEARANCE_ALL_HAIR))
				var/datum/sprite_accessory/wing/instance = locate(params["ref"])
				if(params["clear"])
					instance = null
				if(!istype(instance) && !params["clear"])
					return FALSE
				owner.wing_style = instance
				owner.update_wing_showing()
				update_dna()
				changed_hook(APPEARANCECHANGER_CHANGED_HAIRSTYLE)
				return TRUE
		if("wing_color")
			if(can_change(APPEARANCE_HAIR_COLOR))
				var/new_hair = input(usr, "Please select wing color.", "Wing Color", rgb(target.r_wing, target.g_wing, target.b_wing)) as color|null
				if(new_hair && can_still_topic(usr, state))
					target.r_wing = hex2num(copytext(new_hair, 2, 4))
					target.g_wing = hex2num(copytext(new_hair, 4, 6))
					target.b_wing = hex2num(copytext(new_hair, 6, 8))
					update_dna()
					owner.update_wing_showing()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("wing2_color")
			if(can_change(APPEARANCE_HAIR_COLOR))
				var/new_hair = input(usr, "Please select secondary wing color.", "2nd Wing Color", rgb(target.r_wing2, target.g_wing2, target.b_wing2)) as color|null
				if(new_hair && can_still_topic(usr, state))
					target.r_wing2 = hex2num(copytext(new_hair, 2, 4))
					target.g_wing2 = hex2num(copytext(new_hair, 4, 6))
					target.b_wing2 = hex2num(copytext(new_hair, 6, 8))
					update_dna()
					owner.update_wing_showing()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		// VOREStation Add End
	return FALSE

/datum/tgui_module/appearance_changer/tgui_interact(mob/user, datum/tgui/ui = null, datum/tgui/parent_ui = null, datum/tgui_state/custom_state)
	var/mob/living/carbon/human/target = owner
	if(customize_usr)
		if(!ishuman(user))
			return TRUE
		target = user

	if(!target || !target.species)
		return

	ui = SStgui.try_update_ui(user, src, ui)
	update_active_camera_screen()
	if(!ui)
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

/datum/tgui_module/appearance_changer/tgui_static_data(mob/user)
	var/list/data = ..()

	generate_data(usr)

	if(can_change(APPEARANCE_RACE))
		var/species[0]
		for(var/specimen in valid_species)
			species[++species.len] =  list("specimen" = specimen)
		data["species"] = species

	if(can_change(APPEARANCE_HAIR))
		var/hair_styles[0]
		for(var/hair_style in valid_hairstyles)
			hair_styles[++hair_styles.len] = list("hairstyle" = hair_style)
		data["hair_styles"] = hair_styles
		// VOREStation Add - Ears/Tails/Wings
		data["ear_styles"] = valid_earstyles
		data["tail_styles"] = valid_tailstyles
		data["wing_styles"] = valid_wingstyles
		// VOREStation Add End

	if(can_change(APPEARANCE_FACIAL_HAIR))
		var/facial_hair_styles[0]
		for(var/facial_hair_style in valid_facial_hairstyles)
			facial_hair_styles[++facial_hair_styles.len] = list("facialhairstyle" = facial_hair_style)
		data["facial_hair_styles"] = facial_hair_styles

	return data

/datum/tgui_module/appearance_changer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	generate_data(user)

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
		data["hair_style"] = target.h_style

		// VOREStation Add - Ears/Tails/Wings
		data["ear_style"] = target.ear_style
		data["tail_style"] = target.tail_style
		data["wing_style"] = target.wing_style
		// VOREStation Add End

	data["change_facial_hair"] = can_change(APPEARANCE_FACIAL_HAIR)
	if(data["change_facial_hair"])
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
		// VOREStation Add - Ears/Tails/Wings
		data["ears_color"] = rgb(target.r_ears, target.g_ears, target.b_ears)
		data["ears2_color"] = rgb(target.r_ears2, target.g_ears2, target.b_ears2)
		data["tail_color"] = rgb(target.r_tail, target.g_tail, target.b_tail)
		data["tail2_color"] = rgb(target.r_tail2, target.g_tail2, target.b_tail2)
		data["wing_color"] = rgb(target.r_wing, target.g_wing, target.b_wing)
		data["wing2_color"] = rgb(target.r_wing2, target.g_wing2, target.b_wing2)
		// VOREStation Add End

	data["change_facial_hair_color"] = can_change(APPEARANCE_FACIAL_HAIR_COLOR)
	if(data["change_facial_hair_color"])
		data["facial_hair_color"] = rgb(target.r_facial, target.g_facial, target.b_facial)
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

/datum/tgui_module/appearance_changer/proc/cut_data()
	// Making the assumption that the available species remain constant
	valid_hairstyles.Cut()
	valid_facial_hairstyles.Cut()
	// VOREStation Add - Ears/Tails/Wings
	valid_earstyles.Cut()
	valid_tailstyles.Cut()
	valid_wingstyles.Cut()
	// VOREStation Add End

/datum/tgui_module/appearance_changer/proc/generate_data(mob/user)
	var/mob/living/carbon/human/target = owner
	if(customize_usr)
		if(!ishuman(user))
			return TRUE
		target = user
	if(!target)
		return

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

// Used for subtypes to handle messaging or whatever.
/datum/tgui_module/appearance_changer/proc/changed_hook(flag)
	return

// VOREStation Add - Ears/Tails/Wings
/datum/tgui_module/appearance_changer/proc/can_use_sprite(datum/sprite_accessory/X, mob/living/carbon/human/target, mob/user)
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
