// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
#include "spider1.dmm"
#include "Flake.dmm"
#include "Field1.dmm"
#include "MCamp1.dmm"
#include "Rocky1.dmm"
#include "Rocky2.dmm"
#include "Rocky3.dmm"
#include "Shack1.dmm"
#include "Smol1.dmm"
#include "Mudpit.dmm"
#include "Snowrock1.dmm"
#include "Boombase.dmm"
#include "Blackshuttledown.dmm"
#include "Lab1.dmm"
#include "Rocky4.dmm"
#include "DJOutpost1.dmm"
#include "Rockybase.dmm"
#include "MHR.dmm"
#include "GovPatrol.dmm"

#endif

// The 'wilderness' is the endgame for Explorers. Extremely dangerous and far away from help, but with vast shinies.
// POIs here spawn in two different sections, the top half and bottom half of the map.
// The top half connects to the outpost z-level, and is seperated from the bottom half by a river. It should provide a challenge to a well equiped Explorer team.
// The bottom half should be even more dangerous, where only the robust, fortunate, or lucky can survive.

/datum/map_template/surface/wilderness
	name = "Surface Content - Wildy"
	desc = "Used to make the surface's wilderness be 17% less boring."

// 'Normal' templates get used on the top half, and should be challenging.
/datum/map_template/surface/wilderness/normal

// 'Deep' templates get used on the bottom half, and should be (even more) dangerous and rewarding.
/datum/map_template/surface/wilderness/deep

// To be added: Templates for surface exploration when they are made.

/datum/map_template/surface/wilderness/normal/spider1
	name = "Spider Nest 1"
	desc = "A small spider nest, in the forest."
	mappath = 'maps/submaps/surface_submaps/wilderness/spider1.dmm'
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/surface/wilderness/normal/Flake
	name = "Forest Lake"
	desc = "A serene lake sitting amidst the surface."
	mappath = 'maps/submaps/surface_submaps/wilderness/Flake.dmm'
	cost = 10

/datum/map_template/surface/wilderness/normal/Mcamp1
	name = "Military Camp 1"
	desc = "A derelict military camp host to some unsavory dangers"
	mappath = 'maps/submaps/surface_submaps/wilderness/MCamp1.dmm'
	cost = 5

/datum/map_template/surface/wilderness/normal/Mudpit
	name = "Mudpit"
	desc = "What happens when someone is a bit too careless with gas.."
	mappath = 'maps/submaps/surface_submaps/wilderness/Mudpit.dmm'
	cost = 5

/datum/map_template/surface/wilderness/normal/Rocky1
	name = "Rocky1"
	desc = "DununanununanununuNAnana"
	mappath = 'maps/submaps/surface_submaps/wilderness/Rocky1.dmm'
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/surface/wilderness/normal/Rocky2
	name =  "Rocky2"
	desc = "More rocks."
	mappath = 'maps/submaps/surface_submaps/wilderness/Rocky2.dmm'
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/surface/wilderness/normal/Rocky3
	name = "Rocky3"
	desc = "More and more and more rocks."
	mappath = 'maps/submaps/surface_submaps/wilderness/Rocky3.dmm'
	desc = "DununanununanununuNAnana"
	cost = 5

/datum/map_template/surface/wilderness/normal/Shack1
	name = "Shack1"
	desc = "A small shack in the middle of nowhere, Your halloween murder happens here"
	mappath = 'maps/submaps/surface_submaps/wilderness/Shack1.dmm'
	cost = 5

/datum/map_template/surface/wilderness/normal/Smol1
	name = "Smol1"
	desc = "A tiny grove of trees, The Nemesis of thicc"
	mappath = 'maps/submaps/surface_submaps/wilderness/Smol1.dmm'
	cost = 5

/datum/map_template/surface/wilderness/normal/Snowrock1
	name = "Snowrock1"
	desc = "A rocky snow covered area"
	mappath = 'maps/submaps/surface_submaps/wilderness/Snowrock1.dmm'
	cost = 5

/datum/map_template/surface/wilderness/normal/Cragzone1
	name = "Cragzone1"
	desc = "Rocks and more rocks."
	mappath = 'maps/submaps/surface_submaps/wilderness/Cragzone1.dmm'
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/surface/wilderness/normal/Lab1
	name = "Lab1"
	desc = "An isolated small robotics lab."
	mappath = 'maps/submaps/surface_submaps/wilderness/Lab1.dmm'
	cost = 5

/datum/map_template/surface/wilderness/normal/Rocky4
	name = "Rocky4"
	desc = "An interesting geographic formation."
	mappath = 'maps/submaps/surface_submaps/wilderness/Rocky4.dmm'
	cost = 5

/datum/map_template/surface/wilderness/deep/DJOutpost1
	name = "DJOutpost1"
	desc = "Home of Sif Free Radio, the best - and only - radio station for miles around."
	mappath = 'maps/submaps/surface_submaps/wilderness/DJOutpost1.dmm'
	cost = 5

/datum/map_template/surface/wilderness/deep/Boombase
	name = "Boombase"
	desc = "What happens when you don't follow SOP."
	mappath = 'maps/submaps/surface_submaps/wilderness/Boombase.dmm'
	cost = 5

/datum/map_template/surface/wilderness/deep/BSD
	name = "Black Shuttle Down"
	desc = "You REALLY shouldn't be near this."
	mappath = 'maps/submaps/surface_submaps/wilderness/Blackshuttledown.dmm'
	cost = 30

/datum/map_template/surface/wilderness/deep/Rockybase
	name = "Rocky Base"
	desc = "A guide to upsetting Icarus and the EIO"
	mappath = 'maps/submaps/surface_submaps/wilderness/Rockybase.dmm'
	cost = 35

/datum/map_template/surface/wilderness/deep/MHR
	name = "Manhack Rock"
	desc = "A rock filled with nasty Synthetics."
	mappath = 'maps/submaps/surface_submaps/wilderness/MHR.dmm'
	cost = 15

/datum/map_template/surface/GovPatrol
	name = "GovPatrol"
	desc = "A long lost SifGuard ground survey patrol. Now they have you guys!"
	mappath = 'maps/submaps/surface_submaps/wilderness/GovPatrol.dmm'