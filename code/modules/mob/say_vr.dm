/mob/verb/me_verb_subtle(message as text)
	set name = "Subtle"
	set category = "IC"
	set desc = "Emote to nearby people (and your pred/prey)"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "Speech is currently admin-disabled."
		return

	message = strip_html_properly(message)

	set_typing_indicator(0)
	if(use_me)
	else
		usr.emote(message)
