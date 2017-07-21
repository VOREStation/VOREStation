// All mobs should have custom emote, really..
//m_type == 1 --> visual.
//m_type == 2 --> audible
/mob/proc/custom_emote(var/m_type=1,var/message = null,var/range=world.view)
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
		message = "<B>[src]</B> [input]"
	else
		return


	if (message)
		log_emote("[name]/[key] : [message]")

		message = say_emphasis(message)

 // Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		var/turf/T = get_turf(src)
		if(!T) return
		var/list/in_range = get_mobs_and_objs_in_view_fast(T,range,2)
		var/list/m_viewers = in_range["mobs"]
		var/list/o_viewers = in_range["objs"]

		for(var/mob in m_viewers)
			var/mob/M = mob
			spawn(0) // It's possible that it could be deleted in the meantime, or that it runtimes.
				if(M)
					M.show_message(message, m_type)

		for(var/obj in o_viewers)
			var/obj/O = obj
			spawn(0)
				if(O)
					O.see_emote(src, message, m_type)

/mob/proc/emote_dead(var/message)

	if(client.prefs.muted & MUTE_DEADCHAT)
		src << "<span class='danger'>You cannot send deadchat emotes (muted).</span>"
		return

	if(!is_preference_enabled(/datum/client_preference/show_dsay))
		src << "<span class='danger'>You have deadchat muted.</span>"
		return

	if(!src.client.holder)
		if(!config.dsay_allowed)
			src << "<span class='danger'>Deadchat is globally muted.</span>"
			return


	var/input
	if(!message)
		input = sanitize(input(src, "Choose an emote to display.") as text|null)
	else
		input = message

	input = say_emphasis(input)

	if(input)
		log_emote("Ghost/[src.key] : [input]")
		if(!invisibility) //If the ghost is made visible by admins or cult. And to see if the ghost has toggled its own visibility, as well. -Mech
			visible_message("<span class='deadsay'><B>[src]</B> [input]</span>")
		else
			say_dead_direct(input, src)
