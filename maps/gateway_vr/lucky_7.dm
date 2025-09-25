/obj/effect/overmap/visitable/sector/common_gateway/lucky7
	initial_generic_waypoints = list("tether_excursion_lucky7")
	name = "Lucky 7 Casino and Restaraunt"
	scanner_desc = @{"[i]Registration[/i]: _ERROR
[i]Class[/i]: Installation
[i]Transponder[/i]: Weak Signal
[b]Notice[/b]: Current estimated wait time: 999999"}
	unknown_state = "station"
	known = FALSE
	icon_state = "lucky7_g"

// -- Areas -- //

/area/awaymission/lucky7
	icon_state = "away1"
	ambience = AMBIENCE_CASINO
	flags = AREA_FLAG_IS_NOT_PERSISTENT | AREA_BLOCK_INSTANT_BUILDING

/area/awaymission/lucky7/casinofloor
	name = "\improper Gateway - Casino Floor"
	icon_state = "casino"

/area/awaymission/lucky7/arcade
	name = "\improper Gateway - Arcade"
	icon_state = "arcade"

/area/awaymission/lucky7/gateway
	name = "\improper Gateway - Gateway"
	icon_state = "away"

/area/awaymission/lucky7/privategameroom
	name = "\improper Gateway - Private Game Room One"
	icon_state = "arcade2"
	flags = AREA_FLAG_IS_NOT_PERSISTENT | AREA_SOUNDPROOF | AREA_FORBID_EVENTS | AREA_BLOCK_INSTANT_BUILDING

/area/awaymission/lucky7/privategameroom/two
	name = "\improper Gateway - Private Game Room Two"

/area/awaymission/lucky7/privategameroom/three
	name = "\improper Gateway - Private Game Room Three"

/area/awaymission/lucky7/privategameroom/four
	name = "\improper Gateway - Private Game Room Four"

/area/awaymission/lucky7/privategameroom/five
	name = "\improper Gateway - Private Game Room Five"

/area/awaymission/lucky7/privategameroom/six
	name = "\improper Gateway - Private Game Room Six"

/area/awaymission/lucky7/privategameroom/seven
	name = "\improper Gateway - Private Game Room Seven"

/area/awaymission/lucky7/privategameroom/eight
	name = "\improper Gateway - Private Game Room Eight"

/area/awaymission/lucky7/privateroom
	name = "\improper Gateway - Private Room One"
	icon_state = "crew_quarters"
	flags = RAD_SHIELDED | BLUE_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT | AREA_FORBID_EVENTS | AREA_FORBID_SINGULO | AREA_SOUNDPROOF | AREA_ALLOW_LARGE_SIZE | AREA_BLOCK_SUIT_SENSORS | AREA_BLOCK_TRACKING | AREA_BLOCK_INSTANT_BUILDING

/area/awaymission/lucky7/privateroom/two
	name = "\improper Gateway - Private Room Two"
	icon_state = "crew_quarters"

/area/awaymission/lucky7/privateroom/three
	name = "\improper Gateway - Private Room Three"
	icon_state = "crew_quarters"

/area/awaymission/lucky7/privateroom/four
	name = "\improper Gateway - Private Room Four"
	icon_state = "crew_quarters"

/area/awaymission/lucky7/privateroom/five
	name = "\improper Gateway - Private Room Five"
	icon_state = "crew_quarters"

/area/awaymission/lucky7/privateroom/six
	name = "\improper Gateway - Private Room Six"
	icon_state = "crew_quarters"

/area/awaymission/lucky7/privateroom/seven
	name = "\improper Gateway - Private Room Seven"
	icon_state = "crew_quarters"

/area/awaymission/lucky7/privateroom/eight
	name = "\improper Gateway - Private Room Eight"
	icon_state = "crew_quarters"

/area/awaymission/lucky7/privateroom/vip
	name = "\improper Gateway - VIP Room"
	icon_state = "crew_quarters"

/area/awaymission/lucky7/dorms
	name = "\improper Gateway - Dorms"
	icon_state = "crew_quarters"
	flags = RAD_SHIELDED | BLUE_SHIELDED | AREA_FLAG_IS_NOT_PERSISTENT | AREA_FORBID_EVENTS | AREA_FORBID_SINGULO | AREA_SOUNDPROOF | AREA_ALLOW_LARGE_SIZE | AREA_BLOCK_SUIT_SENSORS | AREA_BLOCK_TRACKING | AREA_BLOCK_INSTANT_BUILDING

/area/awaymission/lucky7/dorms/one
	name = "\improper Gateway - Dorm 1"

/area/awaymission/lucky7/dorms/two
	name = "\improper Gateway - Dorm 2"

/area/awaymission/lucky7/dorms/three
	name = "\improper Gateway - Dorm 3"

/area/awaymission/lucky7/dorms/four
	name = "\improper Gateway - Dorm 4"

/area/awaymission/lucky7/dorms/five
	name = "\improper Gateway - Dorm 5"

/area/awaymission/lucky7/security
	name = "\improper Gateway - Security"
	icon_state = "security"

/area/awaymission/lucky7/kitchen
	name = "\improper Gateway - Kitchen"
	icon_state = "kitchen"

/area/awaymission/lucky7/bar
	name = "\improper Gateway - Bar"
	icon_state = "bar"

/area/awaymission/lucky7/barbackroom
	name = "\improper Gateway - Bar Backroom"
	icon_state = "bar"

/area/awaymission/lucky7/breakroom
	name = "\improper Gateway - Breakroom"
	icon_state = "green"

/area/awaymission/lucky7/loungeprivateroom
	name = "\improper Gateway - Private Lounge"
	icon_state = "lounge"

/area/awaymission/lucky7/lounge
	name = "\improper Gateway - Lounge"
	icon_state = "lounge"

/area/awaymission/lucky7/laundry
	name = "\improper Gateway - Laundry Room"
	icon_state = "laundry"

/area/awaymission/lucky7/medical
	name = "\improper Gateway - Clinic"
	icon_state = "medbay"

/area/awaymission/lucky7/workshop
	name = "\improper Gateway - Workshop"
	icon_state = "yellow"

/area/awaymission/lucky7/maint1
	name = "\improper Gateway - Maint 1"
	icon_state = "maint"

/area/awaymission/lucky7/maint2
	name = "\improper Gateway - Maint 2"
	icon_state = "maint"

/area/awaymission/lucky7/hall1
	name = "\improper Gateway - Hall 1"
	icon_state = "hallway"

/area/awaymission/lucky7/hall2
	name = "\improper Gateway - Hall 2"
	icon_state = "hallway"

/area/awaymission/lucky7/hotelhall
	name = "\improper Gateway - Hotel Hall"
	icon_state = "hallway"

/area/awaymission/lucky7/trash
	name = "\improper Gateway - Trash Collection"
	icon_state = "disposal"

/area/awaymission/lucky7/dock1
	name = "\improper Gateway - Dock 1"
	icon_state = "entry_1"

/area/awaymission/lucky7/dock2
	name = "\improper Gateway - Dock 2"
	icon_state = "entry_2"

/area/awaymission/lucky7/entry
	name = "\improper Gateway - Entry Hall"
	icon_state = "entry_3"

/obj/machinery/telecomms/allinone/casino
	freq_listening = list(PUB_FREQ, CSN_FREQ)
