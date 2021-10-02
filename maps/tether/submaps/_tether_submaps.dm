 // This causes tether submap maps to get 'checked' and compiled, when undergoing a unit test.
// This is so CI can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.

//////////////////////////////////////////////////////////////////////////////
/// Static Load
/datum/map_template/tether_lateload/tether_misc
	name = "Tether - Misc"
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = 'tether_misc.dmm'

	associated_map_datum = /datum/map_z_level/tether_lateload/misc

/datum/map_z_level/tether_lateload/misc
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

#include "underdark_pois/_templates.dm"
#include "underdark_pois/underdark_things.dm"
/datum/map_template/tether_lateload/tether_underdark
	name = "Tether - Underdark"
	desc = "Mining, but harder."
	mappath = 'tether_underdark.dmm'

	associated_map_datum = /datum/map_z_level/tether_lateload/underdark

/datum/map_z_level/tether_lateload/underdark
	name = "Underdark"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/mineral/floor/virgo3b
	z = Z_LEVEL_UNDERDARK

/datum/map_template/tether_lateload/tether_underdark/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_UNDERDARK), 100, /area/mine/unexplored/underdark, /datum/map_template/underdark)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_UNDERDARK, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_UNDERDARK, 64, 64)         // Create the mining ore distribution map.

#include "../../submaps/surface_submaps/plains/plains.dm"
#include "../../submaps/surface_submaps/plains/plains_areas.dm"
#include "../../submaps/surface_submaps/plains/plains_turfs.dm"
/datum/map_template/tether_lateload/tether_plains
	name = "Tether - Plains"
	desc = "The Virgo 3B away mission."
	mappath = 'tether_plains.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/tether_plains

/datum/map_z_level/tether_lateload/tether_plains
	name = "Away Mission - Plains"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/mineral/floor/virgo3b
	z = Z_LEVEL_PLAINS

/datum/map_template/tether_lateload/tether_plains/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_PLAINS), 120, /area/tether/outpost/exploration_plains, /datum/map_template/surface/plains)

//////////////////////////////////////////////////////////////////////////////
//Antag/Event/ERT Areas

#include "../../submaps/admin_use_vr/ert.dm"
#include "../../submaps/admin_use_vr/mercship.dm"
#include "../../submaps/admin_use_vr/salamander_trader.dm"

/datum/map_template/admin_use/ert
	name = "Special Area - ERT"
	desc = "It's the ERT ship! Lorge."
	mappath = 'maps/submaps/admin_use_vr/ert.dmm'

/datum/map_template/admin_use/trader
	name = "Special Area - Trader"
	desc = "Big trader ship."
	mappath = 'maps/submaps/admin_use_vr/tradeship.dmm'

/datum/map_template/admin_use/salamander_trader
	name = "Special Area - Salamander Trader"
	desc = "Modest trader ship."
	mappath = 'maps/submaps/admin_use_vr/salamander_trader.dmm'

/datum/map_template/admin_use/mercenary
	name = "Special Area - Merc Ship"
	desc = "Prepare tae be boarded, arr!"
	mappath = 'maps/submaps/admin_use_vr/kk_mercship.dmm'

/datum/map_template/admin_use/skipjack
	name = "Special Area - Skipjack Base"
	desc = "Stinky!"
	mappath = 'maps/submaps/admin_use_vr/skipjack.dmm'

/datum/map_template/admin_use/thunderdome
	name = "Special Area - Thunderdome"
	desc = "Thunderrrrdomeee"
	mappath = 'maps/submaps/admin_use_vr/thunderdome.dmm'

/datum/map_template/admin_use/wizardbase
	name = "Special Area - Wizard Base"
	desc = "Wingardium Levosia"
	mappath = 'maps/submaps/admin_use_vr/wizard.dmm'

/datum/map_template/admin_use/dojo
	name = "Special Area - Ninja Dojo"
	desc = "Sneaky"
	mappath = 'maps/submaps/admin_use_vr/dojo.dmm'

//////////////////////////////////////////////////////////////////////////////
//Rogue Mines Stuff

/datum/map_template/tether_lateload/tether_roguemines1
	name = "Asteroid Belt 1"
	desc = "Mining, but rogue. Zone 1"
	mappath = 'maps/submaps/rogue_mines_vr/rogue_mine1.dmm'

	associated_map_datum = /datum/map_z_level/tether_lateload/roguemines1

/datum/map_z_level/tether_lateload/roguemines1
	name = "Belt 1"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_1

/datum/map_template/tether_lateload/tether_roguemines2
	name = "Asteroid Belt 2"
	desc = "Mining, but rogue. Zone 2"
	mappath = 'maps/submaps/rogue_mines_vr/rogue_mine2.dmm'

	associated_map_datum = /datum/map_z_level/tether_lateload/roguemines2

/datum/map_z_level/tether_lateload/roguemines2
	name = "Belt 2"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_2

//////////////////////////////////////////////////////////////////////////////
// Code Shenanigans for Tether lateload maps
/datum/map_template/tether_lateload
	allow_duplicates = FALSE
	var/associated_map_datum