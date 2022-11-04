//Planetside

/area/surface
	name = "The Surface (Don't Use)"
	area_flags = AREA_FLAG_IS_RAD_SHIELDED

/area/surface/center
	name = "Center"
	icon_state = "center"

/area/surface/north
	name = "Outpost"
	icon_state = "north"

/area/surface/south
	name = "Lake"
	icon_state = "south"

/area/surface/east
	name = "Shoreline"
	icon_state = "east"

/area/surface/west
	name = "Snowfields"
	icon_state = "west"

/area/surface/northeast
	name = "Depths"
	icon_state = "northeast"

/area/surface/northwest
	name = "Mountains"
	icon_state = "northwest"

/area/surface/southwest
	name = "Glowing Forest"
	icon_state = "southwest"

/area/surface/southeast
	name = "Southern Shoreline"
	icon_state = "southeast"

/area/surface/outside
	ambience = AMBIENCE_SIF
	always_unpowered = TRUE
	area_flags = AREA_FLAG_IS_RAD_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
	outdoors = OUTDOORS_YES

// The area near the station, so POIs don't show up right next to the outpost.
/area/surface/outside/plains/station
	name = "Station Perimeter"
	icon_state = "green"

//For Second Floor

/area/surface/outside/plains/station/snd
	name = "Plains"
	icon_state = "blueold"

// Rest of the 'plains' Z-level, for POIs.
/area/surface/outside/plains/normal
	name = "Plains"
	icon_state = "yellow"

// So POIs don't get embedded in rock.
/area/surface/outside/plains/plateau
	name = "Plateau"
	icon_state = "darkred"

// Paths get their own area so POIs don't overwrite pathways.
/area/surface/outside/path
	name = "Trail"
	icon_state = "purple"

/area/surface/outside/path/plains

/area/surface/outside/wilderness/normal
	name = "Wilderness"
	icon_state = "yellow"

/area/surface/outside/wilderness/deep
	name = "Deep Wilderness"
	icon_state = "red"

// So POIs don't get embedded in rock.
/area/surface/outside/wilderness/mountains
	name = "Mountains"
	icon_state = "darkred"

/area/surface/outside/path/wilderness

// Water
/area/surface/outside/ocean
	name = "Sea"
	icon_state = "bluenew"

/area/surface/outside/river
	name = "River"
	icon_state = "bluenew"

/area/surface/outside/river/gautelfr
	name = "Gautelfr River"

/area/surface/cave
	area_flags = AREA_FLAG_IS_RAD_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT
	always_unpowered = TRUE

// The bottom half that connects to the outpost and is safer.
/area/surface/cave/explored/normal
	name = "Tunnels"
	icon_state = "explored"

/area/surface/cave/unexplored/normal
	name = "Tunnels"
	icon_state = "unexplored"

// The top half of the map that is more dangerous.
/area/surface/cave/explored/deep
	name = "Depths"
	icon_state = "explored_deep"

/area/surface/cave/unexplored/deep
	name = "Depths"
	icon_state = "unexplored_deep"

//Cynosure Station

/area/surface/station
	ambience = AMBIENCE_GENERIC
	outdoors = OUTDOORS_NO
	area_flags = AREA_FLAG_IS_STATION_AREA

//AI

/area/surface/station/ai
	name = "\improper AI - Chamber"
	icon_state = "ai_chamber"
	holomap_color = HOLOMAP_AREACOLOR_COMMAND
	ambience = AMBIENCE_AI

/area/surface/station/ai/cyborg_station
	name = "\improper AI - Cyborg Station"
	icon_state = "ai_cyborg"
	sound_env = SMALL_ENCLOSED

/area/surface/station/ai/upload
	name = "\improper AI - Upload Chamber"
	icon_state = "ai_upload"

/area/surface/station/ai/upload_foyer
	name = "AI - Upload Access"
	icon_state = "ai_foyer"
	sound_env = SMALL_ENCLOSED

/area/surface/station/ai/server_room
	name = "AI - Messaging Server Room"
	icon_state = "ai_server"
	sound_env = SMALL_ENCLOSED


//Arrivals

/area/surface/station/arrivals
	forbid_events = TRUE
	base_turf = /turf/simulated/floor/outdoors/dirt/sif/planetuse

/area/surface/station/arrivals/cynosure
	name = "Arrivals and Departures"
	icon_state = "entry_1"

/area/surface/station/arrivals/cynosure/nopower
	name = "Arrivals and Departures"
	icon_state = "entry_1"
	requires_power = 0

/area/surface/station/arrivals/cynosure/cryo
	name = "\improper Cryogenic Storage"
	icon_state = "Sleep"

//Hallways

/area/surface/station/hallway/primary
	sound_env = LARGE_ENCLOSED
	ambience = AMBIENCE_GENERIC

/area/surface/station/hallway/primary/bmt/north
	name = "\improper Basement North Hallway"
	icon_state = "hallF"

/area/surface/station/hallway/primary/bmt/south
	name = "\improper Basement South Hallway"
	icon_state = "hallA"

/area/surface/station/hallway/primary/bmt/east
	name = "\improper Basement East Hallway"
	icon_state = "hallS"

/area/surface/station/hallway/primary/bmt/west
	name = "\improper Basement West Hallway"
	icon_state = "hallP"

/area/surface/station/hallway/primary/bmt/west/elevator
	name = "\improper Basement West Elevator Hallway"

/area/surface/station/hallway/primary/groundfloor/east
	name = "\improper Ground Floor East Hallway"
	icon_state = "hallS"

/area/surface/station/hallway/primary/groundfloor/west
	name = "\improper Ground Floor West Hallway"
	icon_state = "hallP"

/area/surface/station/hallway/primary/groundfloor/west/elevator
	name = "\improper Ground Floor West Elevator Hallway"
	icon_state = "hallP"

/area/surface/station/hallway/primary/groundfloor/north
	name = "\improper Ground Floor North Hallway"
	icon_state = "hallF"

/area/surface/station/hallway/primary/groundfloor/south
	name = "\improper Ground Floor South Hallway"
	icon_state = "hallA"

/area/surface/station/hallway/primary/secondfloor/east
	name = "\improper Second Floor East Hallway"
	icon_state = "hallS"

/area/surface/station/hallway/primary/secondfloor/north
	name = "\improper Second Floor North Hallway"
	icon_state = "hallF"

/area/surface/station/hallway/primary/secondfloor/west
	name = "\improper Second Floor West Hallway"
	icon_state = "hallP"

/area/surface/station/hallway/primary/secondfloor/west/elevator
	name = "\improper Second Floor West Elevator Hallway"
	icon_state = "hallP"

//Secondary Hallway

/area/surface/station/hallway/secondary
	icon_state = "hallA"

/area/surface/station/hallway/secondary/groundfloor/civilian
	name = "\improper Ground Floor Civilian Hallway"
	icon_state = "mid_civilian_hallway"

/area/surface/station/hallway/secondary/secondfloor/civilian
	name = "\improper Second Floor Civilian Hallway"
	icon_state = "mid_civilian_hallway"

/area/surface/station/hallway/secondary/secondfloor/command
	name = "\improper Second Floor Command Hallway"
	icon_state = "hallS"

