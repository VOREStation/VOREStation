/mob/living/verb/customsay()
	set category = "IC"
	set name = "Customise Speech Verbs"
	set desc = "Customise the text which appears when you type- e.g. 'says', 'asks', 'exclaims'."

	if(src.client)
		var/customsaylist[] = list(
				"Say",
				"Whisper",
				"Ask (?)",
				"Exclaim/Shout/Yell (!)",
				"Cancel"
			)
		var/sayselect = input("Which say-verb do you wish to customise?") as null|anything in customsaylist //we can't use alert() for this because there's too many terms

		if(sayselect == "Say")
			custom_say =  sanitize(input(usr, "This word or phrase will appear instead of 'says': [src] says, \"Hi.\"", "Custom Say", null)  as text)
		else if(sayselect == "Whisper")
			custom_whisper =  sanitize(input(usr, "This word or phrase will appear instead of 'whispers': [src] whispers, \"Hi...\"", "Custom Whisper", null)  as text)
		else if(sayselect == "Ask (?)")
			custom_ask =  sanitize(input(usr, "This word or phrase will appear instead of 'asks': [src] asks, \"Hi?\"", "Custom Ask", null)  as text)
		else if(sayselect == "Exclaim/Shout/Yell (!)")
			custom_exclaim =  sanitize(input(usr, "This word or phrase will appear instead of 'exclaims', 'shouts' or 'yells': [src] exclaims, \"Hi!\"", "Custom Exclaim", null)  as text)
		else
			return
