// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
#include "deadBeacon.dmm"
#include "prepper1.dmm"
#include "quarantineshuttle.dmm"
#include "Mineshaft1.dmm"
#include "Scave1.dmm"
#include "crashed_ufo.dmm"
#endif

/datum/map_template/cave
	name = "Cave Content"
	desc = "Don't dig too deep!"

// To be added: Templates for cave exploration when they are made.

/datum/map_template/cave/deadBeacon
	name = "Abandoned Relay"
	desc = "An unregistered comms relay, abandoned to the elements."
	mappath = 'maps/submaps/cave_submaps/deadBeacon.dmm'
	cost = 10

/datum/map_template/cave/prepper1
	name = "Prepper Bunker"
	desc = "A little hideaway for someone with more time and money than sense."
	mappath = 'maps/submaps/cave_submaps/prepper1.dmm'
	cost = 10

/datum/map_template/cave/qshuttle
	name = "Quarantined Shuttle"
	desc = "An emergency landing turned viral outbreak turned tragedy."
	mappath = 'maps/submaps/cave_submaps/quarantineshuttle.dmm'
	cost = 20

/datum/map_template/cave/Mineshaft1
	name = "Abandoned Mineshaft 1"
	desc = "An abandoned minning tunnel from a lost money making effort."
	mappath = 'maps/submaps/cave_submaps/Mineshaft1.dmm'
	cost = 5

/datum/map_template/cave/Scave1
	name = "Spider Cave 1"
	desc = "A minning tunnel home to an aggressive collection of spiders."
	mappath = 'maps/submaps/cave_submaps/Scave1.dmm'
	cost = 5

/datum/map_template/cave/crashed_ufo
	name = "Crashed UFO"
	desc = "A (formerly) flying saucer that is now embedded into the mountain, yet it still seems to be running..."
	mappath = 'maps/submaps/cave_submaps/crashed_ufo.dmm'
	cost = 40
