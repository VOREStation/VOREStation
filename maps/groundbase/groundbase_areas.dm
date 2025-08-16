/area/groundbase
	name = "Groundbase"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "blublacir"
	requires_power = TRUE
	dynamic_lighting = TRUE
	ambience = AMBIENCE_RUINS
	base_turf = /turf/simulated/mineral/floor/virgo3c

/area/maintenance/groundbase
	name = "Maintenance"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "purblasqu"
	flags = RAD_SHIELDED
	ambience = AMBIENCE_RUINS
	flags = AREA_FLAG_IS_NOT_PERSISTENT
	base_turf = /turf/simulated/mineral/floor/virgo3c

/area/groundbase/level1
	name = "Rascal's Pass Level 1"
	flags = AREA_FLAG_IS_NOT_PERSISTENT
	sound_env = SOUND_ENVIRONMENT_MOUNTAINS

/area/groundbase/level1/ne
	name = "Northeast Rascal's Pass Level 1"
/area/groundbase/level1/nw
	name = "Northwest Rascal's Pass Level 1"
/area/groundbase/level1/se
	name = "Southeast Rascal's Pass Level 1"
/area/groundbase/level1/sw
	name = "Southwest Rascal's Pass Level 1"

/area/groundbase/level1/centsquare
	name = "\improper Central Square"

/area/groundbase/level1/northspur
	name = "\improper North Spur"
/area/groundbase/level1/eastspur
	name = "\improper East Spur"
/area/groundbase/level1/westspur
	name = "\improper West Spur"
/area/groundbase/level1/southeastspur
	name = "\improper Southeast Spur"
/area/groundbase/level1/southwestspur
	name = "\improper Southwest Spur"


/area/groundbase/level2
	name = "Rascal's Pass Level 2"
	flags = AREA_FLAG_IS_NOT_PERSISTENT
	sound_env = SOUND_ENVIRONMENT_MOUNTAINS

/area/groundbase/level2/ne
	name = "Northeast Rascal's Pass Level 2"
/area/groundbase/level2/nw
	name = "Northwest Rascal's Pass Level 2"
/area/groundbase/level2/se
	name = "Southeast Rascal's Pass Level 2"
/area/groundbase/level2/sw
	name = "Southwest Rascal's Pass Level 2"

/area/groundbase/level2/northspur
	name = "\improper North Spur"
	base_turf = /turf/simulated/open/virgo3c
/area/groundbase/level2/eastspur
	name = "\improper East Spur"
	base_turf = /turf/simulated/open/virgo3c
/area/groundbase/level2/westspur
	name = "\improper West Spur"
	base_turf = /turf/simulated/open/virgo3c
/area/groundbase/level2/southeastspur
	name = "\improper Southeast Spur"
	base_turf = /turf/simulated/open/virgo3c
/area/groundbase/level2/southwestspur
	name = "\improper Southwest Spur"
	base_turf = /turf/simulated/open/virgo3c

/area/groundbase/level3
	name = "Rascal's Pass Level 3"
	flags = AREA_FLAG_IS_NOT_PERSISTENT
	sound_env = SOUND_ENVIRONMENT_MOUNTAINS

/area/groundbase/level3/ne
	name = "Northeast Rascal's Pass Level 3"
/area/groundbase/level3/ne/open
	base_turf = /turf/simulated/open/virgo3c
/area/groundbase/level3/nw
	name = "Northwest Rascal's Pass Level 3"
/area/groundbase/level3/nw/open
	base_turf = /turf/simulated/open/virgo3c
/area/groundbase/level3/se
	name = "Southeast Rascal's Pass Level 3"
/area/groundbase/level3/se/open
	base_turf = /turf/simulated/open/virgo3c
/area/groundbase/level3/sw
	name = "Southwest Rascal's Pass Level 3"
/area/groundbase/level3/sw/open
	base_turf = /turf/simulated/open/virgo3c

/area/groundbase/level3/escapepad
	name = "Escape Shuttle Landing Pad"

/area/groundbase/science
	name = "Science"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE
	icon_state = "purwhisqu"
	ambience = AMBIENCE_GENERIC
	lightswitch = 0
/area/groundbase/science/hall
	name = "Science Hallway"
	lightswitch = 1
/area/groundbase/science/rnd
	name = "Research and Development"
/area/groundbase/science/robotics
	name = "Robotics"
