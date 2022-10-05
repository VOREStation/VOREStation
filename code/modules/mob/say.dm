/mob/proc/say(var/message, var/datum/language/speaking = null, var/whispering = 0)
	return


/mob/verb/whisper(message as text)
	set name = "Whisper"
	set category = "IC"
	//VOREStation Addition Start
	if(forced_psay)
		psay(message)
		return
	//VOREStation Addition End
	usr.say(message, whispering = TRUE)


/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"
	//VOREStation Addition Start
	if(forced_psay)
		psay(message)
		return
	//VOREStation Addition End

	set_typing_indicator(FALSE)
	usr.say(message)


/mob/verb/me_verb(message as message)
	set name = "Me"
	set category = "IC"
	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, SPAN_WARNING("Speech is currently admin-disabled."))
		return
	//VOREStation Addition Start
	if(forced_psay)
		pme(message)
		return
	//VOREStation Addition End

	//VOREStation Edit Start
	if(muffled)
		return me_verb_subtle(message)
	//VOREStation Edit End

	set_typing_indicator(FALSE)
	message = sanitize_or_reflect(message,src)
	if(use_me)
		custom_emote(usr.emote_type, message)
	else
		usr.emote(message)


/mob/proc/say_dead(var/message)
	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return

	if(!client)
		return // Clientless mobs shouldn't be trying to talk in deadchat.

	if(!client.holder)
		if(!config.dsay_allowed)
			to_chat(src, "<span class='danger'>Deadchat is globally muted.</span>")
			return

	if(!is_preference_enabled(/datum/client_preference/show_dsay))
		to_chat(usr, "<span class='danger'>You have deadchat muted.</span>")
		return

	message = encode_html_emphasis(message)

	say_dead_direct("[pick("complains","moans","whines","laments","blubbers")], <span class='message'>\"[message]\"</span>", src)

/mob/proc/say_understands(var/mob/other, var/datum/language/speaking = null)
	if(stat == DEAD)
		return TRUE

	//Universal speak makes everything understandable, for obvious reasons.
	else if(universal_speak || universal_understand)
		return TRUE

	//VOREStation Addition Start
	if(isliving(src))
		var/mob/living/L = src
		if(isbelly(L.loc) && L.absorbed)
			var/mob/living/P = L.loc.loc
			if(P.say_understands(other, speaking))
				return TRUE
	//VOREStation Addition End

	//Languages are handled after.
	if(!speaking)
		if(!other)
			return TRUE
		if(other.universal_speak)
			return TRUE
		if(isAI(src) && ispAI(other))
			return TRUE
		if(istype(other, type) || istype(src, other.type))
			return TRUE
		return FALSE

	if(speaking.flags & INNATE)
		return TRUE

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if(speaking.flags & NONVERBAL)
		if(sdisabilities & BLIND || blinded)
			return FALSE
		if(!other || !(other in view(src)))
			return FALSE

	//Language check.
	for(var/datum/language/L in languages)
		if(speaking.name == L.name)
			return TRUE

	return FALSE

/mob/proc/say_quote(var/message, var/datum/language/speaking = null)
	var/verb = "says"
	var/ending = copytext(message, length(message))

	if(speaking)
		verb = speaking.get_spoken_verb(ending)
	else
		if(ending == "!")
			verb = pick("exclaims", "shouts", "yells")
		else if(ending == "?")
			verb = "asks"
	return verb

/mob/proc/get_ear()
	// returns an atom representing a location on the map from which this
	// mob can hear things

	// should be overloaded for all mobs whose "ear" is separate from their "mob"

	return get_turf(src)

/proc/say_test(var/text)
	var/ending = copytext(text, length(text))
	if(ending == "?")
		return "1"
	else if(ending == "!")
		return "2"
	return "0"

//parses the message mode code (e.g. :h, :w) from text, such as that supplied to say.
//returns the message mode string or null for no message mode.
//standard mode is the mode returned for the special ';' radio code.
/mob/proc/parse_message_mode(var/message, var/standard_mode = "headset")
	if(length(message) >= 1 && copytext(message, 1, 2) == ";")
		return standard_mode

	if(length(message) >= 2)
		var/channel_prefix = copytext(message, 1, 3)
		return department_radio_keys[channel_prefix]

	return null

/datum/multilingual_say_piece
	var/datum/language/speaking = null
	var/message = ""

/datum/multilingual_say_piece/New(datum/language/new_speaking, new_message)
	. = ..()
	speaking = new_speaking
	if(new_message)
		message = new_message

