As of 8/25/2020, the map folders have been reworked to allow expedition areas and POIs to be shared between maps. The major improvement is that in new mapping projects, as long as the mapsize is the same (140x140), you are able to load POIs from Tether on another map.

This does introduce some changes, and I'll walk you through adding a NEW expedition area in the new system.

## EXPEDITION AREAS:
In order to add a new expedition area, we need to go to maps/expedition_vr and create a new folder.

This will house our expedition map, as well as any map-specific code, and our submap pointing.

In order to 'point' an expedition area to load a submap, you will need to ensure the following:

#include "../../submaps/pois_vr/expedition_area_name/_template_name.dm"

This tells us "go to root, maps, submaps, pois_vr, mapname, and use _template_name.dm"

Then simply place your poi's in the expedition_area_name folder as you would with any other POI. Easy way to do it is to look at the others.

## GATEWAY MAPS:
In order to add a new gateway area, we need to go to maps/gateway_vr and create a new .dm and .dmm for our map.

Follow one of the existing gateway maps to configure your new map. DO NOT USE GATEWAY_ARCHIVE_VR as that is outdated/broken gateway maps.

## Folders listed as follows:
~map_system: Polaris, do not touch
example: Polaris, do not touch
expedition_vr: VORE, our expedition areas (shared between station maps)
gateway_archive_vr: Do not touch, broken gateway maps
gateway_vr: VORE, our gateway maps
nothern_star: Polaris, do not touch
offmap_vr: VORE, Offmap ships such as Talon, the overmaps ships, and Guttersite, once it's converted to offmap spawn.
overmap: Do not touch, ask maintainers.
plane: Polaris, do not touch
RandomZLevels: Polaris, do not touch
southern_cross: Polaris, do not touch
submaps: All our submaps. non _vr files are Polaris, do not touch them.
tether: VORE, Our map, self-explanatory
virgo_minitest: VORE, Testing map used for CI, do not touch

## What _submaps.dm (map-folder-specific, Tether uses _tether_submaps.dm) should look like:

# Map-specific areas should be loaded without a #include, and the mappath should just be:
mappath = 'tether_plains.dmm'

# Non-map specific expedition areas should be loaded as follows:

/// Away Missions
#ifdef AWAY_MISSION_TEST
#include "../../expedition_vr/beach/beach.dmm"
#include "../../expedition_vr/beach/cave.dmm"
#include "../../expedition_vr/alienship/alienship.dmm"
#include "../../expedition_vr/aerostat/aerostat.dmm"
#include "../../expedition_vr/aerostat/surface.dmm"
#include "../../expedition_vr/space/debrisfield.dmm"
#include "../../expedition_vr/space/fueldepot.dmm"
#include "../../expedition_vr/space/guttersite.dmm"
#endif

#include "../../expedition_vr/beach/_beach.dm"
/datum/map_template/tether_lateload/away_beach
	name = "Desert Planet - Z1 Beach"
	desc = "The beach away mission."
	mappath = 'maps/expedition_vr/beach/beach.dmm'
	associated_map_datum = /datum/map_z_level/tether_lateload/away_beach

/datum/map_z_level/tether_lateload/away_beach
	name = "Away Mission - Desert Beach"
	z = Z_LEVEL_BEACH
	base_turf = /turf/simulated/floor/outdoors/rocks/caves
