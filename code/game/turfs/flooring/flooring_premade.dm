/turf/simulated/floor/carpet
	name = "carpet"
	icon = 'icons/turf/flooring/carpet.dmi'
	icon_state = "carpet"
	initial_flooring = /decl/flooring/carpet

/turf/simulated/floor/carpet/bcarpet
	name = "black carpet"
	icon_state = "bcarpet"
	initial_flooring = /decl/flooring/carpet/bcarpet

/turf/simulated/floor/carpet/blucarpet
	name = "blue carpet"
	icon_state = "blucarpet"
	initial_flooring = /decl/flooring/carpet/blucarpet

/turf/simulated/floor/carpet/tealcarpet
	name = "teal carpet"
	icon_state = "tealcarpet"
	initial_flooring = /decl/flooring/carpet/tealcarpet

/turf/simulated/floor/carpet/geo
	name = "deco carpet"
	icon_state = "decocarpet"
	initial_flooring = /decl/flooring/carpet/geo

/turf/simulated/floor/carpet/retro
	name = "retro carpet"
	icon_state = "retrocarpet"
	initial_flooring = /decl/flooring/carpet/retro

// Legacy support for existing paths for blue carpet
/turf/simulated/floor/carpet/blue
	name = "blue carpet"
	icon_state = "blucarpet"
	initial_flooring = /decl/flooring/carpet/blucarpet

/turf/simulated/floor/carpet/turcarpet
	name = "tur carpet"
	icon_state = "turcarpet"
	initial_flooring = /decl/flooring/carpet/turcarpet

/turf/simulated/floor/carpet/sblucarpet
	name = "sblue carpet"
	icon_state = "sblucarpet"
	initial_flooring = /decl/flooring/carpet/sblucarpet

/turf/simulated/floor/carpet/gaycarpet
	name = "clown carpet"
	icon_state = "gaycarpet"
	initial_flooring = /decl/flooring/carpet/gaycarpet

/turf/simulated/floor/carpet/purcarpet
	name = "purple carpet"
	icon_state = "purcarpet"
	initial_flooring = /decl/flooring/carpet/purcarpet

/turf/simulated/floor/carpet/oracarpet
	name = "orange carpet"
	icon_state = "oracarpet"
	initial_flooring = /decl/flooring/carpet/oracarpet

/turf/simulated/floor/carpet/brown
	name = "brown carpet"
	icon_state = "brncarpet"
	initial_flooring = /decl/flooring/carpet/browncarpet

/turf/simulated/floor/carpet/blue2
	name = "blue carpet"
	icon_state = "blue1"
	initial_flooring = /decl/flooring/carpet/blucarpet2

/turf/simulated/floor/carpet/green
	name = "green carpet"
	icon_state = "green"
	initial_flooring = /decl/flooring/carpet/greencarpet

/turf/simulated/floor/carpet/purple
	name = "purple carpet"
	icon_state = "purple"
	initial_flooring = /decl/flooring/carpet/purplecarpet

/turf/simulated/floor/carpet/geo
	name = "geometric carpet"
	icon_state = "geocarpet"
	initial_flooring = /decl/flooring/carpet/geo

/turf/simulated/floor/carpet/retro
	name = "blue retro carpet"
	icon_state = "retrocarpet"
	initial_flooring = /decl/flooring/carpet/retro

/turf/simulated/floor/carpet/retro_red
	name = "red retro carpet"
	icon_state = "retrocarpet_red"
	initial_flooring = /decl/flooring/carpet/retro_red

/turf/simulated/floor/carpet/happy
	name = "happy carpet"
	icon_state = "happycarpet"
	initial_flooring = /decl/flooring/carpet/happy

/turf/simulated/floor/bluegrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "bcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit

/turf/simulated/floor/greengrid
	name = "mainframe floor"
	icon = 'icons/turf/flooring/circuit.dmi'
	icon_state = "gcircuit"
	initial_flooring = /decl/flooring/reinforced/circuit/green

/turf/simulated/floor/wood
	name = "wooden floor"
	icon = 'icons/turf/flooring/wood_vr.dmi'
	icon_state = "wood"
	initial_flooring = /decl/flooring/wood