/mob/proc/find_valid_prefixes(message)
	var/list/prefixes = list() // [["Common", start, end], ["Gutter", start, end]]
	for(var/i in 1 to length(message))
		// This grabs 3 character substrings, to allow for up to 1 prefix, 1 letter language key, and one post-key character to more strictly control where the language breaks happen
		var/selection = trim_right(copytext(message, i, i + 3)) // VOREStation Edit: We use uppercase keys to avoid Polaris key duplication, but this had lowertext() in it
		// The first character in the selection will always be the prefix (if this is a valid language invocation)
		var/prefix = copytext(selection, 1, 2)
		var/language_key = copytext(selection, 2, 3)
		if(is_language_prefix(prefix))
			// Okay, we're definitely now trying to invoke a language (probably)
			// This "[]" is probably unnecessary but BYOND will runtime if a number is used
			var/datum/language/L = GLOB.language_keys["[language_key]"]
			if((language_key in language_keys) && language_keys[language_key])
				L = language_keys[language_key]

			// MULTILINGUAL_SPACE enforces a space after the language key
			if(client && (client.prefs.multilingual_mode == MULTILINGUAL_SPACE) && (text2ascii(copytext(selection, 3, 4)) != 32)) // If we're looking for a space and we don't find one
				continue

			// MULTILINGUAL_DOUBLE_DELIMITER enforces a delimiter (valid prefix) after the language key
			if(client && (client.prefs.multilingual_mode == MULTILINGUAL_DOUBLE_DELIMITER) && !is_language_prefix(copytext(selection, 3, 4)))
				continue

			if(client && (client.prefs.multilingual_mode in list(MULTILINGUAL_DEFAULT)))
				selection = copytext(selection, 1, 3) // These modes only use two characters, not three

			// It's kinda silly that we have to check L != null and this isn't done for us by can_speak (it runtimes instead), but w/e
			if(L && can_speak(L))
				// So we have a valid language invocation, and we can speak that language, let's make a piece for it
				// This language will be the language until the next prefixes[] index, or the end of the message if there are none.
				prefixes[++prefixes.len] = list(L, i, i + length(selection))
			else if(L)
				// We found a valid language, but they can't speak it. Let's make them speak gibberish instead.
				prefixes[++prefixes.len] = list(GLOB.all_languages[LANGUAGE_GIBBERISH], i, i + length(selection))
			continue
		if(i == 1)
			// This covers the case of "no prefixes in use."
			prefixes[++prefixes.len] = list(get_default_language(), i, i)

		// If multilingualism is disabled, then after the first pass we're guaranteed to have either found a language key at the start, or else there isn't one and we're using the default for the whole message
		if(client && (client.prefs.multilingual_mode == MULTILINGUAL_OFF))
			break

	return prefixes

/mob/proc/strip_prefixes(message, mob/prefixer = null)
	. = ""
	var/last_index = 1
	for(var/i in 1 to length(message))
		var/selection = trim_right(lowertext(copytext(message, i, i + 2)))
		// The first character in the selection will always be the prefix (if this is a valid language invocation)
		var/prefix = copytext(selection, 1, 2)
		var/language_key = copytext(selection, 2, 3)
		if(is_language_prefix(prefix))
			var/datum/language/L = GLOB.language_keys["[language_key]"]
			if(L)
				. += copytext(message, last_index, i)
				last_index = i + 2
		if(i + 1 > length(message))
			. += copytext(message, last_index)

// this returns a structured message with language sections
// list(/datum/multilingual_say_piece(common, "hi"), /datum/multilingual_say_piece(farwa, "squik"), /datum/multilingual_say_piece(common, "meow!"))
/mob/proc/parse_languages(message)
	. = list()

	// Noise language is a snowflake.
	if(copytext(message, 1, 2) == "!" && length(message) > 1)
		// Note that list() here is intended
		// Returning a raw /datum/multilingual_say_piece is supported, but only for hivemind languages
		// What we actually want is a normal say piece that's all noise lang
		return list(new /datum/multilingual_say_piece(GLOB.all_languages["Noise"], trim(strip_prefixes(copytext(message, 2)))))

	// Scan the message for prefixes
	var/list/prefix_locations = find_valid_prefixes(message)
	if(!LAZYLEN(prefix_locations)) // There are no prefixes... or at least, no _valid_ prefixes.
		. += new /datum/multilingual_say_piece(get_default_language(), trim(strip_prefixes(message))) // So we'll just strip those pesky things and still make the message.

	for(var/i in 1 to length(prefix_locations))
		var/current = prefix_locations[i] // ["Common", start, end]

		// There are a few things that will make us want to ignore all other languages in - namely, HIVEMIND languages.
		var/datum/language/L = current[1]
		if(L && (L.flags & HIVEMIND || L.flags & SIGNLANG || L.flags & INAUDIBLE))
			return new /datum/multilingual_say_piece(L, trim(sanitize(strip_prefixes(message))))

		if(i + 1 > length(prefix_locations)) // We are out of lookaheads, that means the rest of the message is in cur lang
			var/spoke_message = sanitize(handle_autohiss(trim(copytext(message, current[3])), L))
			. += new /datum/multilingual_say_piece(current[1], spoke_message)
		else
			var/next = prefix_locations[i + 1] // We look ahead at the next message to see where we need to stop.
			var/spoke_message = sanitize(handle_autohiss(trim(copytext(message, current[3], next[2])), L))
			. += new /datum/multilingual_say_piece(current[1], spoke_message)

/* These are here purely because it would be hell to try to convert everything over to using the multi-lingual system at once */
/proc/message_to_multilingual(message, datum/language/speaking = null)
	. = list(new /datum/multilingual_say_piece(speaking, message))

/proc/multilingual_to_message(list/message_pieces, var/requires_machine_understands = FALSE, var/with_capitalization = FALSE)
	. = ""
	for(var/datum/multilingual_say_piece/S in message_pieces)
		var/message_to_append = S.message
		if(S.speaking)
			if(with_capitalization)
				message_to_append = S.speaking.format_message_plain(S.message)
			if(requires_machine_understands && !S.speaking.machine_understands)
				message_to_append = S.speaking.scramble(S.message)
		. += message_to_append + " "
	. = trim_right(.)
