// At minimum every mob has a hear_say proc.

/mob/proc/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(!client && !teleop)
		return

	if(speaker && !speaker.client && istype(src,/mob/observer/dead) && is_preference_enabled(/datum/client_preference/ghost_ears) && !(speaker in view(src)))
			//Does the speaker have a client?  It's either random stuff that observers won't care about (Experiment 97B says, 'EHEHEHEHEHEHEHE')
			//Or someone snoring.  So we make it where they won't hear it.
		return

	//make sure the air can transmit speech - hearer's side
	var/turf/T = get_turf(src)
	if ((T) && (!(istype(src, /mob/observer/dead)))) //Ghosts can hear even in vacuum.
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = (environment)? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE && get_dist(speaker, src) > 1)
			return

		if (pressure < ONE_ATMOSPHERE*0.4) //sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
			italics = 1
			sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact

	if(sleeping || stat == 1)
		hear_sleep(message)
		return

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if (language && (language.flags & NONVERBAL))
		if (!speaker || (src.sdisabilities & BLIND || src.blinded) || !(speaker in view(src)))
			message = stars(message)

	if(!(language && (language.flags & INNATE))) // skip understanding checks for INNATE languages
		if(!say_understands(speaker,language))
			if(language)
				message = language.scramble(message)
			else
				message = stars(message)

	var/speaker_name = speaker.name
	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.GetVoice()

	if(italics)
		message = "<i>[message]</i>"

	message = say_emphasis(message)

	var/track = null
	if(istype(src, /mob/observer/dead))
		if(italics && is_preference_enabled(/datum/client_preference/ghost_radio))
			return
		if(speaker_name != speaker.real_name && speaker.real_name)
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "([ghost_follow_link(speaker, src)]) "
		if(is_preference_enabled(/datum/client_preference/ghost_ears) && (speaker in view(src)))
			message = "<b>[message]</b>"

	if(is_deaf())
		if(!language || !(language.flags & INNATE)) // INNATE is the flag for audible-emote-language, so we don't want to show an "x talks but you cannot hear them" message if it's set
			if(speaker == src)
				src << "<span class='warning'>You cannot hear yourself speak!</span>"
			else
				src << "<span class='name'>[speaker_name]</span>[alt_name] talks but you cannot hear."
	else
		var/message_to_send = null
		if(language)
			message_to_send = "<span class='game say'><span class='name'>[speaker_name]</span>[alt_name] [track][language.format_message(message, verb)]</span>"
		else
			message_to_send = "<span class='game say'><span class='name'>[speaker_name]</span>[alt_name] [track][verb], <span class='message'><span class='body'>\"[message]\"</span></span></span>"
		if(check_mentioned(message) && is_preference_enabled(/datum/client_preference/check_mention))
			message_to_send = "<font size='3'><b>[message_to_send]</b></font>"

		on_hear_say(message_to_send)

		if (speech_sound && (get_dist(speaker, src) <= world.view && src.z == speaker.z))
			var/turf/source = speaker? get_turf(speaker) : get_turf(src)
			src.playsound_local(source, speech_sound, sound_vol, 1)

/mob/proc/on_hear_say(var/message)
	to_chat(src, message)
	if(teleop)
		to_chat(teleop, create_text_tag("body", "BODY:", teleop) + "[message]")

/mob/living/silicon/on_hear_say(var/message)
	var/time = say_timestamp()
	to_chat(src, "[time] [message]")
	if(teleop)
		to_chat(teleop, create_text_tag("body", "BODY:", teleop) + "[time] [message]")

// Checks if the mob's own name is included inside message.  Handles both first and last names.
/mob/proc/check_mentioned(var/message)
	var/not_included = list("a", "the", "of", "in", "for", "through", "throughout", "therefore", "here", "there", "then", "now", "I", "you", "they", "he", "she", "by")
	var/list/valid_names = splittext(real_name, " ") // Should output list("John", "Doe") as an example.
	valid_names -= not_included
	var/list/nicknames = splittext(nickname, " ")
	valid_names += nicknames
	valid_names += special_mentions()
	for(var/name in valid_names)
		if(findtext(message, regex("\\b[name]\\b", "i"))) // This is to stop 'ai' from triggering if someone says 'wait'.
			return TRUE
	return FALSE

// Override this if you want something besides the mob's name to count for being mentioned in check_mentioned().
/mob/proc/special_mentions()
	return list()