/turf/simulated/floor/wood/broken
	icon_state = "wood-broken0" // This gets changed when spawned.

/turf/simulated/floor/wood/broken/LateInitialize()
	. = ..()
	break_tile()

/turf/simulated/floor/wood/sif
	name = "alien wooden floor"
	icon_state = "sifwood"
	initial_flooring = /decl/flooring/wood/sif

/turf/simulated/floor/wood/sif/broken
	icon_state = "sifwood-broken0" // This gets changed when spawned.

/turf/simulated/floor/wood/sif/broken/LateInitialize()
	. = ..()
	break_tile()

/turf/simulated/floor/wood/alt
	icon = 'icons/turf/flooring/wood.dmi'
	initial_flooring = /decl/flooring/wood/alt

/turf/simulated/floor/wood/alt/broken
	icon_state = "wood-broken0" // This gets changed when spawned.

/turf/simulated/floor/wood/alt/broken/LateInitialize()
	. = ..()
	break_tile()

/turf/simulated/floor/wood/alt/tile
	icon_state = "wood_tile"
	initial_flooring = /decl/flooring/wood/alt/tile

/turf/simulated/floor/wood/alt/tile/broken
	icon_state = "wood_tile-broken0" // This gets changed when spawned.

/turf/simulated/floor/wood/alt/tile/broken/LateInitialize()
	. = ..()
	break_tile()

/turf/simulated/floor/wood/alt/panel
	icon_state = "wood_panel"
	initial_flooring = /decl/flooring/wood/alt/panel

/turf/simulated/floor/wood/alt/panel/broken
	icon_state = "wood_panel-broken0" // This gets changed when spawned.

/turf/simulated/floor/wood/alt/panel/broken/LateInitialize()
	. = ..()
	break_tile()

/turf/simulated/floor/wood/alt/parquet
	icon_state = "wood_parquet"
	initial_flooring = /decl/flooring/wood/alt/parquet

/turf/simulated/floor/wood/alt/parquet/broken
	icon_state = "wood_parquet-broken0" // This gets changed when spawned.

/turf/simulated/floor/wood/alt/parquet/broken/LateInitialize()
	. = ..()
	break_tile()

/turf/simulated/floor/grass
	name = "grass patch"
	icon = 'icons/turf/flooring/grass.dmi'
	icon_state = "grass0"
	can_dirty = FALSE //VOREStation Edit
	initial_flooring = /decl/flooring/grass

/turf/simulated/floor/tiled
	name = "floor"
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "tiled"
	initial_flooring = /decl/flooring/tiling

/turf/simulated/floor/tiled/techmaint
	name = "floor"
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "techmaint"
	initial_flooring = /decl/flooring/tiling/new_tile/techmaint

/turf/simulated/floor/tiled/techfloor
	name = "floor"
	icon = 'icons/turf/flooring/techfloor.dmi'
	icon_state = "techfloor_gray"
	initial_flooring = /decl/flooring/tiling/tech

/turf/simulated/floor/tiled/monotile
	name = "floor"
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "monotile"
	initial_flooring = /decl/flooring/tiling/new_tile/monotile

/turf/simulated/floor/tiled/steel_grid
	name = "floor"
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "steel_grid"
	initial_flooring = /decl/flooring/tiling/new_tile/steel_grid

/turf/simulated/floor/tiled/steel_ridged
	name = "floor"
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "steel_ridged"
	initial_flooring = /decl/flooring/tiling/new_tile/steel_ridged

/turf/simulated/floor/tiled/old_tile
	name = "floor"
	icon_state = "tile_full"
	initial_flooring = /decl/flooring/tiling/new_tile
/turf/simulated/floor/tiled/old_tile/white
	color = "#d9d9d9"
/turf/simulated/floor/tiled/old_tile/blue
	color = "#8ba7ad"
/turf/simulated/floor/tiled/old_tile/yellow
	color = "#8c6d46"
/turf/simulated/floor/tiled/old_tile/gray
	color = "#687172"
/turf/simulated/floor/tiled/old_tile/beige
	color = "#385e60"
/turf/simulated/floor/tiled/old_tile/red
	color = "#964e51"
