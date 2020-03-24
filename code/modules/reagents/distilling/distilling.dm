
/*
 * Distillery, used for over-time temperature-based mixes.
 */

/obj/machinery/portable_atmospherics/powered/reagent_distillery
	name = "chemical distillery"
	desc = "A complex machine utilizing state-of-the-art components to mix chemicals at different temperatures."
	use_power = 1

	icon = 'icons/obj/machines/reagent.dmi'
	icon_state = "distiller"
	var/base_state	// The string var used in update icon for overlays, either set manually or initialized.

	power_rating = 3000
	power_losses = 240

	var/on = FALSE

	var/target_temp = T20C

	var/max_temp = T20C + 300
	var/min_temp = T0C - 10

	var/current_temp = T20C

	var/use_atmos = FALSE	// If true, this machine will be connectable to ports, and use gas mixtures as the source of heat, rather than its internal controls.

	var/static/radial_examine = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_examine")
	var/static/radial_use = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_use")

	var/static/radial_pump = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_pump")

	var/static/radial_eject_input = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_eject_input")
	var/static/radial_eject_output = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_eject_output")

	var/static/radial_adjust_temp = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_temp")

	var/static/radial_install_input = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_add")
	var/static/radial_install_output = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_add")

	var/static/radial_inspectgauges = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_lookat")

	var/static/radial_mix = image(icon = 'icons/mob/radial.dmi', icon_state = "radial_mix")

// Overlay holders so we don't have to constantly remake them.
	var/image/overlay_output_beaker
	var/image/overlay_input_beaker
	var/image/overlay_off
	var/image/overlay_ready
	var/image/overlay_cooling
	var/image/overlay_heating
	var/image/overlay_dumping
	var/image/overlay_connected

// Our unique beaker, used in its unique recipes to ensure things can only react inside this machine and minimize oddities from trying to transfer to a machine and back.
	var/obj/item/weapon/reagent_containers/glass/distilling/Reservoir

	var/obj/item/weapon/reagent_containers/glass/InputBeaker
	var/obj/item/weapon/reagent_containers/glass/OutputBeaker

// A multiplier for the production amount. This should really only ever be lower than one, otherwise you end up with duping.
	var/efficiency = 1

/obj/item/weapon/reagent_containers/glass/distilling
	name = "distilling chamber"
	desc = "You should not be seeing this."
	volume = 600

	var/obj/machinery/portable_atmospherics/powered/reagent_distillery/Master

/obj/item/weapon/reagent_containers/glass/distilling/Destroy()
	Master = null
	..()

/obj/machinery/portable_atmospherics/powered/reagent_distillery/Initialize()
	..()

	Reservoir = new (src)
	Reservoir.Master = src

	if(!base_state)
		base_state = icon_state

	setup_overlay_vars()

	update_icon()

/obj/machinery/portable_atmospherics/powered/reagent_distillery/proc/setup_overlay_vars()
	overlay_output_beaker = image(icon = src.icon, icon_state = "[base_state]-output")
	overlay_input_beaker = image(icon = src.icon, icon_state = "[base_state]-input")
	overlay_off = image(icon = src.icon, icon_state = "[base_state]-bad")
	overlay_ready = image(icon = src.icon, icon_state = "[base_state]-good")
	overlay_cooling = image(icon = src.icon, icon_state = "[base_state]-cool")
	overlay_heating = image(icon = src.icon, icon_state = "[base_state]-heat")
	overlay_dumping = image(icon = src.icon, icon_state = "[base_state]-dump")
	overlay_connected = image(icon = src.icon, icon_state = "[base_state]-connector")

/obj/machinery/portable_atmospherics/powered/reagent_distillery/Destroy()
	qdel(Reservoir)
	Reservoir = null
	if(InputBeaker)
		qdel(InputBeaker)
		InputBeaker = null
	if(OutputBeaker)
		qdel(OutputBeaker)
		OutputBeaker = null

	..()

/obj/machinery/portable_atmospherics/powered/reagent_distillery/attack_hand(mob/user)
	var/list/options = list()
	options["examine"] = radial_examine
	options["use"] = radial_use
	options["inspect gauges"] = radial_inspectgauges
	options["pulse agitator"] = radial_mix

	if(InputBeaker)
		options["eject input"] = radial_eject_input
	if(OutputBeaker)
		options["eject output"] = radial_eject_output

	if(!use_atmos)
		options["adjust temp"] = radial_adjust_temp

	if(length(options) < 1)
		return

	var/list/choice = list()
	if(length(options) == 1)
		for(var/key in options)
			choice = key
	else
		choice = show_radial_menu(user, src, options, require_near = !issilicon(user))

	switch(choice)
		if("examine")
			examine(user)

		if("use")
			if(powered())
				on = !on
				to_chat(user, "<span class='notice'>You turn \the [src] [on ? "on" : "off"].</span>")

		if("inspect gauges")
			to_chat(user, "<span class='notice'>\The [src]'s gauges read:</span>")
			if(!use_atmos)
				to_chat(user, "<span class='notice'>- Target Temperature:</span> <span class='warning'>[target_temp]</span>")
			to_chat(user, "<span class='notice'>- Temperature:</span> <span class='warning'>[current_temp]</span>")

		if("pulse agitator")
			to_chat(user, "<span class='notice'>You press \the [src]'s chamber agitator button.</span>")
			if(on)
				visible_message("<span class='notice'>\The [src] rattles to life.</span>")
				Reservoir.reagents.handle_reactions()
			else
				spawn(1 SECOND)
					to_chat(user, "<span class='notice'>Nothing happens..</span>")

		if("eject input")
			if(InputBeaker)
				InputBeaker.forceMove(get_turf(src))
				InputBeaker = null

		if("eject output")
			if(OutputBeaker)
				OutputBeaker.forceMove(get_turf(src))
				OutputBeaker = null

		if("adjust temp")
			target_temp = input("Choose a target temperature.", "Temperature.", T20C) as num
			target_temp = CLAMP(target_temp, min_temp, max_temp)

	update_icon()