/mob/living/silicon/ai/special_mentions()
	return list("AI") // AI door!

// Converts specific characters, like +, |, and _ to formatted output.
/mob/proc/say_emphasis(var/message)
	message = encode_html_emphasis(message, "|", "i")
	message = encode_html_emphasis(message, "+", "b")
	message = encode_html_emphasis(message, "_", "u")
	return message

// Replaces a character inside message with html tags.  Note that html var must not include brackets.
// Will not create an open html tag if it would not have a closing one.
/proc/encode_html_emphasis(var/message, var/char, var/html)
	var/i = 20 // Infinite loop safety.
	var/pattern = "(?<!<)\\" + char
	var/regex/re = regex(pattern,"i") // This matches results which do not have a < next to them, to avoid stripping slashes from closing html tags.
	var/first = re.Find(message) // Find first occurance.
	var/second = re.Find(message, first + 1) // Then the second.
	while(first && second && i)
		// Calculate how far foward the second char is, as the first replacetext() will displace it.
		var/length_increase = length("<[html]>") - 1

		// Now replace both.
		message = replacetext(message, char, "<[html]>", first, first + 1)
		message = replacetext(message, char, "</[html]>", second + length_increase, second + length_increase + 1)

		// Check again to see if we need to keep going.
		first = re.Find(message)
		second = re.Find(message, first + 1)
		i--
	if(!i)
		CRASH("Possible infinite loop occured in encode_html_emphasis().")
	return message

/mob/proc/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/part_c, var/mob/speaker = null, var/hard_to_hear = 0, var/vname ="")

	if(!client)
		return

	if(sleeping || stat==1) //If unconscious or sleeping
		hear_sleep(message)
		return

	var/track = null

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if (language && (language.flags & NONVERBAL))
		if (!speaker || (src.sdisabilities & BLIND || src.blinded) || !(speaker in view(src)))
			message = stars(message)

	if(!(language && (language.flags & INNATE))) // skip understanding checks for INNATE languages
		if(!say_understands(speaker,language))
			if(istype(speaker,/mob/living/simple_animal))
				var/mob/living/simple_animal/S = speaker
				if(S.speak && S.speak.len)
					message = pick(S.speak)
				else
					return
			else
				if(language)
					message = language.scramble(message)
				else
					message = stars(message)

		if(hard_to_hear)
			message = stars(message)

	var/speaker_name = speaker.name

	if(vname)
		speaker_name = vname

	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		if(H.voice)
			speaker_name = H.voice

	if(hard_to_hear)
		speaker_name = "unknown"

	var/changed_voice

	if(istype(src, /mob/living/silicon/ai) && !hard_to_hear)
		var/jobname // the mob's "job"
		var/mob/living/carbon/human/impersonating //The crew member being impersonated, if any.

		if (ishuman(speaker))
			var/mob/living/carbon/human/H = speaker

			if(H.wear_mask && istype(H.wear_mask,/obj/item/clothing/mask/gas/voice))
				changed_voice = 1
				var/list/impersonated = new()
				var/mob/living/carbon/human/I = impersonated[speaker_name]

				if(!I)
					for(var/mob/living/carbon/human/M in mob_list)
						if(M.real_name == speaker_name)
							I = M
							impersonated[speaker_name] = I
							break

				// If I's display name is currently different from the voice name and using an agent ID then don't impersonate
				// as this would allow the AI to track I and realize the mismatch.
				if(I && !(I.name != speaker_name && I.wear_id && istype(I.wear_id,/obj/item/weapon/card/id/syndicate)))
					impersonating = I
					jobname = impersonating.get_assignment()
				else
					jobname = "Unknown"
			else
				jobname = H.get_assignment()

		else if (iscarbon(speaker)) // Nonhuman carbon mob
			jobname = "No id"
		else if (isAI(speaker))
			jobname = "AI"
		else if (isrobot(speaker))
			jobname = "Cyborg"
		else if (istype(speaker, /mob/living/silicon/pai))
			jobname = "Personal AI"
		else
			jobname = "Unknown"

		if(changed_voice)
			if(impersonating)
				track = "<a href='byond://?src=\ref[src];trackname=[html_encode(speaker_name)];track=\ref[impersonating]'>[speaker_name] ([jobname])</a>"
			else
				track = "[speaker_name] ([jobname])"
		else
			track = "<a href='byond://?src=\ref[src];trackname=[html_encode(speaker_name)];track=\ref[speaker]'>[speaker_name] ([jobname])</a>"

	if(istype(src, /mob/observer/dead))
		if(speaker_name != speaker.real_name && !isAI(speaker)) //Announce computer and various stuff that broadcasts doesn't use it's real name but AI's can't pretend to be other mobs.
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "[speaker_name] ([ghost_follow_link(speaker, src)])"

	message = say_emphasis(message)

	var/formatted
	if(language)
		formatted = "[language.format_message_radio(message, verb)][part_c]"
	else
		formatted = "[verb], <span class=\"body\">\"[message]\"</span>[part_c]"


	if((sdisabilities & DEAF) || ear_deaf)
		if(prob(20))
			src << "<span class='warning'>You feel your headset vibrate but can hear nothing from it!</span>"
	else
		on_hear_radio(part_a, speaker_name, track, part_b, formatted)

