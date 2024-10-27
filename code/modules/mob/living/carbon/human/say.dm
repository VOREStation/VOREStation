/mob/living/carbon/human/GetAltName()
	if(ability_flags & AB_PHASE_SHIFTED)
		return ""
	if(name != GetVoice())
		return " (as [get_id_name("Unknown")])"

	return ..()

/mob/living/carbon/human/proc/forcesay(list/append)
	if(stat == CONSCIOUS)
		if(client)
			var/virgin = 1	//has the text been modified yet?
			var/temp = winget(client, "input", "text")
			if(findtextEx(temp, "Say \"", 1, 7) && length(temp) > 5)	//case sensitive means

				temp = replacetext(temp, ";", "")	//general radio

				if(findtext(trim_left(temp), ":", 6, 7))	//dept radio
					temp = copytext(trim_left(temp), 8)
					virgin = 0

				if(virgin)
					temp = copytext(trim_left(temp), 6)	//normal speech
					virgin = 0

				while(findtext(trim_left(temp), ":", 1, 2))	//dept radio again (necessary)
					temp = copytext(trim_left(temp), 3)

				if(findtext(temp, "*", 1, 2))	//emotes
					return
				temp = copytext(trim_left(temp), 1, rand(5,8))

				var/trimmed = trim_left(temp)
				if(length(trimmed))
					if(append)
						temp += pick(append)

					say(temp)
				winset(client, "input", "text=[null]")

/mob/living/carbon/human/speech_bubble_appearance()
	var/sounds_synth = FALSE
	var/datum/robolimb/robo = isSynthetic() //Will get torso manufacturer
	if(robo)
		sounds_synth = looksSynthetic() //Based on lifelike robolimb vars

	// Not lifelike and got manufacturer
	if(sounds_synth)
		return robo.speech_bubble_appearance || "synthetic"

	// Not lifelike synth, might have synth voice box
	if(!robo)
		var/obj/item/organ/internal/V = internal_organs_by_name[O_VOICE]
		if(V?.robotic >= ORGAN_ROBOT)
			return "synthetic"

	// Species might have custom one
	if(species.speech_bubble_appearance)
		return species.speech_bubble_appearance

	// NORMIE
	return ..()

/mob/living/carbon/human/say_understands(var/mob/other, var/datum/language/speaking = null)
	if(has_brain_worms()) //Brain worms translate everything. Even mice and alien speak.
		return TRUE

	if(species.can_understand(other))
		return TRUE

	//These only pertain to common. Languages are handled by mob/say_understands()
	if(!speaking)
		if(istype(other, /mob/living/carbon/alien/diona))
			if(other.languages.len >= 2) //They've sucked down some blood and can speak common now.
				return TRUE
		if(issilicon(other))
			return TRUE
		if(isbrain(other))
			return TRUE
		if(isslime(other))
			return TRUE

	return ..()

/mob/living/carbon/human/GetVoice()
	var/voice_sub
	if(istype(get_rig(),/obj/item/rig))
		var/obj/item/rig/rig = get_rig()
		// todo: fix this shit
		if(rig.speech && rig.speech.voice_holder && rig.speech.voice_holder.active && rig.speech.voice_holder.voice)
			voice_sub = rig.speech.voice_holder.voice
	if(!voice_sub)	// If the rig has a voice changer, then we use that. Otherwise, use this
		for(var/obj/item/gear in list(wear_mask,wear_suit,head))
			if(!gear)
				continue
			var/obj/item/voice_changer/changer = locate() in gear
			if(changer && changer.active)
				if(changer.voice)
					voice_sub = changer.voice
				else
					voice_sub = get_id_name()
	if(voice_sub)
		return voice_sub
	if(mind && mind.changeling && mind.changeling.mimicing)
		return mind.changeling.mimicing
	if(GetSpecialVoice())
		return GetSpecialVoice()
	return real_name

/mob/living/carbon/human/proc/SetSpecialVoice(var/new_voice)
	if(new_voice)
		special_voice = new_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice

/mob/living/carbon/human/handle_speech_problems(var/list/message_data)
	if(silent || (sdisabilities & MUTE))
		message_data[1] = ""
		. = 1

	else if(istype(wear_mask, /obj/item/clothing/mask))
		var/obj/item/clothing/mask/M = wear_mask
		if(M.voicechange)
			message_data[1] = pick(M.say_messages)
			message_data[2] = pick(M.say_verbs)
			. = 1

	else if(CE_SPEEDBOOST in chem_effects || is_jittery) // motor mouth
		// Despite trying to url/html decode these, byond is just being bad and I dunno.
		var/static/regex/speedboost_initial = new (@"&[a-z]{2,5};|&#\d{2};","g")
		// Not herestring because bad vs code syntax highlight panics at apostrophe
		var/static/regex/speedboost_main = new ("\[ ',!?.;\]","g")
		for(var/datum/multilingual_say_piece/S in message_data[1])
			S.message = speedboost_initial.Replace(S.message, "")
			S.message = speedboost_main.Replace(S.message, "")
		. = 1
	else
		. = ..(message_data)

/mob/living/carbon/human/handle_message_mode(message_mode, list/message_pieces, verb, used_radios)
	switch(message_mode)
		if("intercom")
			if(!restrained())
				for(var/obj/item/radio/intercom/I in view(1))
					I.talk_into(src, message_pieces, null, verb)
					I.add_fingerprint(src)
					used_radios += I
		if("headset")
			var/obj/item/radio/R = null
			if(isradio(l_ear))
				R = l_ear
				if(R.talk_into(src, message_pieces, null, verb))
					used_radios += R
					return

			if(isradio(r_ear))
				R = r_ear
				if(R.talk_into(src, message_pieces, null, verb))
					used_radios += R
					return
		if("right ear")
			var/obj/item/radio/R = null
			if(isradio(r_ear))
				R = r_ear
			if(isradio(r_hand))
				R = r_hand
			if(istype(R))
				if(R.talk_into(src, message_pieces, null, verb))
					used_radios += R
		if("left ear")
			var/obj/item/radio/R = null
			if(isradio(l_ear))
				R = l_ear
			if(isradio(l_hand))
				R = l_hand
			if(istype(R))
				if(R.talk_into(src, message_pieces, null, verb))
					used_radios += R
		else
			if(message_mode)
				if(isradio(l_ear))
					if(l_ear.talk_into(src, message_pieces, message_mode, verb))
						used_radios += l_ear
						return

				if(isradio(r_ear))
					if(r_ear.talk_into(src, message_pieces, message_mode, verb))
						used_radios += r_ear

/mob/living/carbon/human/handle_speech_sound()
	var/list/returns[2]
	if(species.speech_sounds && species.speech_sounds.len && prob(species.speech_chance))		//VOREStation Edit: Sanity Check
		returns[1] = sound(pick(species.speech_sounds))
		returns[2] = 50
	return returns

/mob/living/carbon/human/binarycheck()
	. = FALSE
	var/obj/item/radio/headset/R = null
	if(istype(l_ear, /obj/item/radio/headset))
		R = l_ear
		if(R.translate_binary)
			. = TRUE

	if(istype(r_ear, /obj/item/radio/headset))
		R = r_ear
		if(R.translate_binary)
			. = TRUE
