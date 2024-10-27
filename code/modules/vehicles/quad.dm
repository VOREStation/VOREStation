
/obj/vehicle/train/engine/quadbike //It's a train engine, so it can tow trailers.
	name = "electric all terrain vehicle"
	desc = "A ridable electric ATV designed for all terrain. Except space."
	icon = 'icons/obj/vehicles_64x64.dmi'
	icon_state = "quad"
	on = 0
	powered = 1
	locked = 0

	load_item_visible = 1
	load_offset_x = 0
	mob_offset_y = 5

	pixel_x = -16
	speed_mod = 0.45
	car_limit = 1	//It gets a trailer. That's about it.
	active_engines = 1
	key_type = /obj/item/key/quadbike

	var/frame_state = "quad" //Custom-item proofing!
	var/paint_base = 'icons/obj/vehicles_64x64.dmi'
	var/custom_frame = FALSE
	var/datum/looping_sound/vehicle_engine/soundloop

	paint_color = "#ffffff"

	var/outdoors_speed_mod = 0.7 //The general 'outdoors' speed. I.E., the general difference you'll be at when driving outside.

/obj/vehicle/train/engine/quadbike/New()
	cell = new /obj/item/cell/high(src)
	key = new key_type(src)
	soundloop = new(list(src), FALSE)
	. = ..()
	turn_off()
	update_icon()

/obj/vehicle/train/engine/quadbike/built/New()
	key = new key_type(src)
	turn_off()

/obj/vehicle/train/engine/quadbike/random/New()
	paint_color = rgb(rand(1,255),rand(1,255),rand(1,255))
	..()

/obj/vehicle/train/engine/quadbike/Destroy()
	QDEL_NULL(soundloop)
	return ..()

/obj/item/key/quadbike
	name = "key"
	desc = "A keyring with a small steel key, and a blue fob reading \"ZOOM!\"."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "quad_keys"
	w_class = ITEMSIZE_TINY

/obj/vehicle/train/engine/quadbike/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..() //Move it move it, so we can test it test it.
	get_turf_speeds(old_loc)
	handle_vehicle_icon()

/obj/vehicle/train/engine/quadbike/proc/get_turf_speeds(atom/prev_loc)
	// Same speed if turf type doesn't change
	if(istype(loc, prev_loc.type) || istype(prev_loc, loc.type))
		return
	if(istype(loc, /turf/simulated/floor/water))
		speed_mod = outdoors_speed_mod * 4 //It kind of floats due to its tires, but it is slow.
	else if(istype(loc, /turf/simulated/floor/outdoors/rocks))
		speed_mod = initial(speed_mod) //Rocks are good, rocks are solid.
	else if(istype(loc, /turf/simulated/floor/outdoors/dirt) || istype(loc, /turf/simulated/floor/outdoors/grass) || istype(loc, /turf/simulated/floor/outdoors/newdirt) || istype(loc, /turf/simulated/floor/outdoors/newdirt_nograss))
		speed_mod = outdoors_speed_mod //Dirt and grass are the outdoors bench mark.
	else if(istype(loc, /turf/simulated/floor/outdoors/mud))
		speed_mod = outdoors_speed_mod * 1.5 //Gets us roughly 1. Mud may be fun, but it's not the best.
	else if(istype(loc, /turf/simulated/floor/outdoors/snow))
		speed_mod = outdoors_speed_mod * 1.7 //Roughly a 1.25. Snow is coarse and wet and gets everywhere, especially your electric motors.
	else
		speed_mod = initial(speed_mod)
	update_car(train_length, active_engines)

/obj/vehicle/train/engine/quadbike/proc/handle_vehicle_icon()
	switch(dir) //Due to being a Big Boy sprite, it has to have special pixel shifting to look 'normal' when being driven.
		if(1)
			pixel_y = -6
		if(2)
			pixel_y = -6
		if(4)
			pixel_y = 0
		if(8)
			pixel_y = 0

