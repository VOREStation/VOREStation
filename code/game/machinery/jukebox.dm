//
// Media Player Jukebox
// Rewritten by Leshana from existing Polaris code, merging in D2K5 and N3X15 work
//

#define JUKEMODE_NEXT        1 // Advance to next song in the track list
#define JUKEMODE_RANDOM      2 // Not shuffle, randomly picks next each time.
#define JUKEMODE_REPEAT_SONG 3 // Play the same song over and over
#define JUKEMODE_PLAY_ONCE   4 // Play, then stop.

/obj/machinery/media/jukebox/
	name = "space jukebox"
	desc = "Filled with songs both past and present!"
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "jukebox2-nopower"
	var/state_base = "jukebox2"
	anchored = 1
	density = 1
	power_channel = EQUIP
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 100
	circuit = /obj/item/weapon/circuitboard/jukebox
	clicksound = 'sound/machines/buttonbeep.ogg'

	// Vars for hacking
	var/datum/wires/jukebox/wires = null
	var/hacked = 0 // Whether to show the hidden songs or not
	var/freq = 0 // Currently no effect, will return in phase II of mediamanager.
	//VOREStation Add
	var/loop_mode = JUKEMODE_PLAY_ONCE			// Behavior when finished playing a song
	var/max_queue_len = 3						// How many songs are we allowed to queue up?
	var/list/queue = list()
	//VOREStation Add End
	var/datum/track/current_track
	var/list/datum/track/tracks = list(
		new/datum/track("Beyond", 'sound/ambience/ambispace.ogg'),
		new/datum/track("Clouds of Fire", 'sound/music/clouds.s3m'),
		new/datum/track("D`Bert", 'sound/music/title2.ogg'),
		new/datum/track("D`Fort", 'sound/ambience/song_game.ogg'),
		new/datum/track("Floating", 'sound/music/main.ogg'),
		new/datum/track("Endless Space", 'sound/music/space.ogg'),
		new/datum/track("Part A", 'sound/misc/TestLoop1.ogg'),
		new/datum/track("Scratch", 'sound/music/title1.ogg'),
		new/datum/track("Trai`Tor", 'sound/music/traitor.ogg'),
		new/datum/track("Stellar Transit", 'sound/ambience/space/space_serithi.ogg'),
	)

	// Only visible if hacked
	var/list/datum/track/secret_tracks = list(
		new/datum/track("Clown", 'sound/music/clown.ogg'),
		new/datum/track("Space Asshole", 'sound/music/space_asshole.ogg'),
		new/datum/track("Thunderdome", 'sound/music/THUNDERDOME.ogg'),
		new/datum/track("Russkiy rep Diskoteka", 'sound/music/russianrapdisco.ogg')
	)

/obj/machinery/media/jukebox/Initialize()
	. = ..()
	default_apply_parts()
	wires = new/datum/wires/jukebox(src)
	update_icon()

/obj/machinery/media/jukebox/Destroy()
	qdel(wires)
	wires = null
	return ..()

// On initialization, copy our tracks from the global list
/obj/machinery/media/jukebox/Initialize()
	. = ..()
	if(LAZYLEN(all_jukebox_tracks)) //Global list has tracks
		tracks.Cut()
		secret_tracks.Cut()
		for(var/datum/track/T in all_jukebox_tracks) //Load them
			if(T.secret)
				secret_tracks |= T
			else
				tracks |= T
	else if(!LAZYLEN(tracks)) //We don't even have default tracks
		stat |= BROKEN // No tracks configured this round!

/obj/machinery/media/jukebox/process()
	if(!playing)
		return
	if(inoperable())
		disconnect_media_source()
		playing = 0
		return
	// If the current track isn't finished playing, let it keep going
	if(current_track && world.time < media_start_time + current_track.duration)
		return
	// Otherwise time to pick a new one!
	if(queue.len > 0)
		current_track = queue[1]
		queue.Cut(1, 2)  // Remove the item we just took off the list
	else
		// Oh... nothing in queue? Well then pick next according to our rules
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

// Tells the media manager to start or stop playing based on current settings.
/obj/machinery/media/jukebox/proc/start_stop_song()
	if(current_track && playing)
		media_url = current_track.url
		media_start_time = world.time
		visible_message("<span class='notice'>\The [src] begins to play [current_track.display()].</span>")
	else
		media_url = ""
		media_start_time = 0
	update_music()

/obj/machinery/media/jukebox/proc/set_hacked(var/newhacked)
	if (hacked == newhacked) return
	hacked = newhacked
	if (hacked)
		tracks.Add(secret_tracks)
	else
		tracks.Remove(secret_tracks)
	updateDialog()

/obj/machinery/media/jukebox/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(W.is_wirecutter())
		return wires.Interact(user)
	if(istype(W, /obj/item/device/multitool))
		return wires.Interact(user)
	if(W.is_wrench())
		if(playing)
			StopPlaying()
		user.visible_message("<span class='warning'>[user] has [anchored ? "un" : ""]secured \the [src].</span>", "<span class='notice'>You [anchored ? "un" : ""]secure \the [src].</span>")
		anchored = !anchored
		playsound(src, W.usesound, 50, 1)
		power_change()
		update_icon()
		if(!anchored)
			playing = 0
			disconnect_media_source()
		else
			update_media_source()
		return
	return ..()

/obj/machinery/media/jukebox/power_change()
	if(!powered(power_channel) || !anchored)
		stat |= NOPOWER
	else
		stat &= ~NOPOWER

	if(stat & (NOPOWER|BROKEN) && playing)
		StopPlaying()
	update_icon()

