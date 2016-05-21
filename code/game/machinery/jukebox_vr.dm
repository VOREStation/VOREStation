// The improved, hackable jukebox for vorestation!

/obj/machinery/media/jukebox/vore
	name = "space jukebox"
	icon = 'icons/obj/jukebox_vr.dmi'

	// Vars for hacking
	var/datum/wires/jukebox/wires = null
	var/hacked = 0 // Whether to show the hidden songs or not
	var/freq = 0

	// Only visible if hacked
	var/list/datum/track/secret_tracks = list(
		new/datum/track("Bandit Radio", 'sound/music/jukebox/bandit_radio.ogg'),
		new/datum/track("Ghost Fight (Toby Fox)", 'sound/music/jukebox/TobyFoxGhostFight.mid'),
		new/datum/track("Space Asshole", 'sound/music/space_asshole.ogg'),
		new/datum/track("THUNDERDOME", 'sound/music/THUNDERDOME.ogg'),
	)

	// Normally visible tracks
	tracks = list(
		new/datum/track("A Song About Hares", 'sound/music/jukebox/SongAboutHares.ogg'),
		new/datum/track("Below The Asteroids", 'sound/music/jukebox/BelowTheAsteroids.ogg'),
		new/datum/track("Beyond", 'sound/ambience/ambispace.ogg'),
		new/datum/track("Clouds of Fire", 'sound/music/clouds.s3m'),
		new/datum/track("D`Bert", 'sound/music/title2.ogg'),
		new/datum/track("D`Fort", 'sound/ambience/song_game.ogg'),
		new/datum/track("Duck Tales - Moon", 'sound/music/jukebox/DuckTalesMoon.mid'),
		new/datum/track("Endless Space", 'sound/music/space.ogg'),
		new/datum/track("Floating", 'sound/music/main.ogg'),
		new/datum/track("Fly Me To The Moon", 'sound/music/jukebox/Fly_Me_To_The_Moon.ogg'),
		new/datum/track("Mad About Me", 'sound/music/jukebox/Cantina.ogg'),
		new/datum/track("Minor Turbulence", 'sound/music/jukebox/MinorTurbulenceFull.ogg'),
		new/datum/track("Ode to Greed", 'sound/music/jukebox/OdeToGreed.ogg'),
		new/datum/track("Part A", 'sound/misc/TestLoop1.ogg'),
		new/datum/track("Ransacked", 'sound/music/jukebox/Ransacked.ogg'),
		new/datum/track("Russkiy rep Diskoteka", 'sound/music/jukebox/russianrapdisco.ogg'),
		new/datum/track("Scratch", 'sound/music/title1.ogg'),
		new/datum/track("Space Oddity", 'sound/music/space_oddity.ogg'),
		new/datum/track("Thunderdome", 'sound/music/THUNDERDOME.ogg'),
		new/datum/track("Trai`Tor", 'sound/music/traitor.ogg'),
		new/datum/track("Welcome To Jurassic Park", 'sound/music/jukebox/WelcomeToJurassicPark.mid')
	)

/obj/machinery/media/jukebox/vore/New()
	..()
	wires = new/datum/wires/jukebox(src)

/obj/machinery/media/jukebox/vore/Destroy()
	..()
	qdel(wires)
	wires = null

/obj/machinery/media/jukebox/vore/update_icon()
	..()
	if (panel_open)
		overlays += "panel_open"


/obj/machinery/media/jukebox/vore/proc/set_hacked(var/newhacked)
	if (hacked == newhacked) return
	hacked = newhacked
	if (hacked)
		tracks.Add(secret_tracks)
	else
		tracks.Remove(secret_tracks)
	updateDialog()


/obj/machinery/media/jukebox/vore/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (default_deconstruction_screwdriver(user, W))
		return
	if(istype(W, /obj/item/weapon/wirecutters))
		return wires.Interact(user)
	if(istype(W, /obj/item/device/multitool))
		return wires.Interact(user)
	return ..()


/obj/machinery/media/jukebox/vore/StartPlaying()
	StopPlaying()
	if(!current_track)
		return

	var/area/main_area = get_area(src)
	if(freq)
		var/sound/new_song = sound(current_track.sound, channel = 1, repeat = 1, volume = 25)
		new_song.frequency = freq
		main_area.forced_ambience = list(new_song)
	else
		main_area.forced_ambience = list(current_track.sound)

	for(var/mob/living/M in mobs_in_area(main_area))
		if(M.mind)
			main_area.play_ambience(M)

	playing = 1
	update_use_power(2)
	update_icon()
