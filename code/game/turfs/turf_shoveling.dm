/turf/proc/handle_turf_dig(mob/user, obj/item/shovel/our_shovel)
	SHOULD_NOT_OVERRIDE(TRUE)

	// Grave digging
	if(our_shovel.grave_mode)
		shovel_dig_grave(user, our_shovel)
		return

	// Loot and garden digging
	to_chat(user, span_notice("\The [user] begins digging into \the [src] with \the [our_shovel]."))
	var/delay = (3 SECONDS * our_shovel.toolspeed)
	user.setClickCooldown(delay)
	if(do_after(user, delay, target = src))
		if(shovel_can_cultivate() && !(locate(/obj/machinery/portable_atmospherics/hydroponics/soil) in contents))
			var/obj/machinery/portable_atmospherics/hydroponics/soil/soil = new(src)
			user.visible_message(span_notice("\The [src] digs \a [soil] into \the [src]."))
			return

		// Spawn loot
		if(!(flags & TURF_CAN_DIG_SHOVEL))
			to_chat(user, span_warning("There is nothing more to be found in \the [src]."))
			return
		var/loot_type = get_dig_loot_type(user, our_shovel)
		if(!loot_type)
			to_chat(user, span_notice("You didn't find anything of note in \the [src]."))
			return
		var/obj/item/loot = new loot_type(src)
		to_chat(user, span_notice("You dug up \a [loot]!"))

		// Clear the flag, the caller proc looks at the initial() flags of the turf to check if we can get here.
		// Effectively the current flag is used to check if we have exhausted the loot in the turf or not
		if(prob(60))
			flags ^= TURF_CAN_DIG_SHOVEL

/turf/proc/shovel_dig_grave(mob/user, obj/item/shovel/our_shovel)
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

/// If a turf has any loot when dug with a shovel
/turf/proc/get_dig_loot_type(mob/user, obj/item/W)
	return null

/// If a turf supports making growbeds
/turf/proc/shovel_can_cultivate()
	return FALSE
