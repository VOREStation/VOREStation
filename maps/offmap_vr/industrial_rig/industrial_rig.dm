// The ship's area(s)
/area/ship/industrial_rig
	name = "\improper Industrial Rig"
	icon_state = "shuttle2"
	requires_power = 1
	dynamic_lighting = 1

/area/ship/industrial_rig/engineering
	name = "\improper Industrial Rig - Engineering"
/area/ship/industrial_rig/engineeringcntrl
	name = "\improper Industrial Rig - Engineering Power Room"
/area/ship/industrial_rig/bridge
	name = "\improper Industrial Rig - Control Deck"
/area/ship/industrial_rig/atmos
	name = "\improper Industrial Rig - Atmospherics"
/area/ship/industrial_rig/engines
	name = "\improper Industrial Rig - Engines"
/area/ship/industrial_rig/engineering_reactor
	name = "\improper Industrial Rig - Reactor Room"
/area/ship/industrial_rig/kit_storage
	name = "\improper Industrial Rig - Equipment Storage"
/area/ship/industrial_rig/hangar
	name = "\improper Industrial Rig - Hangar"
/area/ship/industrial_rig/common_room
	name = "\improper Industrial Rig - Common Room"
/area/ship/industrial_rig/med
	name = "\improper Industrial Rig - Medical Bay"
/area/ship/industrial_rig/hall1
	name = "\improper Industrial Rig - Corridor Alpha"
/area/ship/industrial_rig/hall2
	name = "\improper Industrial Rig - Corridor Beta"
/area/ship/industrial_rig/portairlock_fore
	name = "\improper Industrial Rig - Port Fore Airlock"
/area/ship/industrial_rig/portairlock_aft
	name = "\improper Industrial Rig - Port Aft Airlock"
/area/ship/industrial_rig/starboardairlock_fore
	name = "\improper Industrial Rig - Starboard Fore Airlock"
/area/ship/industrial_rig/starboardairlock_aft
	name = "\improper Industrial Rig - Starboard Aft Airlock"
/area/ship/industrial_rig/operations_chamber
	name = "\improper Industrial Rig - Ops Chamber"
/area/ship/industrial_rig/ops_airlock_1
	name = "\improper Industrial Rig - Ops Airlock 1"
/area/ship/industrial_rig/ops_airlock_2
	name = "\improper Industrial Rig - Ops Airlock 2"

// The 'shuttle' of the excursion shuttle
// /datum/shuttle/autodock/overmap/mercenaryship
//	name = "Unknown Vessel"
//	warmup_time = 0
//	current_location = "tether_excursion_hangar"
//	docking_controller_tag = "expshuttle_docker"
//	shuttle_area = list(/area/ship/industrial_rig/engineering, /area/ship/industrial_rig/engineeringcntrl, /area/ship/industrial_rig/bridge, /area/ship/industrial_rig/atmos, /area/ship/industrial_rig/air, /area/ship/industrial_rig/engine, /area/ship/industrial_rig/engine1, /area/ship/industrial_rig/armoury, /area/ship/industrial_rig/hangar, /area/ship/industrial_rig/barracks, /area/ship/industrial_rig/fighter, /area/ship/industrial_rig/med, /area/ship/industrial_rig/med1, /area/ship/industrial_rig/hall1, /area/ship/industrial_rig/hall2)
//	fuel_consumption = 3

// The 'ship'
/obj/effect/overmap/visitable/ship/industrial_rig
	name = "NT Industrial Rig"
	icon_state = "nt_cruiser_g"
	desc = "Spacefaring vessel. Corporate IFF transmitting on standard frequencies."
	scanner_desc = @{"[i]Registration[/i]: Nanotrasen IRV Wegener
[i]Class[/i]: [i]Hutton[/i]-class Dredger
[i]Transponder[/i]: Broadcasting (CORP)
[b]Notice[/b]: Industrial vessels have poor maneuvering capabilities for their mass. Observe recommended clearance distance.<br>NOTICE: Vessel prow configuration consistent with industrial gravitic manipulation manifold. Exercise caution."}
	vessel_mass = 40000
	vessel_size = SHIP_SIZE_MEDIUM
	initial_generic_waypoints = list("rig_port_1","rig_port_2","rig_starboard_1","rig_starboard_2")
	known = TRUE
