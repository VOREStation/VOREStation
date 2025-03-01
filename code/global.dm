// Items that ask to be called every cycle.
var/global/datum/datacore/data_core = null
var/global/list/machines                 = SSmachines.all_machines //I would upgrade all instances of global.machines to SSmachines.all_machines but it's used in so many places and a search returns so many matches for 'machines' that isn't a use of the global...

var/global/list/active_diseases          = list()
var/global/list/hud_icon_reference       = list()


var/global/list/global_mutations  = list() // List of hidden mutation things.

var/global/datum/universal_state/universe = new

var/global/list/global_map = null

// Noises made when hit while typing.
var/list/hit_appends	= list("-OOF", "-ACK", "-UGH", "-HRNK", "-HURGH", "-GLORF")
var/log_path			= "data/logs/" //See world.dm for the full calculated path
var/diary				= null
var/error_log			= null
var/sql_error_log		= null
var/query_debug_log		= null
var/debug_log			= null
var/href_logfile		= null
// var/station_name		= "Northern Star"
// var/const/station_orig	= "Northern Star" //station_name can't be const due to event prefix/suffix
// var/const/station_short	= "Northern Star"
// var/const/dock_name		= "Vir Interstellar Spaceport"
// var/const/boss_name		= "Central Command"
// var/const/boss_short	= "CentCom"
// var/const/company_name	= "NanoTrasen"
// var/const/company_short	= "NT"
// var/const/star_name		= "Vir"
// var/const/starsys_name	= "Vir"
var/game_year			= (text2num(time2text(world.realtime, "YYYY")) + 300) //VOREStation Edit
var/round_progressing = 1

var/master_mode       = "extended" // "extended"
var/secret_force_mode = "secret"   // if this is anything but "secret", the secret rotation will forceably choose this mode.

var/list/bombers       = list()
var/list/admin_log     = list()
var/list/lastsignalers = list() // Keeps last 100 signals here in format: "[src] used \ref[src] @ location [src.loc]: [freq]/[code]"
var/list/lawchanges    = list() // Stores who uploaded laws to which silicon-based lifeform, and what the law was.

//Spawnpoints.
var/list/latejoin          = list()
var/list/latejoin_gateway  = list()
var/list/latejoin_elevator = list()
var/list/latejoin_cryo     = list()
var/list/latejoin_cyborg   = list()

var/list/prisonwarp         = list() // Prisoners go to these
var/list/holdingfacility    = list() // Captured people go here
var/list/xeno_spawn         = list() // Aliens spawn at at these.
var/list/tdome1             = list()
var/list/tdome2             = list()
var/list/tdomeobserve       = list()
var/list/tdomeadmin         = list()
var/list/prisonsecuritywarp = list() // Prison security goes to these.
var/list/prisonwarped       = list() // List of players already warped.
var/list/blobstart          = list()
var/list/ninjastart         = list()

var/list/cardinal    = list(NORTH, SOUTH, EAST, WEST)
var/list/cardinalz   = list(NORTH, SOUTH, EAST, WEST, UP, DOWN)
var/list/cornerdirs  = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/list/cornerdirsz = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST, NORTH|UP, EAST|UP, WEST|UP, SOUTH|UP, NORTH|DOWN, EAST|DOWN, WEST|DOWN, SOUTH|DOWN)
var/list/alldirs     = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
var/list/reverse_dir = list( // reverse_dir[dir] = reverse of dir
	 2,  1,  3,  8, 10,  9, 11,  4,  6,  5,  7, 12, 14, 13, 15, 32, 34, 33, 35, 40, 42,
	41, 43, 36, 38, 37, 39, 44, 46, 45, 47, 16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21,
	23, 28, 30, 29, 31, 48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63
)

var/list/combatlog = list()
var/list/IClog     = list()
var/list/OOClog    = list()
var/list/adminlog  = list()

var/datum/debug/debugobj

var/datum/moduletypes/mods = new()

var/gravity_is_on = 1

var/join_motd = null

var/datum/metric/metric = new() // Metric datum, used to keep track of the round.

