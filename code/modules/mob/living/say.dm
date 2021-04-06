var/list/department_radio_keys = list(
	  ":r" = "right ear",	".r" = "right ear",
	  ":l" = "left ear",	".l" = "left ear",
	  ":i" = "intercom",	".i" = "intercom",
	  ":h" = "department",	".h" = "department",
	  ":+" = "special",		".+" = "special", //activate radio-specific special functions
	  ":c" = "Command",		".c" = "Command",
	  ":n" = "Science",		".n" = "Science",
	  ":m" = "Medical",		".m" = "Medical",
	  ":e" = "Engineering", ".e" = "Engineering",
	  ":k" = "Response Team",	".k" = "Response Team",	//TFF 11/3/20 - Add Response Team to channels usable rather than resorting to :H or such.,
	  ":s" = "Security",	".s" = "Security",
	  ":w" = "whisper",		".w" = "whisper",
	  ":t" = "Mercenary",	".t" = "Mercenary",
	  ":x" = "Raider",		".x" = "Raider",
	  ":u" = "Supply",		".u" = "Supply",
	  ":v" = "Service",		".v" = "Service",
	  ":p" = "AI Private",	".p" = "AI Private",
	  ":y" = "Explorer",	".y" = "Explorer",
	  ":a" = "Talon",		".a" = "Talon", //VOREStation Add,

	  ":R" = "right ear",	".R" = "right ear",
	  ":L" = "left ear",	".L" = "left ear",
	  ":I" = "intercom",	".I" = "intercom",
	  ":H" = "department",	".H" = "department",
	  ":C" = "Command",		".C" = "Command",
	  ":N" = "Science",		".N" = "Science",
	  ":M" = "Medical",		".M" = "Medical",
	  ":E" = "Engineering",	".E" = "Engineering",
	  ":k" = "Response Team",	".k" = "Response Team",	//TFF 11/3/20 - Add Response Team to channels usable rather than resorting to :H or such.,
	  ":S" = "Security",	".S" = "Security",
	  ":W" = "whisper",		".W" = "whisper",
	  ":T" = "Mercenary",	".T" = "Mercenary",
	  ":X" = "Raider",		".X" = "Raider",
	  ":U" = "Supply",		".U" = "Supply",
	  ":V" = "Service",		".V" = "Service",
	  ":P" = "AI Private",	".P" = "AI Private",
	  ":Y" = "Explorer",	".Y" = "Explorer",
	  ":A" = "Talon",		".A" = "Talon", //VOREStation Add,

	  //kinda localization -- rastaf0
	  //same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	  ":ê" = "right ear",	".ê" = "right ear",
	  ":ä" = "left ear",	".ä" = "left ear",
	  ":ø" = "intercom",	".ø" = "intercom",
	  ":ð" = "department",	".ð" = "department",
	  ":ñ" = "Command",		".ñ" = "Command",
	  ":ò" = "Science",		".ò" = "Science",
	  ":ü" = "Medical",		".ü" = "Medical",
	  ":ó" = "Engineering",	".ó" = "Engineering",
	  ":û" = "Security",	".û" = "Security",
	  ":ö" = "whisper",		".ö" = "whisper",
	  ":å" = "Mercenary",	".å" = "Mercenary",
	  ":é" = "Supply",		".é" = "Supply",
)


var/list/channel_to_radio_key = new
proc/get_radio_key_from_channel(var/channel)
	var/key = channel_to_radio_key[channel]
	if(!key)
		for(var/radio_key in department_radio_keys)
			if(department_radio_keys[radio_key] == channel)
				key = radio_key
				break
		if(!key)
			key = ""
		channel_to_radio_key[channel] = key

	return key

/mob/living/proc/binarycheck()
	return FALSE

/mob/proc/get_default_language()
	return null

/mob/living/get_default_language()
	return default_language

//Takes a list of the form list(message, verb, whispering) and modifies it as needed
//Returns 1 if a speech problem was applied, 0 otherwise
/mob/living/proc/handle_speech_problems(var/list/message_data)
	var/list/message_pieces = message_data[1]
	var/verb = message_data[2]
	var/whispering = message_data[3]
	. = 0

	// Technically this rerolls the verb for as many say pieces as there are. _shrug_
	for(var/datum/multilingual_say_piece/S in message_pieces)
		if(S.speaking && (S.speaking.flags & NO_STUTTER || S.speaking.flags & SIGNLANG))
			continue

		if((HULK in mutations) && health >= 25 && length(S.message))
			S.message = "[uppertext(S.message)]!!!"
			verb = pick("yells","roars","hollers")
			whispering = 0
			. = 1
		if(slurring)
			S.message = slur(S.message)
			verb = pick("slobbers","slurs")
			. = 1
		if(stuttering)
			S.message = stutter(S.message)
			verb = pick("stammers","stutters")
			. = 1
		//VOREStation Edit Start
		if(muffled)
			verb = pick("muffles")
			whispering = 1
			. = 1
		//VOREStation Edit End

	message_data[1] = message_pieces
	message_data[2] = verb
	message_data[3] = whispering