/obj/machinery/media/jukebox/update_icon()
	overlays.Cut()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		if(stat & BROKEN)
			icon_state = "[state_base]-broken"
		else
			icon_state = "[state_base]-nopower"
		return
	icon_state = state_base
	if(playing)
		if(emagged)
			overlays += "[state_base]-emagged"
		else
			overlays += "[state_base]-running"
	if (panel_open)
		overlays += "panel_open"

/obj/machinery/media/jukebox/interact(mob/user)
	if(inoperable())
		to_chat(usr, "\The [src] doesn't appear to function.")
		return
	tgui_interact(user)

/obj/machinery/media/jukebox/tgui_status(mob/user)
	if(inoperable())
		to_chat(user, "<span class='warning'>[src] doesn't appear to function.</span>")
		return STATUS_CLOSE
	if(!anchored)
		to_chat(user, "<span class='warning'>You must secure [src] first.</span>")
		return STATUS_CLOSE
	. = ..()

/obj/machinery/media/jukebox/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Jukebox", "RetroBox - Space Style")
		ui.open()

/obj/machinery/media/jukebox/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()
	
	data["playing"] = playing
	data["loop_mode"] = loop_mode
	data["volume"] = volume
	data["current_track_ref"] = null
	data["current_track"] = null
	if(current_track)
		data["current_track_ref"] = "\ref[current_track]"  // Convenient shortcut
		data["current_track"] = current_track.toTguiList()
	data["percent"] = playing ? min(100, round(world.time - media_start_time) / current_track.duration) : 0;

	var/list/tgui_tracks = list()
	for(var/datum/track/T in tracks)
		tgui_tracks.Add(list(T.toTguiList()))
	data["tracks"] = tgui_tracks

	return data

/obj/machinery/media/jukebox/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("change_track")
			var/datum/track/T = locate(params["change_track"]) in tracks
			if(istype(T))
				current_track = T
				StartPlaying()
			return TRUE
		if("loopmode")
			var/newval = text2num(params["loopmode"])
			loop_mode = sanitize_inlist(newval, list(JUKEMODE_NEXT, JUKEMODE_RANDOM, JUKEMODE_REPEAT_SONG, JUKEMODE_PLAY_ONCE), loop_mode)
			return TRUE
		if("volume")
			volume = clamp(params["val"], 0, 1)
			update_music() // To broadcast volume change without restarting song
			return TRUE
		if("stop")
			StopPlaying()
			return TRUE
		if("play")
			if(emagged)
				playsound(src.loc, 'sound/items/AirHorn.ogg', 100, 1)
				for(var/mob/living/carbon/M in ohearers(6, src))
					if(M.get_ear_protection() >= 2)
						continue
					M.SetSleeping(0)
					M.stuttering += 20
					M.ear_deaf += 30
					M.Weaken(3)
					if(prob(30))
						M.Stun(10)
						M.Paralyse(4)
					else
						M.make_jittery(500)
				spawn(15)
					explode()
			else if(current_track == null)
				to_chat(usr, "No track selected.")
			else
				StartPlaying()
			return TRUE

/obj/machinery/media/jukebox/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/media/jukebox/attack_hand(var/mob/user as mob)
	interact(user)

/obj/machinery/media/jukebox/proc/explode()
	walk_to(src,0)
	src.visible_message("<span class='danger'>\the [src] blows apart!</span>", 1)

	explosion(src.loc, 0, 0, 1, rand(1,2), 1)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/blood/oil(src.loc)
	qdel(src)

/obj/machinery/media/jukebox/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(W.is_wrench())
		if(playing)
			StopPlaying()
		user.visible_message("<span class='warning'>[user] has [anchored ? "un" : ""]secured \the [src].</span>", "<span class='notice'>You [anchored ? "un" : ""]secure \the [src].</span>")
		anchored = !anchored
		playsound(src, W.usesound, 50, 1)
		power_change()
		update_icon()
		return
	return ..()

/obj/machinery/media/jukebox/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		StopPlaying()
		visible_message("<span class='danger'>\The [src] makes a fizzling sound.</span>")
		update_icon()
		return 1

/obj/machinery/media/jukebox/proc/StopPlaying()
	playing = 0
	update_use_power(USE_POWER_IDLE)
	update_icon()
	start_stop_song()

/obj/machinery/media/jukebox/proc/StartPlaying()
	if(!current_track)
		return
	playing = 1
	update_use_power(USE_POWER_ACTIVE)
	update_icon()
	start_stop_song()
	updateDialog()

// Advance to the next track - Don't start playing it unless we were already playing
/obj/machinery/media/jukebox/proc/NextTrack()
	if(!tracks.len) return
	var/curTrackIndex = max(1, tracks.Find(current_track))
	var/newTrackIndex = (curTrackIndex % tracks.len) + 1  // Loop back around if past end
	current_track = tracks[newTrackIndex]
	if(playing)
		start_stop_song()
	updateDialog()

// Advance to the next track - Don't start playing it unless we were already playing
/obj/machinery/media/jukebox/proc/PrevTrack()
	if(!tracks.len) return
	var/curTrackIndex = max(1, tracks.Find(current_track))
	var/newTrackIndex = curTrackIndex == 1 ? tracks.len : curTrackIndex - 1
	current_track = tracks[newTrackIndex]
	if(playing)
		start_stop_song()
	updateDialog()
