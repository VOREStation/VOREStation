/datum/persistent/paper/sticky
	name = "stickynotes"
	paper_type = /obj/item/paper/sticky
	requires_noticeboard = FALSE

/datum/persistent/paper/sticky/CreateEntryInstance(turf/creating, list/token)
	var/atom/paper = ..()
	if(paper)
		//VOREStation add - sometimes they fall off
		if(prob(90))
			paper.pixel_x = token["offset_x"]
			paper.pixel_y = token["offset_y"]
		else
			paper.pixel_x = rand(-5,5)
			paper.pixel_y = rand(-5,5)
		//VOREStation add end
		paper.color =   token["color"]
	return paper

/datum/persistent/paper/sticky/CompileEntry(atom/entry, write_file)
	. = ..()
	var/obj/item/paper/sticky/paper = entry
	LAZYADDASSOC(., "offset_x", paper.pixel_x)
	LAZYADDASSOC(., "offset_y", paper.pixel_y)
	LAZYADDASSOC(., "color", paper.color)
