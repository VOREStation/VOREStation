/mob
	///the icon currently used for the typing indicator's bubble
	var/mutable_appearance/active_typing_indicator
	///the icon currently used for the thinking indicator's bubble
	var/mutable_appearance/active_thinking_indicator

/** Creates a thinking indicator over the mob. Note: Prefs are checked in /client/proc/start_thinking() */
/mob/proc/create_thinking_indicator()
	if(active_thinking_indicator || active_typing_indicator || stat != CONSCIOUS || !HAS_TRAIT(src, TRAIT_THINKING_IN_CHARACTER))
		return FALSE
	var/cur_bubble_appearance = custom_speech_bubble
	if(!cur_bubble_appearance || cur_bubble_appearance == "default")
		cur_bubble_appearance = speech_bubble_appearance()
	active_thinking_indicator = mutable_appearance('icons/mob/talk_vr.dmi', "[cur_bubble_appearance]_thinking", FLOAT_LAYER)
	active_thinking_indicator.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	add_overlay(active_thinking_indicator)

/** Removes the thinking indicator over the mob. */
/mob/proc/remove_thinking_indicator()
	if(!active_thinking_indicator)
		return FALSE
	cut_overlay(active_thinking_indicator)
	active_thinking_indicator = null

/** Creates a typing indicator over the mob. Note: Prefs are checked in /client/proc/start_typing() */
/mob/proc/create_typing_indicator()
	if(active_typing_indicator || active_thinking_indicator || stat != CONSCIOUS || !HAS_TRAIT(src, TRAIT_THINKING_IN_CHARACTER))
		return FALSE
	var/cur_bubble_appearance = custom_speech_bubble
	if(!cur_bubble_appearance || cur_bubble_appearance == "default")
		cur_bubble_appearance = speech_bubble_appearance()
	active_typing_indicator = mutable_appearance('icons/mob/talk_vr.dmi', "[cur_bubble_appearance]_typing", ABOVE_MOB_LAYER)
	active_typing_indicator.appearance_flags |= (RESET_COLOR|PIXEL_SCALE)
	add_overlay(active_typing_indicator)

/** Removes the typing indicator over the mob. */
/mob/proc/remove_typing_indicator()
	if(!active_typing_indicator)
		return FALSE
	cut_overlay(active_typing_indicator)
	active_typing_indicator = null

/** Removes any indicators and marks the mob as not speaking IC. */
/mob/proc/remove_all_indicators()
	REMOVE_TRAIT(src, TRAIT_THINKING_IN_CHARACTER, CURRENTLY_TYPING_TRAIT)
	remove_thinking_indicator()
	remove_typing_indicator()

/mob/set_stat(new_stat)
	. = ..()
	if(.)
		remove_all_indicators()

/mob/Logout()
	remove_all_indicators()
	return ..()

/** Sets the mob as "thinking" - with indicator and the TRAIT_THINKING_IN_CHARACTER trait */
/datum/tgui_say/proc/start_thinking(channel)
	if(!window_open)
		return FALSE
	return client.start_thinking(channel)

/** Removes typing/thinking indicators and flags the mob as not thinking */
/datum/tgui_say/proc/stop_thinking(channel)
	return client.stop_thinking(channel)

/**
 * Handles the user typing. After a brief period of inactivity,
 * signals the client mob to revert to the "thinking" icon.
 */
/datum/tgui_say/proc/start_typing(channel)
	if(!window_open)
		return FALSE
	return client.start_typing(channel)
