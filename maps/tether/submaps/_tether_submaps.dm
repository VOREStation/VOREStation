 // This causes tether submap maps to get 'checked' and compiled, when undergoing a unit test.
// This is so CI can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.

//////////////////////////////////////////////////////////////////////////////
/// Static Load

/datum/map_template/tether_lateload/tether_centcom
	name = "Tether - Centcom"
	desc = "Central Command lives here!"
	mappath = "maps/tether/submaps/tether_centcom.dmm"

	associated_map_datum = /datum/map_z_level/tether_lateload/centcom

/datum/map_z_level/tether_lateload/centcom
	z = Z_LEVEL_CENTCOM
	name = "Centcom"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT
	base_turf = /turf/simulated/floor/outdoors/rocks

/datum/map_template/tether_lateload/tether_misc
	name = "Tether - Misc"
	desc = "Misc areas, like some transit areas, holodecks, merc area."
	mappath = "maps/tether/submaps/tether_misc.dmm"

	associated_map_datum = /datum/map_z_level/tether_lateload/misc

/datum/map_z_level/tether_lateload/misc
	z = Z_LEVEL_MISC
	name = "Misc"
	flags = MAP_LEVEL_ADMIN|MAP_LEVEL_SEALED|MAP_LEVEL_CONTACT|MAP_LEVEL_XENOARCH_EXEMPT

#include "underdark_pois/_templates.dm"
#include "underdark_pois/underdark_things.dm"
/datum/map_template/tether_lateload/tether_underdark
	name = "Tether - Underdark"
	desc = "Mining, but harder."
	mappath = "maps/tether/submaps/tether_underdark.dmm"

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
	new /datum/random_map/noise/ore/underdark(null, 1, 1, Z_LEVEL_UNDERDARK, 64, 64)         // Create the mining ore distribution map.

#include "../../submaps/surface_submaps/plains/plains_vr.dm"
#include "../../submaps/surface_submaps/plains/plains_areas.dm"
#include "../../submaps/surface_submaps/plains/plains_turfs.dm"
/datum/map_template/tether_lateload/tether_plains
	name = "Tether - Plains"
	desc = "The Virgo 3B away mission."
	mappath = "maps/tether/submaps/tether_plains.dmm"
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
	mappath = "maps/submaps/admin_use_vr/ert.dmm"

/datum/map_template/admin_use/trader
	name = "Special Area - Trader"
	desc = "Big trader ship."
	mappath = "maps/submaps/admin_use_vr/tradeship.dmm"

/datum/map_template/admin_use/salamander_trader
	name = "Special Area - Salamander Trader"
	desc = "Modest trader ship."
	mappath = "maps/submaps/admin_use_vr/salamander_trader.dmm"

/datum/map_template/admin_use/mercenary
	name = "Special Area - Merc Ship"
	desc = "Prepare tae be boarded, arr!"
	mappath = "maps/submaps/admin_use_vr/kk_mercship.dmm"

/datum/map_template/admin_use/skipjack
	name = "Special Area - Skipjack Base"
	desc = "Stinky!"
	mappath = "maps/submaps/admin_use_vr/skipjack.dmm"

/datum/map_template/admin_use/thunderdome
	name = "Special Area - Thunderdome"
	desc = "Thunderrrrdomeee"
	mappath = "maps/submaps/admin_use_vr/thunderdome.dmm"

/datum/map_template/admin_use/wizardbase
	name = "Special Area - Wizard Base"
	desc = "Wingardium Levosia"
	mappath = "maps/submaps/admin_use_vr/wizard.dmm"

/datum/map_template/admin_use/dojo
	name = "Special Area - Ninja Dojo"
	desc = "Sneaky"
	mappath = "maps/submaps/admin_use_vr/dojo.dmm"

//////////////////////////////////////////////////////////////////////////////
//Rogue Mines Stuff

/datum/map_template/tether_lateload/tether_roguemines1
	name = "Asteroid Belt 1"
	desc = "Mining, but rogue. Zone 1"
	mappath = "maps/submaps/rogue_mines_vr/rogue_mine1.dmm"

	associated_map_datum = /datum/map_z_level/tether_lateload/roguemines1

