GLOBAL_LIST_EMPTY(clients) //all clients
GLOBAL_LIST_EMPTY(admins) //all clients whom are admins
GLOBAL_PROTECT(admins)
GLOBAL_LIST_EMPTY(deadmins) //all ckeys who have used the de-admin verb.

GLOBAL_LIST_EMPTY(directory) //all ckeys with associated client
GLOBAL_LIST_EMPTY(stealthminID) //reference list with IDs that store ckeys, for stealthmins

//Since it didn't really belong in any other category, I'm putting this here
//This is for procs to replace all the goddamn 'in world's that are chilling around the code

GLOBAL_LIST_EMPTY(keyloop_list) //as above but can be limited to boost performance
GLOBAL_LIST_EMPTY(new_player_list) //all /mob/new_player, in theory all should have clients and those that don't are in the process of spawning and get deleted when done.

GLOBAL_LIST_EMPTY(mob_config_movespeed_type_lookup)

/proc/update_config_movespeed_type_lookup(update_mobs = TRUE)
	var/list/mob_types = list()
	var/list/entry_value = CONFIG_GET(keyed_list/multiplicative_movespeed)
	for(var/path in entry_value)
		var/value = entry_value[path]
		if(!value)
			continue
		for(var/subpath in typesof(path))
			mob_types[subpath] = value
	GLOB.mob_config_movespeed_type_lookup = mob_types
	if(update_mobs)
		update_mob_config_movespeeds()

/proc/update_mob_config_movespeeds()
	for(var/i in GLOB.mob_list)
		var/mob/M = i
		M.update_config_movespeed()
