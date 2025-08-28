/obj/machinery/bunsen_burner
	name = "bunsen burner"
	desc = "A small, self-heating device designed for bringing chemical mixtures to a boil."
	description_info = "Place a beaker into it to begin heating. Reagents will be distilled over time as the mixture heats up. The bunsen burner is only capable of heating reagents up to 600c, and the atmoshere around it will affect what reactions are possible."
	icon = 'icons/obj/device.dmi'
	icon_state = "bunsen0"
	var/current_temp = T0C
	var/heating = FALSE
	var/obj/item/reagent_containers/held_container

/obj/machinery/bunsen_burner/Initialize(mapload)
	. = ..()
	create_reagents(1,/datum/reagents/distilling) //  resizes based on the boiling container

/obj/machinery/bunsen_burner/attackby(obj/item/W, mob/user)
	add_fingerprint(user)
	// Anchoring and disassembly
	if(default_unfasten_wrench(user, W))
		if(!anchored) // no longer anchored
			drop_held_container()
			if(heating)
				end_boil()
		return
	if(default_deconstruction_screwdriver(user, W))
		return
	if(W.has_tool_quality(TOOL_CROWBAR) && panel_open && isturf(loc))
		if(do_after(user,5 * W.toolspeed))
			// Breaking it down
			drop_held_container()
			to_chat(user, span_notice("You dissasemble \the [src]"))
			new /obj/item/stack/material/steel(get_turf(src), 1)
			qdel(src)
		return
	// Handle container
	if(!istype(W, /obj/item/reagent_containers))
		to_chat(user,span_notice("You can't put \the [W] onto \the [src]."))
		return
	if(!anchored)
		to_chat(user,span_notice("\The [src] must be secured down with a wrench."))
		return
	if(held_container)
		to_chat(user,span_notice("You must remove \the [held_container] before you can place another container on \the [src]."))
		return
	// A new hand touches the beacon
	user.drop_item(src)
	held_container = W
	held_container.forceMove(src)
	reagents.maximum_volume = held_container.reagents.maximum_volume // Update internal reagent distilling volume
	to_chat(user,span_notice("You put \the [held_container] onto \the [src]."))
	if(held_container.reagents.total_volume > 0)
		start_boiling()
	else
		update_icon()

/obj/machinery/bunsen_burner/attack_hand(mob/user as mob)
	if(..())
		return
	add_fingerprint(user)
	if(!held_container)
		to_chat(user,span_notice("There is nothing on \the [src]."))
		return

	// Take it off
	to_chat(user,span_notice("You remove \the [held_container] from \the [src]."))
	held_container.forceMove(get_turf(src))
	held_container.attack_hand(user) // Pick it up
	held_container = null

	// Removed beaker, so kill processing
	if(heating)
		end_boil()
		return
	update_icon()

/obj/machinery/bunsen_burner/proc/start_boiling()
	if(!held_container)
		return
	if(heating)
		return

	// Begin boiling
	visible_message(span_notice("\The [src] starts to heat \the [held_container]."))
	heating = TRUE
	update_icon()

	// Reset gas on start
	current_temp = T0C
	var/datum/gas_mixture/GM = return_air()
	if(GM)
		current_temp = GM.temperature

/obj/machinery/bunsen_burner/proc/drop_held_container()
	if(!held_container)
		return
	held_container.forceMove(get_turf(src))
	held_container = null

/obj/machinery/bunsen_burner/process()
	if(!heating)
		return

	if(held_container && !anchored)
		drop_held_container()
		end_boil()
		return

	if(!held_container?.reagents?.reagent_list?.len)
		end_boil()
		return

	// Increase temp
	var/previous_temp = current_temp
	current_temp += 15

	// Slosh and toss. We use an internal distilling container, react it in there, then pass it back.
	held_container.reagents.trans_to_obj(src,held_container.reagents.total_volume)
	if(reagents.handle_reactions())
		held_container.update_icon()
		update_icon()
	reagents.trans_to_obj(held_container,reagents.total_volume)

	// every 25 degree step, do a message to show we are working
	if(FLOOR(previous_temp / 40,1) != FLOOR(current_temp / 40,1))
		// Open flame
		var/turf/location = get_turf(src)
		if(isturf(location))
			location.hotspot_expose(1000,500,1)
		// Messages and temp limit
		if(current_temp < T0C + 50)
			visible_message(span_notice("\The [src] sloshes."))
		else if(current_temp <  T0C + 100)
			visible_message(span_notice("\The [src] hisses."))
		else if(current_temp <  T0C + 200)
			visible_message(span_notice("\The [src] boils."))
		else if(current_temp <  T0C + 400)
			visible_message(span_notice("\The [src] bubbles aggressively."))
		else if(current_temp <  T0C + 600)
			visible_message(span_notice("\The [src] rumbles intensely."))
		else
			// finished boiling
			end_boil()

/obj/machinery/bunsen_burner/proc/end_boil()
	heating = FALSE
	visible_message(span_notice("\The [src] clicks."))
	update_icon()

/obj/machinery/bunsen_burner/update_icon()
	cut_overlays()
	icon_state = "bunsen0"
	if(held_container)
		var/image/I = image("icon"=held_container)
		add_overlay(I)
	if(heating)
		var/image/I = image(icon,icon_state = "bunsen1",layer = layer+0.1)
		add_overlay(I)

/obj/machinery/bunsen_burner/examine(mob/user, infix, suffix)
	. = ..()
	if(heating)
		. += span_notice("It's current temperature is [current_temp - T0C]c")