/area/surface/station/hallway/secondary/secondfloor/dormhallway
	name = "\improper Dormitory Hallway"
	icon_state = "aft_civilian_hallway"

/area/surface/station/hallway/secondary/secondfloor/eva_hallway
	name = "\improper EVA Hallway"
	icon_state = "eva_hallway"

/area/surface/station/hallway/secondary/bmt/weststairwell
	name = "\improper Basement West Stairwell"
	icon_state = "hallP"

/area/surface/station/hallway/secondary/secondfloor/weststairwell
	name = "\improper Second Floor West Stairwell"
	icon_state = "hallP"

/area/surface/station/hallway/secondary/secondfloor/westskybridge
	name = "\improper Second Floor West Skybridge"
	icon_state = "green"

/area/surface/station/hallway/secondary/bmt/eaststairwell
	name = "\improper Basement East Stairwell"
	icon_state = "hallP"

//Substations

/area/surface/station/maintenance/substation
	name = "Substation"
	icon_state = "substation"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_SUBSTATION


/area/surface/station/maintenance/substation/arrivals
	name = "Arrivals Substation"

/area/surface/station/maintenance/substation/atmospherics
	name = "Atmospherics Substation"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/surface/station/maintenance/substation/civilian
	name = "Civilian Substation"

/area/surface/station/maintenance/substation/command
	name = "Command Substation"
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/surface/station/maintenance/substation/cargo/bmt
	name = "Basement Cargo Substation"
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/surface/station/maintenance/substation/cargo/gnd
	name = "Ground Floor Cargo Substation"
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/surface/station/maintenance/substation/cargo/snd
	name = "Second Floor Cargo Substation"
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/surface/station/maintenance/substation/engineering/bmt
	name = "Basement Engineering Substation"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/surface/station/maintenance/substation/engineering/gnd
	name = "Ground Floor Engineering Substation"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/surface/station/maintenance/substation/engineering/snd
	name = "Second Floor Engineering Substation"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/surface/station/maintenance/substation/medbay/bmt
	name = "Medbay - Basement Substation"
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/surface/station/maintenance/substation/medbay/gnd
	name = "Medbay - Ground Floor Substation"
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/surface/station/maintenance/substation/medbay/snd
	name = "Medbay - Second Floor Substation"
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/surface/station/maintenance/substation/research/bmt
	name = "Research - Basement Substation"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/surface/station/maintenance/substation/research/gnd
	name = "Research - Ground Floor Substation"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/surface/station/maintenance/substation/research/snd
	name = "Research - Second Floor Substation"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/surface/station/maintenance/substation/security/gnd
	name = "Security - Ground Floor Substation"
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/surface/station/maintenance/substation/security/snd
	name = "Security - Second Floor Substation"
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

//Civilian

/area/surface/station/storage/art
	name = "Art Supply Storage"
	icon_state = "storage"

/area/surface/station/chapel
	ambience = AMBIENCE_CHAPEL
	icon_state = "chapel"

/area/surface/station/chapel/main
	name = "\improper Chapel"
	sound_env = LARGE_ENCLOSED

/area/surface/station/chapel/office
	name = "\improper Chapel Office"
	icon_state = "chapeloffice"

/area/surface/station/crew_quarters
	name = "\improper Dormitories"
	icon_state = "Sleep"
	ambience = AMBIENCE_GENERIC

/area/surface/station/crew_quarters/bar
	name = "\improper Bar"
	icon_state = "bar"
	sound_env = LARGE_SOFTFLOOR

/area/surface/station/crew_quarters/cafeteria
	name = "\improper Cafeteria"
	icon_state = "cafeteria"
	sound_env = LARGE_SOFTFLOOR

/area/surface/station/crew_quarters/caferestroom
	name = "\improper Cafeteria Restroom"
	icon_state = "bar"
	sound_env = SMALL_ENCLOSED

/area/surface/station/crew_quarters/sleep/Dorm_1
	name = "\improper Dormitory Room 1"
	icon_state = "Sleep"
	holomap_color = HOLOMAP_AREACOLOR_DORMS

/area/surface/station/crew_quarters/sleep/Dorm_2
	name = "\improper Dormitory Room 2"
	icon_state = "Sleep"
	holomap_color = HOLOMAP_AREACOLOR_DORMS

/area/surface/station/crew_quarters/sleep/Dorm_3
	name = "\improper Dormitory Room 3"
	icon_state = "Sleep"
	holomap_color = HOLOMAP_AREACOLOR_DORMS

/area/surface/station/crew_quarters/sleep/Dorm_4
	name = "\improper Dormitory Room 4"
	icon_state = "Sleep"
	holomap_color = HOLOMAP_AREACOLOR_DORMS

/area/surface/station/crew_quarters/sleep/Dorm_5
	name = "\improper Dormitory Room 5"
	icon_state = "Sleep"
	holomap_color = HOLOMAP_AREACOLOR_DORMS

/area/surface/station/crew_quarters/gym
	name = "\improper Station Gym"
	icon_state = "fitness"

/area/surface/station/crew_quarters/kitchen
	name = "\improper Kitchen"
	icon_state = "kitchen"

/area/surface/station/crew_quarters/locker
	name = "\improper Locker Room"
	icon_state = "locker"

/area/surface/station/crew_quarters/pool
	name = "\improper Pool"
	icon_state = "pool"

/area/surface/station/holodeck_control
	name = "\improper Holodeck Control"
	icon_state = "holodeck_control"

/area/surface/station/hydroponics
	name = "\improper Hydroponics"
	icon_state = "hydro"

/area/surface/station/hydroponics/garden
	name = "\improper Garden"
	icon_state = "garden"

/area/surface/station/janitor/
	name = "\improper Custodial Closet"
	icon_state = "janitor"

/area/surface/station/library
 	name = "\improper Library"
 	icon_state = "library"
 	sound_env = LARGE_SOFTFLOOR

/area/surface/station/storage/primarytool
	name = "Primary Tool Storage"
	icon_state = "primarystorage"

//Public

/area/surface/station/garage
	name = "\improper Garage"
	icon_state = "green"

/area/surface/station/park
	name = "\improper Park"
	icon_state = "garden"
	sound_env = STANDARD_STATION

/area/surface/station/park/skybridge
	name = "\improper Skybridge"
	icon_state = "green"

//Public Secure

/area/surface/station/storage/tech
	name = "Technical Storage"
	icon_state = "auxstorage"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/surface/station/vault
	name = "\improper Vault"
	icon_state = "nuke_storage"
	ambience = AMBIENCE_HIGHSEC
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

//Command

/area/surface/station/ai_monitored/storage/eva
	name = "EVA Storage"
	icon_state = "eva"

