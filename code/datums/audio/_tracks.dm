/datum/track
	var/title
	var/track

/datum/track/New(_title, _track)
	title = _title
	track = _track

/datum/track/proc/GetTrack()
	if(ispath(track, /decl/music_track))
		var/decl/music_track/music_track = GET_DECL(track)
		return music_track.song
	return track // Allows admins to continue their adminbus simply by overriding the track var

//Track List

/decl/music_track/absconditus
	artist = "Zhay Tee"
	title = "Absconditus"
	album = "Minerva: Metastasis OST"
	song = 'sound/music/traitor.ogg'
	license = /decl/license/cc_by_nc_sa_3_0
	url = "https://bandcamp.zhaytee.net/track/absconditus"

/decl/music_track/ambispace
	artist = "Alstroemeria Records"
	title = "Bad Apple!! (slowed down)"
	song = 'sound/ambience/ambispace.ogg'
	license = /decl/license/grandfathered

/decl/music_track/chasing_time
	artist = "Dexter Britain"
	title = "Chasing Time"
	album = "Creative Commons Vol. 1"
	song = 'sound/music/chasing_time.ogg'
	license = /decl/license/cc_by_nc_sa_3_0
	url = "http://www.dexterbritain.co.uk"

/decl/music_track/clouds_of_fire
	artist = "Hector/dMk"
	title = "Clouds of Fire"
	song = 'sound/music/clouds.s3m'
	license = /decl/license/grandfathered
	url = "https://modarchive.org/index.php?request=view_by_moduleid&query=73980"

/decl/music_track/comet_haley
	artist = "Stellardrone"
	title = "Comet Halley"
	album = "Light Years"
	song = 'sound/music/comet_haley.ogg'
	license = /decl/license/cc_by_3_0
	url = "http://freemusicarchive.org/music/Stellardrone/Light_Years_1227/07_Comet_Halley"

/decl/music_track/df_theme
	artist = "Beyond Quality"
	title = "Dwarf Fortress Main Theme"
	song = 'sound/ambience/song_game.ogg'
	license = /decl/license/grandfathered

/decl/music_track/digit_one
	artist = "Kelly Bailey"
	title = "Half-Life 2 - Tracking Device"
	song = 'sound/music/1.ogg'
	license = /decl/license/grandfathered

/decl/music_track/dilbert
	title = "Robocop.mp3"
	album = "Dehumanize Yourself and Face to Bloodshed"
	artist = "CBoyardee"
	song = 'sound/music/title2.ogg'
	license = /decl/license/grandfathered

/decl/music_track/elibao
	artist = "Earthcrusher"
	title = "Every Light is Blinking at Once"
	song = 'sound/music/elibao.ogg'
	license = /decl/license/cc_by_nc_sa_3_0
	url = "https://soundcloud.com/alexanderdivine/every-light-is-blinking-at-once"

/decl/music_track/endless_space
	artist = "SolusLunes"
	title = "Endless Space"
	song = 'sound/music/space.ogg'
	license = /decl/license/cc_by_3_0
	url = "https://www.newgrounds.com/audio/listen/67583"

/decl/music_track/epicintro2015
	artist = "Sascha Ende"
	title = "Epic Intro 2015"
	song = 'sound/music/epic2015.ogg'
	license = /decl/license/cc_by_4_0
	url = "https://filmmusic.io/song/323-epic-intro-2015/"

/decl/music_track/floating
	artist = "Floating"
	title = "Unknown"
	song = 'sound/music/main.ogg'
	license = /decl/license/grandfathered

/decl/music_track/hull_rupture
	artist = "Mikazu"
	title = "Hull Rupture"
	song = 'sound/music/hull_rupture.ogg'
	license = /decl/license/cc_by_nc_3_0
	url = "https://soundcloud.com/mikazu-1/baystation-12-hull-rupture"