/mob/living/proc/handle_message_mode(message_mode, list/message_pieces, verb, used_radios)
	if(message_mode == "intercom")
		for(var/obj/item/device/radio/intercom/I in view(1, null))
			I.talk_into(src, message_pieces, verb)
			used_radios += I
	return 0

/mob/living/proc/handle_speech_sound()
	var/list/returns[2]
	returns[1] = null
	returns[2] = null
	return returns

/mob/living/proc/get_speech_ending(verb, var/ending)
	if(ending == "!")
		return pick("exclaims","shouts","yells")
	if(ending == "?")
		return "asks"
	return verb

/mob/living/say(var/message, var/whispering = 0)
	//If you're muted for IC chat
	if(client)
		if(message)
			client.handle_spam_prevention(MUTE_IC)
			if((client.prefs.muted & MUTE_IC) || say_disabled)
				to_chat(src, "<span class='warning'>You cannot speak in IC (Muted).</span>")
				return

	//Redirect to say_dead if talker is dead
	if(stat)
		if(stat == DEAD && !forbid_seeing_deadchat)
			return say_dead(message)
		return

	//Parse the mode
	var/message_mode = parse_message_mode(message, "headset")

	//Maybe they are using say/whisper to do a quick emote, so do those
	switch(copytext(message, 1, 2))
		if("*") return emote(copytext(message, 2))
		if("^") return custom_emote(1, copytext(message, 2))

	//Parse the radio code and consume it
	if(message_mode)
		if(message_mode == "headset")
			message = copytext(message, 2)	//it would be really nice if the parse procs could do this for us.
		else if(message_mode == "whisper")
			whispering = 1
			message_mode = null
			message = copytext(message, 3)
		else
			message = copytext(message, 3)

	//Clean up any remaining space on the left
	message = trim_left(message)

	// VOREStation Edit - Reflect messages as needed, no sanitizing because parse_languages will handle it for us
	if(reflect_if_needed(message, src))
		return
	// VOREStation Edit End

	//Parse the language code and consume it
	var/list/message_pieces = parse_languages(message)
	if(istype(message_pieces, /datum/multilingual_say_piece)) // Little quark for dealing with hivemind/signlang languages.
		var/datum/multilingual_say_piece/S = message_pieces // Yay for BYOND's hilariously broken typecasting for allowing us to do this.
		S.speaking.broadcast(src, S.message)
		return 1

	if(!LAZYLEN(message_pieces))
		log_runtime(EXCEPTION("Message failed to generate pieces. [message] - [json_encode(message_pieces)]"))
		return 0

	// If you're muzzled, you can only speak sign language
	// However, sign language is handled above.
	if(is_muzzled())
		to_chat(src, "<span class='danger'>You're muzzled and cannot speak!</span>")
		return

	//Whisper vars
	var/w_scramble_range = 5	//The range at which you get ***as*th**wi****
	var/w_adverb				//An adverb prepended to the verb in whispers
	var/w_not_heard				//The message for people in watching range

	var/datum/multilingual_say_piece/first_piece = message_pieces[1]
	var/verb = ""
	//Handle language-specific verbs and adverb setup if necessary
	if(!whispering) //Just doing normal 'say' (for now, may change below)
		verb = say_quote(message, first_piece.speaking)
	else if(whispering && first_piece.speaking.whisper_verb) //Language has defined whisper verb
		verb = first_piece.speaking.whisper_verb
		w_not_heard = "[verb] something"
	else //Whispering but language has no whisper verb, use say verb
		w_adverb = pick("quietly", "softly")
		verb = first_piece.speaking.speech_verb
		w_not_heard = "[first_piece.speaking.speech_verb] something [w_adverb]"

	//For speech disorders (hulk, slurring, stuttering)
	var/list/message_data = list(message_pieces, verb, whispering)
	if(handle_speech_problems(message_data))
		message_pieces = message_data[1]
		whispering = message_data[3]

		if(verb != message_data[2]) //They changed our verb
			if(whispering)
				w_adverb = pick("quietly", "softly")
			verb = message_data[2]

	//Whisper may have adverbs, add those if one was set
	if(w_adverb)
		verb = "[verb] [w_adverb]"

	//If something nulled or emptied the message, forget it
	if(!LAZYLEN(message_pieces))
		return 0

	//Radio message handling
	var/list/used_radios = list()
	if(handle_message_mode(message_mode, message_pieces, verb, used_radios, whispering))
		return 1

	//For languages with actual speech sounds
	var/list/handle_v = handle_speech_sound()
	var/sound/speech_sound = handle_v[1]
	var/sound_vol = handle_v[2]

	//Default range and italics, may be overridden past here
	var/message_range = world.view
	var/italics = 0

	//Speaking into radios
	if(used_radios.len)
		italics = 1
		message_range = 1

		if(first_piece.speaking)
			message_range = first_piece.speaking.get_talkinto_msg_range(message)
		var/msg
		if(!first_piece.speaking || !(first_piece.speaking.flags & NO_TALK_MSG))
			msg = "<span class='notice'>[src] talks into [used_radios[1]]</span>"

		if(msg)
			for(var/mob/living/M in hearers(5, src) - src)
				M.show_message(msg)

		if(speech_sound)
			sound_vol *= 0.5

	//Set vars if we're still whispering by this point
	if(whispering)
		italics = 1
		message_range = 1
		sound_vol *= 0.5

	//VOREStation edit - allows for custom say verbs, overriding all other say-verb types- e.g. "says loudly" instead of "shouts"
	//You'll still stammer if injured or slur if drunk, but it won't have those specific words
	var/ending = copytext(message, length(message))

	if(custom_whisper && whispering)
		verb = "[custom_whisper]"
	else if(custom_exclaim && ending=="!")
		verb = "[custom_exclaim]"
	else if(custom_ask && ending=="?")
		verb = "[custom_ask]"
	else if(custom_say)
		verb = "[custom_say]"
	//VOREStation edit ends

	//Handle nonverbal languages here
	for(var/datum/multilingual_say_piece/S in message_pieces)
		if(S.speaking.flags & NONVERBAL)
			custom_emote(1, "[pick(S.speaking.signlang_verb)].")

	//These will contain the main receivers of the message
	var/list/listening = list()
	var/list/listening_obj = list()

	//Atmosphere calculations (speaker's side only, for now)
	var/turf/T = get_turf(src)
	if(T)
		//Air is too thin to carry sound at all, contact speech only
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = environment ? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE)
			message_range = 1

		//Air is nearing minimum levels, make text italics as a hint, and muffle sound
		if(pressure < ONE_ATMOSPHERE * 0.4)
			italics = 1
			sound_vol *= 0.5

		//Obtain the mobs and objects in the message range
		var/list/results = get_mobs_and_objs_in_view_fast(T, world.view, remote_ghosts = client ? TRUE : FALSE)
		listening = results["mobs"]
		listening_obj = results["objs"]
	else
		return 1 //If we're in nullspace, then forget it.

	//Remember the speech images so we can remove them later and they can get GC'd
	var/list/images_to_clients = list()

	//The 'post-say' static speech bubble
	var/speech_bubble_test = say_test(message)
	//var/image/speech_bubble = image('icons/mob/talk_vr.dmi',src,"h[speech_bubble_test]") //VOREStation Edit. Commented this out in case we need to reenable.
	var/speech_type = speech_bubble_appearance()
	var/image/speech_bubble = generate_speech_bubble(src, "[speech_type][speech_bubble_test]")
	var/sb_alpha = 255
	var/atom/loc_before_turf = src
	//VOREStation Add
	if(isbelly(loc))
		speech_bubble.pixel_y = -13 //teehee
	//VOREStation Add End
	while(loc_before_turf && !isturf(loc_before_turf.loc))
		loc_before_turf = loc_before_turf.loc
		sb_alpha -= 50
		if(sb_alpha < 0)
			break
	speech_bubble.loc = loc_before_turf
	speech_bubble.alpha = CLAMP(sb_alpha, 0, 255)
	images_to_clients[speech_bubble] = list()

	// Attempt Multi-Z Talking
	var/mob/above = src.shadow
	while(!QDELETED(above))
		var/turf/ST = get_turf(above)
		if(ST)
			var/list/results = get_mobs_and_objs_in_view_fast(ST, world.view)
			var/image/z_speech_bubble = generate_speech_bubble(above, "h[speech_bubble_test]")
			images_to_clients[z_speech_bubble] = list()
			for(var/item in results["mobs"])
				if(item != above && !(item in listening))
					listening[item] = z_speech_bubble
			listening_obj |= results["objs"]
		above = above.shadow

	//Main 'say' and 'whisper' message delivery
	for(var/mob/M in listening)
		spawn(0) //Using spawns to queue all the messages for AFTER this proc is done, and stop runtimes

			if(M && src) //If we still exist, when the spawn processes
				//VOREStation Add - Ghosts don't hear whispers
				if(whispering && !is_preference_enabled(/datum/client_preference/whisubtle_vis) && isobserver(M) && !M.client?.holder)
					M.show_message("<span class='game say'><span class='name'>[src.name]</span> [w_not_heard].</span>", 2)
					return
				//VOREStation Add End

				var/dst = get_dist(get_turf(M),get_turf(src))

				if(dst <= message_range || (M.stat == DEAD && !forbid_seeing_deadchat)) //Inside normal message range, or dead with ears (handled in the view proc)
					if(M.client)
						var/image/I1 = listening[M] || speech_bubble
						images_to_clients[I1] |= M.client
						M << I1
					M.hear_say(message_pieces, verb, italics, src, speech_sound, sound_vol)
				if(whispering && !isobserver(M)) //Don't even bother with these unless whispering
					if(dst > message_range && dst <= w_scramble_range) //Inside whisper scramble range
						if(M.client)
							var/image/I2 = listening[M] || speech_bubble
							images_to_clients[I2] |= M.client
							M << I2
						M.hear_say(stars_all(message_pieces), verb, italics, src, speech_sound, sound_vol*0.2)
					if(dst > w_scramble_range && dst <= world.view) //Inside whisper 'visible' range
						M.show_message("<span class='game say'><span class='name'>[name]</span> [w_not_heard].</span>", 2)

	//Object message delivery
	for(var/obj/O in listening_obj)
		spawn(0)
			if(O && src) //If we still exist, when the spawn processes
				var/dst = get_dist(get_turf(O),get_turf(src))
				if(dst <= message_range)
					O.hear_talk(src, message_pieces, verb)

	//Remove all those images. At least it's just ONE spawn this time.
	spawn(30)
		for(var/img in images_to_clients)
			var/image/I = img
			var/list/clients_from_image = images_to_clients[I]
			for(var/client in clients_from_image)
				var/client/C = client
				if(C) //Could have disconnected after message sent, before removing bubble.
					C.images -= I
			qdel(I)

	//Log the message to file
	if(message_mode)
		message = "([message_mode == "headset" ? "Common" : capitalize(message_mode)]) [message]" //Adds radio keys used if available
	if(whispering)
		log_whisper(message, src)
	else
		log_say(message, src)
	return 1

