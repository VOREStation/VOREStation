// Proc: add_communicating()
// Parameters: 1 (comm - the communicator to add to communicating)
// Description: Used when this communicator gets a new communicator to relay say/me messages to
/obj/item/device/communicator/proc/add_communicating(obj/item/device/communicator/comm)
	if(!comm || !istype(comm)) return

	communicating |= comm
	listening_objects |= src
	update_icon()

// Proc: del_communicating()
// Parameters: 1 (comm - the communicator to remove from communicating)
// Description: Used when this communicator is being asked to stop relaying say/me messages to another
/obj/item/device/communicator/proc/del_communicating(obj/item/device/communicator/comm)
	if(!comm || !istype(comm)) return

	communicating.Remove(comm)
	update_icon()

// Proc: open_connection()
// Parameters: 2 (user - the person who initiated the connecting being opened, candidate - the communicator or observer that will connect to the device)
// Description: Typechecks the candidate, then calls the correct proc for further connecting.
/obj/item/device/communicator/proc/open_connection(mob/user, var/atom/candidate)
	if(isobserver(candidate))
		voice_invites.Remove(candidate)
		open_connection_to_ghost(user, candidate)
	else
		if(istype(candidate, /obj/item/device/communicator))
			open_connection_to_communicator(user, candidate)

// Proc: open_connection_to_communicator()
// Parameters: 2 (user - the person who initiated this and will be receiving feedback information, candidate - someone else's communicator)
// Description: Adds the candidate and src to each other's communicating lists, allowing messages seen by the devices to be relayed.
/obj/item/device/communicator/proc/open_connection_to_communicator(mob/user, var/atom/candidate)
	if(!istype(candidate, /obj/item/device/communicator))
		return
	var/obj/item/device/communicator/comm = candidate
	voice_invites.Remove(candidate)
	comm.voice_requests.Remove(src)

	if(user)
		comm.visible_message("<span class='notice'>\icon[src][bicon(src)] Connecting to [src].</span>")
		to_chat(user, "<span class='notice'>\icon[src][bicon(src)] Attempting to call [comm].</span>")
		sleep(10)
		to_chat(user, "<span class='notice'>\icon[src][bicon(src)] Dialing internally from [station_name()], [system_name()].</span>")
		sleep(20) //If they don't have an exonet something is very wrong and we want a runtime.
		to_chat(user, "<span class='notice'>\icon[src][bicon(src)] Connection re-routed to [comm] at [comm.exonet.address].</span>")
		sleep(40)
		to_chat(user, "<span class='notice'>\icon[src][bicon(src)] Connection to [comm] at [comm.exonet.address] established.</span>")
		comm.visible_message("<span class='notice'>\icon[src][bicon(src)] Connection to [src] at [exonet.address] established.</span>")
		sleep(20)

	src.add_communicating(comm)
	comm.add_communicating(src)

