var/list/preferences_datums = list()

/datum/preferences
	/// The path to the general savefile for this datum
	var/path
	/// Whether or not we allow saving/loading. Used for guests, if they're enabled
	var/load_and_save = TRUE
	/// Ensures that we always load the last used save, QOL
	var/default_slot = 1

	//non-preference stuff
	var/warns = 0
	var/muted = 0
	var/last_ip
	var/last_id

	//game-preferences
	var/lastchangelog = ""				//Saved changlog filesize to detect if there was a change
	var/ooccolor = "#010000"			//Whatever this is set to acts as 'reset' color and is thus unusable as an actual custom color
	var/be_special = 0					//Special role selection
	var/UI_style = "Midnight"
	var/UI_style_color = "#ffffff"
	var/UI_style_alpha = 255
	var/tooltipstyle = "Midnight"		//Style for popup tooltips
	var/client_fps = 40
	var/ambience_freq = 5				// How often we're playing repeating ambience to a client.
	var/ambience_chance = 35			// What's the % chance we'll play ambience (in conjunction with the above frequency)

	var/tgui_fancy = TRUE
	var/tgui_lock = FALSE
	var/tgui_input_mode = FALSE			// All the Input Boxes (Text,Number,List,Alert)
	var/tgui_large_buttons = TRUE
	var/tgui_swapped_buttons = FALSE
	var/obfuscate_key = FALSE
	var/obfuscate_job = FALSE
	var/chat_timestamp = FALSE

	//character preferences
	var/real_name						//our character's name
	var/be_random_name = 0				//whether we are a random name every round
	var/nickname						//our character's nickname
	var/age = 30						//age of character
	var/bday_month = 0					//Birthday month
	var/bday_day = 0					//Birthday day
	var/last_birthday_notification = 0	//The last year we were notified about our birthday
	var/bday_announce = FALSE			//Public announcement for birthdays
	var/spawnpoint = "Arrivals Shuttle" //where this character will spawn (0-2).
	var/b_type = "A+"					//blood type (not-chooseable)
	var/blood_reagents = "default"		//blood restoration reagents
	var/headset = 1						//headset type
	var/backbag = 2						//backpack type
	var/pdachoice = 1					//PDA type
	var/shoe_hater = FALSE				//RS ADD - if true, will spawn with no shoes
	var/h_style = "Bald"				//Hair type
	var/r_hair = 0						//Hair color
	var/g_hair = 0						//Hair color
	var/b_hair = 0						//Hair color
	var/grad_style = "none"				//Gradient style
	var/r_grad = 0						//Gradient color
	var/g_grad = 0						//Gradient color
	var/b_grad = 0						//Gradient color
	var/f_style = "Shaved"				//Face hair type
	var/r_facial = 0					//Face hair color
	var/g_facial = 0					//Face hair color
	var/b_facial = 0					//Face hair color
	var/s_tone = -75						//Skin tone
	var/r_skin = 238					//Skin color // Vorestation edit, so color multi sprites can aren't BLACK AS THE VOID by default.
	var/g_skin = 206					//Skin color // Vorestation edit, so color multi sprites can aren't BLACK AS THE VOID by default.
	var/b_skin = 179					//Skin color // Vorestation edit, so color multi sprites can aren't BLACK AS THE VOID by default.
	var/r_eyes = 0						//Eye color
	var/g_eyes = 0						//Eye color
	var/b_eyes = 0						//Eye color
	var/species = SPECIES_HUMAN         //Species datum to use.
	var/species_preview                 //Used for the species selection window.
	var/list/alternate_languages = list() //Secondary language(s)
	var/list/language_prefixes = list() //Language prefix keys
	var/list/language_custom_keys = list() //Language custom call keys
	var/list/gear						//Left in for Legacy reasons, will no longer save.
	var/list/gear_list = list()			//Custom/fluff item loadouts.
	var/gear_slot = 1					//The current gear save slot
	var/list/traits						//Traits which modifier characters for better or worse (mostly worse).
	var/synth_color	= 0					//Lets normally uncolorable synth parts be colorable.
	var/r_synth							//Used with synth_color to color synth parts that normaly can't be colored.
	var/g_synth							//Same as above
	var/b_synth							//Same as above
	var/synth_markings = 1				//Enable/disable markings on synth parts. //VOREStation Edit - 1 by default
	var/digitigrade = 0

		//Some faction information.
	var/home_system = "Unset"           //Current home or residence.
	var/birthplace = "Unset"           //Location of birth.
	var/citizenship = "None"            //Government or similar entity with which you hold citizenship.
	var/faction = "None"                //General associated faction.
	var/religion = "None"               //Religious association.
	var/antag_faction = "None"			//Antag associated faction.
	var/antag_vis = "Hidden"			//How visible antag association is to others.

		//Mob preview
	var/list/char_render_holders		//Should only be a key-value list of north/south/east/west = obj/screen.
	var/static/list/preview_screen_locs = list(
		"1" = "character_preview_map:2,7",
		"2" = "character_preview_map:2,5",
		"4"  = "character_preview_map:2,3",
		"8"  = "character_preview_map:2,1",
		"BG" = "character_preview_map:1,1 to 3,8",
		"PMH" = "character_preview_map:2,7"
	)

		//Jobs, uses bitflags
	var/job_civilian_high = 0
	var/job_civilian_med = 0
	var/job_civilian_low = 0

	var/job_medsci_high = 0
	var/job_medsci_med = 0
	var/job_medsci_low = 0

	var/job_engsec_high = 0
	var/job_engsec_med = 0
	var/job_engsec_low = 0

	//Keeps track of preferrence for not getting any wanted jobs
	var/alternate_option = 1

	var/used_skillpoints = 0
	var/skill_specialization = null
	var/list/skills = list() // skills can range from 0 to 3

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data = list()
	var/list/rlimb_data = list()
	var/list/player_alt_titles = new()		// the default name of a job like JOB_MEDICAL_DOCTOR

	var/list/body_markings = list() // "name" = "#rgbcolor" //VOREStation Edit: "name" = list(BP_HEAD = list("on" = <enabled>, "color" = "#rgbcolor"), BP_TORSO = ...)

	var/list/flavor_texts = list()
	var/list/flavour_texts_robot = list()
	var/custom_link = null

	var/list/body_descriptors = list()

	var/med_record = ""
	var/sec_record = ""
	var/gen_record = ""
	var/exploit_record = ""
	var/disabilities = 0

	var/economic_status = "Average"

	var/uplinklocation = "PDA"

	// OOC Metadata:
	var/metadata = ""
	var/metadata_likes = ""
	var/metadata_dislikes = ""
	var/list/ignored_players = list()

	var/client/client = null
	var/client_ckey = null

	// Communicator identity data
	var/communicator_visibility = 0

	/// Default ringtone for character; if blank, use job default.
	var/ringtone = null

	var/datum/category_collection/player_setup_collection/player_setup
	var/datum/browser/panel

	var/lastnews // Hash of last seen lobby news content.
	var/lastlorenews //ID of last seen lore news article.

	var/examine_text_mode = 0 // Just examine text, include usage (description_info), switch to examine panel.
	var/multilingual_mode = 0 // Default behaviour, delimiter-key-space, delimiter-key-delimiter, off

	// THIS IS NOT SAVED
	// WE JUST HAVE NOWHERE ELSE TO STORE IT
	var/list/action_button_screen_locs

	var/list/volume_channels = list()

	///If they are currently in the process of swapping slots, don't let them open 999 windows for it and get confused
	var/selecting_slots = FALSE

	/// The json savefile for this datum
	var/datum/json_savefile/savefile

