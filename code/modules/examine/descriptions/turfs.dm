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