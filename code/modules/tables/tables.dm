var/list/table_icon_cache = list()

/obj/structure/table
	name = "table frame"
	icon = 'icons/obj/tables.dmi'
	icon_state = "frame"
	desc = "It's a table, for putting things on. Or standing on, if you really want to."
	density = TRUE
	anchored = TRUE
	climbable = TRUE
	layer = TABLE_LAYER
	throwpass = 1
	surgery_odds = 50 //VOREStation Edit
	var/flipped = 0
	var/maxhealth = 10
	var/health = 10

	// For racks.
	var/can_reinforce = 1
	var/can_plate = 1

	var/manipulating = 0
	var/datum/material/material = null
	var/datum/material/reinforced = null

	// Gambling tables. I'd prefer reinforced with carpet/felt/cloth/whatever, but AFAIK it's either harder or impossible to get /obj/item/stack/material of those.
	// Convert if/when you can easily get stacks of these.
	var/carpeted = 0
	var/carpeted_type = /obj/item/stack/tile/carpet

/obj/structure/table/examine_icon()
	return icon(icon=initial(icon), icon_state=initial(icon_state)) //Basically the map preview version

/obj/structure/table/proc/update_material()
	var/old_maxhealth = maxhealth
	if(!material)
		maxhealth = 10
	else
		maxhealth = material.integrity / 2

		if(reinforced)
			maxhealth += reinforced.integrity / 2

	health += maxhealth - old_maxhealth

/obj/structure/table/take_damage(amount)
	// If the table is made of a brittle material, and is *not* reinforced with a non-brittle material, damage is multiplied by TABLE_BRITTLE_MATERIAL_MULTIPLIER
	if(material && material.is_brittle())
		if(reinforced)
			if(reinforced.is_brittle())
				amount *= TABLE_BRITTLE_MATERIAL_MULTIPLIER
		else
			amount *= TABLE_BRITTLE_MATERIAL_MULTIPLIER
	health -= amount
	if(health <= 0)
		visible_message(span_warning("\The [src] breaks down!"))
		return break_to_parts() // if we break and form shards, return them to the caller to do !FUN! things with

/obj/structure/table/blob_act()
	take_damage(100)

/obj/structure/table/Initialize()
	. = ..()

	// One table per turf.
	for(var/obj/structure/table/T in loc)
		if(T != src)
			// There's another table here that's not us, break to metal.
			// break_to_parts calls qdel(src)
			break_to_parts(full_return = 1)
			return

	// reset color/alpha, since they're set for nice map previews
	color = "#ffffff"
	alpha = 255
	update_connections(ticker && ticker.current_state == GAME_STATE_PLAYING)
	update_icon()
	update_desc()
	update_material()

/obj/structure/table/Destroy()
	material = null
	reinforced = null
	update_connections(1) // Update tables around us to ignore us (material=null forces no connections)
	for(var/obj/structure/table/T in oview(src, 1))
		T.update_icon()
	. = ..()

/obj/structure/table/examine(mob/user)
	. = ..()
	if(health < maxhealth)
		switch(health / maxhealth)
			if(0.0 to 0.5)
				. += span_warning("It looks severely damaged!")
			if(0.25 to 0.5)
				. += span_warning("It looks damaged!")
			if(0.5 to 1.0)
				. += span_notice("It has a few scrapes and dents.")

