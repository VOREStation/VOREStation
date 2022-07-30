/obj/effect/vfx/foam/firefighting
	name = "firefighting foam"
	icon_state = "mfoam" //Whiter
	color = "#A6FAFF"
	var/lifetime = 3
	dries = FALSE // We do this ourselves
	slips = FALSE

/obj/effect/vfx/foam/firefighting/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/vfx/foam/firefighting/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/vfx/foam/firefighting/process()
	if(lifetime-- <= 0)
		flick("[icon_state]-disolve", src)
		QDEL_IN(src, 5)
