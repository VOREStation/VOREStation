//A very, very simple mob that exists inside other objects to talk and has zero influence on the world.
/mob/living/voice
	name = "unknown"
	desc = "How are you examining me?"
//	default_language = "Galactic Common"
	var/obj/item/device/communicator/comm = null

	emote_type = 2 //This lets them emote through containers.  The communicator has a image feed of the person calling them so...
	var/stable_connection = 0 //If set to zero, makes the mob effectively deaf, mute, and blind, due to interferance.


/mob/living/voice/New(loc)
	add_language("Galactic Common")
	for(var/datum/language/L in languages) //This is needed to get around some saycode problems.
		if(L.name == "Galactic Common")
			set_default_language(L)
			break

	if(istype(loc, /obj/item/device/communicator))
		comm = loc
	..()

/mob/living/voice/proc/transfer_identity(mob/speaker)
	if(ismob(speaker))
		icon = speaker.icon
		icon_state = speaker.icon_state
		overlays = speaker.overlays

		alpha = 127 //Maybe we'll have hologram calls later.
		if(speaker.client && speaker.client.prefs)
			var/datum/preferences/p = speaker.client.prefs
			name = p.real_name
			real_name = name
			gender = p.gender

			for(var/language in p.alternate_languages)
				add_language(language)

/mob/living/voice/Login()
	var/obj/screen/static_effect = new() //Since what the player sees is essentially a video feed, from a vast distance away, the view isn't going to be perfect.
	static_effect.screen_loc = ui_entire_screen
	static_effect.icon = 'icons/effects/static.dmi'
	static_effect.icon_state = "1 light"
	static_effect.mouse_opacity = 0 //So the static doesn't get in the way of clicking.
	client.screen.Add(static_effect)

/mob/living/voice/Destroy()
	comm = null
	..()

/mob/living/voice/verb/hang_up()
	set name = "Hang Up"
	set category = "Communicator"
	set desc = "Disconnects you from whoever you're talking to."
	set src = usr

	if(comm)
		comm.close_connection(src, "[src] hung up")
	else
		src << "You appear to not be inside a communicator.  This is a bug and you should report it."

/mob/living/voice/Life()
	if(comm && comm.server && !comm.server.active)
		comm.close_connection(src,"Connection to telecommunications array timed out")
	..()

/mob/living/voice/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="")
//	world << "say() was called.  Arguments: ([message], [speaking], [verb], [alt_name])."
	if(!stable_connection)
		return 0

	//Speech bubbles.
	if(comm)
		var/speech_bubble_test = say_test(message)
		var/image/speech_bubble = image('icons/mob/talk.dmi',src,"h[speech_bubble_test]")
		spawn(30)
			qdel(speech_bubble)

		for(var/mob/M in hearers(world.view,comm)) //simplifed since it's just a speech bubble
			M << speech_bubble
		src << speech_bubble

	..(message, speaking, verb, alt_name) //mob/living/say() can do the actual talking.
/*
/mob/verb/test_voice_mob()
	set name = "Make Voice Mob"
	set category = "Debug"
	set desc = "For testing only!"
	set src = usr

	var/turf/T = get_turf(src)
	var/obj/item/device/communicator/comm = new(T)
	comm.open_connection(src, src)
*/
