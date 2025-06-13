GLOBAL_DATUM_INIT(gas_data, /datum/xgm_gas_data, new())

/datum/xgm_gas_data
	//Simple list of all the gas IDs.
	var/list/gases = list()
	//The friendly, human-readable name for the gas.
	var/list/name = list()
	//Specific heat of the gas.  Used for calculating heat capacity.
	var/list/specific_heat = list()
	//Molar mass of the gas.  Used for calculating specific entropy.
	var/list/molar_mass = list()
	//Tile overlays.  /images, created from references to 'icons/effects/tile_effects.dmi'
	var/list/tile_overlay = list()
	//Overlay limits.  There must be at least this many moles for the overlay to appear.
	var/list/overlay_limit = list()
	//Flags.
	var/list/flags = list()

/datum/xgm_gas_data/New()
	. = ..()
	for(var/p in subtypesof(/decl/xgm_gas))
		var/decl/xgm_gas/gas = new p //avoid initial() because of potential New() actions

		if(gas.id in gases)
			error("Duplicate gas id `[gas.id]` in `[p]`")

		gases += gas.id
		name[gas.id] = gas.name
		specific_heat[gas.id] = gas.specific_heat
		molar_mass[gas.id] = gas.molar_mass
		if(gas.tile_overlay)
			var/atom/movable/gas_visuals/GV = new(null)
			GV.icon_state = gas.tile_overlay
			tile_overlay[gas.id] = GV
		if(gas.overlay_limit)
			overlay_limit[gas.id] = gas.overlay_limit
		flags[gas.id] = gas.flags

	return 1

/decl/xgm_gas
	var/id = ""
	var/name = "Unnamed Gas"
	var/specific_heat = 20	// J/(mol*K)
	var/molar_mass = 0.032	// kg/mol

	var/tile_overlay = null
	var/overlay_limit = null

	var/flags = 0

/atom/movable/gas_visuals
	icon = 'icons/effects/tile_effects.dmi'
	mouse_opacity = 0
	plane = ABOVE_MOB_PLANE
