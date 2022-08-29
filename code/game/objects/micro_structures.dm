/obj/structure/micro_tunnel
	name = "mouse hole"
	desc = "A tiny little hole... where does it go?"
	icon = 'icons/obj/structures/micro_structures.dmi'
	icon_state = "mouse_hole"

	anchored = TRUE
	density = FALSE

	var/max_accepted_scale = 0.3
	var/magic = FALSE	//For events and stuff, if true, this tunnel will show up in the list regardless of whether it's in valid range, of if you're in a tunnel with this var, all tunnels of the same faction will show up redardless of range

/obj/structure/micro_tunnel/Initialize()
	. = ..()
	if(name == "mouse hole")
		var/area/our_area = get_area(src)
		name = "[our_area.name] mouse hole"
	if(pixel_x || pixel_y)
		return
	offset_tunnel()

/obj/structure/micro_tunnel/Destroy()
	visible_message("<span class = 'warning'>\The [src] collapses!</span>")
	for(var/mob/thing in src.contents)
		visible_message("<span class = 'warning'>\The [thing] tumbles out!</span>")
		thing.forceMove(get_turf(src.loc))

	return ..()

/obj/structure/micro_tunnel/set_dir(new_dir)
	. = ..()
	offset_tunnel()

/obj/structure/micro_tunnel/proc/offset_tunnel()

	pixel_x = 0
	pixel_y = 0

	switch(dir)
		if(1)
			pixel_y = 32
		if(2)
			pixel_y = -32
		if(4)
			pixel_x = 32
		if(8)
			pixel_x = -32

/obj/structure/micro_tunnel/attack_hand(mob/user)
	if(!isliving(user))
		return ..()
	if(user.loc == src)
		var/choice = tgui_alert(user,"It's dark and gloomy in here. What would you like to do?","Tunnel",list("Exit", "Move"))
		switch(choice)
			if("Exit")
				user.forceMove(get_turf(src.loc))
				user.visible_message("<span class = 'notice'>\The [user] climbs out of \the [src]!</span>")
				return
			if("Move")
				var/list/destinations = list()
				var/turf/myturf = get_turf(src.loc)
				var/datum/planet/planet
				for(var/datum/planet/P in SSplanets.planets)
					if(myturf.z in P.expected_z_levels)
						planet = P
					else
				for(var/obj/structure/micro_tunnel/t in world)
					if(t == src)
						continue
					if(magic || t.magic)
						destinations |= t
						continue
					if(t.z == z)
						destinations |= t
						continue
					var/turf/targetturf = get_turf(t.loc)
					if(planet)
						if(targetturf.z in planet.expected_z_levels)
							destinations |= t
							continue
						else
					var/above = GetAbove(myturf)
					if(above && t.z == z + 1)
						destinations |= t
						continue
					var/below = GetBelow(myturf)
					if(below && t.z == z - 1)
						destinations |= t

				if(!destinations.len)
					to_chat(user, "<span class = 'warning'>There are no other tunnels connected to this one!</span>")
					return
				choice = tgui_input_list(user, "Where would you like to go?", "Pick a tunnel", destinations)
				if(!choice)
					return
				to_chat(user,"<span class = 'notice'>You begin moving...</span>")
				if(!do_after(user, 10 SECONDS, exclusive = TRUE))
					return
				user.forceMove(choice)
				var/obj/structure/micro_tunnel/da_oddawun = choice
				da_oddawun.tunnel_notify(user)
				return

	if(!can_enter(user))
		user.visible_message("<span class = 'warning'>\The [user] reaches into \the [src]. . .</span>","<span class = 'warning'>You reach into \the [src]. . .</span>")
		if(!do_after(user, 3 SECONDS, exclusive = TRUE))
			user.visible_message("<span class = 'notice'>\The [user] pulls their hand out of \the [src].</span>","<span class = 'warning'>You pull your hand out of \the [src]</span>")
			return
		if(!src.contents.len)
			to_chat(user, "<span class = 'warning'>There was nothing inside.</span>")
			user.visible_message("<span class = 'notice'>\The [user] pulls their hand out of \the [src].</span>","<span class = 'warning'>You pull your hand out of \the [src]</span>")
			return
		var/grabbed = pick(src.contents)
		if(!grabbed)
			to_chat(user, "<span class = 'warning'>There was nothing inside.</span>")
			user.visible_message("<span class = 'notice'>\The [user] pulls their hand out of \the [src].</span>","<span class = 'warning'>You pull your hand out of \the [src]</span>")
			return

		if(ishuman(user))
			var/mob/living/carbon/human/h = user
			var/mob/living/l = grabbed
			if(isliving(grabbed))
				l.attempt_to_scoop(h)
			else
				var/atom/movable/whatever = grabbed
				whatever.forceMove(get_turf(src.loc))

			user.visible_message("<span class = 'warning'>\The [user] pulls \the [grabbed] out of \the [src]! ! !</span>")
			return

		else if(isanimal(user))
			var/mob/living/simple_mob/a = user
			var/mob/living/l = grabbed
			if(!a.has_hands || isliving(grabbed))
				l.attempt_to_scoop(user)
			else
				var/atom/movable/whatever = grabbed
				whatever.forceMove(get_turf(src.loc))
			user.visible_message("<span class = 'warning'>\The [user] pulls \the [grabbed] out of \the [src]! ! !</span>")
			return

	if(tgui_alert(user,"Do you want to go into the tunnel?","Enter Tunnel",list("Yes", "No")) != "Yes")
		return
	user.visible_message("<span class = 'notice'>\The [user] begins climbing into \the [src]!</span>")
	if(!do_after(user, 10 SECONDS, exclusive = TRUE))
		to_chat(user, "<span class = 'warning'>You didn't go into \the [src]!</span>")
		return

	enter_tunnel(user)

