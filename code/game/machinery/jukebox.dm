<<<<<<< HEAD
//
// Media Player Jukebox
// Rewritten by Leshana from existing Polaris code, merging in D2K5 and N3X15 work
//

#define JUKEMODE_NEXT        1 // Advance to next song in the track list
#define JUKEMODE_RANDOM      2 // Not shuffle, randomly picks next each time.
#define JUKEMODE_REPEAT_SONG 3 // Play the same song over and over
#define JUKEMODE_PLAY_ONCE   4 // Play, then stop.

/obj/machinery/media/jukebox
=======
/obj/machinery/media/jukebox/
>>>>>>> 474a8c43cf4... Decl Music and Ported Music + Licenses (#8221)
	name = "space jukebox"
	desc = "Filled with songs both past and present!"
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "jukebox-nopower"
	var/state_base = "jukebox"
	anchored = TRUE
	density = TRUE
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
	var/list/obj/item/device/juke_remote/remotes
	//VOREStation Add End
	var/datum/track/current_track
<<<<<<< HEAD
=======
	var/list/datum/track/tracks

	// Only visible if hacked
	var/list/datum/track/secret_tracks
>>>>>>> 474a8c43cf4... Decl Music and Ported Music + Licenses (#8221)

/obj/machinery/media/jukebox/Initialize()
	. = ..()
	default_apply_parts()
	wires = new/datum/wires/jukebox(src)
	tracks = setup_music_tracks(tracks)
	secret_tracks = setup_secret_music_tracks(secret_tracks)
	update_icon()
	if(!LAZYLEN(getTracksList()))
		stat |= BROKEN

/obj/machinery/media/jukebox/Destroy()
	qdel(wires)
	QDEL_NULL_LIST(tracks)
	current_track = null
	wires = null
	return ..()

/obj/machinery/media/jukebox/proc/getTracksList()
	return hacked ? SSmedia_tracks.all_tracks : SSmedia_tracks.jukebox_tracks

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

// Tells the media manager to start or stop playing based on current settings.
/obj/machinery/media/jukebox/proc/start_stop_song()
	if(current_track && playing)
		media_url = current_track.url
		media_start_time = world.time
		audible_message("<span class='notice'>\The [src] begins to play [current_track.display()].</span>", runemessage = "[current_track.display()]")
	else
		media_url = ""
		media_start_time = 0
	update_music()
	//VOREStation Add
	for(var/obj/item/device/juke_remote/remote as anything in remotes)
		remote.update_music()
	//VOREStation Add End

/obj/machinery/media/jukebox/proc/set_hacked(var/newhacked)
	if(hacked == newhacked)
		return
	hacked = newhacked
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
	cut_overlays()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		if(stat & BROKEN)
			icon_state = "[state_base]-broken"
		else
			icon_state = "[state_base]-nopower"
		return
	icon_state = state_base
	if(playing)
		if(emagged)
			add_overlay("[state_base]-emagged")
		else
			add_overlay("[state_base]-running")
	if (panel_open)
		add_overlay("panel_open")

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

/obj/machinery/media/jukebox/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("change_track")
			var/datum/track/T = locate(params["change_track"]) in getTracksList()
			if(istype(T))
				current_track = T
				StartPlaying()
<<<<<<< HEAD
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
			if(emagged)
				playsound(src, 'sound/items/AirHorn.ogg', 100, 1)
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
=======
				break
	else if(href_list["stop"])
		StopPlaying()
	else if(href_list["play"])
		if(emagged)
			playsound(src, 'sound/items/AirHorn.ogg', 100, 1)
			for(var/mob/living/carbon/M in ohearers(6, src))
				if(M.get_sound_volume_multiplier() < 0.2)
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

	return 1

/obj/machinery/media/jukebox/interact(mob/user)
	if(stat & (NOPOWER|BROKEN))
		to_chat(usr, "\The [src] doesn't appear to function.")
		return

	ui_interact(user)

/obj/machinery/media/jukebox/ui_interact(mob/user, ui_key = "jukebox", var/datum/nanoui/ui = null, var/force_open = 1)
	var/title = "RetroBox - Space Style"
	var/data[0]

	if(!(stat & (NOPOWER|BROKEN)))
		data["current_track"] = current_track != null ? current_track.title : ""
		data["playing"] = playing

		var/list/nano_tracks = new
		for(var/datum/track/T in tracks)
			nano_tracks[++nano_tracks.len] = list("track" = T.title)

		data["tracks"] = nano_tracks

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		// the ui does not exist, so we'll create a new() one
        // for a list of parameters and their descriptions see the code docs in \code\modules\nano\nanoui.dm
		ui = new(user, src, ui_key, "jukebox.tmpl", title, 450, 600)
		// when the ui is first opened this is the data it will use
		ui.set_initial_data(data)
		// open the new ui window
		ui.open()
>>>>>>> 474a8c43cf4... Decl Music and Ported Music + Licenses (#8221)

/obj/machinery/media/jukebox/attack_ai(mob/user as mob)
	return src.attack_hand(user)

/obj/machinery/media/jukebox/attack_hand(var/mob/user as mob)
	interact(user)

/obj/machinery/media/jukebox/proc/explode()
	walk_to(src,0)
	src.visible_message("<span class='danger'>\The [src] blows apart!</span>", 1)

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
<<<<<<< HEAD
=======

	var/area/main_area = get_area(src)
	if(freq)
		var/sound/new_song = sound(current_track.GetTrack(), channel = 1, repeat = 1, volume = 25)
		new_song.frequency = freq
		main_area.forced_ambience = list(new_song)
	else
		main_area.forced_ambience = list(current_track.GetTrack())

	for(var/mob/living/M in mobs_in_area(main_area))
		if(M.mind)
			main_area.play_ambience(M)

>>>>>>> 474a8c43cf4... Decl Music and Ported Music + Licenses (#8221)
	playing = 1
	update_use_power(USE_POWER_ACTIVE)
	update_icon()
	start_stop_song()
	updateDialog()

// Advance to the next track - Don't start playing it unless we were already playing
/obj/machinery/media/jukebox/proc/NextTrack()
	var/list/tracks = getTracksList()
	if(!tracks.len) return
	var/curTrackIndex = max(1, tracks.Find(current_track))
	var/newTrackIndex = (curTrackIndex % tracks.len) + 1  // Loop back around if past end
	current_track = tracks[newTrackIndex]
	if(playing)
		start_stop_song()
	updateDialog()

// Advance to the next track - Don't start playing it unless we were already playing
/obj/machinery/media/jukebox/proc/PrevTrack()
	var/list/tracks = getTracksList()
	if(!tracks.len) return
	var/curTrackIndex = max(1, tracks.Find(current_track))
	var/newTrackIndex = curTrackIndex == 1 ? tracks.len : curTrackIndex - 1
	current_track = tracks[newTrackIndex]
	if(playing)
		start_stop_song()
	updateDialog()

//Pre-hacked Jukebox, has the full sond list unlocked
/obj/machinery/media/jukebox/hacked
	name = "DRM free space jukebox"
	desc = "Filled with songs both past and present! Unlocked for your convenience!"
	hacked = 1

// Ghostly jukebox for adminbuse
/obj/machinery/media/jukebox/ghost
	name = "ghost jukebox"
	desc = "A jukebox from the nether-realms! Spooky."

	plane = PLANE_GHOSTS
	invisibility = INVISIBILITY_OBSERVER
	alpha = 127

	icon_state = "jukebox2-virtual"

	density = FALSE
	hacked = TRUE

	use_power = USE_POWER_OFF
	circuit = null

	var/list/custom_tracks = list()

// Just junk to make it sneaky - I wish a lot more stuff was on /obj/machinery/media instead of /jukebox so I could use that.
/obj/machinery/media/jukebox/ghost/is_incorporeal()
	return TRUE
/obj/machinery/media/jukebox/ghost/audible_message(message, deaf_message, hearing_distance, radio_message, runemessage)
	return
/obj/machinery/media/jukebox/ghost/visible_message(message, blind_message, list/exclude_mobs, range, runemessage)
	return
/obj/machinery/media/jukebox/ghost/attackby(obj/item/W as obj, mob/user as mob)
	return
/obj/machinery/media/jukebox/ghost/attack_ai(mob/user as mob)
	return
/obj/machinery/media/jukebox/ghost/attack_hand(var/mob/user as mob)
	return
/obj/machinery/media/jukebox/ghost/update_use_power(new_use_power)
	return
/obj/machinery/media/jukebox/ghost/power_change()
	return
/obj/machinery/media/jukebox/ghost/emp_act(severity)
	return
/obj/machinery/media/jukebox/ghost/emag_act(remaining_charges, mob/user)
	return
/obj/machinery/media/jukebox/ghost/explode()
	return
/obj/machinery/media/jukebox/ghost/update_icon()
	if(playing)
		animate(src, alpha = 200, time = 5, loop = -1)
	else
		animate(src, alpha = initial(alpha), time = 10)
// End junk

/obj/machinery/media/jukebox/ghost/attack_ghost(var/mob/observer/dead/M)
	if(!istype(M))
		return

	if(check_rights(R_FUN|R_ADMIN, show_msg=0))
		interact(M)
	else if(current_track)
		to_chat(M, "\The [src] is playing [current_track.display()].")
	else
		to_chat(M, "\The [src] is not playing any music.")

/obj/machinery/media/jukebox/ghost/getTracksList()
	return (custom_tracks + ..())

/obj/machinery/media/jukebox/ghost/proc/manual_track_add()
	var/client/C = usr.client
	if(!check_rights(R_FUN|R_ADMIN))
		return

	// Required
	var/url = input(C, "REQUIRED: Provide URL for track", "Track URL") as text|null
	if(!url)
		return

	var/title = input(C, "REQUIRED: Provide title for track", "Track Title") as text|null
	if(!title)
		return

	var/duration = input(C, "REQUIRED: Provide duration for track (in deciseconds, aka seconds*10)", "Track Duration") as num|null
	if(!duration)
		return

	// Optional
	var/artist = input(C, "Optional: Provide artist for track", "Track Artist") as text|null
	if(isnull(artist)) // Cancel rather than empty string
		return

	// So they're obvious and grouped
	var/genre = "! Admin Loaded !"

	custom_tracks += new /datum/track(url, title, duration, artist, genre)

/obj/machinery/media/jukebox/ghost/proc/manual_track_remove()
	var/client/C = usr.client
	if(!check_rights(R_FUN|R_ADMIN))
		return

	var/track = input(C, "Input track title or URL to remove (must be exact)", "Remove Track") as text|null
	if(!track)
		return

	for(var/datum/track/T in custom_tracks)
		if(T.title == track || T.url == track)
			custom_tracks -= T
			qdel(T)
			return

	to_chat(C, "<span class='warning>Couldn't find a track matching the specified parameters.</span>")

/obj/machinery/media/jukebox/ghost/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION("", "---")
	VV_DROPDOWN_OPTION("add_track", "Add New Track")
	VV_DROPDOWN_OPTION("remove_track", "Remove Track")

/obj/machinery/media/jukebox/ghost/vv_do_topic(list/href_list)
	. = ..()
	IF_VV_OPTION("add_track")
		manual_track_add()
		href_list["datumrefresh"] = "\ref[src]"
	IF_VV_OPTION("remove_track")
		manual_track_remove()
		href_list["datumrefresh"] = "\ref[src]"
