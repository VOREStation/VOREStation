
var/list/weighted_randomevent_locations = list()
var/list/weighted_mundaneevent_locations = list()

/datum/trade_destination
	var/name = ""
	var/description = ""
	var/distance = 0
	var/list/willing_to_buy = list()
	var/list/willing_to_sell = list()
	var/can_shuttle_here = 0		//one day crew from the station will be able to travel to this destination
	var/list/viable_random_events = list()
	var/list/temp_price_change[BIOMEDICAL]
	var/mundane_probability = 0

/datum/trade_destination/proc/get_custom_eventstring(var/event_type)
	return null

//distance is measured in Arbitrary and corelates to travel time, like, I guess
/datum/trade_destination/luna
	name = "Luna"
	description = "The capital world of SolGov, host to NanoTrasen's corporate offices."
	distance = 1.2
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(SECURITY_BREACH, CORPORATE_ATTACK, AI_LIBERATION)
	mundane_probability = 3

/datum/trade_destination/nohio
	name = "New Ohio"
	description = "A world in the Sagitarius Heights, home to Vey-Medical's research and development facilities."
	distance = 1.7
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(SECURITY_BREACH, CULT_CELL_REVEALED, BIOHAZARD_OUTBREAK, PIRATES, ALIEN_RAIDERS)
	mundane_probability = 4

/datum/trade_destination/sophia
	name = "Sophia"
	description = "The homeworld of the positronics and an extremely important cultural center."
	distance = 0.6
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(INDUSTRIAL_ACCIDENT, PIRATES, CORPORATE_ATTACK)
	mundane_probability = 2

/datum/trade_destination/jade
	name = "Jade"
	description = "Jade, in the Zhu Que system, is one of the Bowl's garden worlds and home to a major ore processing operation."
	distance = 7.5
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(PIRATES, INDUSTRIAL_ACCIDENT)
	mundane_probability = 1

/datum/trade_destination/sif
	name = "Sif"
	description = "A garden world in the Vir system with a developing phoron-based economy."
	distance = 2.3
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(RIOTS, INDUSTRIAL_ACCIDENT, BIOHAZARD_OUTBREAK, CULT_CELL_REVEALED, FESTIVAL, MOURNING)
	mundane_probability = 8

/datum/trade_destination/mars
	name = "Mars"
	description = "A major industrial center in the Sol system."
	distance = 6.6
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(RIOTS, INDUSTRIAL_ACCIDENT, BIOHAZARD_OUTBREAK, CULT_CELL_REVEALED, FESTIVAL, MOURNING)
	mundane_probability = 3

/datum/trade_destination/nisp
	name = "Nisp"
	description = "A near-garden world known for its hostile wildlife and its N2O atmosphere."
	distance = 8.9
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(WILD_ANIMAL_ATTACK, CULT_CELL_REVEALED, FESTIVAL, MOURNING, ANIMAL_RIGHTS_RAID, ALIEN_RAIDERS)
	mundane_probability = 4

/datum/trade_destination/abelsrest
	name = "Abel's Rest"
	description = "A garden world on the Hegemony border. Coinhabitated rather uncomfortably by Unathi and Solar settlers."
	distance = 7.5
	willing_to_buy = list()
	willing_to_sell = list()
	viable_random_events = list(WILD_ANIMAL_ATTACK, CULT_CELL_REVEALED, FESTIVAL, MOURNING, ANIMAL_RIGHTS_RAID, ALIEN_RAIDERS)
	mundane_probability = 4
