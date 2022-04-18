#define UAV_OFF 0
#define UAV_ON 1
#define UAV_PAIRING 2
#define UAV_PACKED 3

/obj/item/uav
	name = "recon skimmer"
	desc = "A semi-portable reconnaissance drone that folds into a backpack-sized carrying case."
	icon = 'icons/obj/uav.dmi'
	icon_state = "uav"

	var/obj/item/cell/cell
	var/cell_type = null //Can put a starting cell here

	density = TRUE //Is dense, but not anchored, so you can swap with it
	slowdown = 1.5 //Heevvee.

	health = 100

	light_system = MOVABLE_LIGHT_DIRECTIONAL
	light_cone_y_offset = 5
	light_range = 4
	light_power = 4
	var/power_per_process = 50 // About 6.5 minutes of use on a high-cell (10,000)
	var/state = UAV_OFF

	var/datum/effect/effect/system/ion_trail_follow/ion_trail

	var/list/mob/living/masters

	// So you know which is which
	var/nickname = "Unnamed UAV"

	// Radial menu
	var/static/image/radial_pickup = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_pickup")
	var/static/image/radial_wrench = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_wrench")
	var/static/image/radial_power = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_power")
	var/static/image/radial_pair = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_pair")

	// Movement cooldown
	var/next_move = 0

	// Idle shutdown time
	var/no_masters_time = 0

/obj/item/uav/loaded
	cell_type = /obj/item/cell/high

/obj/item/uav/Initialize()
	. = ..()
	
	if(!cell && cell_type)
		cell = new cell_type
	
	ion_trail = new /datum/effect/effect/system/ion_trail_follow()
	ion_trail.set_up(src)
	ion_trail.stop()

/obj/item/uav/Destroy()
	qdel_null(cell)
	qdel_null(ion_trail)
	LAZYCLEARLIST(masters)
	STOP_PROCESSING(SSobj, src)
	return ..()

<<<<<<< HEAD
/obj/item/device/uav/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "It has <i>'[nickname]'</i> scribbled on the side."
	if(!cell)
		. += "<span class='warning'>It appears to be missing a power cell.</span>"
	
	if(health <= (initial(health)/4))
		. += "<span class='warning'>It looks like it might break at any second!</span>"
	else if(health <= (initial(health)/2))
		. += "<span class='warning'>It looks pretty beaten up...</span>"

/obj/item/device/uav/attack_hand(var/mob/user)
=======
/obj/item/uav/attack_hand(var/mob/user)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
	//Has to be on the ground to work with it properly
	if(!isturf(loc))
		return ..()

	var/list/options = list(
		"Pick Up" = radial_pickup,
		"(Dis)Assemble" = radial_wrench,
		"Toggle Power" = radial_power,
		"Pairing Mode" = radial_pair)
	var/choice = show_radial_menu(user, src, options, require_near = !issilicon(user))
	
	switch(choice)
		// Can pick up when off or packed
		if("Pick Up")
			if(state == UAV_OFF || state == UAV_PACKED)
				return ..()
			else
				to_chat(user,"<span class='warning'>Turn [nickname] off or pack it first!</span>")
				return
		// Can disasemble or reassemble from packed or off (and this one takes time)
		if("(Dis)Assemble")
			if(can_transition_to(state == UAV_PACKED ? UAV_OFF : UAV_PACKED, user))
				user.visible_message("<b>[user]</b> starts [state == UAV_PACKED ? "unpacking" : "packing"] [src].", "You start [state == UAV_PACKED ? "unpacking" : "packing"] [src].")
				if(do_after(user, 10 SECONDS, src))
					return toggle_packed(user)
		// Can toggle power from on and off
		if("Toggle Power")
			if(can_transition_to(state == UAV_ON ? UAV_OFF : UAV_ON, user))
				return toggle_power(user)
		// Can pair when off
		if("Pairing Mode")
			if(can_transition_to(state == UAV_PAIRING ? UAV_OFF : UAV_PAIRING, user))
				return toggle_pairing(user)

/obj/item/uav/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/modular_computer) && state == UAV_PAIRING)
		var/obj/item/modular_computer/MC = I
		LAZYDISTINCTADD(MC.paired_uavs, weakref(src))
		playsound(src, 'sound/machines/buttonbeep.ogg', 50, 1)
		visible_message("<span class='notice'>[user] pairs [I] to [nickname]</span>")
		toggle_pairing()
	
	else if(I.is_screwdriver() && cell)
		if(do_after(user, 3 SECONDS, src))
			to_chat(user, "<span class='notice'>You remove [cell] into [nickname].</span>")
			playsound(src, I.usesound, 50, 1)
			power_down()
			cell.forceMove(get_turf(src))
			cell = null
