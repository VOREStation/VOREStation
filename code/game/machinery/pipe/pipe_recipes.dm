//
// Recipies for Pipe Dispenser and (someday) the RPD
//

GLOBAL_LIST_INIT(atmos_pipe_recipes, list(
	"Pipes" = list(
		new /datum/pipe_recipe/pipe("Pipe",					/obj/machinery/atmospherics/pipe/simple),
		new /datum/pipe_recipe/pipe("Manifold",				/obj/machinery/atmospherics/pipe/manifold),
		new /datum/pipe_recipe/pipe("Manual Valve",			/obj/machinery/atmospherics/valve),
		new /datum/pipe_recipe/pipe("Digital Valve",		/obj/machinery/atmospherics/valve/digital),
		new /datum/pipe_recipe/pipe("Pipe cap",				/obj/machinery/atmospherics/pipe/cap),
		new /datum/pipe_recipe/pipe("4-Way Manifold",		/obj/machinery/atmospherics/pipe/manifold4w),
		new /datum/pipe_recipe/pipe("Manual T-Valve",		/obj/machinery/atmospherics/tvalve),
		new /datum/pipe_recipe/pipe("Digital T-Valve",		/obj/machinery/atmospherics/tvalve/digital),
		new /datum/pipe_recipe/pipe("Upward Pipe",			/obj/machinery/atmospherics/pipe/zpipe/up),
		new /datum/pipe_recipe/pipe("Downward Pipe",		/obj/machinery/atmospherics/pipe/zpipe/down),
		new /datum/pipe_recipe/pipe("Universal Pipe Adaptor",/obj/machinery/atmospherics/pipe/simple/visible/universal),
	),
	"Devices" = list(
		new /datum/pipe_recipe/pipe("Connector",			/obj/machinery/atmospherics/portables_connector),
		new /datum/pipe_recipe/pipe("Unary Vent",			/obj/machinery/atmospherics/unary/vent_pump),
		new /datum/pipe_recipe/pipe("Aux Vent",				/obj/machinery/atmospherics/unary/vent_pump/aux),
		new /datum/pipe_recipe/pipe("Passive Vent",			/obj/machinery/atmospherics/pipe/vent),
		new /datum/pipe_recipe/pipe("Injector",				/obj/machinery/atmospherics/unary/outlet_injector),
		new /datum/pipe_recipe/pipe("Gas Pump",				/obj/machinery/atmospherics/binary/pump),
		new /datum/pipe_recipe/pipe("Fuel Pump",			/obj/machinery/atmospherics/binary/pump/fuel),
		new /datum/pipe_recipe/pipe("Aux Pump",				/obj/machinery/atmospherics/binary/pump/aux),
		new /datum/pipe_recipe/pipe("Pressure Regulator",	/obj/machinery/atmospherics/binary/passive_gate),
		new /datum/pipe_recipe/pipe("High Power Gas Pump",	/obj/machinery/atmospherics/binary/pump/high_power),
		new /datum/pipe_recipe/pipe("Automatic Shutoff Valve",/obj/machinery/atmospherics/valve/shutoff),
		new /datum/pipe_recipe/pipe("Scrubber",				/obj/machinery/atmospherics/unary/vent_scrubber),
		new /datum/pipe_recipe/meter("Meter"),
		new /datum/pipe_recipe/pipe("Gas Filter",			/obj/machinery/atmospherics/trinary/atmos_filter),
		new /datum/pipe_recipe/pipe("Gas Mixer",			/obj/machinery/atmospherics/trinary/mixer),
		new /datum/pipe_recipe/pipe("Gas Mixer 'T'",		/obj/machinery/atmospherics/trinary/mixer/t_mixer),
		new /datum/pipe_recipe/pipe("Omni Gas Mixer",		/obj/machinery/atmospherics/omni/mixer),
		new /datum/pipe_recipe/pipe("Omni Gas Filter",		/obj/machinery/atmospherics/omni/atmos_filter),
	),
	"Heat Exchange" = list(
		new /datum/pipe_recipe/pipe("Pipe",					/obj/machinery/atmospherics/pipe/simple/heat_exchanging),
		new /datum/pipe_recipe/pipe("Junction",				/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction),
		new /datum/pipe_recipe/pipe("Heat Exchanger",		/obj/machinery/atmospherics/unary/heat_exchanger),
	),
	"Insulated pipes" = list(
		new /datum/pipe_recipe/pipe("Pipe",					/obj/machinery/atmospherics/pipe/simple/insulated),
	)
))

