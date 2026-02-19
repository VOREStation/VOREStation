/// Change currently viewed camera
/mob/living/silicon/pai/proc/switchCamera(var/obj/machinery/camera/C)
	if (!C)
		src.reset_perspective()
		return 0
	if (stat == 2 || !C.status || !(src.network in C.network)) return 0

	// ok, we're alive, camera is good and in our network...
	src.current = C
	src.AddComponent(/datum/component/remote_view, focused_on = C, viewsize = null, vconfig_path = /datum/remote_view_config/camera_standard)
	return 1

/mob/living/silicon/pai/cancel_camera()
	set category = "Abilities.pAI Commands"
	set name = "Cancel Camera View"
	reset_perspective()

/mob/living/silicon/pai/reset_perspective(atom/new_eye)
	. = ..()
	current = null

/mob/living/silicon/pai/verb/reset_record_view()
	set category = "Abilities.pAI Commands"
	set name = "Reset Records Software"

	securityActive1 = null
	securityActive2 = null
	security_cannotfind = 0
	medicalActive1 = null
	medicalActive2 = null
	medical_cannotfind = 0
	SStgui.update_uis(src)
	to_chat(src, span_notice("You reset your record-viewing software."))

/mob/living/silicon/pai/proc/choose_verbs()
	set category = "Abilities.pAI Commands"
	set name = "Choose Speech Verbs"

	var/choice = tgui_input_list(src,"What theme would you like to use for your speech verbs?","Theme Choice", GLOB.possible_say_verbs)
	if(!choice) return

	var/list/sayverbs = GLOB.possible_say_verbs[choice]
	speak_statement = sayverbs[1]
	speak_exclamation = sayverbs[(sayverbs.len>1 ? 2 : sayverbs.len)]
	speak_query = sayverbs[(sayverbs.len>2 ? 3 : sayverbs.len)]

/mob/living/silicon/pai/verb/allowmodification()
	set name = "Change Access Modifcation Permission"
	set category = "Abilities.pAI Commands"
	set desc = "Allows people to modify your access or block people from modifying your access."

	if(idaccessible == 0)
		idaccessible = 1
		visible_message(span_notice("\The [src] clicks as their access modification slot opens."),span_notice("You allow access modifications."), runemessage = "click")
	else
		idaccessible = 0
		visible_message(span_notice("\The [src] clicks as their access modification slot closes."),span_notice("You block access modfications."), runemessage = "click")

/mob/living/silicon/pai/verb/toggle_gender_identity_vr()
	set name = "Set Gender Identity"
	set desc = "Sets the pronouns when examined and performing an emote."
	set category = "IC.Settings"
	var/new_gender_identity = tgui_input_list(src, "Please select a gender Identity:", "Set Gender Identity", list(FEMALE, MALE, NEUTER, PLURAL, HERM))
	if(!new_gender_identity)
		return 0
	gender = new_gender_identity
	return 1

/mob/living/silicon/pai/verb/pai_hide()
	set name = "Hide"
	set desc = "Allows to hide beneath tables or certain items. Toggled on or off."
	set category = "Abilities.pAI"

	hide()
	if(status_flags & HIDING)
		hide_glow = TRUE
	else
		hide_glow = FALSE
	update_icon()

