//
// VOREStation Custom - Configurable Jukebox!
//

/datum/track
	var/secret = 0  // Whether or not this is a SECRET TRACK OOOOOH

// On initialization, copy our tracks from the global list
/obj/machinery/media/jukebox/initialize()
	..()
	if(all_jukebox_tracks.len)
		tracks.Cut()
		secret_tracks.Cut()
		for(var/datum/track/T in all_jukebox_tracks)
			if(T.secret)
				secret_tracks += T
			else
				tracks += T
	return

// Global list holding all configured jukebox tracks
var/global/list/all_jukebox_tracks = list()

// Read the jukebox configuration file on system startup.
/hook/startup/proc/load_jukebox_tracks()
	var/jukebox_track_file = "config/jukebox.txt"
	if(!fexists(jukebox_track_file))
		warning("File not found: [jukebox_track_file]")
		return
	// Helpful regex that ignores comments and parses our file format
	var/regex/lineSplitter = regex("^(?!#)(.+?)\\|(.+?)\\|(.+)$")
	var/list/Lines = file2list(jukebox_track_file)
	for(var/t in Lines)
		if(!t) continue
		if(!lineSplitter.Find(t)) continue
		var/file = trim(lineSplitter.group[1])
		var/title = trim(lineSplitter.group[2])
		var/isSecret = text2num(trim(lineSplitter.group[3]))
		if(!fexists(file))
			warning("In [jukebox_track_file], sound file file not found: [file]")
			continue
		var/datum/track/T = new(title, file(file))
		T.secret = isSecret ? 1 : 0
		all_jukebox_tracks += T
	return 1
