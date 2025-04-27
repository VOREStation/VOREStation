/datum/asset/simple/lobby_files
	keep_local_name = TRUE
	assets = list(
		"lobby_loading.gif" = 'html/lobby/loading.gif',
		"load.ogg" = 'sound/lobby/lobby_load.ogg',
	)

/datum/asset/simple/lobby_files/register()
	assets["lobby_bg.gif"] = icon(using_map.lobby_icon, pick(using_map.lobby_screens))
	. = ..()
