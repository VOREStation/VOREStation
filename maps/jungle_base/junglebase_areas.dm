//Debug areas
/area/junglebase
	name = "junglebase Debug Surface"

/area/junglebase/transit
	name = "junglebase Debug Transit"
	requires_power = 0

/area/junglebase/space
	name = "junglebase Debug Space"
	requires_power = 0

// Junglebase Areas itself
/area/junglebase/junglebase
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "junglebase1"
/area/junglebase/transit/junglebase
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "junglebase2"
/area/junglebase/space/junglebase
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "junglebase3"

// Elevator areas.
/area/turbolift
	delay_time = 2 SECONDS
	forced_ambience = list('sound/music/elevator.ogg')
	dynamic_lighting = FALSE //Temporary fix for elevator lighting

	requires_power = FALSE

/area/turbolift/junglebase/undermine
	name = "Undermine"
	lift_floor_label = "Undermine"
	lift_floor_name = "Underground Mining Area"
	lift_announce_str = "Arriving at the Undermine. Ensure you are prepared for the temperatures."
	base_turf = /turf/simulated/floor/plating
	delay_time = 30 SECONDS // Very long time to get to/from this level. TODO: Elevator temporary animation.

/area/turbolift/junglebase/underbrush
	name = "Underbrush/Ground Level"
	lift_floor_label = "Underbrush"
	lift_floor_name = "Surface Access, Surface Security Outpost, Vehicle Storage"
	lift_announce_str = "Arriving at Ground Level. Be wary of the wildlife."
	base_turf = /turf/simulated/floor/plating

/area/turbolift/junglebase/secondaryplatform
	name = "Civilian Platform, Recreational Level"
	lift_floor_label = "Lower Platform, Civilian Section"
	lift_floor_name = "Dorms, Bar, Tram"
	lift_announce_str = "Arriving at the Civilian Platform Level. Mind the catwalks, and Tram is to your North."

/area/turbolift/junglebase/primaryplatform
	name = "Primary Level"
	lift_floor_label = "Primary Platform"
	lift_floor_name = "Research, Security, Brig, Atmospherics, Cargo/Mining"
	lift_announce_str = "Arriving at Primary Research Platform. Research is to your North, Mining South. Mind the catwalks."

/area/turbolift/junglebase/shuttlepad
	name = "Shuttlepad"
	lift_floor_label = "Shuttlepad"
	lift_floor_name = "Shuttle Pad, Docking"
	lift_announce_str = "Arriving at Shuttlepad. Mind the exhaust, and stand well clear of landing platforms."
	delay_time = 10 SECONDS

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

/area/engineering/gravity_lobby
	name = "\improper Engineering GravGen Lobby"

/area/engineering/gravity_gen
	name = "\improper Engineering GravGen"

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

/area/junglebase
	icon = 'icons/turf/areas_vr.dmi'

/area/junglebase/vehicle_storage
	name = "\improper Vehicle Storage"
	icon_state = "yellow"

/area/junglebase/gate_control
	name = "\improper Gate Control"
	icon_state = "security"

/area/junglebase/exterior
	name = "Outside - Surface"
	sound_env = MOUNTAINS
/area/junglebase/exterior/exterior1
	icon_state = "outside1"
/area/junglebase/exterior/exterior2
	icon_state = "outside2"
/area/junglebase/exterior/exterior3
	icon_state = "outside3"

/area/junglebase/exterior/empty
	name = "Outside - Empty Area"

/area/junglebase/exterior/temple
	name = "Outside - Wilderness"
	icon_state = "red"

/area/junglebase/exterior/crash
	name = "Outside - Wilderness"
	icon_state = "yellow"

/area/junglebase/tram
	name = "\improper Tram Station"
	icon_state = "dk_yellow"

/area/junglebase/hallway/civilian_platform_hall
	name = "\improper Civilian Platform Internal Hallway"
	icon_state = "dk_yellow"
/area/junglebase/hallway/research_platform_hall
	name = "\improper Research Platform Hallway"
	icon_state = "dk_yellow"

/area/junglebase/civilian/public_garden
	name = "\improper Public Garden"
	icon_state = "purple"