/obj/structure/table/attackby(obj/item/W, mob/user)

	if(reinforced && W.has_tool_quality(TOOL_SCREWDRIVER))
		remove_reinforced(W, user)
		if(!reinforced)
			update_desc()
			update_icon()
			update_material()
		return 1

	if(carpeted && W.has_tool_quality(TOOL_CROWBAR))
		user.visible_message(span_infoplain(span_bold("\The [user]") + " removes the carpet from \the [src]."),
		                              span_notice("You remove the carpet from \the [src]."))
		new carpeted_type(loc)
		carpeted = 0
		update_icon()
		return 1

	if(!carpeted && material && istype(W, /obj/item/stack/tile/carpet))
		var/obj/item/stack/tile/carpet/C = W
		if(C.use(1))
			user.visible_message(span_infoplain(span_bold("\The [user]") + " adds \the [C] to \the [src]."),
			                              span_notice("You add \the [C] to \the [src]."))
			carpeted = 1
			carpeted_type = W.type
			update_icon()
			return 1
		else
			to_chat(user, span_warning("You don't have enough carpet!"))

	if(!reinforced && !carpeted && material && W.has_tool_quality(TOOL_WRENCH))
		remove_material(W, user)
		if(!material)
			update_connections(1)
			update_icon()
			for(var/obj/structure/table/T in oview(src, 1))
				T.update_icon()
			update_desc()
			update_material()
		return 1

	if(!carpeted && !reinforced && !material && W.has_tool_quality(TOOL_WRENCH))
		dismantle(W, user)
		return 1

	if(health < maxhealth && W.has_tool_quality(TOOL_WELDER))
		var/obj/item/weldingtool/F = W.get_welder()
		if(F.welding)
			to_chat(user, span_notice("You begin reparing damage to \the [src]."))
			playsound(src, F.usesound, 50, 1)
			if(!do_after(user, 20 * F.toolspeed) || !F.remove_fuel(1, user))
				return
			user.visible_message(span_infoplain(span_bold("\The [user]") + " repairs some damage to \the [src]."),
			                              span_notice("You repair some damage to \the [src]."))
			health = max(health+(maxhealth/5), maxhealth) // 20% repair per application
			return 1

	if(!material && can_plate && istype(W, /obj/item/stack/material))
		material = common_material_add(W, user, "plat")
		if(material)
			update_connections(1)
			update_icon()
			update_desc()
			update_material()
		return 1

	return ..()

/obj/structure/table/attack_hand(mob/user as mob)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/X = user
		if(istype(X.species, /datum/species/xenos))
			src.attack_alien(user)
			return
	..()

/obj/structure/table/attack_alien(mob/user as mob)
	visible_message(span_danger("\The [user] tears apart \the [src]!"))
	src.break_to_parts()

/obj/structure/table/attack_generic(mob/user as mob, var/damage)
	if(damage >= 10)
		if(reinforced && prob(70))
			visible_message(span_danger("\The [user] smashes against \the [src]!"))
			take_damage(damage/2)
			user.do_attack_animation(src)
			..()
		else
			visible_message(span_danger("\The [user] tears apart \the [src]!"))
			src.break_to_parts()
			user.do_attack_animation(src)
			return 1
	visible_message(span_infoplain(span_bold("\The [user]") + " scratches at \the [src]!"))
	return ..()

/obj/structure/table/MouseDrop_T(obj/item/stack/material/what)
	if(can_reinforce && isliving(usr) && (!usr.stat) && istype(what) && usr.get_active_hand() == what && Adjacent(usr))
		reinforce_table(what, usr)
	else
		return ..()

/obj/structure/table/proc/reinforce_table(obj/item/stack/material/S, mob/user)
	if(reinforced)
		to_chat(user, span_warning("\The [src] is already reinforced!"))
		return

	if(!can_reinforce)
		to_chat(user, span_warning("\The [src] cannot be reinforced!"))
		return

	if(!material)
		to_chat(user, span_warning("Plate \the [src] before reinforcing it!"))
		return

	if(flipped)
		to_chat(user, span_warning("Put \the [src] back in place before reinforcing it!"))
		return

	reinforced = common_material_add(S, user, "reinforc")
	if(reinforced)
		update_desc()
		update_icon()
		update_material()

/obj/structure/table/proc/update_desc()
	if(material)
		name = "[material.display_name] table"
	else
		name = "table frame"

	if(reinforced)
		name = "reinforced [name]"
		desc = "[initial(desc)] This one seems to be reinforced with [reinforced.display_name]."
	else
		desc = initial(desc)

// Returns the material to set the table to.
/obj/structure/table/proc/common_material_add(obj/item/stack/material/S, mob/user, verb) // Verb is actually verb without 'e' or 'ing', which is added. Works for 'plate'/'plating' and 'reinforce'/'reinforcing'.
	var/datum/material/M = S.get_material()
	if(!istype(M))
		to_chat(user, span_warning("You cannot [verb]e \the [src] with \the [S]."))
		return null

	if(manipulating) return M
	manipulating = 1
	to_chat(user, span_notice("You begin [verb]ing \the [src] with [M.display_name]."))
	if(!do_after(user, 20) || !S.use(1))
		manipulating = 0
		return null
	user.visible_message(span_notice("\The [user] [verb]es \the [src] with [M.display_name]."), span_notice("You finish [verb]ing \the [src]."))
	manipulating = 0
	return M

