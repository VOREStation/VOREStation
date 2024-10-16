// This file provides manually written utility types and such for the BAPI DMM Reader

GLOBAL_LIST_EMPTY(cached_maps)

GLOBAL_VAR_INIT(use_preloader, FALSE)
GLOBAL_VAR_INIT(_preloader_path, null)
GLOBAL_LIST_EMPTY(_preloader_attributes)

/world/proc/preloader_setup(list/the_attributes, path)
	if(LAZYLEN(the_attributes))
		GLOB.use_preloader = TRUE
		GLOB._preloader_attributes = the_attributes
		GLOB._preloader_path = path

/world/proc/preloader_load(atom/what)
	GLOB.use_preloader = FALSE
	var/list/attributes = GLOB._preloader_attributes
	for(var/attribute in attributes)
		var/value = attributes[attribute]
		if(islist(value))
			value = deepCopyList(value)
		#ifdef TESTING
		if(what.vars[attribute] == value)
			var/message = "<font color=green>[what.type]</font> at [AREACOORD(what)] - <b>VAR:</b> <font color=red>[attribute] = [isnull(value) ? "null" : (isnum(value) ? value : "\"[value]\"")]</font>"
			world.log << "DIRTY VAR: [message]"
			dirty_vars += message
		#endif
		what.vars[attribute] = value

#define MAP_DMM "dmm"
/**
 * TGM SPEC:
 * TGM is a derevation of DMM, with restrictions placed on it
 * to make it easier to parse and to reduce merge conflicts/ease their resolution
 *
 * Requirements:
 * Each "statement" in a key's details ends with a new line, and wrapped in (...)
 * All paths end with either a comma or occasionally a {, then a new line
 * Excepting the area, who is listed last and ends with a ) to mark the end of the key
 *
 * {} denotes a list of variable edits applied to the path that came before the first {
 * the final } is followed by a comma, and then a new line
 * Variable edits have the form \tname = value;\n
 * Except the last edit, which has no final ;, and just ends in a newline
 * No extra padding is permitted
 * Many values are supported. See parse_constant()
 * Strings must be wrapped in "...", files in '...', and lists in list(...)
 * Files are kinda susy, and may not actually work. buyer beware
 * Lists support assoc values as expected
 * These constants can be further embedded into lists
 *
 * There can be no padding in front of, or behind a path
 *
 * Therefore:
 * "key" = (
 * /path,
 * /other/path{
 *     var = list("name" = 'filepath');
 *     other_var = /path
 *     },
 * /turf,
 * /area)
 *
 */
#define MAP_TGM "tgm"
#define MAP_UNKNOWN "unknown"

/// Returned from parse_map to give some metadata about the map
/datum/bapi_parsed_map
	var/_internal_index = -1

	var/original_path = ""
	var/map_format = MAP_UNKNOWN
	var/key_len = 0
	var/line_len = 0
	var/expanded_y = FALSE
	var/expanded_x = FALSE

	/// Unoffset bounds. Null on parse failure.
	var/list/bounds = list()
	/// Offset bounds. Same as parsed_bounds until load().
	var/list/parsed_bounds = list()

	///any turf in this list is skipped inside of build_coordinate. Lazy assoc list
	var/list/turf_blacklist

	var/loading = FALSE
	var/loaded_warnings = list()

/**
 * Helper and recommened way to load a map file
 * - dmm_file: The path to the map file
 * - x_offset: The x offset to load the map at
 * - y_offset: The y offset to load the map at
 * - z_offset: The z offset to load the map at
 * - crop_map: If true, the map will be cropped to the world bounds
 * - measure_only: If true, the map will not be loaded, but the bounds will be calculated
 * - no_changeturf: If true, the map will not call /turf/AfterChange
 * - x_lower: The minimum x coordinate to load
 * - x_upper: The maximum x coordinate to load
 * - y_lower: The minimum y coordinate to load
 * - y_upper: The maximum y coordinate to load
 * - z_lower: The minimum z coordinate to load
 * - z_upper: The maximum z coordinate to load
 * - place_on_top: Whether to use /turf/proc/PlaceOnTop rather than /turf/proc/ChangeTurf
 * - new_z: If true, a new z level will be created for the map
 */
/proc/load_map_bapi(
	dmm_file,
	x_offset = 1,
	y_offset = 1,
	z_offset,
	crop_map = FALSE,
	measure_only = FALSE,
	no_changeturf = FALSE,
	x_lower = -INFINITY,
	x_upper = INFINITY,
	y_lower = -INFINITY,
	y_upper = INFINITY,
	z_lower = -INFINITY,
	z_upper = INFINITY,
	place_on_top = FALSE,
	new_z = FALSE,
)
	if(isfile(dmm_file))
		log_debug("bapi-dmm was passed a file instead of a path string: [dmm_file]")
		var/name = sanitize_filename("[dmm_file]")
		var/path = "data/baked_dmm_files/[name]"
		if(!fexists(path))
			var/text = file2text(dmm_file)
			rustg_file_write(text, path)
		dmm_file = path

	if(!fexists(dmm_file))
		stack_trace("Invalid map path: [dmm_file]")
		return

	if(!(dmm_file in GLOB.cached_maps))
		GLOB.cached_maps[dmm_file] = new /datum/bapi_parsed_map(dmm_file)

	// Bay assumption
	if(!z_offset)
		z_offset = world.maxz + 1

	var/datum/bapi_parsed_map/parsed_map = GLOB.cached_maps[dmm_file]
	parsed_map = parsed_map.copy()
	if(!measure_only && !isnull(parsed_map.bounds))
		parsed_map.load(x_offset, y_offset, z_offset, crop_map, no_changeturf, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper, place_on_top, new_z)
	return parsed_map