/area/junglebase/civilian/fish_farm
	name = "\improper Fish Farm"
	icon_state = "red"
/area/junglebase/civilian/bar_backroom
	name = "\improper Bar Backroom"
	icon_state = "red"
	sound_env = SMALL_SOFTFLOOR
/area/junglebase/civilian/servicebackroom
	name = "\improper Service Block Backroom"
	icon_state = "red"
/area/junglebase/civilian/barbackmaintenance
	name = "\improper Bar Back Maintenance"
	icon_state = "red"

/area/junglebase/civilian/public_garden_lg
	name = "\improper Public Garden Looking Glass"
	icon_state = "green"

/area/junglebase/stairwells/east_stairs_two
	name = "\improper East Stairwell Second Floor"
	icon_state = "dk_yellow"

/area/junglebase/emergency_storage
	icon_state = "emergencystorage"
/area/junglebase/emergency_storage/panic_shelter
	name = "\improper Panic Shelter Emergency Storage"
/area/junglebase/emergency_storage/rnd
	name = "\improper RnD Emergency Storage"
/area/junglebase/emergency_storage/atmos
	name = "\improper Atmospherics Emergency Storage"

// Cargo/Mining Areas
/area/junglebase/cargo
	name = "\improper Cargo"

/area/junglebase/mining_main
	icon_state = "outpost_mine_main"
/area/junglebase/mining_main/eva
	name = "\improper Mining EVA"
/area/junglebase/mining_main/external	//TODO: repath for medical move
	name = "\improper Mining External"
/area/junglebase/mining_main/break_room
	name = "\improper Mining Crew Area"
/area/junglebase/mining_main/bathroom
	name = "\improper Mining Bathroom"
/area/outpost/mining_main/hangar
	name = "\improper Mining Outpost Shuttle Hangar"
/area/outpost/mining_main/secondary_gear_storage
	name = "\improper Mining Outpost Gear Storage"
/area/outpost/mining_main/drill_equipment
	name = "\improper Mining Equipment Storage"

// Mining Underdark
/area/mine/unexplored/underdark
	name = "\improper Mining Underdark"
	base_turf = /turf/simulated/mineral/floor/torris
/area/mine/explored/underdark
	name = "\improper Mining Underdark"
	base_turf = /turf/simulated/mineral/floor/torris

// Mining outpost areas
/area/outpost/mining_main/passage
	name = "\improper Mining Outpost Passage"

// Wilderness Areas
/area/junglebase/outpost/wilderness
	name = "\improper Wilderness Zone"
	icon_state = "green"

/area/maintenance/substation/mining
	name = "\improper Mining Substation"
/area/maintenance/substation/bar
	name = "\improper Bar Substation"
/area/maintenance/substation/surface_compound
	name = "\improper Underbrush Compound Substation"
/area/maintenance/substation/civ_west
	name = "\improper Civilian West Substation"
/area/maintenance/substation/exploration
	name = "\improper Exploration Substation"
/area/maintenance/commandmaint
	name = "\improper Command Maintenance"

/area/junglebase/medical
	icon_state = "medical"

/area/junglebase/library/study
	name = "\improper Library Private Study"
	lightswitch = 0
	icon_state = "library"

/area/junglebase/civilian/entertainment
	name = "\improper Entertainment Auditorium"
	icon_state = "library"

/area/junglebase/entertainment/stage
	name = "\improper Entertainment Stage"
	icon_state = "library"

/area/junglebase/entertainment/backstage
	name = "\improper Entertainment Backstage"
	icon_state = "library"

/area/junglebase/civilian/botanystorage
	name = "\improper Botany Storage"
	icon_state = "library"


/area/junglebase/security
	icon_state = "security"

/area/junglebase/security/exterior_checkpoint
	name = "\improper Security Exterior Checkpoint"
	icon_state = "security"

/area/engineering/atmos/processing
	name = "Atmospherics Processing"
	icon_state = "atmos"
	sound_env = LARGE_ENCLOSED

/area/engineering/atmos/gas_storage
	name = "Atmospherics Gas Storage"
	icon_state = "atmos"

