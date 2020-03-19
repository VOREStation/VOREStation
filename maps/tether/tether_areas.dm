//Debug areas
/area/tether/surfacebase
	name = "Tether Debug Surface"

/area/tether/transit
	name = "Tether Debug Transit"
	requires_power = 0

/area/tether/space
	name = "Tether Debug Space"
	requires_power = 0

// Tether Areas itself
/area/tether/surfacebase/tether
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "tether1"
/area/tether/transit/tether
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "tether2"
/area/tether/space/tether
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "tether3"

// Elevator areas.
/area/turbolift
	delay_time = 2 SECONDS
	forced_ambience = list('sound/music/elevator.ogg')
	dynamic_lighting = FALSE //Temporary fix for elevator lighting

	requires_power = FALSE

/area/turbolift/tether/transit
	name = "tether (midway)"
	lift_floor_label = "Tether Midpoint"
	lift_floor_name = "Midpoint"
	lift_announce_str = "Arriving at tether midway point."
	delay_time = 5 SECONDS

/area/turbolift/t_surface/level1
	name = "surface (level 1)"
	lift_floor_label = "Surface 1"
	lift_floor_name = "Tram, Dorms, Mining, Surf. EVA"
	lift_announce_str = "Arriving at Base Level 1."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/t_surface/level2
	name = "surface (level 2)"
	lift_floor_label = "Surface 2"
	lift_floor_name = "Atmos, Chapel, Maintenance"
	lift_announce_str = "Arriving at Base Level 2."

/area/turbolift/t_surface/level3
	name = "surface (level 3)"
	lift_floor_label = "Surface 3"
	lift_floor_name = "Bridge, Science, Bar, Pool"
	lift_announce_str = "Arriving at Base Level 3."

/area/turbolift/t_station/level1
	name = "asteroid (level 1)"
	lift_floor_label = "Asteroid 1"
	lift_floor_name = "Eng, Secondary Bridge, Park, Cryo, Visitor Offices"
	lift_announce_str = "Arriving at Station Level 1."

/area/turbolift/t_station/level2
	name = "asteroid (level 2)"
	lift_floor_label = "Asteroid 2"
	lift_floor_name = "Exploration, AI Core, EVA Gear"
	lift_announce_str = "Arriving at Station Level 2."

/area/turbolift/t_station/level3
	name = "asteroid (level 3)"
	lift_floor_label = "Asteroid 3"
	lift_floor_name = "Medical, Security, Cargo"
	lift_announce_str = "Arriving at Station Level 3."

/area/vacant/vacant_restaurant_upper
	name = "\improper Vacant Restaurant"
	icon_state = "vacant_site"
	flags = null

/area/vacant/vacant_restaurant_lower
	name = "\improper Vacant Restaurant"
	icon_state = "vacant_site"
	flags = null

/area/engineering/engineering_airlock
	name = "\improper Engineering Airlock"
	icon_state = "engine_eva"

/area/engineering/hallway
	name = "\improper Engineering Hallway"
	icon_state = "engineering"

/area/engineering/shaft
	name = "\improper Engineering Electrical Shaft"
	icon_state = "substation"

/area/vacant/vacant_office
	name = "\improper Vacant Office"
	icon_state = "vacant_site"

/area/centcom/simulated
	dynamic_lighting = 1

/area/centcom/simulated/terminal
	name = "\improper Docking Terminal"
	icon_state = "centcom_dock"
	ambience = AMBIENCE_ARRIVALS

/area/centcom/simulated/medical
	name = "\improper CentCom Medical"
	icon_state = "centcom_medical"

/area/centcom/simulated/restaurant
	name = "\improper CentCom Restaurant"
	icon_state = "centcom_crew"

/area/centcom/simulated/bathroom
	name = "\improper CentCom Bathroom"
	icon_state = "centcom_crew"

/area/centcom/simulated/living
	name = "\improper CentCom Living Quarters"

/area/centcom/simulated/main_hall
	name = "\improper Main Hallway"
	icon_state = "centcom_hallway1"

/area/centcom/simulated/evac
	name = "\improper CentCom Emergency Shuttle"

/area/centcom/simulated/bar
	name = "\improper CentCom Bar"
	icon_state = "centcom_crew"

/area/centcom/simulated/security
	name = "\improper CentCom Security"
	icon_state = "centcom_security"


//
// Surface Base Z Levels
//

/area/tether/surfacebase
	icon = 'icons/turf/areas_vr.dmi'


/area/tether/surfacebase/outside
	name = "Outside - Surface"
	sound_env = MOUNTAINS
/area/tether/surfacebase/outside/outside1
	icon_state = "outside1"
/area/tether/surfacebase/outside/outside2
	icon_state = "outside2"
/area/tether/surfacebase/outside/outside3
	icon_state = "outside3"

