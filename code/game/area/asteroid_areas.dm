// GENERIC MINING AREAS

/area/mine
	icon_state = "mining"
	sound_env = ASTEROID
	flags = AREA_FLAG_IS_NOT_PERSISTENT

/area/mine/explored
	name = "Mine"
	icon_state = "explored"

/area/mine/unexplored
	name = "Mine"
	icon_state = "unexplored"

/area/mine/explored/upper_level
	name = "Upper Level Mine"
	icon_state = "explored"

/area/mine/unexplored/upper_level
	name = "Upper Level Mine"
	icon_state = "unexplored"


// OUTPOSTS

// Small outposts
/area/outpost/mining_north
	name = "North Mining Outpost"
	icon_state = "outpost_mine_north"
	flags = AREA_FLAG_IS_NOT_PERSISTENT

/area/outpost/mining_west
	name = "West Mining Outpost"
	icon_state = "outpost_mine_west"
	flags = AREA_FLAG_IS_NOT_PERSISTENT

/area/outpost/abandoned
	name = "Abandoned Outpost"
	icon_state = "dark"
	flags = AREA_FLAG_IS_NOT_PERSISTENT

// Main mining outpost
/area/outpost/mining_main
	icon_state = "outpost_mine_main"
	flags = AREA_FLAG_IS_NOT_PERSISTENT

/area/outpost/mining_main/airlock
	name = "Mining Outpost Airlock"

/area/outpost/mining_main/dorms
	name = "Mining Outpost Dormitory"

/area/outpost/mining_main/dorms1
	name = "Mining Outpost Dormitory 1"

/area/outpost/mining_main/dorms2
	name = "Mining Outpost Dormitory 2"

/area/outpost/mining_main/medbay
	name = "Mining Outpost Medical"

/area/outpost/mining_main/storage
	name = "Mining Outpost Gear Storage"

/area/outpost/mining_main/eva
	name = "Mining Outpost EVA"

/area/outpost/mining_main/maintenance
	name = "Mining Outpost Maintenance"

/area/outpost/mining_main/north_hall
	name = "Mining Outpost Fore Hallway"

/area/outpost/mining_main/south_hall
	name = "Mining Outpost Aft Hallway"

/area/outpost/mining_main/west_hall
	name = "Mining Outpost Port Hallway"

/area/outpost/mining_main/east_hall
	name = "Mining Outpost Starboard Hallway"

/area/outpost/mining_main/break_room
	name = "Mining Outpost Crew Area"

/area/outpost/mining_main/refinery
	name = "Mining Outpost Refinery"

/area/outpost/mining_main/bathroom
	name = "Mining Outpost Bathroom"



// Engineering Outpost
/area/outpost/engineering
	icon_state = "outpost_engine"
	flags = AREA_FLAG_IS_NOT_PERSISTENT

/area/outpost/engineering/hallway
	name = "Engineering Outpost Hallway"

/area/outpost/engineering/atmospherics
	name = "Engineering Outpost Atmospherics"

/area/outpost/engineering/power
	name = "Engineering Outpost Power Distribution"

/area/outpost/engineering/telecomms
	name = "Engineering Outpost Telecommunications"

/area/outpost/engineering/storage
	name = "Engineering Outpost Storage"

/area/outpost/engineering/meeting
	name = "Engineering Outpost Meeting Room"

/area/outpost/engineering/kitchen
	name = "Engineering Outpost Kitchen"

/area/outpost/engineering/rest
	name = "Engineering Outpost Break Room"

/area/outpost/engineering/solars
	name = "Engineering Outpost Solars"

/area/outpost/engineering/solarsoutside
	requires_power = 1
	always_unpowered = 1
	dynamic_lighting = 0

/area/outpost/engineering/solarsoutside/aft
	name = "\improper Engineering Outpost Solar Array"
	icon_state = "yellow"

// Engineering Mining Outpost
/area/outpost/engineering/mining
	icon_state = "outpost_engine"

/area/outpost/engineering/mining/hallway
	name = "Mining Engineering Outpost Hallway"

/area/outpost/engineering/mining/atmospherics
	name = "Mining Engineering Outpost Atmospherics"

/area/outpost/engineering/mining/power
	name = "Mining Engineering Outpost Power Distribution"

/area/outpost/engineering/mining/telecomms
	name = "Mining Engineering Outpost Telecommunications"

/area/outpost/engineering/mining/storage
	name = "Mining Engineering Outpost Storage"

/area/outpost/engineering/mining/meeting
	name = "Mining Engineering Outpost Meeting Room"

/area/outpost/engineering/mining/kitchen
	name = "Mining Engineering Outpost Kitchen"

/area/outpost/engineering/mining/rest
	name = "Mining Engineering Outpost Break Room"

/area/outpost/engineering/mining/solars
	name = "Mining Engineering Outpost Solars"



// Research Outpost
/area/outpost/research
	icon_state = "outpost_research"
	flags = AREA_FLAG_IS_NOT_PERSISTENT

/area/outpost/research/hallway
	name = "Research Outpost Hallway"

/area/outpost/research/hallway/mid
	name = "Research Outpost Hallway Mid"

/area/outpost/research/hallway/starboard
	name = "Research Outpost Hallway Starboard"

/area/outpost/research/hallway/catwalk
	name = "Research Outpost Catwalk"

/area/outpost/research/hallway/toxins_hallway
	name = "Research Outpost Toxins Hallway"

/area/outpost/research/dock
	name = "Research Outpost Shuttle Dock"

/area/outpost/research/eva
	name = "Research Outpost EVA"

/area/outpost/research/analysis
	name = "Research Outpost Sample Analysis"

/area/outpost/research/anomaly
	name = "Anomalous Materials Lab"

/area/outpost/research/chemistry
	name = "Research Outpost Chemistry"

/area/outpost/research/medical
	name = "Research Outpost Medical"

/area/outpost/research/power
	name = "Research Outpost Maintenance"

/area/outpost/research/isolation_a
	name = "Research Outpost Isolation 1"

/area/outpost/research/isolation_b
	name = "Research Outpost Isolation 2"

/area/outpost/research/isolation_c
	name = "Research Outpost Isolation 3"

/area/outpost/research/isolation_hall
	name = "Research Outpost Isolation Hall"

/area/outpost/research/bathroom
	name = "Research Outpost Bathroom"

/area/outpost/research/dorms
	name = "Research Outpost Research Lounge"

/area/outpost/research/longtermstorage
	name = "Research Outpost Long-Term Storage"

/area/outpost/research/anomaly_storage
	name = "Research Outpost Anomalous Storage"

/area/outpost/research/anomaly_analysis
	name = "Research Outpost Anomaly Analysis"

/area/outpost/research/exp_prep
	name = "Research Outpost Expedition Preperation"

/area/outpost/research/disposal
	name = "Research Outpost Waste Disposal"

/area/outpost/research/toxins_launch
	name = "Research Outpost Toxins Launch Room"

/area/outpost/research/tox_store
	name = "Research Outpost Toxins Storage"

/area/outpost/research/test_area
	name = "\improper Research Outpost Toxins Test Area"
	icon_state = "toxtest"

/area/outpost/research/toxins_misc_lab
	name = "\improper Research Outpost Toxins Miscellaneous Research"
	icon_state = "toxmisc"

/area/outpost/research/mixing
	name = "\improper Research Outpost Toxins Mixing Room"
	icon_state = "toxmix"

/area/outpost/research/tempstorage
	name = "Research Outpost Temporary Storage"

/area/outpost/research/xenobiology
	name = "\improper Research Outpost Xenobiology Lab"
	icon_state = "xeno_lab"
