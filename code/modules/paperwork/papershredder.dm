//
// Paper Shredder Machine
//
/obj/machinery/papershredder
	name = "paper shredder"
	desc = "For those documents you don't want seen."
	icon = 'icons/obj/papershredder.dmi'
	icon_state = "shredder-off"
	var/shred_anim = "shredder-shredding"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 200
	power_channel = EQUIP
	circuit = /obj/item/circuitboard/papershredder
	var/max_paper = 10
	var/paperamount = 0
	var/list/shred_amounts = list(
		/obj/item/photo = 1,
		/obj/item/shreddedp = 1,
		/obj/item/paper = 1,
		/obj/item/newspaper = 3,
		/obj/item/card/id = 3,
		/obj/item/paper_bundle = 3,
		)

/obj/machinery/papershredder/Initialize()
	. = ..()
	default_apply_parts()
	update_icon()

/obj/machinery/papershredder/attackby(var/obj/item/W, var/mob/user)

	if(istype(W, /obj/item/storage))
		empty_bin(user, W)
		return
	else if(W.has_tool_quality(TOOL_WRENCH))
		playsound(src, W.usesound, 50, 1)
		anchored = !anchored
		to_chat(user, span_notice("You [anchored ? "wrench" : "unwrench"] \the [src]."))
		return
	else if(default_part_replacement(user, W))
		return
	else if(default_deconstruction_screwdriver(user, W))
		return
	else if(default_deconstruction_crowbar(user, W))
		return
	else
		var/paper_result
		for(var/shred_type in shred_amounts)
			if(istype(W, shred_type))
				paper_result = shred_amounts[shred_type]
		if(paper_result)
			if(inoperable())
				return // Need powah!
			if(paperamount == max_paper)
				to_chat(user, span_warning("\The [src] is full; please empty it before you continue."))
				return
			paperamount += paper_result
			user.drop_from_inventory(W)
			qdel(W)
			playsound(src, 'sound/items/pshred.ogg', 75, 1)
			flick(shred_anim, src)
			if(paperamount > max_paper)
				to_chat(user,span_danger("\The [src] was too full, and shredded paper goes everywhere!"))
				for(var/i=(paperamount-max_paper);i>0;i--)
					var/obj/item/shreddedp/SP = get_shredded_paper()
					SP.loc = get_turf(src)
					SP.throw_at(get_edge_target_turf(src,pick(alldirs)),1,5)
				paperamount = max_paper
			update_icon()
			return
	return ..()

/obj/machinery/papershredder/verb/empty_contents()
	set name = "Empty bin"
	set category = "Object"
	set src in range(1)

	if(usr.stat || usr.restrained() || usr.weakened || usr.paralysis || usr.lying || usr.stunned)
		return

	if(!paperamount)
		to_chat(usr, span_notice("\The [src] is empty."))
		return

	empty_bin(usr)

/obj/machinery/papershredder/proc/empty_bin(var/mob/living/user, var/obj/item/storage/empty_into)

	// Sanity.
	if(empty_into && !istype(empty_into))
		empty_into = null

	if(empty_into && empty_into.contents.len >= empty_into.storage_slots)
		to_chat(user, span_notice("\The [empty_into] is full."))
		return

	while(paperamount)
		var/obj/item/shreddedp/SP = get_shredded_paper()
		if(!SP) break
		if(empty_into)
			empty_into.handle_item_insertion(SP)
			if(empty_into.contents.len >= empty_into.storage_slots)
				break
	if(empty_into)
		if(paperamount)
			to_chat(user, span_notice("You fill \the [empty_into] with as much shredded paper as it will carry."))
		else
			to_chat(user, span_notice("You empty \the [src] into \the [empty_into]."))

	else
		to_chat(user, span_notice("You empty \the [src]."))
	update_icon()

/obj/machinery/papershredder/proc/get_shredded_paper()
	if(!paperamount)
		return
	paperamount--
	return new /obj/item/shreddedp(get_turf(src))

/obj/machinery/papershredder/power_change()
	..()
	spawn(rand(0,15))
		update_icon()

/obj/machinery/papershredder/update_icon()
	cut_overlays()
	if(operable())
		icon_state = "shredder-on"
	else
		icon_state = "shredder-off"
	// Fullness overlay
	add_overlay("shredder-[max(0,min(5,FLOOR(paperamount/max_paper*5, 1)))]")
	if (panel_open)
		add_overlay("panel_open")

//
// Shredded Paper Item
//

/obj/item/shreddedp
	name = "shredded paper"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "shredp"
	throwforce = 0
	w_class = ITEMSIZE_TINY
	throw_range = 3
	throw_speed = 1

/obj/item/shreddedp/New()
	..()
	pixel_x = rand(-5,5)
	pixel_y = rand(-5,5)
	if(prob(65)) color = pick("#BABABA","#7F7F7F")

/obj/item/shreddedp/attackby(var/obj/item/W as obj, var/mob/user)
	if(istype(W, /obj/item/flame/lighter))
		burnpaper(W, user)
	else
		..()

/obj/item/shreddedp/proc/burnpaper(var/obj/item/flame/lighter/P, var/mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	if(user.restrained())
		return
	if(!P.lit)
		to_chat(user, span_warning("\The [P] is not lit."))
		return
	user.visible_message(span_warning("\The [user] holds \the [P] up to \the [src]. It looks like [TU.he] [TU.is] trying to burn it!"), \
		span_warning("You hold \the [P] up to \the [src], burning it slowly."))
	if(!do_after(user,20))
		to_chat(user, span_warning("You must hold \the [P] steady to burn \the [src]."))
		return
	user.visible_message(span_danger("\The [user] burns right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap."), \
		span_danger("You burn right through \the [src], turning it to ash. It flutters through the air before settling on the floor in a heap."))
	FireBurn()

/obj/item/shreddedp/proc/FireBurn()
	var/mob/living/M = loc
	if(istype(M))
		M.drop_from_inventory(src)
	new /obj/effect/decal/cleanable/ash(get_turf(src))
	qdel(src)
