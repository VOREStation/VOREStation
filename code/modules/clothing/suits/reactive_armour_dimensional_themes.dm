#define MAX_BARRIERS 4
#define MIN_BARRIERS 2

/datum/armour_dimensional_theme
	var/datum/material/material
	var/turf/replace_floor = /turf/simulated/floor/tiled
	var/turf/replace_wall = /turf/simulated/wall
	var/obj/barricade = /obj/structure/barricade
	var/barricade_anchored = TRUE

/datum/armour_dimensional_theme/proc/apply_random(turf/source, dangerous = FALSE)
	var/theme_type
	if(dangerous)
		theme_type = pick(subtypesof(/datum/armour_dimensional_theme/dangerous))
	else
		theme_type = pick(subtypesof(/datum/armour_dimensional_theme/safe))
	var/datum/armour_dimensional_theme/theme = new theme_type()
	theme.apply(source)
	qdel(theme)

/datum/armour_dimensional_theme/proc/apply(turf/source)
	var/obj/effect/effect/smoke/poof = new(source)
	poof.time_to_live = 2 SECONDS
	var/list/target_area = get_target_area(source)
	for (var/turf/target in target_area)
		convert_turf(target)
	place_barriers(source, target_area)

/datum/armour_dimensional_theme/proc/get_target_area(turf/source)
	var/list/target_area = RANGE_TURFS(1, source)
	for (var/turf/check_turf as anything in target_area)
		if(isspace(check_turf))
			target_area -= check_turf
			continue
		if(istype(get_area(check_turf), /area/holodeck))
			continue

	return target_area

/datum/armour_dimensional_theme/proc/convert_turf(turf/to_convert)
	if(isfloorturf(to_convert))
		var/turf/simulated/floor/floor = to_convert
		floor.ChangeTurf(replace_floor)
	else if(iswall(to_convert))
		to_convert.ChangeTurf(replace_wall)

/datum/armour_dimensional_theme/proc/place_barriers(turf/source, list/target_area)
	target_area -= source
	for(var/turf/check_turf as anything in target_area)
		if (!check_turf.density)
			continue
		target_area -= check_turf

	var/to_place = rand(MIN_BARRIERS, MAX_BARRIERS)
	var/list/custom_materials = list()
	if(material)
		custom_materials = list(GET_MATERIAL_REF(material) = SHEET_MATERIAL_AMOUNT)

	while(target_area.len > 0 && to_place > 0)
		var/turf/place_turf = pick(target_area)
		place_barrier(place_turf, custom_materials)
		target_area -= place_turf
		to_place--

/datum/armour_dimensional_theme/proc/place_barrier(turf/source)
	var/obj/structure/barricade/placed_barricade = new barricade(source, material.name)
	if(!barricade_anchored)
		placed_barricade.anchored = FALSE

/datum/armour_dimensional_theme/safe

/datum/armour_dimensional_theme/safe/natural
	replace_wall = /turf/simulated/wall/wood
	replace_floor = /turf/simulated/floor/wood
	barricade = /obj/structure/barricade
	material = /datum/material/wood

/datum/armour_dimensional_theme/safe/snow
	replace_wall = /turf/simulated/wall/snowbrick
	replace_floor = /turf/simulated/floor/snow
	material = /datum/material/snow

/datum/armour_dimensional_theme/dangerous

/datum/armour_dimensional_theme/dangerous/radioactive
	replace_wall = /turf/simulated/wall/uranium
	replace_floor = /turf/simulated/floor/tiled/material/uranium
	material = /datum/material/uranium

/datum/armour_dimensional_theme/dangerous/phoron
	replace_wall = /turf/simulated/wall/phoron
	replace_floor = /turf/simulated/floor/tiled/material/phoron
	material = /datum/material/phoron

#undef MAX_BARRIERS
#undef MIN_BARRIERS
