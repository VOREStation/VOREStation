//A very, very simple mob that exists inside other objects to talk and has zero influence on the world.
/mob/living/voice
	name = "unknown person"
	desc = "How are you examining me?"
	see_invisible = SEE_INVISIBLE_LIVING
	var/obj/item/device/communicator/comm = null

	emote_type = 2 //This lets them emote through containers.  The communicator has a image feed of the person calling them so...

/mob/living/voice/New(loc)
	add_language("Galactic Common")
	for(var/datum/language/L in languages) //This is needed to get around some saycode problems.
		if(L.name == "Galactic Common")
			set_default_language(L)
			break

	if(istype(loc, /obj/item/device/communicator))
		comm = loc
	..()

// Proc: transfer_identity()
// Parameters: 1 (speaker - the mob (usually an observer) to copy information from)
// Description: Copies the mob's icons, overlays, TOD, gender, currently loaded character slot, and languages, to src.
/mob/living/voice/proc/transfer_identity(mob/speaker)
	if(ismob(speaker))
		icon = speaker.icon
		icon_state = speaker.icon_state
		overlays = speaker.overlays
		timeofdeath = speaker.timeofdeath

		alpha = 127 //Maybe we'll have hologram calls later.
		if(speaker.client && speaker.client.prefs)
			var/datum/preferences/p = speaker.client.prefs
			name = p.real_name
			real_name = name
			gender = p.identifying_gender

			for(var/language in p.alternate_languages)
				add_language(language)

// Proc: Login()
// Parameters: None
// Description: Adds a static overlay to the client's screen.
/mob/living/voice/Login()
	..()
	client.screen |= global_hud.whitense
	client.screen |= global_hud.darkMask

// Proc: Destroy()
// Parameters: None
// Description: Removes reference to the communicator, so it can qdel() successfully.
/mob/living/voice/Destroy()
	comm = null
	..()

// Proc: ghostize()
// Parameters: None
// Description: Sets a timeofdeath variable, to fix the free respawn bug.
/mob/living/voice/ghostize()
	timeofdeath = world.time
	. = ..()

// Verb: hang_up()
// Parameters: None
// Description: Disconnects the voice mob from the communicator.
/mob/living/voice/verb/hang_up()
	set name = "Hang Up"
	set category = "Communicator"
	set desc = "Disconnects you from whoever you're talking to."
	set src = usr

	if(comm)
		comm.close_connection(user = src, target = src, reason = "[src] hung up")
	else
		src << "You appear to not be inside a communicator.  This is a bug and you should report it."

// Verb: change_name()
// Parameters: None
// Description: Allows the voice mob to change their name, assuming it is valid.
/mob/living/voice/verb/change_name()
	set name = "Change Name"
	set category = "Communicator"
	set desc = "Changes your name."
	set src = usr

	var/new_name = sanitizeSafe(input(src, "Who would you like to be now?", "Communicator", src.client.prefs.real_name)  as text, MAX_NAME_LEN)
	if(new_name)
		if(comm)
			comm.visible_message("<span class='notice'>\icon[comm] [src.name] has left, and now you see [new_name].</span>")
		//Do a bit of logging in-case anyone tries to impersonate other characters for whatever reason.
		var/msg = "[src.client.key] ([src]) has changed their communicator identity's name to [new_name]."
		message_admins(msg)
		log_game(msg)
		src.name = new_name
	else
		src << "<span class='warning'>Invalid name.  Rejected.</span>"

// Proc: Life()
// Parameters: None
// Description: Checks the active variable on the Exonet node, and kills the mob if it goes down or stops existing.
/mob/living/voice/Life()
	if(comm)
		if(!comm.node || !comm.node.on || !comm.node.allow_external_communicators)
			comm.close_connection(user = src, target = src, reason = "Connection to telecommunications array timed out")
	..()

// Proc: say()
// Parameters: 4 (generic say() arguments)
// Description: Adds a speech bubble to the communicator device, then calls ..() to do the real work.
/mob/living/voice/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/whispering=0)
	//Speech bubbles.
	if(comm)
		var/speech_bubble_test = say_test(message)
		var/image/speech_bubble = image('icons/mob/talk.dmi',comm,"h[speech_bubble_test]")
		spawn(30)
			qdel(speech_bubble)

		for(var/mob/M in hearers(comm)) //simplifed since it's just a speech bubble
			M << speech_bubble
		src << speech_bubble

	..(message, speaking, verb, alt_name, whispering) //mob/living/say() can do the actual talking.

/mob/living/voice/custom_emote(var/m_type=1,var/message = null,var/range=world.view)
	if(!comm) return
	..(m_type,message,comm.video_range)