/area/engineering/atmos_intake
	name = "\improper Atmospherics Intake"
	icon_state = "atmos"
	sound_env = MOUNTAINS

/area/engineering/atmos/hallway
	name = "\improper Atmospherics Main Hallway"

/area/engineering/lower/corridor
	name = "\improper Lower Service Corridor"
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
/area/rnd/testingroom
	name = "\improper Research Testing Room"
	icon_state = "research"
/area/rnd/hardstorage
	name = "\improper Research Hard Storage"
	icon_state = "research"
/area/rnd/tankstorage
	name = "\improper Research Tank Storage"
	icon_state = "research"

/area/rnd/research/testingrange
	name = "\improper Weapons Testing Range"
	icon_state = "firingrange"

/area/rnd/research/researchdivision
	name = "\improper Research Division"
	icon_state = "research"


//Outpost areas
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
	name = "\improper Xenobiology Northern Airlock"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_south_airlock
	name = "\improper Xenobiology Southern Airlock"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_hallway
	name = "\improper Xenobiology Access Corridor"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_breakroom
	name = "\improper Xenobiology Breakroom"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_office
	name = "\improper Xenobiology Main Office"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_autopsy
	name = "\improper Xenobiology Alien Autopsy Room"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_decon
	name = "\improper Xenobiology Decontamination and Showers"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_first_aid
	name = "\improper Xenobiology First Aid"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_slimepens
	name = "\improper Xenobiology Slime and Xenos Containment"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_main
	name = "\improper Xenobiology Main Outpost"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_storage
	name = "\improper Xenobiology Equipment Storage"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_stairs
	name = "\improper Xenobiology Stairwell"
	icon_state = "research"
/area/rnd/outpost/xenobiology/outpost_substation
	name = "\improper Xenobiology SMES Substation"
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

/area/junglebase/shuttle_pad
	name = "\improper junglebase Shuttle Pad"
/area/junglebase/civilian/reading_room
	name = "\improper Reading Room"
/area/junglebase/vacant_site
	name = "\improper Vacant Site"
	flags = null
/area/crew_quarters/freezer
	name = "\improper Kitchen Freezer"
/area/crew_quarters/panic_shelter
	name = "\improper Panic Shelter"
	flags = RAD_SHIELDED	//It just makes sense

/area/junglebase/civilian/public_meeting_room
	name = "Public Meeting Room"
	icon_state = "blue"
	sound_env = SMALL_SOFTFLOOR

/area/chapel/observation
	name = "\improper Chapel Observation"
	icon_state = "chapel"

//
// Station Z Levels
//
// Note: Fore is NORTH

/area/junglebase/stairwells/stairs_one
	name = "\improper Station Stairwell First Floor"
	icon_state = "dk_yellow"
/area/junglebase/stairwells/stairs_two
	name = "\improper Station Stairwell Second Floor"
	icon_state = "dk_yellow"
/area/junglebase/stairwells/stairs_three
	name = "\improper Station Stairwell Shuttlepad"
	icon_state = "dk_yellow"

/area/maintenance/station/abandonedholodeck
	name = "\improper Old Holodeck"
	icon_state = "dk_yellow"
	flags = RAD_SHIELDED

/area/crew_quarters/showers
	name = "\improper Unisex Showers"
	icon_state = "recreation_area_restroom"

// Dorms Start. DO NOT TOUCH.
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
// Dorms End. DO NOT TOUCH.
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

/area/maintenance/station
	icon_state = "fsmaint"
/area/maintenance/station/bridge
	name = "\improper Bridge Maintenance"
/area/maintenance/station/engineering
	name = "\improper Engineering Maintenance"
/area/maintenance/station/medbay
	name = "\improper Medbay Maintenance"
/area/maintenance/station/cargo
	name = "\improper Cargo Maintenance"
/area/maintenance/station/elevator
	name = "\improper Elevator Maintenance"
/area/maintenance/station/security
	name = "\improper Security Maintenance"
/area/maintenance/station/micro
	name = "\improper Micro Maintenance"
/area/maintenance/station/virology
	name = "\improper Virology Maintenance"
/area/maintenance/station/ai
	name = "\improper AI Maintenance"
	sound_env = SEWER_PIPE
