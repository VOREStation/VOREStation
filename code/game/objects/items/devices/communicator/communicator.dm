var/global/list/obj/item/device/communicator/all_communicators = list()

/obj/item/device/communicator
	name = "communicator"
	desc = "A personal device used to enable long range dialog between two people, utilizing existing telecommunications infrastructure to allow \
	communications across different stations, planets, or even star systems."
	icon = 'icons/obj/device.dmi'
	icon_state = "communicator"
	w_class = 2.0
	slot_flags = SLOT_ID | SLOT_BELT

	origin_tech = list(TECH_ENGINEERING = 2, TECH_MAGNET = 2, TECH_BLUESPACE = 2, TECH_DATA = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 30,"glass" = 10)

	var/mob/living/voice/voice_mob = null
	var/list/voice_requests = list()
	var/owner = null
	var/owner_job = null
	var/owner_rank = null //Is this different from job?
	var/alert_called = 0
	var/obj/machinery/message_server/server = null //Reference to the PDA server, to avoid having to look it up so often.

/obj/item/device/communicator/New()
	..()
	all_communicators += src
	all_communicators = sortAtom(all_communicators)
	server = get_message_server()
	//This is a pretty terrible way of doing this.
	spawn(20) //Wait for our mob to finish spawning.
		if(ismob(loc))
			register_device(loc)
		else if(istype(loc, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = loc
			if(ismob(S.loc))
				register_device(S.loc)

/obj/item/device/communicator/examine(mob/user)
	if(!..(user))
		return

	var/msg = ""
	if(voice_mob)
		msg += "<span class='notice'>On the screen, you can see a image feed of [voice_mob].</span>\n"
	msg += "<span class='warning'>"

	if(src.voice_mob && src.voice_mob.key)
		switch(src.voice_mob.stat)
			if(CONSCIOUS)
				if(!src.voice_mob.client)
					msg += "[voice_mob] appears to be asleep.\n" //afk
			if(UNCONSCIOUS)
				msg += "[voice_mob] doesn't appear to be conscious.\n"
			if(DEAD)
				msg += "<span class='deadsay'>[voice_mob] appears to have died...</span>\n" //Hopefully this never has to be used.
	else
		msg += "<span class='notice'>The device doesn't appear to be transmitting any data.</span>\n"
	msg += "</span>"
	user << msg
	return

//This is pretty lengthy
/obj/item/device/communicator/attack_self(mob/user)
	if(!owner)
		var/choice = alert(user,"Would you like to register [src]?","Communicator","Yes","No")
		if(choice == "Yes")
			register_device(user)
		return

	if(voice_mob)
		var/choice = alert(user,"Would you like to hang up?","Communicator","No","Yes")
		if(choice == "Yes")
			close_connection(user, "[user] hung up")
			return

	if(!server || !server.active)
		user << "<span class='danger'>\icon[src] Error: Cannot establish connection to telecommunications.</span>"
		sleep(30)
		user << "<span class='danger'>\icon[src] Attempting to connect to telecommunications.</span>"
		sleep(30)
		if(!server)
			server = get_message_server()
			if(!server)
				user << "<span class='danger'>\icon[src] Query to telecommunications timed out.</span>"
			else if(server.active)
				user << "<span class='notice'>\icon[src] Connection re-established.</span>"
		else
			if(server.active)
				user << "<span class='notice'>\icon[src] Connection re-established.</span>"
			else
				user << "<span class='danger'>\icon[src] Query to telecommunications timed out.</span>"

		return

	var/mode = alert(user,"Would you like to check for communications requests or attempt to send a communication request to an external device?",
					"Communicator","Check Requests","Send Request", "Cancel")
	switch(mode)
		if("Check Requests")
			if(!voice_requests.len)
				user << "\icon[src] No incoming communications requests."
				return

			else
				alert_called = 0
				update_icon()
				var/choice = input(user,"Would would you like to talk to?","Communicator") as null|anything in voice_requests
				if(choice)
					open_connection(user, choice)
				return

		if("Send Request")
			var/list/potential_candidates = list()
			for(var/mob/dead/observer/O in dead_mob_list)				//To my knowledge, there isn't a list of all ghosts.
				if(O.client)											//We only want logged in ghosts.
					potential_candidates.Add(O.client.prefs.real_name)	//This is needed so you don't see ghosted maint drones on the list.

			if(!potential_candidates.len)
				user << "\icon[src] Unfortunately, no other communicators outside your local area could be found.  Please try again later."
				return

			var/choice = input(src,"Please select a person to call.  Due to the vast distances involved \
			as well as time-zones, please note that your request may take a long time to be noticed, and \
			that the available people to call may change as time passes.") as null|anything in potential_candidates
			if(choice)
				var/mob/dead/observer/boo = null
				for(var/mob/dead/observer/O in dead_mob_list)
					if(O.client && O.client.prefs.real_name == choice)
						boo = O
						break
				boo << "\icon[src] A communications request has been received from [src].  If you would like to answer, please use the <b>Call Communicator</b> verb."
				user  << "\icon[src] A communications request has been sent to [choice].  Now you need to wait until they answer, if they do."
			return

/obj/item/device/communicator/proc/register_device(mob/user, var/job = null)
	if(!user)
		return
	owner = user.name
	if(job)
		owner_job = job
		owner_rank = job
	else
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			var/obj/item/weapon/card/id/idcard = H.wear_id
			if(idcard)
				owner_job = idcard.assignment
				owner_rank = idcard.rank
			else
				user << "<span class='warning'>\icon[src] ID not found.  Please swipe your ID on the device.</span>"
				return
		else //They're probably a synth.
			owner_job = user.job
			owner_rank = user.job

	name = "\improper [initial(name)]-[owner] ([owner_job])"

/*
			owner = idcard.registered_name
			owner_job = idcard.assignment
			owner_rank = idcard.rank
			name = "\improper communicator-[owner] ([ownjob])"
*/

/obj/item/device/communicator/proc/open_connection(mob/user, var/mob/candidate)
	if(!isobserver(candidate))
		return

	//Handle moving the ghost into the new shell.
	announce_ghost_joinleave(candidate, 0, "They are occupying a personal communications device now.")
	voice_mob = new /mob/living/voice(src) 	//Make the voice mob the ghost is going to be.
	voice_mob.transfer_identity(candidate) 	//Now make the voice mob load from the ghost's active character in preferences.
	//Do some simple logging since this is a tad risky as a concept.
	var/msg = "[candidate.client ? "[candidate.client.key]" : "*no key*"] ([candidate]) has entered [src], triggered by \
	[user.client ? "[user.client.key]" : "*no key*"] ([user]) at [x],[y],[z].  They have joined as [voice_mob.name]."
	message_admins(msg)
	log_game(msg)
	voice_mob.mind = candidate.mind			//Transfer the mind, if any.
	voice_mob.ckey = candidate.ckey			//Finally, bring the client over.

	var/obj/screen/blackness = new() 	//Makes a black screen, so the candidate can't see what's going on before actually 'connecting' to the communicator.
	blackness.screen_loc = ui_entire_screen
	blackness.icon = 'icons/effects/effects.dmi'
	blackness.icon_state = "1"
	blackness.mouse_opacity = 2			//Can't see anything!
	voice_mob.client.screen.Add(blackness)

	update_icon()

	//Now for some connection fluff.
	user << "<span class='notice'>\icon[src] Connecting to [candidate].</span>"
	src.voice_mob << "<span class='notice'>\icon[src] Attempting to call [src].</span>"
	sleep(10)
	src.voice_mob << "<span class='notice'>\icon[src] Dialing to [station_name()], Kara Subsystem, [system_name()].</span>"
	sleep(20)
	src.voice_mob << "<span class='notice'>\icon[src] Connecting to [station_name()] telecommunications array.</span>"
	sleep(40)
	src.voice_mob << "<span class='notice'>\icon[src] Connection to [station_name()] telecommunications array established.  Redirecting signal to [src].</span>"
	sleep(20)

	//We're connected, no need to hide everything.
	voice_mob.client.screen.Remove(blackness)
	qdel(blackness)

	voice_mob.stable_connection = 1
	voice_mob << "<span class='notice'>\icon[src] Connection to [src] established.</span>"
	voice_mob << "<b>To talk to the person on the other end of the call, just talk normally.</b>"
	voice_mob << "<b>If you want to end the call, use the 'Hang Up' verb.  The other person can also hang up at any time.</b>"
	voice_mob << "<b>Remember, your character does not know anything you've learned from observing!</b>"
	if(voice_mob.mind)
		voice_mob.mind.assigned_role = "Disembodied Voice"
	user << "<span class='notice'>\icon[src] Your communicator is now connected to [candidate]'s communicator.</span>"

/obj/item/device/communicator/proc/close_connection(mob/user, var/reason)
	if(!voice_mob)
		return
	if(user != voice_mob)
		user << "<span class='notice'>\icon[src] [reason].</span>"
		voice_mob << "<span class='danger'>\icon[src] [reason].</span>"
	else
		if(ismob(loc))
			user << "<span class='notice'>\icon[src] [reason].</span>"
			loc << "<span class='danger'>\icon[src] [reason].</span>"
	qdel(voice_mob)

	update_icon()

/obj/item/device/communicator/proc/request(var/mob/candidate)
	if(!isobserver(candidate))
		return
	if(candidate in voice_requests)
		return
	voice_requests.Add(candidate)

	playsound(loc, 'sound/machines/twobeep.ogg', 50, 1)
	for (var/mob/O in hearers(2, loc))
		O.show_message(text("\icon[src] *beep*"))

	alert_called = 1
	update_icon()

	//Search for holder of the device.
	var/mob/living/L = null
	if(loc && isliving(loc))
		L = loc

	if(L)
		L << "<span class='notice'>\icon[src] Communications request from [candidate].</span>"

/obj/item/device/communicator/Destroy()
	if(voice_mob)
		voice_mob << "<span class='danger'>\icon[src] Connection timed out with remote host.</span>"
		qdel(voice_mob)
	all_communicators -= src
	..()

/obj/item/device/communicator/update_icon()
	if(voice_mob)
		icon_state = "communicator-active"
		return

	if(alert_called)
		icon_state = "communicator-called"
		return

	icon_state = initial(icon_state)

/obj/item/device/communicator/see_emote(mob/living/M, text)
	if(voice_mob && voice_mob.client)
		if(!voice_mob.stable_connection)
			return 0
		var/rendered = "<span class='message'>[text]</span>"
		voice_mob.show_message(rendered, 2)
	..()

/obj/item/device/communicator/show_message(msg, type, alt, alt_type)
	if(voice_mob && voice_mob.client)
		if(!voice_mob.stable_connection)
			return 0
		var/rendered = "<span class='message'>[msg]</span>"
		voice_mob.show_message(rendered, type)
	..()

/obj/item/device/communicator/attackby(obj/item/C as obj, mob/user as mob)
	if(istype(C, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/idcard = C
		if(!idcard.registered_name)
			user << "<span class='notice'>\icon[src] \The [src] rejects the ID.</span>"
			return
		if(!owner)
			owner = idcard.registered_name
			owner_job = idcard.assignment
			owner_rank = idcard.rank
			name = "\improper communicator-[owner] ([owner_job])"
			user << "<span class='notice'>\icon[src] Card scanned.</span>"
	else
		..()

/mob/dead/verb/join_as_voice()
	set category = "Ghost"
	set name = "Call Communicator"
	set desc = "If there is a communicator available, send a request to speak through it.  This will reset your respawn timer, if someone picks up."

	if(ticker.current_state < GAME_STATE_PLAYING)
		src << "<span class='danger'>The game hasn't started yet!</span>"
		return

	if (!src.stat)
		return

	if (usr != src)
		return //something is terribly wrong

	var/confirm = alert(src, "Would you like to talk as [src.client.prefs.real_name], over a communicator?  \
						This will reset your respawn timer, if someone answers.", "Join as Voice?", "Yes","No")
	if(confirm == "No")
		return

	for(var/mob/living/L in mob_list) //Simple check so you don't have dead people calling.
		if(src.client.prefs.real_name == L.real_name)
			src << "<span class='danger'>Your identity is already present in the game world.  Please load in a different character first.</span>"
			return

	if(!all_communicators.len)
		src << "<span class='danger'>There are no available communicators, sorry.</span>"
		return

	if(!get_message_server())
		src << "<span class='danger'>The messaging server or telecommunications is down at the moment, so your call can't go through.</span>"
		return

	var/choice = input(src,"Send a voice request to whom?") as null|anything in all_communicators
	if(choice)
		var/obj/item/device/communicator/chosen_communicator = choice
		chosen_communicator.request(src)

		src << "A communications request has been sent to [chosen_communicator].  Now you need to wait until someone answers."

/obj/item/device/communicator/integrated //For synths who have no hands.
	name = "integrated communicator"
	desc = "A circuit used for long-range communications, able to be integrated into a system."

/obj/item/device/communicator/integrated/verb/activate()
	set category = "AI IM"
	set name = "Use Communicator"
	set desc = "Utilizes your built-in communicator."
	set src in usr

	if(usr.stat == 2)
		usr << "You can't do that because you are dead!"
		return

	src.attack_self(usr)