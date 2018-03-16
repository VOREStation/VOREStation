/mob/proc/set_typing_indicator(var/state) //Leaving this here for mobs.

	if(!typing_indicator)
		typing_indicator = new
		//typing_indicator.icon = 'icons/mob/talk_vr.dmi' //VOREStation Edit - Looks better on the right with job icons.
		//typing_indicator.icon_state = "typing"
		typing_indicator.icon = 'icons/mob/talk_vr.dmi' //VOREStation Edit - talk_vr.dmi instead of talk.dmi for right-side icons
		typing_indicator.icon_state = "[speech_bubble_appearance()]_typing"

	if(client && !stat)
		typing_indicator.invisibility = invisibility
		if(!is_preference_enabled(/datum/client_preference/show_typing_indicator))
			add_overlay(typing_indicator)
		else
			if(state)
				if(!typing)
					add_overlay(typing_indicator)
					typing = 1
			else
				if(typing)
					cut_overlay(typing_indicator)
					typing = 0
			return state

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1

	if(!ishuman(src)) //If they're a mob, use the old code.
		set_typing_indicator(1)
	else if(is_preference_enabled(/datum/client_preference/show_typing_indicator))
		hud_typing = 1

	var/message = input("","say (text)") as text

	if(!ishuman(src)) //If they're a mob, use the old code.
		set_typing_indicator(0)
	else if(is_preference_enabled(/datum/client_preference/show_typing_indicator))
		hud_typing = 0

	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	if(!ishuman(src)) //If they're a mob, use the old code.
		set_typing_indicator(1)
	else if(is_preference_enabled(/datum/client_preference/show_typing_indicator))
		hud_typing = 1

	var/message = input("","me (text)") as text

	if(is_preference_enabled(/datum/client_preference/show_typing_indicator))
		hud_typing = 0
	else if(!ishuman(src)) //If they're a mob, use the old code.
		set_typing_indicator(0)

	if(message)
		me_verb(message)
