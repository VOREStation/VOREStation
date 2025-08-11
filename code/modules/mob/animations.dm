//handles up-down floaty effect in space and zero-gravity
/mob/var/is_floating = 0
/mob/var/floatiness = 0

/mob/proc/update_floating(var/dense_object=0)

	if(anchored||buckled)
		make_floating(0)
		return
	if(ishuman(src)) //VOREStation Edit Start. Floating code.
		var/mob/living/carbon/human/H = src
		if(H.flying)
			make_floating(1)
			return //VOREStation Edit End
	var/turf/turf = get_turf(src)
	if(!istype(turf,/turf/space))
		var/area/A = turf.loc
		if(istype(A) && A.get_gravity())
			make_floating(0)
			return
		else if (Check_Shoegrip())
			make_floating(0)
			return
		else
			make_floating(1)
			return

	if(dense_object && Check_Shoegrip())
		make_floating(0)
		return

	make_floating(1)
	return

/mob/proc/make_floating(var/n)
	if(buckled)
		if(is_floating)
			stop_floating()
		return
	floatiness = n

	if(floatiness && !is_floating)
		start_floating()
	else if(!floatiness && is_floating)
		stop_floating()

/mob/proc/start_floating()

	is_floating = 1

	var/amplitude = 2 //maximum displacement from original position
	var/period = 36 //time taken for the mob to go up >> down >> original position, in deciseconds. Should be multiple of 4

	var/top = old_y + amplitude
	var/bottom = old_y - amplitude
	var/half_period = period / 2
	var/quarter_period = period / 4

	animate(src, pixel_y = top, time = quarter_period, easing = SINE_EASING | EASE_OUT, loop = -1)		//up
	animate(pixel_y = bottom, time = half_period, easing = SINE_EASING, loop = -1)						//down
	animate(pixel_y = old_y, time = quarter_period, easing = SINE_EASING | EASE_IN, loop = -1)			//back

/mob/proc/stop_floating()
	animate(src, pixel_y = old_y, time = 5, easing = SINE_EASING | EASE_IN) //halt animation
	//reset the pixel offsets to zero
	is_floating = 0

/atom/movable/proc/fade_towards(atom/A,var/time = 2)
	set waitfor = FALSE

	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/pixel_z_diff = 0
	var/direction = get_dir(src, A)
	if(direction & NORTH)
		pixel_y_diff = 32
	else if(direction & SOUTH)
		pixel_y_diff = -32

	if(direction & EAST)
		pixel_x_diff = 32
	else if(direction & WEST)
		pixel_x_diff = -32

	if(!direction) // On top of?
		pixel_z_diff = -8

	var/default_pixel_x = initial(pixel_x)
	var/default_pixel_y = initial(pixel_y)
	var/default_pixel_z = initial(pixel_z)
	var/initial_alpha = alpha
	var/mob/mob = src
	if(istype(mob))
		default_pixel_x = mob.default_pixel_x
		default_pixel_y = mob.default_pixel_y

	animate(src, alpha = 0, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, pixel_z = pixel_z + pixel_z_diff, time = time)
	sleep(time+1) //So you can wait on this proc to finish if you want to time your next steps
	pixel_x = default_pixel_x
	pixel_y = default_pixel_y
	pixel_z = default_pixel_z
	alpha = initial_alpha

// Similar to attack animations, but in reverse and is longer to act as a telegraph.
/atom/movable/proc/do_windup_animation(atom/A, windup_time)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/direction = get_dir(src, A)
	if(direction & NORTH)
		pixel_y_diff = -8
	else if(direction & SOUTH)
		pixel_y_diff = 8

	if(direction & EAST)
		pixel_x_diff = -8
	else if(direction & WEST)
		pixel_x_diff = 8

	var/default_pixel_x = pixel_x
	var/default_pixel_y = pixel_y

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = windup_time - 2)
	animate(pixel_x = default_pixel_x, pixel_y = default_pixel_y, time = 2)


/atom/movable/proc/do_attack_animation(atom/A)
	var/pixel_x_diff = 0
	var/pixel_y_diff = 0
	var/direction = get_dir(src, A)
	if(direction & NORTH)
		pixel_y_diff = 8
	else if(direction & SOUTH)
		pixel_y_diff = -8

	if(direction & EAST)
		pixel_x_diff = 8
	else if(direction & WEST)
		pixel_x_diff = -8

	var/default_pixel_x = pixel_x
	var/default_pixel_y = pixel_y

	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff, time = 2)
	animate(pixel_x = default_pixel_x, pixel_y = default_pixel_y, time = 2)

/mob/living/do_attack_animation(atom/A, no_attack_icons = FALSE)
	..()
	if(no_attack_icons)
		return FALSE

	//Check for clients with pref enabled
	var/list/viewing = list()
	for(var/mob/M as anything in viewers(A))
		if(M.client?.prefs?.read_preference(/datum/preference/toggle/attack_icons))
			viewing += M.client

	//Animals attacking each other in the distance, probably. Forgeddaboutit.
	if(!viewing.len)
		return FALSE

	// What icon do we use for the attack?
	var/obj/used_item
	if(hand && l_hand) // Attacked with item in left hand.
		used_item = l_hand
	else if (!hand && r_hand) // Attacked with item in right hand.
		used_item = r_hand

	//Couldn't find an item, do they have a sprite specified (like animal claw stuff?)
	if(!used_item && !(attack_icon && attack_icon_state))
		return FALSE //Didn't find an item, not doing animation.

	// If we were without gravity, the bouncing animation got stopped, so we make sure we restart the bouncing after the next movement.
	is_floating = 0

	var/image/I

	if(used_item) //Found an in-hand item to animate
		I = image(used_item.icon, A, used_item.icon_state, A.layer + 1)
		//Color the icon
		I.color = used_item.color
		// Scale the icon.
		I.transform *= 0.75
	else //They had a hardcoded one specified
		I = image(attack_icon, A, attack_icon_state, A.layer + 1)
		I.dir = dir

	// Show the overlay to the clients
	flick_overlay(I, viewing, 5, TRUE) // 5 ticks/half a second

	// Set the direction of the icon animation.
	var/direction = get_dir(src, A)
	if(direction & NORTH)
		I.pixel_y = -16
	else if(direction & SOUTH)
		I.pixel_y = 16

	if(direction & EAST)
		I.pixel_x = -16
	else if(direction & WEST)
		I.pixel_x = 16

	if(!direction) // Attacked self?!
		I.pixel_z = 16

	// And animate the attack!
	animate(I, alpha = 175, pixel_x = 0, pixel_y = 0, pixel_z = 0, time = 3)
	update_icon()
	return TRUE //Found an item, doing item attack animation.

/mob/proc/spin(spintime, speed)
	if(!speed || speed < 1)		// Do NOT spin with infinite speed, it will break the reality
		return
	if(istype(buckled,/obj/structure/bed/chair/office)) // WEEEE!!!
		playsound(src, 'sound/effects/roll.ogg', 100, 1)
	spawn()
		var/D = dir
		while(spintime >= speed)
			sleep(speed)
			switch(D)
				if(NORTH)
					D = EAST
				if(SOUTH)
					D = WEST
				if(EAST)
					D = SOUTH
				if(WEST)
					D = NORTH
			set_dir(D)
			if(istype(buckled,/obj/structure/bed/chair/office))
				var/obj/structure/bed/chair/office/O = buckled
				O.dir = D
				O.set_dir(D)
			spintime -= speed
	return
