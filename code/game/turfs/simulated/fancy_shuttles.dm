/**
 * To map these, place down a /obj/effect/fancy_shuttle on the map and lay down /turf/simulated/wall/fancy_shuttle
 * everywhere that is included in the sprite. Up to you if you want to make some opacity=FALSE or density=FALSE
 * Set a matching fancy_shuttle_tag on your walls and on the /obj/effect/fancy_shuttle. Make sure it's unique.
 *
 * If you want flooring to look like the shuttle flooring, put /obj/effect/floor_decal/fancy_shuttle on all of it.
 * You can add your own decals on top of that. Just make sure to put the fancy_shuttle decal lowest.
 * Also set the same tag as your /obj/effect/fancy_shuttle on the decals.
 */

GLOBAL_LIST_EMPTY(fancy_shuttles)
/**
 * Generic shuttle
 * North facing: W:5, H:9
 */
/obj/effect/fancy_shuttle
	name = "shuttle wall decorator"
	icon = 'icons/turf/fancy_shuttles/generic_preview.dmi'
	icon_state = "walls"
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	invisibility = INVISIBILITY_MAXIMUM
	alpha = 90 // so you can see it a bit easier on the map if you placed walls properly
	var/split_file = 'icons/turf/fancy_shuttles/generic.dmi'
	var/icon/split_icon
	var/fancy_shuttle_tag

/obj/effect/fancy_shuttle/New() // has to be very early so others can grab it
	. = ..()
	if(!fancy_shuttle_tag)
		error("Fancy shuttle with no tag at [x],[y],[z]! Type is: [type]")
		return INITIALIZE_HINT_QDEL
	split_icon = icon(split_file, null, dir)
	GLOB.fancy_shuttles[fancy_shuttle_tag] = src

/obj/effect/fancy_shuttle_floor_preview
	name = "shuttle floor preview"
	icon = 'icons/turf/fancy_shuttles/generic_preview.dmi'
	icon_state = "floors"
	plane = PLATING_PLANE
	layer = DISPOSAL_LAYER
	alpha = 90

/obj/effect/fancy_shuttle_floor_preview/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_QDEL

// Only icon changes are damage
/turf/simulated/wall/fancy_shuttle
	icon = 'icons/turf/fancy_shuttles/_fancy_helpers.dmi'
	icon_state = "hull"
	wall_masks = 'icons/turf/fancy_shuttles/_fancy_helpers.dmi'
	var/mutable_appearance/under_MA
	var/mutable_appearance/under_EM
	var/fancy_shuttle_tag

// Reinforced hull steel
/turf/simulated/wall/fancy_shuttle/Initialize(mapload, materialtype, rmaterialtype, girdertype)
	. = ..(mapload,  MAT_STEELHULL, MAT_STEELHULL, MAT_STEELHULL)

/turf/simulated/wall/fancy_shuttle/low //you can see over it and it doesn't block air but you still cant walk over it
	blocks_air = FALSE
	opacity = FALSE
	icon_state = "hull_low"

/turf/simulated/wall/fancy_shuttle/nondense
	density = FALSE
	blocks_air = FALSE
	opacity = FALSE
	icon_state = "hull_nondense"

/turf/simulated/wall/fancy_shuttle/pre_translate_A(turf/B)
	. = ..()
	remove_underlay()

/turf/simulated/wall/fancy_shuttle/post_translate_B(turf/A)
	apply_underlay()
	return ..()

// No girders, and Eris plating
/turf/simulated/wall/fancy_shuttle/dismantle_wall(var/devastated, var/explode, var/no_product)

	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	if(!no_product && !devastated)
		material.place_dismantled_product(src)
		if (!reinf_material)
			material.place_dismantled_product(src)

	clear_plants()
	material = get_material_by_name("placeholder")
	reinf_material = null
	girder_material = null

	ChangeTurf(/turf/simulated/floor/plating/eris/under)

/turf/simulated/wall/fancy_shuttle/proc/remove_underlay()
	if(under_MA)
		underlays -= under_MA
		under_MA = null
	if(under_EM)
		underlays -= under_EM
		under_EM = null

