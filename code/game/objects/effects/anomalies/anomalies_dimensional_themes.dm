/**
 * Datum which describes a theme and replaces turfs and objects in specified locations to match that theme
 */
/datum/dimension_theme
	/// Human readable name of the theme
	var/name = "Unnamed Theme"
	/// An icon to display to represent the theme
	var/icon/icon = 'icons/obj/stacks.dmi'
	/// Icon state to use to represent the theme
	var/icon_state
	/// Typepath of custom material to use for objects.
	var/datum/material/material
	/// Sound to play when transforming a tile
	var/sound = 'sound/effects/blind.ogg'
	/// Weighted list of turfs to replace the floor with.
	var/list/replace_floors = list(/turf/simulated/floor/tiled = 1)
	/// Typepath of turf to replace walls with.
	var/turf/replace_walls = /turf/simulated/wall
	/// List of weighted lists for object replacement. Key is an original typepath, value is a weighted list of typepaths to replace it with.
	var/list/replace_objs = list(
		/obj/structure/bed/chair = list(/obj/structure/bed/chair = 1),
		/obj/machinery/door/airlock = list(/obj/machinery/door/airlock = 1, /obj/machinery/door/airlock/glass = 1),
		/obj/structure/table = list(/obj/structure/table = 1),
		/obj/structure/toilet = list(/obj/structure/toilet = 1)
	)
	/// List of random spawns to place in completely open turfs
	var/list/random_spawns
	/// Prob of placing a random spawn in a completely open turf
	var/random_spawn_chance = 0
	/// Typepath of full-size windows which will replace existing ones
	/// These need to be separate from replace_objs because we don't want to replace dir windows with full ones and they share typepath
	var/obj/structure/window/replace_window
	/// Colour to recolour windows with, replaced by material colour if material was specified.
	var/window_colour = "#ffffff"

/datum/dimension_theme/New()
	if(material)
		var/datum/material/using_mat = GET_MATERIAL_REF(material)
		window_colour = using_mat.icon_colour


/**
 * Applies themed transformation to the provided turf.
 *
 * Arguments
 * * affected_turf - Turf to transform.
 * * skip_sound - If the sound shouldn't be played.
 * * show_effect - if the temp visual effect should be shown.
 */
/datum/dimension_theme/proc/apply_theme(turf/affected_turf, skip_sound = FALSE, show_effect = FALSE)
	if(!replace_turf(affected_turf))
		return
	if(!skip_sound)
		playsound(affected_turf, sound, 100, TRUE)
	if(show_effect)
		new /obj/effect/temp_visual/transmute_tile_flash(affected_turf)
	for(var/obj/object in affected_turf)
		replace_object(object)
	if(length(random_spawns) && prob(random_spawn_chance))
		var/random_spawn_picked = pick(random_spawns)
		new random_spawn_picked(affected_turf)

/datum/dimension_theme/proc/can_convert(var/turf/affected_turf)
	if(isspace(affected_turf))
		return FALSE
	if(isfloorturf(affected_turf))
		if(istype(get_area(affected_turf), /area/holodeck))
			return FALSE
		return replace_floors.len > 0
	if(iswall(affected_turf))
		return TRUE
	return FALSE

/datum/dimension_theme/proc/replace_turf(turf/affected_turf)
	PROTECTED_PROC(TRUE)

	if(isfloorturf(affected_turf))
		if(istype(get_area(affected_turf), /area/holodeck) || istype(get_area(affected_turf), /area/crew_quarters))
			return FALSE
		return transform_floor(affected_turf)

	if(!iswall(affected_turf))
		return FALSE

	affected_turf.ChangeTurf(replace_walls)
	return TRUE

/**
 * Replaces the provided floor turf with a different one.
 *
 * Arguments
 * * affected_floor - Floor turf to transform.
 */
/datum/dimension_theme/proc/transform_floor(turf/affected_floor)
	PROTECTED_PROC(TRUE)

	if(replace_floors.len == 0)
		return FALSE
	affected_floor.ChangeTurf(pick_weight(replace_floors))

	return TRUE

/**
 * Replaces the provided object with a different one.
 *
 * Arguments
 * * object - Object to replace.
 */
