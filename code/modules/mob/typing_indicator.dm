/mob/proc/set_typing_indicator(var/state) //Leaving this here for mobs.

	if(!typing_indicator)
		typing_indicator = new
		typing_indicator.icon = 'icons/mob/talk.dmi'
		typing_indicator.icon_state = "[speech_bubble_appearance()]_typing"

	if(client && !stat)
		typing_indicator.invisibility = invisibility
		if(!is_preference_enabled(/datum/client_preference/show_typing_indicator))
			overlays -= typing_indicator
		else
			if(state)
				if(!typing)
					overlays += typing_indicator
					typing = 1
			else
				if(typing)
					overlays -= typing_indicator
					typing = 0
			return state

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = 1

	if(!ishuman(src)) //If they're a mob, use the old code.
		set_typing_indicator(1)
	if(is_preference_enabled(/datum/client_preference/show_typing_indicator))
		hud_typing = 1
		update_icons_huds()
	var/message = input("","say (text)") as text
	if(is_preference_enabled(/datum/client_preference/show_typing_indicator))
		hud_typing = 0
		update_icons_huds()
	if(!ishuman(src)) //If they're a mob, use the old code.
		set_typing_indicator(0)
	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = 1

	if(!ishuman(src)) //If they're a mob, use the old code.
		set_typing_indicator(1)
	if(is_preference_enabled(/datum/client_preference/show_typing_indicator))
		hud_typing = 1
		update_icons_huds()
	var/message = input("","me (text)") as text
	if(is_preference_enabled(/datum/client_preference/show_typing_indicator))
		hud_typing = 0
		update_icons_huds()
	if(!ishuman(src)) //If they're a mob, use the old code.
		set_typing_indicator(0)
	if(message)
		me_verb(message)