/area/tether/surfacebase/outside/empty
	name = "Outside - Empty Area"

/area/tether/surfacebase/outside/wilderness
	name = "Outside - Wilderness"
	icon_state = "invi"
	forced_ambience = list('sound/music/Sacred_Grove.ogg')

/area/tether/surfacebase/temple
	name = "Outside - Wilderness" // ToDo: Make a way to hide spoiler areas off the list of areas ghosts can jump to.
	icon_state = "red"

/area/tether/surfacebase/crash
	name = "Outside - Wilderness" // ToDo: Make a way to hide spoiler areas off the list of areas ghosts can jump to.
	icon_state = "yellow"

/area/tether/surfacebase/tram
	name = "\improper Tram Station"
	icon_state = "dk_yellow"

/area/tether/surfacebase/surface_one_hall
	name = "\improper First Floor Hallway"
	icon_state = "dk_yellow"
/area/tether/surfacebase/surface_two_hall
	name = "\improper Second Floor Hallway"
	icon_state = "dk_yellow"
/area/tether/surfacebase/surface_three_hall
	name = "\improper Third Floor Hallway"
	icon_state = "dk_yellow"

/area/tether/surfacebase/north_stairs_one
	name = "\improper North Stairwell First Floor"
	icon_state = "dk_yellow"
/area/tether/surfacebase/north_staires_two
	name = "\improper North Stairwell Second Floor"
	icon_state = "dk_yellow"
/area/tether/surfacebase/north_stairs_three
	name = "\improper North Stairwell Third Floor"
	icon_state = "dk_yellow"

/area/tether/surfacebase/public_garden_one
	name = "\improper Public Garden First Floor"
	icon_state = "green"
/area/tether/surfacebase/public_garden_two
	name = "\improper Public Garden Second Floor"
	icon_state = "green"
/area/tether/surfacebase/public_garden_three
	name = "\improper Public Garden Third Floor"
	icon_state = "green"
/area/tether/surfacebase/public_garden
	name = "\improper Public Garden"
	icon_state = "purple"
/area/tether/surfacebase/fish_farm
	name = "\improper Fish Farm"
	icon_state = "red"
/area/tether/surfacebase/bar_backroom
	name = "\improper Bar Backroom"
	icon_state = "red"
	sound_env = SMALL_SOFTFLOOR

// /area/tether/surfacebase/east_stairs_one //This is just part of a lower hallway

/area/tether/surfacebase/east_stairs_two
	name = "\improper East Stairwell Second Floor"
	icon_state = "dk_yellow"
/area/vacant/vacant_site/east
	name = "\improper East Base Vacant Site"
	flags = null
/area/vacant/vacant_library
	name = "\improper Atrium Construction Site"
/area/vacant/vacant_bar
	name = "\improper Vacant Bar"
/area/vacant/vacant_bar_upper
	name = "\improper Upper Vacant Bar"
/area/vacant/vacant_site/gateway
	name = "\improper Vacant Prep Area"
/area/vacant/vacant_site/gateway/lower
	name = "\improper Lower Vacant Prep Area"

// /area/tether/surfacebase/east_stairs_three //This is just part of an upper hallway

/area/tether/surfacebase/emergency_storage
	icon_state = "emergencystorage"
/area/tether/surfacebase/emergency_storage/panic_shelter
	name = "\improper Panic Shelter Emergency Storage"
/area/tether/surfacebase/emergency_storage/rnd
	name = "\improper RnD Emergency Storage"
/area/tether/surfacebase/emergency_storage/atmos
	name = "\improper Atmospherics Emergency Storage"
/area/tether/surfacebase/emergency_storage/atrium
	name = "\improper Atrium Emergency Storage"

// Main mining area
/area/tether/surfacebase/mining_main
	icon_state = "outpost_mine_main"
/area/tether/surfacebase/mining_main/airlock
	name = "\improper Mining Airlock"
/area/tether/surfacebase/mining_main/storage
	name = "\improper Mining Gear Storage"
/area/tether/surfacebase/mining_main/uxstorage
	name = "\improper Mining Secondary Storage"
/area/tether/surfacebase/mining_main/ore
	name = "\improper Mining Ore Storage"
/area/tether/surfacebase/mining_main/eva
	name = "\improper Mining EVA"
/area/tether/surfacebase/mining_main/break_room
	name = "\improper Mining Crew Area"
/area/tether/surfacebase/mining_main/refinery
	name = "\improper Mining Refinery"
/area/tether/surfacebase/mining_main/external
	name = "\improper Mining Refinery"
/area/tether/surfacebase/mining_main/bathroom
	name = "\improper Mining Bathroom"
/area/tether/surfacebase/mining_main/lobby
	name = "\improper Mining Lobby"
/area/tether/surfacebase/mining_main/surfacecargo
	name = "\improper Surface Cargo Office"
	lightswitch = 0