/area/groundbase/science/server
	name = "Science Server Room"
/area/groundbase/science/rd
	name = "Research Director's Office"
/area/groundbase/science/circuits
	name = "Circuits Workshop"
/area/groundbase/science/xenohall
	name = "Xeno Studies Hallway"
	lightswitch = 1
/area/groundbase/science/xenobot
	name = "Xenobotany"
/area/groundbase/science/xenobot/storage
	name = "Xenobotany Storage"
/area/groundbase/science/picnic
	name = "Science Break Room"
	lightswitch = 1

/area/groundbase/science/outpost
	name = "Science Outpost"
	lightswitch = 1
/area/groundbase/science/outpost/substation
	name = "Science Outpost Substation"
/area/groundbase/science/outpost/atmos
	name = "Science Outpost Atmospherics"
	lightswitch = 0
/area/groundbase/science/outpost/anomaly_lab
	name = "Science Outpost Anomaly Lab"
	lightswitch = 0
/area/groundbase/science/outpost/anomaly_storage
	name = "Science Outpost Anomaly Storage"
	lightswitch = 0
/area/groundbase/science/outpost/anomaly_testing
	name = "Science Outpost Anomaly Testing"
	lightswitch = 0
/area/groundbase/science/outpost/toxins_lab
	name = "Science Outpost Toxins Lab"
	lightswitch = 0
/area/groundbase/science/outpost/toxins_storage
	name = "Science Outpost Toxins Storage"
	lightswitch = 0
/area/groundbase/science/outpost/toxing_gasworks
	name = "Science Outpost Toxins Gasworks"
	lightswitch = 0
/area/groundbase/science/outpost/toxins_mixing
	name = "Science Outpost Toxins Mixing"
	lightswitch = 0
/area/groundbase/science/outpost/toxins_hallway
	name = "Science Outpost Toxins Hallway"

/area/groundbase/command
	name = "Command"
	holomap_color = HOLOMAP_AREACOLOR_COMMAND
	icon_state = "bluwhisqu"
	ambience = AMBIENCE_GENERIC
/area/groundbase/command/bridge
	name = "Bridge"
/area/groundbase/command/captain
	name = "Captain's Office"
	lightswitch = 0
/area/groundbase/command/captainq
	name = "Captain's Quarters"
	lightswitch = 0
/area/groundbase/command/hop
	name = "Head of Personnel"
	lightswitch = 0
/area/groundbase/command/hall
	name = "Command Hallway"
/area/groundbase/command/meeting
	name = "Command Meeting Room"
	lightswitch = 0
/area/groundbase/command/ai
	name = "AI Core"
	ambience = AMBIENCE_AI
/area/groundbase/command/ai/chamber
	name = "AI Chamber"
/area/groundbase/command/ai/upload
	name = "AI Upload"
/area/groundbase/command/ai/hall
	name = "AI Hall"
/area/groundbase/command/ai/foyer
	name = "AI Foyer"
/area/groundbase/command/ai/robot
	name = "Robot Storage"
/area/groundbase/command/ai/storage
	name = "AI Storage"

/area/groundbase/security
	name = "Security"
	holomap_color = HOLOMAP_AREACOLOR_SECURITY
	icon_state = "redwhisqu"
	ambience = AMBIENCE_GENERIC
	lightswitch = 0
/area/groundbase/security/lobby
	name = "Security Lobby"
	lightswitch = 1
/area/groundbase/security/processing
	name = "Security Processing"
/area/groundbase/security/halls
	name = "Security South Hallway"
	lightswitch = 1
/area/groundbase/security/halle
	name = "Security East Hallway"
	lightswitch = 1
/area/groundbase/security/warden
	name = "Warden's Office"
/area/groundbase/security/armory
	name = "Security Armory"
	lightswitch = 1
	ambience = AMBIENCE_HIGHSEC
/area/groundbase/security/briefing
	name = "Security Briefing Room"
/area/groundbase/security/equipment
	name = "Security Equipment Room"
	ambience = AMBIENCE_HIGHSEC
/area/groundbase/security/iaa1
	name = "Internal Affairs West Office"
/area/groundbase/security/iaa2
	name = "Internal Affairs East Office"
/area/groundbase/security/detective
	name = "Detective's Office"
/area/groundbase/security/hos
	name = "Head of Security's Office"
/area/prison/cell_block/gb
	name = "Brig"

