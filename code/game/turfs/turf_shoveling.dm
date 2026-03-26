/turf/proc/handle_turf_dig(mob/user, obj/item/shovel/our_shovel)
	SHOULD_NOT_OVERRIDE(TRUE)

	// Grave digging
	if(our_shovel.grave_mode)
		if(length(contents))
			to_chat(user, span_warning("You can't dig here!"))
			return

		// Make a grave
		to_chat(user, span_notice("\The [user] begins digging into \the [src] with \the [our_shovel]."))
		var/delay = (5 SECONDS * our_shovel.toolspeed)
		user.setClickCooldown(delay)
		if(do_after(user, delay, target = src))
			if(!(locate(/obj/structure/closet/grave/dirthole) in contents))
				new /obj/structure/closet/grave/dirthole(src)
			to_chat(user, span_notice("You dug up a hole!"))
		return

	// Loot and garden digging
	to_chat(user, span_notice("\The [user] begins digging into \the [src] with \the [our_shovel]."))
	var/delay = (3 SECONDS * our_shovel.toolspeed)
	user.setClickCooldown(delay)
	if(do_after(user, delay, target = src))
		if(!(locate(/obj/machinery/portable_atmospherics/hydroponics/soil) in contents))
			var/obj/machinery/portable_atmospherics/hydroponics/soil/soil = new(src)
			user.visible_message(span_notice("\The [src] digs \a [soil] into \the [src]."))
			return

		// Spawn loot
		var/loot_type = (flags & TURF_CAN_DIG_SHOVEL) ? src.get_dig_loot_type(user, our_shovel) : null
		if(!loot_type)
			to_chat(user, span_notice("You didn't find anything of note in \the [src]."))
			return
		var/obj/item/loot = new loot_type(src)
		to_chat(user, span_notice("You dug up \a [loot]!"))

		// Clear the flag, the caller proc looks at the initial() flags of the turf to check if we can get here.
		// Effectively the current flag is used to check if we have exhausted the loot in the turf or not
		if(prob(80))
			flags ^= TURF_CAN_DIG_SHOVEL

/turf/proc/get_dig_loot_type(mob/user, obj/item/W)
	return null