// Mining Underdark
/area/mine/unexplored/underdark
	name = "\improper Mining Underdark"
	base_turf = /turf/simulated/mineral/floor/virgo3b
/area/mine/explored/underdark
	name = "\improper Mining Underdark"
	base_turf = /turf/simulated/mineral/floor/virgo3b

// Mining outpost areas
/area/outpost/mining_main/passage
	name = "\improper Mining Outpost Passage"

// Solars map areas
/area/tether/outpost/solars_outside
	name = "\improper Solar Farm"
/area/tether/outpost/solars_shed
	name = "\improper Solar Farm Shed"

// Exploration area - Plains
/area/tether/outpost/exploration_plains
	name = "\improper Plains Exploration Zone"
	icon_state = "green"
/area/tether/outpost/exploration_shed
	name = "\improper Plains Entrance Shed"

/area/maintenance/substation/medsec
	name = "\improper MedSec Substation"
/area/maintenance/substation/mining
	name = "\improper Mining Substation"
/area/maintenance/substation/bar
	name = "\improper Bar Substation"
/area/maintenance/substation/surface_atmos
	name = "\improper Surface Atmos Substation"
/area/maintenance/substation/civ_west
	name = "\improper Civilian West Substation"
/area/maintenance/substation/exploration
	name = "\improper Exploration Substation"
/area/maintenance/tether_midpoint
	name = "\improper Tether Midpoint Maint"
/area/maintenance/commandmaint
	name = "\improper Command Maintenance"

/area/tether/surfacebase/medical
	icon_state = "medical"
/area/tether/surfacebase/medical/lobby
	name = "\improper Surface Medical Lobby"
/area/tether/surfacebase/medical/triage
	name = "\improper Surface Triage"
/area/tether/surfacebase/medical/first_aid_west
	name = "\improper First Aid West"
/area/tether/surfacebase/medical/chemistry
	name = "\improper Surface Chemistry"
	lightswitch = 0
/area/tether/surfacebase/medical/resleeving
	name = "\improper Surface Resleeving"
	lightswitch = 0
/area/tether/surfacebase/medical/surgery
	name = "\improper Surface Surgery"
	lightswitch = 0
/area/tether/surfacebase/medical/patient_a
	name = "\improper Surface Patient Room A"
	lightswitch = 0
/area/tether/surfacebase/medical/patient_b
	name = "\improper Surface Patient Room B"
	lightswitch = 0
/area/tether/surfacebase/medical/lowerhall
	name = "\improper Surface Medical Lower Hall"
/area/tether/surfacebase/medical/storage
	name = "\improper Surface Medical Storage"
	lightswitch = 0
/area/tether/surfacebase/medical/paramed
	name = "\improper Surface Paramedic Closet"
	lightswitch = 0
/area/tether/surfacebase/medical/breakroom
	name = "\improper Surface Medical Break Room"
	lightswitch = 0
/area/tether/surfacebase/medical/maints
	name = "\improper Mining Upper Maintenance"

/area/tether/surfacebase/library/study
	name = "\improper Library Private Study"
	lightswitch = 0
	icon_state = "library"

/area/tether/surfacebase/security
	icon_state = "security"
/area/tether/surfacebase/security/breakroom
	name = "\improper Surface Security Break Room"
	lightswitch = 0
	sound_env = MEDIUM_SOFTFLOOR
/area/tether/surfacebase/security/lobby
	name = "\improper Surface Security Lobby"
/area/tether/surfacebase/security/common
	name = "\improper Surface Security Room"
/area/tether/surfacebase/security/armory
	name = "\improper Surface Equipment Storage"
	lightswitch = 0
/area/tether/surfacebase/security/checkpoint
	name = "\improper Surface Checkpoint Office"
/area/tether/surfacebase/security/hallway
	name = "\improper Surface Checkpoint Hallway"
/area/tether/surfacebase/security/warden
	name = "\improper Surface Security Warden's Office"
	lightswitch = 0
/area/tether/surfacebase/security/lowerhallway
	name = "\improper Surface Security Lower Hallway"
/area/tether/surfacebase/security/evidence
	name = "\improper Surface Security Evidence Storage"
	lightswitch = 0
/area/tether/surfacebase/security/brig
	name = "\improper Surface Security Brig"
	lightswitch = 0
/area/tether/surfacebase/security/solitary
	name = "\improper Surface Security Solitary Confinement"
	lightswitch = 0
	sound_env =PADDED_CELL
/area/tether/surfacebase/security/gasstorage
	name = "\improper Surface Security Gas Storage"
	lightswitch = 0
/area/tether/surfacebase/security/interrogation
	name = "\improper Surface Security Interrogation"
	lightswitch = 0
	sound_env = SMALL_ENCLOSED
