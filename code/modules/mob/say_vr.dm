//////////////////////////////////////////////////////
////////////////////SUBTLE COMMAND////////////////////
//////////////////////////////////////////////////////

/mob/verb/me_verb_subtle(message as text) //This would normally go in say.dm
	set name = "Subtle"
	set category = "IC"
	set desc = "Emote to nearby people (and your pred/prey)"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "Speech is currently admin-disabled."
		return

	message = sanitize(message)

	set_typing_indicator(0)
	if(use_me)
		usr.emote_vr("me",4,message)
	else
		usr.emote_vr(message)



/mob/proc/custom_emote_vr(var/m_type=1,var/message = null) //This would normally go in emote.dm
	if(stat || !use_me && usr == src)
		src << "You are unable to emote."
		return

	var/muzzled = is_muzzled()
	if(m_type == 2 && muzzled) return

	var/input
	if(!message)
		input = sanitize(input(src,"Choose an emote to display.") as text|null)
	else
		input = message

	if(input)
		message = "<B>[src]</B> <I>[input]</I>"
	else
		return


	if (message)
		log_emote("[name]/[key] : [message]")

		for(var/mob/M in player_list)
			if (!M.client)
				continue //skip monkeys and leavers
			if (istype(M, /mob/new_player))
				continue
			if(findtext(message," snores.")) //Because we have so many sleeping people.
				break
			if(M.stat == DEAD && M.is_preference_enabled(/datum/client_preference/ghost_sight) && !(M in viewers(src,null)))
				M.show_message(message, m_type)
		var/list/subtle = get_mobs_or_objects_in_view(1,src)
		for(var/I in subtle)
			if(isobj(I))
				spawn(0)
					if(I) //It's possible that it could be deleted in the meantime.
						var/obj/O = I
						O.see_emote(src, message, 2)
			else if(ismob(I))
				var/mob/M = I
				M.show_message(message, 2)



/mob/proc/emote_vr(var/act, var/type, var/message) //This would normally go in say.dm
	if(act == "me")
		return custom_emote_vr(type, message)