/datum/element/shovel_dig
	var/exhaust_probability = 80
	var/static/list/exhausted_digsites = list()

/datum/element/shovel_dig/Attach(atom/target)
	. = ..()
	if(!isturf(target))
		return ELEMENT_INCOMPATIBLE
	RegisterSignal(target, COMSIG_ATOM_ATTACKBY, PROC_REF(dig))

/datum/element/shovel_dig/Detach(atom/target)
	. = ..()
	exhausted_digsites -= REF(target)
	UnregisterSignal(target, COMSIG_ATOM_ATTACKBY)

/datum/element/shovel_dig/proc/dig(turf/source, obj/item/C, mob/user, click_parameters)
	SIGNAL_HANDLER

	if(!istype(C, /obj/item/shovel))
		return

	// I dislike this, but doafters don't have an alternative
	INVOKE_ASYNC(src, PROC_REF(process_dig), source, C, user, click_parameters)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/datum/element/shovel_dig/proc/process_dig(turf/source, obj/item/shovel/our_shovel, mob/user, click_parameters)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)

	// Grave digging
	if(our_shovel.grave_mode)
		if(length(source.contents))
			to_chat(user, span_warning("You can't dig here!"))
			return

		to_chat(user, span_notice("\The [user] begins digging into \the [source] with \the [our_shovel]."))
		var/delay = (5 SECONDS * our_shovel.toolspeed)
		user.setClickCooldown(delay)
		if(do_after(user, delay, target = source))
			new/obj/structure/closet/grave/dirthole(source)
			to_chat(user, span_notice("You dug up a hole!"))
		return

	// Loot and garden digging
	to_chat(user, span_notice("\The [user] begins digging into \the [source] with \the [our_shovel]."))
	var/delay = (3 SECONDS * our_shovel.toolspeed)
	user.setClickCooldown(delay)
	if(do_after(user, delay, target = source))
		if(!(locate(/obj/machinery/portable_atmospherics/hydroponics/soil) in source.contents))
			var/obj/machinery/portable_atmospherics/hydroponics/soil/soil = new(source)
			user.visible_message(span_notice("\The [source] digs \a [soil] into \the [source]."))
			return

		var/loot_type = !check_site_exhausted(source) ? source.get_dig_loot_type(user, our_shovel) : null
		if(!loot_type)
			to_chat(user, span_notice("You didn't find anything of note in \the [source]."))
			return

		var/obj/item/loot = new loot_type(source)
		to_chat(user, span_notice("You dug up \a [loot]!"))
		if(prob(exhaust_probability))
			exhaust_digsite(source)
	return

/datum/element/shovel_dig/proc/check_site_exhausted(turf/location)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	return (REF(location) in exhausted_digsites)

/datum/element/shovel_dig/proc/exhaust_digsite(turf/location)
	SHOULD_NOT_OVERRIDE(TRUE)
	PRIVATE_PROC(TRUE)
	exhausted_digsites[REF(location)] = TRUE
