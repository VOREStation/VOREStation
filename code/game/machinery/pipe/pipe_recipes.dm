//
// Recipies for Pipe Dispenser and (someday) the RPD
//

var/global/list/atmos_pipe_recipes = null

/hook/startup/proc/init_pipe_recipes()
	global.atmos_pipe_recipes = list(
		"Pipes" = list(
			new /datum/pipe_recipe/pipe("Pipe",				/obj/machinery/atmospherics/pipe/simple),
			new /datum/pipe_recipe/pipe("Manifold",			/obj/machinery/atmospherics/pipe/manifold),
			new /datum/pipe_recipe/pipe("Manual Valve",		/obj/machinery/atmospherics/valve),
			new /datum/pipe_recipe/pipe("Digital Valve",		/obj/machinery/atmospherics/valve/digital),
			new /datum/pipe_recipe/pipe("Pipe cap",			/obj/machinery/atmospherics/pipe/cap),
			new /datum/pipe_recipe/pipe("4-Way Manifold",		/obj/machinery/atmospherics/pipe/manifold4w),
			new /datum/pipe_recipe/pipe("Manual T-Valve",		/obj/machinery/atmospherics/tvalve),
			new /datum/pipe_recipe/pipe("Digital T-Valve",	/obj/machinery/atmospherics/tvalve/digital),
			new /datum/pipe_recipe/pipe("Upward Pipe",		/obj/machinery/atmospherics/pipe/zpipe/up),
			new /datum/pipe_recipe/pipe("Downward Pipe",		/obj/machinery/atmospherics/pipe/zpipe/down),
			new /datum/pipe_recipe/pipe("Universal Pipe Adaptor",	/obj/machinery/atmospherics/pipe/simple/visible/universal),
		),
		"Devices" = list(
			new /datum/pipe_recipe/pipe("Connector",			/obj/machinery/atmospherics/portables_connector),
			new /datum/pipe_recipe/pipe("Unary Vent",			/obj/machinery/atmospherics/unary/vent_pump),
			new /datum/pipe_recipe/pipe("Passive Vent",		/obj/machinery/atmospherics/pipe/vent),
			new /datum/pipe_recipe/pipe("Injector",			/obj/machinery/atmospherics/unary/outlet_injector),
			new /datum/pipe_recipe/pipe("Gas Pump",			/obj/machinery/atmospherics/binary/pump),
			new /datum/pipe_recipe/pipe("Pressure Regulator",	/obj/machinery/atmospherics/binary/passive_gate),
			new /datum/pipe_recipe/pipe("High Power Gas Pump",/obj/machinery/atmospherics/binary/pump/high_power),
			//new /datum/pipe_recipe/pipe("Automatic Shutoff Valve",/obj/machinery/atmospherics/valve/shutoff),	//VOREStation Removal: Without leaks, those are just regular valves,
			new /datum/pipe_recipe/pipe("Scrubber",			/obj/machinery/atmospherics/unary/vent_scrubber),
			new /datum/pipe_recipe/meter("Meter"),
			new /datum/pipe_recipe/pipe("Gas Filter",			/obj/machinery/atmospherics/trinary/atmos_filter),
			new /datum/pipe_recipe/pipe("Gas Mixer",			/obj/machinery/atmospherics/trinary/mixer),
			new /datum/pipe_recipe/pipe("Gas Mixer 'T'",		/obj/machinery/atmospherics/trinary/mixer/t_mixer),
			new /datum/pipe_recipe/pipe("Omni Gas Mixer",		/obj/machinery/atmospherics/omni/mixer),
			new /datum/pipe_recipe/pipe("Omni Gas Filter",	/obj/machinery/atmospherics/omni/atmos_filter),
		),
		"Heat Exchange" = list(
			new /datum/pipe_recipe/pipe("Pipe",				/obj/machinery/atmospherics/pipe/simple/heat_exchanging),
			new /datum/pipe_recipe/pipe("Junction",			/obj/machinery/atmospherics/pipe/simple/heat_exchanging/junction),
			new /datum/pipe_recipe/pipe("Heat Exchanger",		/obj/machinery/atmospherics/unary/heat_exchanger),
		),
		"Insulated pipes" = list(
			new /datum/pipe_recipe/pipe("Pipe",				/obj/machinery/atmospherics/pipe/simple/insulated),
		)
	)
	return TRUE

//
// New method of handling pipe construction.  Instead of numeric constants and a giant switch statement of doom
// 	every pipe type has a datum instance which describes its name, placement rules and construction method, dispensing etc.
// The advantages are obvious, mostly in simplifying the code of the dispenser, and the ability to add new pipes without hassle.
//
/datum/pipe_recipe
	var/name = "Abstract Pipe (fixme)"	// Recipe name
	var/dirtype					// If using an RPD, this tells more about what previews to show.

// Render an HTML link to select this pipe type. Returns text.
/datum/pipe_recipe/proc/Render(dispenser)
	return "<A href='?src=\ref[dispenser]&[Params()]'>[name]</A><BR>"

// Parameters for the Topic link returned by Render().  Returns text.
/datum/pipe_recipe/proc/Params()
	return ""

//
// Subtype for actual pipes
//
/datum/pipe_recipe/pipe
	var/obj/item/pipe/construction_type 		// The type PATH to the type of pipe fitting object the recipe makes.
	var/obj/machinery/atmospherics/pipe_type	// The type PATH of what actual pipe the fitting becomes.

/datum/pipe_recipe/pipe/New(var/label, var/obj/machinery/atmospherics/path)
	name = label
	pipe_type = path
	construction_type = initial(path.construction_type)
	dirtype = initial(construction_type.dispenser_class)

// Render an HTML link to select this pipe type
/datum/pipe_recipe/pipe/Render(dispenser)
	var/dat = ..(dispenser)
	// Stationary pipe dispensers don't allow you to pre-select pipe directions.
	// This makes it impossble to spawn bent versions of bendable pipes.
	// We add a "Bent" pipe type with a preset diagonal direction to work around it.
	if(istype(dispenser, /obj/machinery/pipedispenser) && (dirtype == PIPE_BENDABLE))
		dat += "<A href='?src=\ref[dispenser]&[Params()]&dir=[NORTHEAST]'>Bent [name]</A><BR>"
	return dat

/datum/pipe_recipe/pipe/Params()
	return "makepipe=[pipe_type]"

//
// Subtype for meters
//
/datum/pipe_recipe/meter
	dirtype = PIPE_ONEDIR

/datum/pipe_recipe/meter/New(label)
	name = label

/datum/pipe_recipe/meter/Params()
	return "makemeter=1"
