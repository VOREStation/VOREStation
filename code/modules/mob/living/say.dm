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
	  ":s" = "Security",	".s" = "Security",
	  ":w" = "whisper",		".w" = "whisper",
	  ":t" = "Mercenary",	".t" = "Mercenary",
	  ":x" = "Raider",		".x" = "Raider",
	  ":u" = "Supply",		".u" = "Supply",
	  ":v" = "Service",		".v" = "Service",
	  ":p" = "AI Private",	".p" = "AI Private",

	  ":R" = "right ear",	".R" = "right ear",
	  ":L" = "left ear",	".L" = "left ear",
	  ":I" = "intercom",	".I" = "intercom",
	  ":H" = "department",	".H" = "department",
	  ":C" = "Command",		".C" = "Command",
	  ":N" = "Science",		".N" = "Science",
	  ":M" = "Medical",		".M" = "Medical",
	  ":E" = "Engineering",	".E" = "Engineering",
	  ":S" = "Security",	".S" = "Security",
	  ":W" = "whisper",		".W" = "whisper",
	  ":T" = "Mercenary",	".T" = "Mercenary",
	  ":X" = "Raider",		".X" = "Raider",
	  ":U" = "Supply",		".U" = "Supply",
	  ":V" = "Service",		".V" = "Service",
	  ":P" = "AI Private",	".P" = "AI Private",

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

	if (istype(src, /mob/living/silicon/pai))
		return

	if (!ishuman(src))
		return

	var/mob/living/carbon/human/H = src
	if (H.l_ear || H.r_ear)
		var/obj/item/device/radio/headset/dongle
		if(istype(H.l_ear,/obj/item/device/radio/headset))
			dongle = H.l_ear
		else
			dongle = H.r_ear
		if(!istype(dongle)) return
		if(dongle.translate_binary) return 1

/mob/living/proc/get_default_language()
	return default_language

//Takes a list of the form list(message, verb, whispering) and modifies it as needed
//Returns 1 if a speech problem was applied, 0 otherwise
/mob/living/proc/handle_speech_problems(var/list/message_data)
	var/message = message_data[1]
	var/verb = message_data[2]
	var/whispering = message_data[3]
	. = 0

	if((HULK in mutations) && health >= 25 && length(message))
		message = "[uppertext(message)]!!!"
		verb = pick("yells","roars","hollers")
		whispering = 0
		. = 1
	if(slurring)
		message = slur(message)
		verb = pick("slobbers","slurs")
		. = 1
	if(stuttering)
		message = stutter(message)
		verb = pick("stammers","stutters")
		. = 1

	message_data[1] = message
	message_data[2] = verb
	message_data[3] = whispering

/mob/living/proc/handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name)
	if(message_mode == "intercom")
		for(var/obj/item/device/radio/intercom/I in view(1, null))
			I.talk_into(src, message, verb, speaking)
			used_radios += I
	return 0

/mob/living/proc/handle_speech_sound()
	var/list/returns[2]
	returns[1] = null
	returns[2] = null
	return returns

/mob/living/proc/get_speech_ending(verb, var/ending)
	if(ending=="!")
		return pick("exclaims","shouts","yells")
	if(ending=="?")
		return "asks"
	return verb

