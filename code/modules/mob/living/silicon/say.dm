/mob/living/silicon/robot/handle_message_mode(message_mode, message, verb, speaking, used_radios)
	..()
	if(message_mode)
		if(!is_component_functioning("radio"))
			to_chat(src, "<span class='warning'>Your radio isn't functional at this time.</span>")
			return 0
		if(message_mode == "general")
			message_mode = null
		return radio.talk_into(src,message,message_mode,verb,speaking)

/mob/living/silicon/speech_bubble_appearance()
	return "synthetic"

/mob/living/silicon/ai/handle_message_mode(message_mode, message, verb, speaking, used_radios)
	..()
	if(message_mode == "department")
		return holopad_talk(message, verb, speaking)
	else if(message_mode)
		if (aiRadio.disabledAi || aiRestorePowerRoutine || stat)
			to_chat(src, "<span class='danger'>System Error - Transceiver Disabled.</span>")
			return 0
		if(message_mode == "general")
			message_mode = null
		return aiRadio.talk_into(src,message,message_mode,verb,speaking)

/mob/living/silicon/pai/handle_message_mode(message_mode, message, verb, speaking, used_radios)
	..()
	if(message_mode)
		if(message_mode == "general")
			message_mode = null
		return radio.talk_into(src,message,message_mode,verb,speaking)

/mob/living/silicon/say_quote(var/text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return speak_query
	else if (ending == "!")
		return speak_exclamation

	return speak_statement

#define IS_AI 1
#define IS_ROBOT 2
#define IS_PAI 3

/mob/living/silicon/say_understands(var/other, var/datum/language/speaking = null)
	//These only pertain to common. Languages are handled by mob/say_understands()
	if(!speaking)
		if(iscarbon(other))
			return TRUE
		if(issilicon(other))
			return TRUE
		if(isbrain(other))
			return TRUE
	return ..()

//For holopads only. Usable by AI.
/mob/living/silicon/ai/proc/holopad_talk(list/message_pieces, verb)
	log_say("(HPAD) [multilingual_to_message(message_pieces)]",src)

	var/obj/machinery/hologram/holopad/T = src.holo
	if(T && T.masters[src])//If there is a hologram and its master is the user.
		var/list/listeners = get_mobs_and_objs_in_view_fast(get_turf(T), world.view)
		var/list/listening = listeners["mobs"]
		var/list/listening_obj = listeners["objs"]
		for(var/mob/M in listening)
			M.hear_holopad_talk(message_pieces, verb, src)
		for(var/obj/O in listening_obj)
			if(O == T) //Don't recieve your own speech
				continue
			O.hear_talk(src, message_pieces, verb)
		/*Radios "filter out" this conversation channel so we don't need to account for them.
		This is another way of saying that we won't bother dealing with them.*/
		var/list/combined = combine_message(message_pieces, verb, src)
		to_chat(src, "<span class='game say'><i>Holopad transmitted, <span class='name'>[real_name]</span> [combined["formatted"]]</i></span>")
	else
		to_chat(src, "<span class='filter_notice'>No holopad connected.</span>")
		return 0
	return 1

/mob/living/silicon/ai/proc/holopad_emote(var/message) //This is called when the AI uses the 'me' verb while using a holopad.
	message = trim(message)

	if(!message)
		return

	var/obj/machinery/hologram/holopad/T = src.holo
	if(T && T.masters[src])
		var/rendered = "<span class='game say'><span class='name'>[name]</span> <span class='message'>[message]</span></span>"
<<<<<<< HEAD
		to_chat(src, "<i><span class='game say'>Holopad action relayed, <span class='name'>[real_name]</span> <span class='message'>[message]</span></span></i>")
		var/obj/effect/overlay/aiholo/hologram = T.masters[src] //VOREStation Add for people in the hologram to hear the messages

		//var/obj/effect/overlay/hologram = T.masters[src] //VOREStation edit. Done above.
=======
		to_chat(src, "<span class='game say'><i>Holopad action relayed, <span class='name'>[real_name]</span> <span class='message'>[message]</span></i></span>")
		var/obj/effect/overlay/hologram = T.masters[src]
>>>>>>> 75577bd3ca9... cleans up so many to_chats so they use vchat filters, unsorted chat filter for everything else (#9006)
		var/list/in_range = get_mobs_and_objs_in_view_fast(get_turf(hologram), world.view, 2) //Emotes are displayed from the hologram, not the pad
		var/list/m_viewers = in_range["mobs"]
		var/list/o_viewers = in_range["objs"]

		for(var/mob/M in m_viewers)
			spawn(0)
				if(M)
					M.show_message(rendered, 2)

		for(var/obj/O in o_viewers)
			if(O == T)
				continue
			spawn(0)
				if(O)
					O.see_emote(src, message)

		log_emote("(HPAD) [message]", src)

	else //This shouldn't occur, but better safe then sorry.
		to_chat(src, "<span class='filter_notice'>No holopad connected.</span>")
		return 0
	return 1

/mob/living/silicon/ai/emote(var/act, var/m_type, var/message)
	var/obj/machinery/hologram/holopad/T = holo
	if(T && T.masters[src]) //Is the AI using a holopad?
		. = holopad_emote(message)
	else //Emote normally, then.
		. = ..()

#undef IS_AI
#undef IS_ROBOT
#undef IS_PAI