/area/surface/station/crew_quarters/captain
	name = "\improper Command - Site Manager's Office"
	icon_state = "captain"
	sound_env = MEDIUM_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/surface/station/crew_quarters/heads/chief
	name = "\improper Engineering - Chief Engineer's Office"
	icon_state = "head_quarters"
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/surface/station/crew_quarters/heads/cmo
	name = "\improper Medbay - CMO's Office"
	icon_state = "head_quarters"
	area_flags = AREA_FLAG_IS_RAD_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_STATION_AREA
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/surface/station/crew_quarters/heads/hop
	name = "\improper Head of Personnel's Office"
	icon_state = "head_quarters"
	area_flags = AREA_FLAG_IS_RAD_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_STATION_AREA
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/surface/station/crew_quarters/heads/hos
	name = "\improper Security - HoS' Office"
	icon_state = "head_quarters"
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/surface/station/crew_quarters/heads/rdoffice
	name = "\improper Research - Research Director's Office"
	icon_state = "head_quarters"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/surface/station/command/internalaffairs
	name = "\improper Command - Internal Affairs"
	icon_state = "law"
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/surface/station/command/liaison
	name = "\improper Command - Liaison Office"
	icon_state = "law"
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/surface/station/command/meeting_room
	name = "\improper Command - Meeting Room"
	icon_state = "bridge"
	music = null
	sound_env = MEDIUM_SOFTFLOOR
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/surface/station/command/operations
	name = "\improper Command - Operations Center"
	icon_state = "bridge"
	music = "signal"
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

/area/surface/station/command/teleporter
	name = "\improper Command - Teleporter"
	icon_state = "teleporter"
	music = "signal"
	holomap_color = HOLOMAP_AREACOLOR_COMMAND

//Engineering

/area/surface/station/engineering/
	name = "\improper Engineering"
	icon_state = "engineering"
	ambience = AMBIENCE_ENGINEERING
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/surface/station/engineering/atmos
 	name = "\improper Engineering - Atmospherics"
 	icon_state = "atmos"
 	sound_env = LARGE_ENCLOSED
	 ambience = AMBIENCE_ATMOS

/area/surface/station/engineering/atmos/monitoring
	name = "\improper Engineering - Atmospherics Monitoring"
	icon_state = "atmos_monitoring"
	sound_env = STANDARD_STATION

/area/surface/station/engineering/auxiliary_engineering
	name = "\improper Engineering - Auxiliary Engineering Station"
	sound_env = SMALL_ENCLOSED

/area/surface/station/engineering/drone_fabrication
	name = "\improper Engineering - Drone Fabrication"
	icon_state = "drone_fab"
	sound_env = SMALL_ENCLOSED

/area/surface/station/engineering/engi_restroom
	name = "\improper Engineering - Restroom"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

/area/surface/station/engineering/foyer
	name = "\improper Engineering - Foyer"
	icon_state = "engineering_foyer"

/area/surface/station/engineering/foyer/secondfloor
	name = "\improper Engineering - Foyer Overlook"
	icon_state = "engineering_foyer"

/area/surface/station/engineering/hallway/
	name = "\improper Engineering - Ground Floor Hallway"
	icon_state = "engineering_aft_hallway"

/area/surface/station/engineering/hallway/bmt
	name = "\improper Engineering - Basement Hallway"

/area/surface/station/engineering/hallway/snd
	name = "\improper Engineering - Second Floor Hallway"

/area/surface/station/engineering/hallway/eva_hallway
	name = "\improper Engineering - EVA Hallway"
	icon_state = "engine_eva"

/area/surface/station/engineering/hallway/reactor
	name = "\improper Engineering - Reactor Hallway"
	icon_state = "engine"

/area/surface/station/engineering/hallway/sndaccess
	name = "\improper Engineering - Access Second Floor"

/area/surface/station/engineering/reactor_smes
	name = "\improper Engineering - SMES"
	icon_state = "engine_smes"
	sound_env = SMALL_ENCLOSED

/area/surface/station/engineering/reactor_room
	name = "\improper Engineering - Reactor Room"
	icon_state = "engine"
	sound_env = LARGE_ENCLOSED
	forbid_events = TRUE

/area/surface/station/engineering/reactor_airlock
	name = "\improper Engineering - Ground Floor Reactor Room Airlock"
	icon_state = "engine"

/area/surface/station/engineering/reactor_airlock/snd
	name = "\improper Engineering - Second Floor Reactor Room Airlock"
	icon_state = "engine"

/area/surface/station/engineering/reactor_monitoring
	name = "\improper Engineering - Reactor Monitoring"
	icon_state = "engine_monitoring"

/area/surface/station/engineering/reactor_waste
	name = "\improper Engineering - Reactor Waste Handling"
	icon_state = "engine_waste"

/area/surface/station/engineering/engineering_monitoring
	name = "\improper Engineering - Engineering Monitoring"
	icon_state = "engine_monitoring"

/area/surface/station/engineering/storage
	name = "\improper Engineering - Storage"
	icon_state = "engineering_storage"

/area/surface/station/engineering/engine_eva
	name = "\improper Engineering - EVA"
	icon_state = "engine_eva"

/area/surface/station/engineering/locker_room
	name = "\improper Engineering - Locker Room"
	icon_state = "engineering_locker"

/area/surface/station/engineering/workshop
	name = "\improper Engineering - Workshop"
	icon_state = "engineering_workshop"

//Maintenance

/area/surface/station/maintenance
	area_flags = AREA_FLAG_IS_RAD_SHIELDED | AREA_FLAG_IS_STATION_AREA
	sound_env = TUNNEL_ENCLOSED
	turf_initializer = new /datum/turf_initializer/maintenance()
	ambience = AMBIENCE_MAINTENANCE

/area/surface/station/maintenance/atmos
	name = "Atmospherics Maintenance"
	icon_state = "fpmaint"

/area/surface/station/maintenance/bar
	name = "Bar Maintenance"
	icon_state = "maint_bar"

/area/surface/station/maintenance/cargo
	name = "Cargo Maintenance"
	icon_state = "maint_cargo"

/area/surface/station/maintenance/chapel
	name = "Chapel Maintenance"
	icon_state = "maint_chapel"

/area/surface/station/maintenance/east/gnd
	name = "\improper East Maintenance - Ground Floor"
	icon_state = "smaint"

/area/surface/station/maintenance/east/snd
	name = "\improper East Maintenance - Second Floor"
	icon_state = "smaint"

/area/surface/station/maintenance/eaststairwell
	name = "East Stairwell Maintenance"
	icon_state = "smaint"

/area/surface/station/maintenance/engineering
	name = "Engineering Maintenance"
	icon_state = "maint_engineering"

/area/surface/station/maintenance/engineering/north
	name = "Engineering Maintenance - North"
	icon_state = "maint_engineering"

/area/surface/station/maintenance/engineering/south
	name = "Engineering Maintenance - South"
	icon_state = "maint_engineering"

/area/surface/station/maintenance/eva
	name = "\improper EVA Maintenance"
	icon_state = "maint_eva"

/area/surface/station/maintenance/incinerator
	name = "\improper Incinerator"
	icon_state = "disposal"

/area/surface/station/maintenance/incineratormaint
	name = "Incinerator Maintenance"
	icon_state = "pmaint"

/area/surface/station/maintenance/kitchen
	name = "Kitchen Maintenance"
	icon_state = "maint_cafe_dock"

/area/surface/station/maintenance/medical
	name = "Medbay Maintenance"
	icon_state = "maint_medbay"

/area/surface/station/maintenance/medical/west
	name = "Medbay Maintenance - West"
	icon_state = "maint_medbay"

