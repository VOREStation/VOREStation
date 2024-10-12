/obj/structure/bed/chair/e_chair
	name = "electric chair"
	desc = "Looks absolutely SHOCKING!"
	icon_state = "echair0"
	var/on = 0
	var/obj/item/assembly/shock_kit/part = null
	var/last_time = 1.0

/obj/structure/bed/chair/e_chair/Initialize()
	. = ..()
	add_overlay(image('icons/obj/objects.dmi', src, "echair_over", MOB_LAYER + 1, dir))
	return

/obj/structure/bed/chair/e_chair/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_WRENCH))
		var/obj/structure/bed/chair/C = new /obj/structure/bed/chair(loc)
		playsound(src, W.usesound, 50, 1)
		C.set_dir(dir)
		part.loc = loc
		part.master = null
		part = null
		qdel(src)
		return
	return

/obj/structure/bed/chair/e_chair/verb/toggle()
	set name = "Toggle Electric Chair"
	set category = "Object"
	set src in oview(1)

	if(on)
		on = 0
		icon_state = "echair0"
	else
		on = 1
		icon_state = "echair1"
	to_chat(usr, span_notice("You switch [on ? "on" : "off"] [src]."))
	return

/obj/structure/bed/chair/e_chair/rotate_clockwise()
	..()
	cut_overlays()
	add_overlay(image('icons/obj/objects.dmi', src, "echair_over", MOB_LAYER + 1, dir))	//there's probably a better way of handling this, but eh. -Pete
	return

/obj/structure/bed/chair/e_chair/proc/shock()
	if(!on)
		return
	if(last_time + 50 > world.time)
		return
	last_time = world.time

	// special power handling
	var/area/A = get_area(src)
	if(!isarea(A))
		return
	if(!A.powered(EQUIP))
		return
	A.use_power_oneoff(5000, EQUIP)
	var/light = A.power_light
	A.update_icon()

	flick("echair1", src)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(12, 1, src)
	s.start()
	if(has_buckled_mobs())
		for(var/mob/living/L as anything in buckled_mobs)
			L.burn_skin(85)
			to_chat(L, span_danger("You feel a deep shock course through your body!"))
			sleep(1)
			L.burn_skin(85)
			L.Stun(600)
	visible_message(span_danger("The electric chair went off!"), span_danger("You hear a deep sharp shock!"))

	A.power_light = light
	A.update_icon()
	return