// Proc: open_connection_to_ghost()
// Parameters: 2 (user - the person who initiated this, candidate - the ghost that will be turned into a voice mob)
// Description: Pulls the candidate ghost from deadchat, makes a new voice mob, transfers their identity, then their client.
/obj/item/device/communicator/proc/open_connection_to_ghost(mob/user, var/mob/candidate)
	if(!isobserver(candidate))
		return
	//Handle moving the ghost into the new shell.
	announce_ghost_joinleave(candidate, 0, "They are occupying a personal communications device now.")
	voice_requests.Remove(candidate)
	voice_invites.Remove(candidate)
	var/mob/living/voice/new_voice = new /mob/living/voice(src) 	//Make the voice mob the ghost is going to be.
	new_voice.transfer_identity(candidate) 	//Now make the voice mob load from the ghost's active character in preferences.
	//Do some simple logging since this is a tad risky as a concept.
	var/msg = "[candidate && candidate.client ? "[candidate.client.key]" : "*no key*"] ([candidate]) has entered [src], triggered by \
	[user && user.client ? "[user.client.key]" : "*no key*"] ([user ? "[user]" : "*null*"]) at [x],[y],[z].  They have joined as [new_voice.name]."
	message_admins(msg)
	log_game(msg)
	new_voice.mind = candidate.mind			//Transfer the mind, if any.
	new_voice.ckey = candidate.ckey			//Finally, bring the client over.
	voice_mobs.Add(new_voice)
	listening_objects |= src

	var/obj/screen/blackness = new() 	//Makes a black screen, so the candidate can't see what's going on before actually 'connecting' to the communicator.
	blackness.screen_loc = ui_entire_screen
	blackness.icon = 'icons/effects/effects.dmi'
	blackness.icon_state = "1"
	blackness.mouse_opacity = 2			//Can't see anything!
	new_voice.client.screen.Add(blackness)

	update_icon()

	//Now for some connection fluff.
	if(user)
		to_chat(user, "<span class='notice'>\icon[src][bicon(src)] Connecting to [candidate].</span>")
	to_chat(new_voice, "<span class='notice'>\icon[src][bicon(src)] Attempting to call [src].</span>")
	sleep(10)
	to_chat(new_voice, "<span class='notice'>\icon[src][bicon(src)] Dialing to [station_name()], Kara Subsystem, [system_name()].</span>")
	sleep(20)
	to_chat(new_voice, "<span class='notice'>\icon[src][bicon(src)] Connecting to [station_name()] telecommunications array.</span>")
	sleep(40)
	to_chat(new_voice, "<span class='notice'>\icon[src][bicon(src)] Connection to [station_name()] telecommunications array established.  Redirecting signal to [src].</span>")
	sleep(20)

	//We're connected, no need to hide everything.
	new_voice.client.screen.Remove(blackness)
	qdel(blackness)

	to_chat(new_voice, "<span class='notice'>\icon[src][bicon(src)] Connection to [src] established.</span>")
	to_chat(new_voice, "<b>To talk to the person on the other end of the call, just talk normally.</b>")
	to_chat(new_voice, "<b>If you want to end the call, use the 'Hang Up' verb.  The other person can also hang up at any time.</b>")
	to_chat(new_voice, "<b>Remember, your character does not know anything you've learned from observing!</b>")
	if(new_voice.mind)
		new_voice.mind.assigned_role = "Disembodied Voice"
	if(user)
		to_chat(user, "<span class='notice'>\icon[src][bicon(src)] Your communicator is now connected to [candidate]'s communicator.</span>")

// Proc: close_connection()
// Parameters: 3 (user - the user who initiated the disconnect, target - the mob or device being disconnected, reason - string shown when disconnected)
// Description: Deletes specific voice_mobs or disconnects communicators, and shows a message to everyone when doing so.  If target is null, all communicators
//				and voice mobs are removed.
/obj/item/device/communicator/proc/close_connection(mob/user, var/atom/target, var/reason)
	if(voice_mobs.len == 0 && communicating.len == 0)
		return

	for(var/mob/living/voice/voice in voice_mobs) //Handle ghost-callers
		if(target && voice != target) //If no target is inputted, it deletes all of them.
			continue
		to_chat(voice, "<span class='danger'>\icon[src][bicon(src)] [reason].</span>")
		visible_message("<span class='danger'>\icon[src][bicon(src)] [reason].</span>")
		voice_mobs.Remove(voice)
		qdel(voice)
		update_icon()

	for(var/obj/item/device/communicator/comm in communicating) //Now we handle real communicators.
		if(target && comm != target)
			continue
		src.del_communicating(comm)
		comm.del_communicating(src)
		comm.visible_message("<span class='danger'>\icon[src][bicon(src)] [reason].</span>")
		visible_message("<span class='danger'>\icon[src][bicon(src)] [reason].</span>")
		if(comm.camera && video_source == comm.camera) //We hung up on the person on video
			end_video()
		if(camera && comm.video_source == camera) //We hung up on them while they were watching us
			comm.end_video()

	if(voice_mobs.len == 0 && communicating.len == 0)
		listening_objects.Remove(src)

// Proc: request()
// Parameters: 1 (candidate - the ghost or communicator wanting to call the device)
// Description: Response to a communicator or observer trying to call the device.  Adds them to the list of requesters
/obj/item/device/communicator/proc/request(var/atom/candidate)
	if(candidate in voice_requests)
		return
	var/who = null
	if(isobserver(candidate))
		who = candidate.name
	else if(istype(candidate, /obj/item/device/communicator))
		var/obj/item/device/communicator/comm = candidate
		who = comm.owner
		comm.voice_invites |= src

	if(!who)
		return

	voice_requests |= candidate

	if(ringer)
		playsound(src, 'sound/machines/twobeep.ogg', 50, 1)
		for (var/mob/O in hearers(2, loc))
			O.show_message(text("\icon[src][bicon(src)] *beep*"))

	alert_called = 1
	update_icon()

	//Search for holder of the device.
	var/mob/living/L = null
	if(loc && isliving(loc))
		L = loc

	if(L)
		to_chat(L, "<span class='notice'>\icon[src][bicon(src)] Communications request from [who].</span>")

