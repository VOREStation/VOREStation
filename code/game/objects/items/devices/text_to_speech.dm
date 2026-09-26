/obj/item/text_to_speech
	name = "TTS device"
	desc = "A device that speaks an inputted message. Given to crew which can not speak properly or at all."
	icon = 'icons/obj/integrated_electronics/electronic_setups.dmi'
	icon_state = "setup_small"
	w_class = ITEMSIZE_SMALL
	var/named

/obj/item/text_to_speech/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(user.incapacitated(INCAPACITATION_DISABLED)) // EDIT: We can use the device only if we are not in certain types of incapacitation. We don't want chairs stopping us from texting!!
		to_chat(user, "You cannot activate the device in your state.")
		return

	if(!named)
		to_chat(user, "You input your name into the device.")
		name = "[initial(name)] ([user.real_name])"
		desc = "[initial(desc)] This one is assigned to [user.real_name]."
		named = 1
		/* //Another way of naming the device. Gives more freedom, but could lead to issues.
		device_name = tgui_input_text(user, "What would you like to name your device? You must input a name before the device can be used.", "Name your device", "", MAX_NAME_LEN)
		if(!device_name)
			return
		name = "[initial(name)] - [device_name]"
		named = 1
		*/

	user.client?.start_thinking()
	user.client?.start_typing()
	var/message = tgui_input_text(user,"Choose a message to relay to those around you.", "", "", MAX_MESSAGE_LEN)
	user.client?.stop_thinking()
	send_tts(message, user)

/obj/item/text_to_speech/proc/send_tts(message, mob/user)
	if(!message)
		return
	audible_message("[icon2html(src, user.client)] \The [src.name] states, \"[message]\"", runemessage = "synthesized speech")
	if(ismob(loc))
		loc.runechat_message("\[TTS Voice\] [message]")

/obj/item/text_to_speech/click_alt(mob/user) // QOL Change
	attack_self(user)

/obj/item/text_to_speech/equipped(mob/user)
	. = ..()
	RegisterSignal(user, COMSIG_MOB_SAY_PREPARE, PROC_REF(handle_prepare_say))

/obj/item/text_to_speech/dropped(mob/user, equipping, slot)
	. = ..()
	UnregisterSignal(user, COMSIG_MOB_SAY_PREPARE)

/obj/item/text_to_speech/proc/handle_prepare_say(atom/source, list/message_pieces, datum/language/speaking, message, whispering, message_mode)
	SIGNAL_HANDLER
	if(message_mode) // Ignore TTS if trying to use the radio
		return
	if(loc != source || !isliving(source))
		return
	var/mob/living/my_mob = source
	if(src != my_mob.get_active_hand())
		return

	send_tts(message, my_mob)
	return COMSIG_SAY_FORBID_SPEAK // We don't want to speak at all if the TTS is actively being used