/area/surface/station/maintenance/medical/south
	name = "Medbay Maintenance - South"
	icon_state = "maint_medbay_aft"

/area/surface/station/maintenance/mining
	name = "Mining Maintenance"
	icon_state = "apmaint"

/area/surface/station/maintenance/north/gnd
	name = "\improper North Maintenance - Ground Floor"
	icon_state = "fmaint"

/area/surface/station/maintenance/security
	name = "Security Maintenance"
	icon_state = "maint_security_starboard"

/area/surface/station/maintenance/surgery
	name = "Surgery Maintenance"
	icon_state = "maint_medbay"

/area/surface/station/maintenance/research
	name = "Research Maintenance"
	icon_state = "maint_research"

/area/surface/station/maintenance/research/south
	name = "Research Maintenance - South"

/area/surface/station/maintenance/research/east
	name = "Research Maintenance - East"
	icon_state = "maint_research_starboard"

/area/surface/station/maintenance/weststairwell
	name = "West Stairwell Maintenance"
	icon_state = "pmaint"

/area/surface/station/maintenance/weststairwell/bmt
	name = "West Stairwell Maintenance - Basement Floor"

/area/surface/station/maintenance/weststairwell/gnd
	name = "West Stairwell Maintenance - Ground Floor"

/area/surface/station/maintenance/weststairwell/snd
	name = "West Stairwell Maintenance - Second Floor"

/area/surface/station/maintenance/storage/emergency
	name = "Emergency Storage"
	icon_state = "emergencystorage"

/area/surface/station/maintenance/storage/emergency/bmtseast
	name = "Emergency Storage - Basement Southeast"
	icon_state = "emergencystorage"

/area/surface/station/maintenance/storage/emergency/bmtswest
	name = "Emergency Storage - Basement Southwest"
	icon_state = "emergencystorage"

/area/surface/station/maintenance/storage/emergency/sec
	name = "Emergency Storage - Security"
	icon_state = "emergencystorage"

//Construction

/area/surface/station/construction
	name = "\improper Engineering Construction Area"
	icon_state = "yellow"
	area_flags = AREA_FLAG_IS_RAD_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_STATION_AREA

/area/surface/station/construction/bar
	name = "\improper Bar Basement"
	icon_state = "maint_bar"

/area/surface/station/construction/bmt/construction1
	name = "\improper Engineering Construction Area 1"

/area/surface/station/construction/bmt/construction2
	name = "\improper Engineering Construction Area 2"

/area/surface/station/construction/bmt/construction3
	name = "\improper Engineering Construction Area 3"

/area/surface/station/construction/bmt/construction4
	name = "\improper Engineering Construction Area 4"

/area/surface/station/construction/bmt/construction5
	name = "\improper Engineering Construction Area 5"

/area/surface/station/construction/bmt/construction6
	name = "\improper Engineering Construction Area 6"

// This is explicitly not under the /bmt subtype as this is not a PoI-based construction area.
/area/surface/station/construction/basement
	name = "\improper Engineering Construction Area 7"

/area/surface/station/construction/elevator
	name = "\improper Central Elevator Shaft"

/area/surface/station/construction/genetics
	name = "\improper Genetics Lab"
	icon_state = "genetics"

/area/surface/station/construction/office
	name = "\improper Vacant Office"
	icon_state = "vacant_site"

/area/surface/station/construction/warehouse
	name = "\improper Cargo Warehouse"
	icon_state = "quartstorage"

//Medbay

/area/surface/station/medical/
	name = "\improper Medbay"
	icon_state = "medbay"
	music = 'sound/ambience/signal.ogg'
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/surface/station/medical/chemistry
	name = "\improper Medical - Chemistry"
	icon_state = "chem"

/area/surface/station/medical/emt_bay
	name = "\improper Medical - EMT Bay"
	icon_state = "medbay_emt_bay"

/area/surface/station/medical/etc
	name = "\improper Medical - Emergency Treatment Centre"
	icon_state = "exam_room"
	area_flags = AREA_FLAG_IS_RAD_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_STATION_AREA //Trust me.

/area/surface/station/medical/hallway
	name = "\improper Medbay - Hallway"
	icon_state = "medbay4"

/area/surface/station/medical/hallway/bmt
	name = "\improper Medbay - Basement Hallway"

/area/surface/station/medical/hallway/snd
	name = "\improper Medbay - Second Floor Hallway"

/area/surface/station/medical/hallway/gnd
	name = "\improper Medbay - Ground Floor Elevator Access"

/area/surface/station/medical/lockerroom
	name = "\improper Medbay - Locker Room"
	icon_state = "locker"

/area/surface/station/medical/reception
	name = "\improper Medbay - Reception"
	icon_state = "medbay2"

/area/surface/station/medical/storage/primary_storage
	name = "\improper Medbay - Primary Storage"
	icon_state = "medbay_primary_storage"

/area/surface/station/medical/storage/second_storage
	name = "\improper Medbay - Secondary Storage"
	icon_state = "medbay3"

/area/surface/station/medical/psych
	name = "\improper Medbay - Psych Room"
	icon_state = "medbay3"
	music = 'sound/ambience/signal.ogg'

/area/surface/station/medical/restroom
	name = "\improper Medbay - Restroom"
	icon_state = "medbay_restroom"
	sound_env = SMALL_ENCLOSED

/area/surface/station/medical/ward
	name = "\improper Medbay - Recovery Ward"
	icon_state = "patients"

/area/surface/station/medical/patient_a
	name = "\improper Medbay - Patient A"
	icon_state = "medbay_patient_room_a"

/area/surface/station/medical/patient_b
	name = "\improper Medbay - Patient B"
	icon_state = "medbay_patient_room_b"

/area/surface/station/medical/patient_c
	name = "\improper Medbay - Patient C"
	icon_state = "medbay_patient_room_c"

/area/surface/station/medical/patient_wing
	name = "\improper Medbay - Patient Wing"
	icon_state = "patients"

/area/surface/station/medical/virology
	name = "\improper Medbay - Virology"
	icon_state = "virology"

/area/surface/station/medical/morgue
	name = "\improper Medbay - Morgue"
	icon_state = "morgue"

/area/surface/station/medical/surgery
	name = "\improper Medbay - Operating Theatre 1"
	icon_state = "surgery"
	area_flags = AREA_FLAG_IS_RAD_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_STATION_AREA //This WOULD become a filth pit

/area/surface/station/medical/surgery2
	name = "\improper Medbay - Operating Theatre 2"
	icon_state = "surgery"
	area_flags = AREA_FLAG_IS_RAD_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_STATION_AREA

/area/surface/station/medical/surgeryobs
	name = "\improper Medbay - Operation Observation"
	icon_state = "surgery"

/area/surface/station/medical/surgery_storage
	name = "\improper Medbay - Surgery Storage"
	icon_state = "surgery_storage"

/area/surface/station/medical/exam_room
	name = "\improper Medbay - Exam Room"
	icon_state = "exam_room"

/area/surface/station/medical/cloning
	name = "\improper Medbay - Cloning Lab"
	icon_state = "cloning"

/area/surface/station/medical/office
	name = "\improper Medbay - Office"
	icon_state = "medbay2"

