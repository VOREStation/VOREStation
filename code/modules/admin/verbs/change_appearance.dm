ADMIN_VERB(change_human_appearance_admin, R_FUN, "Change Mob Appearance - Admin", "Allows you to change the mob appearance.", ADMIN_CATEGORY_EVENTS)
	var/mob/living/carbon/human/target_human = tgui_input_list(user, "Select mob.", "Change Mob Appearance - Admin", GLOB.human_mob_list)
	if(!target_human)
		return

	log_and_message_admins("is altering the appearance of [target_human].")
	target_human.change_appearance(APPEARANCE_ALL, usr, check_species_whitelist = 0, state = ADMIN_STATE(R_FUN))
	feedback_add_details("admin_verb","CHAA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(change_human_appearance_self, R_FUN, "Change Mob Appearance - Self", "Allows the mob to change its appearance.", ADMIN_CATEGORY_EVENTS)
	var/mob/living/carbon/human/human_target = tgui_input_list(user, "Select mob.", "Change Mob Appearance - Self", GLOB.human_mob_list)
	if(!human_target)
		return

	if(!human_target.client)
		to_chat(human_target, span_filter_warning("Only mobs with clients can alter their own appearance."))
		return
	switch(tgui_alert(user, "Do you wish for [human_target] to be allowed to select non-whitelisted races?","Alter Mob Appearance","Yes","No","Cancel"))
		if("Yes")
			log_and_message_admins("has allowed [human_target] to change [human_target.p_their()] appearance, without whitelisting of races.")
			human_target.change_appearance(APPEARANCE_ALL, human_target, check_species_whitelist = 0)
		if("No")
			log_and_message_admins("has allowed [human_target] to change [human_target.p_their()] appearance, with whitelisting of races.")
			human_target.change_appearance(APPEARANCE_ALL, human_target, check_species_whitelist = 1)
	feedback_add_details("admin_verb","CMAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

ADMIN_VERB(editappear, R_FUN, "Edit Appearance", "Edit a human's apperance.", ADMIN_CATEGORY_FUN_EVENT_KIT)
	var/mob/living/carbon/human/target_human = tgui_input_list(user, "Select mob.", "Edit Appearance", GLOB.human_mob_list)

	if(!ishuman(target_human))
		to_chat(user, span_warning("You can only do this to humans!"))
		return
	if(tgui_alert(user, "Are you sure you wish to edit this mob's appearance? Skrell, Unathi, Tajaran can result in unintended consequences.","Danger!",list("Yes","No")) != "Yes")
		return
	var/new_facial = tgui_color_picker(user, "Please select facial hair color.", "Character Generation")
	if(new_facial)
		target_human.r_facial = hex2num(copytext(new_facial, 2, 4))
		target_human.g_facial = hex2num(copytext(new_facial, 4, 6))
		target_human.b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = tgui_color_picker(user, "Please select hair color.", "Character Generation")
	if(new_facial)
		target_human.r_hair = hex2num(copytext(new_hair, 2, 4))
		target_human.g_hair = hex2num(copytext(new_hair, 4, 6))
		target_human.b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = tgui_color_picker(user, "Please select eye color.", "Character Generation")
	if(new_eyes)
		target_human.r_eyes = hex2num(copytext(new_eyes, 2, 4))
		target_human.g_eyes = hex2num(copytext(new_eyes, 4, 6))
		target_human.b_eyes = hex2num(copytext(new_eyes, 6, 8))
		target_human.update_eyes()

	var/new_skin = tgui_color_picker(user, "Please select body color. This is for Tajaran, Unathi, and Skrell only!", "Character Generation")
	if(new_skin)
		target_human.r_skin = hex2num(copytext(new_skin, 2, 4))
		target_human.g_skin = hex2num(copytext(new_skin, 4, 6))
		target_human.b_skin = hex2num(copytext(new_skin, 6, 8))

	var/new_tone = tgui_input_number(user, "Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation", null, 220, 1)

	if (new_tone)
		target_human.s_tone = max(min(round(text2num(new_tone)), 220), 1)
		target_human.s_tone =  -target_human.s_tone + 35

	// hair
	var/new_hstyle = tgui_input_list(user, "Select a hair style", "Grooming", GLOB.hair_styles_list)
	if(new_hstyle)
		target_human.h_style = new_hstyle

	// facial hair
	var/new_fstyle = tgui_input_list(user, "Select a facial hair style", "Grooming", GLOB.facial_hair_styles_list)
	if(new_fstyle)
		target_human.f_style = new_fstyle

	var/new_gender = tgui_alert(user, "Please select gender.", "Character Generation", list("Male", "Female", "Neuter"))
	if (new_gender)
		target_human.set_gender(new_gender)

	target_human.update_dna(target_human)
	target_human.update_hair(FALSE)
	target_human.update_icons_body()
