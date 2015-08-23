// GENERIC MINING AREAS

/area/mine
	icon_state = "mining"
	music = 'sound/ambience/song_game.ogg'
	sound_env = ASTEROID

/area/mine/explored
	name = "Mine"
	icon_state = "explored"
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')

/area/mine/unexplored
	name = "Mine"
	icon_state = "unexplored"
	ambience = list('sound/ambience/ambimine.ogg', 'sound/ambience/song_game.ogg')


// OUTPOSTS

// Small outposts
/area/outpost/mining_north
	name = "North Mining Outpost"
	icon_state = "outpost_mine_north"

/area/outpost/mining_west
	name = "West Mining Outpost"
	icon_state = "outpost_mine_west"

/area/outpost/abandoned
	name = "Abandoned Outpost"
	icon_state = "dark"

// Main mining outpost
/area/outpost/mining_main
	icon_state = "outpost_mine_main"

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
	name = "Mining Outpost North Hallway"

/area/outpost/mining_main/south_hall
	name = "Mining Outpost South Hallway"

/area/outpost/mining_main/west_hall
	name = "Mining Outpost West Hallway"

/area/outpost/mining_main/east_hall
	name = "Mining Outpost East Hallway"

/area/outpost/mining_main/break_room
	name = "Mining Outpost Break Room"

/area/outpost/mining_main/refinery
	name = "Mining Outpost Refinery"

/area/outpost/mining_main/bathroom
	name = "Mining Outpost Bathroom"



// Engineering Outpost
/area/outpost/engineering
	icon_state = "outpost_engine"

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
	lighting_use_dynamic = 0

	aft
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

/area/outpost/research/hallway
	name = "Research Outpost Hallway"

/area/outpost/research/dock
	name = "Research Outpost Shuttle Dock"

/area/outpost/research/eva
	name = "Research Outpost EVA"

/area/outpost/research/analysis
	name = "Research Outpost Sample Analysis"

/area/outpost/research/chemistry
	name = "Research Outpost Chemistry"

/area/outpost/research/medical
	name = "Research Outpost Medical"

/area/outpost/research/power
	name = "Research Outpost Maintenance"

/area/outpost/research/isolation_a
	name = "Research Outpost Isolation A"

/area/outpost/research/isolation_b
	name = "Research Outpost Isolation B"

/area/outpost/research/isolation_c
	name = "Research Outpost Isolation C"

/area/outpost/research/isolation_hall
	name = "Research Outpost Isolation Hall"

/area/outpost/research/bathroom
	name = "Research Outpost Bathroom"

/area/outpost/research/dorms
	name = "Research Outpost Dorms"

/area/outpost/research/anomaly_storage
	name = "Research Outpost Anomalous Storage"

/area/outpost/research/anomaly_analysis
	name = "Research Outpost Anomaly Analysis"

/area/outpost/research/exp_prep
	name = "Research Outpost Expedition Preperation"

/area/outpost/research/disposal
	name = "Research Outpost Waste Disposal"

/area/outpost/research/tox_store
	name = "Research Outpost Toxins Storage"