// Proc: del_request()
// Parameters: 1 (candidate - the ghost or communicator to be declined)
// Description: Declines a request and cleans up both ends
/obj/item/device/communicator/proc/del_request(var/atom/candidate)
	if(!(candidate in voice_requests))
		return

	if(isobserver(candidate))
		to_chat(candidate, "<span class='warning'>Your communicator call request was declined.</span>")
	else if(istype(candidate, /obj/item/device/communicator))
		var/obj/item/device/communicator/comm = candidate
		comm.voice_invites -= src

	voice_requests -= candidate

	//Search for holder of our device.
	var/mob/living/us = null
	if(loc && isliving(loc))
		us = loc

	if(us)
		to_chat(us, "<span class='notice'>\icon[src][bicon(src)] Declined request.</span>")

// Proc: see_emote()
// Parameters: 2 (M - the mob the emote originated from, text - the emote's contents)
// Description: Relays the emote to all linked communicators.
/obj/item/device/communicator/see_emote(mob/living/M, text)
	var/rendered = "\icon[src][bicon(src)] <span class='message'>[text]</span>"
	for(var/obj/item/device/communicator/comm in communicating)
		var/turf/T = get_turf(comm)
		if(!T) return
		//VOREStation Edit Start for commlinks
		var/list/mobs_to_relay
		if(istype(comm,/obj/item/device/communicator/commlink))
			var/obj/item/device/communicator/commlink/CL = comm
			mobs_to_relay = list(CL.nif.human)
		else
			var/list/in_range = get_mobs_and_objs_in_view_fast(T,world.view,0) //Range of 3 since it's a tiny video display
			mobs_to_relay = in_range["mobs"]
		//VOREStation Edit End

		for(var/mob/mob in mobs_to_relay) //We can't use visible_message(), or else we will get an infinite loop if two communicators hear each other.
			var/dst = get_dist(get_turf(mob),get_turf(comm))
			if(dst <= video_range)
				mob.show_message(rendered)
			else
				to_chat(mob, "You can barely see some movement on \the [src]'s display.")

	..()

// Proc: hear_talk()
// Parameters: 3 (M - the mob the speech originated from,
//                list/message_pieces - what is being said w/ baked languages,
//                verb - the word used to describe how text is being said)
// Description: Relays the speech to all linked communicators.
/obj/item/device/communicator/hear_talk(mob/M, list/message_pieces, verb)
	for(var/obj/item/device/communicator/comm in communicating)
		var/turf/T = get_turf(comm)
		if(!T) return
		//VOREStation Edit Start for commlinks
		var/list/mobs_to_relay
		if(istype(comm,/obj/item/device/communicator/commlink))
			var/obj/item/device/communicator/commlink/CL = comm
			mobs_to_relay = list(CL.nif.human)
		else
			var/list/in_range = get_mobs_and_objs_in_view_fast(T,world.view,0) //Range of 3 since it's a tiny video display
			mobs_to_relay = in_range["mobs"]
		//VOREStation Edit End

		for(var/mob/mob in mobs_to_relay)
			var/list/combined = mob.combine_message(message_pieces, verb, M)
			var/message = combined["formatted"]
			var/name_used = M.GetVoice()
			var/rendered = null
			rendered = "<span class='game say'>\icon[src][bicon(src)] <span class='name'>[name_used]</span> [message]</span>"
			mob.show_message(rendered, 2)

// Proc: show_message()
// Parameters: 4 (msg - the message, type - number to determine if message is visible or audible, alt - unknown, alt_type - unknown)
// Description: Relays the message to all linked communicators.
/obj/item/device/communicator/show_message(msg, type, alt, alt_type)
	var/rendered = "\icon[src][bicon(src)] <span class='message'>[msg]</span>"
	for(var/obj/item/device/communicator/comm in communicating)
		var/turf/T = get_turf(comm)
		if(!T) return
		var/list/in_range = get_mobs_and_objs_in_view_fast(T,world.view,0)
		var/list/mobs_to_relay = in_range["mobs"]

		for(var/mob/mob in mobs_to_relay)
			mob.show_message(rendered)
	..()

