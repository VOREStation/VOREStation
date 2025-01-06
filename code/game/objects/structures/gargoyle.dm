/obj/structure/gargoyle
	name = "statue"
	desc = "A very lifelike carving."
	density = TRUE
	anchored = TRUE
	var/mob/living/carbon/human/gargoyle
	var/initial_sleep
	var/initial_blind
	var/initial_is_shifted
	var/initial_lying
	var/initial_lying_prev
	var/wagging
	var/flapping
	var/obj_integrity = 100
	var/original_int = 100
	var/max_integrity = 100
	var/stored_examine
	var/identifier = "statue"
	var/material = "stone"
	var/adjective = "hardens"
	var/list/tail_lower_dirs = list(SOUTH, EAST, WEST)
	var/image/tail_image
	var/tail_alt = TAIL_UPPER_LAYER

	var/can_revert = TRUE
	var/was_rayed = FALSE

/obj/structure/gargoyle/Initialize(mapload, var/mob/living/carbon/human/H, var/ident_ovr, var/mat_ovr, var/adj_ovr, var/tint_ovr, var/revert = TRUE, var/discard_clothes)
	. = ..()
	if (isspace(loc) || isopenspace(loc))
		anchored = FALSE
	if (!istype(H) || !isturf(H.loc))
		return
	var/datum/component/gargoyle/comp = H.GetComponent(/datum/component/gargoyle)
	var/tint = "#FFFFFF"
	if (comp)
		comp.cooldown = world.time + (15 SECONDS)
		comp.statue = src
		comp.transformed = TRUE
		comp.paused = FALSE
		identifier = length(comp.identifier) > 0 ? comp.identifier : initial(identifier)
		material = length(comp.material) > 0 ? comp.material : initial(material)
		tint = length(comp.tint) > 0 ? comp.tint : initial(tint)
		adjective = length(comp.adjective) > 0 ? comp.adjective : initial(adjective)
		if (copytext_char(adjective, -1) != "s")
			adjective += "s"
	gargoyle = H

	if (H.get_effective_size(TRUE) < 0.5) // "So small! I can step over it!"
		density = FALSE

	if (ident_ovr)
		identifier = ident_ovr
	if (mat_ovr)
		material = mat_ovr
	if (adj_ovr)
		adjective = adj_ovr
	if (tint_ovr)
		tint = tint_ovr

	if (H.tail_style?.clip_mask_state)
		tail_lower_dirs.Cut()
	else if (H.tail_style)
		tail_lower_dirs = H.tail_style.lower_layer_dirs.Copy()
	tail_alt = H.tail_alt ? TAIL_UPPER_LAYER_ALT : TAIL_UPPER_LAYER

	max_integrity = H.getMaxHealth() + 100
	obj_integrity = H.health + 100
	original_int = obj_integrity
	name = "[identifier] of [H.name]"
	desc = "A very lifelike [identifier] made of [material]."
	stored_examine = H.examine(H)
	description_fluff = H.get_description_fluff()

	if (H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)
	//icon = H.icon
	//copy_overlays(H)

	//calculate our tints
	var/list/RGB = rgb2num(tint)

	var/colorr = rgb(RGB[1]*0.299, RGB[2]*0.299, RGB[3]*0.299)
	var/colorg = rgb(RGB[1]*0.587, RGB[2]*0.587, RGB[3]*0.587)
	var/colorb = rgb(RGB[1]*0.114, RGB[2]*0.114, RGB[3]*0.114)

	var/tint_color = list(colorr, colorg, colorb, "#000000")

	var/list/body_layers = HUMAN_BODY_LAYERS
	var/list/other_layers = HUMAN_OTHER_LAYERS
	for (var/i = 1; i <= length(H.overlays_standing); i++)
		if (i in other_layers)
			continue
		if (discard_clothes && !(i in body_layers))
			continue
		if (istype(H.overlays_standing[i], /image) && (i in body_layers))
			var/image/old_image = H.overlays_standing[i]
			var/image/new_image = image(old_image)
			if (i == TAIL_LOWER_LAYER || i == TAIL_UPPER_LAYER || i == TAIL_UPPER_LAYER_ALT)
				tail_image = new_image
			new_image.color = tint_color
			new_image.layer = old_image.layer
			add_overlay(new_image)
		else
			if (!isnull(H.overlays_standing[i]))
				add_overlay(H.overlays_standing[i])

	initial_sleep = H.sleeping
	initial_blind = H.eye_blind
	initial_is_shifted = H.is_shifted
	transform = H.transform
	layer = H.layer
	pixel_x = H.pixel_x
	pixel_y = H.pixel_y
	dir = H.dir
	initial_lying = H.lying
	initial_lying_prev = H.lying_prev
	H.sdisabilities |= MUTE
	if (H.appearance_flags & PIXEL_SCALE)
		appearance_flags |= PIXEL_SCALE
	wagging = H.wagging
	H.transforming = TRUE
	flapping = H.flapping
	H.toggle_tail(FALSE, FALSE)
	H.toggle_wing(FALSE, FALSE)
	H.visible_message(span_warning("[H]'s skin rapidly [adjective] as they turn to [material]!"), span_warning("Your skin abruptly [adjective] as you turn to [material]!"))
	H.forceMove(src)
	H.SetBlinded(0)
	H.SetSleeping(0)
	H.status_flags |= GODMODE
	H.updatehealth()
	H.canmove = 0

	can_revert = revert

	START_PROCESSING(SSprocessing, src)