/area/groundbase/medical
	name = "Medical"
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL
	icon_state = "cyawhisqu"
	lightswitch = 0
/area/groundbase/medical/lobby
	name = "Medical Lobby"
	lightswitch = 1
/area/groundbase/medical/psych
	name = "Psychiatrist's Office"
/area/groundbase/medical/Chemistry
	name = "Chemistry"
	lightswitch = 1
/area/groundbase/medical/triage
	name = "Medical Triage"
	lightswitch = 1
/area/groundbase/medical/lhallway
	name = "Medical Lower Hallway"
	lightswitch = 1
/area/groundbase/medical/resleeving
	name = "Resleeving"
/area/groundbase/medical/autoresleeving
	name = "Auto-Resleeving"
	lightswitch = 1
/area/groundbase/medical/or1
	name = "Medical Operating Room 1"
/area/groundbase/medical/or2
	name = "Medical Operating Room 2"
/area/groundbase/medical/equipment
	name = "Medical Equipment Room"
/area/groundbase/medical/office
	name = "Medical Office"
/area/groundbase/medical/uhallway
	name = "Medical Upper Hallway"
	lightswitch = 1
/area/groundbase/medical/cmo
	name = "Chief Medical Officer's Office"
/area/groundbase/medical/paramedic
	name = "Paramedic Equipment Room"
/area/groundbase/medical/patio
	name = "Medical Break Room"
	lightswitch = 1
/area/groundbase/medical/patient1
	name = "Medical Patient Room 1"
/area/groundbase/medical/patient2
	name = "Medical Patient Room 2"
/area/groundbase/medical/patient3
	name = "Medical Patient Room 3"
/area/groundbase/medical/patient4
	name = "Medical Patient Room 4"
/area/groundbase/medical/morgue
	name = "Morgue"

/area/groundbase/engineering
	name = "Engineering"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING
	icon_state = "yelwhisqu"
	ambience = AMBIENCE_ENGINEERING
	lightswitch = 0
/area/groundbase/engineering/lobby
	name = "Engineering Lobby"
	lightswitch = 1
/area/groundbase/engineering/ce
	name = "Chief Engineer's Office"
/area/groundbase/engineering/workshop
	name = "Engineering Workshop"
	lightswitch = 1
/area/groundbase/engineering/eva
	name = "Engineering EVA"
/area/groundbase/engineering/storage
	name = "Engineering Storage"
	lightswitch = 1
/area/groundbase/engineering/techstorage
	name = "Engineering Tech Storage"
/area/groundbase/engineering/engine
	name = "Engine"
/area/groundbase/engineering/atmos
	name = "Atmospherics"
	ambience = AMBIENCE_ATMOS
/area/groundbase/engineering/atmos/monitoring
	name = "Atmospherics Monitoring"
	lightswitch = 1
/area/groundbase/engineering/solarshed
	name = "Solar Shed"
	lightswitch = 1
/area/groundbase/engineering/solarfield
	name = "Solar Field"
	lightswitch = 1
	sound_env = SOUND_ENVIRONMENT_MOUNTAINS

/area/groundbase/cargo
	name = "Cargo"
	holomap_color = HOLOMAP_AREACOLOR_CARGO
	icon_state = "orawhisqu"
	ambience = AMBIENCE_HANGAR
	lightswitch = 0
/area/groundbase/cargo/office
	name = "Cargo Office"
	lightswitch = 1
/area/groundbase/cargo/storage
	name = "Cargo Storage"
	lightswitch = 0
/area/groundbase/cargo/bay
	name = "Cargo Bay"
	lightswitch = 1
/area/groundbase/cargo/bay/above
	base_turf = /turf/simulated/open/virgo3c
/area/groundbase/cargo/qm
	name = "Quartermaster's Office"
/area/groundbase/cargo/mining
	name = "Mining"
/area/maintenance/groundbase/trashpit
	name = "Trash Pit"
	lightswitch = 1

/area/groundbase/civilian
	name = "Civilian"
	holomap_color = HOLOMAP_AREACOLOR_CIV
	icon_state = "grewhisqu"
	ambience = AMBIENCE_FOREBODING
	lightswitch = 0

/area/groundbase/civilian/arrivals
	name = "Arrivals"
	lightswitch = 1
	flags = AREA_FORBID_EVENTS | AREA_FORBID_SINGULO