// Mining
/area/surface/station/mining_main
	name = "Mining"
	icon_state = "mining"
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/surface/station/mining_main/locker
	name = "Mining Locker Room"
	icon_state = "outpost_mine_main"

/area/surface/station/mining_main/exterior
	name = "Mining Exterior"
	icon_state = "outpost_mine_west"

/area/surface/station/mining_main/storage
	name = "Mining Gear Storage"

/area/surface/station/mining_main/refinery
	name = "Mining Refinery"
	icon_state = "mining_production"

//Misc

/area/surface/outside/station
	name = "\improper Station"
	ambience = AMBIENCE_SIF
	area_flags = AREA_FLAG_IS_RAD_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_STATION_AREA

/area/surface/outside/station/roof
	name = "\improper Roof"
	icon_state = "dark128"

/area/surface/outside/station/reactorpond
	name = "\improper Reactor Cooling Ponds"
	icon_state = "bluenew"

/area/surface/outside/station/solar
	requires_power = 1
	always_unpowered = 1

/area/surface/outside/station/solar/westsolar
	name = "\improper Solar Array - West"
	icon_state = "panelsP"

/area/surface/outside/station/solar/northeastsolar
	name = "\improper Solar Array - Northeast"
	icon_state = "panelsS"

/area/surface/outside/station/shuttle
	icon_state = "red"

/area/surface/outside/station/shuttle/pad1
	name = "\improper Departures Pad"

/area/surface/outside/station/shuttle/pad2
	name = "\improper Arrivals Pad"

/area/surface/outside/station/shuttle/pad3
	name = "\improper Shuttle Pad Three"

/area/surface/outside/station/shuttle/pad4
	name = "\improper Shuttle Pad Four"

//Solars

/area/surface/station/maintenance/solars
	icon_state = "SolarcontrolS"
	sound_env = SMALL_ENCLOSED
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/surface/station/maintenance/solars/west
	name = "Solar Maintenance - West"
	icon_state = "SolarcontrolP"

/area/surface/station/maintenance/solars/northeast
	name = "Solar Maintenance - Northeast"
	icon_state = "SolarcontrolS"

// Supply

/area/surface/station/quartermaster
	name = "\improper Quartermasters"
	icon_state = "quart"
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/surface/station/quartermaster/office
	name = "\improper Cargo Office"
	icon_state = "quartoffice"

/area/surface/station/quartermaster/storage
	name = "\improper Cargo Bay"
	icon_state = "quartstorage"
	sound_env = LARGE_ENCLOSED

/area/surface/station/quartermaster/foyer
	name = "\improper Cargo Bay Foyer"
	icon_state = "quartstorage"

/area/surface/station/quartermaster/qm
	name = "\improper Cargo - Quartermaster's Office"

/area/surface/station/quartermaster/delivery
	name = "\improper Cargo - Delivery Office"
	area_flags = AREA_FLAG_IS_RAD_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_STATION_AREA //So trash doesn't pile up too hard.

/area/surface/station/quartermaster/lockerroom
	name = "\improper Cargo Locker Room"
	icon_state = "quart"

/area/surface/station/quartermaster/restroom
	name = "\improper Cargo Restroom"
	icon_state = "toilet"
	sound_env = SMALL_ENCLOSED

//Research Outpost

/area/surface/outpost/research
	icon_state = "outpost_research"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/surface/outpost/research/xenoarcheology
	name = "\improper Xenoarcheology"

/area/surface/outpost/research/xenoarcheology/smes
	name = "\improper Xenoarcheology SMES Maintenance"
	icon_state = "substation"
	sound_env = SMALL_ENCLOSED
	ambience = AMBIENCE_SUBSTATION

/area/surface/outpost/research/xenoarcheology/restroom
	name = "\improper Xenoarcheology Restroom"
	icon_state = "research_restroom"
	sound_env = SMALL_ENCLOSED

/area/surface/outpost/research/xenoarcheology/analysis
	name = "Xenoarcheology Sample Analysis"

/area/surface/outpost/research/xenoarcheology/anomaly
	name = "Xenoarcheology Anomalous Materials Lab"

/area/surface/outpost/research/xenoarcheology/isolation_a
	name = "Xenoarcheology Isolation A"

/area/surface/outpost/research/xenoarcheology/isolation_b
	name = "Xenoarcheology Isolation B"

/area/surface/outpost/research/xenoarcheology/isolation_c
	name = "Xenoarcheology Isolation C"

/area/surface/outpost/research/xenoarcheology/entrance
	name = "Xenoarcheology Research Entrance"

/area/surface/outpost/research/xenoarcheology/surface
	name = "Xenoarcheology Research Surface Entrance"

/area/surface/outpost/research/xenoarcheology/longtermstorage
	name = "Xenoarcheology Long-Term Anomalous Storage"

/area/surface/outpost/research/xenoarcheology/exp_prep
	name = "Xenoarcheology Expedition Preperation"

// SCIENCE

/area/surface/station/rnd
	name = "\improper Research"
	icon_state = "research"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/surface/station/rnd/hallway/bmt
	name = "\improper Research - Basement Hallway"

/area/surface/station/rnd/hallway/gnd
	name = "\improper Research - Ground Floor Hallway"

/area/surface/station/rnd/hallway/snd
	name = "\improper Research - Second Floor Hallway"

/area/surface/station/rnd/hallway/stairwell
	name = "\improper Research - Stairwell"

/area/surface/station/rnd/exploration
	name = "\improper Research - Exploration Prep"
	icon_state = "purple"

/area/surface/station/rnd/research
	name = "\improper Research - RnD"

/area/surface/station/rnd/research_foyer
	name = "\improper Research - Foyer"
	icon_state = "research_foyer"

/area/surface/station/rnd/research_lockerroom
	name = "\improper Research - Locker Room"
	icon_state = "toxlab"

/area/surface/station/rnd/research_restroom
	name = "\improper Research - Restroom"
	icon_state = "research_restroom"
	sound_env = SMALL_ENCLOSED

/area/surface/station/rnd/lab
	name = "\improper Research - Lab"
	icon_state = "toxlab"

/area/surface/station/rnd/xenobiology
	name = "\improper Research - Xenobiology Lab"
	icon_state = "xeno_lab"

/area/surface/station/rnd/xenobiology/xenoflora_isolation
	name = "\improper Research - Xenoflora Isolation"
	icon_state = "xeno_f_store"

/area/surface/station/rnd/xenobiology/xenoflora
	name = "\improper Research - Xenoflora Lab"
	icon_state = "xeno_f_lab"

/area/surface/station/rnd/storage
	name = "\improper Research - Toxins Storage"
	icon_state = "toxstorage"

/area/surface/station/rnd/toxins_launch
	name = "\improper Research - Toxins Launch Room"
	icon_state = "toxtest"

/area/surface/station/rnd/test_area
	name = "\improper Research - Toxins Test Area"
	icon_state = "toxtest"

/area/surface/station/rnd/mixing
	name = "\improper Research - Toxins Mixing Room"
	icon_state = "toxmix"

/area/surface/station/rnd/misc_lab
	name = "\improper Research - Miscellaneous Research"
	icon_state = "toxmisc"