/datum/bapi_parsed_map/New(tfile)
	if(isnull(tfile))
		return // create a new datum without loading a map
	var/ret = _bapidmm_parse_map_blocking(tfile, src)
	if(!ret)
		CRASH("Failed to load map [tfile], check rust_log.txt")

/datum/bapi_parsed_map/Destroy()
	..()
	SSatoms.map_loader_stop(REF(src)) // Just in case, I don't want to double up here
	if(turf_blacklist)
		turf_blacklist.Cut()
	parsed_bounds.Cut()
	bounds.Cut()
	return QDEL_HINT_HARDDEL_NOW

/datum/bapi_parsed_map/proc/copy()
	// Avoids duped work just in case
	var/datum/bapi_parsed_map/newfriend = new()
	// use the same under-the-hood data
	newfriend._internal_index = _internal_index
	newfriend.original_path = original_path
	newfriend.map_format = map_format
	newfriend.key_len = key_len
	newfriend.line_len = line_len
	newfriend.parsed_bounds = parsed_bounds.Copy()
	// Copy parsed bounds to reset to initial values
	newfriend.bounds = parsed_bounds.Copy()
	newfriend.turf_blacklist = turf_blacklist?.Copy()
	// Explicitly do NOT copy `loaded` and `loaded_warnings`
	return newfriend

/datum/bapi_parsed_map/proc/load(
	x_offset = 1,
	y_offset = 1,
	z_offset = 1,
	crop_map = FALSE,
	no_changeturf = FALSE,
	x_lower = -INFINITY,
	x_upper = INFINITY,
	y_lower = -INFINITY,
	y_upper = INFINITY,
	z_lower = -INFINITY,
	z_upper = INFINITY,
	place_on_top = FALSE,
	new_z = FALSE,
)
	Master.StartLoadingMap()
	. = _load_impl(x_offset, y_offset, z_offset, crop_map, no_changeturf, x_lower, x_upper, y_lower, y_upper, z_lower, z_upper, place_on_top, new_z)
	Master.StopLoadingMap()

/datum/bapi_parsed_map/proc/_load_impl(
	x_offset = 1,
	y_offset = 1,
	z_offset = 1,
	crop_map = FALSE,
	no_changeturf = FALSE,
	x_lower = -INFINITY,
	x_upper = INFINITY,
	y_lower = -INFINITY,
	y_upper = INFINITY,
	z_lower = -INFINITY,
	z_upper = INFINITY,
	place_on_top = FALSE,
	new_z = FALSE,
)
	PRIVATE_PROC(TRUE)
	SSatoms.map_loader_begin(REF(src))

	// `loading` var handled by bapidmm
	var/resume_key = _bapidmm_load_map_buffered(
		src,
		x_offset,
		y_offset,
		z_offset,
		crop_map,
		no_changeturf,
		x_lower,
		x_upper,
		y_lower,
		y_upper,
		z_lower,
		z_upper,
		place_on_top,
		new_z
	)

	if(!resume_key)
		SSatoms.map_loader_stop(REF(src))
		CRASH("Failed to generate command buffer, check rust_log.txt and other runtimes")

	var/work_remaining = FALSE
	do
		work_remaining = _bapidmm_work_commandbuffer(src, resume_key)
		stoplag()
	while(work_remaining)

	SSatoms.map_loader_stop(REF(src))

	// if(new_z)
	// 	for(var/z_index in bounds[MAP_MINZ] to bounds[MAP_MAXZ])
	// 		SSmapping.build_area_turfs(z_index)

	// if(!no_changeturf)
	// 	var/list/turfs = block(
	// 		locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
	// 		locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))
	// 	for(var/turf/T as anything in turfs)
	// 		//we do this after we load everything in. if we don't, we'll have weird atmos bugs regarding atmos adjacent turfs
	// 		T.AfterChange(CHANGETURF_IGNORE_AIR)

	// if(expanded_x || expanded_y)
	// 	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_EXPANDED_WORLD_BOUNDS, expanded_x, expanded_y)

	return TRUE

/datum/bapi_parsed_map/proc/has_warnings()
	if(length(loaded_warnings))
		return TRUE
	return FALSE

// #undef MAP_DMM
// #undef MAP_TGM
// #undef MAP_UNKNOWN