/turf/simulated/floor/tiled/old_tile/purple
	color = "#906987"
/turf/simulated/floor/tiled/old_tile/green
	color = "#46725c"



/turf/simulated/floor/tiled/old_cargo
	name = "floor"
	icon_state = "cargo_one_full"
	initial_flooring = /decl/flooring/tiling/new_tile/cargo_one
/turf/simulated/floor/tiled/old_cargo/white
	color = "#d9d9d9"
/turf/simulated/floor/tiled/old_cargo/blue
	color = "#8ba7ad"
/turf/simulated/floor/tiled/old_cargo/yellow
	color = "#8c6d46"
/turf/simulated/floor/tiled/old_cargo/gray
	color = "#687172"
/turf/simulated/floor/tiled/old_cargo/beige
	color = "#385e60"
/turf/simulated/floor/tiled/old_cargo/red
	color = "#964e51"
/turf/simulated/floor/tiled/old_cargo/purple
	color = "#906987"
/turf/simulated/floor/tiled/old_cargo/green
	color = "#46725c"


/turf/simulated/floor/tiled/kafel_full
	name = "floor"
	icon_state = "kafel_full"
	initial_flooring = /decl/flooring/tiling/new_tile/kafel
/turf/simulated/floor/tiled/kafel_full/white
	color = "#d9d9d9"
/turf/simulated/floor/tiled/kafel_full/blue
	color = "#8ba7ad"
/turf/simulated/floor/tiled/kafel_full/yellow
	color = "#8c6d46"
/turf/simulated/floor/tiled/kafel_full/gray
	color = "#687172"
/turf/simulated/floor/tiled/kafel_full/beige
	color = "#385e60"
/turf/simulated/floor/tiled/kafel_full/red
	color = "#964e51"
/turf/simulated/floor/tiled/kafel_full/purple
	color = "#906987"
/turf/simulated/floor/tiled/kafel_full/green
	color = "#46725c"


/turf/simulated/floor/tiled/techfloor/grid
	name = "floor"
	icon_state = "techfloor_grid"
	initial_flooring = /decl/flooring/tiling/tech/grid

/turf/simulated/floor/reinforced
	name = "reinforced floor"
	icon = 'icons/turf/flooring/tiles.dmi'
	icon_state = "reinforced"
	initial_flooring = /decl/flooring/reinforced

/turf/simulated/floor/reinforced/airless
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/reinforced/airmix
	oxygen = MOLES_O2ATMOS
	nitrogen = MOLES_N2ATMOS

/turf/simulated/floor/reinforced/nitrogen
	oxygen = 0
	nitrogen = ATMOSTANK_NITROGEN

/turf/simulated/floor/reinforced/oxygen
	oxygen = ATMOSTANK_OXYGEN
	nitrogen = 0

/turf/simulated/floor/reinforced/phoron
	oxygen = 0
	nitrogen = 0
	phoron = ATMOSTANK_PHORON

/turf/simulated/floor/reinforced/carbon_dioxide
	oxygen = 0
	nitrogen = 0
	carbon_dioxide = ATMOSTANK_CO2

/turf/simulated/floor/reinforced/n20
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/reinforced/n20/Initialize()
	. = ..()
	if(!air) make_air()
	air.adjust_gas("nitrous_oxide", ATMOSTANK_NITROUSOXIDE)

/turf/simulated/floor/cult
	name = "engraved floor"
	icon = 'icons/turf/flooring/cult.dmi'
	icon_state = "cult"
	initial_flooring = /decl/flooring/reinforced/cult

/turf/simulated/floor/cult/cultify()
	return

/turf/simulated/floor/tiled/dark
	name = "dark floor"
	icon_state = "dark"
	initial_flooring = /decl/flooring/tiling/dark

/turf/simulated/floor/tiled/hydro
	name = "hydro floor"
	icon_state = "hydrofloor"
	initial_flooring = /decl/flooring/tiling/hydro

/turf/simulated/floor/tiled/neutral
	name = "light floor"
	icon_state = "neutral"
	initial_flooring = /decl/flooring/tiling/neutral

/turf/simulated/floor/tiled/red
	name = "red floor"
	color = COLOR_RED_GRAY
	icon_state = "white"
	initial_flooring = /decl/flooring/tiling/red