GLOBAL_LIST_INIT(disposal_pipe_recipes, list(
	"Disposal Pipes" = list(
		new /datum/pipe_recipe/disposal("Pipe",						DISPOSAL_PIPE_STRAIGHT, "conpipe-s", PIPE_STRAIGHT),
		new /datum/pipe_recipe/disposal("Bent Pipe",				DISPOSAL_PIPE_CORNER, "conpipe-c"),
		new /datum/pipe_recipe/disposal("Junction",					DISPOSAL_PIPE_JUNCTION, "conpipe-j1", PIPE_TRIN_M),
		new /datum/pipe_recipe/disposal("Y-Junction",				DISPOSAL_PIPE_JUNCTION_Y, "conpipe-y"),
		new /datum/pipe_recipe/disposal("Sort Junction",			DISPOSAL_PIPE_SORTER, "conpipe-j1s", PIPE_TRIN_M, DISPOSAL_SORT_NORMAL),
		new /datum/pipe_recipe/disposal("Sort Junction (Wildcard)",	DISPOSAL_PIPE_SORTER, "conpipe-j1s", PIPE_TRIN_M, DISPOSAL_SORT_WILDCARD),
		new /datum/pipe_recipe/disposal("Sort Junction (Untagged)",	DISPOSAL_PIPE_SORTER, "conpipe-j1s", PIPE_TRIN_M, DISPOSAL_SORT_UNTAGGED),
		new /datum/pipe_recipe/disposal("Tagger",					DISPOSAL_PIPE_TAGGER, "pipe-tagger", PIPE_STRAIGHT),
		new /datum/pipe_recipe/disposal("Tagger (Partial)",			DISPOSAL_PIPE_TAGGER_PARTIAL, "pipe-tagger-partial", PIPE_STRAIGHT),
		new /datum/pipe_recipe/disposal("Trunk",					DISPOSAL_PIPE_TRUNK, "conpipe-t"),
		new /datum/pipe_recipe/disposal("Upwards",					DISPOSAL_PIPE_UPWARD, "pipe-u"),
		new /datum/pipe_recipe/disposal("Downwards",				DISPOSAL_PIPE_DOWNWARD, "pipe-d"),
		new /datum/pipe_recipe/disposal("Bin",						DISPOSAL_PIPE_BIN, "disposal", PIPE_ONEDIR),
		new /datum/pipe_recipe/disposal("Outlet",					DISPOSAL_PIPE_OUTLET, "outlet"),
		new /datum/pipe_recipe/disposal("Chute",					DISPOSAL_PIPE_CHUTE, "intake"),
	)
))

//
// New method of handling pipe construction.  Instead of numeric constants and a giant switch statement of doom
// 	every pipe type has a datum instance which describes its name, placement rules and construction method, dispensing etc.
// The advantages are obvious, mostly in simplifying the code of the dispenser, and the ability to add new pipes without hassle.
// icon_state and icon_state_m must be from among those available from the dmi files included in /datum/asset/iconsheet/pipes
//
/datum/pipe_recipe
	var/name = "Abstract Pipe (fixme)"	// Recipe name
	var/icon_state = null				// This tells the RPD what kind of pipe icon to render for the preview.
	var/icon_state_m = null				// This stores the mirrored version of the regular state (if available).
	var/dirtype							// If using an RPD, this tells more about what previews to show.
	var/pipe_type