/area/surface/station/rnd/workshop
	name = "\improper Research - Workshop"
	icon_state = "sci_workshop"

/area/surface/station/rnd/server
	name = "\improper Research - Server Room"
	icon_state = "server"

/area/surface/station/rnd/robotics
	name = "\improper Research - Robotics Lab"
	icon_state = "robotics"

/area/surface/station/rnd/chargebay
	name = "\improper Research - Mech Bay"
	icon_state = "mechbay"

//Security

/area/surface/station/security
	name = "\improper Security"
	icon_state = "security"
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/surface/station/security/main
	name = "\improper Security - Office"

/area/surface/station/security/lobby
	name = "\improper Security - Lobby"

/area/surface/station/security/brig
	name = "\improper Security - Brig"
	icon_state = "brig"

/area/surface/station/security/brig/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = 0
		temp_closet.icon_state = "closed_unlocked"
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.timer_duration = 1
	..()

/area/surface/station/security/prison
	name = "\improper Security - Prison Wing"
	icon_state = "sec_prison"

/area/surface/station/security/prison/prison_break()
	for(var/obj/structure/closet/secure_closet/brig/temp_closet in src)
		temp_closet.locked = 0
		temp_closet.icon_state = "closed_unlocked"
	for(var/obj/machinery/door_timer/temp_timer in src)
		temp_timer.timer_duration = 1
	..()

/area/surface/station/security/hallway
	name = "\improper Security - Hallway"
	icon_state = "darkred"

/area/surface/station/security/hallway/gnd
	name = "\improper Security - Ground Floor Hallway"

/area/surface/station/security/hallway/snd
	name = "\improper Security - Second Floor Hallway"

/area/surface/station/security/hallway/cell_hallway
	name = "\improper Security - Cell Hallway"
	icon_state = "security_cell_hallway"

/area/surface/station/security/hallway/stairwell
	name = "\improper Security - Second Floor Stairwell"
	icon_state = "security"

/area/surface/station/security/warden
	name = "\improper Security - Warden's Office"
	icon_state = "Warden"

/area/surface/station/security/armoury
	name = "\improper Security - Armory"
	icon_state = "armory"
	ambience = AMBIENCE_HIGHSEC

/area/surface/station/security/briefing_room
	name = "\improper Security - Briefing Room"
	icon_state = "brig"

/area/surface/station/security/evidence_storage
	name = "\improper Security - Equipment Storage"
	icon_state = "security_equipment_storage"

/area/surface/station/security/evidence_storage
	name = "\improper Security - Evidence Storage"
	icon_state = "evidence_storage"

/area/surface/station/security/interrogation
	name = "\improper Security - Interrogation"
	icon_state = "interrogation"

/area/surface/station/security/riot_control
	name = "\improper Security - Riot Control"
	icon_state = "riot_control"

/area/surface/station/security/detectives_office
	name = "\improper Security - Forensic Office"
	icon_state = "detective"
	sound_env = MEDIUM_SOFTFLOOR

/area/surface/station/security/detectives_office/lab
	name = "\improper Security - Forensic Lab"

/area/surface/station/security/range
	name = "\improper Security - Firing Range"
	icon_state = "firingrange"

/area/surface/station/security/restroom
	name = "\improper Security - Restroom"
	icon_state = "security_bathroom"
	sound_env = SMALL_ENCLOSED

/area/surface/station/security/equiptment_storage
	name = "\improper Security - Equipment Storage"
	icon_state = "security_equip_storage"

/area/surface/station/security/equiptment_storage/ses
	name = "\improper Security - Secondary Equipment Storage"

/area/surface/station/security/lockerroom
	name = "\improper Security - Locker Room"
	icon_state = "security_lockerroom"

/area/surface/station/security/processing
	name = "\improper Security - Processing"
	icon_state = "security_processing"

/area/surface/station/security/tactical
	name = "\improper Security - Tactical Equipment"
	icon_state = "Tactical"
	ambience = AMBIENCE_HIGHSEC

//Turbolift Cynosure

/area/turbolift
	name = "\improper Turbolift"
	icon_state = "shuttle"
	requires_power = 0
	dynamic_lighting = 1
	area_flags = AREA_FLAG_IS_RAD_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT | AREA_FLAG_IS_STATION_AREA

/area/turbolift/start
	name = "\improper Turbolift Start"

/area/turbolift/bmt
	name = "\improper basement"
	base_turf = /turf/simulated/floor/plating

/area/turbolift/gnd
	name = "\improper ground floor"
	base_turf = /turf/simulated/open

/area/turbolift/snd
	name = "\improper second deck"
	base_turf = /turf/simulated/open

// Elevator areas.
/area/turbolift/west_bmt
	name = "lift (basement)"
	lift_floor_label = "Basement"
	lift_floor_name = "Basement"
	lift_announce_str = "Arriving at Basement: Mining.Storage. Toxins. Vault."
	base_turf = /turf/simulated/floor

/area/turbolift/west_gnd
	name = "lift (ground floor)"
	lift_floor_label = "Ground Floor"
	lift_floor_name = "Ground Floor"
	lift_announce_str = "Arriving at Ground Floor: Engineering. Medbay. Security. Crew Facilities. Shuttle Landing Pads. Cryogenic Storage."

/area/turbolift/west_snd
	name = "lift (ground floor)"
	lift_floor_label = "Second Floor"
	lift_floor_name = "Second Floor"
	lift_announce_str = "Arriving at Second Floor: Cargo. Research. Crew Facilities. Command Operations. Meeting Room. AI Core. Escape Pod"

/area/turbolift/eng_bmt
	name = "lift (basement)"
	lift_floor_label = "Basement"
	lift_floor_name = "Basement"
	lift_announce_str = "Arriving at Basement: Drone Fabrication."
	base_turf = /turf/simulated/floor
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/turbolift/eng_gnd
	name = "lift (ground floor)"
	lift_floor_label = "Ground Floor"
	lift_floor_name = "Ground Floor"
	lift_announce_str = "Arriving at Ground Floor: Monitoring Room. Atmospherics. Storage. Reactor."
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/turbolift/eng_snd
	name = "lift (ground floor)"
	lift_floor_label = "Second Floor"
	lift_floor_name = "Second Floor"
	lift_announce_str = "Arriving at Second Floor: Atmospherics. EVA. CE Office. Locker Rooms."
	holomap_color = HOLOMAP_AREACOLOR_ENGINEERING

/area/turbolift/center_gnd
	name = "lift (ground floor)"
	lift_floor_label = "Ground Floor"
	lift_floor_name = "Ground Floor"
	lift_announce_str = "Arriving at Ground Floor: Engineering. Medbay. Security. Crew Facilities. Shuttle Landing Pads. Cryogenic Storage."
	base_turf = /turf/simulated/open

/area/turbolift/center_snd
	name = "lift (ground floor)"
	lift_floor_label = "Second Floor"
	lift_floor_name = "Second Floor"
	lift_announce_str = "Arriving at Second Floor: Cargo. Research. Crew Facilities. Command Operations. Meeting Room. AI Core. Escape Pod"

