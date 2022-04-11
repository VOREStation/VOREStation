// Mostly a jukebox copy-paste, given the vastly different paths though it seemed worth it.
// Would rather not have a bunch of /machinery baggage on our portable music player.

/obj/item/device/walkpod
	name = "\improper PodZu music player"
	desc = "Portable music player! For when you need to ignore the rest of the world, there's only one choice: PodZu."
	description_fluff = "A prestigious set: The ZuMan music player, and the HeadPods headphones, both 90th anniversary releases! Together they form the PodZu Music Player, famous in the local galactic cluster for pumping sick beats directly into your head."
	description_info = "An easy way to access the menu while the player is in a pocket is Alt-Click. Wearing the headphones is not actually necessary to listen to music, but you can if you want, by right-clicking on the player and using 'Take HeadPods'."

	icon = 'icons/obj/device_vr.dmi'
	icon_state = "podzu" // podzu_o, headpod, zuman

	var/loop_mode = JUKEMODE_PLAY_ONCE	// Behavior when finished playing a song
	var/datum/track/current_track		// Current track playing
	var/mob/living/listener				// Person whomst is listening to us

	var/playing = 0
	var/volume = 1
	
	var/media_url = ""
	var/media_start_time

	var/obj/item/device/headpods/deployed_headpods

	w_class = ITEMSIZE_COST_SMALL

/obj/item/device/walkpod/Destroy()
	remove_listener()
	return ..()

// Icon
/obj/item/device/walkpod/update_icon()
	if(listener)
		if(deployed_headpods)
			icon_state = "zuman_on"
		else
			icon_state = "[initial(icon_state)]_on"
	else
		if(deployed_headpods)
			icon_state = "zuman"
		else
			icon_state = "[initial(icon_state)]"

// Listener handling
/obj/item/device/walkpod/proc/check_listener()
	if(loc == listener)
		return TRUE
	return FALSE

/obj/item/device/walkpod/proc/remove_listener()
	if(playing)
		StopPlaying()
	STOP_PROCESSING(SSobj, src)
	if(deployed_headpods)
		restore_headpods()
	to_chat(listener, "<span class='notice'>You are no longer wearing the [src]'s headphones.</span>")
	listener = null
	update_icon()
	
/obj/item/device/walkpod/proc/set_listener(mob/living/L)
	if(listener)
		remove_listener()
	listener = L
	START_PROCESSING(SSobj, src)
	to_chat(L, "<span class='notice'>You put the [src]'s headphones on and power it up, preparing to listen to some <b>sick tunes</b>.</span>")
	update_icon()

/obj/item/device/walkpod/proc/update_music()
	listener?.force_music(media_url, media_start_time, volume) // Calling this with "" url (when we aren't playing) helpfully disables forced music

/obj/item/device/walkpod/AltClick(mob/living/L)
	if(L == listener && check_listener())
		tgui_interact(L)
	else if(loc == L) // at least they're holding it
		to_chat(L, "<span class='warning'>Turn on the [src] first.</span>")

/obj/item/device/walkpod/attack_self(mob/living/L)
	if(!istype(L) || loc != L)
		return
	if(!listener)
		set_listener(L)
	tgui_interact(L)

// Process ticks to ensure our listener remains valid and we do music-ing
/obj/item/device/walkpod/process()
	if(!check_headpods())
		restore_headpods()
	if(!check_listener())
		remove_listener()
		return
	if(!playing)
		return
	// If the current track isn't finished playing, let it keep going
	if(current_track && world.time < media_start_time + current_track.duration)
		return
	// Oh... nothing in queue? Well then pick next according to our rules
	var/list/tracks = getTracksList()
	switch(loop_mode)
		if(JUKEMODE_NEXT)
			var/curTrackIndex = max(1, tracks.Find(current_track))
			var/newTrackIndex = (curTrackIndex % tracks.len) + 1  // Loop back around if past end
			current_track = tracks[newTrackIndex]
		if(JUKEMODE_RANDOM)
			var/previous_track = current_track
			do
				current_track = pick(tracks)
			while(current_track == previous_track && tracks.len > 1)
		if(JUKEMODE_REPEAT_SONG)
			current_track = current_track
		if(JUKEMODE_PLAY_ONCE)
			current_track = null
			playing = 0
			update_icon()
	updateDialog()
	start_stop_song()

// Track/music internals
/obj/item/device/walkpod/proc/start_stop_song()
	if(current_track && playing)
		media_url = current_track.url
		media_start_time = world.time
		runechat_message("*&nbsp;[current_track.display()]&nbsp;*", specific_viewers = list(listener))
	else
		media_url = ""
		media_start_time = 0
	update_music()

