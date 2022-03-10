//////////////////////////////////////////////////////
////////////////////SUBTLE COMMAND////////////////////
//////////////////////////////////////////////////////

/mob/verb/me_verb_subtle(message as message) //This would normally go in say.dm
	set name = "Subtle"
	set category = "IC"
	set desc = "Emote to nearby people (and your pred/prey)"

	if(say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "Speech is currently admin-disabled.")
		return
	//VOREStation Addition Start
	if(forced_psay)
		pme(message)
		return
	//VOREStation Addition End

	message = sanitize_or_reflect(message,src) //VOREStation Edit - Reflect too-long messages (within reason)
	if(!message)
		return

	set_typing_indicator(FALSE)
	if(use_me)
		usr.emote_vr("me",4,message)
	else
		usr.emote_vr(message)

/mob/proc/custom_emote_vr(var/m_type=1,var/message = null) //This would normally go in emote.dm
	if(stat || !use_me && usr == src)
		to_chat(src, "You are unable to emote.")
		return

	//VOREStation Addition Start
	if(forced_psay)
		pme(message)
		return
	//VOREStation Addition End

	var/muzzled = is_muzzled()
	if(m_type == 2 && muzzled) return

	var/input
	if(!message)
		input = sanitize_or_reflect(input(src,"Choose an emote to display.") as text|null, src)
	else
		input = message

	if(input)
		log_subtle(message,src)
		message = "<span class='emote_subtle'><B>[src]</B> <I>[input]</I></span>"
	else
		return

	if (message)
		var/undisplayed_message = "<span class='emote'><B>[src]</B> <I>does something too subtle for you to see.</I></span>"
		message = encode_html_emphasis(message)

		var/list/vis = get_mobs_and_objs_in_view_fast(get_turf(src),1,2) //Turf, Range, and type 2 is emote
		var/list/vis_mobs = vis["mobs"]
		var/list/vis_objs = vis["objs"]

		for(var/mob/M as anything in vis_mobs)
			if(isobserver(M) && !is_preference_enabled(/datum/client_preference/whisubtle_vis) && !M.client?.holder)
				spawn(0)
					M.show_message(undisplayed_message, 2)
			else
				spawn(0)
					M.show_message(message, 2)

		for(var/obj/O as anything in vis_objs)
			spawn(0)
				O.see_emote(src, message, 2)

/mob/proc/emote_vr(var/act, var/type, var/message) //This would normally go in say.dm
	if(act == "me")
		return custom_emote_vr(type, message)

#define MAX_HUGE_MESSAGE_LEN 8192
#define POST_DELIMITER_STR "\<\>"
/proc/sanitize_or_reflect(message,user)
	//Way too long to send
	if(length(message) > MAX_HUGE_MESSAGE_LEN)
		fail_to_chat(user)
		return

	message = sanitize(message, max_length = MAX_HUGE_MESSAGE_LEN)

	//Came back still too long to send
	if(length(message) > MAX_MESSAGE_LEN)
		fail_to_chat(user,message)
		return null
	else
		return message

// returns true if it failed
/proc/reflect_if_needed(message, user)
	if(length(message) > MAX_HUGE_MESSAGE_LEN)
		fail_to_chat(user)
		return TRUE
	return FALSE

/proc/fail_to_chat(user,message)
	if(!message)
		to_chat(user, "<span class='danger'>Your message was NOT SENT, either because it was FAR too long, or sanitized to nothing at all.</span>")
		return

	var/length = length(message)
	var/posts = CEILING((length/MAX_MESSAGE_LEN), 1)
	to_chat(user,message)
	to_chat(user, "<span class='danger'>^ This message was NOT SENT ^ -- It was [length] characters, and the limit is [MAX_MESSAGE_LEN]. It would fit in [posts] separate messages.</span>")
#undef MAX_HUGE_MESSAGE_LEN

///// PSAY /////