// Returns the material to set the table to.
/obj/structure/table/proc/common_material_remove(mob/user, datum/material/M, delay, what, type_holding, sound)
	if(!M.stack_type)
		to_chat(user, span_warning("You are unable to remove the [what] from this [src]!"))
		return M

	if(manipulating) return M
	manipulating = 1
	user.visible_message(span_infoplain(span_bold("\The [user]") + " begins removing the [type_holding] holding \the [src]'s [M.display_name] [what] in place."),
	                              span_notice("You begin removing the [type_holding] holding \the [src]'s [M.display_name] [what] in place."))
	if(sound)
		playsound(src, sound, 50, 1)
	if(!do_after(user, delay))
		manipulating = 0
		return M
	user.visible_message(span_infoplain(span_bold("\The [user]") + " removes the [M.display_name] [what] from \the [src]."),
	                              span_notice("You remove the [M.display_name] [what] from \the [src]."))
	new M.stack_type(src.loc)
	manipulating = 0
	return null

/obj/structure/table/proc/remove_reinforced(obj/item/S, mob/user)
	reinforced = common_material_remove(user, reinforced, 40 * S.toolspeed, "reinforcements", "screws", S.usesound)

/obj/structure/table/proc/remove_material(obj/item/W, mob/user)
	material = common_material_remove(user, material, 20 * W.toolspeed, "plating", "bolts", W.usesound)

/obj/structure/table/proc/dismantle(obj/item/W, mob/user)
	if(manipulating) return
	manipulating = 1
	user.visible_message(span_infoplain(span_bold("\The [user]") + " begins dismantling \the [src]."),
	                              span_notice("You begin dismantling \the [src]."))
	playsound(src, W.usesound, 50, 1)
	if(!do_after(user, 20 * W.toolspeed))
		manipulating = 0
		return
	user.visible_message(span_infoplain(span_bold("\The [user]") + " dismantles \the [src]."),
	                              span_notice("You dismantle \the [src]."))
	new /obj/item/stack/material/steel(src.loc)
	qdel(src)
	return

// Returns a list of /obj/item/material/shard objects that were created as a result of this table's breakage.
// Used for !fun! things such as embedding shards in the faces of tableslammed people.

// The repeated
//     S = [x].place_shard(loc)
//     if(S) shards += S
// is to avoid filling the list with nulls, as place_shard won't place shards of certain materials (holo-wood, holo-steel)

/obj/structure/table/proc/break_to_parts(full_return = 0)
	var/list/shards = list()
	var/obj/item/material/shard/S = null
	if(reinforced)
		if(reinforced.stack_type && (full_return || prob(20)))
			reinforced.place_sheet(loc, 1)
		else
			S = reinforced.place_shard(loc)
			if(S) shards += S
	if(material)
		if(material.stack_type && (full_return || prob(20)))
			material.place_sheet(loc, 1)
		else
			S = material.place_shard(loc)
			if(S) shards += S
	if(carpeted && (full_return || prob(50))) // Higher chance to get the carpet back intact, since there's no non-intact option
		new carpeted_type(src.loc)
	if(full_return || prob(20))
		new /obj/item/stack/material/steel(src.loc)
	else
		var/datum/material/M = get_material_by_name(MAT_STEEL)
		S = M.place_shard(loc)
		if(S) shards += S
	qdel(src)
	return shards

/obj/structure/table/can_visually_connect_to(var/obj/structure/S)
	if(istype(S,/obj/structure/table/bench) && !istype(src,/obj/structure/table/bench))
		return FALSE
	if(istype(src,/obj/structure/table/bench) && !istype(S,/obj/structure/table/bench))
		return FALSE
	if(istype(S,/obj/structure/table/rack) && !istype(src,/obj/structure/table/rack))
		return FALSE
	if(istype(src,/obj/structure/table/rack) && !istype(S,/obj/structure/table/rack))
		return FALSE
	if(istype(S,/obj/structure/table))
		return TRUE
	..()

/proc/get_table_image(var/icon/ticon,var/ticonstate,var/tdir,var/tcolor,var/talpha)
	var/icon_cache_key = "\ref[ticon]-[ticonstate]-[tdir]-[tcolor]-[talpha]"
	var/image/I = table_icon_cache[icon_cache_key]
	if(!I)
		I = image(icon = ticon, icon_state = ticonstate, dir = tdir)
		if(tcolor)
			I.color = tcolor
		if(talpha)
			I.alpha = talpha
		table_icon_cache[icon_cache_key] = I

	return I

