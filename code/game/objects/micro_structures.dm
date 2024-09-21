var/global/list/micro_tunnels = list()

/obj/structure/micro_tunnel
	name = "mouse hole"
	desc = "A tiny little hole... where does it go?"
	icon = 'icons/obj/structures/micro_structures.dmi'
	icon_state = "mouse_hole"

	anchored = TRUE
	density = FALSE

	var/magic = FALSE	//For events and stuff, if true, this tunnel will show up in the list regardless of whether it's in valid range, of if you're in a tunnel with this var, all tunnels of the same faction will show up redardless of range
	micro_target = TRUE

	var/static/non_micro_types = list(
		/mob/living/simple_mob/vore/squirrel,
		/mob/living/simple_mob/vore/alienanimals/catslug,
		/mob/living/simple_mob/vore/morph,
		/mob/living/simple_mob/protean_blob,
		/mob/living/simple_mob/slime
	)

/obj/structure/micro_tunnel/New()
	. = ..()
	micro_tunnels.Add(src)

/obj/structure/micro_tunnel/Initialize()
	. = ..()
	if(name == initial(name))
		var/area/our_area = get_area(src)
		name = "[our_area.name] [name]"
	if(pixel_x || pixel_y)
		return
	offset_tunnel()

/obj/structure/micro_tunnel/Destroy()
	visible_message("<span class = 'warning'>\The [src] collapses!</span>")
	for(var/mob/thing in src.contents)
		visible_message("<span class = 'warning'>\The [thing] tumbles out!</span>")
		thing.forceMove(get_turf(src.loc))
		thing.cancel_camera()

	micro_tunnels.Remove(src)

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

/obj/structure/micro_tunnel/proc/find_destinations()
	var/list/destinations = list()
	var/turf/myturf = get_turf(src.loc)
	var/datum/planet/planet
	for(var/datum/planet/P in SSplanets.planets)
		if(myturf.z in P.expected_z_levels)
			planet = P
		else
	for(var/obj/structure/micro_tunnel/t in micro_tunnels)
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
	return destinations

/obj/structure/micro_tunnel/attack_hand(mob/living/user)
	tunnel_interact(user)
	return ..()

/obj/structure/micro_tunnel/attack_generic(mob/user, damage, attack_verb)
	tunnel_interact(user)
	return ..()

/obj/structure/micro_tunnel/attack_robot(mob/living/user)
	var/turf/hole = get_turf(src)	//Borgs can click stuff from far away, let's make sure they're next to the hole
	var/turf/borg = get_turf(user)
	if(hole.AdjacentQuick(borg))
		tunnel_interact(user)
		return ..()

/obj/structure/micro_tunnel/proc/tunnel_interact(mob/living/user)
	if(!isliving(user))
		return
	if(user.loc == src)
		var/list/our_options = list("Exit", "Move")

		if(is_type_in_list(user, non_micro_types))
			if(src.contents.len > 1)
				our_options |= "Eat"

		our_options |= "Cancel"

		var/choice = tgui_alert(user,"It's dark and gloomy in here. What would you like to do?","Tunnel",our_options)
		switch(choice)
			if("Exit")
				if(user.loc != src)
					to_chat(user, "<span class = 'warning'>You can't do that unless you're in \the [src].</span>")
					return

				user.forceMove(get_turf(src.loc))
				user.cancel_camera()
				user.visible_message("<span class = 'notice'>\The [user] climbs out of \the [src]!</span>")
				return
			if("Move")
				if(user.loc != src)
					to_chat(user, "<span class = 'warning'>You can't do that unless you're in \the [src].</span>")
					return

				var/list/destinations = find_destinations()

				if(!destinations.len)
					to_chat(user, "<span class = 'warning'>There are no other tunnels connected to this one!</span>")
					return
				else if(destinations.len == 1)
					choice = pick(destinations)
				else
					choice = tgui_input_list(user, "Where would you like to go?", "Pick a tunnel", destinations)
				if(!choice)
					return
				to_chat(user,"<span class = 'notice'>You begin moving...</span>")
				if(!do_after(user, 10 SECONDS, exclusive = TRUE))
					return
				user.forceMove(choice)
				user.cancel_camera()
				var/obj/structure/micro_tunnel/da_oddawun = choice
				da_oddawun.tunnel_notify(user)
				return
			if("Eat")
				var/list/our_targets = list()
				for(var/mob/living/L in src.contents)
					if(L == user)
						continue
					our_targets |= L
				if(!our_targets.len)
					to_chat(user, "<span class = 'warning'>There is no one in here except for you!</span>")
					return
				var/mob/our_choice
				if(our_targets.len == 1)
					our_choice = pick(our_targets)
				else
					our_choice = tgui_input_list(user, "Who would you like to eat?", "Pick a target to eat", our_targets)
				if(user.loc != src)
					to_chat(user, "<span class = 'warning'>You are no longer inside \the [src], and so cannot eat \the [our_choice].</span>")
					return
				if(our_choice.loc != src)
					to_chat(user, "<span class = 'warning'>\The [our_choice] is no longer inside \the [src], and so cannot be eaten.</span>")
					return
				user.feed_grabbed_to_self(user,our_choice)
				return
			if("Cancel")
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
				if(!l.attempt_to_scoop(h))
					l.forceMove(get_turf(src.loc))
			else
				var/atom/movable/whatever = grabbed
				whatever.forceMove(get_turf(src.loc))

			user.visible_message("<span class = 'warning'>\The [user] pulls \the [grabbed] out of \the [src]! ! !</span>")
			return

		else if(isanimal(user))
			var/mob/living/simple_mob/a = user
			var/mob/living/l = grabbed
			if(!a.has_hands || isliving(grabbed))
				if(!l.attempt_to_scoop(a))
					l.forceMove(get_turf(src.loc))
			else
				var/atom/movable/whatever = grabbed
				whatever.forceMove(get_turf(src.loc))
			user.visible_message("<span class = 'warning'>\The [user] pulls \the [grabbed] out of \the [src]! ! !</span>")
			return

	user.visible_message("<span class = 'notice'>\The [user] begins climbing into \the [src]!</span>")
	if(!do_after(user, 10 SECONDS, exclusive = TRUE))
		to_chat(user, "<span class = 'warning'>You didn't go into \the [src]!</span>")
		return

	enter_tunnel(user)