/area/maintenance/station/exploration
	name = "\improper Exploration Maintenance"

/area/shuttle/junglebase/crash1
	name = "\improper Crash Site 1"
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/outdoors/dirt/torris
/area/shuttle/junglebase/crash2
	name = "\improper Crash Site 2"
	icon_state = "shuttle2"
	base_turf = /turf/simulated/floor/outdoors/dirt/torris

// Exploration Shuttle stuff //
/area/junglebase/exploration
	name = "\improper Excursion Shuttle Dock"
	icon_state = "yellow"
	holomap_color = HOLOMAP_AREACOLOR_SCIENCE

/area/junglebase/exploration/equipment
	name = "\improper Exploration Equipment Storage"

/area/junglebase/exploration/crew
	name = "\improper Exploration Crew Area"

/area/junglebase/exploration/pathfinder_office
	name = "\improper Pathfinder's Office"

/area/junglebase/exploration/hallway
	name = "\improper Exploration Hallway"

/area/junglebase/exploration/showers
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

/area/shuttle/medivac
	requires_power = 1
	icon_state = "shuttle2"

/area/shuttle/medivac/general
	name = "\improper Medivac"

/area/shuttle/medivac/cockpit
	name = "\improper Medivac Cockpit"

/area/shuttle/medivac/engines
	name = "\improper Medivac Engines"

/area/shuttle/securiship
	requires_power = 1
	icon_state = "shuttle2"

/area/shuttle/securiship/general
	name = "\improper Securiship"

/area/shuttle/securiship/cockpit
	name = "\improper Securiship Cockpit"

/area/shuttle/securiship/engines
	name = "\improper Securiship Engines"

// Asteroid Mining belter and Mining Outpost shuttles and refinery/gear areas
/area/quartermaster/belterdock
	name = "\improper Cargo Belter Access"
	icon_state = "mining"
/area/quartermaster/belterdock/gear
	name = "\improper Mining Gear Storage"
/area/quartermaster/belterdock/refinery
	name = "\improper Mining Refinery"
/area/quartermaster/belterdock/surface_mining_outpost_shuttle_hangar
	name = "\improper Mining Outpost Shuttle - Station"
area/shuttle/mining_outpost/shuttle
	name = "\improper Mining Outpost Shuttle"
	icon_state = "shuttle2"

// Elevator (Turboshaft) areas //

/area/junglebase/turboshaft
	name = "\improper Turboshaft"
	icon = 'icons/turf/areas_vr.dmi'
	icon_state = "elevator"
	dynamic_lighting = FALSE

	requires_power = FALSE

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
	name = "NSB Forbearance (AM)"
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

// Antag Stuff, Don't touch

// ERT/Deathsquad Shuttle
/area/shuttle/specialops/centcom
	name = "Special Operations Shuttle - Centcom"
	icon_state = "shuttlered"
	base_turf = /turf/unsimulated/floor/shuttle_ceiling

/area/shuttle/specialops/junglebase
	name = "Special Operations Shuttle - junglebase"
	icon_state = "shuttlered"

/area/shuttle/specialops/transit
	name = "transit"
	icon_state = "shuttlered"
	base_turf = /turf/space/transit/east

// junglebase Map has this shuttle
/area/shuttle/junglebase
	name = "junglebase Shuttle"
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
	name = "near the junglebase"
	icon_state = "northwest"

/area/skipjack_station/arrivals_dock
	name = "\improper docked with junglebase"
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
	name = "near the junglebase"
	icon_state = "south"

/area/ninja_dojo/transit
	name = "transit"
	icon_state = "shuttlered"
	base_turf = /turf/space/transit/north

/area/ninja_dojo/arrivals_dock
	name = "\improper docked with junglebase"
	icon_state = "shuttle"
	dynamic_lighting = 0

// Exclude some more areas from the atmos leak event so people don't get trapped when spawning.
/datum/event/atmos_leak/setup()
	excluded |= /area/junglebase/tram
	excluded |= /area/junglebase/hallway/civilian_platform_hall
	excluded |= /area/junglebase/hallway/research_platform_hall
	excluded |= /area/teleporter/departing
	..()