/turf/simulated/wall/fancy_shuttle/proc/apply_underlay()
	remove_underlay()

	var/turf/path = get_base_turf_by_area(src) || /turf/space

	var/do_plane = null
	var/do_state = initial(path.icon_state)
	var/do_icon = initial(path.icon)
	if(ispath(path, /turf/space))
		do_plane = SPACE_PLANE
		do_state = "white"

		under_EM = mutable_appearance('icons/turf/space.dmi', "white", plane = PLANE_O_LIGHTING_VISUAL)
		under_EM.filters = filter(type = "alpha", icon = icon(src.icon, src.icon_state), flags = MASK_INVERSE)

	under_MA = mutable_appearance(do_icon, do_state, layer = src.layer-0.02, plane = do_plane)
	underlays += under_MA
	if(under_EM)
		underlays += under_EM

// Trust me, this is WAY faster than the normal wall overlays shenanigans, don't worry about performance
/turf/simulated/wall/fancy_shuttle/update_icon()
	if(!damage_overlays[1])
		generate_overlays()

	cut_overlays()
	if(fancy_shuttle_tag) // after a shuttle jump it won't be set anymore, but the shuttle jump proc will set our icon and state
		var/obj/effect/fancy_shuttle/F = GLOB.fancy_shuttles[fancy_shuttle_tag]
		if(!F)
			warning("Fancy shuttle wall at [x],[y],[z] couldn't locate a helper with tag [fancy_shuttle_tag]")
			return
		icon = F.split_icon
		icon_state = "walls [x - F.x],[y - F.y]"

	apply_underlay()

	if(damage != 0)
		var/integrity = material.integrity
		if(reinf_material)
			integrity += reinf_material.integrity

		var/overlay = round(damage / integrity * damage_overlays.len) + 1
		if(overlay > damage_overlays.len)
			overlay = damage_overlays.len

		add_overlay(damage_overlays[overlay])

/turf/simulated/wall/fancy_shuttle/update_connections()
	return

/turf/simulated/wall/fancy_shuttle/set_light(l_range, l_power, l_color, l_on)
	return

/obj/effect/floor_decal/fancy_shuttle
	icon = 'icons/turf/fancy_shuttles/_fancy_helpers.dmi'
	icon_state = "fancy_shuttle"
	layer = DECAL_LAYER-1
	var/icon_file
	var/fancy_shuttle_tag

/obj/effect/floor_decal/fancy_shuttle/Initialize(mapload)
	var/obj/effect/fancy_shuttle/F = GLOB.fancy_shuttles[fancy_shuttle_tag]
	if(!F)
		warning("Fancy shuttle floor decal at [x],[y],[z] couldn't locate a helper with tag [fancy_shuttle_tag]")
		return INITIALIZE_HINT_QDEL
	icon = F.split_icon
	icon_file = F.split_file
	icon_state = "floors [x - F.x],[y - F.y]"
	return ..()

/obj/effect/floor_decal/fancy_shuttle/make_decal_image()
	return image(icon = icon, icon_state = icon_state, layer = BUILTIN_DECAL_LAYER)

/obj/effect/floor_decal/fancy_shuttle/get_cache_key(var/turf/T)
	return "[alpha]-[color]-[dir]-[icon_state]-[T.layer]-[icon_file]"

/**
 * Shuttle Glass
 */
 //OLD GLASS - USE NEW GLASS
/turf/simulated/wall/fancy_shuttle/window
	opacity = FALSE
	icon_state = "hull_transparent"

/turf/simulated/wall/fancy_shuttle/window/attack_generic(mob/user, damage, attack_message)
	take_damage(damage)
	return damage

//NEW GLASS
/obj/structure/window/fancy_shuttle
	name = "shuttle window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/turf/fancy_shuttles/_fancy_helpers.dmi'
	icon_state = "hull_window"
	density = TRUE
	fulltile = TRUE
	maxhealth = 60
	reinf = 1
	force_threshold = 7
	var/fancy_shuttle_tag

