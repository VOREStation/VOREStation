/atom
	var/light_power = 1 // intensity of the light
	var/light_range = 0 // range in tiles of the light
	var/light_color		// Hexadecimal RGB string representing the colour of the light

	var/datum/light_source/light
	var/list/light_sources

// Nonsensical value for l_color default, so we can detect if it gets set to null.
#define NONSENSICAL_VALUE -99999
/atom/proc/set_light(l_range, l_power, l_color = NONSENSICAL_VALUE)
	. = 0 //make it less costly if nothing's changed

	if(l_power != null && l_power != light_power)
		light_power = l_power
		. = 1
	if(l_range != null && l_range != light_range)
		light_range = l_range
		. = 1
	if(l_color != NONSENSICAL_VALUE && l_color != light_color)
		light_color = l_color
		. = 1

	if(.) update_light()

#undef NONSENSICAL_VALUE

/atom/proc/update_light()
	set waitfor = FALSE

	if(!light_power || !light_range)
		if(light)
			light.destroy()
			light = null
	else
		if(!istype(loc, /atom/movable))
			. = src
		else
			. = loc

		if(light)
			light.update(.)
		else
			light = new /datum/light_source(src, .)

/atom/New()
	. = ..()

	if(light_power && light_range)
		update_light()

	if(opacity && isturf(loc))
		var/turf/T = loc
		T.has_opaque_atom = TRUE // No need to recalculate it in this case, it's guranteed to be on afterwards anyways.

/atom/Destroy()
	if(light)
		light.destroy()
		light = null
	return ..()

/atom/movable/Destroy()
	var/turf/T = loc
	if(opacity && istype(T))
		T.reconsider_lights()
	return ..()

/atom/movable/Moved(atom/old_loc, direction, forced = FALSE)
	. = ..()

	for(var/datum/light_source/L in light_sources)
		L.source_atom.update_light()

	var/turf/new_turf = loc
	var/turf/old_turf = old_loc
	if(istype(old_turf) && opacity)
		old_turf.reconsider_lights()

	if(istype(new_turf) && opacity)
		new_turf.reconsider_lights()

/atom/proc/set_opacity(new_opacity)
	if(new_opacity == opacity)
		return

	opacity = new_opacity
	var/turf/T = isturf(src) ? src : loc
	if(!isturf(T))
		return

	if(new_opacity == TRUE)
		T.has_opaque_atom = TRUE
		T.reconsider_lights()
	else
		var/old_has_opaque_atom = T.has_opaque_atom
		T.recalc_atom_opacity()
		if(old_has_opaque_atom != T.has_opaque_atom)
			T.reconsider_lights()

/obj/item/equipped()
	. = ..()
	update_light()

/obj/item/pickup()
	. = ..()
	update_light()

/obj/item/dropped()
	. = ..()
	update_light()
