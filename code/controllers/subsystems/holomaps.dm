//
// Holo-Minimaps Generation Subsystem handles initialization of the holo minimaps.
// Look in code/modules/holomap/generate_holomap.dm to find generateHoloMinimaps()
//
SUBSYSTEM_DEF(holomaps)
	name = "HoloMiniMaps"
	init_order = INIT_ORDER_HOLOMAPS
	flags = SS_NO_FIRE
	var/static/holomaps_initialized = FALSE
	var/static/list/holoMiniMaps = list()
	var/static/list/extraMiniMaps = list()
	var/static/list/station_holomaps = list()

/datum/controller/subsystem/holomaps/Recover()
	flags |= SS_NO_INIT // Make extra sure we don't initialize twice.

/datum/controller/subsystem/holomaps/Initialize()
	generateHoloMinimaps()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/holomaps/stat_entry(msg)
	if (!GLOB.Debug2)
		return // Only show up in stat panel if debugging is enabled.
	. = ..()

/datum/controller/subsystem/holomaps/proc/dump_nanomap_icons()
	. = list()

	for(var/z = 1 to world.maxz)
		var/icon/base = icon(HOLOMAP_ICON, "blank") // start at 480x480
		base.Scale(world.maxx, world.maxy) // scale down to perfectly fit the map size

		var/icon/walls = icon(holoMiniMaps[z])
		var/icon/areas = extraMiniMaps["[HOLOMAP_EXTRA_STATIONMAPAREAS]_[z]"]

		base.Blend(walls, ICON_OVERLAY)
		if(areas)
			base.Blend(areas, ICON_OVERLAY)

		var/fname = "data/spritesheets/minimap_[z].png"

		// Copy to a file
		fcopy(base, fname)

		// Strip DMI metadata to prevent any ~issues~
		var/error = rustg_dmi_strip_metadata(fname)
		if(length(error))
			stack_trace("Failed to strip [fname]: [error]")

		.["minimap_[z].png"] = fname
