/obj/structure/disposalpipe/tagger
	name = "package tagger"
	icon_state = "pipe-tagger"
	var/sort_tag = ""
	var/partial = 0

/obj/structure/disposalpipe/tagger/proc/updatedesc()
	desc = initial(desc)
	if(sort_tag)
		desc += "\nIt's tagging objects with the '[sort_tag]' tag."

/obj/structure/disposalpipe/tagger/proc/updatename()
	if(sort_tag)
		name = "[initial(name)] ([sort_tag])"
		return
	name = initial(name)

/obj/structure/disposalpipe/tagger/Initialize(mapload)
	. = ..()
	dpdir = dir | turn(dir, 180)
	if(sort_tag)
		LAZYADD(GLOB.tagger_locations["[sort_tag]"], get_z(src))
	updatename()
	updatedesc()
	update()
/obj/structure/disposalpipe/tagger/Destroy()
	. = ..()
	if(sort_tag)
		LAZYREMOVE(GLOB.tagger_locations["[sort_tag]"], get_z(src))


/obj/structure/disposalpipe/tagger/attackby(obj/item/I, mob/user)
	if(..())
		return

	if(istype(I, /obj/item/destTagger))
		var/obj/item/destTagger/O = I

		if(O.currTag)// Tag set
			var/current_z = get_z(src)
			if(sort_tag)
				LAZYREMOVE(GLOB.tagger_locations["[sort_tag]"], current_z)
			sort_tag = O.currTag
			LAZYADD(GLOB.tagger_locations["[sort_tag]"], current_z)
			playsound(src, 'sound/machines/twobeep.ogg', 100, 1)
			to_chat(user, span_notice("Changed tag to '[sort_tag]'."))
			updatename()
			updatedesc()

/obj/structure/disposalpipe/tagger/transfer(obj/structure/disposalholder/H)
	if(sort_tag)
		if(partial)
			H.setpartialtag(sort_tag)
		else
			H.settag(sort_tag)
	return ..()

/obj/structure/disposalpipe/tagger/partial //needs two passes to tag
	name = "partial package tagger"
	icon_state = "pipe-tagger-partial"
	partial = 1