/obj/structure/micro_tunnel/proc/can_enter(var/mob/living/user)
	if(user.mob_size <= MOB_TINY || user.get_effective_size(TRUE) <= micro_accepted_scale)
		return TRUE

	if(is_type_in_list(user, non_micro_types))
		if(tgui_alert(user, "Would you like to enter the tunnel, or reach inside it?", "Enter or reach", list("Enter","Reach")) == "Enter")
			return TRUE

	return FALSE

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
	k.cancel_camera()
	to_chat(k,"<span class = 'notice'>You are inside of \the [src]. It's dark and gloomy inside of here. You can click upon the tunnel to exit, or travel to another tunnel if there are other tunnels linked to it.</span>")
	tunnel_notify(k)

/obj/structure/micro_tunnel/proc/tunnel_notify(var/mob/living/user)
	to_chat(user, "<span class = 'notice'>You arrive inside \the [src].</span>")
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

/obj
	var/micro_accepted_scale = 0.5
	var/micro_target = FALSE

/obj/Initialize(mapload)
	. = ..()
	if(micro_target)
		verbs += /obj/proc/micro_interact

/obj/proc/micro_interact()
	set name = "Micro Interact"
	set desc = "Micros can enter, or move between objects with this! Non-micros can reach into objects to search for micros!"
	set category = "Object"
	set src in oview(1)

	if(!isliving(usr))
		return

	var/list/contained_mobs = list()
	for(var/mob/living/issamob in src.contents)
		if(isliving(issamob))
			contained_mobs |= issamob

	if(usr.loc == src)
		var/choice = tgui_alert(usr,"What would you like to do?","[src]",list("Exit", "Move", "Cancel"))
		switch(choice)
			if("Exit")
				if(usr.loc != src)
					to_chat(usr, "<span class = 'warning'>You can't do that unless you're in \the [src].</span>")
					return

				usr.forceMove(get_turf(src.loc))
				usr.cancel_camera()
				usr.visible_message("<span class = 'notice'>\The [usr] climbs out of \the [src]!</span>")
				return

			if("Move")
				if(usr.loc != src)
					to_chat(usr, "<span class = 'warning'>You can't do that unless you're in \the [src].</span>")
					return
				var/list/destinations = list()
				if(istype(src,/obj/structure/micro_tunnel))	//If we're in a tunnel let's also get the tunnel's destinations
					var/obj/structure/micro_tunnel/t = src
					destinations = t.find_destinations()
				var/turf/myturf = get_turf(src.loc)
				for(var/obj/o in range(1,myturf))
					if(!istype(o,/obj))
						continue
					if(o == src)
						continue
					if(o.micro_target)
						destinations |= o

				if(!destinations.len)
					to_chat(usr, "<span class = 'warning'>There is nowhere to move to!</span>")
					return
				else if(destinations.len == 1)
					choice = pick(destinations)
				else
					choice = tgui_input_list(usr, "Where would you like to go?", "Pick a destination", destinations)
				if(!choice)
					return
				to_chat(usr,"<span class = 'notice'>You begin moving...</span>")
				if(!do_after(usr, 10 SECONDS, exclusive = TRUE))
					return
				if(QDELETED(src))
					return
				if(usr.loc != src)
					return
				var/obj/our_choice = choice

				var/list/new_contained_mobs = list()
				for(var/mob/living/issamob in src.contents)
					if(isliving(issamob))
						contained_mobs |= issamob

				usr.forceMove(our_choice)
				usr.cancel_camera()

				to_chat(usr,"<span class = 'notice'>You are inside of \the [our_choice]. You can click upon the thing you are in to exit, or travel to a nearby thing if there are other tunnels linked to it.</span>")

				var/our_message = "You can see "
				var/found_stuff = FALSE
				for(var/thing in new_contained_mobs)
					if(thing == usr)
						continue
					found_stuff = TRUE
					our_message = "[our_message] [thing], "
					if(isliving(thing))
						var/mob/living/t = thing
						to_chat(t, "<span class = 'notice'>\The [usr] enters \the [src]!</span>")
				if(found_stuff)
					to_chat(usr, "<span class = 'notice'>[our_message]inside of \the [src]!</span>")
				if(prob(25))
					our_choice.visible_message("<span class = 'warning'>Something moves inside of \the [our_choice]. . .</span>")
				return
			if("Cancel")
				return

	if(!(usr.mob_size <= MOB_TINY || usr.get_effective_size(TRUE) <= micro_accepted_scale))
		usr.visible_message("<span class = 'warning'>\The [usr] reaches into \the [src]. . .</span>","<span class = 'warning'>You reach into \the [src]. . .</span>")
		if(!do_after(usr, 3 SECONDS, exclusive = TRUE))
			usr.visible_message("<span class = 'notice'>\The [usr] pulls their hand out of \the [src].</span>","<span class = 'warning'>You pull your hand out of \the [src]</span>")
			return

		if(!contained_mobs.len)
			to_chat(usr, "<span class = 'warning'>There was nothing inside.</span>")
			usr.visible_message("<span class = 'notice'>\The [usr] pulls their hand out of \the [src].</span>","<span class = 'warning'>You pull your hand out of \the [src]</span>")
			return
		var/grabbed = pick(contained_mobs)
		if(!grabbed)
			to_chat(usr, "<span class = 'warning'>There was nothing inside.</span>")
			usr.visible_message("<span class = 'notice'>\The [usr] pulls their hand out of \the [src].</span>","<span class = 'warning'>You pull your hand out of \the [src]</span>")
			return

		if(ishuman(usr))
			var/mob/living/carbon/human/h = usr
			var/mob/living/l = grabbed
			if(isliving(grabbed))
				l.attempt_to_scoop(h)
				if(!l.attempt_to_scoop(h))
					l.forceMove(get_turf(src.loc))
			else
				var/atom/movable/whatever = grabbed
				whatever.forceMove(get_turf(src.loc))

			usr.visible_message("<span class = 'warning'>\The [usr] pulls \the [grabbed] out of \the [src]! ! !</span>")
			return

		else if(isanimal(usr))
			var/mob/living/simple_mob/a = usr
			var/mob/living/l = grabbed
			if(!a.has_hands || isliving(grabbed))
				if(!l.attempt_to_scoop(a))
					l.forceMove(get_turf(src.loc))
			else
				var/atom/movable/whatever = grabbed
				whatever.forceMove(get_turf(src.loc))
			usr.visible_message("<span class = 'warning'>\The [usr] pulls \the [grabbed] out of \the [src]! ! !</span>")
			return

	usr.visible_message("<span class = 'notice'>\The [usr] begins climbing into \the [src]!</span>")
	if(!do_after(usr, 10 SECONDS, exclusive = TRUE))
		to_chat(usr, "<span class = 'warning'>You didn't go into \the [src]!</span>")
		return

	usr.visible_message("<span class = 'notice'>\The [usr] climbs into \the [src]!</span>")
	usr.forceMove(src)
	usr.cancel_camera()
	to_chat(usr,"<span class = 'notice'>You are inside of \the [src]. You can click upon the tunnel to exit, or travel to another tunnel if there are other tunnels linked to it.</span>")

	var/our_message = "You can see "
	var/found_stuff = FALSE
	for(var/thing in contained_mobs)
		if(thing == usr)
			continue
		found_stuff = TRUE
		our_message = "[our_message] [thing], "
		if(isliving(thing))
			var/mob/living/t = thing
			to_chat(t, "<span class = 'notice'>\The [usr] enters \the [src]!</span>")
	if(found_stuff)
		to_chat(usr, "<span class = 'notice'>[our_message]inside of \the [src]!</span>")
	if(prob(25))
		visible_message("<span class = 'warning'>Something moves inside of \the [src]. . .</span>")

/obj/effect/mouse_hole_spawner
	name = "mouse hole spawner"
	icon = 'icons/obj/landmark_vr.dmi'
	icon_state = "blue-x"
	invisibility = 101

	var/chance_to_spawn = 25

/obj/effect/mouse_hole_spawner/Initialize()
	. = ..()

	if(prob(chance_to_spawn))
		var/obj/structure/micro_tunnel/tunnel = new (get_turf(src.loc))
		tunnel.set_dir(dir)

	qdel(src)
