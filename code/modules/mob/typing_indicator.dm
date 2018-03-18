/mob/proc/set_typing_indicator(var/state) //Leaving this here for mobs.

	if(!is_preference_enabled(/datum/client_preference/show_typing_indicator))
		cut_overlay(typing_indicator, TRUE)
		return

	if(!typing_indicator)
		typing_indicator = new
		//typing_indicator.icon = 'icons/mob/talk_vr.dmi' //VOREStation Edit - Looks better on the right with job icons.
		//typing_indicator.icon_state = "typing"
		typing_indicator.icon = 'icons/mob/talk_vr.dmi' //VOREStation Edit - talk_vr.dmi instead of talk.dmi for right-side icons
		typing_indicator.icon_state = "[speech_bubble_appearance()]_typing"

	if(state && !typing)
		add_overlay(typing_indicator, TRUE)
		typing = TRUE
	else if(typing)
		cut_overlay(typing_indicator, TRUE)
		typing = FALSE

	if(shadow) //Multi-Z above-me shadows
		shadow.set_typing_indicator(state)

	return state

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1

	set_typing_indicator(TRUE)
	var/message = input("","say (text)") as text
	set_typing_indicator(FALSE)
	
	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	set_typing_indicator(TRUE)
	var/message = input("","me (text)") as text
	set_typing_indicator(FALSE)

	if(message)
		me_verb(message)
