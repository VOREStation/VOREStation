/obj/structure/portal_event/resize
	name = "portal"
	desc = "It leads to someplace else!"
	icon = 'icons/obj/stationobjs_vr.dmi'
	icon_state = "type-d-portal"
	var/shrinking = TRUE
	var/size_limit = 0.5

/obj/structure/portal_event/resize/attack_ghost(var/mob/observer/dead/user)
	if(!target && user?.client?.holder)
		if(tgui_alert(user, "Would you like to adjust the portal's size settings?", "Change portal size settings", list("No","Yes")) == "Yes")
			var/our_message
			if(tgui_alert(user, "Should this portal shrink people who are over the limit, or grow people who are under the limit?", "Change portal size settings", list("Shrink","Grow")) == "Shrink")
				shrinking = TRUE
				our_message = "What should the size limit be? Anyone over this limit will be shrunk to this size. (1 = 100%, etc)"
			else
				shrinking = FALSE
				our_message = "What should the size limit be? Anyone under this limit will be grown to this size. (1 = 100%, etc)"

			size_limit = tgui_input_number(user, our_message, "Pick a Size", 1, round_value=FALSE)

	return ..()

/obj/structure/portal_event/resize/teleport(atom/movable/M as mob|obj)
	if(!isliving(M))
		return ..()
	var/mob/living/ourmob = M
	if(shrinking)
		if(ourmob.size_multiplier > size_limit)
			ourmob.resize(size_limit, FALSE, TRUE, TRUE)
	else
		if(ourmob.size_multiplier < size_limit)
			ourmob.resize(size_limit, FALSE, TRUE, TRUE)

	return ..()

/obj/structure/portal_event/resize/preset_shrink_twentyfive
	shrinking = TRUE
	size_limit = 0.25

/obj/structure/portal_event/resize/preset_shrink_fifty
	shrinking = TRUE
	size_limit = 0.5

/obj/structure/portal_event/resize/preset_shrink_hundred
	shrinking = TRUE
	size_limit = 1

/obj/structure/portal_event/resize/preset_grow_hundred
	shrinking = FALSE
	size_limit = 1

/obj/structure/portal_event/resize/preset_grow_twohundred
	shrinking = FALSE
	size_limit = 2

///// TIMER DOOR /////

/obj/structure/timer_door
	name = "door"
	desc = "It's a door with no apparent control mechanism! It opens on a timer!"
	icon = 'icons/obj/doors/Dooralien.dmi'
	icon_state = "door_locked"
	opacity = TRUE
	density = TRUE
	anchored = TRUE

	var/start_time
	var/time_til_open = 5 MINUTES

/obj/structure/timer_door/examine(mob/user, infix, suffix)
	. = ..()

	var/ourtime = (((start_time + time_til_open) - world.time) / 600)
	. += "<span class ='notice'>It will open in [ourtime] minutes!</span>"

/obj/structure/timer_door/Initialize()
	START_PROCESSING(SSobj, src)

	start_time = world.time

/obj/structure/timer_door/Destroy()
	STOP_PROCESSING(SSobj, src)
	visible_message("<span class = 'danger'>\The [src] opens up!</span>")
	playsound(src, 'sound/effects/bang.ogg', 75, 1)
	return ..()

/obj/structure/timer_door/process()
	if(start_time + time_til_open < world.time)
		qdel(src)

/obj/structure/timer_door/ten
	time_til_open = 10 MINUTES

/obj/structure/timer_door/fifteen
	time_til_open = 15 MINUTES

/obj/structure/timer_door/twenty
	time_til_open = 20 MINUTES