/area/turbolift/cargo_gnd
	name = "lift (first deck)"
	lift_floor_label = "Ground Floor"
	lift_floor_name = "Ground Floor"
	lift_announce_str = "Arriving at Cargo Delivery Bay."
	base_turf = /turf/simulated/floor
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/turbolift/cargo_snd
	name = "lift (second deck)"
	lift_floor_label = "Second Floor"
	lift_floor_name = "Second Floor"
	lift_announce_str = "Arriving at Cargo Office."
	holomap_color = HOLOMAP_AREACOLOR_CARGO

/area/turbolift/med_bmt
	name = "lift (basement)"
	lift_floor_label = "Basement"
	lift_floor_name = "Basement"
	lift_announce_str = "Arriving at Basement: Morgue.Medical Storage."
	base_turf = /turf/simulated/floor
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/turbolift/med_gnd
	name = "lift (ground floor)"
	lift_floor_label = "Ground Floor"
	lift_floor_name = "Ground Floor"
	lift_announce_str = "Arriving at Ground Floor: Emergency Treatment. Surgery. Cloning. Chemistry. Foyer."
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/turbolift/med_snd
	name = "lift (ground floor)"
	lift_floor_label = "Second Floor"
	lift_floor_name = "Second Floor"
	lift_announce_str = "Arriving at Second Floor: Patient Rooms. Mental Health. Virology. CMO Office. Locker Rooms."
	holomap_color = HOLOMAP_AREACOLOR_MEDICAL

/area/turbolift/sci_bmt
	name = "lift (basement)"
	lift_floor_label = "Basement"
	lift_floor_name = "Basement"
	lift_announce_str = "Arriving at Basement: Xenoarchaeology."
	base_turf = /turf/simulated/floor
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/turbolift/sci_gnd
	name = "lift (ground floor)"
	lift_floor_label = "Ground Floor"
	lift_floor_name = "Ground Floor"
	lift_announce_str = "Arriving at Ground Floor: Xenoarch Surface Exit."
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/turbolift/sec_gnd
	name = "lift (ground floor)"
	lift_floor_label = "Ground Floor"
	lift_floor_name = "Ground Floor"
	lift_announce_str = "Arriving at Ground Floor: Foyer. Detective Office. HoS Office. Locker Room. Processing. Evidence Storage"
	base_turf = /turf/simulated/floor
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

/area/turbolift/sec_snd
	name = "lift (ground floor)"
	lift_floor_label = "Second Floor"
	lift_floor_name = "Second Floor"
	lift_announce_str = "Arriving at Second Floor: Armory. Warden Office. Cells."
	holomap_color = HOLOMAP_AREACOLOR_SECURITY

//Wilderness Shuttle Shelter

/area/surface/outpost/shelter
	name = "Wilderness Shelter"

// Telecommunications Satellite
/area/tcommsat/cynosure
	name = "\improper Telecomms Satellite"
	icon_state = "tcomsatcham"
	ambience = AMBIENCE_ENGINEERING
	area_flags = AREA_FLAG_IS_STATION_AREA

/area/tcommsat/cynosure/entrance
	name = "\improper Telecomms Entrance"
	icon_state = "tcomsatentrance"

/area/tcommsat/cynosure/teleporter
	name = "\improper Telecomms Teleporter"
	icon_state = "tcomsatlob"

/area/tcommsat/cynosure/chamber
	name = "\improper Telecomms Central Compartment"

/area/tcommsat/cynosure/foyer
	name = "\improper Telecomms Foyer"
	icon_state = "tcomsatfoyer"

/area/tcommsat/cynosure/powercontrol
	name = "\improper Telecomms Solar Control"
	icon_state = "tcomsatwest"

/area/tcommsat/cynosure/computer
	name = "\improper Telecomms Control Room"
	icon_state = "tcomsatcomp"
	music = "signal"

/area/tcommsat/cynosure/lounge
	name = "\improper Telecomms Satellite Lounge"
	icon_state = "tcomsatlounge"

/area/tcommsat/cynosure/storage
	name = "\improper Telecommss Storage"
	icon_state = "tcomsateast"

//Shuttles

/area/shuttle/exploration
	requires_power = 1
	icon_state = "shuttle2"

/area/shuttle/exploration/general
	name = "\improper NTC Calvera Passenger Compartment"

/area/shuttle/exploration/cockpit
	name = "\improper NTC Calvera Cockpit"

/area/shuttle/exploration/cargo
	name = "\improper NTC Calvera Cargo and Engine Room"

//Centcomm Antags and Others

// Shuttles

//NT response shuttle

/area/shuttle/response_ship
	name = "\improper Response Team Ship"
	icon_state = "centcom"
	requires_power = 0
	area_flags = AREA_FLAG_IS_RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC

/area/shuttle/response_ship/start
	name = "\improper Response Team Base"
	icon_state = "shuttlered"
	base_turf = /turf/unsimulated/floor/

/area/shuttle/response_ship/firstdeck
	name = "north-west of first deck"
	icon_state = "northwest"

/area/shuttle/response_ship/seconddeck
	name = "south-east of second deck"
	icon_state = "southeast"

/area/shuttle/response_ship/thirddeck
	name = "north-east of third deck"
	icon_state = "northeast"

/area/shuttle/response_ship/planet
	name = "planetside outpost"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/outdoors/dirt/sif/planetuse

/area/shuttle/response_ship/mining
	name = "mining site"
	icon_state = "shuttlered"
	base_turf = /turf/space

/area/shuttle/response_ship/arrivals_dock
	name = "\improper docked with Cynosure"
	icon_state = "shuttle"

/area/shuttle/response_ship/orbit
	name = "in orbit of Sif"
	icon_state = "shuttlegrn"
	base_turf = /turf/space

/area/shuttle/response_ship/sky
	name = "hovering over skies of sif"
	icon_state = "shuttlegrn"
	base_turf = /turf/simulated/sky/west

/area/shuttle/response_ship/sky_transit
	name = "in flight over sif"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/sky/moving/west

/area/shuttle/response_ship/transit
	name = "transit"
	icon_state = "shuttlered"
	base_turf = /turf/space

// Centcom Transport Shuttle
/area/shuttle/transport1/centcom
	icon_state = "shuttle"
	name = "\improper Transport Shuttle"

/area/shuttle/transport1/station
	icon_state = "shuttle"
	name = "\improper Transport Shuttle Station"

// Centcom Admin Shuttle

/area/shuttle/administration/centcom
	name = "\improper Administration Shuttle"
	icon_state = "shuttlered"

/area/shuttle/administration/station
	name = "\improper Administration Shuttle Station"
	icon_state = "shuttlered2"

//Merc

/area/syndicate_mothership
	name = "\improper Mercenary Base"
	icon_state = "syndie-ship"
	requires_power = 0
	dynamic_lighting = 0
	area_flags = AREA_FLAG_IS_RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC

/area/syndicate_station
	name = "\improper Mercenary Base"
	icon_state = "syndie-ship"
	requires_power = 0
	dynamic_lighting = 0
	area_flags = AREA_FLAG_IS_RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC

/area/syndicate_station/start
	name = "\improper Mercenary Ship"
	icon_state = "shuttlered"

/area/syndicate_station/firstdeck
	name = "north-west of first deck"
	icon_state = "northwest"