/area/tether/surfacebase/security/processing
	name = "\improper Surface Security Processing"
	lightswitch = 0
/area/tether/surfacebase/security/lobby
	name = "\improper Surface Security Lobby"
/area/tether/surfacebase/security/frontdesk
	name = "\improper Surface Security Front Desk"
	lightswitch = 0
/area/tether/surfacebase/security/upperhall
	name = "\improper Surface Security Upper Hallway"
/area/maintenance/lower/security
	name = "\improper Surface Security Maintenance"

/area/engineering/atmos/processing
	name = "Atmospherics Processing"
	icon_state = "atmos"
	sound_env = LARGE_ENCLOSED

/area/engineering/atmos/gas_storage
	name = "Atmospherics Gas Storage"
	icon_state = "atmos"

//TFF 11/12/19 - Minor refactor, makes mice spawn only in Atmos.
/area/engineering/atmos_intake
	name = "\improper Atmospherics Intake"
	icon_state = "atmos"
	sound_env = MOUNTAINS

/area/engineering/atmos/hallway
	name = "\improper Atmospherics Main Hallway"
/area/engineering/lower/lobby
	name = "\improper Enginering Surface Lobby"
/area/engineering/lower/breakroom
	name = "\improper Enginering Surface Break Room"
/area/engineering/lower/corridor
	name = "\improper Tether Lower Service Corridor"
/area/engineering/lower/atmos_lockers
	name = "\improper Engineering Atmos Locker Room"
/area/engineering/lower/atmos_eva
	name = "\improper Engineering Atmos EVA"

/area/gateway/prep_room
	name = "\improper Gateway Prep Room"
/area/crew_quarters/locker/laundry_arrival
	name = "\improper Arrivals Laundry"

/area/maintenance/lower
	icon_state = "fsmaint"

/area/maintenance/lower/xenoflora
	name = "\improper Xenoflora Maintenance"
/area/maintenance/lower/research
	name = "\improper Research Maintenance"
/area/maintenance/lower/atmos
	name = "\improper Atmospherics Maintenance"
/area/maintenance/lower/locker_room
	name = "\improper Locker Room Maintenance"
/area/maintenance/lower/vacant_site
	name = "\improper Vacant Site Maintenance"
/area/maintenance/lower/atrium
	name = "\improper Atrium Maintenance"
/area/maintenance/lower/rnd
	name = "\improper RnD Maintenance"
/area/maintenance/lower/north
	name = "\improper North Maintenance"
/area/maintenance/lower/bar
	name = "\improper Bar Maintenance"
/area/maintenance/lower/mining
	name = "\improper Mining Maintenance"
/area/maintenance/lower/south
	name = "\improper South Maintenance"
/area/maintenance/lower/trash_pit
	name = "\improper Trash Pit"
/area/maintenance/lower/solars
	name = "\improper Solars Maintenance"
/area/maintenance/lower/mining_eva
	name = "\improper Mining EVA Maintenance"
/area/maintenance/lower/public_garden_maintenence
	name = "\improper Public Garden Maintenence"
/area/maintenance/lower/public_garden_maintenence/upper
	name = "\improper Upper Public Garden Maintenence"
/area/maintenance/lower/medsec_maintenance
	name = "\improper Surface MedSec Maintenance"

// Research
/area/rnd/xenobiology/xenoflora/lab_atmos
	name = "\improper Xenoflora Atmospherics Lab"
/area/rnd/breakroom
	name = "\improper Research Break Room"
	icon_state = "research"
/area/rnd/reception_desk
	name = "\improper Research Reception Desk"
	icon_state = "research"
/area/rnd/lockers
	name = "\improper Research Locker Room"
	icon_state = "research"
/area/rnd/external
	name = "\improper Research External Access"
	icon_state = "research"
/area/rnd/hallway
	name = "\improper Research Lower Hallway"
	icon_state = "research"
/area/rnd/xenoarch_storage
	name = "\improper Xenoarch Storage"
	icon_state = "research"
/area/rnd/chemistry_lab
	name = "\improper Research Chemistry Lab"
	icon_state = "research"
/area/rnd/miscellaneous_lab
	name = "\improper Research Miscellaneous Lab"
	icon_state = "research"
/area/rnd/staircase/secondfloor
	name = "\improper Research Staircase Second Floor"
	icon_state = "research"
/area/rnd/staircase/thirdfloor
	name = "\improper Research Staircase Third Floor"
	icon_state = "research"
/area/rnd/breakroom/bathroom
	name = "\improper Research Bathroom"
	icon_state = "research"

//TFF 28/8/19 - cleanup of areas placement
/area/rnd/research/testingrange
	name = "\improper Weapons Testing Range"
	icon_state = "firingrange"

/area/rnd/research/researchdivision
	name = "\improper Research Division"
	icon_state = "research"