var/list/awaydestinations = list() // Away missions. A list of landmarks that the warpgate can take you to.

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
var/fileaccess_timer = 0
var/custom_event_msg = null

// Added for Xenoarchaeology, might be useful for other stuff.
var/global/list/alphabet_uppercase = list("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")


// Used by robots and robot preferences for regular modules.
var/list/robot_module_types = list(
	"Standard", "Engineering", /*"Surgeon",*/ "Crisis", "Miner",
	"Janitor", "Service", "Clown", "Clerical", "Security",
	"Research", "Command" //"Exploration"
)
// List of modules added during code red
var/list/emergency_module_types = list(
	"Combat"
)
// List of modules available to AI shells
var/list/shell_module_types = list(
	"Standard", "Engineering", "Surgeon", "Crisis", "Miner",
	"Janitor", "Service", "Clown", "Clerical", "Security",
	"Research", "Command" //"Exploration"
)
// List of whitelisted modules
var/list/whitelisted_module_types = list(
	"Lost"
)

// Some scary sounds.
var/static/list/scarySounds = list(
	'sound/weapons/thudswoosh.ogg',
	'sound/weapons/Taser.ogg',
	'sound/weapons/armbomb.ogg',
	'sound/voice/hiss1.ogg',
	'sound/voice/hiss2.ogg',
	'sound/voice/hiss3.ogg',
	'sound/voice/hiss4.ogg',
	'sound/voice/hiss5.ogg',
	'sound/voice/hiss6.ogg',
	'sound/effects/Glassbr1.ogg',
	'sound/effects/Glassbr2.ogg',
	'sound/effects/Glassbr3.ogg',
	'sound/items/Welder.ogg',
	'sound/items/Welder2.ogg',
	'sound/machines/door/old_airlock.ogg',
	'sound/effects/clownstep1.ogg',
	'sound/effects/clownstep2.ogg',
	'sound/voice/teppi/roar.ogg',
	'sound/voice/moth/scream_moth.ogg',
	'sound/voice/nya.ogg',
	'sound/voice/succlet_shriek.ogg'
)

// Bomb cap!
var/max_explosion_range = 14

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it.
var/global/obj/item/radio/intercom/omni/global_announcer = new /obj/item/radio/intercom/omni(null)

var/list/station_departments = list("Command", "Medical", "Engineering", "Research", "Security", "Cargo", "Exploration", "Civilian") //VOREStation Edit

//Icons for in-game HUD glasses. Why don't we just share these a little bit?
var/static/icon/ingame_hud = icon('icons/mob/hud.dmi')
var/static/icon/ingame_hud_med = icon('icons/mob/hud_med.dmi')
var/static/icon/buildmode_hud = icon('icons/misc/buildmode.dmi')

//Keyed list for caching icons so you don't need to make them for records, IDs, etc all separately.
//Could be useful for AI impersonation or something at some point?
var/static/list/cached_character_icons = list()

var/list/vinestart			= list()
var/list/verminstart		= list()

var/list/awayabductors = list() // List of scatter landmarks for Abductors in Gateways
var/list/eventdestinations = list() // List of scatter landmarks for VOREStation event portals
var/list/eventabductors = list() // List of scatter landmarks for VOREStation abductor portals

// Some "scary" sounds.
var/static/list/scawwySownds = list(
	'sound/voice/ScawwySownds/a scawey sownd.ogg',
	'sound/voice/ScawwySownds/is that you.ogg',
	'sound/voice/ScawwySownds/lookit this darkness wow.ogg',
	'sound/voice/ScawwySownds/maint preds.ogg',
	'sound/voice/ScawwySownds/spooky sounds.ogg',
	'sound/voice/ScawwySownds/sus.ogg',
	'sound/voice/ScawwySownds/this is scaewy.ogg',
	'sound/voice/ScawwySownds/what is that behind you.ogg',
	'sound/voice/ScawwySownds/what you doin over dere.ogg',
	'sound/voice/ScawwySownds/whats up with all the trash.ogg',
	'sound/voice/ScawwySownds/youre afraid of the dark arent you.ogg'
	)
