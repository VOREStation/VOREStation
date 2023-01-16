/datum/persistent/filth/CheckTokenSanity(var/list/token)
	. = ..()
	return saves_dirt ? . && isnum(token["dirt"]) : .

/datum/persistent/filth/CreateEntryInstance(var/turf/creating, var/list/token)
	var/_path = token["path"]
	if (saves_dirt)
		new _path(creating, token["age"]+1, token["dirt"])
	else
		new _path(creating, token["age"]+1)

/datum/persistent/filth/proc/GetEntryDirt(var/atom/entry)
	var/turf/simulated/T = get_turf(entry)
	if (istype(T))
		return T.dirt
	return 0

/datum/persistent/filth/CompileEntry(var/atom/entry)
	. = ..()
	if (saves_dirt)
		LAZYADDASSOC(., "dirt", GetEntryDirt(entry))