//Outpost areas
//TFF 28/8/19 - cleanup of areas placement
/area/rnd/outpost
	name = "\improper Research Outpost Hallway"
	icon_state = "research"

/area/rnd/outpost/breakroom
	name = "\improper Research Outpost Breakroom"
	icon_state = "research"

/area/rnd/outpost/airlock
	name = "\improper Research Outpost Airlock"
	icon_state = "green"

/area/rnd/outpost/eva
	name = "Research Outpost EVA Storage"
	icon_state = "eva"

/area/rnd/outpost/chamber
	name = "\improper Research Outpost Burn Chamber"
	icon_state = "engine"

/area/rnd/outpost/atmos
	name = "Research Outpost Atmospherics"
	icon_state = "atmos"

/area/rnd/outpost/storage
	name = "\improper Research Outpost Gas Storage"
	icon_state = "toxstorage"

/area/rnd/outpost/mixing
	name = "\improper Research Outpost Gas Mixing"
	icon_state = "toxmix"

/area/rnd/outpost/heating
	name = "\improper Research Outpost Gas Heating"
	icon_state = "toxmix"

/area/rnd/outpost/testing
	name = "\improper Research Outpost Testing"
	icon_state = "toxtest"

/area/maintenance/substation/outpost
	name = "Research Outpost Substation"

/area/rnd/outpost/anomaly_lab
	name = "\improper Research Outpost Anomaly Lab"
	icon_state = "research"
/area/rnd/outpost/anomaly_lab/analysis
	name = "\improper Anomaly Lab Analysis Chamber"
	icon_state = "research"
/area/rnd/outpost/anomaly_lab/testing
	name = "\improper Anomaly Lab Testing Chamber"
	icon_state = "research"
/area/rnd/outpost/anomaly_lab/airlock
	name = "\improper Anomaly Lab Testing Chamber Airlock"
	icon_state = "research"
/area/rnd/outpost/anomaly_lab/storage
	name = "\improper Anomaly Storage"
	icon_state = "research"
/area/rnd/outpost/xenoarch_storage
	name = "\improper Research Outpost Xenoarch Storage"
	icon_state = "research"


// Xenobiology Outpost Areas
/area/rnd/outpost/xenobiology/outpost_north_airlock
	name = "\improper Xenbiology Northern Airlock"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_south_airlock
	name = "\improper Xenbiology Southern Airlock"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_hallway
	name = "\improper Xenbiology Access Corridor"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_breakroom
	name = "\improper Xenbiology Breakroom"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_office
	name = "\improper Xenbiology Main Office"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_autopsy
	name = "\improper Xenbiology Alien Autopsy Room"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_decon
	name = "\improper Xenbiology Decontamination and Showers"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_first_aid
	name = "\improper Xenbiology First Aid"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_slimepens
	name = "\improper Xenbiology Slime and Xenos Containment"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_main
	name = "\improper Xenbiology Main Outpost"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_storage
	name = "\improper Xenbiology Equipment Storage"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_stairs
	name = "\improper Xenbiology Stairwell"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_substation
	name = "\improper Xenbiology SMES Substation"
	icon_state = "research"

// Misc
/area/hallway/lower/third_south
	name = "\improper Hallway Third Floor South"
	icon_state = "hallC1"
/area/hallway/lower/first_west
	name = "\improper Hallway First Floor West"
	icon_state = "hallC1"

/area/storage/surface_eva
	icon_state = "storage"
	name = "\improper Surface EVA"
/area/storage/surface_eva/external
	name = "\improper Surface EVA Access"

/area/tether/surfacebase/shuttle_pad
	name = "\improper Tether Shuttle Pad"
/area/tether/surfacebase/reading_room
	name = "\improper Reading Room"
/area/tether/surfacebase/vacant_site
	name = "\improper Vacant Site"
	flags = null
/area/crew_quarters/freezer
	name = "\improper Kitchen Freezer"
/area/crew_quarters/panic_shelter
	name = "\improper Panic Shelter"
	flags = RAD_SHIELDED	//It just makes sense

/area/tether/station/public_meeting_room
	name = "Public Meeting Room"
	icon_state = "blue"
	sound_env = SMALL_SOFTFLOOR
//TFF 28/8/19 - cleanup of areas placement
/area/chapel/observation
	name = "\improper Chapel Observation"
	icon_state = "chapel"

//
// Station Z Levels
//
// Note: Fore is NORTH

/area/tether/station/stairs_one
	name = "\improper Station Stairwell First Floor"
	icon_state = "dk_yellow"
/area/tether/station/stairs_two
	name = "\improper Station Stairwell Second Floor"
	icon_state = "dk_yellow"
/area/tether/station/stairs_three
	name = "\improper Station Stairwell Third Floor"
	icon_state = "dk_yellow"
