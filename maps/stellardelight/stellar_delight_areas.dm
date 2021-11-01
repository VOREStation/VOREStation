/area/stellardelight
	name = "Stellar Delight"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "blublatri"
	requires_power = TRUE
	dynamic_lighting = TRUE

/area/maintenance/stellardelight
	name = "maintenance"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "purblasqu"
	flags = RAD_SHIELDED
	ambience = AMBIENCE_MAINTENANCE

/area/maintenance/stellardelight/substation/atmospherics
	name = "Atmospherics Substation"
/area/maintenance/stellardelight/substation/cargo
	name = "Cargo Substation"
/area/maintenance/stellardelight/substation/civilian
	name = "Civilian Substation"
/area/maintenance/stellardelight/substation/command
	name = "Command Substation"
/area/maintenance/stellardelight/substation/engineering
	name = "Engineering Substation"
/area/maintenance/stellardelight/substation/exploration
	name = "Exploration Substation"
/area/maintenance/stellardelight/substation/medical
	name = "Medical Substation"
/area/maintenance/stellardelight/substation/research
	name = "Research Substation"
/area/maintenance/stellardelight/substation/security
	name = "Security Substation"

/area/maintenance/stellardelight/deck1
	icon_state = "deckmaint1"

/area/maintenance/stellardelight/deck1/portfore
	name = "deck one port forward maintenance"
/area/maintenance/stellardelight/deck1/starboardfore
	name = "deck one starboard forward maintenance"
/area/maintenance/stellardelight/deck1/portcent
	name = "deck one port center maintenance"
/area/maintenance/stellardelight/deck1/starboardcent
	name = "deck one starboard center maintenance"
/area/maintenance/stellardelight/deck1/portaft
	name = "deck one port aft maintenance"
/area/maintenance/stellardelight/deck1/exploration
	name = "exploration maintenance"
/area/maintenance/stellardelight/deck1/starboardaft
	name = "deck one starboard aft maintenance"

/area/maintenance/stellardelight/deck2
	icon_state = "deckmaint2"

/area/maintenance/stellardelight/deck2/portfore
	name = "deck two port forward maintenance"
/area/maintenance/stellardelight/deck2/starboardfore
	name = "deck two starboard forward maintenance"
/area/maintenance/stellardelight/deck2/portaft
	name = "deck two port aft maintenance"
/area/maintenance/stellardelight/deck2/starboardaft
	name = "deck two starboard aft maintenance"
/area/maintenance/stellardelight/deck2/portsolars
	name = "deck two port solar array"
/area/maintenance/stellardelight/deck2/starboardsolars
	name = "deck two starboard solar array"
/area/maintenance/stellardelight/deck2/atmos
	name = "atmospherics maintenance"


/area/maintenance/stellardelight/deck3
	icon_state = "deckmaint3"

/area/maintenance/stellardelight/deck3/portfore
	name = "deck three port forward maintenance"
/area/maintenance/stellardelight/deck3/starboardfore
	name = "deck three starboard forward maintenance"
/area/maintenance/stellardelight/deck3/portcent
	name = "deck three port central maintenance"
/area/maintenance/stellardelight/deck3/starboardcent
	name = "deck three starboard central maintenance"
/area/maintenance/stellardelight/deck3/portaft
	name = "deck three port aft maintenance"
/area/maintenance/stellardelight/deck3/starboardaft
	name = "deck three starboard aft maintenance"

/area/maintenance/stellardelight/deck3/foreportrooma
	name = "deck three forward port construction a"
/area/maintenance/stellardelight/deck3/foreportroomb
	name = "deck three forward port construction b"
/area/maintenance/stellardelight/deck3/forestarrooma
	name = "deck three forward starboard construction a"
/area/maintenance/stellardelight/deck3/forestarroomb
	name = "deck three forward starboard construction b"
/area/maintenance/stellardelight/deck3/forestarroomc
	name = "deck three forward starboard construction c"
/area/maintenance/stellardelight/deck3/aftstarroom
	name = "deck three aft starboard construction "


/area/maintenance/stellardelight/deck3/portfore
/area/maintenance/stellardelight/deck3/starboardfore


/area/stellardelight/deck1
	name = "Deck One"
	icon_state = "deck1"

/area/stellardelight/deck1/fore
	name = "Deck One Fore"
	sound_env = LARGE_ENCLOSED

/area/stellardelight/deck1/port
	name = "Deck One Port"
	sound_env = LARGE_ENCLOSED

/area/stellardelight/deck1/starboard
	name = "Deck One Starboard"
	sound_env = LARGE_ENCLOSED

/area/stellardelight/deck1/aft
	name = "Deck One Aft"
	sound_env = LARGE_ENCLOSED

/area/stellardelight/deck1/dorms
	name = "Dormitory"
	sound_env = SMALL_SOFTFLOOR
	flags = RAD_SHIELDED| BLUE_SHIELDED |AREA_FLAG_IS_NOT_PERSISTENT
	soundproofed = TRUE
	limit_mob_size = FALSE
	block_suit_sensors = TRUE

/area/stellardelight/deck1/dorms/dorm1
	name = "Dormitory One"
	icon_state = "dorm1"
/area/stellardelight/deck1/dorms/dorm2
	name = "Dormitory Two"
	icon_state = "dorm2"
