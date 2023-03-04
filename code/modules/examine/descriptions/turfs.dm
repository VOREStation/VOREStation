/turf/simulated/wall
	description_info = "You can build a wall by using metal sheets and making a girder, then adding more metal or plasteel."

/turf/simulated/wall/get_description_interaction()
	var/list/results = list()
	if(damage)
		results += "[desc_panel_image("welder")]to repair."

	if(isnull(construction_stage) || !reinf_material)
		results += "[desc_panel_image("welder")]to deconstruct if undamaged."
	else
		switch(construction_stage)
			if(6)
				results += "[desc_panel_image("wirecutters")]to begin deconstruction."
			if(5)
				results += list(
					"[desc_panel_image("screwdriver")]to continue deconstruction.",
					"[desc_panel_image("wirecutters")]to reverse deconstruction."
					)
			if(4)
				results += list(
					"[desc_panel_image("welder")]to continue deconstruction.",
					"[desc_panel_image("screwdriver")]to reverse deconstruction."
					)
			if(3)
				results += "[desc_panel_image("crowbar")]to continue deconstruction."
			if(2)
				results += "[desc_panel_image("wrench")]to continue deconstruction."
			if(1)
				results += "[desc_panel_image("welder")]to continue deconstruction."
			if(0)
				results += "[desc_panel_image("crowbar")]to finish deconstruction."
	return results

/turf/simulated/floor/get_description_info()
	. = ..()
	if(broken || burnt)
		. += "It is broken."

/turf/simulated/floor/get_description_interaction()
	. = ..()
	if (has_snow())
		. += "Use a shovel on it to get rid of the snow and reveal the ground beneath."
		. += "Use an empty hand on it to scoop up some snow, which you can use to make snowballs or snowmen."
	else if(broken || burnt)
		if(is_plating())
			. += "Use a welder on it to repair the damage."
		else
			. += "Use a crowbar on it to remove it."
	else if(flooring)
		if(flooring.flags & TURF_IS_FRAGILE)
			. += "You can use a crowbar on it to remove it, but this will destroy it!"
		else if(flooring.flags & TURF_REMOVE_CROWBAR)
			. += "Use a crowbar on it to remove it."
		if(flooring.flags & TURF_REMOVE_SCREWDRIVER)
			. += "Use a screwdriver on it to remove it."
		if(flooring.flags & TURF_REMOVE_WRENCH)
			. += "Use a wrench on it to remove it."
		if(flooring.flags & TURF_REMOVE_SHOVEL)
			. += "Use a shovel on it to remove it."

/turf/simulated/floor/outdoors/grass/get_description_interaction()
	. = "Use floor tiles on it to make a plating."  // using . = ..() would incorrectly say you can remove the grass with a shovel
	. += "Use a shovel on it to dig for worms."
