/**
 * Used by mapmerge2 to denote the existence of a merge conflict (or when it has to complete a "best intent" merge where it dumps the movable contents of an old key and a new key on the same tile).
 * We define it explicitly here to ensure that it shows up on the highest possible plane (while giving off a verbose icon) to aide mappers in resolving these conflicts.
 * DO NOT USE THIS IN NORMAL MAPPING!!! Linters WILL fail.
 */
/obj/merge_conflict_marker
	name = "Merge Conflict Marker - DO NOT USE"
	icon = 'icons/turf/floors.dmi'
	icon_state = ""
	desc = "If you are seeing this in-game: Yell at whoever made this mistake."

///We REALLY do not want un-addressed merge conflicts in maps for an inexhaustible list of reasons. This should help ensure that this will not be missed in case linters fail to catch it for any reason what-so-ever.
/obj/merge_conflict_marker/Initialize(mapload)
	. = ..()
	var/msg = "HEY, LISTEN!!! Merge Conflict Marker detected at [COORD(src)]! Please manually address all potential merge conflicts!!!"
	to_chat(world, span_warning("[msg]"))
	CRASH(msg)
