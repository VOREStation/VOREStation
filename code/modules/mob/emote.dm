// Shortcuts for above proc
/mob/proc/visible_emote(var/act_desc)
	custom_emote(VISIBLE_MESSAGE, act_desc)

/mob/proc/audible_emote(var/act_desc)
	custom_emote(AUDIBLE_MESSAGE, act_desc)

/mob/proc/emote_dead(var/message)

	if(client.prefs.muted & MUTE_DEADCHAT)
		to_chat(src, span_danger("You cannot send deadchat emotes (muted)."))
		return

	if(!client?.prefs?.read_preference(/datum/preference/toggle/show_dsay))
		to_chat(src, span_danger("You have deadchat muted."))
		return

	if(!check_rights(R_HOLDER, FALSE))
		if(!CONFIG_GET(flag/dsay_allowed))
			to_chat(src, span_danger("Deadchat is globally muted."))
			return


	var/input
	if(!message)
		input = tgui_input_text(src, "Choose an emote to display.", max_length=MAX_HUGE_MESSAGE_LEN)
		reflect_if_needed(input, src)
	else
		input = message

	input = encode_html_emphasis(input)

	if(input)
		log_ghostemote(input, src)
		if(!invisibility) //If the ghost is made visible by admins or cult. And to see if the ghost has toggled its own visibility, as well. -Mech
			visible_message(span_deadsay(span_bold("[src]") + " [input]"))
		else
			say_dead_direct(input, src)