// Trust me, this is WAY faster than the normal wall overlays shenanigans, don't worry about performance
/obj/structure/window/fancy_shuttle/update_icon()
	if(fancy_shuttle_tag) // after a shuttle jump it won't be set anymore, but the shuttle jump proc will set our icon and state
		var/obj/effect/fancy_shuttle/F = GLOB.fancy_shuttles[fancy_shuttle_tag]
		if(!F)
			warning("Fancy shuttle wall at [x],[y],[z] couldn't locate a helper with tag [fancy_shuttle_tag]")
			return
		icon = F.split_icon
		icon_state = "walls [x - F.x],[y - F.y]"

/**
 * Invisible ship equipment (otherwise the same as normal)
 */
// Gas engine
/obj/machinery/atmospherics/unary/engine/fancy_shuttle
	icon = 'icons/turf/fancy_shuttles/_fancy_helpers.dmi'
	icon_state = "gas_engine"
	invisibility = INVISIBILITY_MAXIMUM

// Ion engine
/obj/machinery/ion_engine/fancy_shuttle
	icon = 'icons/turf/fancy_shuttles/_fancy_helpers.dmi'
	icon_state = "ion_engine"
	invisibility = INVISIBILITY_MAXIMUM

// Sensors
/obj/machinery/shipsensors/fancy_shuttle
	icon = 'icons/turf/fancy_shuttles/_fancy_helpers.dmi'
	icon_state = "ship_sensors"
	invisibility = INVISIBILITY_MAXIMUM

/**
 * Escape shuttle
 * North facing: W:15, H:27
 */
/obj/effect/fancy_shuttle/escape
	icon = 'icons/turf/fancy_shuttles/escape_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/escape.dmi'
/obj/effect/fancy_shuttle_floor_preview/escape
	icon = 'icons/turf/fancy_shuttles/escape_preview.dmi'

/**
 * Mining shuttle
 * North facing: W:18, H:24
 */
/obj/effect/fancy_shuttle/miner
	icon = 'icons/turf/fancy_shuttles/miner_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/miner.dmi'
/obj/effect/fancy_shuttle_floor_preview/miner
	icon = 'icons/turf/fancy_shuttles/miner_preview.dmi'

/**
 * Science shuttle
 * North facing: W:17, H:22
 */
/obj/effect/fancy_shuttle/science
	icon = 'icons/turf/fancy_shuttles/science_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/science.dmi'
/obj/effect/fancy_shuttle_floor_preview/science
	icon = 'icons/turf/fancy_shuttles/science_preview.dmi'

/**
 * Dropship
 * North facing: W:11, H:20
 */
/obj/effect/fancy_shuttle/dropship
	icon = 'icons/turf/fancy_shuttles/dropship_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/dropship.dmi'
/obj/effect/fancy_shuttle_floor_preview/dropship
	icon = 'icons/turf/fancy_shuttles/dropship_preview.dmi'

/**
 * Explo shuttle
 * North facing: W:13, H:18
 */
/obj/effect/fancy_shuttle/exploration
	icon = 'icons/turf/fancy_shuttles/exploration_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/exploration.dmi'
/obj/effect/fancy_shuttle_floor_preview/exploration
	icon = 'icons/turf/fancy_shuttles/exploration_preview.dmi'

/**
 * Secbus shuttle
 * North facing: W:11, H:16
 */
/obj/effect/fancy_shuttle/secbus
	icon = 'icons/turf/fancy_shuttles/secbus_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/secbus.dmi'
/obj/effect/fancy_shuttle_floor_preview/secbus
	icon = 'icons/turf/fancy_shuttles/secbus_preview.dmi'

/**
 * Medbus shuttle
 * North facing: W:11, H:16
 */
/obj/effect/fancy_shuttle/medbus
	icon = 'icons/turf/fancy_shuttles/medbus_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/medbus.dmi'
/obj/effect/fancy_shuttle_floor_preview/medbus
	icon = 'icons/turf/fancy_shuttles/medbus_preview.dmi'

