// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so Travis can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
#include "farm1.dmm"
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
#include "Epod.dmm"
#include "Blackshuttledown.dmm"
#include "Lab1.dmm"
#include "Rocky4.dmm"

#endif

/datum/map_template/surface
	name = "Surface Content"
	desc = "Used to make the surface be 17% less boring."

// To be added: Templates for surface exploration when they are made.

/datum/map_template/surface/farm1
	name = "Farm 1"
	desc = "A small farm tended by a farmbot."
	mappath = 'maps/submaps/surface_submaps/farm1.dmm'
	cost = 10

/datum/map_template/surface/spider1
	name = "Spider Nest 1"
	desc = "A small spider nest, in the forest."
	mappath = 'maps/submaps/surface_submaps/spider1.dmm'
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/surface/Flake
	name = "Forest Lake"
	desc = "A serene lake sitting amidst the surface."
	mappath = 'maps/submaps/surface_submaps/Flake.dmm'
	cost = 10

/datum/map_template/surface/Mcamp1
	name = "Military Camp 1"
	desc = "A derelict military camp host to some unsavory dangers"
	mappath = 'maps/submaps/surface_submaps/MCamp1.dmm'
	cost = 5

/datum/map_template/surface/Mudpit
	name = "Mudpit"
	desc = "What happens when someone is a bit too careless with gas.."
	mappath = 'maps/submaps/surface_submaps/Mudpit.dmm'
	cost = 5

/datum/map_template/surface/Rocky1
	name = "Rocky1"
	desc = "DununanununanununuNAnana"
	mappath = 'maps/submaps/surface_submaps/Rocky1.dmm'
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/surface/Rocky2
	name =  "Rocky2"
	desc = "More rocks."
	mappath = 'maps/submaps/surface_submaps/Rocky2.dmm'
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/surface/Rocky3
	name = "Rocky3"
	desc = "More and more and more rocks."
	mappath = 'maps/submaps/surface_submaps/Rocky3.dmm'
	desc = "DununanununanununuNAnana"
	cost = 5

/datum/map_template/surface/Shack1
	name = "Shack1"
	desc = "A small shack in the middle of nowhere, Your halloween murder happens here"
	mappath = 'maps/submaps/surface_submaps/Shack1.dmm'
	cost = 5

/datum/map_template/surface/Smol1
	name = "Smol1"
	desc = "A tiny grove of trees, The Nemesis of thicc"
	mappath = 'maps/submaps/surface_submaps/Smol1.dmm'
	cost = 5

/datum/map_template/surface/Snowrock1
	name = "Snowrock1"
	desc = "A rocky snow covered area"
	mappath = 'maps/submaps/surface_submaps/Snowrock1.dmm'
	cost = 5

/datum/map_template/surface/Boombase
	name = "Boombase"
	desc = "What happens when you don't follow SOP."
	mappath = 'maps/submaps/surface_submaps/Boombase.dmm'
	cost = 5

/datum/map_template/surface/Epod
	name = "Emergency Pod"
	desc = "A vacant Emergency pod in the middle of nowhere."
	mappath = 'maps/submaps/surface_submaps/Epod.dmm'
	cost = 5

/datum/map_template/surface/BSD
	name = "Black Shuttle Down"
	desc = "You REALLY shouldn't be near this."
	mappath = 'maps/submaps/surface_submaps/Blackshuttledown.dmm'
	cost = 30

/datum/map_template/surface/Cragzone1
	name = "Cragzone1"
	desc = "Rocks and more rocks."
	mappath = 'maps/submaps/surface_submaps/Cragzone1.dmm'
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/surface/Lab1
	name = "Lab1"
	desc = "An isolated small robotics lab."
	mappath = 'maps/submaps/surface_submaps/Lab1.dmm'
	cost = 5

/datum/map_template/surface/Rocky4
	name = "Rocky4"
	desc = "An intresting Geographic formation"
	mappath = 'maps/submaps/surface_submaps/Rocky4.dmm'
	cost = 5