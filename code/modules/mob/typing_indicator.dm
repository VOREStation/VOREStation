/proc/generate_speech_bubble(bubble_loc, speech_state, set_layer = FLOAT_LAYER)
	var/image/I = image('icons/mob/talk_vr.dmi', bubble_loc, speech_state, set_layer)  //VOREStation Edit - talk_vr.dmi instead of talk.dmi for right-side icons
	I.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)			//VOREStation Edit
	/*			//VOREStation Removal Start
	if(istype(bubble_loc, /atom/movable))
		var/atom/movable/AM = bubble_loc
		var/x_scale = AM.get_icon_scale_x()
		if(abs(x_scale) < 2) // reset transform on bubbles, except for the Very Large
			I.pixel_z = (AM.icon_expected_height * (x_scale-1))
			I.appearance_flags |= RESET_TRANSFORM
	*/			//VOREStation Removal Start
	return I

/mob/verb/say_wrapper()
	set name = "Say verb"
	set category = "IC"

	if(client?.prefs?.read_preference(/datum/preference/toggle/tgui_say))
		winset(src, null, "command=[client.tgui_say_create_open_command(SAY_CHANNEL)]")
		return

	client?.start_thinking()
	client?.start_typing()
	var/message = tgui_input_text(src, "Type your message:", "Say")
	client?.stop_thinking()

	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = "Me verb"
	set category = "IC"

	if(client?.prefs?.read_preference(/datum/preference/toggle/tgui_say) && client?.prefs?.read_preference(/datum/preference/toggle/tgui_say_emotes))
		winset(src, null, "command=[client.tgui_say_create_open_command(ME_CHANNEL)]")
		return

	client?.start_thinking()
	client?.start_typing()
	var/message = tgui_input_text(src, "Type your message:", "Emote", multiline = TRUE)
	client?.stop_thinking()

	if(message)
		me_verb(message)

/mob/verb/whisper_wrapper()
	set name = "Whisper verb"
	set category = "IC"

	if(client?.prefs?.read_preference(/datum/preference/toggle/tgui_say))
		winset(src, null, "command=[client.tgui_say_create_open_command(WHIS_CHANNEL)]")
		return

	if(client?.prefs?.read_preference(/datum/preference/toggle/show_typing_indicator_subtle))
		client?.start_thinking()
		client?.start_typing()
	var/message = tgui_input_text(src, "Type your message:", "Whisper")
	client?.stop_thinking()

	if(message)
		whisper(message)

/mob/verb/subtle_wrapper()
	set name = "Subtle verb"
	set category = "IC"
	set desc = "Emote to nearby people (and your pred/prey)"

	if(client?.prefs?.read_preference(/datum/preference/toggle/tgui_say) && client?.prefs?.read_preference(/datum/preference/toggle/tgui_say_emotes))
		winset(src, null, "command=[client.tgui_say_create_open_command(SUBTLE_CHANNEL)]")
		return

	if(client?.prefs?.read_preference(/datum/preference/toggle/show_typing_indicator_subtle))
		client?.start_thinking()
		client?.start_typing()
	var/message = tgui_input_text(src, "Type your message:", "Subtle", multiline = TRUE)
	client?.stop_thinking()

	if(message)
		me_verb_subtle(message)
