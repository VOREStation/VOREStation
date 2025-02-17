// The aerostat shuttle
/area/shuttle/aerostat
	name = "\improper Aerostat Shuttle"

//The aerostat itself
/area/tether_away/aerostat
	name = "\improper Away Mission - Aerostat Outside"
	icon_state = "away"
	base_turf = /turf/unsimulated/floor/sky/virgo2_sky
	requires_power = FALSE
	dynamic_lighting = FALSE

/area/tether_away/aerostat/inside
	name = "\improper Away Mission - Aerostat Inside"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/plating/virgo2
	requires_power = TRUE
	dynamic_lighting = TRUE
	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/argitoth.ogg', 'sound/ambience/tension/burning_terror.ogg')

/area/tether_away/aerostat/solars
	name = "\improper Away Mission - Aerostat Solars"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/plating/virgo2
	dynamic_lighting = TRUE

/area/offmap/aerostat/surface
	flags = RAD_SHIELDED
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	base_turf = /turf/simulated/mineral/floor/ignore_mapgen/virgo2

/area/offmap/aerostat/surface/explored
	name = "Away Mission - Aerostat Surface (E)"
	icon_state = "explored"

/area/offmap/aerostat/surface/shuttleconsole
	name = "Away Mission - Aerostat Surface Console"
	icon_state = "explored"
	dynamic_lighting = FALSE
	requires_power = FALSE

/area/offmap/aerostat/surface/unexplored
	name = "Away Mission - Aerostat Surface (UE)"
	icon_state = "unexplored"

/area/offmap/aerostat/surface/outpost
	requires_power = TRUE
	dynamic_lighting = TRUE
	ambience = null

/area/offmap/aerostat/surface/outpost/backroom
	name = "V2 Outpost - Research Area"
/area/offmap/aerostat/surface/outpost/hallway
	name = "V2 Outpost - Hallway"
/area/offmap/aerostat/surface/outpost/cafe
	name = "V2 Outpost - Cafe"
/area/offmap/aerostat/surface/outpost/park
	name = "V2 Outpost - Park"
/area/offmap/aerostat/surface/outpost/officerone
	name = "V2 Outpost - Officer's Quarters 1"
/area/offmap/aerostat/surface/outpost/officertwo
	name = "V2 Outpost - Officer's Quarters 2"
/area/offmap/aerostat/surface/outpost/barracks
	name = "V2 Outpost - Barracks"
/area/offmap/aerostat/surface/outpost/airlock
	name = "V2 Outpost - Airlock"
/area/offmap/aerostat/surface/outpost/powerroom
	name = "V2 Outpost - Power Room"
/area/offmap/aerostat/surface/outpost/guardpost
	name = "V2 Outpost - Guard Post"

/area/offmap/aerostat/inside
	name = "\improper Away Mission - Aerostat Inside"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/plating/virgo2
	requires_power = TRUE
	dynamic_lighting = TRUE
//	forced_ambience = list('sound/ambience/tension/tension.ogg', 'sound/ambience/tension/argitoth.ogg', 'sound/ambience/tension/burning_terror.ogg')

/area/offmap/aerostat/inside
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "blublasqu"

/area/offmap/aerostat/inside/toxins
	name = "Toxins Lab"
	icon_state = "purwhisqu"

/area/offmap/aerostat/inside/xenoarch
	name = "Xenoarchaeolegy Lab"
	icon_state = "yelwhisqu"
/area/offmap/aerostat/inside/xenoarch/chamber
	name = "Xenoarchaeolegy Vent Chamber"

/area/offmap/aerostat/inside/genetics
	name = "Genetics Lab"
	icon_state = "grewhisqu"

/area/offmap/aerostat/inside/telesci
	name = "Telescience Lab"
	icon_state = "bluwhisqu"

/area/offmap/aerostat/inside/atmos
	name = "Atmospherics"
	icon_state = "orawhisqu"

/area/offmap/aerostat/inside/firingrange
	name = "Firing Range"
	icon_state = "orawhisqu"

