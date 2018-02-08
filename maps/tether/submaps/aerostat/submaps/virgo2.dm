#include "virgo2_submap_areas.dm"

#if MAP_TEST
#include "Blackshuttledown.dmm"
#include "Boombase.dmm"
#include "CaveS.dmm"
#include "DecoupledEngine.dmm"
#include "GovPatrol.dmm"
#include "Lab1.dmm"
#include "MCamp1.dmm"
#include "MHR.dmm"
#include "Mudpit.dmm"
#include "Rockybase.dmm"
#include "Shack1.dmm"
#include "Smol1.dmm"
#include "Snowrock1.dmm"
#endif

/datum/map_template/virgo2
	name = "Surface Content - Virgo 2"
	desc = "For seeding submaps on Virgo 2"
	allow_duplicates = TRUE

/datum/map_template/virgo2/Blackshuttledown
	name = "V2 - Black Shuttle Down"
	desc = "You REALLY shouldn't be near this."
	mappath = 'Blackshuttledown.dmm'
	cost = 30
	allow_duplicates = FALSE

/datum/map_template/virgo2/Boombase
	name = "V2 - Boombase"
	desc = "What happens when you don't follow SOP."
	mappath = 'Boombase.dmm'
	cost = 5

/datum/map_template/virgo2/CaveS
	name = "V2 - CaveS"
	desc = "Chitter chitter!"
	mappath = 'CaveS.dmm'
	cost = 20
	allow_duplicates = FALSE

/datum/map_template/virgo2/DecoupledEngine
	name = "V2 - Decoupled Engine"
	desc = "A damaged fission engine jettisoned from a starship long ago."
	mappath = 'DecoupledEngine.dmm'
	cost = 15

/datum/map_template/virgo2/GovPatrol
	name = "V2 - Government Patrol"
	desc = "A long lost SifGuard ground survey patrol. Now they have you guys!"
	mappath = 'GovPatrol.dmm'
	cost = 5

/datum/map_template/virgo2/Lab1
	name = "V2 - Lab1"
	desc = "An isolated small robotics lab."
	mappath = 'Lab1.dmm'
	cost = 5

/datum/map_template/virgo2/Mcamp1
	name = "V2 - Military Camp 1"
	desc = "A derelict military camp host to some unsavory dangers"
	mappath = 'MCamp1.dmm'
	cost = 15

/datum/map_template/virgo2/MHR
	name = "V2 - Manhack Rock"
	desc = "A rock filled with nasty Synthetics."
	mappath = 'MHR.dmm'
	cost = 15

/datum/map_template/virgo2/Mudpit
	name = "V2 - Mudpit"
	desc = "What happens when someone is a bit too careless with gas.."
	mappath = 'Mudpit.dmm'
	cost = 15

/datum/map_template/virgo2/Rockybase
	name = "V2 - Rocky Base"
	desc = "A guide to upsetting Icarus and the EIO"
	mappath = 'Rockybase.dmm'
	cost = 35
	allow_duplicates = FALSE

/datum/map_template/virgo2/Shack1
	name = "V2 - Shack1"
	desc = "A small shack in the middle of nowhere, Your halloween murder happens here"
	mappath = 'Shack1.dmm'
	cost = 5

/datum/map_template/virgo2/Smol1
	name = "V2 - Smol1"
	desc = "A tiny grove of trees, The Nemesis of thicc"
	mappath = 'Smol1.dmm'
	cost = 5

/datum/map_template/virgo2/Snowrock1
	name = "V2 - Snowrock1"
	desc = "A rocky snow covered area"
	mappath = 'Snowrock1.dmm'
	cost = 5