/area/stellardelight/deck1/dorms/dorm3
	name = "Dormitory Three"
	icon_state = "dorm3"
/area/stellardelight/deck1/dorms/dorm4
	name = "Dormitory Four"
	icon_state = "dorm4"
/area/stellardelight/deck1/dorms/dorm5
	name = "Dormitory Five"
	icon_state = "dorm5"
/area/stellardelight/deck1/dorms/dorm6
	name = "Dormitory Six"
	icon_state = "dorm6"
/area/stellardelight/deck1/dorms/dorm7
	name = "Dormitory Seven"
	icon_state = "dorm7"
/area/stellardelight/deck1/dorms/dorm8
	name = "Dormitory Eight"
	icon_state = "dorm8"

/area/stellardelight/deck1/researchequip
	name = "Research Equipment"
/area/stellardelight/deck1/researchhall
	name = "Research Hallway"
/area/stellardelight/deck1/researchserver
	name = "Research Server Room"

/area/stellardelight/deck1/shower
	name = "Showers"

/area/stellardelight/deck1/mining
	name = "Mining Hallway"
/area/stellardelight/deck1/oreprocessing
	name = "Ore Processing"
/area/stellardelight/deck1/miningequipment
	name = "Mining Equipment"

/area/stellardelight/deck1/shuttlebay
	name = "Shuttle Bay"
	ambience = AMBIENCE_HANGAR
	sound_env = LARGE_ENCLOSED
/area/stellardelight/deck1/miningshuttle
	name = "Mining Shuttle"
/area/stellardelight/deck1/exploshuttle
	name = "Exploration Shuttle"

/area/stellardelight/deck1/exploration
	name = "Exploration Hallway"
/area/stellardelight/deck1/exploequipment
	name = "Exploration Equipment"
/area/stellardelight/deck1/explobriefing
	name = "Exploration Briefing"
/area/stellardelight/deck1/pathfinder
	name = "Pathfinder"

/area/stellardelight/deck1/pilot
	name = "Pilot Equipment"

/area/stellardelight/deck1/resleeving
	name = "Resleeving Lab"
/area/stellardelight/deck1/paramedic
	name = "Paramedic Equipment"
/area/stellardelight/deck1/lowermed
	name = "Lower Medical"


/area/stellardelight/deck2
	name = "Deck Two"
	icon_state = "deck2"

/area/stellardelight/deck2/fore
	name = "Deck Two Fore"
	sound_env = LARGE_ENCLOSED

/area/stellardelight/deck2/port
	name = "Deck Two Port"
	sound_env = LARGE_ENCLOSED

/area/stellardelight/deck2/starboard
	name = "Deck Two Starboard"
	sound_env = LARGE_ENCLOSED

/area/stellardelight/deck2/aftport
	name = "Deck Two Aft Port"
	sound_env = LARGE_ENCLOSED

/area/stellardelight/deck2/aftstarboard
	name = "Deck Two Aft Starboard"
	sound_env = LARGE_ENCLOSED

/area/stellardelight/deck2/central
	name = "Deck Two Central"
	sound_env = LARGE_ENCLOSED

/area/stellardelight/deck2/barbackroom
	name = "Bar Backroom"
	sound_env = SMALL_SOFTFLOOR

/area/stellardelight/deck2/portescape
	name = "Port Escape Pod"
	requires_power = FALSE
/area/stellardelight/deck2/starboardescape
	name = "Starboard Escape Pod"
	requires_power = FALSE

/area/stellardelight/deck2/o2production
	name = "O2 Production"
	ambience = AMBIENCE_ATMOS
/area/stellardelight/deck2/fuelstorage
	name = "Primary Fuel Storage"
	ambience = AMBIENCE_ATMOS
/area/stellardelight/deck2/combustionworkshop
	name = "Combustion Workshop"
	ambience = AMBIENCE_ATMOS

/area/stellardelight/deck2/triage
	name = "Triage"

/area/stellardelight/deck2/briefingroom
	name = "Command Briefing Room"
	sound_env = SMALL_SOFTFLOOR

/area/stellardelight/deck3
	name = "Deck Three"
	icon_state = "deck3"

/area/stellardelight/deck3/aft
	name = "Deck Three Aft"
	ambience = AMBIENCE_ARRIVALS
/area/stellardelight/deck3/cafe
	name = "Cafe"
/area/stellardelight/deck3/commandhall
	name = "Command Office Hallway"

/area/stellardelight/deck3/transitgateway
	name = "Transit Gateway"
/area/stellardelight/deck3/cryo
	name = "Cryogenic Storage"

/area/stellardelight/deck3/readingroom
	name = "Reading Rooms"
	sound_env = SMALL_SOFTFLOOR

/area/stellardelight/deck3/portdock
	name = "Port Dock"
	ambience = AMBIENCE_ARRIVALS

/area/stellardelight/deck3/starboarddock
	name = "Starboard Dock"
	ambience = AMBIENCE_ARRIVALS

/area/stellardelight/deck1/exterior
	name = "Deck One Exterior"
/area/stellardelight/deck2/exterior
	name = "Deck Two Exterior"
/area/stellardelight/deck3/exterior
	name = "Deck Three Exterior"

