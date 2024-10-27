/obj/machinery/portable_atmospherics/hydroponics/proc/setup_overlays()
	ov_lowhealth = image(icon = icon, icon_state = "over_lowhealth3")
	ov_lowhealth.plane = PLANE_LIGHTING_ABOVE
	ov_lowwater = image(icon = icon, icon_state = "over_lowwater3")
	ov_lowwater.plane = PLANE_LIGHTING_ABOVE
	ov_lownutri = image(icon = icon, icon_state = "over_lownutri3")
	ov_lownutri.plane = PLANE_LIGHTING_ABOVE
	ov_harvest = image(icon = icon, icon_state = "over_harvest3")
	ov_harvest.plane = PLANE_LIGHTING_ABOVE
	ov_frozen = image(icon = icon, icon_state = "over_frozen3")
	ov_frozen.plane = PLANE_LIGHTING_ABOVE
	ov_alert3 = image(icon = icon, icon_state = "over_alert3")
	ov_alert3.plane = PLANE_LIGHTING_ABOVE

//Refreshes the icon and sets the luminosity
/obj/machinery/portable_atmospherics/hydroponics/update_icon()
	// Update name.
	if(seed)
		if(mechanical)
			name = "[base_name] ([seed.seed_name])"
		else
			name = "[seed.seed_name]"
	else
		name = initial(name)

	if(labelled)
		name += " ([labelled])"

	cut_overlays()
	// Updates the plant overlay.
	if(!isnull(seed))

		if(mechanical && health <= (seed.get_trait(TRAIT_ENDURANCE) / 2))
			add_overlay(ov_lowhealth)

		if(dead)
			var/ikey = "[seed.get_trait(TRAIT_PLANT_ICON)]-dead"
			var/image/dead_overlay = SSplants.plant_icon_cache["[ikey]"]
			if(!dead_overlay)
				dead_overlay = image('icons/obj/hydroponics_growing.dmi', "[ikey]")
				dead_overlay.color = DEAD_PLANT_COLOUR
			add_overlay(dead_overlay)
		else
			if(!seed.growth_stages)
				seed.update_growth_stages()
			if(!seed.growth_stages)
				to_world(span_danger("Seed type [seed.get_trait(TRAIT_PLANT_ICON)] cannot find a growth stage value."))
				return
			var/overlay_stage = 1
			if(age >= seed.get_trait(TRAIT_MATURATION))
				overlay_stage = seed.growth_stages
			else
				var/maturation = seed.get_trait(TRAIT_MATURATION)/seed.growth_stages
				if(maturation < 1)
					maturation = 1
				overlay_stage = maturation ? max(1,round(age/maturation)) : 1
			var/ikey = "[seed.get_trait(TRAIT_PLANT_ICON)]-[overlay_stage]"
			var/image/plant_overlay = SSplants.plant_icon_cache["[ikey]-[seed.get_trait(TRAIT_PLANT_COLOUR)]"]
			if(frozen == 1)
				plant_overlay = image('icons/obj/hydroponics_growing.dmi', "[ikey]")
				plant_overlay.color = FROZEN_PLANT_COLOUR
			if(!plant_overlay)
				plant_overlay = image('icons/obj/hydroponics_growing.dmi', "[ikey]")
				plant_overlay.color = seed.get_trait(TRAIT_PLANT_COLOUR)
				SSplants.plant_icon_cache["[ikey]-[seed.get_trait(TRAIT_PLANT_COLOUR)]"] = plant_overlay
			add_overlay(plant_overlay)

			if(harvest && overlay_stage == seed.growth_stages)
				ikey = "[seed.get_trait(TRAIT_PRODUCT_ICON)]"
				var/image/harvest_overlay = SSplants.plant_icon_cache["product-[ikey]-[seed.get_trait(TRAIT_PLANT_COLOUR)]"]
				if(!harvest_overlay)
					harvest_overlay = image('icons/obj/hydroponics_products.dmi', "[ikey]")
					harvest_overlay.color = seed.get_trait(TRAIT_PRODUCT_COLOUR)
					SSplants.plant_icon_cache["product-[ikey]-[seed.get_trait(TRAIT_PRODUCT_COLOUR)]"] = harvest_overlay
				add_overlay(harvest_overlay)


	//Draw the cover.
	if(closed_system)
		add_overlay("hydrocover")

	//Updated the various alert icons.
	if(mechanical)
		if(waterlevel <= 10)
			add_overlay(ov_lowwater)
		if(nutrilevel <= 2)
			add_overlay(ov_lownutri)
		if(weedlevel >= 5 || pestlevel >= 5 || toxins >= 40)
			add_overlay(ov_alert3)
		if(harvest)
			add_overlay(ov_harvest)
		if(frozen)
			add_overlay(ov_frozen)

	// Update bioluminescence.
	if(seed)
		if(seed.get_trait(TRAIT_BIOLUM))
			var/clr
			if(seed.get_trait(TRAIT_BIOLUM_COLOUR))
				clr = seed.get_trait(TRAIT_BIOLUM_COLOUR)
			set_light(round(seed.get_trait(TRAIT_POTENCY)/10), l_color = clr)
			return

	set_light(0)
	return