/obj/vehicle/train/engine/quadbike/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/multitool) && open)
		var/new_paint = input(usr, "Please select paint color.", "Paint Color", paint_color) as color|null
		if(new_paint)
			paint_color = new_paint
			update_icon()
			return
	..()

/obj/vehicle/train/engine/quadbike/update_icon()
	..()
	cut_overlays()
	if(custom_frame)
		var/image/Bodypaint = new(icon = 'icons/obj/custom_items_vehicle.dmi', icon_state = "[frame_state]_a", layer = src.layer)
		Bodypaint.color = paint_color
		add_overlay(Bodypaint)

		var/image/Overmob = new(icon = 'icons/obj/custom_items_vehicle.dmi', icon_state = "[frame_state]_overlay", layer = src.layer + 0.2) //over mobs
		var/image/Overmob_color = new(icon = 'icons/obj/custom_items_vehicle.dmi', icon_state = "[frame_state]_overlay_a", layer = src.layer + 0.2) //over the over mobs, gives the color.
		Overmob.plane = MOB_PLANE
		Overmob_color.plane = MOB_PLANE
		Overmob_color.color = paint_color

		add_overlay(Overmob)
		add_overlay(Overmob_color)
		return

	var/image/Bodypaint = new(icon = paint_base, icon_state = "[frame_state]_a", layer = src.layer)
	Bodypaint.color = paint_color
	add_overlay(Bodypaint)

	var/image/Overmob = new(icon = paint_base, icon_state = "[frame_state]_overlay", layer = src.layer + 0.2) //over mobs
	var/image/Overmob_color = new(icon = paint_base, icon_state = "[frame_state]_overlay_a", layer = src.layer + 0.2) //over the over mobs, gives the color.
	Overmob.plane = MOB_PLANE
	Overmob_color.plane = MOB_PLANE
	Overmob_color.color = paint_color

	add_overlay(Overmob)
	add_overlay(Overmob_color)

/obj/vehicle/train/engine/quadbike/Bump(atom/Obstacle)
	if(!istype(Obstacle, /atom/movable))
		return
	var/atom/movable/A = Obstacle

	if(!A.anchored)
		var/turf/T = get_step(A, dir)
		if(isturf(T))
			A.Move(T)	//bump things away when hit

	if(istype(A, /mob/living))
		var/mob/living/M = A
		visible_message(span_danger("[src] knocks over [M]!"))
		M.apply_effects(2, 2)				// Knock people down for a short moment
		M.apply_damages(8 / move_delay)		// Smaller amount of damage than a tug, since this will always be possible because Quads don't have safeties.
		var/list/throw_dirs = list(1, 2, 4, 8, 5, 6, 9, 10)
		if(!emagged)						// By the power of Bumpers TM, it won't throw them ahead of the quad's path unless it's emagged or the person turns.
			health -= round(M.mob_size / 2)
			throw_dirs -= dir
			throw_dirs -= get_dir(M, src) //Don't throw it AT the quad either.
		else
			health -= round(M.mob_size / 4) // Less damage if they actually put the point in to emag it.
		var/turf/T2 = get_step(A, pick(throw_dirs))
		M.throw_at(T2, 1, 1, src)
		if(istype(load, /mob/living/carbon/human))
			var/mob/living/D = load
			to_chat(D, span_danger("You hit [M]!"))
			add_attack_logs(D,M,"Ran over with [src.name]")


/obj/vehicle/train/engine/quadbike/RunOver(var/mob/living/M)
	..()
	var/list/throw_dirs = list(1, 2, 4, 8, 5, 6, 9, 10)
	if(!emagged)
		throw_dirs -= dir
		if(tow)
			throw_dirs -= get_dir(M, tow) //Don't throw it at the trailer either.
	var/turf/T = get_step(M, pick(throw_dirs))
	M.throw_at(T, 1, 1, src)

