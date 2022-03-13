

GLOBAL_LIST_INIT(music_tracks, list(
	"Beyond" = /decl/music_track/ambispace,
	"Clouds of Fire" = /decl/music_track/clouds_of_fire,
	"Stage Three" = /decl/music_track/dilbert,
	"Asteroids" = /decl/music_track/df_theme,
	"Floating" = /decl/music_track/floating,
	"Endless Space" = /decl/music_track/endless_space,
	"Fleet Party Theme" = /decl/music_track/one_loop,
	"Scratch" = /decl/music_track/level3_mod,
	"Absconditus" = /decl/music_track/absconditus,
	"Lasers Rip Apart the Bulkhead" = /decl/music_track/lasers,
	"Maschine Klash" = /decl/music_track/digit_one,
	"Comet Halley" = /decl/music_track/comet_haley,
	"Human" = /decl/music_track/human,
	"Memories of Lysendraa" = /decl/music_track/lysendraa,
	"Marhaba" = /decl/music_track/marhaba,
	"Space Oddity" = /decl/music_track/space_oddity,
	"Treacherous Voyage" = /decl/music_track/treacherous_voyage,
	"Wake" = /decl/music_track/wake,
	"Phoron Will Make Us Rich" = /decl/music_track/pwmur,
	"Every Light is Blinking at Once" = /decl/music_track/elibao,
	"In Orbit" = /decl/music_track/inorbit,
	"Martian Cowboy" = /decl/music_track/martiancowboy,
	"Monument" = /decl/music_track/monument,
	"As Far As It Gets" = /decl/music_track/asfarasitgets,
	"80s All Over Again" = /decl/music_track/eighties,
	"Wild Encounters" = /decl/music_track/wildencounters,
	"Torn" = /decl/music_track/torn,
	"Nebula" = /decl/music_track/nebula,
	"Stellar Transit" = /decl/music_track/stellartransit
))

GLOBAL_LIST_INIT(jukebox_secret_tracks, list(
	"Clown" = /decl/music_track/clown,
	"THUNDERDOME" = /decl/music_track/thunderdome,
	"Space Asshole" = /decl/music_track/spaceasshole,
	"Russkiy rep Diskoteka" = /decl/music_track/russianrapdisco,
))

/proc/setup_music_tracks(var/list/tracks)
	. = list()
	var/track_list = LAZYLEN(tracks) ? tracks : GLOB.music_tracks
	for(var/track_name in track_list)
		var/track_path = track_list[track_name]
		. += new/datum/track(track_name, track_path)

/proc/setup_secret_music_tracks(var/list/tracks)
	. = list()
	var/track_list = LAZYLEN(tracks) ? tracks : GLOB.jukebox_secret_tracks
	for(var/track_name in track_list)
		var/track_path = track_list[track_name]
		. += new/datum/track(track_name, track_path)