/mob/living/silicon/pai/verb/screen_message(message as text|null)
	set category = "Abilities.pAI Commands"
	set name = "Screen Message"
	set desc = "Allows you to display a message on your screen. This will show up in the chat of anyone who is holding your card."

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, span_warning("You cannot speak in IC (muted)."))
			return
	if(loc != card)
		to_chat(src, span_warning("Your message won't be visible while unfolded!"))
	if (!message)
		message = tgui_input_text(src, "Enter text you would like to show on your screen.","Screen Message", encode = FALSE)
	message = sanitize_or_reflect(message,src)
	if (!message)
		return
	message = capitalize(message)
	if (stat == DEAD)
		return
	card.screen_msg = message
	var/logmsg = "(CARD SCREEN)[message]"
	log_talk(logmsg, LOG_SAY)
	to_chat(src, span_filter_say(span_cult("You print a message to your screen, \"[message]\"")))
	if(isliving(card.loc))
		var/mob/living/L = card.loc
		if(L.client)
			to_chat(L, span_filter_say(span_cult("[src.name]'s screen prints, \"[message]\"")))
		else return
	else if(isbelly(card.loc))
		var/obj/belly/b = card.loc
		if(b.owner.client)
			to_chat(b.owner, span_filter_say(span_cult("[src.name]'s screen prints, \"[message]\"")))
		else return
	else if(istype(card.loc, /obj/item/pda))
		var/obj/item/pda/p = card.loc
		if(isliving(p.loc))
			var/mob/living/L = p.loc
			if(L.client)
				to_chat(L, span_filter_say(span_cult("[src.name]'s screen prints, \"[message]\"")))
			else return
		else if(isbelly(p.loc))
			var/obj/belly/b = card.loc
			if(b.owner.client)
				to_chat(b.owner, span_filter_say(span_cult("[src.name]'s screen prints, \"[message]\"")))
			else return
		else return
	else return
	to_chat(src, span_notice("Your message was relayed."))
	for (var/mob/G in GLOB.player_list)
		if (isnewplayer(G))
			continue
		else if(isobserver(G) && G.client?.prefs?.read_preference(/datum/preference/toggle/ghost_ears))
			if((client?.prefs?.read_preference(/datum/preference/toggle/whisubtle_vis) || check_rights_for(G.client, R_HOLDER)) && \
			G.client?.prefs?.read_preference(/datum/preference/toggle/ghost_see_whisubtle))
				to_chat(G, span_filter_say(span_cult("[src.name]'s screen prints, \"[message]\"")))

/mob/living/silicon/pai/proc/pai_nom(var/mob/living/T in oview(1))
	set name = "pAI Nom"
	set category = "Abilities.pAI Commands"
	set desc = "Allows you to eat someone while unfolded. Can't be used while in card form."

	if (stat != CONSCIOUS)
		return
	return feed_grabbed_to_self(src,T)

/mob/living/silicon/pai/verb/toggle_eyeglow()
	set category = "Abilities.pAI Commands"
	set name = "Toggle Eye Glow"

	if(!SSpai.chassis_data(chassis_name).has_eye_color)
		to_chat(src, span_filter_notice("Your selected chassis cannot modify its eye glow!"))
		return

	if(eye_glow && !hide_glow)
		eye_glow = FALSE
	else
		eye_glow = TRUE
		hide_glow = FALSE
	update_icon()

/mob/living/silicon/pai/verb/pick_eye_color()
	set category = "Abilities.pAI Commands"
	set name = "Pick Eye Color"

	if(!SSpai.chassis_data(chassis_name).has_eye_color)
		to_chat(src, span_warning("Your selected chassis eye color can not be modified. The color you pick will only apply to supporting chassis and your card screen."))
		return

	var/new_eye_color = tgui_color_picker(src, "Choose your character's eye color:", "Eye Color")
	if(new_eye_color)
		eye_color = new_eye_color
		update_icon()
		card.setEmotion(card.current_emotion)

/mob/living/silicon/pai/proc/hug(var/mob/living/silicon/pai/H, var/mob/living/target)

	var/t_him = "them"
	if(ishuman(target))
		var/mob/living/carbon/human/T = target
		switch(T.identifying_gender)
			if(MALE)
				t_him = "him"
			if(FEMALE)
				t_him = "her"
			if(NEUTER)
				t_him = "it"
			if(HERM)
				t_him = "hir"
			else
				t_him = "them"
	else
		switch(target.gender)
			if(MALE)
				t_him = "him"
			if(FEMALE)
				t_him = "her"
			if(NEUTER)
				t_him = "it"
			if(HERM)
				t_him = "hir"
			else
				t_him = "them"

	if(H.zone_sel.selecting == BP_HEAD)
		H.visible_message( \
			span_notice("[H] pats [target] on the head."), \
			span_notice("You pat [target] on the head."), )
	else if(H.zone_sel.selecting == BP_R_HAND || H.zone_sel.selecting == BP_L_HAND)
		H.visible_message( \
			span_notice("[H] shakes [target]'s hand."), \
			span_notice("You shake [target]'s hand."), )
	else if(H.zone_sel.selecting == "mouth")
		H.visible_message( \
			span_notice("[H] boops [target]'s nose."), \
			span_notice("You boop [target] on the nose."), )
	else
		H.visible_message(span_notice("[H] hugs [target] to make [t_him] feel better!"), \
						span_notice("You hug [target] to make [t_him] feel better!"))
	playsound(src, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
