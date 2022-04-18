/datum/persistent/paper
	name = "paper"
	entries_expire_at = 50
	has_admin_data = TRUE
	var/paper_type = /obj/item/paper
	var/requires_noticeboard = TRUE

/datum/persistent/paper/CheckTurfContents(var/turf/T, var/list/token)
	if(requires_noticeboard && !(locate(/obj/structure/noticeboard) in T))
		new /obj/structure/noticeboard(T)
	. = ..()

/datum/persistent/paper/CreateEntryInstance(var/turf/creating, var/list/token)
	var/obj/structure/noticeboard/board = locate() in creating
	if(requires_noticeboard && LAZYLEN(board.notices) >= board.max_notices)
		return
	var/obj/item/paper/paper = new paper_type(creating)
	paper.info = token["message"]
	paper.name = token["title"]
	paper.last_modified_ckey = token["author"]
	paper.age = token["age"]+1
	if(requires_noticeboard)
		board.add_paper(paper)
	if(!paper.was_maploaded) // If we were created/loaded when the map was made, skip us!
		SSpersistence.track_value(paper, type)
	return paper

/datum/persistent/paper/GetEntryAge(var/atom/entry)
	var/obj/item/paper/paper = entry
	return paper.age

/datum/persistent/paper/CompileEntry(var/atom/entry, var/write_file)
	. = ..()
	var/obj/item/paper/paper = entry
	LAZYADDASSOC(., "author", "[paper.last_modified_ckey ? paper.last_modified_ckey : "unknown"]")
	LAZYADDASSOC(., "message", "[paper.info]")
	LAZYADDASSOC(., "name", "[paper.name]")

/datum/persistent/paper/GetAdminDataStringFor(var/thing, var/can_modify, var/mob/user)
	var/obj/item/paper/paper = thing
	if(can_modify)
		. = "<td style='background-color:[paper.color]'>[paper.info]</td><td>[paper.name]</td><td>[paper.last_modified_ckey]</td><td><a href='byond://?src=\ref[src];caller=\ref[user];remove_entry=\ref[thing]'>Destroy</a></td>"
	else
		. = "<td colspan = 2;style='background-color:[paper.color]'>[paper.info]</td><td>[paper.name]</td><td>[paper.last_modified_ckey]</td>"

/datum/persistent/paper/RemoveValue(var/atom/value)
	var/obj/structure/noticeboard/board = value.loc
	if(istype(board))
		board.remove_paper(value)
	qdel(value)