/mob/living/proc/say_signlang(var/message, var/verb="gestures", var/datum/language/language)
	var/turf/T = get_turf(src)
	//We're in something, gesture to people inside the same thing
	if(loc != T)
		for(var/mob/M in loc)
			M.hear_signlang(message, verb, language, src)

	//We're on a turf, gesture to visible as if we were a normal language
	else
		var/list/potentials = get_mobs_and_objs_in_view_fast(T, world.view)
		var/list/mobs = potentials["mobs"]
		for(var/hearer in mobs)
			var/mob/M = hearer
			M.hear_signlang(message, verb, language, src)
		var/list/objs = potentials["objs"]
		for(var/hearer in objs)
			var/obj/O = hearer
			O.hear_signlang(message, verb, language, src)
	return 1

/obj/effect/speech_bubble
	var/mob/parent

/mob/proc/GetVoice()
	return name

/mob/living/emote(var/act, var/type, var/message) //emote code is terrible, this is so that anything that isn't
	if(stat)			                          //already snowflaked to shit can call the parent and handle emoting sanely
		return FALSE

	if(..(act, type, message))
		return TRUE

	if(act && type && message)
		log_emote(message, src)

		for(var/mob/M in dead_mob_list)
			if(!M.client)
				continue

			if(isnewplayer(M))
				continue

			if(isobserver(M) && M.is_preference_enabled(/datum/client_preference/ghost_sight))
				M.show_message(message)

		switch(type)
			if(1) // Visible
				visible_message(message)
				return TRUE
			if(2) // Audible
				audible_message(message)
				return TRUE
	else
		if(act == "help")
			return // Mobs handle this individually
		to_chat(src, "<span class='warning'>Unusable emote '[act]'. Say *help for a list.</span>")


/mob/proc/speech_bubble_appearance()
	return "normal"
