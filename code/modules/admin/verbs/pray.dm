/mob/verb/pray()
	set category = "IC"
	set name = "Pray"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_red("Speech is currently admin-disabled."))
		return

	var/raw_msg = sanitize(tgui_input_text(usr, "Prayers are sent to staff but do not open tickets or go to Discord. If you have a technical difficulty or an event/spice idea/hook - please ahelp instead. Thank you!", "Pray", null, MAX_MESSAGE_LEN))
	if(!raw_msg)	return

	if(usr.client)
		if(raw_msg)
			client.handle_spam_prevention(MUTE_PRAY)
			if(usr.client.prefs.muted & MUTE_PRAY)
				to_chat(usr, span_red("You cannot pray (muted)."))
				return

	var/icon/cross = icon('icons/obj/storage.dmi',"bible")
	var/msg = "<span class='filter_pray'>" + span_blue("[icon2html(cross, GLOB.admins)] <b>" + span_purple("PRAY: ") + "[key_name(src, 1)] [ADMIN_QUE(src)] [ADMIN_PP(src)] [ADMIN_VV(src)] [ADMIN_SM(src)] ([admin_jump_link(src, src)]) [ADMIN_CA(src)] [ADMIN_SC(src)] [ADMIN_SMITE(src)]:</b> [raw_msg]") + "</span>"

	for(var/client/C in GLOB.admins)
		if(!check_rights(R_ADMIN, 0, C))
			continue
		if(C.prefs?.read_preference(/datum/preference/toggle/show_chat_prayers))
			to_chat(C, msg, type = MESSAGE_TYPE_PRAYER, confidential = TRUE)
			C << 'sound/effects/ding.ogg'
	to_chat(usr, "Your prayers have been received by the gods.", confidential = TRUE)

	feedback_add_details("admin_verb","PR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	log_pray(raw_msg, src)

/proc/CentCom_announce(var/msg, var/mob/Sender, var/iamessage)
	msg = span_blue("<b>" + span_orange("[uppertext(using_map.boss_short)]M[iamessage ? " IA" : ""]:") + "[key_name(Sender, 1)] [ADMIN_PP(Sender)] [ADMIN_VV(Sender)] [ADMIN_SM(Sender)] ([admin_jump_link(Sender)]) [ADMIN_CA(Sender)] [ADMIN_BSA(Sender)] [ADMIN_CENTCOM_REPLY(Sender)]:</b> [msg]")
	for(var/client/C in GLOB.admins) //VOREStation Edit - GLOB admins
		if(!check_rights(R_ADMIN, 0, C))
			continue
		to_chat(C,msg)
		C << 'sound/machines/signal.ogg'

/proc/Syndicate_announce(var/msg, var/mob/Sender)
	msg = span_blue("<b>" + span_crimson("ILLEGAL:") + "[key_name(Sender, 1)] [ADMIN_PP(Sender)] [ADMIN_VV(Sender)] [ADMIN_SM(Sender)] ([admin_jump_link(Sender)]) [ADMIN_CA(Sender)] [ADMIN_BSA(Sender)] [ADMIN_SYNDICATE_REPLY(Sender)]:</b> [msg]")
	for(var/client/C in GLOB.admins) //VOREStation Edit - GLOB admins
		if(!check_rights(R_ADMIN, 0, C))
			continue
		to_chat(C,msg)
		C << 'sound/machines/signal.ogg'
