// *******************************************************
// Unified body transformation UI for inround TF or bodyrecord editing.
// Make a new subtype of this, and configure it for whatever changes
// that you will be allowing on the objects. This is a tgui UI and can
// be attached to any object.
//
// USE THIS instead of recoding tf/appearance editing for the forth time
// in this codebase. It should all be in one place, and extended for every
// new feature added to cosmetics. Be sure to update bodyrecords and their
// cloning/to/from mob procs as well.
//
// owner is the mob being transformed, ui.user is the mob using the interface
// if owner and user are the same, there is some special logic for self-tf.
// use can_change(owner, APPEARANCE_X) to validate if the owner is still in a
// valid state for the module to edit them.
// *******************************************************

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
	var/list/valid_gradstyles = list()
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
	if(owner == user || !customize_usr)
		close_ui()
		UnregisterSignal(owner, COMSIG_OBSERVER_MOVED)
		owner = null
		last_camera_turf = null
		cut_data()

/datum/tgui_module/appearance_changer/Destroy()
	qdel(cam_screen)
	QDEL_LIST(cam_plane_masters)
	qdel(cam_background)
	return ..()

/datum/tgui_module/appearance_changer/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	var/obj/machinery/computer/transhuman/designer/DC = null
	var/datum/tgui_module/appearance_changer/body_designer/BD = null
	if(istype(src,/datum/tgui_module/appearance_changer/body_designer))
		BD = src
		DC = BD.linked_body_design_console?.resolve()

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
				if(isnum(new_s_tone) && can_still_topic(ui.user, state))
					new_s_tone = 35 - max(min( round(new_s_tone), 220),1)
					changed_hook(APPEARANCECHANGER_CHANGED_SKINTONE)
					return owner.change_skin_tone(new_s_tone)
		if("skin_color")
			if(can_change_skin_color(owner))
				var/new_skin = tgui_color_picker(ui.user, "Choose your character's skin colour: ", "Skin Color", rgb(owner.r_skin, owner.g_skin, owner.b_skin))
				if(new_skin && can_still_topic(ui.user, state))
					var/r_skin = hex2num(copytext(new_skin, 2, 4))
					var/g_skin = hex2num(copytext(new_skin, 4, 6))
					var/b_skin = hex2num(copytext(new_skin, 6, 8))
					if(owner.change_skin_color(r_skin, g_skin, b_skin))
						update_dna(owner)
						changed_hook(APPEARANCECHANGER_CHANGED_SKINCOLOR)
						return 1
		if("hair")
			if(can_change(owner, APPEARANCE_HAIR) && (params["name"] in valid_hairstyles))
				if(owner.change_hair(params["name"]))
					update_dna(owner)
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRSTYLE)
					return 1
		if("hair_grad")
			var/picked = params["picked"]
			if(picked && can_change(owner, APPEARANCE_HAIR_COLOR))
				owner.grad_style = picked[1] // returned as a list
				update_dna(owner)
				owner.regenerate_icons()
				changed_hook(APPEARANCECHANGER_CHANGED_HAIRSTYLE)
				return 1
		if("hair_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = tgui_color_picker(ui.user, "Please select hair color.", "Hair Color", rgb(owner.r_hair, owner.g_hair, owner.b_hair))
				if(new_hair && can_still_topic(ui.user, state))
					var/r_hair = hex2num(copytext(new_hair, 2, 4))
					var/g_hair = hex2num(copytext(new_hair, 4, 6))
					var/b_hair = hex2num(copytext(new_hair, 6, 8))
					if(owner.change_hair_color(r_hair, g_hair, b_hair))
						update_dna(owner)
						changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
						return 1
		if("hair_color_grad")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_grad = tgui_color_picker(ui.user, "Please select hair gradiant color.", "Hair Color", rgb(owner.r_grad, owner.g_grad, owner.b_grad))
				if(new_grad && can_still_topic(ui.user, state))
					var/r_grad = hex2num(copytext(new_grad, 2, 4))
					var/g_grad = hex2num(copytext(new_grad, 4, 6))
					var/b_grad = hex2num(copytext(new_grad, 6, 8))
					if(owner.change_grad_color(r_grad, g_grad, b_grad))
						update_dna(owner)
						changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
						return 1
		if("facial_hair")
			if(can_change(owner, APPEARANCE_FACIAL_HAIR) && (params["name"] in valid_facial_hairstyles))
				if(owner.change_facial_hair(params["name"]))
					update_dna(owner)
					changed_hook(APPEARANCECHANGER_CHANGED_F_HAIRSTYLE)
					return 1
		if("facial_hair_color")
			if(can_change(owner, APPEARANCE_FACIAL_HAIR_COLOR))
				var/new_facial = tgui_color_picker(ui.user, "Please select facial hair color.", "Facial Hair Color", rgb(owner.r_facial, owner.g_facial, owner.b_facial))
				if(new_facial && can_still_topic(ui.user, state))
					var/r_facial = hex2num(copytext(new_facial, 2, 4))
					var/g_facial = hex2num(copytext(new_facial, 4, 6))
					var/b_facial = hex2num(copytext(new_facial, 6, 8))
					if(owner.change_facial_hair_color(r_facial, g_facial, b_facial))
						update_dna(owner)
						changed_hook(APPEARANCECHANGER_CHANGED_F_HAIRCOLOR)
						return 1
		if("eye_color")
			if(can_change(owner, APPEARANCE_EYE_COLOR))
				var/new_eyes = tgui_color_picker(ui.user, "Please select eye color.", "Eye Color", rgb(owner.r_eyes, owner.g_eyes, owner.b_eyes))
				if(new_eyes && can_still_topic(ui.user, state))
					var/r_eyes = hex2num(copytext(new_eyes, 2, 4))
					var/g_eyes = hex2num(copytext(new_eyes, 4, 6))
					var/b_eyes = hex2num(copytext(new_eyes, 6, 8))
					if(owner.change_eye_color(r_eyes, g_eyes, b_eyes))
						update_dna(owner)
						changed_hook(APPEARANCECHANGER_CHANGED_EYES)
						return 1
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
				var/new_hair = tgui_color_picker(ui.user, "Please select ear color.", "Ear Color", rgb(owner.r_ears, owner.g_ears, owner.b_ears))
				if(new_hair && can_still_topic(ui.user, state))
					owner.r_ears = hex2num(copytext(new_hair, 2, 4))
					owner.g_ears = hex2num(copytext(new_hair, 4, 6))
					owner.b_ears = hex2num(copytext(new_hair, 6, 8))
					update_dna(owner)
					owner.update_hair()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("ears2_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = tgui_color_picker(ui.user, "Please select secondary ear color.", "2nd Ear Color", rgb(owner.r_ears2, owner.g_ears2, owner.b_ears2))
				if(new_hair && can_still_topic(ui.user, state))
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
				var/new_color = tgui_color_picker(ui.user, "Please select ear color.", "2nd Ear Color", existing)
				if(new_color && can_still_topic(ui.user, state))
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
				var/new_hair = tgui_color_picker(ui.user, "Please select tail color.", "Tail Color", rgb(owner.r_tail, owner.g_tail, owner.b_tail))
				if(new_hair && can_still_topic(ui.user, state))
					owner.r_tail = hex2num(copytext(new_hair, 2, 4))
					owner.g_tail = hex2num(copytext(new_hair, 4, 6))
					owner.b_tail = hex2num(copytext(new_hair, 6, 8))
					update_dna(owner)
					owner.update_tail_showing()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("tail2_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = tgui_color_picker(ui.user, "Please select secondary tail color.", "2nd Tail Color", rgb(owner.r_tail2, owner.g_tail2, owner.b_tail2))
				if(new_hair && can_still_topic(ui.user, state))
					owner.r_tail2 = hex2num(copytext(new_hair, 2, 4))
					owner.g_tail2 = hex2num(copytext(new_hair, 4, 6))
					owner.b_tail2 = hex2num(copytext(new_hair, 6, 8))
					update_dna(owner)
					owner.update_tail_showing()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("tail3_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = tgui_color_picker(ui.user, "Please select tertiary tail color.", "3rd Tail Color", rgb(owner.r_tail3, owner.g_tail3, owner.b_tail3))
				if(new_hair && can_still_topic(ui.user, state))
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
				var/new_hair = tgui_color_picker(ui.user, "Please select wing color.", "Wing Color", rgb(owner.r_wing, owner.g_wing, owner.b_wing))
				if(new_hair && can_still_topic(ui.user, state))
					owner.r_wing = hex2num(copytext(new_hair, 2, 4))
					owner.g_wing = hex2num(copytext(new_hair, 4, 6))
					owner.b_wing = hex2num(copytext(new_hair, 6, 8))
					update_dna(owner)
					owner.update_wing_showing()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("wing2_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = tgui_color_picker(ui.user, "Please select secondary wing color.", "2nd Wing Color", rgb(owner.r_wing2, owner.g_wing2, owner.b_wing2))
				if(new_hair && can_still_topic(ui.user, state))
					owner.r_wing2 = hex2num(copytext(new_hair, 2, 4))
					owner.g_wing2 = hex2num(copytext(new_hair, 4, 6))
					owner.b_wing2 = hex2num(copytext(new_hair, 6, 8))
					update_dna(owner)
					owner.update_wing_showing()
					changed_hook(APPEARANCECHANGER_CHANGED_HAIRCOLOR)
					return 1
		if("wing3_color")
			if(can_change(owner, APPEARANCE_HAIR_COLOR))
				var/new_hair = tgui_color_picker(ui.user, "Please select tertiary wing color.", "3rd Wing Color", rgb(owner.r_wing3, owner.g_wing3, owner.b_wing3))
				if(new_hair && can_still_topic(ui.user, state))
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
						if(name_marking && can_still_topic(ui.user, state))
							var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[name_marking]
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
						var/current = markings[name_marking] ? markings[name_marking]["color"] : "#000000"
						var/marking_color = tgui_color_picker(ui.user, "Please select marking color", "Marking color", current)
						if(marking_color && can_still_topic(ui.user, state))
							var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[name_marking]
							if (owner.change_marking_color(mark_datum, marking_color))
								return TRUE
		if("rotate_view")
			if(can_change(owner, APPEARANCE_RACE))
				owner.set_dir(turn(owner.dir, 90))
				return TRUE
		if("rename")
			if(owner)
				var/raw_name = tgui_input_text(ui.user, "Choose the a name:", "Sleeve Name")
				if(!isnull(raw_name) && can_change(owner, APPEARANCE_RACE))
					var/new_name = sanitize_name(raw_name, owner.species, FALSE) // can't edit synths
					if(new_name)
						owner.dna.real_name = new_name
						owner.real_name = new_name
						owner.name = new_name
						return TRUE
					else
						to_chat(ui.user, span_warning("Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and ."))
						return TRUE
		if("char_name")
			if(DC) // Only body designer does this. no hrefing
				var/new_name = sanitize(tgui_input_text(ui.user, "Input character's name:", "Name", owner.name, MAX_NAME_LEN), MAX_NAME_LEN)
				if(can_change(owner, APPEARANCE_RACE)) // new name can be empty, it uses base species if so
					owner.name = new_name
					owner.real_name = owner.name
					owner.dna.real_name = owner.name
					return TRUE
		if("race_name")
			var/new_name = sanitize(tgui_input_text(ui.user, "Input custom species name:", "Custom Species Name", owner.custom_species, MAX_NAME_LEN), MAX_NAME_LEN)
			if(can_change(owner, APPEARANCE_RACE)) // new name can be empty, it uses base species if so
				owner.custom_species = new_name
				return TRUE
		if("base_icon")
			if(owner.species.selects_bodytype == SELECTS_BODYTYPE_FALSE)
				var/datum/species/S = GLOB.all_species[owner.species.name]
				owner.species.base_species = S.base_species // Return to original form
				generate_data(ui.user, owner)
				changed_hook(APPEARANCECHANGER_CHANGED_RACE)
				return TRUE
			var/list/choices
			var/datum/species/S = GLOB.all_species[owner.species.name]
			if(S.selects_bodytype == SELECTS_BODYTYPE_SHAPESHIFTER)
				choices = S.get_valid_shapeshifter_forms()
			else if(S.selects_bodytype == SELECTS_BODYTYPE_CUSTOM)
				choices = GLOB.custom_species_bases
			var/new_species = tgui_input_list(ui.user, "Please select basic shape.", "Body Shape", choices)
			if(new_species && can_change(owner, APPEARANCE_RACE))
				owner.species.base_species = new_species
				owner.regenerate_icons()
				generate_data(ui.user, owner)
				changed_hook(APPEARANCECHANGER_CHANGED_RACE)
				return TRUE
		if("blood_reagent")
			var/new_blood_reagents = tgui_input_list(ui.user, "Please select blood restoration reagent:", "Character Preference", valid_bloodreagents)
			if(new_blood_reagents && can_change(owner, APPEARANCE_RACE))
				owner.dna.blood_reagents = new_blood_reagents
				changed_hook(APPEARANCECHANGER_CHANGED_RACE)
				return TRUE
		if("blood_color")
			var/current = owner.species.blood_color ? owner.species.blood_color : "#A10808"
			var/blood_col = tgui_color_picker(ui.user, "Please select marking color", "Marking color", current)
			if(blood_col && can_change(owner, APPEARANCE_RACE))
				owner.dna.blood_color = blood_col
				changed_hook(APPEARANCECHANGER_CHANGED_RACE)
				return TRUE
		if("weight")
			var/new_weight = tgui_input_number(ui.user, "Choose tbe character's relative body weight.\n\
			This measurement should be set relative to a normal 5'10'' person's body and not the actual size of the character.\n\
			([WEIGHT_MIN]-[WEIGHT_MAX])", "Character Preference", null, WEIGHT_MAX, WEIGHT_MIN, round_value=FALSE)
			if(new_weight && can_change(owner, APPEARANCE_RACE))
				var/unit_of_measurement = tgui_alert(ui.user, "Is that number in pounds (lb) or kilograms (kg)?", "Confirmation", list("Pounds", "Kilograms"))
				if(unit_of_measurement && can_change(owner, APPEARANCE_RACE))
					if(unit_of_measurement == "Pounds")
						new_weight = round(text2num(new_weight),4)
					if(unit_of_measurement == "Kilograms")
						new_weight = round(2.20462*text2num(new_weight),4)
					owner.weight = sanitize_integer(new_weight, WEIGHT_MIN, WEIGHT_MAX, owner.weight)
					changed_hook(APPEARANCECHANGER_CHANGED_RACE)
					return TRUE
		if("size_scale")
			var/new_size = tgui_input_number(ui.user, "Choose size, ranging from [RESIZE_MINIMUM * 100]% to [RESIZE_MAXIMUM * 100]%", "Set Size", null, RESIZE_MAXIMUM * 100, RESIZE_MINIMUM * 100)
			if(new_size && ISINRANGE(new_size,RESIZE_MINIMUM * 100,RESIZE_MAXIMUM * 100) && can_change(owner, APPEARANCE_RACE))
				owner.size_multiplier = new_size / 100
				owner.update_transform(TRUE)
				owner.regenerate_icons()
				owner.set_dir(owner.dir) // Causes a visual update for fuzzy/offset
				changed_hook(APPEARANCECHANGER_CHANGED_RACE)
				return TRUE
		if("scale_appearance")
			if(can_change(owner, APPEARANCE_RACE))
				owner.dna.scale_appearance = !owner.dna.scale_appearance
				owner.fuzzy = owner.dna.scale_appearance
				owner.regenerate_icons()
				owner.set_dir(owner.dir) // Causes a visual update for fuzzy/offset
				return TRUE
		if("offset_override")
			if(can_change(owner, APPEARANCE_RACE))
				owner.dna.offset_override = !owner.dna.offset_override
				owner.offset_override = owner.dna.offset_override
				owner.regenerate_icons()
				owner.set_dir(owner.dir) // Causes a visual update for fuzzy/offset
				return TRUE
		if("digitigrade")
			if(can_change(owner, APPEARANCE_RACE))
				owner.dna.digitigrade = !owner.dna.digitigrade
				owner.digitigrade = owner.dna.digitigrade
				owner.regenerate_icons()
				generate_data(ui.user, owner)
				changed_hook(APPEARANCECHANGER_CHANGED_RACE)
				return TRUE
		/*if("species_sound") //TODO: UP PORT SPECIES_SOUNDS
			var/list/possible_species_sound_types = species_sound_map
			var/choice = tgui_input_list(ui.user, "Which set of sounds would you like to use? (Cough, Sneeze, Scream, Pain, Gasp, Death)", "Species Sounds", possible_species_sound_types)
			if(choice && can_change(owner, APPEARANCE_RACE))
				owner.species.species_sounds = choice
				return TRUE
		*/
		if("flavor_text")
			var/select_key = params["target"]
			if(select_key && can_change(owner, APPEARANCE_RACE))
				if(select_key in owner.flavor_texts)
					switch(select_key)
						if("general")
							var/msg = strip_html_simple(tgui_input_text(ui.user,"Give a general description of the character. This will be shown regardless of clothings. Put in a single space to make blank.","Flavor Text",html_decode(owner.flavor_texts[select_key]), multiline = TRUE, prevent_enter = TRUE))
							if(can_change(owner, APPEARANCE_RACE)) // allows empty to wipe flavor
								owner.flavor_texts[select_key] = msg
								return TRUE
						else
							var/msg = strip_html_simple(tgui_input_text(ui.user,"Set the flavor text for their [select_key]. Put in a single space to make blank.","Flavor Text",html_decode(owner.flavor_texts[select_key]), multiline = TRUE, prevent_enter = TRUE))
							if(can_change(owner, APPEARANCE_RACE)) // allows empty to wipe flavor
								owner.flavor_texts[select_key] = msg
								return TRUE
		// ***********************************
		// Body designer UI
		// ***********************************
		if("view_brec")
			var/datum/transhuman/body_record/BR = locate(params["view_brec"])
			if(BR && istype(BR.mydna))
				if(DC.allowed(ui.user) || BR.ckey == ui.user.ckey)
					BD.load_record_to_body(BR)
					owner.resleeve_lock = BR.locked
					DC.selected_record = TRUE
			return TRUE
		if("view_stock_brec")
			var/datum/species/S = GLOB.all_species[params["view_stock_brec"]]
			if(S && (S.spawn_flags & (SPECIES_IS_WHITELISTED|SPECIES_CAN_JOIN)) == SPECIES_CAN_JOIN)
				// Generate body record from species!
				owner = new(null, S.name)
				owner.real_name = "Stock [S.name] Body"
				owner.name = owner.real_name
				owner.dna.real_name = owner.real_name
				owner.dna.base_species = S.base_species
				owner.resleeve_lock = FALSE
				owner.custom_species = "Custom Sleeve" // Custom name
				DC.selected_record = TRUE
			return TRUE
		if("loadfromdisk")
			if(!DC.disk)
				return FALSE
			if(DC.disk.stored && can_change(owner, APPEARANCE_RACE))
				BD.load_record_to_body(DC.disk.stored)
				DC.selected_record = TRUE
				to_chat(ui.user,span_notice("\The [owner]'s bodyrecord was loaded from the disk."))
			return TRUE
		if("savetodisk")
			if(!DC.selected_record)
				return FALSE
			if(!DC.disk)
				return FALSE
			if(owner.resleeve_lock)
				var/answer = tgui_alert(ui.user,"This body record will be written to a disk and allow any mind to inhabit it. This is against the current body owner's configured OOC preferences for body impersonation. Please confirm that you have permission to do this, and are sure! Admins will be notified.","Mind Compatability",list("No","Yes"))
				if(!answer)
					return
				if(answer == "No")
					to_chat(ui.user, span_warning("ERROR: This body record is restricted."))
				else
					message_admins("[ui.user] wrote an unlocked version of [owner.real_name]'s bodyrecord to a disk. Their preferences do not allow body impersonation, but may be allowed with OOC consent.")
					owner.resleeve_lock = FALSE // unlock it, even though it's only temp, so you don't get the warning every time
			if(!owner.resleeve_lock && can_change(owner, APPEARANCE_RACE))
				// Create it from the mob
				if(DC.disk.stored)
					qdel_null(DC.disk.stored)
				to_chat(ui.user,span_notice("\The [owner]'s bodyrecord was saved to the disk."))
				DC.disk.stored = new /datum/transhuman/body_record(owner, FALSE, FALSE) // Saves a COPY!
				DC.disk.stored.locked = FALSE // remove lock
				DC.disk.name = "[initial(DC.disk.name)] ([owner.real_name])"
			return TRUE
		if("ejectdisk")
			if(!DC.disk)
				return FALSE
			if(can_change(owner, APPEARANCE_RACE))
				to_chat(ui.user,span_notice("You eject the disk."))
				DC.disk.forceMove(get_turf(DC))
				DC.disk = null
				return TRUE
		if("back_to_library")
			if(can_change(owner, APPEARANCE_RACE))
				BD.make_fake_owner()
				DC.selected_record = FALSE
				return TRUE
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
		RegisterSignal(owner, COMSIG_OBSERVER_MOVED, PROC_REF(update_active_camera_screen), TRUE)
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
			var/datum/sprite_accessory/hair/S = hair_styles_list[hair_style]
			hair_styles[++hair_styles.len] = list("name" = hair_style, "icon" = S.icon, "icon_state" = "[S.icon_state]_s")
		data["hair_styles"] = hair_styles
		data["ear_styles"] = valid_earstyles
		data["tail_styles"] = valid_tailstyles
		data["wing_styles"] = valid_wingstyles

		markings = owner.get_prioritised_markings()
		var/list/usable_markings = markings.Copy() ^ body_marking_styles_list.Copy()
		var/marking_styles[0]
		for(var/marking_style in usable_markings)
			var/datum/sprite_accessory/marking/S = body_marking_styles_list[marking_style]
			var/our_iconstate = S.icon_state
			if(LAZYLEN(S.body_parts))
				our_iconstate += "-[S.body_parts[1]]"
			marking_styles[++marking_styles.len] = list("name" = marking_style, "icon" = S.icon, "icon_state" = "[our_iconstate]")
		data["marking_styles"] = marking_styles

	if(can_change(owner, APPEARANCE_FACIAL_HAIR))
		var/facial_hair_styles[0]
		for(var/facial_hair_style in valid_facial_hairstyles)
			var/datum/sprite_accessory/facial_hair/S = facial_hair_styles_list[facial_hair_style]
			facial_hair_styles[++facial_hair_styles.len] = list("name" = facial_hair_style, "icon" = S.icon, "icon_state" = "[S.icon_state]_s")
		data["facial_hair_styles"] = facial_hair_styles

	if(can_change(owner, APPEARANCE_HAIR_COLOR))
		data["hair_grads"] = valid_gradstyles

	return data

/datum/tgui_module/appearance_changer/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	generate_data(user, owner)

	data["is_design_console"] = FALSE
	data["disk"] = FALSE
	data["selected_a_record"] = FALSE
	data["character_records"] = list()
	data["stock_records"] = list()
	// Handle some unique stuff to the body design console
	var/obj/machinery/computer/transhuman/designer/DC = null
	if(istype(src,/datum/tgui_module/appearance_changer/body_designer))
		var/datum/tgui_module/appearance_changer/body_designer/BD = src
		DC = BD.linked_body_design_console?.resolve()
	if(DC)
		data["is_design_console"] = TRUE
		data["disk"] = !isnull(DC.disk)
		// Monkey is a placeholder, because I am not hackcoding the appearance changer to accept a null owner - Willbird
		data["selected_a_record"] = DC.selected_record
		if(!DC.selected_record)
			// Load all records on station that can be printed
			var/list/bodyrecords_list_ui = list()
			for(var/N in DC.our_db.body_scans)
				var/datum/transhuman/body_record/BR = DC.our_db.body_scans[N]
				var/datum/species/S = GLOB.all_species[BR.mydna.dna.species]
				if((S.spawn_flags & (SPECIES_IS_WHITELISTED|SPECIES_CAN_JOIN)) != SPECIES_CAN_JOIN || BR.synthetic) continue
				bodyrecords_list_ui[++bodyrecords_list_ui.len] = list("name" = N, "recref" = "\ref[BR]")
			data["character_records"] = bodyrecords_list_ui
			// Load all stock records printable
			var/list/stock_bodyrecords_list_ui = list()
			for (var/N in GLOB.all_species)
				var/datum/species/S = GLOB.all_species[N]
				if((S.spawn_flags & (SPECIES_IS_WHITELISTED|SPECIES_CAN_JOIN)) != SPECIES_CAN_JOIN) continue
				stock_bodyrecords_list_ui += N
			data["stock_records"] = stock_bodyrecords_list_ui
			data["change_race"] = can_change(owner, APPEARANCE_RACE)
			data["gender_id"] = can_change(owner, APPEARANCE_GENDER)
			data["change_gender"] = can_change(owner, APPEARANCE_GENDER)
			data["change_hair"] = can_change(owner, APPEARANCE_HAIR)
			data["change_eye_color"] = can_change(owner, APPEARANCE_EYE_COLOR)
			data["change_hair_color"] = can_change(owner, APPEARANCE_HAIR_COLOR)
			data["change_facial_hair_color"] = can_change(owner, APPEARANCE_FACIAL_HAIR_COLOR)
			// Drop out early, as we have nothing to edit, and are on the BR menu for the designer
			return data
	// species/body
	data["species_name"] = owner.custom_species
	data["use_custom_icon"] = (owner.species.selects_bodytype >= SELECTS_BODYTYPE_CUSTOM)
	data["base_icon"] = owner.species.base_species
	data["synthetic"] = owner.synthetic ? "Yes" : "No"
	data["size_scale"] = player_size_name(owner.size_multiplier)
	data["scale_appearance"] = owner.dna.scale_appearance ? "Fuzzy" : "Sharp"
	data["offset_override"] = owner.dna.offset_override ? "Odd" : "Even"
	data["weight"] = owner.weight
	data["digitigrade"] = owner.digitigrade
	data["blood_reagent"] = owner.dna.blood_reagents
	data["blood_color"] = owner.dna.blood_color
	//data["species_sound"] = owner.species.species_sounds //TODO: RAISE UP FROM CHOMP
	// Are these needed? It seems to be only used if above is unset??
	//data["species_sounds_gendered"] = owner.species.gender_specific_species_sounds
	//data["species_sounds_female"] = owner.species.species_sounds_female
	//data["species_sounds_male"] = owner.species.species_sounds_male
	// flavor
	if(!owner.flavor_texts.len)
		owner.flavor_texts["general"] = ""
		owner.flavor_texts["head"] = ""
		owner.flavor_texts["face"] = ""
		owner.flavor_texts["eyes"] = ""
		owner.flavor_texts["torso"] = ""
		owner.flavor_texts["arms"] = ""
		owner.flavor_texts["hands"] = ""
		owner.flavor_texts["legs"] = ""
		owner.flavor_texts["feet"] = ""
	data["flavor_text"] = owner.flavor_texts.Copy()

	data["name"] = owner.name
	data["specimen"] = owner.species.name
	data["gender"] = owner.gender
	data["gender_id"] = owner.identifying_gender //This is saved to your MIND.
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

		data["ear_style"] = owner.ear_style
		data["ear_secondary_style"] = owner.ear_secondary_style?.name
		data["tail_style"] = owner.tail_style
		data["wing_style"] = owner.wing_style
		var/list/markings_data[0]
		markings = owner.get_prioritised_markings()
		for (var/marking in markings)
			markings_data[++markings_data.len] = list("marking_name" = marking, "marking_color" = markings[marking]["color"] ? markings[marking]["color"] : "#000000") //too tired to add in another submenu for bodyparts here
		data["markings"] = markings_data

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
		data["hair_color_grad"] = rgb(owner.r_grad, owner.g_grad, owner.b_grad)
		data["ears_color"] = rgb(owner.r_ears, owner.g_ears, owner.b_ears)
		data["ears2_color"] = rgb(owner.r_ears2, owner.g_ears2, owner.b_ears2)

		// not a color, but it basically is
		data["hair_grad"] = owner.grad_style

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
	valid_earstyles.Cut()
	valid_tailstyles.Cut()
	valid_wingstyles.Cut()
	valid_gradstyles.Cut()

/datum/tgui_module/appearance_changer/proc/generate_data(mob/user, mob/living/carbon/human/target)
	if(!ishuman(target))
		return TRUE

	if(!LAZYLEN(valid_species))
		valid_species = target.generate_valid_species(check_whitelist, whitelist, blacklist)

	if(!LAZYLEN(valid_hairstyles) || !LAZYLEN(valid_facial_hairstyles))
		valid_hairstyles = target.generate_valid_hairstyles(check_gender = 0)
		valid_facial_hairstyles = target.generate_valid_facial_hairstyles()

	if(!LAZYLEN(valid_earstyles))
		for(var/path in ear_styles_list)
			var/datum/sprite_accessory/ears/instance = ear_styles_list[path]
			if(can_use_sprite(instance, target, user))
				valid_earstyles.Add(list(list(
					"name" = instance.name,
					"instance" = REF(instance),
					"color" = !!instance.do_colouration,
					"second_color" = !!instance.extra_overlay,
					"icon" = instance.icon,
					"icon_state" = instance.icon_state
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
					"icon" = instance.icon,
					"icon_state" = instance.icon_state
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
					"icon" = instance.icon,
					"icon_state" = instance.icon_state
				)))

	if(!LAZYLEN(valid_gradstyles))
		for(var/key in GLOB.hair_gradients)
			valid_gradstyles.Add(list(list(key)))

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

/datum/tgui_module/appearance_changer/proc/can_use_sprite(datum/sprite_accessory/X, mob/living/carbon/human/target, mob/user)
	if(X.name == DEVELOPER_WARNING_NAME)
		return FALSE
	if(!isnull(X.species_allowed) && !(target.species.name in X.species_allowed) && (!istype(target.species, /datum/species/custom))) // Letting custom species access wings/ears/tails.
		return FALSE

	if(LAZYLEN(X.ckeys_allowed) && !(user?.ckey in X.ckeys_allowed) && !(target.ckey in X.ckeys_allowed))
		return FALSE

	return TRUE

// Subtypes for specific items or machines:
// *******************************************************
// Salon Pro
// *******************************************************
/datum/tgui_module/appearance_changer/mirror
	name = "SalonPro Nano-Mirror&trade;"
	flags = APPEARANCE_ALL_HAIR
	customize_usr = TRUE

/datum/tgui_module/appearance_changer/mirror/coskit
	name = "SalonPro Porta-Makeover Deluxe&trade;"

// *******************************************************
// Vore TF
// *******************************************************
/datum/tgui_module/appearance_changer/vore
	name = "Appearance Editor (Vore)"
	flags = APPEARANCE_ALL

/datum/tgui_module/appearance_changer/vore/tgui_state(mob/user)
	return GLOB.tgui_conscious_state

/datum/tgui_module/appearance_changer/vore/tgui_status(mob/user, datum/tgui_state/state)
	if(!isbelly(owner.loc))
		return STATUS_CLOSE
	return ..()

/datum/tgui_module/appearance_changer/vore/update_active_camera_screen()
	cam_screen.vis_contents = list(owner)
	cam_background.icon_state = "clear"
	cam_background.fill_rect(1, 1, 1, 1)
	local_skybox.cut_overlays()

/datum/tgui_module/appearance_changer/vore/tgui_close(mob/user)
	. = ..()
	QDEL_IN(src, 1)

/datum/tgui_module/appearance_changer/vore/changed_hook(flag)
	var/mob/living/carbon/human/M = owner
	var/mob/living/O = usr

	switch(flag)
		if(APPEARANCECHANGER_CHANGED_RACE)
			to_chat(M, span_notice("You lose sensation of your body, feeling only the warmth of everything around you... "))
			to_chat(O, span_notice("Your body shifts as you make dramatic changes to your captive's body."))
		if(APPEARANCECHANGER_CHANGED_GENDER)
			to_chat(M, span_notice("Your body feels very strange..."))
			to_chat(O, span_notice("You feel strange as you alter your captive's gender."))
		if(APPEARANCECHANGER_CHANGED_GENDER_ID)
			to_chat(M, span_notice("You start to feel... [capitalize(M.gender)]?"))
			to_chat(O, span_notice("You feel strange as you alter your captive's gender identity."))
		if(APPEARANCECHANGER_CHANGED_SKINTONE, APPEARANCECHANGER_CHANGED_SKINCOLOR)
			to_chat(M, span_notice("Your body tingles all over..."))
			to_chat(O, span_notice("You tingle as you make noticeable changes to your captive's body."))
		if(APPEARANCECHANGER_CHANGED_HAIRSTYLE, APPEARANCECHANGER_CHANGED_HAIRCOLOR, APPEARANCECHANGER_CHANGED_F_HAIRSTYLE, APPEARANCECHANGER_CHANGED_F_HAIRCOLOR)
			to_chat(M, span_notice("Your body tingles all over..."))
			to_chat(O, span_notice("You tingle as you make noticeable changes to your captive's body."))
		if(APPEARANCECHANGER_CHANGED_EYES)
			to_chat(M, span_notice("You feel lightheaded and drowsy..."))
			to_chat(O, span_notice("You feel warm as you make subtle changes to your captive's body."))

// *******************************************************
// Weaver Cocoon
// *******************************************************
/datum/tgui_module/appearance_changer/cocoon
	name ="Appearance Editor (Cocoon)"
	flags = APPEARANCE_ALL_HAIR | APPEARANCE_EYE_COLOR | APPEARANCE_SKIN
	customize_usr = TRUE

/datum/tgui_module/appearance_changer/cocoon/tgui_status(mob/user, datum/tgui_state/state)
	//if(!istype(owner.loc, /obj/item/storage/vore_egg/bugcocoon))
	if(!owner.transforming)
		return STATUS_CLOSE
	return ..()

// *******************************************************
// Morph Superpower
// *******************************************************
/datum/tgui_module/appearance_changer/superpower
	name ="Appearance Editor (Superpower)"
	flags = APPEARANCE_ALL_HAIR | APPEARANCE_EYE_COLOR | APPEARANCE_SKIN
	customize_usr = TRUE

/datum/tgui_module/appearance_changer/superpower/tgui_status(mob/user, datum/tgui_state/state)
	var/datum/gene/G = get_gene_from_trait(/datum/trait/positive/superpower_morph)
	if(!owner.dna.GetSEState(G.block))
		return STATUS_CLOSE
	return ..()

// *******************************************************
// Body design console
// *******************************************************
/datum/tgui_module/appearance_changer/body_designer
	name ="Appearance Editor (Body Designer)"
	flags = APPEARANCE_ALL
	var/datum/weakref/linked_body_design_console = null

/datum/tgui_module/appearance_changer/body_designer/tgui_status(mob/user, datum/tgui_state/state)
	if(!istype(host,/obj/machinery/computer/transhuman/designer))
		return STATUS_CLOSE
	return ..()

/datum/tgui_module/appearance_changer/body_designer/Destroy()
	var/obj/machinery/computer/transhuman/designer/DC = linked_body_design_console?.resolve()
	if(DC)
		DC.selected_record = FALSE
		DC.designer_gui = null // no hardrefs
	. = ..()

/datum/tgui_module/appearance_changer/body_designer/proc/make_fake_owner()
	// checks for monkey to tell if on the menu
	if(owner)
		UnregisterSignal(owner, COMSIG_OBSERVER_MOVED)
		qdel_null(owner)
	owner = new(src)
	owner.set_species(SPECIES_LLEILL)
	owner.species.produceCopy(owner.species.traits.Copy(),owner,null,FALSE)
	owner.invisibility = 101
	// Add listeners back
	owner.AddComponent(/datum/component/recursive_move)
	RegisterSignal(owner, COMSIG_OBSERVER_MOVED, PROC_REF(update_active_camera_screen), TRUE)

/datum/tgui_module/appearance_changer/body_designer/proc/load_record_to_body(var/datum/transhuman/body_record/current_project)
	if(owner)
		UnregisterSignal(owner, COMSIG_OBSERVER_MOVED)
		qdel_null(owner)
	//Get the DNA and generate a new mob
	var/datum/dna2/record/R = current_project.mydna
	owner = new /mob/living/carbon/human(src, R.dna.species)
	//Fix the external organs
	for(var/part in current_project.limb_data)
		var/status = current_project.limb_data[part]
		if(status == null) continue //Species doesn't have limb? Child of amputated limb?
		var/obj/item/organ/external/O = owner.organs_by_name[part]
		if(!O) continue //Not an organ. Perhaps another amputation removed it already.
		if(status == 1) //Normal limbs
			continue
		else if(status == 0) //Missing limbs
			O.remove_rejuv()
		else if(status) //Anything else is a manufacturer
			O.remove_rejuv() //Don't robotize them, leave them removed so robotics can attach a part.
	for(var/part in current_project.organ_data)
		var/status = current_project.organ_data[part]
		if(status == null) continue //Species doesn't have organ? Child of missing part?
		var/obj/item/organ/I = owner.internal_organs_by_name[part]
		if(!I) continue//Not an organ. Perhaps external conversion changed it already?
		if(status == 0) //Normal organ
			continue
		else if(status == 1) //Assisted organ
			I.mechassist()
		else if(status == 2) //Mechanical organ
			I.robotize()
		else if(status == 3) //Digital organ
			I.digitize()
	//Set the name or generate one
	owner.real_name = R.dna.real_name
	owner.name = owner.real_name
	//Apply DNA
	owner.dna = R.dna.Clone()
	owner.original_player = current_project.ckey
	//Apply legs
	owner.digitigrade = R.dna.digitigrade // ensure clone mob has digitigrade var set appropriately
	if(owner.dna.digitigrade <> R.dna.digitigrade)
		owner.dna.digitigrade = R.dna.digitigrade // ensure cloned DNA is set appropriately from record??? for some reason it doesn't get set right despite the override to datum/dna/Clone()
	//Update appearance, remake icons
	owner.UpdateAppearance()
	owner.sync_dna_traits(FALSE)
	owner.sync_organ_dna()
	owner.dna.blood_reagents = R.dna.blood_reagents
	owner.dna.blood_color = R.dna.blood_color
	owner.regenerate_icons()
	owner.flavor_texts = current_project.mydna.flavor.Copy()
	owner.resize(current_project.sizemult, FALSE)
	owner.appearance_flags = current_project.aflags
	owner.weight = current_project.weight
	if(current_project.speciesname)
		owner.custom_species = current_project.speciesname
	// Add listeners back
	owner.AddComponent(/datum/component/recursive_move)
	RegisterSignal(owner, COMSIG_OBSERVER_MOVED, PROC_REF(update_active_camera_screen), TRUE)