/mob/living/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/whispering = 0)
	//If you're muted for IC chat
	if(client)
		client.handle_spam_prevention(MUTE_IC)
		if((client.prefs.muted & MUTE_IC) || say_disabled)
			src << "<span class='warning'>You cannot speak in IC (Muted).</span>"
			return

	//Redirect to say_dead if talker is dead
	if(stat)
		if(stat == DEAD)
			return say_dead(message)
		return

	//Parse the mode
	var/message_mode = parse_message_mode(message, "headset")

	//Maybe they are using say/whisper to do a quick emote, so do those
	switch(copytext(message,1,2))
		if("*") return emote(copytext(message,2))
		if("^") return custom_emote(1, copytext(message,2))

	//Parse the radio code and consume it
	if (message_mode)
		if (message_mode == "headset")
			message = copytext(message,2)	//it would be really nice if the parse procs could do this for us.
		else if (message_mode == "whisper")
			whispering = 1
			message_mode = null
			message = copytext(message,3)
		else
			message = copytext(message,3)

	//Clean up any remaining space on the left
	message = trim_left(message)

	//Parse the language code and consume it
	if(!speaking)
		speaking = parse_language(message)
	if(speaking)
		message = copytext(message,2+length(speaking.key))
	else
		speaking = get_default_language()

	//HIVEMIND languages always send to all people with that language
	if(speaking && (speaking.flags & HIVEMIND))
		speaking.broadcast(src,trim(message))
		return 1

	//Self explanatory.
	if(is_muzzled() && !(speaking && (speaking.flags & SIGNLANG)))
		src << "<span class='danger'>You're muzzled and cannot speak!</span>"
		return

	//Clean up any remaining junk on the left like spaces.
	message = trim_left(message)

	//Autohiss handles auto-rolling tajaran R's and unathi S's/Z's
	message = handle_autohiss(message, speaking)

	//Whisper vars
	var/w_scramble_range = 5	//The range at which you get ***as*th**wi****
	var/w_adverb				//An adverb prepended to the verb in whispers
	var/w_not_heard				//The message for people in watching range

	//Handle language-specific verbs and adverb setup if necessary
	if(!whispering) //Just doing normal 'say' (for now, may change below)
		verb = say_quote(message, speaking)
	else if(whispering && speaking.whisper_verb) //Language has defined whisper verb
		verb = speaking.whisper_verb
		w_not_heard = "[verb] something"
	else //Whispering but language has no whisper verb, use say verb
		w_adverb = pick("quietly", "softly")
		verb = speaking.speech_verb
		w_not_heard = "[speaking.speech_verb] something [w_adverb]"

	//For speech disorders (hulk, slurring, stuttering)
	if(!(speaking && (speaking.flags & NO_STUTTER || speaking.flags & SIGNLANG)))
		var/list/message_data = list(message, verb, whispering)
		if(handle_speech_problems(message_data))
			message = message_data[1]
			whispering = message_data[3]

			if(verb != message_data[2]) //They changed our verb
				if(whispering)
					w_adverb = pick("quietly", "softly")
				verb = message_data[2]

	//Whisper may have adverbs, add those if one was set
	if(w_adverb) verb = "[verb] [w_adverb]"

	//If something nulled or emptied the message, forget it
	if(!message || message == "")
		return 0

	//Radio message handling
	var/list/obj/item/used_radios = new
	if(handle_message_mode(message_mode, message, verb, speaking, used_radios, alt_name, whispering))
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
		if(speaking)
			message_range = speaking.get_talkinto_msg_range(message)
		var/msg
		if(!speaking || !(speaking.flags & NO_TALK_MSG))
			msg = "<span class='notice'>\The [src] talks into \the [used_radios[1]]</span>"
		for(var/mob/living/M in hearers(5, src))
			if((M != src) && msg)
				M.show_message(msg)
			if (speech_sound)
				sound_vol *= 0.5

	//Set vars if we're still whispering by this point
	if(whispering)
		italics = 1
		message_range = 1
		sound_vol *= 0.5

	//Handle nonverbal and sign languages here
	if (speaking)
		if (speaking.flags & NONVERBAL)
			if (prob(30))
				src.custom_emote(1, "[pick(speaking.signlang_verb)].")

		if (speaking.flags & SIGNLANG)
			log_say("[name]/[key] : SIGN: [message]")
			return say_signlang(message, pick(speaking.signlang_verb), speaking)

	//These will contain the main receivers of the message
	var/list/listening = list()
	var/list/listening_obj = list()

	//Atmosphere calculations (speaker's side only, for now)
	var/turf/T = get_turf(src)
	if(T)
		//Air is too thin to carry sound at all, contact speech only
		var/datum/gas_mixture/environment = T.return_air()
		var/pressure = (environment)? environment.return_pressure() : 0
		if(pressure < SOUND_MINIMUM_PRESSURE)
			message_range = 1

		//Air is nearing minimum levels, make text italics as a hint, and muffle sound
		if (pressure < ONE_ATMOSPHERE*0.4)
			italics = 1
			sound_vol *= 0.5

		//Obtain the mobs and objects in the message range
		var/list/results = get_mobs_and_objs_in_view_fast(T, world.view)
		listening = results["mobs"]
		listening_obj = results["objs"]
	else
		return 1 //If we're in nullspace, then forget it.

	//The 'post-say' static speech bubble
	var/speech_bubble_test = say_test(message)
	var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h[speech_bubble_test]")
	spawn(30) qdel(speech_bubble)

	//Main 'say' and 'whisper' message delivery
	for(var/mob/M in listening)
		spawn(0) //Using spawns to queue all the messages for AFTER this proc is done, and stop runtimes

			if(M && src) //If we still exist, when the spawn processes
				var/dst = get_dist(get_turf(M),get_turf(src))

				if(dst <= message_range || M.stat == DEAD) //Inside normal message range, or dead with ears (handled in the view proc)
					M << speech_bubble
					M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol)

				if(whispering) //Don't even bother with these unless whispering
					if(dst > message_range && dst <= w_scramble_range) //Inside whisper scramble range
						M << speech_bubble
						M.hear_say(stars(message), verb, speaking, alt_name, italics, src, speech_sound, sound_vol*0.2)
					if(dst > w_scramble_range && dst <= world.view) //Inside whisper 'visible' range
						M.show_message("<span class='game say'><span class='name'>[src.name]</span> [w_not_heard].</span>", 2)

	//Object message delivery
	for(var/obj/O in listening_obj)
		spawn(0)
			if(O && src) //If we still exist, when the spawn processes
				var/dst = get_dist(get_turf(O),get_turf(src))
				if(dst <= message_range)
					O.hear_talk(src, message, verb, speaking)

	//Log the message to file
	log_say("[name]/[key][whispering ? " (W)" : ""]: [message]")
	return 1

/mob/living/proc/say_signlang(var/message, var/verb="gestures", var/datum/language/language)
	for (var/mob/O in viewers(src, null))
		O.hear_signlang(message, verb, language, src)
	return 1

/obj/effect/speech_bubble
	var/mob/parent

/mob/living/proc/GetVoice()
	return name