/turf/simulated/floor/tiled/steel
	name = "steel floor"
	icon_state = "steel"
	initial_flooring = /decl/flooring/tiling/steel

/turf/simulated/floor/tiled/steel_dirty
	name = "steel floor"
	icon_state = "steel_dirty"
	initial_flooring = /decl/flooring/tiling/steel_dirty

/turf/simulated/floor/tiled/steel/airless
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/tiled/asteroid_steel
	icon_state = "asteroidfloor"
	initial_flooring = /decl/flooring/tiling/asteroidfloor

/turf/simulated/floor/tiled/asteroid_steel/airless
	name = "plating"
	oxygen = 0
	nitrogen = 0

/turf/simulated/floor/tiled/white
	name = "white floor"
	icon_state = "white"
	initial_flooring = /decl/flooring/tiling/white

/turf/simulated/floor/tiled/yellow
	name = "yellow floor"
	color = COLOR_BROWN
	icon_state = "white"
	initial_flooring = /decl/flooring/tiling/yellow

/turf/simulated/floor/tiled/freezer
	name = "tiles"
	icon_state = "freezer"
	initial_flooring = /decl/flooring/tiling/freezer

/turf/simulated/floor/lino
	name = "lino"
	icon = 'icons/turf/flooring/linoleum.dmi'
	icon_state = "lino"
	initial_flooring = /decl/flooring/linoleum

/turf/simulated/floor/wmarble
	name = "marble"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "lightmarble"
	initial_flooring = /decl/flooring/wmarble

/turf/simulated/floor/bmarble
	name = "marble"
	icon = 'icons/turf/flooring/misc.dmi'
	icon_state = "darkmarble"
	initial_flooring = /decl/flooring/bmarble

//ATMOS PREMADES
/turf/simulated/floor/reinforced/airless
	name = "vacuum floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/airless
	name = "plating"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/tiled/airless
	name = "floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/bluegrid/airless
	name = "floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/greengrid/airless
	name = "floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/greengrid/nitrogen
	oxygen = 0

/turf/simulated/floor/tiled/white/airless
	name = "floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

// Placeholders

/turf/simulated/floor/airless/lava
/turf/simulated/floor/light
/*
/turf/simulated/floor/beach
/turf/simulated/floor/beach/sand
/turf/simulated/floor/beach/sand/desert
/turf/simulated/floor/beach/coastline
/turf/simulated/floor/beach/water
/turf/simulated/floor/beach/water/ocean
*/
/turf/simulated/floor/airless/ceiling
/turf/simulated/floor/plating
/turf/simulated/floor/plating/external // To be overrided by the map files.
/turf/simulated/floor/tiled/external

//**** Here lives snow ****
/turf/simulated/floor/snow
	name = "snow"
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "snow"
	initial_flooring = /decl/flooring/snow
	var/list/crossed_dirs = list()

/turf/simulated/floor/snow/snow2
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"
	initial_flooring = /decl/flooring/snow

/turf/simulated/floor/snow/gravsnow
	name = "snow"
	icon_state = "gravsnow"
	initial_flooring = /decl/flooring/snow/gravsnow

/turf/simulated/floor/snow/plating
	name = "snowy playing"
	icon_state = "snowyplating"
	initial_flooring = /decl/flooring/snow/plating

/turf/simulated/floor/snow/plating/drift
	name = "snowy plating"
	icon_state = "snowyplayingdrift"
	initial_flooring = /decl/flooring/snow/plating/drift

// TODO: Move foortprints to a datum-component signal so they can actually be applied to other turf types, like sand, or mud
/turf/simulated/floor/snow/Entered(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.hovering) // Flying things shouldn't make footprints.
			return ..()
		var/mdir = "[A.dir]"
		crossed_dirs[mdir] = 1
		update_icon()
	. = ..()

/turf/simulated/floor/snow/update_icon()
	..()
	for(var/d in crossed_dirs)
		add_overlay(image(icon = 'icons/turf/outdoors.dmi', icon_state = "snow_footprints", dir = text2num(d)))

//**** Here ends snow ****
