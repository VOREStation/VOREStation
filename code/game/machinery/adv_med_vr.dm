/obj/machinery/bodyscanner
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner_open"

/obj/machinery/body_scanconsole
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "scanner_terminal_off"
	density = TRUE

/obj/machinery/bodyscanner/proc/get_occupant_data_vr(list/incoming, mob/living/carbon/human/H)
	var/humanprey = 0
	var/livingprey = 0
	var/objectprey = 0

	for(var/obj/belly/B as anything in H.vore_organs)
		for(var/C in B)
			if(ishuman(C))
				humanprey++
			else if(isliving(C))
				livingprey++
			else
				objectprey++

	incoming["livingPrey"] = livingprey
	incoming["humanPrey"] = humanprey
	incoming["objectPrey"] = objectprey
	incoming["weight"] = H.weight

	return incoming

/obj/machinery/bodyscanner/update_icon()
	cut_overlays()

	if(!occupant)
		icon_state = "scanner_open"
		set_light(0)
		if(console)
			console.update_icon(0)
		return

	// base image
	icon_state = "new_scanner_off"

	// Determine gradient state
	var/state
	var/scan = TRUE
	var/h_ratio = occupant.health / occupant.getMaxHealth()
	if(console)
		console.update_icon(h_ratio)

	if(stat & (NOPOWER|BROKEN))
		state = "gradient_gray"
		scan = FALSE
		set_light(0)
	else
		switch(h_ratio)
			if(1.000)
				state = "gradient_green"
				set_light(l_range = 1.5, l_power = 2, l_color = COLOR_LIME)
			if(0.001 to 0.999)
				state = "gradient_yellow"
				set_light(l_range = 1.5, l_power = 2, l_color = COLOR_YELLOW)
			else
				state = "gradient_red"
				set_light(l_range = 1.5, l_power = 2, l_color = COLOR_RED)

	// First, we render the occupant
	var/image/occ = image(occupant)
	occ.dir = SOUTH
	var/matrix/M = matrix()
	M.Turn(dir == EAST ? 90 : -90)
	occ.transform = M
	occ.plane = plane
	occ.layer = layer + 0.1
	occ.filters = list(
		filter("type" = "alpha", "icon" = icon(icon, "alpha_mask", dir = dir == EAST ? EAST : WEST)),
		filter("type" = "color", "color" = "#000000")
	)
	add_overlay(occ)

	if(scan)
		// Second, we render the scan beam
		var/image/scan_beam = image(icon(icon, "scan_beam"))
		scan_beam.plane = plane
		scan_beam.layer = layer + 0.2
		add_overlay(scan_beam)

	if(state)
		// Third, we tint everything
		var/image/gradient = image(icon(icon, state))
		gradient.plane = plane
		gradient.layer = layer + 0.3
		add_overlay(gradient)


/obj/machinery/body_scanconsole/update_icon(var/h_ratio)
	if(stat & (NOPOWER|BROKEN))
		icon_state = "scanner_terminal_off"
		set_light(0)
	else
		if(scanner)
			if(h_ratio)
				switch(h_ratio)
					if(1.000)
						icon_state = "scanner_terminal_green"
						set_light(l_range = 1.5, l_power = 2, l_color = COLOR_LIME)
					if(-0.999 to 0.000)
						icon_state = "scanner_terminal_red"
						set_light(l_range = 1.5, l_power = 2, l_color = COLOR_RED)
					else
						icon_state = "scanner_terminal_dead"
						set_light(l_range = 1.5, l_power = 2, l_color = COLOR_RED)
			else
				icon_state = "scanner_terminal_blue"
				set_light(l_range = 1.5, l_power = 2, l_color = COLOR_BLUE)
		else
			icon_state = "scanner_terminal_off"
			set_light(0)
