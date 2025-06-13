// Items that ask to be called every cycle.
GLOBAL_DATUM(data_core, /datum/datacore)

//I would upgrade all instances of global.machines to SSmachines.all_machines but it's used in so many places and a search returns so many matches for 'machines' that isn't a use of the global...
GLOBAL_LIST_INIT(machines, SSmachines.all_machines)

GLOBAL_LIST_EMPTY(active_diseases)
GLOBAL_LIST_EMPTY(hud_icon_reference)

GLOBAL_LIST_EMPTY(global_mutations) // List of hidden mutation things.

GLOBAL_DATUM_INIT(universe, /datum/universal_state, new)

GLOBAL_LIST(global_map)

// Noises made when hit while typing.
GLOBAL_LIST_INIT(hit_appends, list("-OOF", "-ACK", "-UGH", "-HRNK", "-HURGH", "-GLORF"))

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
GLOBAL_VAR_INIT(game_year, (text2num(time2text(world.realtime, "YYYY")) + 300))
GLOBAL_VAR_INIT(round_progressing, TRUE)

GLOBAL_VAR_INIT(master_mode, "extended") // "extended"
GLOBAL_VAR_INIT(secret_force_mode, "secret") // if this is anything but "secret", the secret rotation will forceably choose this mode.

GLOBAL_DATUM_INIT(mods, /datum/moduletypes, new())

GLOBAL_VAR_INIT(gravity_is_on, TRUE)

GLOBAL_VAR(join_motd)

// Metric datum, used to keep track of the round.
GLOBAL_DATUM_INIT(metric, /datum/metric, new())

// For FTP requests. (i.e. downloading runtime logs.)
// However it'd be ok to use for accessing attack logs and such too, which are even laggier.
GLOBAL_VAR_INIT(fileaccess_timer, 0)
GLOBAL_VAR(custom_event_msg)


// Used by robots and robot preferences for regular modules.
GLOBAL_LIST_INIT(robot_module_types, list(
	"Standard", "Engineering", /*"Surgeon",*/ "Crisis", "Miner",
	"Janitor", "Service", "Clown", "Clerical", "Security",
	"Research", "Command" //"Exploration"
))
// List of modules added during code red
GLOBAL_LIST_INIT(emergency_module_types, list(
	"Combat"
))
// List of modules available to AI shells
GLOBAL_LIST_INIT(shell_module_types, list(
	"Standard", "Engineering", "Surgeon", "Crisis", "Miner",
	"Janitor", "Service", "Clown", "Clerical", "Security",
	"Research", "Command" //"Exploration"
))
// List of whitelisted modules
GLOBAL_LIST_INIT(whitelisted_module_types, list(
	"Lost"
))

// Bomb cap!
GLOBAL_VAR_INIT(max_explosion_range, 14)

// Announcer intercom, because too much stuff creates an intercom for one message then hard del()s it.
GLOBAL_DATUM_INIT(global_announcer, /obj/item/radio/intercom/omni, new /obj/item/radio/intercom/omni(null))

GLOBAL_LIST_INIT(station_departments, list("Command", "Medical", "Engineering", "Research", "Security", "Cargo", "Exploration", "Civilian"))

//Icons for in-game HUD glasses. Why don't we just share these a little bit?
GLOBAL_DATUM_INIT(ingame_hud, /icon, icon('icons/mob/hud.dmi'))
GLOBAL_DATUM_INIT(ingame_hud_med, /icon, icon('icons/mob/hud_med.dmi'))
GLOBAL_DATUM_INIT(buildmode_hud, /icon, icon('icons/misc/buildmode.dmi'))

//Keyed list for caching icons so you don't need to make them for records, IDs, etc all separately.
//Could be useful for AI impersonation or something at some point?
GLOBAL_LIST_EMPTY(cached_character_icons)