/datum/preferences/New(client/C)
	client = C

	for(var/middleware_type in subtypesof(/datum/preference_middleware))
		middleware += new middleware_type(src)

	if(istype(C)) // IS_CLIENT_OR_MOCK
		client_ckey = C.ckey
		load_and_save = !IsGuestKey(C.key)
		load_path(C.ckey)
		if(load_and_save && !fexists(path))
			try_savefile_type_migration()
	else
		CRASH("attempted to create a preferences datum without a client or mock!")
	load_savefile()

	// Legacy code
	gear = list()
	gear_list = list()
	gear_slot = 1
	// End legacy code

	player_setup = new(src)

	var/loaded_preferences_successfully = load_preferences()
	if(loaded_preferences_successfully)
		if(load_character())
			return

	// Didn't load a character, so let's randomize
	set_biological_gender(pick(MALE, FEMALE))
	real_name = random_name(identifying_gender,species)
	b_type = RANDOM_BLOOD_TYPE

	if(client)
		apply_all_client_preferences()

	if(!loaded_preferences_successfully)
		save_preferences()
	save_character() // Save random character

/datum/preferences/Destroy()
	QDEL_LIST_ASSOC_VAL(char_render_holders)
	QDEL_NULL(middleware)
	value_cache = null
	return ..()

