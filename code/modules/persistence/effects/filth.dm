/datum/persistent/filth
	name = "filth"
	entries_expire_at = 4 // 4 rounds, 24 hours.
	var/saves_dirt = TRUE //VOREStation edit

/datum/persistent/filth/IsValidEntry(var/atom/entry)
	. = ..() && entry.invisibility == 0

/datum/persistent/filth/CheckTokenSanity(var/list/token)
	// byond's json implementation is "questionable", and uses types as keys and values without quotes sometimes even though they aren't valid json
	token["path"] = istext(token["path"]) ? text2path(token["path"]) : token["path"]
	return ..() && ispath(token["path"])

/datum/persistent/filth/CheckTurfContents(var/turf/T, var/list/token)
	var/_path = token["path"]
	return (locate(_path) in T) ? FALSE : TRUE

/datum/persistent/filth/CreateEntryInstance(var/turf/creating, var/list/token)
	var/_path = token["path"]
	new _path(creating, token["age"]+1)

/datum/persistent/filth/GetEntryAge(var/atom/entry)
	var/obj/effect/decal/cleanable/filth = entry
	return filth.age

/datum/persistent/filth/proc/GetEntryPath(var/atom/entry)
	var/obj/effect/decal/cleanable/filth = entry
	return filth.generic_filth ? /obj/effect/decal/cleanable/filth : filth.type

/datum/persistent/filth/CompileEntry(var/atom/entry)
	. = ..()
	LAZYADDASSOC(., "path", "[GetEntryPath(entry)]")