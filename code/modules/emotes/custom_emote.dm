
/// This is the custom_emote that you'll want to use if you want the mob to be able to input their emote.
/mob/proc/custom_emote(var/m_type = VISIBLE_MESSAGE, var/message, var/range = world.view, var/check_stat = TRUE)

	if((check_stat && (src && stat)) || (!use_me && usr == src))
		to_chat(src, "You are unable to emote.")
		return

	var/input
	if(!message)
		input = sanitize(tgui_input_text(src,"Choose an emote to display."))
	else
		input = message
	process_normal_emote(m_type, message, input, range)

/// This is the custom_emote that you'll want to use if you're forcing something to custom emote with no input from the mob.
/// By default, we have a visible message, our range is world.view, and we do NOT check the stat.
/mob/proc/automatic_custom_emote(var/m_type = VISIBLE_MESSAGE, var/message, var/range = world.view, var/check_stat = FALSE)
	if(check_stat && (src && stat))
		return
	var/input = message
	process_automatic_emote(m_type, message, input, range)

//The actual meat and potatoes of the emote processing.
/mob/proc/process_normal_emote(var/m_type = VISIBLE_MESSAGE, var/message, var/input, var/range = world.view)
	var/list/formatted
	var/runemessage
	if(input)
		formatted = format_emote(src, message)
		if(!islist(formatted))
			return
		message = formatted["pretext"] + formatted["nametext"] + formatted["subtext"]
		runemessage = formatted["subtext"]
		// This is just personal preference (but I'm objectively right) that custom emotes shouldn't have periods at the end in runechat
		runemessage = replacetext(runemessage,".","",length(runemessage),length(runemessage)+1)
	else
		return

	log_the_emote(m_type, message, input, range, runemessage)

/mob/proc/format_the_emote(var/m_type = VISIBLE_MESSAGE, var/message, var/input, var/range = world.view)



/mob/proc/process_automatic_emote(var/m_type = VISIBLE_MESSAGE, var/message, var/input, var/range = world.view)
	var/list/formatted
	var/runemessage
	if(input)
		formatted = format_emote(src, message)
		if(!islist(formatted))
			return
		message = formatted["pretext"] + formatted["nametext"] + formatted["subtext"]
		runemessage = formatted["subtext"]
		// This is just personal preference (but I'm objectively right) that custom emotes shouldn't have periods at the end in runechat
		runemessage = replacetext(runemessage,".","",length(runemessage),length(runemessage)+1)
	else
		return

	build_the_emote(m_type, message, input, range, runemessage)

/mob/proc/log_the_emote(m_type, message, input, range, runemessage)
	log_emote(message,src) //Log before we add junk
	build_the_emote(m_type, message, input, range, runemessage)

/mob/proc/build_the_emote(m_type, message, input, range, runemessage)
	if(client)
		message = span_emote(span_bold("[src]") + " [input]")
	else
		message = span_npc_emote(span_bold("[src]") + " [input]")

	if(message)
		send_the_emote(m_type, message, input, range, runemessage)

/mob/proc/send_the_emote(m_type, message, input, range, runemessage)

	message = encode_html_emphasis(message)
	var/turf/T = get_turf(src)

	if(!T) return

	if(client)
		playsound(T, pick(GLOB.emote_sound), 75, TRUE, falloff = 1 , is_global = TRUE, frequency = voice_freq, ignore_walls = TRUE, preference = /datum/preference/toggle/emote_sounds)

	var/list/in_range = get_mobs_and_objs_in_view_fast(T,range,2,remote_ghosts = client ? TRUE : FALSE)
	var/list/m_viewers = in_range["mobs"]
	var/list/o_viewers = in_range["objs"]

	for(var/mob/M as anything in m_viewers)
		if(M)
			var/final_message = message
			if(isobserver(M))
				final_message = span_emote(span_bold("[src]") + " ([ghost_follow_link(src, M)]) [input]")
			if(src.client && M && !(get_z(src) == get_z(M)))
				final_message = span_multizsay("[final_message]")
			// If you are in the same tile, right next to, or being held by a person doing an emote, you should be able to see it while blind
			if(m_type != AUDIBLE_MESSAGE && (src.Adjacent(M) || (istype(src.loc, /obj/item/holder) && src.loc.loc == M)))
				M.show_message(final_message)
			else
				M.show_message(final_message, m_type)
			M.create_chat_message(src, "[runemessage]", FALSE, list("emote"), (m_type == AUDIBLE_MESSAGE))

	for(var/obj/O as anything in o_viewers)
		if(O)
			var/final_message = message
			if(src.client && O && !(get_z(src) == get_z(O)))
				final_message = span_multizsay("[final_message]")
			O.see_emote(src, final_message, m_type)