/decl/music_track/human
	artist = "Borrtex"
	title = "Human"
	album = "Creation"
	song = 'sound/music/human.ogg'
	license = /decl/license/cc_by_nc_3_0
	url = "http://freemusicarchive.org/music/Borrtex/Creation/Borrtex_11_Human"

/decl/music_track/lasers
	artist = "Earthcrusher"
	title = "Lasers Rip Apart The Bulkhead"
	song = 'sound/music/lasers_rip_apart_the_bulkhead.ogg'
	license = /decl/license/cc_by_nc_sa_3_0
	url = "https://soundcloud.com/alexanderdivine/lasers-rip-apart-the-bulkhead"

/decl/music_track/level3_mod
	artist = "X-CEED"
	title = "Flip-Flap"
	song = 'sound/music/title1.ogg'
	license = /decl/license/grandfathered
	url = "https://aminet.net/package/mods/xceed/Flipflap"

/decl/music_track/marhaba
	artist = "Ian Alex Mac"
	title = "Marhaba"
	album = "Cues"
	song = 'sound/music/marhaba.ogg'
	license = /decl/license/cc_by_3_0
	url = "http://freemusicarchive.org/music/Ian_Alex_Mac/Cues/Marhaba"

/decl/music_track/lysendraa
	artist = "TALES"
	title = "Memories Of Lysendraa"
	album = "The Seskian Wars"
	song = 'sound/music/lysendraa.ogg'
	license = /decl/license/cc_by_nc_nd_4_0
	url = "http://freemusicarchive.org/music/TALES/The_Seskian_Wars/8-Memories_Of_Lysendraa"

/decl/music_track/misanthropic_corridors
	artist = "Mikazu"
	title = "Misanthropic Corridors"
	song = 'sound/music/misanthropic_corridors.ogg'
	license = /decl/license/cc_by_sa_3_0
	url = "https://soundcloud.com/mikazu-1/baystation-12-misanthropic-corridors"

/decl/music_track/one_loop
	artist = "Swedish House Mafia"
	title = "One (abridged loop)"
	song = 'sound/misc/TestLoop1.ogg'
	license = /decl/license/grandfathered

/decl/music_track/pwmur
	artist = "Earthcrusher"
	title = "Phoron will make us rich"
	song = 'sound/music/pwmur.ogg'
	license = /decl/license/cc_by_nc_sa_3_0
	url = "https://soundcloud.com/alexanderdivine/phoron-will-make-us-rich"

/decl/music_track/rimward_cruise
	artist = "Mikazu"
	title = "Rimward Cruise"
	song = 'sound/music/rimward_cruise.ogg'
	license = /decl/license/cc_by_sa_3_0
	url = "https://soundcloud.com/mikazu-1/baystation-12-rimward-cruise"

/decl/music_track/salutjohn
	artist = "Quimorucru"
	title = "Salut John"
	song = 'sound/music/salutjohn.ogg'
	album = "Un m�chant party"
	license = /decl/license/cc_by_nc_nd_4_0
	url = "http://freemusicarchive.org/music/Quimorucru/Un_mchant_party/Quimorucru_-_Un_mchant_party__Compilation__-_20_Salut_John"

/decl/music_track/space_oddity
	artist = "Chris Hadfield"
	title = "Space Oddity"
	song = 'sound/music/space_oddity.ogg'
	license = /decl/license/grandfathered

/decl/music_track/thunderdome
	artist = "MashedByMachines"
	title = "THUNDERDOME (a.k.a. -Sector11)"
	song = 'sound/music/THUNDERDOME.ogg'
	license = /decl/license/cc_by_nc_sa_3_0
	url = "https://www.newgrounds.com/audio/listen/312622"

/decl/music_track/treacherous_voyage
	artist = "Jon Luc Hefferman"
	title = "Treacherous Voyage"
	album = "Eilean Mor"
	song = 'sound/music/treacherous_voyage.ogg'
	license = /decl/license/cc_by_nc_3_0
	url = "http://freemusicarchive.org/music/Jon_Luc_Hefferman/20170730112628534/Treacherous_Voyage"

