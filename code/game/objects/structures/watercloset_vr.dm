//Flushable toilets on station levels. Flushing sends stuff directly to a trashpit landmark without stinking up the cargo office.
//Only on-station toilets are affected and only if the trashpit landmark also exists. Otherwise toilets will stay normal.

/obj/structure/toilet
	var/teleplumbed = FALSE
	var/exit_landmark

/obj/structure/toilet/Initialize()
	if(z in global.using_map.map_levels)
		teleplumbed = TRUE
		exit_landmark = locate(/obj/effect/landmark/teleplumb_exit)
		if(teleplumbed && exit_landmark)
			desc = "The BS-500, a bluespace rift-rotation-based waste disposal unit for small matter. This one seems remarkably clean."
	return ..()

/obj/structure/toilet/attack_hand(mob/living/user as mob)
	if(open && teleplumbed && exit_landmark)
		var/list/bowl_contents = list()
		for(var/obj/item/I in loc.contents)
			if(istype(I) && !I.anchored)
				bowl_contents += I
		if(bowl_contents.len)
			user.visible_message("<span class='notice'>[user] flushes the toilet.</span>", "<span class='notice'>You flush the toilet.</span>")
			playsound(src, 'sound/vore/death7.ogg', 50, 1) //Got lazy about getting new sound files. Have a sick remix lmao.
			playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
			playsound(src, 'sound/mecha/powerup.ogg', 30, 1)
			for(var/obj/item/F in bowl_contents)
				F.forceMove(get_turf(exit_landmark))
				bowl_contents -= F
			return
	return ..()

/obj/structure/toilet/attack_ai(mob/user as mob)
	if(isrobot(user))
		if(user.client && user.client.eye == user)
			return attack_hand(user)
	else
		return attack_hand(user)

/obj/effect/landmark/teleplumb_exit
	name = "teleplumbing exit"