/area/groundbase/civilian/toolstorage
	name = "Tool Storage"
	lightswitch = 1

/area/groundbase/civilian/bar
	name = "Bar"
	sound_env = LARGE_ENCLOSED
	lightswitch = 1

/area/groundbase/civilian/bar/upper
	name = "Bar Balcony"
	base_turf = /turf/simulated/open/virgo3c

/area/groundbase/civilian/cafe
	name = "Cafe"
	sound_env = SMALL_SOFTFLOOR
	lightswitch = 1

/area/groundbase/civilian/hydroponics
	name = "Hydroponics"
	lightswitch = 1

/area/groundbase/civilian/hydroponics/out
	name = "Hydroponics Animal Pen"
/area/groundbase/civilian/kitchen
	name = "Kitchen"
	lightswitch = 1

/area/groundbase/civilian/kitchen/freezer
	name = "Kitchen Freezer"
/area/groundbase/civilian/kitchen/backroom
	name = "Kitchen Back Room"
/area/groundbase/civilian/chapel
	name = "Chapel"
	ambience = AMBIENCE_CHAPEL
	lightswitch = 1
/area/groundbase/civilian/chapel/office
	name = "Chaplain's Office"
/area/groundbase/civilian/library
	name = "Library"
/area/groundbase/civilian/pilot
	name = "Pilot Equipment Room"
/area/groundbase/civilian/gateway
	name = "Gateway"
/area/groundbase/civilian/janitor
	name = "Janitor's Closet"
/area/groundbase/civilian/foodplace
	name = "Uncle Grumslex's Snack Emporium"
	lightswitch = 1
/area/groundbase/civilian/apparel
	name = "Crew Apparel Care"
	lightswitch = 1
/area/groundbase/civilian/clown
	name = "Giggledome"
/area/groundbase/civilian/mime
	name = "Temple of Silence"
/area/groundbase/civilian/gameroom
	name = "Gamatorium"
	sound_env = SMALL_SOFTFLOOR
/area/groundbase/civilian/mensrestroom
	name = "Men's Restroom"
	flags = AREA_FORBID_EVENTS
	sound_env = SOUND_ENVIRONMENT_BATHROOM
	lightswitch = 1

/area/groundbase/civilian/womensrestroom
	name = "Women's Restroom"
	flags = AREA_FORBID_EVENTS
	sound_env = SOUND_ENVIRONMENT_BATHROOM
	lightswitch = 1

/area/groundbase/civilian/entrepreneur
	name = "\improper Shared Office"
	icon_state = "entertainment"

/area/groundbase/civilian/entrepreneur/session
	name = "\improper Shared Office Session Room"

/area/groundbase/civilian/entrepreneur/meeting
	name = "\improper Shared Office Meeting Room"


/area/groundbase/exploration
	name = "Exploration"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE
	icon_state = "purwhisqu"
	ambience = AMBIENCE_GENERIC
/area/groundbase/exploration/equipment
	name = "Exploration Equipment Room"
	lightswitch = 0
/area/groundbase/exploration/shuttlepad
	name = "Exploration Shuttlepad"

/area/groundbase/dorms
	name = "Dormitories"
	holomap_color = HOLOMAP_AREACOLOR_DORMS
	icon_state = "grawhisqu"
	ambience = AMBIENCE_GENERIC
	flags = RAD_SHIELDED | BLUE_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT | AREA_FORBID_EVENTS | AREA_FORBID_SINGULO | AREA_SOUNDPROOF | AREA_ALLOW_LARGE_SIZE | AREA_BLOCK_SUIT_SENSORS | AREA_BLOCK_TRACKING

/area/groundbase/dorms/bathroom
	name = "Dormitory Bathroom"
	sound_env = SOUND_ENVIRONMENT_BATHROOM
/area/groundbase/dorms/room1
	name = "Dorm Room 1"
	lightswitch = 0
	sound_env = SMALL_SOFTFLOOR
/area/groundbase/dorms/room2
	name = "Dorm Room 2"
	lightswitch = 0
	sound_env = SMALL_SOFTFLOOR
/area/groundbase/dorms/room3
	name = "Dorm Room 3"
	lightswitch = 0
	sound_env = SMALL_SOFTFLOOR
/area/groundbase/dorms/room4
	name = "Dorm Room 4"
	lightswitch = 0
	sound_env = SMALL_SOFTFLOOR