/decl/music_track/voidsent
	artist = "Mikazu"
	title = "Voidsent"
	song = 'sound/music/voidsent.ogg'
	license = /decl/license/cc_by_sa_3_0
	url = "https://soundcloud.com/mikazu-1/baystation-12-voidsent"

/decl/music_track/wake
	artist = "Ryan Little"
	title = "Wake"
	song = 'sound/music/wake.ogg'
	license = /decl/license/cc_by_nc_nd_4_0
	url = "http://freemusicarchive.org/music/Ryan_Little/~/Ryan_Little_-_Wake"

/decl/music_track/inorbit
	artist = "Chronox"
	title = "In Orbit"
	song = 'sound/music/europa/Chronox_-_03_-_In_Orbit.ogg'
	license = /decl/license/cc_by_4_0
	url = "freemusicarchive.org/music/Chronox_2/Voyager/Chronox_-_02_-_In_Orbit"

/decl/music_track/martiancowboy
	artist = "Kevin MacLeod"
	title = "Martian Cowboy"
	song = 'sound/music/europa/Martian Cowboy.ogg'
	license = /decl/license/cc_by_3_0
	url = "https://incompetech.com/music/royalty-free/index.html?isrc=usuan1100349"

/decl/music_track/monument
	artist = "Six Umbrellas"
	title = "Monument"
	song = 'sound/music/europa/Six_Umbrellas_-_05_-_Monument.ogg'
	license = /decl/license/cc_by_sa_4_0
	url = "https://sixumbrellas.bandcamp.com/album/the-psychedelic-and"

/decl/music_track/asfarasitgets
	artist = "A Drop A Day"
	title = "As Far As It Gets"
	song = 'sound/music/europa/asfarasitgets.ogg'
	license = /decl/license/cc_by_sa_4_0
	url = "https://ghyti.bandcamp.com/"

/decl/music_track/eighties
	artist = "A Drop A Day"
	title = "80s All Over Again"
	song = 'sound/music/europa/80salloveragain.ogg'
	license = /decl/license/cc_by_sa_4_0
	url = "https://ghyti.bandcamp.com/"

/decl/music_track/wildencounters
	artist = "A Drop A Day"
	title = "Wild Encounters"
	song = 'sound/music/europa/WildEncounters.ogg'
	license = /decl/license/cc_by_sa_4_0
	url = "https://ghyti.bandcamp.com/"

/decl/music_track/torn
	artist = "Macamoto"
	title = "Torn"
	song = 'sound/music/europa/Macamoto_-_05_-_Torn.ogg'
	license = /decl/license/cc_by_nc_sa_3_0
	url = "https://macamoto.bandcamp.com/track/torn"

/decl/music_track/nebula
	artist = "Pulse Emitter"
	title = "Nebula"
	song = 'sound/music/europa/Pulse_Emitter_-_04_-_Nebula.ogg'
	license = /decl/license/cc_by_nc_sa_3_0
	url = "https://pulseemitter.bandcamp.com/track/nebula"

/decl/music_track/stellartransit
	artist = "Serithi"
	title = "Stellar Transit"
	song = 'sound/ambience/space/space_serithi.ogg'
	license = /decl/license/cc_by_sa_3_0
	url = "https://www.byond.com/members/Serithi"

/decl/music_track/clown
	artist = "Unknown"
	title = "Clown"
	song = 'sound/music/clown.ogg'
	license = /decl/license/grandfathered

/decl/music_track/spaceasshole
	artist = "Chris Remo"
	title = "Space Asshole"
	song = 'sound/music/space_asshole.ogg'
	license = /decl/license/grandfathered
	url = "https://idlethumbs.bandcamp.com/"

/decl/music_track/russianrapdisco
	artist = "Unknown"
	title = "Russkiy rep Diskoteka"
	song = 'sound/music/russianrapdisco.ogg'
	license = /decl/license/grandfathered