<<<<<<< HEAD
	
	else if(istype(I, /obj/item/weapon/cell) && !cell)
=======

	else if(istype(I, /obj/item/cell) && !cell)
>>>>>>> 61084723c7b... Merge pull request #8317 from Atermonera/remove_weapon
		if(do_after(user, 3 SECONDS, src))
			to_chat(user, "<span class='notice'>You insert [I] into [nickname].</span>")
			playsound(src, 'sound/items/deconstruct.ogg', 50, 1)
			power_down()
			user.remove_from_mob(I)
			I.forceMove(src)
			cell = I

	else if(istype(I, /obj/item/pen) || istype(I, /obj/item/flashlight/pen))
		var/tmp_label = sanitizeSafe(input(user, "Enter a nickname for [src]", "Nickname", nickname), MAX_NAME_LEN)
		if(length(tmp_label) > 50 || length(tmp_label) < 3)
			to_chat(user, "<span class='notice'>The nickname must be between 3 and 50 characters.</span>")
		else
			to_chat(user, "<span class='notice'>You scribble your new nickname on the side of [src].</span>")
			nickname = tmp_label
			desc = initial(desc) + " This one has <span class='notice'>'[nickname]'</span> scribbled on the side."
	else
		return ..()

/obj/item/uav/proc/can_transition_to(var/new_state, var/mob/user)
	switch(state) //Current one
		if(UAV_ON)
			if(new_state == UAV_OFF || new_state == UAV_PACKED)
				. = TRUE
		if(UAV_OFF)
			if(new_state == UAV_ON || new_state == UAV_PACKED || new_state == UAV_PAIRING)
				. = TRUE
		if(UAV_PAIRING)
			if(new_state == UAV_OFF)
				. = TRUE
		if(UAV_PACKED)
			if(new_state == UAV_OFF)
				. = TRUE

	if(!.)
		if(user)
			to_chat(user, "<span class='warning'>You can't do that while [nickname] is in this state.</span>")
		return FALSE

/obj/item/uav/update_icon()
	cut_overlays()
	switch(state)
		if(UAV_PAIRING)
			add_overlay("[initial(icon_state)]_pairing")
			icon_state = "[initial(icon_state)]"
		if(UAV_ON)
			icon_state = "[initial(icon_state)]_on"
		if(UAV_OFF)
			icon_state = "[initial(icon_state)]"
		if(UAV_PACKED)
			icon_state = "[initial(icon_state)]_packed"

/obj/item/uav/process()
	if(cell?.use(power_per_process) != power_per_process)
		visible_message("<span class='warning'>[src] sputters and thuds to the ground, inert.</span>")
		playsound(src, 'sound/items/drop/metalboots.ogg', 75, 1)
		power_down()
		health -= initial(health)*0.25 //Lose 25% of your original health
	
	if(LAZYLEN(masters))
		no_masters_time = 0
	else if(no_masters_time++ > 50)
		power_down()

/obj/item/uav/proc/toggle_pairing()
	switch(state)
		if(UAV_PAIRING)
			state = UAV_OFF
			update_icon()
			return TRUE
		if(UAV_OFF)
			state = UAV_PAIRING
			update_icon()
			return TRUE
	return FALSE

/obj/item/uav/proc/toggle_power()
	switch(state)
		if(UAV_OFF)
			power_up()
			return TRUE
		if(UAV_ON)
			power_down()
			return TRUE
	return FALSE

/obj/item/uav/proc/toggle_packed()
	if(state == UAV_ON)
		power_down()
	switch(state)
		if(UAV_OFF) //Packing
			state = UAV_PACKED
			w_class = ITEMSIZE_LARGE
			slowdown = 0.5
			density = FALSE
			update_icon()
			return TRUE
		if(UAV_PACKED) //Unpacking
			state = UAV_OFF
			w_class = ITEMSIZE_HUGE
			slowdown = 1.5
			density = TRUE
			update_icon()
			return TRUE
	return FALSE

/obj/item/uav/proc/power_up()
	if(state != UAV_OFF || !isturf(loc))
		return
	if(cell?.use(power_per_process) != power_per_process)
		visible_message("<span class='warning'>[src] sputters and chugs as it tries, and fails, to power up.</span>")
		return

	state = UAV_ON
	update_icon()
	start_hover()
	set_light_on(TRUE)
	START_PROCESSING(SSobj, src)
	no_masters_time = 0
	visible_message("<span class='notice'>[nickname] buzzes and lifts into the air.</span>")