/datum/preferences/proc/ZeroSkills(var/forced = 0)
	for(var/V in SKILLS) for(var/datum/skill/S in SKILLS[V])
		if(!skills.Find(S.ID) || forced)
			skills[S.ID] = SKILL_NONE

/datum/preferences/proc/CalculateSkillPoints()
	used_skillpoints = 0
	for(var/V in SKILLS) for(var/datum/skill/S in SKILLS[V])
		var/multiplier = 1
		switch(skills[S.ID])
			if(SKILL_NONE)
				used_skillpoints += 0 * multiplier
			if(SKILL_BASIC)
				used_skillpoints += 1 * multiplier
			if(SKILL_ADEPT)
				// secondary skills cost less
				if(S.secondary)
					used_skillpoints += 1 * multiplier
				else
					used_skillpoints += 3 * multiplier
			if(SKILL_EXPERT)
				// secondary skills cost less
				if(S.secondary)
					used_skillpoints += 3 * multiplier
				else
					used_skillpoints += 6 * multiplier

/datum/preferences/proc/GetSkillClass(points)
	return CalculateSkillClass(points, age)

/proc/CalculateSkillClass(points, age)
	if(points <= 0) return "Unconfigured"
	// skill classes describe how your character compares in total points
	points -= min(round((age - 20) / 2.5), 4) // every 2.5 years after 20, one extra skillpoint
	if(age > 30)
		points -= round((age - 30) / 5) // every 5 years after 30, one extra skillpoint
	switch(points)
		if(-1000 to 3)
			return "Terrifying"
		if(4 to 6)
			return "Below Average"
		if(7 to 10)
			return "Average"
		if(11 to 14)
			return "Above Average"
		if(15 to 18)
			return "Exceptional"
		if(19 to 24)
			return "Genius"
		if(24 to 1000)
			return "God"

/datum/preferences/proc/ShowChoices(mob/user)
	if(!user || !user.client)	return

	if(!get_mob_by_key(client_ckey))
		to_chat(user, span_danger("No mob exists for the given client!"))
		return

	if(!char_render_holders)
		update_preview_icon()
	show_character_previews()

	var/dat = "<html><body><center>"

	if(path)
		dat += "Slot - "
		dat += "<a href='?src=\ref[src];load=1'>Load slot</a> - "
		dat += "<a href='?src=\ref[src];save=1'>Save slot</a> - "
		dat += "<a href='?src=\ref[src];reload=1'>Reload slot</a> - "
		dat += "<a href='?src=\ref[src];resetslot=1'>Reset slot</a> - "
		dat += "<a href='?src=\ref[src];copy=1'>Copy slot</a>"

	else
		dat += "Please create an account to save your preferences."

	dat += "<br>"
	dat += player_setup.header()
	dat += "<br><HR></center>"
	dat += player_setup.content(user)

	dat += "</html></body>"
	//user << browse(dat, "window=preferences;size=635x736")
	winshow(user, "preferences_window", TRUE)
	var/datum/browser/popup = new(user, "preferences_browser", "Character Setup", 800, 800)
	popup.set_content(dat)
	popup.open(FALSE) // Skip registring onclose on the browser pane
	onclose(user, "preferences_window", src) // We want to register on the window itself

