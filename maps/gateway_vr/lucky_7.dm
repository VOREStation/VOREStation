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

/area/awaymission/lucky7/privategameroom/two
	name = "\improper Gateway - Private Game Room Two"

/area/awaymission/lucky7/privategameroom/three
	name = "\improper Gateway - Private Game Room Three"

/area/awaymission/lucky7/privateroom
	name = "\improper Gateway - Private Room One"
	icon_state = "crew_quarters"

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

/area/awaymission/lucky7/privateroom/vip
	name = "\improper Gateway - VIP Room"
	icon_state = "crew_quarters"

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