/area/groundbase/dorms/room5
	name = "Dorm Room 5"
	lightswitch = 0
	sound_env = SMALL_SOFTFLOOR
/area/groundbase/dorms/room6
	name = "Dorm Room 6"
	lightswitch = 0
	sound_env = SMALL_SOFTFLOOR
/area/groundbase/dorms/room7
	name = "Dorm Room 7"
	lightswitch = 0
	sound_env = SMALL_SOFTFLOOR
/area/groundbase/dorms/room8
	name = "Dorm Room 8"
	lightswitch = 0
	sound_env = SMALL_SOFTFLOOR

/area/maintenance/groundbase/substation
	name = "Substation"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING
	icon_state = "yelwhitri"
	ambience = AMBIENCE_SUBSTATION
/area/maintenance/groundbase/substation/medcargo
	name = "Medical/Cargo Substation"
/area/maintenance/groundbase/substation/secsci
	name = "Security/Research Substation"
/area/maintenance/groundbase/substation/aiciv
	name = "AI/Civilian Substation"
/area/maintenance/groundbase/substation/command
	name = "Command Substation"

/area/maintenance/groundbase/level1/netunnel
	name = "\improper Level 1 Northeast Tunnel"
/area/maintenance/groundbase/level1/nwtunnel
	name = "\improper Level 1 Northwest Tunnel"
/area/maintenance/groundbase/level1/setunnel
	name = "\improper Level 1 Southeast Tunnel"
/area/maintenance/groundbase/level1/stunnel
	name = "\improper Level 1 South Tunnel"
/area/maintenance/groundbase/level1/swtunnel
	name = "\improper Level 1 Southwest Tunnel"

/area/groundbase/unexplored/outdoors
	name = "\improper Rascal's Pass"
	icon_state = "orablatri"
	sound_env = SOUND_ENVIRONMENT_MOUNTAINS

/area/groundbase/unexplored/rock
	sound_env = SOUND_ENVIRONMENT_CAVE

/area/groundbase/mining
	name = "Mining"
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg', 'sound/ambience/old_foreboding/foreboding2.ogg', 'sound/ambience/old_foreboding/foreboding2.ogg')
/area/groundbase/mining/unexplored
	icon_state = "orablacir"
/area/groundbase/mining/explored
	icon_state = "blublacir"

// Exclude some more areas from the atmos leak event since its outside.
/datum/event/atmos_leak/setup()
	excluded |= /area/groundbase/level1/centsquare
	excluded |= /area/groundbase/level1/eastspur
	excluded |= /area/groundbase/level1/northspur
	excluded |= /area/groundbase/level1/southeastspur
	excluded |= /area/groundbase/level1/southwestspur
	excluded |= /area/groundbase/level1/westspur
	excluded |= /area/maintenance/groundbase/level1/netunnel
	excluded |= /area/maintenance/groundbase/level1/nwtunnel
	excluded |= /area/maintenance/groundbase/level1/stunnel
	excluded |= /area/maintenance/groundbase/level1/setunnel
	excluded |= /area/maintenance/groundbase/level1/swtunnel
	excluded |= /area/groundbase/level2/ne
	excluded |= /area/groundbase/level2/nw
	excluded |= /area/groundbase/level2/se
	excluded |= /area/groundbase/level2/sw
	excluded |= /area/groundbase/level3/ne
	excluded |= /area/groundbase/level3/nw
	excluded |= /area/groundbase/level3/se
	excluded |= /area/groundbase/level3/sw
	excluded |= /area/groundbase/level2/northspur
	excluded |= /area/groundbase/level2/eastspur
	excluded |= /area/groundbase/level2/westspur
	excluded |= /area/groundbase/level2/southeastspur
	excluded |= /area/groundbase/level2/southwestspur
	excluded |= /area/groundbase/level3/ne/open
	excluded |= /area/groundbase/level3/nw/open
	excluded |= /area/groundbase/level3/se/open
	excluded |= /area/groundbase/level3/sw/open
	excluded |= /area/groundbase/level3/escapepad
	..()

/area/gb_mine/
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')
	base_turf = /turf/simulated/mineral/floor
/area/gb_mine/unexplored
	name = "Virgo 3c Underground"
	icon_state = "unexplored"
/area/gb_mine/explored
	name = "Virgo 3c Underground"
	icon_state = "explored"