/obj/structure/table/update_icon()
	if(flipped != 1)
		icon_state = "blank"
		cut_overlays()

		// Base frame shape. Mostly done for glass/diamond tables, where this is visible.
		for(var/i = 1 to 4)
			var/image/I = get_table_image(icon, connections?[i] || 0, 1<<(i-1))
			add_overlay(I)

		// Standard table image
		if(material)
			for(var/i = 1 to 4)
				var/connect = connections?[i] || 0
				var/image/I = get_table_image(icon, "[material.table_icon_base]_[connect]", 1<<(i-1), material.icon_colour, 255 * material.opacity)
				add_overlay(I)

		// Reinforcements
		if(reinforced)
			for(var/i = 1 to 4)
				var/connect = connections?[i] || 0
				var/image/I = get_table_image(icon, "[reinforced.icon_reinf]_[connect]", 1<<(i-1), reinforced.icon_colour, 255 * reinforced.opacity)
				add_overlay(I)

		if(carpeted)
			for(var/i = 1 to 4)
				var/connect = connections?[i] || 0
				var/image/I = get_table_image(icon, "carpet_[connect]", 1<<(i-1))
				add_overlay(I)
	else
		cut_overlays()
		var/type = 0
		var/tabledirs = 0
		for(var/direction in list(turn(dir,90), turn(dir,-90)) )
			var/obj/structure/table/T = locate(/obj/structure/table ,get_step(src,direction))
			if (T && T.flipped == 1 && T.dir == src.dir && material && T.material && T.material.name == material.name)
				type++
				tabledirs |= direction

		type = "[type]"
		if (type=="1")
			if (tabledirs & turn(dir,90))
				type += "-"
			if (tabledirs & turn(dir,-90))
				type += "+"

		icon_state = "flip[type]"
		if(material)
			var/image/I = image(icon, "[material.table_icon_base]_flip[type]")
			I.color = material.icon_colour
			I.alpha = 255 * material.opacity
			add_overlay(I)
			name = "[material.display_name] table"
		else
			name = "table frame"

		if(reinforced)
			var/image/I = image(icon, "[reinforced.icon_reinf]_flip[type]")
			I.color = reinforced.icon_colour
			I.alpha = 255 * reinforced.opacity
			add_overlay(I)

		if(carpeted)
			add_overlay("carpet_flip[type]")

/obj/structure/table/proc/get_all_connected_tables(var/list/connections)
	if(!connections)
		connections = list(src)
	else
		connections |= src
	if(istype(src, /obj/structure/table/rack))
		return connections

	for(var/direction in cardinal)
		var/turf/T = get_step(src, direction)
		if(T)
			var/obj/structure/table/nextT = locate(/obj/structure/table) in T
			if(!nextT || !istype(nextT))
				continue
			if(istype(nextT, /obj/structure/table/rack) || (istype(nextT, /obj/structure/table/bench) && !istype(src, /obj/structure/table/bench)) ||  (!istype(nextT, /obj/structure/table/bench) && istype(src, /obj/structure/table/bench)))
				continue
			if(!(nextT in connections))
				connections |= nextT.get_all_connected_tables(connections)

	return connections


#define CORNER_NONE 0
#define CORNER_COUNTERCLOCKWISE 1
#define CORNER_DIAGONAL 2
#define CORNER_CLOCKWISE 4

/*
  turn() is weird:
    turn(icon, angle) turns icon by angle degrees clockwise
    turn(matrix, angle) turns matrix by angle degrees clockwise
    turn(dir, angle) turns dir by angle degrees counter-clockwise
*/

/proc/dirs_to_corner_states(list/dirs)
	if(!istype(dirs))
		return

	var/list/ret = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST)

	for(var/i = 1 to ret.len)
		var/dir = ret[i]
		. = CORNER_NONE
		if(dir in dirs)
			. |= CORNER_DIAGONAL
		if(turn(dir,45) in dirs)
			. |= CORNER_COUNTERCLOCKWISE
		if(turn(dir,-45) in dirs)
			. |= CORNER_CLOCKWISE
		ret[i] = "[.]"

	return ret

#undef CORNER_NONE
#undef CORNER_COUNTERCLOCKWISE
#undef CORNER_DIAGONAL
#undef CORNER_CLOCKWISE