// Get preview for UIs
/datum/pipe_recipe/proc/get_preview(selected_dir)
	var/list/dirs
	switch(dirtype)
		if(PIPE_STRAIGHT, PIPE_BENDABLE)
			dirs = list("[NORTH]" = "Vertical", "[EAST]" = "Horizontal")
			if(dirtype == PIPE_BENDABLE)
				dirs += list("[NORTHWEST]" = "West to North", "[NORTHEAST]" = "North to East",
							"[SOUTHWEST]" = "South to West", "[SOUTHEAST]" = "East to South")
		if(PIPE_TRINARY)
			dirs = list("[NORTH]" = "West South East", "[SOUTH]" = "East North West",
						"[EAST]" = "North West South", "[WEST]" = "South East North")
		if(PIPE_TRIN_M)
			dirs = list("[NORTH]" = "North East South", "[SOUTHWEST]" = "North West South",
						"[NORTHEAST]" = "South East North", "[SOUTH]" = "South West North",
						"[WEST]" = "West North East", "[SOUTHEAST]" = "West South East",
						"[NORTHWEST]" = "East North West", "[EAST]" = "East South West",)
		if(PIPE_DIRECTIONAL)
			dirs = list("[NORTH]" = "North", "[SOUTH]" = "South", "[WEST]" = "West", "[EAST]" = "East")
		if(PIPE_ONEDIR)
			dirs = list("[SOUTH]" = name)
		if(PIPE_UNARY_FLIPPABLE)
			dirs = list("[NORTH]" = "North", "[EAST]" = "East", "[SOUTH]" = "South", "[WEST]" = "West",
						"[NORTHEAST]" = "North Flipped", "[SOUTHEAST]" = "East Flipped", "[SOUTHWEST]" = "South Flipped", "[NORTHWEST]" = "West Flipped")


	var/list/rows = list()
	var/list/row = list("previews" = list())
	var/i = 0
	for(var/dir in dirs)
		var/numdir = text2num(dir)
		var/flipped = ((dirtype == PIPE_TRIN_M) || (dirtype == PIPE_UNARY_FLIPPABLE)) && (numdir in GLOB.cornerdirs)
		row["previews"] += list(list("selected" = (numdir == selected_dir), "dir" = dir2text(numdir), "dir_name" = dirs[dir], "icon_state" = icon_state, "flipped" = flipped))
		if(i++ || dirtype == PIPE_ONEDIR)
			rows += list(row)
			row = list("previews" = list())
			i = 0

	return rows

//
// Subtype for actual pipes
//
/datum/pipe_recipe/pipe
	var/obj/item/pipe/construction_type 		// The type PATH to the type of pipe fitting object the recipe makes.
	var/paintable = FALSE						// If TRUE, allow the RPD to paint this pipe.	// VOREStation Add

/datum/pipe_recipe/pipe/New(var/label, var/obj/machinery/atmospherics/path)
	name = label
	pipe_type = path
	construction_type = initial(path.construction_type)
	icon_state = initial(path.pipe_state)
	dirtype = initial(construction_type.dispenser_class)
	if (dirtype == PIPE_TRIN_M)
		icon_state_m = "[icon_state]m"
	paintable = !ispath(path, /obj/machinery/atmospherics/pipe/simple/heat_exchanging) && ispath(path, /obj/machinery/atmospherics/pipe) && !(ispath(path, /obj/machinery/atmospherics/pipe/vent))	// VOREStation Add


//
// Subtype for meters
//
/datum/pipe_recipe/meter
	dirtype = PIPE_ONEDIR
	icon_state = "meter"
	pipe_type = /obj/item/pipe_meter

/datum/pipe_recipe/meter/New(label)
	name = label

//
// Subtype for disposal pipes
//
/datum/pipe_recipe/disposal
	var/subtype			// subtype is one of the DISPOSAL_SORT_ constants.

/datum/pipe_recipe/disposal/New(var/label, var/ptype, var/state, dt=PIPE_DIRECTIONAL, var/sort=0)
	name = label
	icon_state = state
	pipe_type = ptype
	dirtype = dt
	subtype = sort
	if (dirtype == PIPE_TRIN_M)
		icon_state_m = replacetext(state, "j1", "j2")
