// At minimum every mob has a hear_say proc.
/mob/proc/combine_message(var/list/message_pieces, var/verb, var/mob/speaker, always_stars = FALSE, var/radio = FALSE)
	var/iteration_count = 0
	var/msg = "" // This is to make sure that the pieces have actually added something
	var/raw_msg = ""
	. = list("formatted" = "[verb], \"", "raw" = "")

	for(var/datum/multilingual_say_piece/SP in message_pieces)
		iteration_count++
		var/piece = SP.message
		if(piece == "")
			continue

		if(SP.speaking && SP.speaking.flags & INNATE) // Snowflake for noise lang
			if(radio)
				.["formatted"] = SP.speaking.format_message_radio(piece)
				.["raw"] = piece
				return
			else
				.["formatted"] = SP.speaking.format_message(piece)
				.["raw"] = piece
				return

		if(iteration_count == 1)
			piece = capitalize_utf(piece)

		if(always_stars)
			piece = stars(piece)
		else if(!say_understands(speaker, SP.speaking))
			if(SP.speaking.flags & INAUDIBLE)
				piece = ""
			else
				piece = saypiece_scramble(SP)
				if(isliving(speaker))
					var/mob/living/S = speaker
					if(istype(S.say_list) && length(S.say_list.speak))
						piece = pick(S.say_list.speak)

		raw_msg += (piece + " ")

		if(!speaker.client)
			piece = "<span class='npcsay'>[piece]</span>"

		//HTML formatting
		if(!SP.speaking) // Catch the most generic case first
			piece = "<span class='message body'>[piece]</span>"
		else if(radio) // SP.speaking == TRUE enforced by previous !SP.speaking
			piece = SP.speaking.format_message_radio(piece)
		else // SP.speaking == TRUE && radio == FALSE
			piece = SP.speaking.format_message(piece)

		msg += (piece + " ")

	if(msg == "")
		// There is literally no content left in this message, we need to shut this shit down
		.["formatted"] = "" // hear_say will suppress it
	else
		.["formatted"] = trim(.["formatted"] + trim(msg))
		.["formatted"] += "\""
		.["raw"] = trim(raw_msg)

/mob/proc/saypiece_scramble(datum/multilingual_say_piece/SP)
	if(SP.speaking)
		return SP.speaking.scramble(SP.message)
	else
		return stars(SP.message)

/mob/proc/hear_say(var/list/message_pieces, var/verb = "says", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(!client && !teleop)
		return FALSE

	if(isobserver(src) && is_preference_enabled(/datum/client_preference/ghost_ears))
		if(speaker && !speaker.client && !(speaker in view(src)))
			//Does the speaker have a client?  It's either random stuff that observers won't care about (Experiment 97B says, 'EHEHEHEHEHEHEHE')
			//Or someone snoring.  So we make it where they won't hear it.
			return FALSE

	//make sure the air can transmit speech - hearer's side
	var/turf/T = get_turf(src)
	if(T && !isobserver(src)) //Ghosts can hear even in vacuum.
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = environment ? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE && get_dist(speaker, src) > 1)
			return FALSE

		if(pressure < ONE_ATMOSPHERE * 0.4) //sound distortion pressure, to help clue people in that the air is thin, even if it isn't a vacuum yet
			italics = 1
			sound_vol *= 0.5 //muffle the sound a bit, so it's like we're actually talking through contact

	var/speaker_name = speaker.name
	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.GetVoice()

	var/list/combined = combine_message(message_pieces, verb, speaker)
	var/message = combined["formatted"]
	if(message == "")
		return FALSE

	if(sleeping || stat == UNCONSCIOUS)
		hear_sleep(multilingual_to_message(message_pieces))
		return FALSE

	if(italics)
		message = "<i>[message]</i>"

	message = encode_html_emphasis(message)

	var/track = null
	if(isobserver(src))
		if(speaker_name != speaker.real_name && speaker.real_name)
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "([ghost_follow_link(speaker, src)]) "
		if(is_preference_enabled(/datum/client_preference/ghost_ears) && (speaker in view(src)))
			message = "<b>[message]</b>"

	if(is_deaf())
		if(speaker == src)
			to_chat(src, "<span class='filter_say'><span class='warning'>You cannot hear yourself speak!</span></span>")
		else
			to_chat(src, "<span class='filter_say'><span class='name'>[speaker_name]</span>[speaker.GetAltName()] makes a noise, possibly speech, but you cannot hear them.</span>")
	else
		var/message_to_send = null
		message_to_send = "<span class='name'>[speaker_name]</span>[speaker.GetAltName()] [track][message]"
		if(check_mentioned(multilingual_to_message(message_pieces)) && is_preference_enabled(/datum/client_preference/check_mention))
			message_to_send = "<font size='3'><b>[message_to_send]</b></font>"

		on_hear_say(message_to_send)
		create_chat_message(speaker, combined["raw"], italics, list())

		if(speech_sound && (get_dist(speaker, src) <= world.view && z == speaker.z))
			var/turf/source = speaker ? get_turf(speaker) : get_turf(src)
			playsound_local(source, speech_sound, sound_vol, 1)

	return TRUE

