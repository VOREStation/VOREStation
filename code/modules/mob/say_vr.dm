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
	if(!message)
		return

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
		log_subtle("[name]/[key] : [message]")

		var/list/vis = get_mobs_and_objs_in_view_fast(get_turf(src),1,2) //Turf, Range, and type 2 is emote
		var/list/vis_mobs = vis["mobs"]
		var/list/vis_objs = vis["objs"]

		for(var/vismob in vis_mobs)
			var/mob/M = vismob
			spawn(0)
				M.show_message(message, 2)

		for(var/visobj in vis_objs)
			var/obj/O = visobj
			spawn(0)
				O.see_emote(src, message, 2)

/mob/proc/emote_vr(var/act, var/type, var/message) //This would normally go in say.dm
	if(act == "me")
		return custom_emote_vr(type, message)
