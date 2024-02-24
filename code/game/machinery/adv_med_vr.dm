/obj/machinery/bodyscanner
	icon = 'icons/obj/Cryogenic2_vr.dmi'
	icon_state = "scanner_open"

/obj/machinery/body_scanconsole
	icon = 'icons/obj/Cryogenic2_vr.dmi'
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
	if(stat & (NOPOWER|BROKEN))
		icon_state = "scanner_off"
		set_light(0)
	else
		var/h_ratio
		if(occupant)
			h_ratio = occupant.health / occupant.maxHealth
			switch(h_ratio)
				if(1.000)
					icon_state = "scanner_green"
					set_light(l_range = 1.5, l_power = 2, l_color = COLOR_LIME)
				if(0.001 to 0.999)
					icon_state = "scanner_yellow"
					set_light(l_range = 1.5, l_power = 2, l_color = COLOR_YELLOW)
				if(-0.999 to 0.000)
					icon_state = "scanner_red"
					set_light(l_range = 1.5, l_power = 2, l_color = COLOR_RED)
				else
					icon_state = "scanner_death"
					set_light(l_range = 1.5, l_power = 2, l_color = COLOR_RED)
		else
			icon_state = "scanner_open"
			set_light(0)
		if(console)
			console.update_icon(h_ratio)

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
