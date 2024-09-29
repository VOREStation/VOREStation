#define CENTER 1
#define SIDE 2

/obj/item/picnic_blankets_carried
	name = "picnic blanket"
	desc = "A neatly folded picnic blanket!"
	var/unfolded_desc = "Separates your meal from the dirty floor. Or table."
	icon = 'icons/obj/picnic_vr.dmi'
	icon_state = "picnic_carried"
	w_class = ITEMSIZE_NORMAL
	attack_verb = list("flicked", "whipped", "swooshed")
	force = 0.5
	hitsound = 'sound/weapons/towelwhip.ogg'
	drop_sound = 'sound/items/drop/cloth.ogg'
	pickup_sound = 'sound/items/pickup/cloth.ogg'

/obj/item/picnic_blankets_carried/verb/fold_out()
	set name = "Fold out"
	set desc = "Fold out the picnic blanket for use"
	set category = "Object"
	var/obj/structure/picnic_blanket_deployed/P = new /obj/structure/picnic_blanket_deployed(usr.loc)
	P.name = name
	P.desc = unfolded_desc
	P.unfold()
	qdel(src)

/obj/structure/picnic_blanket_deployed
	name = "picnic blanket"
	desc = "Separates your meal from the dirty floor. Or table."
	var/folded_desc = "A neatly folded picnic blanket!"
	icon = 'icons/obj/picnic_vr.dmi'
	icon_state = "picnic_central"
	var/blanket_type = CENTER
	layer = HIDING_LAYER - 0.01 //Stuff shouldn't be able to hide under the blanket on the ground
	var/list/attached_blankets = list()
	anchored = TRUE

/obj/structure/picnic_blanket_deployed/verb/fold_up()
	set name = "Fold up"
	set desc = "Folds the blanket up for carrying"
	set category = "Object"
	set src in oview(1)

	for(var/obj/structure/picnic_blanket_deployed/side in attached_blankets)
		qdel(side)
	var/obj/item/picnic_blankets_carried/P = new /obj/item/picnic_blankets_carried(usr.loc)
	P.name = name
	P.desc = folded_desc
	qdel(src)

/obj/structure/picnic_blanket_deployed/proc/unfold()
	var/dirs = alldirs
	var/isTableTop //Controls whether to spawn things across tables, or on ground
	var/doWeHaveTable //Helper var set to true if ANY obj is a table
	var/anti_spam = FALSE //Helper var to avoid spamming people if they are mired in trash.
	for(var/obj/O in get_turf(src)) //Center element determines behaviour
		if(istype(O, /obj/structure/table))
			isTableTop = TRUE
			layer = TABLE_LAYER + 0.01 //We should be just a bit over tables!

	populate_blankets:
		for(var/dir in dirs)
			var/turf/T = get_step(get_turf(src), dir)
			doWeHaveTable = FALSE //Resetting to False each loop
			if(T.density)
				continue
			if(LAZYLEN(T.contents) > 20) //Avoiding potential perf issues by not iterating over large piles of objs
				if(!anti_spam)
					to_chat(usr, SPAN_NOTICE("Too many items! Couldn't fully unfold the blanket!"))
					anti_spam = TRUE
				continue
			for(var/obj/O in T)
				if(O.density) //Cables & Atmos machinery dont bother us.
					if(isTableTop && istype(O, /obj/structure/table)) //We expand to the table if the center is a table
						doWeHaveTable = TRUE
						break
					else
						continue populate_blankets
			if(isTableTop && !doWeHaveTable) //However, if center is a table, we don't expand if we havn't found any.
				continue //If center is on table, we only allow the rest to appear on tables as well.

			//Actually spawning
			var/obj/structure/picnic_blanket_deployed/side = new /obj/structure/picnic_blanket_deployed(T)
			side.verbs -= /obj/structure/picnic_blanket_deployed/verb/fold_up
			attached_blankets += side
			side.blanket_type = SIDE
			side.name = name //Making sure side blankets inherit our vars if they got edited at runtime
			side.desc = desc
			side.set_dir(dir)
			if(isTableTop)
				side.layer = TABLE_LAYER + 0.01 //We should be just above tables.
			side.update_icon()

/obj/structure/picnic_blanket_deployed/update_icon()
	if(blanket_type == SIDE)
		icon_state = "picnic_sides" //8 directional icon
	if(blanket_type == CENTER)
		icon_state = "picnic_central" //Adding in case anything might call update_icon on center one. Just to be safe
	. = ..()

/obj/structure/picnic_blanket_deployed/examine(mob/user)
	. = ..()
	if(blanket_type == CENTER)
		. += SPAN_NOTICE("This is the center of a folded out picnic blanket. You can use this to start packing it up!")
	if(blanket_type == SIDE)
		. += SPAN_NOTICE("This is one of the edges. Look for the center to start packing!")

//For Mapping use only.
//If player folds it back up, it reverts to normal type so the Initialize() won't cause issues
//Should be added last to any maps made, to ensure it initializes after all other relevant objs.
//Set unfoldable to TRUE if want to prevent players from picking it up
/obj/structure/picnic_blanket_deployed/for_mapping_use
	name = "RENAME ME"
	var/unfoldable = FALSE


/obj/structure/picnic_blanket_deployed/for_mapping_use/Initialize()
	. = ..()
	unfold()
	if(unfoldable)
		verbs -= /obj/structure/picnic_blanket_deployed/verb/fold_up

#undef CENTER
#undef SIDE