/area/tether/station/dock_one
	name = "\improper Dock One"
	icon_state = "dk_yellow"
/area/tether/station/dock_two
	name = "\improper Dock Two"
	icon_state = "dk_yellow"

/area/tether/station/burial
	name = "\improper Burial"
	icon_state = "chapel_morgue"

/area/crew_quarters/showers
	name = "\improper Unisex Showers"
	icon_state = "recreation_area_restroom"

/area/crew_quarters/sleep/maintDorm1
	name = "\improper Construction Dorm 1"
	icon_state = "Sleep"
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/maintDorm2
	name = "\improper Construction Dorm 2"
	icon_state = "Sleep"
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/maintDorm3
	name = "\improper Construction Dorm 3"
	icon_state = "Sleep"
	flags = RAD_SHIELDED

/area/crew_quarters/sleep/maintDorm4
	name = "\improper Construction Dorm 4"
	icon_state = "Sleep"
	flags = RAD_SHIELDED

//TFF 28/8/19 - cleanup of areas placement
/area/crew_quarters/sleep/vistor_room_1
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_2
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_3
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_4
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_5
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_6
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_7
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_8
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_9
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_10
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_11
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/vistor_room_12
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_1
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_2
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_3
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_4
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_5
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_6
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_7
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_8
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_9
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_10
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_1/holo
	name = "\improper Dorm 1 Holodeck"
	icon_state = "dk_yellow"
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_3/holo
	name = "\improper Dorm 3 Holodeck"
	icon_state = "dk_yellow"
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_5/holo
	name = "\improper Dorm 5 Holodeck"
	icon_state = "dk_yellow"
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/Dorm_7/holo
	name = "\improper Dorm 7 Holodeck"
	icon_state = "dk_yellow"
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/crew_quarters/sleep/spacedorm1
	name = "\improper Visitor Lodging 1"
	icon_state = "dk_yellow"
	lightswitch = 0
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/crew_quarters/sleep/spacedorm2
	name = "\improper Visitor Lodging 2"
	icon_state = "dk_yellow"
	lightswitch = 0
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/crew_quarters/sleep/spacedorm3
	name = "\improper Visitor Lodging 3"
	icon_state = "dk_yellow"
	lightswitch = 0
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/crew_quarters/sleep/spacedorm4
	name = "\improper Visitor Lodging 4"
	icon_state = "dk_yellow"
	lightswitch = 0
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/holodeck/holodorm/source_basic
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_desert
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_seating
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_beach
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_garden
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_boxing
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_snow
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_space
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED
/area/holodeck/holodorm/source_off
	name = "\improper Holodeck Source"
	flags = RAD_SHIELDED | BLUE_SHIELDED

/area/ai_core_foyer
	name = "\improper AI Core Access"

/area/medical/virologyisolation
	name = "\improper Virology Isolation"
	icon_state = "virology"
/area/medical/recoveryrestroom
	name = "\improper Recovery Room Restroom"
	icon_state = "virology"

/area/security/hallway
	name = "\improper Security Hallway"
	icon_state = "security"
/area/security/hallwayaux
	name = "\improper Security Armory Hallway"
	icon_state = "security"
/area/security/forensics
	name = "\improper Forensics Lab"
	icon_state = "security"
/area/security/breakroom
	name = "\improper Security Breakroom"
	icon_state = "security"
/area/security/brig/visitation
	name = "\improper Visitation"
	icon_state = "security"
/area/security/brig/bathroom
	name = "\improper Brig Bathroom"
	icon_state = "security"
/area/security/armory/blue
	name = "\improper Armory - Blue"
	icon_state = "armory"
/area/security/armory/red
	name = "\improper Armory - Red"
	icon_state = "red2"
/area/security/observation
	name = "\improper Brig Observation"
	icon_state = "riot_control"
/area/security/eva
	name = "\improper Security EVA"
	icon_state = "security_equip_storage"
/area/security/recstorage
	name = "\improper Brig Recreation Storage"
	icon_state = "brig"

/area/engineering/atmos/backup
	name = "\improper Backup Atmospherics"
/area/engineering/engine_balcony
	name = "\improper Engine Room Balcony"
/area/engineering/foyer_mezzenine
	name = "\improper Engineering Mezzenine"

/area/hallway/station
	icon_state = "hallC1"
/area/hallway/station/atrium
	name = "\improper Main Station Atrium"
/area/hallway/station/port
	name = "\improper Main Port Hallway"
/area/hallway/station/starboard
	name = "\improper Main Starboard Hallway"
/area/hallway/station/upper
	name = "\improper Main Upper Hallway"
/area/hallway/station/docks
	name = "\improper Docks Hallway"

/area/bridge/secondary
	name = "\improper Secondary Command Office"

/area/bridge/secondary/hallway
	name = "\improper Secondary Command Hallway"