/datum/dimension_theme/proc/replace_object(obj/object)
	PROTECTED_PROC(TRUE)

	if(istype(object, /obj/structure/window) && window_colour)
		object.color = window_colour
		return

	if(istype(object, /obj/structure/table) && material)
		var/obj/structure/table/table = object
		table.material = material
		table.update_connections(TRUE)
		table.update_icon()
		table.update_desc()
		table.update_material()
		return

	if(istype(object, /obj/machinery/light))
		var/obj/machinery/light/light = object
		light.brightness_color = window_colour
		light.brightness_color_ns = window_colour
		light.set_light(0)
		light.update()

	var/replace_path = get_replacement_object_typepath(object)
	if(!replace_path)
		return
	var/obj/new_object = new replace_path(object.loc)
	if(istype(object, /obj/machinery/door/airlock))
		if(istype(new_object, /obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/airlock = object
			var/obj/machinery/door/airlock/new_airlock = new_object
			new_airlock.req_access = airlock.req_one_access?.Copy()
			new_airlock.locked = airlock.locked
			if(istype(object, /obj/machinery/door/airlock/multi_tile))
				for(var/turf/location in object.locs)
					if(location == object.loc)
						continue
					var/obj/machinery/door/airlock/long_airlock = new replace_path(location)
					long_airlock.req_access = airlock.req_one_access?.Copy()
					long_airlock.locked = airlock.locked
					long_airlock.name = airlock.name
		new_object.name = object.name
	qdel(object)

/**
 * Returns the typepath of an object to replace the provided object.
 *
 * Arguments
 * * object - Object to transform.
 */
/datum/dimension_theme/proc/get_replacement_object_typepath(obj/object)
	PROTECTED_PROC(TRUE)

	for(var/type in replace_objs)
		if(istype(object, type))
			return pick_weight(replace_objs[type])

/datum/dimension_theme/gold
	name = "Gold"
	icon_state = "sheet-gold_2"
	material = /datum/material/gold
	replace_floors = list(/turf/simulated/floor/tiled/material/gold = 1)
	replace_objs = list(
		/obj/structure/bed/chair = list(/obj/structure/bed/chair = 1),
		/obj/machinery/door/airlock = list(/obj/machinery/door/airlock/gold = 1),
		/obj/structure/table = list(/obj/structure/table/gold = 1),
		/obj/structure/toilet = list(/obj/structure/toilet = 1)
	)
	replace_walls = /turf/simulated/wall/gold

/datum/dimension_theme/radioactive
	name = "Radioactive"
	icon_state = "sheet-uranium_2"
	material = /datum/material/uranium
	replace_floors = list(/turf/simulated/floor/tiled/material/uranium = 1)
	replace_objs = list(
		/obj/machinery/door/airlock = list(/obj/machinery/door/airlock/uranium = 1),
	)
	replace_walls = /turf/simulated/wall/uranium
	sound = 'sound/items/Welder.ogg'

/datum/dimension_theme/wood
	name = "Wood"
	icon_state = "sheet-plank"
	material = /datum/material/wood
	replace_floors = list(/turf/simulated/floor/wood = 1)
	replace_objs = list(
		/obj/structure/bed/chair = list(/obj/structure/bed/chair/wood = 1),
		/obj/machinery/door/airlock = list(/obj/structure/simple_door/wood = 1),
		/obj/structure/table = list(/obj/structure/table/woodentable = 1)
	)
	replace_walls = /turf/simulated/wall/wood
/*
/datum/dimension_theme/meat
	name = "Meat"
	icon = 'icons/obj/food.dmi'
	icon_state = "meat"
	material = /datum/material/flesh

/datum/dimension_theme/alien
	name = "Alien"
	icon = 'icons/obj/abductor.dmi'
	icon_state = "circuit"
	replace_floors = list(/turf/simulated/floor/redgrid = 1, /turf/simulated/floor/greengrid = 1, /turf/simulated/floor/bluegrid = 1)
	replace_objs = list(
		/obj/machinery/door/airlock = list(/obj/machinery/door/airlock/alien = 1),
		/obj/structure/table = list(/obj/structure/table/alien = 1, /obj/structure/table/alien/blue = 1)
	)
*/
/datum/dimension_theme/natural
	name = "Natural"
	icon = 'icons/obj/plants.dmi'
	icon_state = "plant-24"
	window_colour = "#0b8011ff"
	replace_floors = list(/turf/simulated/floor/grass = 1)
	replace_walls = /turf/simulated/wall/wood
	replace_objs = list(
		/obj/structure/bed/chair = list(/obj/structure/bed/chair/wood = 3, /obj/structure/bed/chair/wood/wings = 1),
		/obj/machinery/door/airlock = list(/obj/structure/simple_door/wood = 1),
	)
	random_spawns = list(
		/obj/structure/flora/grass/green = 3,
		/obj/structure/flora/bush = 3,
		/mob/living/simple_mob/vore/bee = 1,
		)
	random_spawn_chance = 10

/datum/dimension_theme/phoron
	name = "Phoron"
	icon_state = "sheet-phoron_2"
	material = /datum/material/phoron
	replace_floors = list(/turf/simulated/floor/tiled/material/phoron = 1)
	replace_objs = list(
		/obj/machinery/door/airlock = list(/obj/machinery/door/airlock/phoron = 1),
	)
	replace_walls = /turf/simulated/wall/phoron

/datum/dimension_theme/glass
	name = "Glass"
	icon_state = "sheet-glass_2"
	material = /datum/material/glass
	replace_floors = list(/turf/simulated/floor/glass = 1)
	replace_objs = list(
		/obj/machinery/door/airlock = list(/obj/machinery/door/airlock/glass = 1),
		/obj/structure/table = list(/obj/structure/table/glass = 1)
	)
	replace_walls = /obj/structure/window/basic/full

/datum/dimension_theme/snow
	name = "Snow"
	icon_state = "sheet-snow_2"
	material = /datum/material/snow
	replace_floors = list(/turf/simulated/floor/snow = 10, /turf/simulated/floor/outdoors/ice = 1)
	replace_objs = list(
		/obj/machinery/door/airlock = list(/obj/structure/simple_door/)
	)