/obj/item/device/walkpod/proc/StopPlaying()
	playing = 0
	start_stop_song()

/obj/item/device/walkpod/proc/StartPlaying()
	if(!current_track)
		return
	playing = 1
	start_stop_song()
	updateDialog()

// Advance to the next track - Don't start playing it unless we were already playing
/obj/item/device/walkpod/proc/NextTrack()
	var/list/tracks = getTracksList()
	if(!tracks.len) return
	var/curTrackIndex = max(1, tracks.Find(current_track))
	var/newTrackIndex = (curTrackIndex % tracks.len) + 1  // Loop back around if past end
	current_track = tracks[newTrackIndex]
	if(playing)
		start_stop_song()
	updateDialog()

// Unadvance to the notnext track - Don't start playing it unless we were already playing
/obj/item/device/walkpod/proc/PrevTrack()
	var/list/tracks = getTracksList()
	if(!tracks.len) return
	var/curTrackIndex = max(1, tracks.Find(current_track))
	var/newTrackIndex = curTrackIndex == 1 ? tracks.len : curTrackIndex - 1
	current_track = tracks[newTrackIndex]
	if(playing)
		start_stop_song()
	updateDialog()

// UI
/obj/item/device/walkpod/proc/getTracksList()
	return SSmedia_tracks.jukebox_tracks

/obj/item/device/walkpod/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Jukebox", "PodZu Music Player")
		ui.open()

/obj/item/device/walkpod/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	
	data["playing"] = playing
	data["loop_mode"] = loop_mode
	data["volume"] = volume
	data["current_track_ref"] = null
	data["current_track"] = null
	data["current_genre"] = null
	if(current_track)
		data["current_track_ref"] = "\ref[current_track]"  // Convenient shortcut
		data["current_track"] = current_track.toTguiList()
		data["current_genre"] = current_track.genre
	data["percent"] = playing ? min(100, round(world.time - media_start_time) / current_track.duration) : 0;

	var/list/tgui_tracks = list()
	for(var/datum/track/T in getTracksList())
		tgui_tracks.Add(list(T.toTguiList()))
	data["tracks"] = tgui_tracks

	return data

/obj/item/device/walkpod/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("change_track")
			var/datum/track/T = locate(params["change_track"]) in getTracksList()
			if(istype(T))
				current_track = T
				StartPlaying()
			return TRUE
		if("loopmode")
			var/newval = text2num(params["loopmode"])
			loop_mode = sanitize_inlist(newval, list(JUKEMODE_NEXT, JUKEMODE_RANDOM, JUKEMODE_REPEAT_SONG, JUKEMODE_PLAY_ONCE), loop_mode)
			return TRUE
		if("volume")
			var/newval = text2num(params["val"])
			volume = clamp(newval, 0, 1)
			update_music() // To broadcast volume change without restarting song
			return TRUE
		if("stop")
			StopPlaying()
			return TRUE
		if("play")
			if(current_track == null)
				to_chat(usr, "No track selected.")
			else
				StartPlaying()
			return TRUE

// Silly verb
/obj/item/device/walkpod/verb/take_headpods()
	set name = "Take HeadPods"
	set desc = "Grab the pair of HeadPods."

	var/mob/living/L = usr
	if(!istype(L))
		return
	if(deployed_headpods)
		to_chat(usr, "<span class='warning'>The HeadPods are already deployed!</span>")
		return
	deployed_headpods = new ()
	L.put_in_any_hand_if_possible(deployed_headpods)
	update_icon()

/obj/item/device/walkpod/attackby(obj/item/W, mob/user)
	if(W == deployed_headpods)
		restore_headpods(user)
		return
	return ..()

/obj/item/device/walkpod/proc/restore_headpods(mob/living/potential_holder)
	if(!deployed_headpods)
		return

	if(listener)
		to_chat(listener, "<span class='notice'>The headphone cable reunites the [deployed_headpods] with the [src] by retracting inwards.</span>")

	if(istype(potential_holder))
		potential_holder.unEquip(deployed_headpods, force = TRUE)
	qdel_null(deployed_headpods)
	update_icon()

/obj/item/device/walkpod/proc/check_headpods()
	if(deployed_headpods && deployed_headpods.loc != loc)
		return FALSE
	return TRUE

/obj/item/device/headpods
	name = "\improper pair of HeadPods"
	desc = "Portable listening in Hi-Fi!"
	icon = 'icons/obj/device_vr.dmi'
	icon_state = "headpods"
	item_state = "headphones_on"
	w_class = ITEMSIZE_SMALL
	slot_flags = SLOT_HEAD