/area/offmap/aerostat/inside/miscstorage
	name = "Miscellaneous Storage"
	icon_state = "orawhisqu"

/area/offmap/aerostat/inside/virology
	name = "Virology Lab"
	icon_state = "yelwhicir"

/area/offmap/aerostat/inside/south
	name = "Miscellaneous Labs A"
	icon_state = "blublasqu"

/area/offmap/aerostat/inside/south/b
	name = "Miscellaneous Labs B"
	icon_state = "blublasqu"


/area/offmap/aerostat/inside/powercontrol
	name = "Power Control"
	icon_state = "orawhicir"

/area/offmap/aerostat/inside/westhall
	name = "West Hall"
	icon_state = "orablacir"
/area/offmap/aerostat/inside/easthall
	name = "East Hall"
	icon_state = "orablacir"

/area/offmap/aerostat/inside/northchamb
	name = "North Chamber"
	icon_state = "orablacir"
/area/offmap/aerostat/inside/southchamb
	name = "South Chamber"
	icon_state = "orablacir"

/area/offmap/aerostat/inside/drillstorage
	name = "Drill Storage"
	icon_state = "orablacir"

/area/offmap/aerostat/inside/zorrenoffice
	name = "Zorren Reception"
	icon_state = "orablacir"

/area/offmap/aerostat/inside/lobby
	name = "Lobby"
	icon_state = "orablacir"
/area/offmap/aerostat/inside/xenobiolab
	name = "Xenobiology Lab"
	icon_state = "orablacir"

/area/offmap/aerostat/inside/airlock
	name = "Airlock"
	icon_state = "redwhicir"
/area/offmap/aerostat/inside/airlock/north
	name = "North Airlock"
/area/offmap/aerostat/inside/airlock/east
	name = "East Airlock"
/area/offmap/aerostat/inside/airlock/west
	name = "West Airlock"
/area/offmap/aerostat/inside/airlock/south
	name = "South Airlock"

/area/offmap/aerostat/inside/arm/ne
	name = "North-East Solar Arm"
/area/offmap/aerostat/inside/arm/nw
	name = "North-West Solar Arm"
/area/offmap/aerostat/inside/arm/se
	name = "South-East Solar Arm"
/area/offmap/aerostat/inside/arm/sw
	name = "South-West Solar Arm"

/area/offmap/aerostat/glassgetsitsownarea
	name = "Aerostat Glass"
	icon_state = "crew_quarters"
	base_turf = /turf/unsimulated/floor/sky/virgo2_sky
	dynamic_lighting = FALSE

/area/offmap/aerostat/solars
	name = "\improper Away Mission - Aerostat Solars"
	icon_state = "crew_quarters"
	base_turf = /turf/simulated/floor/plating/virgo2
	dynamic_lighting = FALSE

/area/sdmine
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	base_turf = /turf/simulated/mineral/floor/vacuum
/area/sdmine/unexplored
	name = "asteroid field"
	icon_state = "unexplored"
/area/sdmine/explored
	name = "asteroid field"
	icon_state = "explored"

/area/submap/space_rocks
	name = "POI - Space Rocks"
	ambience = AMBIENCE_FOREBODING

/area/submap/space_rocks/bittynest1
	name = "POI - Bittynest1"

/area/submap/space_rocks/bittynest2
	name = "POI - Bittynest2"

/area/submap/space_rocks/bittynest3
	name = "POI - Bittynest3"

/area/submap/space_rocks/bittynest4
	name = "POI - Bittynest4"

/area/submap/space_rocks/tunnel1
	name = "POI - Tunnel1"

/area/submap/space_rocks/tunnel2
	name = "POI - Tunnel2"

/area/submap/space_rocks/spacecrystals
	name = "POI - Space Crystals"

/area/submap/space_rocks/clearing
	name = "POI - Clearing"

/area/submap/space_rocks/seventemple
	name = "POI - Temple of the Seven"
