/obj/item/bork_medigun
	name = "prototype bluespace medigun"
	desc = "The Bork BSM-92 or 'Blue Space Medigun' utilizes advanced bluespace technology to transfer beneficial reagents directly to torn tissue. This way, even larger wounds can be mended efficiently in short periods of time"
	icon = 'icons/obj/borkmedigun.dmi'
	icon_state = "medblaster"
	var/wielded_item_state = "medblaster-wielded"
	var/base_icon_state = "medblaster"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_medigun.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_medigun.dmi',
		)
	w_class = ITEMSIZE_HUGE
	force = 0
	var/beam_range = 3 // How many tiles away it can scan. Changing this also changes the box size.
	var/busy = MEDIGUN_IDLE // Set to true when scanning, to stop multiple scans.
	var/action_cancelled = FALSE
	var/wielded = FALSE
	var/mob/current_target
	var/mgcmo
	canremove = FALSE

/obj/item/bork_medigun/update_twohanding()
	var/mob/living/M = loc
	if(istype(M) && M.item_is_in_hands(src) && !M.hands_are_full())
		wielded = TRUE
		name = "[initial(name)] (wielded)"
	else
		wielded = FALSE
		name = initial(name)
	..()

/obj/item/bork_medigun/update_held_icon()
	if(wielded_item_state)
		var/mob/living/M = loc
		if(istype(M))
			if(M.can_wield_item(src) && src.is_held_twohanded(M))
				LAZYSET(item_state_slots, slot_l_hand_str, wielded_item_state)
				LAZYSET(item_state_slots, slot_r_hand_str, wielded_item_state)
			else
				LAZYSET(item_state_slots, slot_l_hand_str, initial(item_state))
				LAZYSET(item_state_slots, slot_r_hand_str, initial(item_state))
		..()

// Draws a box showing the limits of movement while scanning something.
// Only the client supplied will see the box.
/obj/item/bork_medigun/proc/draw_box(atom/A, box_size, client/C)
	var/list/our_box = list()
	// Things moved with pixel_[x|y] will move the box, so this is to correct that.
	var/pixel_x_correction = -A.pixel_x
	var/pixel_y_correction = -A.pixel_y

	var/our_icon_size = world.icon_size
	// First, place the bottom-left corner.
	our_box += draw_line(A, SOUTHWEST, (-box_size * our_icon_size) + pixel_x_correction, (-box_size * our_icon_size) + pixel_y_correction, C)

	var/rendered_size = (box_size * 2) - 1
	// Make a line on the bottom, going right.
	for(var/i = 1 to rendered_size)
		var/x_displacement = (-box_size * our_icon_size) + (our_icon_size * i) + pixel_x_correction
		var/y_displacement = (-box_size * our_icon_size) + pixel_y_correction
		our_box += draw_line(A, SOUTH, x_displacement, y_displacement, C)

	// Bottom-right corner.
	our_box += draw_line(A, SOUTHEAST, (box_size * our_icon_size) + pixel_x_correction, (-box_size * our_icon_size) + pixel_y_correction, C)

	// Second line, for the right side going up.
	for(var/i = 1 to rendered_size)
		var/x_displacement = (box_size * our_icon_size) + pixel_x_correction
		var/y_displacement = (-box_size * our_icon_size) + (our_icon_size * i) + pixel_y_correction
		our_box += draw_line(A, EAST, x_displacement, y_displacement, C)

	// Top-right corner.
	our_box += draw_line(A, NORTHEAST, (box_size * our_icon_size) + pixel_x_correction, (box_size * our_icon_size) + pixel_y_correction, C)

	// Third line, for the top, going right.
	for(var/i = 1 to rendered_size)
		var/x_displacement = (-box_size * our_icon_size) + (our_icon_size * i) + pixel_x_correction
		var/y_displacement = (box_size * our_icon_size) + pixel_y_correction
		our_box += draw_line(A, NORTH, x_displacement, y_displacement, C)

	// Top-left corner.
	our_box += draw_line(A, NORTHWEST, (-box_size * our_icon_size) + pixel_x_correction, (box_size * our_icon_size) + pixel_y_correction, C)

	// Fourth and last line, for the left side going up.
	for(var/i = 1 to rendered_size)
		var/x_displacement = (-box_size * our_icon_size) + pixel_x_correction
		var/y_displacement = (-box_size * our_icon_size) + (our_icon_size * i) + pixel_y_correction
		our_box += draw_line(A, WEST, x_displacement, y_displacement, C)
	return our_box

// Draws an individual segment of the box.
/obj/item/bork_medigun/proc/draw_line(atom/A, line_dir, line_pixel_x, line_pixel_y, client/C)
	var/image/line = image(icon = 'icons/effects/effects.dmi', loc = A, icon_state = "stripes", dir = line_dir)
	line.pixel_x = line_pixel_x
	line.pixel_y = line_pixel_y
	line.plane = PLANE_FULLSCREEN // It's technically a HUD element but it doesn't need to show above item slots.
	line.appearance_flags = RESET_TRANSFORM|RESET_COLOR|RESET_ALPHA|NO_CLIENT_COLOR|TILE_BOUND
	line.alpha = 125
	C.images += line
	return line

// Removes the box that was generated before from the client.
/obj/item/bork_medigun/proc/delete_box(list/box_segments, client/C)
	for(var/i in box_segments)
		C.images -= i
		qdel(i)

/obj/item/bork_medigun/proc/color_box(list/box_segments, new_color, new_time)
	for(var/i in box_segments)
		animate(i, color = new_color, time = new_time)

/obj/item/bork_medigun/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)// && loc != get_turf)
		return
	return ..()