// Verb: join_as_voice()
// Parameters: None
// Description: Allows ghosts to call communicators, if they meet all the requirements.
/mob/observer/dead/verb/join_as_voice()
	set category = "Ghost"
	set name = "Call Communicator"
	set desc = "If there is a communicator available, send a request to speak through it.  This will reset your respawn timer, if someone picks up."

	if(ticker.current_state < GAME_STATE_PLAYING)
		to_chat(src, "<span class='danger'>The game hasn't started yet!</span>")
		return

	if (!src.stat)
		return

	if (usr != src)
		return //something is terribly wrong

	var/confirm = tgui_alert(src, "Would you like to talk as [src.client.prefs.real_name], over a communicator? This will reset your respawn timer, if someone answers.", "Join as Voice?", list("Yes","No"))
	if(confirm == "No")
		return

	if(config.antag_hud_restricted && has_enabled_antagHUD == 1)
		to_chat(src, "<span class='danger'>You have used the antagHUD and cannot respawn or use communicators!</span>")
		return

	for(var/mob/living/L in mob_list) //Simple check so you don't have dead people calling.
		if(src.client.prefs.real_name == L.real_name)
			to_chat(src, "<span class='danger'>Your identity is already present in the game world.  Please load in a different character first.</span>")
			return

	var/obj/machinery/exonet_node/E = get_exonet_node()
	if(!E || !E.on || !E.allow_external_communicators)
		to_chat(src, "<span class='danger'>The Exonet node at telecommunications is down at the moment, or is actively blocking you, \
		so your call can't go through.</span>")
		return

	var/list/choices = list()
	for(var/obj/item/device/communicator/comm in all_communicators)
		if(!comm.network_visibility || !comm.exonet || !comm.exonet.address)
			continue
		choices.Add(comm)

	if(!choices.len)
		to_chat(src , "<span class='danger'>There are no available communicators, sorry.</span>")
		return

	var/choice = tgui_input_list(src,"Send a voice request to whom?", "Recipient Choice", choices)
	if(choice)
		var/obj/item/device/communicator/chosen_communicator = choice
		var/mob/observer/dead/O = src
		if(O.exonet)
			O.exonet.send_message(chosen_communicator.exonet.address, "voice")

			to_chat(src, "A communications request has been sent to [chosen_communicator].  Now you need to wait until someone answers.")

// Proc: connect_video()
// Parameters: user - the mob doing the viewing of video, comm - the communicator at the far end
// Description: Sets up a videocall and puts the first view into it using watch_video, and updates the icon
/obj/item/device/communicator/proc/connect_video(mob/user,obj/item/device/communicator/comm)
	if((!user) || (!comm) || user.stat) return //KO or dead, or already in a video

	if(video_source) //Already in a video
		to_chat(user, "<span class='danger'>You are already connected to a video call!</span>")
		return

	if(user.blinded) //User is blinded
		to_chat(user, "<span class='danger'>You cannot see well enough to do that!</span>")
		return

	if(!(src in comm.communicating) || !comm.camera) //You called someone with a broken communicator or one that's fake or yourself or something
		to_chat(user, "<span class='danger'>\icon[src][bicon(src)]ERROR: Video failed. Either bandwidth is too low, or the other communicator is malfunctioning.</span>")
		return

	to_chat(user, "<span class='notice'>\icon[src][bicon(src)] Attempting to start video over existing call.</span>")
	sleep(30)
	to_chat(user, "<span class='notice'>\icon[src][bicon(src)] Please wait...</span>")

	video_source = comm.camera
	comm.visible_message("<span class='danger'>\icon[src][bicon(src)] New video connection from [comm].</span>")
	update_active_camera_screen()
	GLOB.moved_event.register(video_source, src, PROC_REF(update_active_camera_screen))
	update_icon()

// Proc: end_video()
// Parameters: reason - the text reason to print for why it ended
// Description: Ends the video call by clearing video_source
/obj/item/device/communicator/proc/end_video(var/reason)
	GLOB.moved_event.unregister(video_source, src, PROC_REF(update_active_camera_screen))
	show_static()
	video_source = null

	. = "<span class='danger'>\icon[src][bicon(src)] [reason ? reason : "Video session ended"].</span>"

	visible_message(.)
	update_icon()
