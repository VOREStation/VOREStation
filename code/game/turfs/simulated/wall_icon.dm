/turf/simulated/wall/proc/update_material()

	if(!material)
		return

	if(reinf_material)
		construction_stage = 6
	else
		construction_stage = null
	if(!material)
		material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	if(material)
		explosion_resistance = material.explosion_resistance
	if(reinf_material && reinf_material.explosion_resistance > explosion_resistance)
		explosion_resistance = reinf_material.explosion_resistance

	if(reinf_material)
		name = "reinforced [material.display_name] wall"
		desc = "It seems to be a section of wall reinforced with [reinf_material.display_name] and plated with [material.display_name]."
	else
		name = "[material.display_name] wall"
		desc = "It seems to be a section of wall plated with [material.display_name]."

	if(material.opacity > 0.5 && !opacity)
		set_light(1)
	else if(material.opacity < 0.5 && opacity)
		set_light(0)

	SSradiation.resistance_cache.Remove(src)
	update_connections(1)
	update_icon()


/turf/simulated/wall/proc/set_material(var/datum/material/newmaterial, var/datum/material/newrmaterial, var/datum/material/newgmaterial)
	material = newmaterial
	reinf_material = newrmaterial
	if(!newgmaterial)
		girder_material = DEFAULT_WALL_MATERIAL
	else
		girder_material = newgmaterial
	update_material()

/turf/simulated/wall/update_icon()
	if(!material)
		return

	if(!damage_overlays[1]) //list hasn't been populated
		generate_overlays()

	cut_overlays()
	var/image/I

	if(!density)
		I = image(wall_masks, "[material.icon_base]fwall_open")
		I.color = material.icon_colour
		add_overlay(I)
		return

	for(var/i = 1 to 4)
		I = image(wall_masks, "[material.icon_base][wall_connections[i]]", dir = 1<<(i-1))
		I.color = material.icon_colour
		add_overlay(I)

	if(reinf_material)
		if(construction_stage != null && construction_stage < 6)
			I = image(wall_masks, "reinf_construct-[construction_stage]")
			I.color = reinf_material.icon_colour
			add_overlay(I)
		else
			if("[reinf_material.icon_reinf]0" in cached_icon_states(wall_masks))
				// Directional icon
				for(var/i = 1 to 4)
					I = image(wall_masks, "[reinf_material.icon_reinf][wall_connections[i]]", dir = 1<<(i-1))
					I.color = reinf_material.icon_colour
					add_overlay(I)
			else if("[reinf_material.icon_reinf]" in cached_icon_states(wall_masks))
				I = image(wall_masks, reinf_material.icon_reinf)
				I.color = reinf_material.icon_colour
				add_overlay(I)
	var/image/texture = material.get_wall_texture()
	if(texture)
		add_overlay(texture)

	if(damage != 0)
		var/integrity = material.integrity
		if(reinf_material)
			integrity += reinf_material.integrity

		var/overlay = round(damage / integrity * damage_overlays.len) + 1
		if(overlay > damage_overlays.len)
			overlay = damage_overlays.len

		add_overlay(damage_overlays[overlay])
	return

/turf/simulated/wall/proc/generate_overlays()
	var/alpha_inc = 256 / damage_overlays.len

	for(var/i = 1; i <= damage_overlays.len; i++)
		var/image/img = image(icon = 'icons/turf/walls.dmi', icon_state = "overlay_damage")
		img.blend_mode = BLEND_MULTIPLY
		img.alpha = (i * alpha_inc) - 1
		damage_overlays[i] = img


/turf/simulated/wall/proc/update_connections(propagate = 0)
	if(!material)
		return
	var/list/dirs = list()
	var/inrange = orange(src, 1)
	for(var/turf/simulated/wall/W in inrange)
		if(!W.material)
			continue
		if(propagate)
			W.update_connections()
			W.update_icon()
		if(can_join_with_wall(W))
			dirs += get_dir(src, W)
	for(var/obj/structure/low_wall/WF in inrange)
		if(can_join_with_low_wall(WF))
			dirs += get_dir(src, WF)

	special_wall_connections(dirs, inrange)
	wall_connections = dirs_to_corner_states(dirs)

/turf/simulated/wall/proc/special_wall_connections(list/dirs, list/inrange)
	if(material.icon_base == "hull") // Could be improved...
		var/additional_dirs = 0
		for(var/direction in alldirs)
			var/turf/T = get_step(src,direction)
			if(T && (locate(/obj/structure/hull_corner) in T))
				dirs += direction
				additional_dirs |= direction
		if(additional_dirs)
			for(var/diag_dir in cornerdirs)
				if ((additional_dirs & diag_dir) == diag_dir)
					dirs += diag_dir

/turf/simulated/wall/proc/can_join_with_wall(var/turf/simulated/wall/W)
	//No blending if no material
	if(!material || !W.material)
		return 0
	//We can blend if either is the same, or a subtype, of the other one
	if(istype(W.material, material.type) || istype(material, W.material.type))
		return 1
	//Also blend if they have the same iconbase
	if(material.icon_base == W.material.icon_base)
		return 1
	return 0

/turf/simulated/wall/proc/can_join_with_low_wall(var/obj/structure/low_wall/WF)
	return FALSE