/mob/verb/psay(message as text|null)
	set category = "Abilities"
	set name = "Psay"
	set desc = "Talk to an absorbed or dominated predator/prey."

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot speak in IC (muted).</span>")
			return
	message = sanitize_or_reflect(message,src)
	if (!message)
		message = input(usr, "Type a message to say.","Psay") as text|null
	if (!message)
		return	
	if (stat == DEAD)
		return say_dead(message)
	if(!isliving(src))
		forced_psay = FALSE
		say(message)
	var/f = FALSE		//did we find someone to send the message to other than ourself?
	var/mob/living/pb	//predator body
	var/mob/living/M = src
	if(istype(M, /mob/living/dominated_brain))
		var/mob/living/dominated_brain/db = M
		if(db.loc != db.pred_body)
			to_chat(db, "<span class='danger'>You aren't inside of a brain anymore!!!</span>")
			qdel(db)	//Oh no, dominated brains shouldn't exist outside of the body, so if we got here something went very wrong.
			return
		else
			pb = db.pred_body
			to_chat(pb, "<span class='changeling'>The captive mind of \the [M] thinks, \"[message]\"</span>")	//To our pred if dominated brain
			f = TRUE
	else if(M.forced_psay && M.absorbed)
		if(isbelly(M.loc))
			pb = M.loc.loc
			to_chat(pb, "<span class='changeling'>\The [M] thinks, \"[message]\"</span>")	//To our pred if absorbed
			f = TRUE
		else
			M.forced_psay = FALSE
			M.say(message)
	
	if(pb)	//We are prey, let's do the prey thing.

		for(var/I in pb.contents)
			if(istype(I, /mob/living/dominated_brain) && I != M)
				var/mob/living/dominated_brain/db = I
				to_chat(db, "<span class='changeling'>The captive mind of \the [M] thinks, \"[message]\"</span>")	//To any dominated brains in the pred
				f = TRUE
		for(var/B in pb.vore_organs)
			for(var/mob/living/L in B)
				if(L.absorbed && L != M)
					to_chat(L, "<span class='changeling'>\The [M] thinks, \"[message]\"</span>")	//To any absorbed people in the pred
					f = TRUE

	//Let's also check and see if there's anyone inside of us to send the message to.
	for(var/I in M.contents)
		if(istype(I, /mob/living/dominated_brain))
			var/mob/living/dominated_brain/db = I
			to_chat(db, "<span class='changeling'><b>\The [M] thinks, \"[message]\"</b></span>")	//To any dominated brains inside us
			f = TRUE
	for(var/B in M.vore_organs)
		for(var/mob/living/L in B)
			if(L.absorbed)
				to_chat(L, "<span class='changeling'><b>\The [M] thinks, \"[message]\"</b></span>")	//To any absorbed people inside us
				f = TRUE

	if(f)	//We found someone to send the message to, let's not print the failed message.
		to_chat(M, "<span class='changeling'><b>You think \"[message]\"</b></span>")	//To us, if we found anyone to send the message to
		for (var/mob/G in player_list)
			if (istype(G, /mob/new_player))
				continue
			else if(G.stat == DEAD && G.is_preference_enabled(/datum/client_preference/ghost_ears))
				to_chat(G, "<span class='changeling'><b>\The [M] thinks, \"[message]\"</b></span>")
		log_say(message,M)
	else
		to_chat(M, "<span class='warning'>There is no one inside you to talk to... ([message])</span>")	//So sad

///// PME /////

/mob/verb/pme(message as text|null)
	set category = "Abilities"
	set name = "Pme"
	set desc = "Emote to an absorbed or dominated predator/prey."

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, "<span class='warning'>You cannot speak in IC (muted).</span>")
			return
	message = sanitize_or_reflect(message,src)
	if (!message)
		message = input(usr, "Type a message to emote.","Pme") as text|null
	if (!message)
		return	
	if (stat == DEAD)
		return say_dead(message)
	if(!isliving(src))
		forced_psay = FALSE
		me_verb(message)
	var/f = FALSE		//did we find someone to send the message to other than ourself?
	var/mob/living/pb	//predator body
	var/mob/living/M = src
	if(istype(M, /mob/living/dominated_brain))
		var/mob/living/dominated_brain/db = M
		if(db.loc != db.pred_body)
			to_chat(db, "<span class='danger'>You aren't inside of a brain anymore!!!</span>")
			qdel(db)	//Oh no, dominated brains shouldn't exist outside of the body, so if we got here something went very wrong.
			return
		else
			pb = db.pred_body
	if(M.forced_psay)
		if(isbelly(M.loc) && M.absorbed)
			pb = M.loc.loc
		else
			M.forced_psay = FALSE
			M.me_verb(message)
	
	if(pb)	//We are prey, let's do the prey thing.

		to_chat(pb, "<span class='changeling'>\The [M] [message]</span>")	//To our pred
		f = TRUE
		for(var/I in pb.contents)
			if(istype(I, /mob/living/dominated_brain) && I != M)
				var/mob/living/dominated_brain/db = I
				to_chat(db, "<span class='changeling'>\The [M] [message]</span>")	//To any dominated brains in the pred
				f = TRUE
		for(var/B in pb.vore_organs)
			for(var/mob/living/L in B)
				if(L.absorbed && L != M)
					to_chat(L, "<span class='changeling'>\The [M] [message]</span>")	//To any absorbed people in the pred
					f = TRUE

	//Let's also check and see if there's anyone inside of us to send the message to.
	for(var/I in M.contents)
		if(istype(I, /mob/living/dominated_brain))
			var/mob/living/dominated_brain/db = I
			to_chat(db, "<span class='changeling'><b>\The [M] [message]</b></span>")	//To any dominated brains inside us
			f = TRUE
	for(var/B in M.vore_organs)
		for(var/mob/living/L in B)
			if(L.absorbed)
				to_chat(L, "<span class='changeling'><b>\The [M] [message]</b></span>")	//To any absorbed people inside us
				f = TRUE

	if(f)	//We found someone to send the message to, let's not print the failed message.
		to_chat(M, "<span class='changeling'><b>\The [M] [message]</b></span>")	//To us, if we found anyone to send the message to
		for (var/mob/G in player_list)
			if (istype(G, /mob/new_player))
				continue
			else if(G.stat == DEAD && G.is_preference_enabled(/datum/client_preference/ghost_ears))
				to_chat(G, "<span class='changeling'><b>\The [M] [message]</b></span>")
		log_say(message,M)
	else
		to_chat(M, "<span class='warning'>There is no one inside you to talk to... ([message])</span>")	//So sad