/datum/preferences/proc/update_character_previews(var/mob/living/carbon/human/mannequin)
	if(!client)
		return

	var/obj/screen/setup_preview/pm_helper/PMH = LAZYACCESS(char_render_holders, "PMH")
	if(!PMH)
		PMH = new
		LAZYSET(char_render_holders, "PMH", PMH)
		client.screen |= PMH
	PMH.screen_loc = preview_screen_locs["PMH"]

	var/obj/screen/setup_preview/bg/BG = LAZYACCESS(char_render_holders, "BG")
	if(!BG)
		BG = new
		BG.plane = TURF_PLANE
		BG.icon = 'icons/effects/setup_backgrounds_vr.dmi'
		BG.pref = src
		LAZYSET(char_render_holders, "BG", BG)
		client.screen |= BG
	BG.icon_state = bgstate
	BG.screen_loc = preview_screen_locs["BG"]

	for(var/D in global.cardinal)
		var/obj/screen/setup_preview/O = LAZYACCESS(char_render_holders, "[D]")
		if(!O)
			O = new
			O.pref = src
			LAZYSET(char_render_holders, "[D]", O)
			client.screen |= O
		mannequin.set_dir(D)
		mannequin.update_tail_showing()
		mannequin.ImmediateOverlayUpdate()
		var/mutable_appearance/MA = new(mannequin)
		O.appearance = MA
		O.screen_loc = preview_screen_locs["[D]"]

/datum/preferences/proc/show_character_previews()
	if(!client || !char_render_holders)
		return
	for(var/render_holder in char_render_holders)
		client.screen |= char_render_holders[render_holder]

/datum/preferences/proc/clear_character_previews()
	for(var/index in char_render_holders)
		var/obj/screen/S = char_render_holders[index]
		client?.screen -= S
		qdel(S)
	char_render_holders = null

/datum/preferences/proc/process_link(mob/user, list/href_list)
	if(!user)	return

	if(!istype(user, /mob/new_player))	return

	if(href_list["preference"] == "open_whitelist_forum")
		if(CONFIG_GET(string/forumurl))
			user << link(CONFIG_GET(string/forumurl))
		else
			to_chat(user, span_danger("The forum URL is not set in the server configuration."))
			return
	ShowChoices(usr)
	return 1

/datum/preferences/Topic(href, list/href_list)
	if(..())
		return 1

	if(href_list["save"])
		save_character()
		save_preferences()
	else if(href_list["reload"])
		load_preferences()
		load_character()
		attempt_vr(client.prefs_vr,"load_vore","") //VOREStation Edit
		sanitize_preferences()
	else if(href_list["load"])
		if(!IsGuestKey(usr.key))
			open_load_dialog(usr)
			return 1
	else if(href_list["resetslot"])
		if("Yes" != tgui_alert(usr, "This will reset the current slot. Continue?", "Reset current slot?", list("No", "Yes")))
			return 0
		if("Yes" != tgui_alert(usr, "Are you completely sure that you want to reset this character slot?", "Reset current slot?", list("No", "Yes")))
			return 0
		reset_slot()
		sanitize_preferences()
	else if(href_list["copy"])
		if(!IsGuestKey(usr.key))
			open_copy_dialog(usr)
			return 1
	else if(href_list["close"])
		// User closed preferences window, cleanup anything we need to.
		clear_character_previews()
		return 1
	else
		return 0

	ShowChoices(usr)
	return 1

/datum/preferences/proc/copy_to(mob/living/carbon/human/character, icon_updates = TRUE)
	// Sanitizing rather than saving as someone might still be editing when copy_to occurs.
	player_setup.sanitize_setup()

	// This needs to happen before anything else becuase it sets some variables.
	character.set_species(species)
	// Special Case: This references variables owned by two different datums, so do it here.
	if(be_random_name)
		real_name = random_name(identifying_gender,species)

	// Ask the preferences datums to apply their own settings to the new mob
	player_setup.copy_to_mob(character)

	for(var/datum/preference/preference as anything in get_preferences_in_priority_order())
		if(preference.savefile_identifier != PREFERENCE_CHARACTER)
			continue

		preference.apply_to_human(character, read_preference(preference.type))

	// VOREStation Edit - Sync up all their organs and species one final time
	character.force_update_organs()

	if(icon_updates)
		character.force_update_limbs()
		character.update_icons_body()
		character.update_mutations()
		character.update_underwear()
		character.update_hair()

	if(LAZYLEN(character.descriptors))
		for(var/entry in body_descriptors)
			character.descriptors[entry] = body_descriptors[entry]

