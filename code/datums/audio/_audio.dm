/decl/music_track
	var/artist
	var/title
	var/album
	var/decl/license/license
	var/song
	var/url // Remember to include http:// or https:// or BYOND will be sad
	var/volume = 70

/decl/music_track/Initialize()
	. = ..()
	license = GET_DECL(license)

/decl/music_track/proc/play_to(var/listener)
	to_chat(listener, "<span class='good'>Now Playing:</span>")
	to_chat(listener, "<span class='good'>[title][artist ? " by [artist]" : ""][album ? " ([album])" : ""]</span>")
	if(url)
		to_chat(listener, url)

	to_chat(listener, "<span class='good'>License: <a href='[license.url]'>[license.name]</a></span>")
	listener << sound(song, repeat = 1, wait = 0, volume = volume, channel = 1)

// No VV editing anything about music tracks
/decl/music_track/VV_static()
	return ..() + vars