/obj/structure/micro_tunnel/proc/can_enter(var/mob/living/user)
	if(user.mob_size <= MOB_TINY || user.size_multiplier <= max_accepted_scale)
		return TRUE

	return FALSE

/obj/structure/micro_tunnel/attack_generic(mob/user, damage, attack_verb)
	attack_hand(user)
	return ..()

/obj/structure/micro_tunnel/MouseDrop_T(mob/living/M, mob/living/user)
	. = ..()
	if(M != user)
		return

	if(!can_enter(user))
		return

	var/mob/living/k = M

	k.visible_message("<span class = 'notice'>\The [k] begins climbing into \the [src]!</span>")
	if(!do_after(k, 3 SECONDS, exclusive = TRUE))
		to_chat(k, "<span class = 'warning'>You didn't go into \the [src]!</span>")
		return

	enter_tunnel(k)

/obj/structure/micro_tunnel/proc/enter_tunnel(mob/living/k)
	k.visible_message("<span class = 'notice'>\The [k] climbs into \the [src]!</span>")
	k.forceMove(src)
	to_chat(k,"<span class = 'notice'>You are inside of \the [src]. It's dark and gloomy inside of here. You can click upon the tunnel to exit, or travel to another tunnel if there are other tunnels linked to it.</span>")
	tunnel_notify(k)

/obj/structure/micro_tunnel/proc/tunnel_notify(var/mob/living/user)
	var/our_message = "You can see "
	var/found_stuff = FALSE
	for(var/thing in src.contents)
		if(thing == user)
			continue
		found_stuff = TRUE
		our_message = "[our_message] [thing], "
		if(isliving(thing))
			var/mob/living/t = thing
			to_chat(t, "<span class = 'notice'>\The [user] enters \the [src]!</span>")
	if(found_stuff)
		to_chat(user, "<span class = 'notice'>[our_message]inside of \the [src]!</span>")
	if(prob(25))
		visible_message("<span class = 'warning'>Something moves inside of \the [src]. . .</span>")

/obj/structure/micro_tunnel/magic
	magic = TRUE