/datum/preferences/proc/open_load_dialog(mob/user)
	if(selecting_slots)
		to_chat(user, span_warning("You already have a slot selection dialog open!"))
		return
	if(!savefile)
		return

	var/default
	var/list/charlist = list()

	for(var/i in 1 to CONFIG_GET(number/character_slots))
		var/list/save_data = savefile.get_entry("character[i]", list())
		var/name = save_data["real_name"]
		var/nickname = save_data["nickname"]
		if(!name)
			name = "[i] - \[Unused Slot\]"
		else if(i == default_slot)
			name = "►[i] - [name]"
		else
			name = "[i] - [name]"
		if(i == default_slot)
			default = "[name][nickname ? " ([nickname])" : ""]"
		charlist["[name][nickname ? " ([nickname])" : ""]"] = i

	selecting_slots = TRUE
	var/choice = tgui_input_list(user, "Select a character to load:", "Load Slot", charlist, default)
	selecting_slots = FALSE
	if(!choice)
		return

	var/slotnum = charlist[choice]
	if(!slotnum)
		error("Player picked [choice] slot to load, but that wasn't one we sent.")
		return

	load_preferences()
	load_character(slotnum)
	attempt_vr(user.client?.prefs_vr,"load_vore","") //VOREStation Edit
	sanitize_preferences()
	save_preferences()
	ShowChoices(user)

/datum/preferences/proc/open_copy_dialog(mob/user)
	if(selecting_slots)
		to_chat(user, span_warning("You already have a slot selection dialog open!"))
		return
	if(!savefile)
		return

	var/list/charlist = list()

	for(var/i in 1 to CONFIG_GET(number/character_slots))
		var/list/save_data = savefile.get_entry("character[i]", list())
		var/name = save_data["real_name"]
		var/nickname = save_data["nickname"]

		if(!name)
			name = "[i] - \[Unused Slot\]"
		else if(i == default_slot)
			name = "►[i] - [name]"
		else
			name = "[i] - [name]"

		charlist["[name][nickname ? " ([nickname])" : ""]"] = i

	selecting_slots = TRUE
	var/choice = tgui_input_list(user, "Select a character to COPY TO:", "Copy Slot", charlist)
	selecting_slots = FALSE
	if(!choice)
		return

	var/slotnum = charlist[choice]
	if(!slotnum)
		error("Player picked [choice] slot to copy to, but that wasn't one we sent.")
		return

	if(tgui_alert(user, "Are you sure you want to override slot [slotnum], [choice]'s savedata?", "Confirm Override", list("No", "Yes")) == "Yes")
		overwrite_character(slotnum)
		sanitize_preferences()
		save_preferences()
		save_character()
		attempt_vr(user.client?.prefs_vr,"load_vore","")
		ShowChoices(user)

