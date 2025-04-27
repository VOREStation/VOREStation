/obj/effect/falling_effect
	name = DEVELOPER_WARNING_NAME
	desc = "no data"
	invisibility = INVISIBILITY_ABSTRACT
	anchored = TRUE
	density = FALSE
	unacidable = TRUE
	var/falling_type = /obj/item/reagent_containers/food/snacks/sliceable/pizza/margherita
	var/crushing = TRUE

/obj/effect/falling_effect/Initialize(mapload, type, var/crushing_type)
	..()
	if(!isnull(crushing_type))
		crushing = crushing_type
	if(type)
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
	addtimer(CALLBACK(dropped, TYPE_PROC_REF(/atom/movable,end_fall), crushing), 0.7 SECONDS)
	qdel(src)

/atom/movable/proc/end_fall(var/crushing = FALSE)
	if(isliving(src))
		var/mob/living/L = src
		if(L.vore_selected && L.can_be_drop_pred && L.drop_vore)
			for(var/mob/living/P in loc)
				if(P.can_be_drop_prey && P.drop_vore)
					L.feed_grabbed_to_self_falling_nom(L,P)
					L.visible_message(span_vdanger("\The [L] falls right onto \the [P]!"))

	if(crushing)
		for(var/atom/movable/AM in loc)
			if(AM != src)
				AM.ex_act(1)

	for(var/mob/living/M in oviewers(3, src))
		shake_camera(M, 2, 2)

	playsound(src, 'sound/effects/meteorimpact.ogg', 50, 1)
	density = initial(density)
	opacity = initial(opacity)
	plane = initial(plane)

/obj/effect/falling_effect/singularity_act()
	return

/obj/effect/falling_effect/singularity_pull()
	return

/obj/effect/falling_effect/ex_act()
	return
