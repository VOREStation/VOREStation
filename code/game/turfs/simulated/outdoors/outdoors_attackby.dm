/turf/simulated/floor/outdoors/attack_generic(mob/user)
	if(isanimal(user) && user.loc == src && user.a_intent == I_HELP)
		var/mob/living/simple_mob/animal/critter = user
		if(critter.burrower)
			if(locate(/obj/structure/animal_den) in contents)
				to_chat(critter, SPAN_WARNING("There is already a den here."))
				return TRUE
			critter.visible_message(SPAN_NOTICE("\The [critter] begins digging industriously."))
			critter.setClickCooldown(10 SECONDS)
			if(!do_after(critter, 10 SECONDS, src))
				return TRUE
			if(locate(/obj/structure/animal_den) in contents)
				to_chat(critter, SPAN_WARNING("There is already a den here."))
				return TRUE
			critter.visible_message(SPAN_NOTICE("\The [critter] finishes digging a den!"))
			new /obj/structure/animal_den(src)
			var/list/dug_up = list()
			while(loot_count)
				var/loot = get_loot_type()
				if(!ispath(loot))
					break
				loot_count--
				dug_up += new loot(src)
			if(length(dug_up))
				to_chat(critter, SPAN_NOTICE("You unearthed [english_list(dug_up)]!"))
			return TRUE
	. = ..()

/turf/simulated/floor/outdoors/attackby(obj/item/C, mob/user)

	if(can_dig && istype(C, /obj/item/shovel))
		to_chat(user, SPAN_NOTICE("\The [user] begins digging into \the [src] with \the [C]."))
		var/delay = (3 SECONDS * C.toolspeed)
		user.setClickCooldown(delay)
		if(do_after(user, delay, src))
			if(!(locate(/obj/machinery/portable_atmospherics/hydroponics/soil) in contents))
				var/obj/machinery/portable_atmospherics/hydroponics/soil/soil = new(src)
				user.visible_message(SPAN_NOTICE("\The [user] digs \a [soil] into \the [src]."))
			else
				var/loot_type = get_loot_type()
				if(loot_type)
					loot_count--
					var/obj/item/loot = new loot_type(src)
					to_chat(user, SPAN_NOTICE("You dug up \a [loot]!"))
				else
					to_chat(user, SPAN_NOTICE("You didn't find anything of note in \the [src]."))
		return TRUE

	if(istype(C, /obj/item/stack/tile/floor))
		var/obj/item/stack/stack = C
		stack.use(1)
		ChangeTurf(/turf/simulated/floor, preserve_outdoors = TRUE)
		return TRUE

	. = ..()