/area/bridge/secondary/meeting_room
	name = "\improper Secondary Command Meeting Room"
	lightswitch = 0
/area/bridge/secondary/teleporter
	name = "\improper Secondary Teleporter"
	lightswitch = 0

/area/tether/station/visitorhallway
	name = "\improper Visitor Hallway"
	icon_state = "dk_yellow"
/area/tether/station/visitorhallway/office
	name = "\improper Visitor Office"
	icon_state = "dk_yellow"
	lightswitch = 0
/area/tether/station/visitorhallway/laundry
	name = "\improper Space Laundry"
	icon_state = "dk_yellow"
	lightswitch = 0
/area/tether/station/visitorhallway/lounge
	name = "\improper Visitor Lounge"
	icon_state = "dk_yellow"
	lightswitch = 0

/area/maintenance/station
	icon_state = "fsmaint"
/area/maintenance/station/bridge
	name = "\improper Bridge Maintenance"
/area/maintenance/station/eng_lower
	name = "\improper Engineering Lower Maintenance"
/area/maintenance/station/eng_upper
	name = "\improper Engineering Upper Maintenance"
/area/maintenance/station/medbay
	name = "\improper Medbay Maintenance"
/area/maintenance/station/cargo
	name = "\improper Cargo Maintenance"
/area/maintenance/station/elevator
	name = "\improper Elevator Maintenance"
/area/maintenance/station/sec_lower
	name = "\improper Security Lower Maintenance"
/area/maintenance/station/sec_upper
	name = "\improper Security Upper Maintenance"
/area/maintenance/station/micro
	name = "\improper Micro Maintenance"
/area/maintenance/station/virology
	name = "\improper Virology Maintenance"
/area/maintenance/station/ai
	name = "\improper AI Maintenance"
	sound_env = SEWER_PIPE
/area/maintenance/station/exploration
	name = "\improper Exploration Maintenance"
/area/maintenance/abandonedlibrary
	name = "\improper Abandoned Library"
	icon_state = "library"
/area/maintenance/abandonedlibraryconference
	name = "\improper Abandoned Library Conference"
	icon_state = "library"
/area/maintenance/station/spacecommandmaint
	name = "\improper Secondary Command Maintenance"
	icon_state = "bridge"
	sound_env = SEWER_PIPE
/area/maintenance/substation/spacecommand
	name = "\improper Secondary Command Substation"
	icon_state = "substation"

/area/shuttle/tether/crash1
	name = "\improper Crash Site 1"
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/outdoors/dirt/virgo3b
/area/shuttle/tether/crash2
	name = "\improper Crash Site 2"
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/outdoors/dirt/virgo3b

// Exploration Shuttle stuff //
/area/tether/exploration
	name = "\improper Excursion Shuttle Dock"
	icon_state = "yellow"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/tether/exploration/equipment
	name = "\improper Exploration Equipment Storage"

/area/tether/exploration/crew
	name = "\improper Exploration Crew Area"

/area/tether/exploration/pathfinder_office
	name = "\improper Pathfinder's Office"

/area/tether/exploration/hallway
	name = "\improper Exploration Hallway"

/area/tether/exploration/staircase
	name = "\improper Exploration Staircase"

/area/tether/exploration/showers
	name = "\improper Exploration Showers"

/area/shuttle/excursion
	requires_power = 1
	icon_state = "shuttle2"

/area/shuttle/excursion/general
	name = "\improper Excursion Shuttle"

/area/shuttle/excursion/cockpit
	name = "\improper Excursion Shuttle Cockpit"

/area/shuttle/excursion/cargo
	name = "\improper Excursion Shuttle Cargo"

/area/shuttle/tourbus
	requires_power = 1
	icon_state = "shuttle2"

/area/shuttle/tourbus/general
	name = "\improper Tour Bus"
	
/area/shuttle/tourbus/cockpit
	name = "\improper Tour Bus Cockpit"

/area/shuttle/tourbus/engines
	name = "\improper Tour Bus Engines"


// Belter Dock

/area/quartermaster/belterdock
	name = "\improper Cargo Belter Access"
	icon_state = "mining"

// Elevator area //

/area/tether/elevator
	name = "\improper Tether Elevator"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "elevator"
	dynamic_lighting = FALSE

	requires_power = FALSE

/area/tether/midpoint
	name = "\improper Tether Midpoint"

//////////////////////////////////

/area/antag/antag_base
	name = "\improper Syndicate Outpost"
	requires_power = 0
	dynamic_lighting = 0

//Merc shuttle
/area/shuttle/mercenary
	name = "\improper Mercenary Shuttle"
	icon_state = "shuttle2"

//Vox shuttle
/area/shuttle/skipjack
	name = "\improper Skipjack"
	icon_state = "shuttle2"

