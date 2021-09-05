// Landmark which loads a PoI on init.
/obj/effect/landmark/poi_loader
	name = "Point of Interest Loader"
	/// If TRUE, most things within the loading area will be deleted. This includes players!
	var/submap_path = null
	var/loaded = TRUE // TODO, optimize loading at init.

/obj/effect/landmark/poi_loader/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/poi_loader/LateInitialize()
	if(loaded)
		return
	loaded = TRUE

	var/turf/T = get_turf(src)
	if(!istype(T))
		to_world_log("[log_info_line(src)] not on a turf! Cannot place PoI template.")
		return

	var/datum/map_template/template = get_submap_template()
	if(!istype(template))
		to_world_log("[log_info_line(src)] was not given a submap template, but was instead given [log_info_line(template)].")
		return
	
	to_world_log("[name] chose [template.name] to load.")
	admin_notice("[name] chose [template.name] to load.")
	moveToNullspace()

	template.load(T)
	qdel(src)

/obj/effect/landmark/poi_loader/proc/get_submap_template()
//	return SSmapping.map_template_types[submap_path]
	return new submap_path()

/obj/effect/landmark/poi_loader/random_subtype/get_submap_template()
//	var/list/choices = list()
//	for(var/i = 1 to SSmapping.map_templates.len)  // I wish these were `/decl`s, but that would hamper admin map uploading.
//		var/datum/map_template/template = SSmapping.map_templates[i]
//		if(istype(template, submap_path))
//			choices += template
//	return pick(choices)
	var/list/subtypes = subtypesof(submap_path)
	var/type_picked = pick(subtypes)
	var/datum/map_template/template = new type_picked()
	return template

/obj/effect/landmark/poi_loader/random
	var/list/possible_submap_paths = list()

/obj/effect/landmark/poi_loader/random/get_submap_template()
	var/chosen_path = pick(possible_submap_paths)
//	return SSmapping.map_template_types[chosen_path]
	return new chosen_path()