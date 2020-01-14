/obj/effect/falling_effect
	name = "you should not see this"
	desc = "no data"
	invisibility = 101
	anchored = TRUE
	density = FALSE
	unacidable = TRUE
	var/falling_type = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita
	var/crushing = TRUE

/obj/effect/falling_effect/Initialize(mapload, type = /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita)
	..()
	falling_type = type
	return INITIALIZE_HINT_LATELOAD

/obj/effect/falling_effect/LateInitialize()
	new falling_type(src)
	var/atom/movable/dropped = pick(contents) // Stupid, but allows to get spawn result without efforts if it is other type(Or if it was randomly generated).
	dropped.loc = get_turf(src)
	var/initial_x = dropped.pixel_x
	var/initial_y = dropped.pixel_y
	dropped.plane = 1
	dropped.pixel_x = rand(-150, 150)
	dropped.pixel_y = 500 // When you think that pixel_z is height but you are wrong
	dropped.density = FALSE
	dropped.opacity = FALSE
	animate(dropped, pixel_y = initial_y, pixel_x = initial_x , time = 7)
	spawn(7)
		dropped.end_fall(crushing)
	qdel(src)

/atom/movable/proc/end_fall(var/crushing = FALSE)
	if(crushing)
		for(var/atom/movable/AM in loc)
			if(AM != src)
				AM.ex_act(1)

	for(var/mob/living/M in oviewers(3, src))
		shake_camera(M, 2, 2)

	playsound(loc, 'sound/effects/meteorimpact.ogg', 50, 1)
	density = initial(density)
	opacity = initial(opacity)
	plane = initial(plane)

/obj/effect/falling_effect/singularity_act()
	return

/obj/effect/falling_effect/singularity_pull()
	return

/obj/effect/falling_effect/ex_act()
	return


/obj/effect/falling_effect/pizza_delivery
	name = "PIZZA PIE POWER!"
	crushing = FALSE

/obj/effect/falling_effect/pizza_delivery/Initialize(mapload)
	..()
	falling_type = pick(prob(25);/obj/item/pizzabox/meat,
				prob(25);/obj/item/pizzabox/margherita,
				prob(25);/obj/item/pizzabox/vegetable,
				prob(25);/obj/item/pizzabox/mushroom)
	return INITIALIZE_HINT_LATELOAD
