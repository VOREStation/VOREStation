// All mobs should have custom emote, really..
//m_type == 1 --> visual.
//m_type == 2 --> audible
/mob/proc/custom_emote(var/m_type=1,var/message = null,var/range=world.view)
	if(stat || !use_me && usr == src)
		to_chat(src, "You are unable to emote.")
		return

	var/muzzled = is_muzzled()
	if(m_type == 2 && muzzled) return

	var/input
	if(!message)
		input = sanitize_or_reflect(input(src,"Choose an emote to display.") as text|null, src) //VOREStation Edit - Reflect too long messages, within reason
	else
		input = message
	if(input)
		log_emote(message,src) //Log before we add junk
		message = "<span class='emote'><B>[src]</B> [input]</span>"
	else
		return


	if (message)
		message = encode_html_emphasis(message)

 // Hearing gasp and such every five seconds is not good emotes were not global for a reason.
 // Maybe some people are okay with that.

		var/turf/T = get_turf(src)
		if(!T) return
		var/list/in_range = get_mobs_and_objs_in_view_fast(T,range,2,remote_ghosts = client ? TRUE : FALSE)
		var/list/m_viewers = in_range["mobs"]
		var/list/o_viewers = in_range["objs"]

		for(var/mob in m_viewers)
			var/mob/M = mob
			spawn(0) // It's possible that it could be deleted in the meantime, or that it runtimes.
				if(M)
					if(isobserver(M))
						//VOREStation Edit Start
						var/mob/observer/dead/D = M
						if(ckey || (src in view(D)))
							M.show_message(message, m_type)
							message = "<span class='emote'><B>[src]</B> ([ghost_follow_link(src, M)]) [input]</span>"
					else
						M.show_message(message, m_type)
						//VOREStation Edit End

		for(var/obj in o_viewers)
			var/obj/O = obj
			spawn(0)
				if(O)
					O.see_emote(src, message, m_type)

// Shortcuts for above proc
/mob/proc/visible_emote(var/act_desc)
	custom_emote(1, act_desc)

/mob/proc/audible_emote(var/act_desc)
	custom_emote(2, act_desc)

/mob/proc/emote_dead(var/message)

	if(client.prefs.muted & MUTE_DEADCHAT)
		to_chat(src, "<span class='danger'>You cannot send deadchat emotes (muted).</span>")
		return

	if(!is_preference_enabled(/datum/client_preference/show_dsay))
		to_chat(src, "<span class='danger'>You have deadchat muted.</span>")
		return

	if(!src.client.holder)
		if(!config.dsay_allowed)
			to_chat(src, "<span class='danger'>Deadchat is globally muted.</span>")
			return


	var/input
	if(!message)
		input = sanitize_or_reflect(input(src, "Choose an emote to display.") as text|null, src) //VOREStation Edit - Reflect too long messages, within reason
	else
		input = message

	input = encode_html_emphasis(input)

	if(input)
		log_ghostemote(input, src)
		if(!invisibility) //If the ghost is made visible by admins or cult. And to see if the ghost has toggled its own visibility, as well. -Mech
			visible_message("<span class='deadsay'><B>[src]</B> [input]</span>")
		else
			say_dead_direct(input, src)
