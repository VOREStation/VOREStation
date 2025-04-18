/client/proc/change_human_appearance_admin()
	set name = "Change Mob Appearance - Admin"
	set desc = "Allows you to change the mob appearance"
	set category = "Admin.Events"

	if(!check_rights(R_FUN)) return

	var/mob/living/carbon/human/H = tgui_input_list(usr, "Select mob.", "Change Mob Appearance - Admin", human_mob_list)
	if(!H) return

	log_and_message_admins("is altering the appearance of [H].")
	H.change_appearance(APPEARANCE_ALL, usr, check_species_whitelist = 0, state = GLOB.tgui_admin_state)
	feedback_add_details("admin_verb","CHAA") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/change_human_appearance_self()
	set name = "Change Mob Appearance - Self"
	set desc = "Allows the mob to change its appearance"
	set category = "Admin.Events"

	if(!check_rights(R_FUN)) return

	var/mob/living/carbon/human/H = tgui_input_list(usr, "Select mob.", "Change Mob Appearance - Self", human_mob_list)
	if(!H) return

	if(!H.client)
		to_chat(usr, span_filter_warning(" Only mobs with clients can alter their own appearance."))
		return
	var/datum/gender/T = GLOB.gender_datums[H.get_visible_gender()]
	switch(tgui_alert(usr, "Do you wish for [H] to be allowed to select non-whitelisted races?","Alter Mob Appearance","Yes","No","Cancel"))
		if("Yes")
			log_and_message_admins("has allowed [H] to change [T.his] appearance, without whitelisting of races.")
			H.change_appearance(APPEARANCE_ALL, H, check_species_whitelist = 0)
		if("No")
			log_and_message_admins("has allowed [H] to change [T.his] appearance, with whitelisting of races.")
			H.change_appearance(APPEARANCE_ALL, H, check_species_whitelist = 1)
	feedback_add_details("admin_verb","CMAS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/editappear()
	set name = "Edit Appearance"
	set category = "Fun.Event Kit"

	if(!check_rights(R_FUN))	return

	var/mob/living/carbon/human/M = tgui_input_list(usr, "Select mob.", "Edit Appearance", human_mob_list)

	if(!ishuman(M))
		to_chat(usr, span_warning("You can only do this to humans!"))
		return
	if(tgui_alert(usr, "Are you sure you wish to edit this mob's appearance? Skrell, Unathi, Tajaran can result in unintended consequences.","Danger!",list("Yes","No")) != "Yes")
		return
	var/new_facial = tgui_color_picker(usr, "Please select facial hair color.", "Character Generation")
	if(new_facial)
		M.r_facial = hex2num(copytext(new_facial, 2, 4))
		M.g_facial = hex2num(copytext(new_facial, 4, 6))
		M.b_facial = hex2num(copytext(new_facial, 6, 8))

	var/new_hair = tgui_color_picker(usr, "Please select hair color.", "Character Generation")
	if(new_facial)
		M.r_hair = hex2num(copytext(new_hair, 2, 4))
		M.g_hair = hex2num(copytext(new_hair, 4, 6))
		M.b_hair = hex2num(copytext(new_hair, 6, 8))

	var/new_eyes = tgui_color_picker(usr, "Please select eye color.", "Character Generation")
	if(new_eyes)
		M.r_eyes = hex2num(copytext(new_eyes, 2, 4))
		M.g_eyes = hex2num(copytext(new_eyes, 4, 6))
		M.b_eyes = hex2num(copytext(new_eyes, 6, 8))
		M.update_eyes()

	var/new_skin = tgui_color_picker(usr, "Please select body color. This is for Tajaran, Unathi, and Skrell only!", "Character Generation")
	if(new_skin)
		M.r_skin = hex2num(copytext(new_skin, 2, 4))
		M.g_skin = hex2num(copytext(new_skin, 4, 6))
		M.b_skin = hex2num(copytext(new_skin, 6, 8))

	var/new_tone = tgui_input_number(usr, "Please select skin tone level: 1-220 (1=albino, 35=caucasian, 150=black, 220='very' black)", "Character Generation", null, 220, 1)

	if (new_tone)
		M.s_tone = max(min(round(text2num(new_tone)), 220), 1)
		M.s_tone =  -M.s_tone + 35

	// hair
	var/new_hstyle = tgui_input_list(usr, "Select a hair style", "Grooming", hair_styles_list)
	if(new_hstyle)
		M.h_style = new_hstyle

	// facial hair
	var/new_fstyle = tgui_input_list(usr, "Select a facial hair style", "Grooming", facial_hair_styles_list)
	if(new_fstyle)
		M.f_style = new_fstyle

	var/new_gender = tgui_alert(usr, "Please select gender.", "Character Generation", list("Male", "Female", "Neuter"))
	if (new_gender)
		M.set_gender(new_gender)

	M.update_dna(M)
	M.update_hair(FALSE)
	M.update_icons_body()