/obj/item/uav/proc/power_down()
	if(state != UAV_ON)
		return
	
	state = UAV_OFF
	update_icon()
	stop_hover()
	set_light_on(FALSE)
	LAZYCLEARLIST(masters)
	STOP_PROCESSING(SSobj, src)
	visible_message("<span class='notice'>[nickname] gracefully settles onto the ground.</span>")

//////////////// Helpers
/obj/item/uav/get_cell()
	return cell

/obj/item/uav/relaymove(var/mob/user, direction, signal = 1)
	if(signal && state == UAV_ON && (weakref(user) in masters))
		if(next_move <= world.time)
			next_move = world.time + (1 SECOND/signal)
			step(src, direction)
		return TRUE // Even if we couldn't step, we're taking credit for absorbing the move
	return FALSE

/obj/item/uav/proc/get_status_string()
	return "[nickname] - [get_x(src)],[get_y(src)],[get_z(src)] - I:[health]/[initial(health)] - C:[cell ? "[cell.charge]/[cell.maxcharge]" : "Not Installed"]"

/obj/item/uav/proc/add_master(var/mob/living/M)
	LAZYDISTINCTADD(masters, weakref(M))

/obj/item/uav/proc/remove_master(var/mob/living/M)
	LAZYREMOVE(masters, weakref(M))

/obj/item/uav/check_eye()
	if(state == UAV_ON)
		return 0
	else
		return -1

/obj/item/uav/proc/start_hover()
	if(!ion_trail.on) //We'll just use this to store if we're floating or not
		ion_trail.start()
		var/amplitude = 2 //maximum displacement from original position
		var/period = 36 //time taken for the mob to go up >> down >> original position, in deciseconds. Should be multiple of 4

		var/top = old_y + amplitude
		var/bottom = old_y - amplitude
		var/half_period = period / 2
		var/quarter_period = period / 4

		animate(src, pixel_y = top, time = quarter_period, easing = SINE_EASING | EASE_OUT, loop = -1)		//up
		animate(pixel_y = bottom, time = half_period, easing = SINE_EASING, loop = -1)						//down
		animate(pixel_y = old_y, time = quarter_period, easing = SINE_EASING | EASE_IN, loop = -1)			//back

/obj/item/uav/proc/stop_hover()
	if(ion_trail.on)
		ion_trail.stop()
		animate(src, pixel_y = old_y, time = 5, easing = SINE_EASING | EASE_IN) //halt animation

/obj/item/uav/hear_talk(var/mob/M, list/message_pieces, verb)
	var/name_used = M.GetVoice()
	for(var/wr_master in masters)
		var/weakref/wr = wr_master
		var/mob/master = wr.resolve()
		var/list/combined = master.combine_message(message_pieces, verb, M)
		var/message = combined["formatted"]
		var/rendered = "<i><span class='game say'>UAV received: <span class='name'>[name_used]</span> [message]</span></i>"
		master.show_message(rendered, 2)

/obj/item/uav/see_emote(var/mob/living/M, text)
	for(var/wr_master in masters)
		var/weakref/wr = wr_master
		var/mob/master = wr.resolve()
		var/rendered = "<i><span class='game say'>UAV received, <span class='message'>[text]</span></span></i>"
		master.show_message(rendered, 2)

/obj/item/uav/show_message(msg, type, alt, alt_type)
	for(var/wr_master in masters)
		var/weakref/wr = wr_master
		var/mob/master = wr.resolve()
		var/rendered = "<i><span class='game say'>UAV received, <span class='message'>[msg]</span></span></i>"
		master.show_message(rendered, type)

/obj/item/uav/take_damage(var/damage)
	health -= damage
	CheckHealth()
	return

/obj/item/uav/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	playsound(src, 'sound/weapons/smash.ogg', 50, 1)
	user.do_attack_animation(src)
	health -= damage
	CheckHealth()
	return

/obj/item/uav/ex_act(severity)
	switch(severity)
		if(1.0)
			die()
		if(2.0)
			health -= 25
			CheckHealth()

/obj/item/uav/proc/CheckHealth()
	if(health <= 0)
		die()

/obj/item/uav/proc/die()
	visible_message("<span class='danger'>[src] shorts out and explodes!</span>")
	power_down()
	var/turf/T = get_turf(src)
	qdel(src)
	explosion(T, -1, 0, 1, 2) //Not very large

#undef UAV_OFF
#undef UAV_ON
#undef UAV_PACKED