/**
 * Orange line tram
 * North facing: W:9, H:16
 */
/obj/effect/fancy_shuttle/orangeline
	icon = 'icons/turf/fancy_shuttles/orangeline_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/orangeline.dmi'
/obj/effect/fancy_shuttle_floor_preview/orangeline
	icon = 'icons/turf/fancy_shuttles/orangeline_preview.dmi'

/**
 * Tour bus
 * North facing: W:7, H:12
 */
/obj/effect/fancy_shuttle/tourbus
	icon = 'icons/turf/fancy_shuttles/tourbus_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/tourbus.dmi'
/obj/effect/fancy_shuttle_floor_preview/tourbus
	icon = 'icons/turf/fancy_shuttles/tourbus_preview.dmi'

/**
 * Stellar Delight Shuttle
 * North facing: W:9, H:14
 */
/obj/effect/fancy_shuttle/sd_shuttle
	icon = 'icons/turf/fancy_shuttles/sd_shuttle_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/sd_shuttle.dmi'
/obj/effect/fancy_shuttle_floor_preview/sd_shuttle
	icon = 'icons/turf/fancy_shuttles/sd_shuttle_preview.dmi'

/**
 * Delivery shuttle
 * North facing: W:8, H:10
 */
/obj/effect/fancy_shuttle/delivery
	icon = 'icons/turf/fancy_shuttles/delivery_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/delivery.dmi'
/obj/effect/fancy_shuttle_floor_preview/delivery
	icon = 'icons/turf/fancy_shuttles/delivery_preview.dmi'

/**
 * Tether Cargo shuttle
 * North facing: W:8, H:12
 */
/obj/effect/fancy_shuttle/tether_cargo
	icon = 'icons/turf/fancy_shuttles/tether_cargo_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/tether_cargo.dmi'
/obj/effect/fancy_shuttle_floor_preview/tether_cargo
	icon = 'icons/turf/fancy_shuttles/tether_cargo_preview.dmi'

/**
 * Wagon
 * North facing: W:5, H:13
 */
/obj/effect/fancy_shuttle/wagon
	icon = 'icons/turf/fancy_shuttles/wagon_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/wagon.dmi'
/obj/effect/fancy_shuttle_floor_preview/wagon
	icon = 'icons/turf/fancy_shuttles/wagon_preview.dmi'

/**
 * Lifeboat
 * North facing: W:5, H:10
 */
/obj/effect/fancy_shuttle/lifeboat
	icon = 'icons/turf/fancy_shuttles/lifeboat_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/lifeboat.dmi'
/obj/effect/fancy_shuttle_floor_preview/lifeboat
	icon = 'icons/turf/fancy_shuttles/lifeboat_preview.dmi'

/**
 * Lifeboat1 (Tether)
 * North facing: W:5, H:7
 */
/obj/effect/fancy_shuttle/lifeboat1
	icon = 'icons/turf/fancy_shuttles/lifeboat1_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/lifeboat1.dmi'
/obj/effect/fancy_shuttle_floor_preview/lifeboat1
	icon = 'icons/turf/fancy_shuttles/lifeboat1_preview.dmi'

/**
 * Lifeboat2 (Tether)
 * North facing: W:5, H:12
 */
/obj/effect/fancy_shuttle/lifeboat2
	icon = 'icons/turf/fancy_shuttles/lifeboat2_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/lifeboat2.dmi'
/obj/effect/fancy_shuttle_floor_preview/lifeboat2
	icon = 'icons/turf/fancy_shuttles/lifeboat2_preview.dmi'

/**
 * Pod
 * North facing: W:3, H:4
 */
/obj/effect/fancy_shuttle/escapepod
	icon = 'icons/turf/fancy_shuttles/pod_preview.dmi'
	split_file = 'icons/turf/fancy_shuttles/pod.dmi'
/obj/effect/fancy_shuttle_floor_preview/escapepod
	icon = 'icons/turf/fancy_shuttles/pod_preview.dmi'