//Ninja shuttle
/area/shuttle/ninja
	name = "\improper Ninjacraft"
	icon_state = "shuttle2"

//TFF 28/8/19 - cleanup of areas placement
/area/teleporter/departing
	name = "\improper Long-Range Teleporter"
	icon_state = "teleporter"
	music = "signal"

// Override telescience shielding on some areas
/area/security/armoury
	flags = BLUE_SHIELDED

/area/security/tactical
	flags = BLUE_SHIELDED

/area/security/nuke_storage
	flags = BLUE_SHIELDED

/area/supply
	flags = BLUE_SHIELDED

// Add rad shielding to maintenance and construction sites
/area/vacant
	flags = RAD_SHIELDED

/area/maintenance
	flags = RAD_SHIELDED

/area/rnd/research_storage	//Located entirely in maint under public access, so why not that too
	flags = RAD_SHIELDED

// New shuttles
/area/shuttle/administration/transit
	name = "Deep Space (AS)"
	icon_state = "shuttle"

/area/shuttle/administration/away_mission
	name = "Away Mission (AS)"
	icon_state = "shuttle"

/area/shuttle/awaymission/home
	name = "NSB Adephagia (AM)"
	icon_state = "shuttle2"

/area/shuttle/awaymission/warp
	name = "Deep Space (AM)"
	icon_state = "shuttle"

/area/shuttle/awaymission/away
	name = "Away Mission (AM)"
	icon_state = "shuttle2"

/area/shuttle/awaymission/oldengbase
	name = "Old Construction Site (AM)"
	icon_state = "shuttle2"

/area/medical/resleeving
	name = "Resleeving Lab"
	icon_state = "genetics"

/area/bigship
	name = "Bigship"
	requires_power = 0
	flags = RAD_SHIELDED
	sound_env = SMALL_ENCLOSED
	base_turf = /turf/space
	icon_state = "red2"

/area/bigship/teleporter
	name = "Bigship Teleporter Room"

//////// Abductor Areas ////////
/area/unknown
	requires_power = 0
	flags = RAD_SHIELDED
	icon_state = "red2"

/area/unknown/dorm1
	name = "Unknown Dorm 1"

/area/unknown/dorm2
	name = "Unknown Dorm 2"

/area/unknown/dorm3
	name = "Unknown Dorm 3"

/area/unknown/dorm4
	name = "Unknown Dorm 4"

// ERT/Deathsquad Shuttle
/area/shuttle/specialops/centcom
	name = "Special Operations Shuttle - Centcom"
	icon_state = "shuttlered"
	base_turf = /turf/unsimulated/floor/shuttle_ceiling

/area/shuttle/specialops/tether
	name = "Special Operations Shuttle - Tether"
	icon_state = "shuttlered"

/area/shuttle/specialops/transit
	name = "transit"
	icon_state = "shuttlered"
	base_turf = /turf/space/transit/east

// Tether Map has this shuttle
/area/shuttle/tether
	name = "Tether Shuttle"
	icon_state = "shuttle2"

//Skipjack

/area/skipjack_station
	name = "Raider Outpost"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 0
	flags = RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC

/area/skipjack_station/transit
	name = "transit"
	icon_state = "shuttlered"
	base_turf = /turf/space/transit/north

/area/skipjack_station/orbit
	name = "near the Tether"
	icon_state = "northwest"

/area/skipjack_station/arrivals_dock
	name = "\improper docked with Tether"
	icon_state = "shuttle"

// Ninja areas
/area/ninja_dojo
	name = "\improper Ninja Base"
	icon_state = "green"
	requires_power = 0
	flags = RAD_SHIELDED
	ambience = AMBIENCE_HIGHSEC

/area/ninja_dojo/dojo
	name = "\improper Clan Dojo"
	dynamic_lighting = 0

/area/ninja_dojo/start
	name = "\improper Clan Dojo"
	icon_state = "shuttlered"
	base_turf = /turf/simulated/floor/plating

/area/ninja_dojo/orbit
	name = "near the Tether"
	icon_state = "south"

/area/ninja_dojo/transit
	name = "transit"
	icon_state = "shuttlered"
	base_turf = /turf/space/transit/north

/area/ninja_dojo/arrivals_dock
	name = "\improper docked with Tether"
	icon_state = "shuttle"
	dynamic_lighting = 0

// Exclude some more areas from the atmos leak event so people don't get trapped when spawning.
/datum/event/atmos_leak/setup()
	excluded |= /area/tether/surfacebase/tram
	excluded |= /area/tether/surfacebase/surface_one_hall
	excluded |= /area/tether/surfacebase/surface_two_hall
	excluded |= /area/tether/surfacebase/surface_three_hall
	excluded |= /area/teleporter/departing
	excluded |= /area/hallway/station/upper
	..()