/obj/structure/gargoyle/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if (!gargoyle)
		return ..()
	if (can_revert)
		unpetrify(deleting = FALSE) //don't delete if we're already deleting!
	else
		visible_message(span_warning("The [identifier] loses shape and crumbles into a pile of [material]!"))
	. = ..()

/obj/structure/gargoyle/process()
	if (!gargoyle)
		qdel(src)
	if (gargoyle.loc != src)
		can_revert = TRUE //something's gone wrong, they escaped, lets not qdel them
		unpetrify(deal_damage = FALSE, deleting = TRUE)

/obj/structure/gargoyle/examine_icon()
	var/icon/examine_icon = icon(icon=src.icon, icon_state=src.icon_state, dir=SOUTH, frame=1, moving=0)
	examine_icon.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))
	return examine_icon

/obj/structure/gargoyle/get_description_info()
	if (gargoyle)
		if (isspace(loc) || isopenspace(loc))
			return
		return "It can be [anchored ? "un" : ""]anchored with a wrench."

/obj/structure/gargoyle/examine(mob/user)
	. = ..()
	if (gargoyle && stored_examine)
		. += "The [identifier] seems to have a bit more to them..."
		. += stored_examine
	return

/obj/structure/gargoyle/proc/unpetrify(var/deal_damage = TRUE, var/deleting = FALSE)
	if (!gargoyle)
		return
	var/datum/component/gargoyle/comp = gargoyle.GetComponent(/datum/component/gargoyle)
	if (comp)
		comp.cooldown = world.time + (15 SECONDS)
		comp.statue = null
		comp.transformed = FALSE
	else
		if (was_rayed)
			remove_verb(gargoyle,/mob/living/carbon/human/proc/gargoyle_transformation)
	if (gargoyle.loc == src)
		gargoyle.forceMove(loc)
		gargoyle.transform = transform
		gargoyle.pixel_x = pixel_x
		gargoyle.pixel_y = pixel_y
		gargoyle.is_shifted = initial_is_shifted
		gargoyle.dir = dir
		gargoyle.lying = initial_lying
		gargoyle.lying_prev = initial_lying_prev
		gargoyle.toggle_tail(wagging, FALSE)
		gargoyle.toggle_wing(flapping, FALSE)
	gargoyle.sdisabilities &= ~MUTE //why is there no ADD_TRAIT etc here that's actually ussssed
	gargoyle.status_flags &= ~GODMODE
	gargoyle.SetBlinded(initial_blind)
	gargoyle.SetSleeping(initial_sleep)
	gargoyle.transforming = FALSE
	gargoyle.canmove = 1
	gargoyle.update_canmove()
	var/hurtmessage = ""
	if (deal_damage)
		if (obj_integrity < original_int)
			var/f = (original_int - obj_integrity) / 10
			for (var/x in 1 to 10)
				gargoyle.adjustBruteLoss(f)
			hurtmessage = " " + span_bold("You feel your body take the damage that was dealt while being [material]!")
	gargoyle.updatehealth()
	alpha = 0
	gargoyle.visible_message(span_warning("[gargoyle]'s skin rapidly reverts, returning them to normal!"), span_warning("Your skin reverts, freeing your movement once more![hurtmessage]"))
	gargoyle = null
	if (deleting)
		qdel(src)