/area/syndicate_station/seconddeck
	name = "north-east of second deck"
	icon_state = "northeast"

/area/syndicate_station/thirddeck
	name = "south-east of third deck"
	icon_state = "southeast"

/area/syndicate_station/mining
	name = "mining site"
	icon_state = "shuttlered"

/area/syndicate_station/planet
	name = "planetside"
	dynamic_lighting = 1
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/outdoors/grass/sif/planetuse

/area/syndicate_station/transit
	name = " transit"
	icon_state = "shuttlered"
	base_turf = /turf/space/transit/east

/area/syndicate_station/orbit
	name = "in orbit of Sif"
	icon_state = "shuttlegrn"
	base_turf = /turf/space

/area/syndicate_station/sky
	name = "hovering over skies of sif"
	icon_state = "shuttlegrn"
	base_turf = /turf/simulated/sky/west

/area/syndicate_station/sky_transit
	name = "in flight over sif"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/sky/moving/west

/area/syndicate_station/arrivals_dock
	name = "\improper docked with Southern Cross"
	dynamic_lighting = 0
	icon_state = "shuttle"

//Skipjack

/area/skipjack_station
	name = "Raider Outpost"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 0
	area_flags = AREA_FLAG_IS_RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC

/area/skipjack_station/transit
	name = "transit"
	icon_state = "shuttlered"
	base_turf = /turf/space/transit/north

/area/skipjack_station/firstdeck
	name = "north of first deck"
	icon_state = "northwest"

/area/skipjack_station/seconddeck
	name = "west of second deck"
	icon_state = "west"

/area/skipjack_station/thirddeck
	name = "east of third deck"
	icon_state = "east"

/area/skipjack_station/mining
	name = "mining site"
	icon_state = "shuttlered"

/area/skipjack_station/planet
	name = "planet"
	icon_state = "shuttlered"
	dynamic_lighting = 1
	base_turf = /turf/simulated/floor/outdoors/grass/sif/planetuse

/area/skipjack_station/orbit
	name = "in orbit of Sif"
	icon_state = "shuttlegrn"
	base_turf = /turf/space

/area/skipjack_station/sky
	name = "hovering over skies of sif"
	icon_state = "shuttlegrn"
	base_turf = /turf/simulated/sky/north

/area/skipjack_station/sky_transit
	name = "in flight over sif"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/sky/moving/north

/area/skipjack_station/arrivals_dock
	name = "\improper docked with Southern Cross"
	icon_state = "shuttle"

// Ninja areas
/area/ninja_dojo
	name = "\improper Ninja Base"
	icon_state = "green"
	requires_power = 0
	area_flags = AREA_FLAG_IS_RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC

/area/ninja_dojo/dojo
	name = "\improper Clan Dojo"
	dynamic_lighting = 0

/area/ninja_dojo/start
	name = "\improper Clan Dojo"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/plating

/area/ninja_dojo/firstdeck
	name = "south of first deck"
	icon_state = "south"

/area/ninja_dojo/seconddeck
	name = "north of second deck"
	icon_state = "north"

/area/ninja_dojo/thirddeck
	name = "west of third deck"
	icon_state = "west"

/area/ninja_dojo/mining
	name = "mining site"
	icon_state = "shuttlered"

/area/ninja_dojo/planet
	name = "planet outposts"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/outdoors/grass/sif/planetuse

/area/ninja_dojo/transit
	name = "transit"
	icon_state = "shuttlered"
	base_turf = /turf/space/transit/north

/area/ninja_dojo/orbit
	name = "in orbit of Sif"
	icon_state = "shuttlegrn"
	base_turf = /turf/space

/area/ninja_dojo/sky
	name = "hovering over skies of sif"
	icon_state = "shuttlegrn"
	base_turf = /turf/simulated/sky/south

/area/ninja_dojo/sky_transit
	name = "in flight over sif"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/sky/moving/south

/area/ninja_dojo/arrivals_dock
	name = "\improper docked with Southern Cross"
	icon_state = "shuttle"
	dynamic_lighting = 0

//Trade Ship

/area/shuttle/merchant
	icon_state = "shuttle"

/area/shuttle/merchant/home
	name = "\improper Merchant Vessel - Home"

/area/shuttle/merchant/away
	name = "\improper Merchant Vessel - Away"


// Main escape shuttle

// Note: Keeping this "legacy" area path becuase of its use in lots of legacy code.
/area/shuttle/escape/centcom
	name = "\improper Emergency Shuttle"
	icon_state = "shuttle"
	dynamic_lighting = 0

//Small Escape Pods

/area/shuttle/escape_pod1
	name = "\improper Escape Pod One"
	music = "music/escape.ogg"

/area/shuttle/escape_pod1/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/airless

/area/shuttle/escape_pod1/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod1/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod2
	name = "\improper Escape Pod Two"
	music = "music/escape.ogg"

/area/shuttle/escape_pod2/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/airless

/area/shuttle/escape_pod2/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod2/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod3
	name = "\improper Escape Pod Three"
	music = "music/escape.ogg"

/area/shuttle/escape_pod3/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/airless

/area/shuttle/escape_pod3/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod3/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod4
	name = "\improper Escape Pod Four"
	music = "music/escape.ogg"

/area/shuttle/escape_pod4/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/airless

/area/shuttle/escape_pod4/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod4/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod5
	name = "\improper Escape Pod Five"
	music = "music/escape.ogg"

/area/shuttle/escape_pod5/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/airless

/area/shuttle/escape_pod5/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod5/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod6
	name = "\improper Escape Pod Six"
	music = "music/escape.ogg"

/area/shuttle/escape_pod6/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/airless

/area/shuttle/escape_pod6/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod6/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod7
	name = "\improper Escape Pod Seven"
	music = "music/escape.ogg"

/area/shuttle/escape_pod7/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/reinforced/airless

/area/shuttle/escape_pod7/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod7/transit
	icon_state = "shuttle"

/area/shuttle/escape_pod8
	name = "\improper Escape Pod Eight"
	music = "music/escape.ogg"

/area/shuttle/escape_pod8/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/reinforced/airless

/area/shuttle/escape_pod8/centcom
	icon_state = "shuttle"

/area/shuttle/escape_pod8/transit
	icon_state = "shuttle"

//Large Escape Pods

/area/shuttle/large_escape_pod1
	name = "\improper Large Escape Pod One"
	music = "music/escape.ogg"

/area/shuttle/large_escape_pod1/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/airless

/area/shuttle/large_escape_pod1/centcom
	icon_state = "shuttle"

/area/shuttle/large_escape_pod1/transit
	icon_state = "shuttle"

/area/shuttle/large_escape_pod2
	name = "\improper Large Escape Pod Two"
	music = "music/escape.ogg"

/area/shuttle/large_escape_pod2/station
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/airless

/area/shuttle/large_escape_pod2/centcom
	icon_state = "shuttle"

/area/shuttle/large_escape_pod2/transit
	icon_state = "shuttle"

// Wilderness spawn areas.
/area/surface/wilderness/shack
	name = "Wilderness Shack"

/area/surface/outpost/checkpoint
	name = "Exterior Checkpoint"