/datum/preferences/proc/vanity_copy_to(var/mob/living/carbon/human/character, var/copy_name, var/copy_flavour = TRUE, var/copy_ooc_notes = FALSE, var/convert_to_prosthetics = FALSE)
	//snowflake copy_to, does not copy anything but the vanity things
	//does not check if the name is the same, do that in any proc that calls this proc
	/*
	name, nickname, flavour, OOC notes
	gender, sex
	custom species name, custom bodytype, weight, scale, scaling center, sound type, sound freq
	custom say verbs
	ears, wings, tail, hair, facial hair
	ears colors, wings colors, tail colors
	body color, prosthetics (if they're a protean) (convert to DSI if protean and not prosthetic), eye color, hair color etc
	markings
	custom synth markings toggle, custom synth color toggle
	digitigrade
	blood color
	*/
	if (copy_name)
		if(CONFIG_GET(flag/humans_need_surnames)) // CHOMPEdit
			var/firstspace = findtext(real_name, " ")
			var/name_length = length(real_name)
			if(!firstspace)	//we need a surname
				real_name += " [pick(last_names)]"
			else if(firstspace == name_length)
				real_name += "[pick(last_names)]"
		character.real_name = real_name
		character.name = character.real_name
		if(character.dna)
			character.dna.real_name = character.real_name
		character.nickname = nickname
	character.gender = biological_gender
	character.identifying_gender = identifying_gender

	character.r_eyes	= r_eyes
	character.g_eyes	= g_eyes
	character.b_eyes	= b_eyes
	character.h_style	= h_style
	character.r_hair	= r_hair
	character.g_hair	= g_hair
	character.b_hair	= b_hair
	character.r_grad	= r_grad
	character.g_grad	= g_grad
	character.b_grad	= b_grad
	character.f_style	= f_style
	character.r_facial	= r_facial
	character.g_facial	= g_facial
	character.b_facial	= b_facial
	character.r_skin	= r_skin
	character.g_skin	= g_skin
	character.b_skin	= b_skin
	character.s_tone	= s_tone
	character.h_style	= h_style
	character.grad_style= grad_style
	character.f_style	= f_style
	character.grad_style= grad_style
	character.b_type	= b_type
	character.synth_color = synth_color
	character.r_synth	= r_synth
	character.g_synth	= g_synth
	character.b_synth	= b_synth
	character.synth_markings = synth_markings

	var/list/ear_styles = get_available_styles(global.ear_styles_list)
	character.ear_style =  ear_styles[ear_style]
	character.r_ears =     r_ears
	character.b_ears =     b_ears
	character.g_ears =     g_ears
	character.r_ears2 =    r_ears2
	character.b_ears2 =    b_ears2
	character.g_ears2 =    g_ears2
	character.r_ears3 =    r_ears3
	character.b_ears3 =    b_ears3
	character.g_ears3 =    g_ears3

	var/list/tail_styles = get_available_styles(global.tail_styles_list)
	character.tail_style = tail_styles[tail_style]
	character.r_tail =     r_tail
	character.b_tail =     b_tail
	character.g_tail =     g_tail
	character.r_tail2 =    r_tail2
	character.b_tail2 =    b_tail2
	character.g_tail2 =    g_tail2
	character.r_tail3 =    r_tail3
	character.b_tail3 =    b_tail3
	character.g_tail3 =    g_tail3

	var/list/wing_styles = get_available_styles(global.wing_styles_list)
	character.wing_style = wing_styles[wing_style]
	character.r_wing =     r_wing
	character.b_wing =     b_wing
	character.g_wing =     g_wing
	character.r_wing2 =    r_wing2
	character.b_wing2 =    b_wing2
	character.g_wing2 =    g_wing2
	character.r_wing3 =    r_wing3
	character.b_wing3 =    b_wing3
	character.g_wing3 =    g_wing3

	character.set_gender(biological_gender)

	// Destroy/cyborgize organs and limbs.
	if (convert_to_prosthetics) //should only really be run for proteans
		var/list/organs_to_edit = list()
		for (var/name in list(BP_TORSO, BP_HEAD, BP_GROIN, BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/O = character.organs_by_name[name]
			if (O)
				var/x = organs_to_edit.Find(O.parent_organ)
				if (x == 0)
					organs_to_edit += name
				else
					organs_to_edit.Insert(x+(O.robotic == ORGAN_NANOFORM ? 1 : 0), name)
		for(var/name in organs_to_edit)
			var/status = organ_data[name]
			var/obj/item/organ/external/O = character.organs_by_name[name]
			if(O)
				if(status == "amputated")
					continue
				else if(status == "cyborg")
					O.robotize(rlimb_data[name])
				else
					var/bodytype
					var/datum/species/selected_species = GLOB.all_species[species]
					if(selected_species.selects_bodytype)
						bodytype = custom_base
					else
						bodytype = selected_species.get_bodytype()
					var/dsi_company = GLOB.dsi_to_species[bodytype]
					if (!dsi_company)
						dsi_company = "DSI - Adaptive"
					O.robotize(dsi_company)

	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = character.organs_by_name[N]
		O.markings.Cut()

	var/priority = 0
	for(var/M in body_markings)
		priority += 1
		var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[M]

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O)
				O.markings[M] = list("color" = body_markings[M][BP]["color"], "datum" = mark_datum, "priority" = priority, "on" = body_markings[M][BP]["on"])
	character.markings_len = priority

	var/list/last_descriptors = list()
	if(islist(body_descriptors))
		last_descriptors = body_descriptors.Copy()
	body_descriptors = list()

	var/datum/species/mob_species = GLOB.all_species[species]
	if(LAZYLEN(mob_species.descriptors))
		for(var/entry in mob_species.descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			if(istype(descriptor))
				if(isnull(last_descriptors[entry]))
					body_descriptors[entry] = descriptor.default_value // Species datums have initial default value.
				else
					body_descriptors[entry] = CLAMP(last_descriptors[entry], 1, LAZYLEN(descriptor.standalone_value_descriptors))
	character.descriptors = body_descriptors

	if (copy_flavour)
		character.flavor_texts["general"]	= flavor_texts["general"]
		character.flavor_texts["head"]		= flavor_texts["head"]
		character.flavor_texts["face"]		= flavor_texts["face"]
		character.flavor_texts["eyes"]		= flavor_texts["eyes"]
		character.flavor_texts["torso"]		= flavor_texts["torso"]
		character.flavor_texts["arms"]		= flavor_texts["arms"]
		character.flavor_texts["hands"]		= flavor_texts["hands"]
		character.flavor_texts["legs"]		= flavor_texts["legs"]
		character.flavor_texts["feet"]		= flavor_texts["feet"]
	if (copy_ooc_notes)
		character.ooc_notes 				= metadata

	character.weight			= weight_vr
	character.weight_gain		= weight_gain
	character.weight_loss		= weight_loss
	character.fuzzy				= fuzzy
	character.offset_override	= offset_override //CHOMPEdit
	character.voice_freq		= voice_freq
	character.resize(size_multiplier, animate = FALSE, ignore_prefs = TRUE)

	var/list/traits_to_copy = list(/datum/trait/neutral/tall,
									/datum/trait/neutral/taller,
									/datum/trait/neutral/short,
									/datum/trait/neutral/shorter,
									/datum/trait/neutral/obese,
									/datum/trait/neutral/fat,
									/datum/trait/neutral/thin,
									/datum/trait/neutral/thinner,
									/datum/trait/neutral/micro_size_down,
									/datum/trait/neutral/micro_size_up)
	//reset all the above trait vars
	if (character.species)
		character.species.micro_size_mod = 0
		character.species.icon_scale_x = 1
		character.species.icon_scale_y = 1
		for (var/trait in neu_traits)
			if (trait in traits_to_copy)
				var/datum/trait/instance = all_traits[trait]
				if (!instance)
					continue
				for (var/to_edit in instance.var_changes)
					character.species.vars[to_edit] = instance.var_changes[to_edit]
	character.update_transform()
	if(!voice_sound)
		character.voice_sounds_list = talk_sound
	else
		character.voice_sounds_list = get_talk_sound(voice_sound)

	character.species?.blood_color = blood_color

	var/datum/species/selected_species = GLOB.all_species[species]
	var/bodytype_selected
	if(selected_species.selects_bodytype)
		bodytype_selected = custom_base
	else
		bodytype_selected = selected_species.get_bodytype(character)

	character.dna.base_species = bodytype_selected
	character.species.base_species = bodytype_selected
	character.species.vanity_base_fit = bodytype_selected
	if (istype(character.species, /datum/species/shapeshifter))
		wrapped_species_by_ref["\ref[character]"] = bodytype_selected

	character.custom_species	= custom_species
	character.custom_say		= lowertext(trim(custom_say))
	character.custom_ask		= lowertext(trim(custom_ask))
	character.custom_whisper	= lowertext(trim(custom_whisper))
	character.custom_exclaim	= lowertext(trim(custom_exclaim))

	character.digitigrade = selected_species.digi_allowed ? digitigrade : 0

	character.dna.ResetUIFrom(character)
	character.force_update_limbs()
	character.regenerate_icons()