/datum/map_z_level/tether_lateload/roguemines1
	name = "Belt 1"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_1

/datum/map_template/tether_lateload/tether_roguemines2
	name = "Asteroid Belt 2"
	desc = "Mining, but rogue. Zone 2"
	mappath = "maps/submaps/rogue_mines_vr/rogue_mine2.dmm"

	associated_map_datum = /datum/map_z_level/tether_lateload/roguemines2

/datum/map_z_level/tether_lateload/roguemines2
	name = "Belt 2"
	flags = MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER
	z = Z_LEVEL_ROGUEMINE_2

//////////////////////////////////////////////////////////////////////////////////////
// Code Shenanigans for Tether lateload maps
/datum/map_template/tether_lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/datum/map_template/tether_lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(using_map, z)

/datum/map_z_level/tether_lateload
	z = 0

/datum/map_z_level/tether_lateload/New(var/datum/map/map, mapZ)
	if(mapZ && !z)
		z = mapZ
	return ..(map)

/obj/effect/step_trigger/zlevel_fall //Don't ever use this, only use subtypes.Define a new var/static/target_z on each
	affect_ghosts = 1

/obj/effect/step_trigger/zlevel_fall/Initialize()
	. = ..()

	if(istype(get_turf(src), /turf/simulated/floor))
		src:target_z = z
		return INITIALIZE_HINT_QDEL

/obj/effect/step_trigger/zlevel_fall/Trigger(var/atom/movable/A) //mostly from /obj/effect/step_trigger/teleporter/planetary_fall, step_triggers.dm L160
	if(!src:target_z)
		return

	var/attempts = 100
	var/turf/simulated/T
	while(attempts && !T)
		var/turf/simulated/candidate = locate(rand(5,world.maxx-5),rand(5,world.maxy-5),src:target_z)
		if(candidate.density)
			attempts--
			continue

		T = candidate
		break

	if(!T)
		return

	if(isobserver(A))
		A.forceMove(T) // Harmlessly move ghosts.
		return

	A.forceMove(T)
	if(isliving(A)) // Someday, implement parachutes.  For now, just turbomurder whoever falls.
		message_admins("\The [A] fell out of the sky.")
		var/mob/living/L = A
		L.fall_impact(T, 42, 90, FALSE, TRUE)	//You will not be defibbed from this.

#include "../../expedition_vr/aerostat/_aerostat.dm"
/datum/map_template/tether_lateload/away_aerostat
	name = "Remmi Aerostat - Z1 Aerostat"
	desc = "The Virgo 2 Aerostat away mission."
	mappath = "maps/expedition_vr/aerostat/aerostat.dmm"
	associated_map_datum = /datum/map_z_level/tether_lateload/away_aerostat

/datum/map_z_level/tether_lateload/away_aerostat
	name = "Away Mission - Aerostat"
	z = Z_LEVEL_AEROSTAT
	base_turf = /turf/unsimulated/floor/sky/virgo2_sky

/datum/map_template/tether_lateload/away_aerostat_surface
	name = "Remmi Aerostat - Z2 Surface"
	desc = "The surface from the Virgo 2 Aerostat."
	mappath = "maps/expedition_vr/aerostat/surface.dmm"
	associated_map_datum = /datum/map_z_level/tether_lateload/away_aerostat_surface

/datum/map_template/tether_lateload/away_aerostat_surface/on_map_loaded(z)
	. = ..()
	seed_submaps(list(Z_LEVEL_AEROSTAT_SURFACE), 120, /area/offmap/aerostat/surface/unexplored, /datum/map_template/virgo2)
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, Z_LEVEL_AEROSTAT_SURFACE, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore/virgo2(null, 1, 1, Z_LEVEL_AEROSTAT_SURFACE, 64, 64)

/datum/map_z_level/tether_lateload/away_aerostat_surface
	name = "Away Mission - Aerostat Surface"
	z = Z_LEVEL_AEROSTAT_SURFACE
	base_turf = /turf/simulated/mineral/floor/ignore_mapgen/virgo2