/obj/machinery/portable_atmospherics/powered/reagent_distillery/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/list/options = list()
	if(istype(W, /obj/item/weapon/reagent_containers/glass))
		if(!InputBeaker)
			options["install input"] = radial_install_input
		if(!OutputBeaker)
			options["install output"] = radial_install_output

	if(!options || !options.len)
		update_icon()
		return ..()

	var/list/choice = list()
	if(length(options) == 1)
		for(var/key in options)
			choice = key
	else
		choice = show_radial_menu(user, src, options, require_near = TRUE) // No telekinetics.

	switch(choice)
		if("install input")
			if(!InputBeaker)
				user.drop_from_inventory(W)
				W.add_fingerprint(user)
				W.forceMove(src)
				InputBeaker = W

		if("install output")
			if(!OutputBeaker)
				user.drop_from_inventory(W)
				W.add_fingerprint(user)
				W.forceMove(src)
				OutputBeaker = W

	update_icon()

/obj/machinery/portable_atmospherics/powered/reagent_distillery/use_power(var/amount, var/chan = -1)
	last_power_draw = amount
	if(use_cell && cell && cell.charge)
		var/cellcharge = cell.charge
		cell.use(amount)

		var/celldifference = max(0, cellcharge - cell.charge)

		amount = celldifference

	var/area/A = get_area(src)
	if(!A || !isarea(A))
		return
	if(chan == -1)
		chan = power_channel
	A.use_power(amount, chan)

/obj/machinery/portable_atmospherics/powered/reagent_distillery/process()
	..()

	var/run_pump = FALSE

	if(InputBeaker || OutputBeaker)
		run_pump = TRUE

	var/avg_temp = 0
	var/avg_pressure = 0

	if(connected_port && connected_port.network.line_members.len)
		var/list/members = list()
		var/datum/pipe_network/Net = connected_port.network
		members = Net.line_members.Copy()

		for(var/datum/pipeline/Line in members)
			avg_pressure += Line.air.return_pressure()
			avg_temp += Line.air.temperature

		avg_temp /= members.len
		avg_pressure /= members.len

	if(!powered())
		on = FALSE

	if(!on || (use_atmos && (!connected_port || avg_pressure < 1000)))
		current_temp = round((current_temp + T20C) / 2)

	else if(on)
		if(!use_atmos)
			if(current_temp != round(target_temp))
				var/shift_mod = 0
				if(current_temp < target_temp)
					shift_mod = 1
				else if(current_temp > target_temp)
					shift_mod = -1
				current_temp = CLAMP(round((current_temp + 1 * shift_mod) + (rand(-5, 5) / 10)), min_temp, max_temp)
				use_power(power_rating * CELLRATE)
		else if(connected_port && avg_pressure > 1000)
			current_temp = round((current_temp + avg_temp) / 2)
		else if(!run_pump)
			visible_message("<span class='notice'>\The [src]'s motors wind down.</span>")
			on = FALSE

		if(InputBeaker && Reservoir.reagents.total_volume < Reservoir.reagents.maximum_volume)
			InputBeaker.reagents.trans_to_holder(Reservoir.reagents, amount = rand(10,20))

		if(OutputBeaker && OutputBeaker.reagents.total_volume < OutputBeaker.reagents.maximum_volume)
			use_power(power_rating * CELLRATE * 0.5)
			Reservoir.reagents.trans_to_holder(OutputBeaker.reagents, amount = rand(1, 5))

	update_icon()

/obj/machinery/portable_atmospherics/powered/reagent_distillery/update_icon()
	..()
	cut_overlays()

	if(InputBeaker)
		add_overlay(overlay_input_beaker)

	if(OutputBeaker)
		add_overlay(overlay_output_beaker)

	if(on)
		if(OutputBeaker && OutputBeaker.reagents.total_volume < OutputBeaker.reagents.maximum_volume)
			add_overlay(overlay_dumping)
		else if(current_temp == round(target_temp))
			add_overlay(overlay_ready)
		else if(current_temp < target_temp)
			add_overlay(overlay_heating)
		else
			add_overlay(overlay_cooling)

	else
		add_overlay(overlay_off)

	if(connected_port)
		add_overlay(overlay_connected)

/*
 * Subtypes
 */

/obj/machinery/portable_atmospherics/powered/reagent_distillery/industrial
	name = "industrial chemical distillery"
	desc = "A gas-operated variant of a chemical distillery. Able to reach much higher, and lower, temperatures through the use of treated gas."

	use_atmos = TRUE
