SUBSYSTEM_DEF(media_tracks)
	name = "Media Tracks"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_MEDIA_TRACKS
	
	/// Every track, including secret
	var/list/all_tracks = list()
	/// Non-secret jukebox tracks
	var/list/jukebox_tracks = list()
	/// Lobby music tracks
	var/list/lobby_tracks = list()

/datum/controller/subsystem/media_tracks/Initialize()
	load_tracks()
	sort_tracks()

/datum/controller/subsystem/media_tracks/proc/load_tracks()
	for(var/filename in config.jukebox_track_files)
		report_progress("Loading jukebox track: [filename]")
		
		if(!fexists(filename))
			error("File not found: [filename]")
			continue
		
		var/list/jsonData = json_decode(file2text(filename))
		
		if(!istype(jsonData))
			error("Failed to read tracks from [filename], json_decode failed.")
			continue
		
		for(var/entry in jsonData)
			
			// Critical problems that will prevent the track from working
			if(!istext(entry["url"]))
				error("Jukebox entry in [filename]: bad or missing 'url'. Tracks must have a URL.")
				continue
			if(!istext(entry["title"]))
				error("Jukebox entry in [filename]: bad or missing 'title'. Tracks must have a title.")
				continue
			if(!isnum(entry["duration"]))
				error("Jukebox entry in [filename]: bad or missing 'duration'. Tracks must have a duration (in deciseconds).")
				continue

			// Noncritical problems, we can keep going anyway, but warn so it can be fixed
			if(!istext(entry["artist"]))
				warning("Jukebox entry in [filename], [entry["title"]]: bad or missing 'artist'. Please consider crediting the artist.")
			if(!istext(entry["genre"]))
				warning("Jukebox entry in [filename], [entry["title"]]: bad or missing 'genre'. Please consider adding a genre.")
				
			var/datum/track/T = new(entry["url"], entry["title"], entry["duration"], entry["artist"], entry["genre"])
			
			T.secret = entry["secret"] ? 1 : 0
			T.lobby = entry["lobby"] ? 1 : 0
			
			all_tracks += T

/datum/controller/subsystem/media_tracks/proc/sort_tracks()
	report_progress("Sorting media tracks...")
	sortTim(all_tracks, /proc/cmp_media_track_asc)
	
	jukebox_tracks.Cut()
	
	for(var/datum/track/T in all_tracks)
		if(!T.secret)
			jukebox_tracks += T
		if(T.lobby)
			lobby_tracks += T
