/mob/living/Check_Shoegrip()
	if(flying)
		return 1
	..()

/mob/living/verb/customsay()
	set category = "IC"
	set name = "Customize Speech Verbs"
	set desc = "Customize the text which appears when you type- e.g. 'says', 'asks', 'exclaims'."

	if(src.client)
		var/sayselect = tgui_alert(src, "Which say-verb do you wish to customize?", "Select Verb", list("Say","Whisper","Ask (?)","Exclaim/Shout/Yell (!)","Cancel"))

		if(sayselect == "Say")
			custom_say =  lowertext(sanitize(tgui_input_text(usr, "This word or phrase will appear instead of 'says': [src] says, \"Hi.\"", "Custom Say", null)))
		else if(sayselect == "Whisper")
			custom_whisper =  lowertext(sanitize(tgui_input_text(usr, "This word or phrase will appear instead of 'whispers': [src] whispers, \"Hi...\"", "Custom Whisper", null)))
		else if(sayselect == "Ask (?)")
			custom_ask =  lowertext(sanitize(tgui_input_text(usr, "This word or phrase will appear instead of 'asks': [src] asks, \"Hi?\"", "Custom Ask", null)))
		else if(sayselect == "Exclaim/Shout/Yell (!)")
			custom_exclaim =  lowertext(sanitize(tgui_input_text(usr, "This word or phrase will appear instead of 'exclaims', 'shouts' or 'yells': [src] exclaims, \"Hi!\"", "Custom Exclaim", null)))
		else
			return

/mob/living/verb/set_metainfo()
	set name = "Set OOC Metainfo"
	set desc = "Sets OOC notes about yourself or your RP preferences or status."
	set category = "OOC"

	var/new_metadata = sanitize(tgui_input_text(usr, "Enter any information you'd like others to see, such as Roleplay-preferences. This will not be saved permanently, only for this round.", "Game Preference" , html_decode(ooc_notes), multiline = TRUE,  prevent_enter = TRUE), extra = 0)
	if(new_metadata && CanUseTopic(usr))
		ooc_notes = new_metadata
		to_chat(usr, "OOC notes updated.")
		log_admin("[key_name(usr)] updated their OOC notes mid-round.")

/mob/living/verb/set_voice_freq()
	set name = "Set Voice Frequency"
	set desc = "Sets your voice frequency to be higher or lower pitched!"
	set category = "OOC"

	var/list/preset_voice_freqs = list("high" = MAX_VOICE_FREQ, "middle-high" = 56250, "middle" = 425000, "middle-low"= 28750, "low" = MIN_VOICE_FREQ, "custom" = 1, "random" = 0)
	var/choice = tgui_input_list(src, "What would you like to set your voice frequency to?", "Voice Frequency", preset_voice_freqs)
	if(!choice)
		return
	choice = preset_voice_freqs[choice]
	if(choice == 0)
	else if(choice == 1)
		choice = tgui_input_number(src, "Choose your character's voice frequency, ranging from [MIN_VOICE_FREQ] to [MAX_VOICE_FREQ]", "Custom Voice Frequency", null, MAX_VOICE_FREQ, MIN_VOICE_FREQ)
	else if(choice > MAX_VOICE_FREQ)
		choice = MAX_VOICE_FREQ
	else if(choice < MIN_VOICE_FREQ)
		choice = MIN_VOICE_FREQ
	voice_freq = choice