// Done here instead of on_hear_say() since that is NOT called if the mob is clientless (which includes most AI mobs).
/mob/living/hear_say(var/list/message_pieces, var/verb = "says", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	.=..()
	if(has_AI()) // Won't happen if no ai_holder exists or there's a player inside w/o autopilot active.
		ai_holder.on_hear_say(speaker, multilingual_to_message(message_pieces))

/mob/proc/on_hear_say(var/message)
	var/time = say_timestamp()
	if(client)
		if(client.prefs.chat_timestamp)
			to_chat(src, "<span class='game say'>[time] [message]</span>")
		else
			to_chat(src, "<span class='game say'>[message]</span>")
	else if(teleop)
		to_chat(teleop, "<span class='game say'>[create_text_tag("body", "BODY:", teleop.client)][message]</span>")
	else
		to_chat(src, "<span class='game say'>[message]</span>")

/mob/living/silicon/on_hear_say(var/message)
	var/time = say_timestamp()
	if(client)
		if(client.prefs.chat_timestamp)
			to_chat(src, "<span class='game say'>[time] [message]</span>")
		else
			to_chat(src, "<span class='game say'>[message]</span>")
	else if(teleop)
		to_chat(teleop, "<span class='game say'>[create_text_tag("body", "BODY:", teleop.client)][message]</span>")
	else
		to_chat(src, "<span class='game say'>[message]</span>")

// Checks if the mob's own name is included inside message.  Handles both first and last names.
/mob/proc/check_mentioned(var/message)
	var/not_included = list("A", "The", "Of", "In", "For", "Through", "Throughout", "Therefore", "Here", "There", "Then", "Now", "I", "You", "They", "He", "She", "By")
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

/proc/encode_html_emphasis(message)
    var/tagged_message = message
    for(var/delimiter in GLOB.speech_toppings)
        var/regex/R = new("\\[delimiter](.+?)\\[delimiter]","g")
        var/tag = GLOB.speech_toppings[delimiter]
        tagged_message = R.Replace(tagged_message,"<[tag]>$1</[tag]>")

    return tagged_message

/mob/proc/hear_radio(var/list/message_pieces, var/verb = "says", var/part_a, var/part_b, var/part_c, var/part_d, var/part_e, var/mob/speaker = null, var/hard_to_hear = 0, var/vname = "")
	if(!client)
		return

	var/list/combined = combine_message(message_pieces, verb, speaker, always_stars = hard_to_hear, radio = TRUE)
	var/message = combined["formatted"]
	if(sleeping || stat == UNCONSCIOUS) //If unconscious or sleeping
		hear_sleep(multilingual_to_message(message_pieces))
		return

	var/speaker_name = handle_speaker_name(speaker, vname, hard_to_hear)
	var/track = handle_track(message, verb, speaker, speaker_name, hard_to_hear)

	message = "[encode_html_emphasis(message)][part_d]"

	if((sdisabilities & DEAF) || ear_deaf)
		if(prob(20))
			to_chat(src, "<span class='warning'>You feel your headset vibrate but can hear nothing from it!</span>")
	else
		on_hear_radio(part_a, part_b, speaker_name, track, part_c, message, part_d, part_e)

/proc/say_timestamp()
	return "<span class='say_quote'>\[[time2text(world.timeofday, "hh:mm")]\]</span>"

/mob/proc/on_hear_radio(part_a, part_b, speaker_name, track, part_c, formatted, part_d, part_e)
	var/final_message = "[part_b][speaker_name][part_c][formatted][part_d]"
	if(check_mentioned(formatted) && is_preference_enabled(/datum/client_preference/check_mention))
		final_message = "[part_a]<font size='3'><b>[final_message]</b></font>[part_e]"
	else
		final_message = "[part_a][final_message][part_e]"
	to_chat(src, final_message)

/mob/observer/dead/on_hear_radio(part_a, part_b, speaker_name, track, part_c, formatted, part_d, part_e)
	var/final_message = "[part_b][track][part_c][formatted][part_d]"
	if(check_mentioned(formatted) && is_preference_enabled(/datum/client_preference/check_mention))
		final_message = "[part_a]<font size='3'><b>[final_message]</b></font>[part_e]"
	else
		final_message = "[part_a][final_message][part_e]"
	to_chat(src, final_message)

/mob/living/silicon/on_hear_radio(part_a, part_b, speaker_name, track, part_c, formatted, part_d, part_e)
	var/time = say_timestamp()
	var/final_message = "[part_b][speaker_name][part_c][formatted][part_d]"
	if(check_mentioned(formatted) && is_preference_enabled(/datum/client_preference/check_mention))
		final_message = "[part_a][time]<font size='3'><b>[final_message]</b></font>[part_e]"
	else
		final_message = "[part_a][time][final_message][part_e]"
	to_chat(src, final_message)

/mob/living/silicon/ai/on_hear_radio(part_a, part_b, speaker_name, track, part_c, formatted, part_d, part_e)
	var/time = say_timestamp()
	var/final_message = "[part_b][track][part_c][formatted][part_d]"
	if(check_mentioned(formatted) && is_preference_enabled(/datum/client_preference/check_mention))
		final_message = "[part_a][time]<font size='3'><b>[final_message]</b></font>[part_e]"
	else
		final_message = "[part_a][time][final_message][part_e]"
	to_chat(src, final_message)

/mob/proc/hear_signlang(var/message, var/verb = "gestures", var/verb_understood = "gestures", var/datum/language/language, var/mob/speaker = null, var/speech_type = 1)
	if(!client)
		return

	if(say_understands(speaker, language))
		message = "<span class='game say'><B>[speaker]</B> [verb_understood], \"[message]\"</span>"
	else if(!(language.ignore_adverb))
		var/adverb
		var/length = length(message) * pick(0.8, 0.9, 1.0, 1.1, 1.2)	//Adds a little bit of fuzziness
		switch(length)
			if(0 to 12)		adverb = " briefly"
			if(12 to 30)	adverb = " a short message"
			if(30 to 48)	adverb = " a message"
			if(48 to 90)	adverb = " a lengthy message"
			else			adverb = " a very lengthy message"
		message = "<span class='game say'><B>[speaker]</B> [verb][adverb].</span>"
	else
		message = "<span class='game say'><B>[speaker]</B> [verb].</span>"

	show_message(message, type = speech_type) // Type 1 is visual message

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
			heardword = copytext(heardword,1,length(heardword))
		heard = "<span class='game say'>...You hear something about...[heardword]</span>"

	else
		heard = "<span class='game say'>...<i>You almost hear someone talking</i>...</span>"

	to_chat(src, heard)

/mob/proc/handle_speaker_name(mob/speaker, vname, hard_to_hear)
	var/speaker_name = "unknown"
	if(speaker)
		speaker_name = speaker.name

	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		if(H.voice)
			speaker_name = H.voice

	if(vname)
		speaker_name = vname

	if(hard_to_hear)
		speaker_name = "unknown"

	return speaker_name

/mob/proc/handle_track(message, verb = "says", mob/speaker = null, speaker_name, hard_to_hear)
	return

/mob/proc/hear_holopad_talk(list/message_pieces, var/verb = "says", var/mob/speaker = null)
	var/list/combined = combine_message(message_pieces, verb, speaker)
	var/message = combined["formatted"]

	var/name = speaker.name
	if(!say_understands(speaker))
		name = speaker.voice_name

	var/rendered = "<span class='game say'><span class='name'>[name]</span> [message]</span>"
	to_chat(src, rendered)