/obj/structure/gargoyle/return_air()
	return return_air_for_internal_lifeform()

/obj/structure/gargoyle/return_air_for_internal_lifeform(var/mob/living/lifeform)
	var/air_type = /datum/gas_mixture/belly_air
	if(istype(lifeform))
		air_type = lifeform.get_perfect_belly_air_type()
	var/air = new air_type(1000)
	return air

/obj/structure/gargoyle/proc/damage(var/damage)
	if (was_rayed)
		return //gargoyle quick regenerates, the others don't, so let's not have them getting too damaged
	obj_integrity = min(obj_integrity-damage, max_integrity)
	if(obj_integrity <= 0)
		qdel(src)

/obj/structure/gargoyle/take_damage(var/damage)
	damage(damage)

/obj/structure/gargoyle/attack_generic(var/mob/user, var/damage, var/attack_message = "hits")
	user.do_attack_animation(src)
	visible_message(span_danger("[user] [attack_message] the [src]!"))
	damage(damage)

/obj/structure/gargoyle/attackby(var/obj/item/W as obj, var/mob/living/user as mob)
	if(W.is_wrench())
		if (isspace(loc) || isopenspace(loc))
			to_chat(user, span_warning("You can't anchor that here!"))
			anchored = FALSE
			return ..()
		playsound(src, W.usesound, 50, 1)
		if (do_after(user, (2 SECONDS) * W.toolspeed, target = src))
			to_chat(user, span_notice("You [anchored ? "un" : ""]anchor the [src]."))
			anchored = !anchored
	else if(!isrobot(user) && gargoyle && gargoyle.vore_selected && gargoyle.trash_catching)
		if(istype(W,/obj/item/grab || /obj/item/holder))
			gargoyle.vore_attackby(W, user)
			return
		if(gargoyle.adminbus_trash || is_type_in_list(W,edible_trash) && W.trash_eatable && !is_type_in_list(W,item_vore_blacklist))
			to_chat(user, span_warning("You slip [W] into [gargoyle]'s [lowertext(gargoyle.vore_selected.name)] ."))
			user.drop_item()
			W.forceMove(gargoyle.vore_selected)
			return
	else if (!(W.flags & NOBLUDGEON))
		user.setClickCooldown(user.get_attack_speed(W))
		if(W.damtype == BRUTE || W.damtype == BURN)
			user.do_attack_animation(src)
			playsound(src, W.hitsound, 50, 1)
			damage(W.force)
	else
		return ..()

/obj/structure/gargoyle/set_dir(var/new_dir)
	. = ..()
	if(. && tail_image)
		cut_overlay(tail_image)
		tail_image.layer = BODY_LAYER + ((dir in tail_lower_dirs) ? TAIL_LOWER_LAYER : tail_alt)
		add_overlay(tail_image)

/obj/structure/gargoyle/hitby(atom/movable/AM as mob|obj,var/speed = THROWFORCE_SPEED_DIVISOR)
	if(istype(AM,/obj/item) && gargoyle && gargoyle.vore_selected && gargoyle.trash_catching)
		var/obj/item/I = AM
		if(gargoyle.adminbus_trash || is_type_in_list(I,edible_trash) && I.trash_eatable && !is_type_in_list(I,item_vore_blacklist))
			gargoyle.hitby(AM, speed)
			return
	else if(isliving(AM) && gargoyle)
		var/mob/living/L = AM
		if(gargoyle.throw_vore && L.throw_vore && gargoyle.can_be_drop_pred && L.can_be_drop_prey)
			var/drop_prey_temp = FALSE
			if(gargoyle.can_be_drop_prey)
				drop_prey_temp = TRUE
				gargoyle.can_be_drop_prey = FALSE //Making sure the original gargoyle body is not the one getting throwvored instead.
			gargoyle.hitby(L, speed)
			if(drop_prey_temp)
				gargoyle.can_be_drop_prey = TRUE
			return
	return ..()