/proc/say_timestamp()
	return "<span class='say_quote'>\[[stationtime2text()]\]</span>"

/mob/proc/on_hear_radio(part_a, speaker_name, track, part_b, formatted)
	var/final_message = "[part_a][speaker_name][part_b][formatted]"
	if(check_mentioned(formatted) && is_preference_enabled(/datum/client_preference/check_mention))
		final_message = "<font size='3'><b>[final_message]</b></font>"
	to_chat(src, final_message)

/mob/observer/dead/on_hear_radio(part_a, speaker_name, track, part_b, formatted)
	var/final_message = "[part_a][track][part_b][formatted]"
	if(check_mentioned(formatted) && is_preference_enabled(/datum/client_preference/check_mention))
		final_message = "<font size='3'><b>[final_message]</b></font>"
	to_chat(src, final_message)

/mob/living/silicon/on_hear_radio(part_a, speaker_name, track, part_b, formatted)
	var/time = say_timestamp()
	var/final_message = "[part_a][speaker_name][part_b][formatted]"
	if(check_mentioned(formatted) && is_preference_enabled(/datum/client_preference/check_mention))
		final_message = "[time]<font size='3'><b>[final_message]</b></font>"
	to_chat(src, final_message)

/mob/living/silicon/ai/on_hear_radio(part_a, speaker_name, track, part_b, formatted)
	var/time = say_timestamp()
	var/final_message = "[part_a][track][part_b][formatted]"
	if(check_mentioned(formatted) && is_preference_enabled(/datum/client_preference/check_mention))
		final_message = "[time]<font size='3'><b>[final_message]</b></font>"
	to_chat(src, final_message)

/mob/proc/hear_signlang(var/message, var/verb = "gestures", var/datum/language/language, var/mob/speaker = null)
	if(!client)
		return

	if(say_understands(speaker, language))
		message = "<B>[speaker]</B> [verb], \"[message]\""
	else
		var/adverb
		var/length = length(message) * pick(0.8, 0.9, 1.0, 1.1, 1.2)	//Adds a little bit of fuzziness
		switch(length)
			if(0 to 12)		adverb = " briefly"
			if(12 to 30)	adverb = " a short message"
			if(30 to 48)	adverb = " a message"
			if(48 to 90)	adverb = " a lengthy message"
			else			adverb = " a very lengthy message"
		message = "<B>[speaker]</B> [verb][adverb]."

	if(src.status_flags & PASSEMOTES)
		for(var/obj/item/weapon/holder/H in src.contents)
			H.show_message(message)
		for(var/mob/living/M in src.contents)
			M.show_message(message)
	src.show_message(message)

/mob/proc/hear_sleep(var/message)
	var/heard = ""
	if(prob(15))
		var/list/punctuation = list(",", "!", ".", ";", "?")
		var/list/messages = splittext(message, " ")
		var/R = rand(1, messages.len)
		var/heardword = messages[R]
		if(copytext(heardword,1, 1) in punctuation)
			heardword = copytext(heardword,2)
		if(copytext(heardword,-1) in punctuation)
			heardword = copytext(heardword,1,lentext(heardword))
		heard = "<span class = 'game_say'>...You hear something about...[heardword]</span>"

	else
		heard = "<span class = 'game_say'>...<i>You almost hear someone talking</i>...</span>"

	src << heard
