/mob/verb/pray(msg as text)
	set category = "IC"
	set name = "Pray"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<font color='red'>Speech is currently admin-disabled.</font>")
		return

	msg = sanitize(msg)
	if(!msg)	return

	if(usr.client)
		if(msg)
			client.handle_spam_prevention(MUTE_PRAY)
			if(usr.client.prefs.muted & MUTE_PRAY)
				to_chat(usr, "<font color='red'> You cannot pray (muted).</font>")
				return

	var/icon/cross = icon('icons/obj/storage.dmi',"bible")
	msg = "<font color='blue'>\icon[cross][bicon(cross)] <b><font color=purple>PRAY: </font>[key_name(src, 1)] [ADMIN_QUE(src)] [ADMIN_PP(src)] [ADMIN_VV(src)] [ADMIN_SM(src)] ([admin_jump_link(src, src)]) [ADMIN_CA(src)] [ADMIN_SC(src)] [ADMIN_SMITE(src)]:</b> [msg]</font>"

	for(var/client/C in GLOB.admins)
		if(R_ADMIN|R_EVENT & C.holder.rights)
			if(C.is_preference_enabled(/datum/client_preference/admin/show_chat_prayers))
				to_chat(C,msg)
				C << 'sound/effects/ding.ogg'
	to_chat(usr, "Your prayers have been received by the gods.")

	feedback_add_details("admin_verb","PR") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	//log_admin("HELP: [key_name(src)]: [msg]")

/proc/CentCom_announce(var/msg, var/mob/Sender, var/iamessage)
	msg = "<font color='blue'><b><font color=orange>[uppertext(using_map.boss_short)]M[iamessage ? " IA" : ""]:</font>[key_name(Sender, 1)] [ADMIN_PP(Sender)] [ADMIN_VV(Sender)] [ADMIN_SM(Sender)] ([admin_jump_link(Sender)]) [ADMIN_CA(Sender)] [ADMIN_BSA(Sender)] [ADMIN_CENTCOM_REPLY(Sender)]:</b> [msg]</font>"
	for(var/client/C in GLOB.admins) //VOREStation Edit - GLOB admins
		if(R_ADMIN|R_EVENT & C.holder.rights)
			to_chat(C,msg)
			C << 'sound/machines/signal.ogg'

/proc/Syndicate_announce(var/msg, var/mob/Sender)
	msg = "<font color='blue'><b><font color=crimson>ILLEGAL:</font>[key_name(Sender, 1)] [ADMIN_PP(Sender)] [ADMIN_VV(Sender)] [ADMIN_SM(Sender)] ([admin_jump_link(Sender)]) [ADMIN_CA(Sender)] [ADMIN_BSA(Sender)] [ADMIN_SYNDICATE_REPLY(Sender)]:</b> [msg]</font>"
	for(var/client/C in GLOB.admins) //VOREStation Edit - GLOB admins
		if(R_ADMIN|R_EVENT & C.holder.rights)
			to_chat(C,msg)
			C << 'sound/machines/signal.ogg'