/obj/vehicle/train/engine/quadbike/turn_on()
	..()
	if(on)
		src.visible_message("\The [src] rumbles to life.", "You hear something rumble deeply.")
		soundloop.start()

/obj/vehicle/train/engine/quadbike/turn_off()
	if(on)
		src.visible_message("\The [src] putters before turning off.", "You hear something putter slowly.")
		soundloop.stop()
	..()

/*
 * Trailer bits and bobs.
 */

/obj/vehicle/train/trolley/trailer
	name = "all terrain trailer"
	icon = 'icons/obj/vehicles_64x64.dmi'
	icon_state = "quadtrailer"
	anchored = FALSE
	passenger_allowed = 1
	buckle_lying = 1
	locked = 0

	load_item_visible = 1
	load_offset_x = 0
	load_offset_y = 13
	mob_offset_y = 16

	pixel_x = -16

	paint_color = "#ffffff"

/obj/vehicle/train/trolley/trailer/random/New()
	paint_color = rgb(rand(1,255),rand(1,255),rand(1,255))
	..()

/obj/vehicle/train/trolley/trailer/proc/update_load()
	if(load)
		var/y_offset = load_offset_y
		if(istype(load, /mob/living))
			y_offset = mob_offset_y
		load.pixel_x = (initial(load.pixel_x) + 16 + load_offset_x + pixel_x) //Base location for the sprite, plus 16 to center it on the 'base' sprite of the trailer, plus the x shift of the trailer, then shift it by the same pixel_x as the trailer to track it.
		load.pixel_y = (initial(load.pixel_y) + y_offset + pixel_y) //Same as the above.
		return 1
	return 0

/obj/vehicle/train/trolley/trailer/New()
	..()
	update_icon()

/obj/vehicle/train/trolley/trailer/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()
	if(lead)
		switch(dir) //Due to being a Big Boy sprite, it has to have special pixel shifting to look 'normal'.
			if(1)
				pixel_y = -10
				pixel_x = -16
			if(2)
				pixel_y = 0
				pixel_x = -16
			if(4)
				pixel_y = 0
				pixel_x = -25
			if(8)
				pixel_y = 0
				pixel_x = -5
	else
		pixel_x = initial(pixel_x)
		pixel_y = initial(pixel_y)
	update_load()

/obj/vehicle/train/trolley/trailer/Bump(atom/Obstacle)
	if(!istype(Obstacle, /atom/movable))
		return
	var/atom/movable/A = Obstacle

	if(!A.anchored)
		var/turf/T = get_step(A, dir)
		if(isturf(T))
			A.Move(T)	//bump things away when hit

	if(istype(A, /mob/living))
		var/mob/living/M = A
		visible_message(span_danger("[src] knocks over [M]!"))
		M.apply_effects(1, 1)
		M.apply_damages(8 / move_delay)
		if(load)
			M.apply_damages(4/move_delay)
		var/list/throw_dirs = list(1, 2, 4, 8, 5, 6, 9, 10)
		if(!emagged)
			throw_dirs -= dir
		var/turf/T2 = get_step(A, pick(throw_dirs))
		M.throw_at(T2, 1, 1, src)
		if(istype(load, /mob/living/carbon/human))
			var/mob/living/D = load
			to_chat(D, span_danger("You hit [M]!"))
			add_attack_logs(D,M,"Ran over with [src.name]")

/obj/vehicle/train/trolley/trailer/update_icon()
	..()
	cut_overlays()

	var/image/Bodypaint = new(icon = 'icons/obj/vehicles_64x64.dmi', icon_state = "[initial(icon_state)]_a", layer = src.layer)
	Bodypaint.color = paint_color
	add_overlay(Bodypaint)

/obj/vehicle/train/trolley/trailer/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/multitool) && open)
		var/new_paint = input(usr, "Please select paint color.", "Paint Color", paint_color) as color|null
		if(new_paint)
			paint_color = new_paint
			update_icon()
			return
	..()
