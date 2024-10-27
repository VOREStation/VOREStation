#include "virgo2_submap_areas.dm"

#ifdef MAP_TEST
#include "Flake.dmm"
#include "MCamp1.dmm"
#include "Rocky1.dmm"
#include "Shack1.dmm"
#include "Smol1.dmm"
#include "Mudpit.dmm"
#include "Snowrock1.dmm"
#include "Boombase.dmm"
//include "Blackshuttledown.dmm"
#include "Lab1.dmm"
#include "Rocky4.dmm"
#include "DJOutpost1.dmm"
#include "DJOutpost2.dmm"
#include "Rockybase.dmm"
#include "MHR.dmm"
#include "GovPatrol.dmm"
#include "DecoupledEngine.dmm"
//include "DoomP.dmm"
#include "CaveS.dmm"
#include "Drugden.dmm"
#include "Musk.dmm"
#include "Manor1.dmm"
#include "Epod3.dmm"
#include "Epod4.dmm"
#include "ButcherShack.dmm"
#include "RareSample.dmm"
#include "SamplePocket.dmm"
#endif

/datum/map_template/virgo2
	name = "Surface Content - Virgo 2"
	desc = "For seeding submaps on Virgo 2"
	allow_duplicates = FALSE

/datum/map_template/virgo2/Flake
	name = "Forest Lake"
	desc = "A serene lake sitting amidst the surface."
	mappath = "maps/submaps/pois_vr/aerostat/Flake.dmm"
	cost = 10

/datum/map_template/virgo2/Mcamp1
	name = "Military Camp 1"
	desc = "A derelict military camp host to some unsavory dangers"
	mappath = "maps/submaps/pois_vr/aerostat/MCamp1.dmm"
	cost = 5

/datum/map_template/virgo2/Mudpit
	name = "Mudpit"
	desc = "What happens when someone is a bit too careless with gas.."
	mappath = "maps/submaps/pois_vr/aerostat/Mudpit.dmm"
	cost = 5

/datum/map_template/virgo2/Rocky1
	name = "Rocky1"
	desc = "DununanununanununuNAnana"
	mappath = "maps/submaps/pois_vr/aerostat/Rocky1.dmm"
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/virgo2/RareSample
	name = "Rocky1"
	desc = "Ooh, shiny!"	//a single rare sample, sitting in the open
	mappath = "maps/submaps/pois_vr/aerostat/RareSample.dmm"
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/virgo2/SamplePocket
	name = "Sampleroid"
	desc = "What's in the (rock)box?"	//one common/uncommon, one uncommon/rare, and one any grade
	mappath = "maps/submaps/pois_vr/aerostat/SamplePocket.dmm"
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/virgo2/Shack1
	name = "Shack1"
	desc = "A small shack in the middle of nowhere, Your halloween murder happens here"
	mappath = "maps/submaps/pois_vr/aerostat/Shack1.dmm"
	cost = 5

/datum/map_template/virgo2/Smol1
	name = "Smol1"
	desc = "A tiny grove of trees, The Nemesis of thicc"
	mappath = "maps/submaps/pois_vr/aerostat/Smol1.dmm"
	cost = 5

/datum/map_template/virgo2/Snowrock1
	name = "Snowrock1"
	desc = "A rocky snow covered area"
	mappath = "maps/submaps/pois_vr/aerostat/Snowrock1.dmm"
	cost = 5

/datum/map_template/virgo2/Lab1
	name = "Lab1"
	desc = "An isolated small robotics lab."
	mappath = "maps/submaps/pois_vr/aerostat/Lab1.dmm"
	cost = 5

/datum/map_template/virgo2/Rocky4
	name = "Rocky4"
	desc = "An interesting geographic formation."
	mappath = "maps/submaps/pois_vr/aerostat/Rocky4.dmm"
	cost = 5

/datum/map_template/virgo2/DJOutpost1
	name = "DJOutpost1"
	desc = "Home of Sif Free Radio, the best - and only - radio station for miles around."
	mappath = "maps/submaps/pois_vr/aerostat/DJOutpost1.dmm"
	template_group = "Sif Free Radio"
	cost = 5

/datum/map_template/virgo2/DJOutpost2
	name = "DJOutpost2"
	desc = "The cratered remains of Sif Free Radio, the best - and only - radio station for miles around."
	mappath = "maps/submaps/pois_vr/aerostat/DJOutpost2.dmm"
	template_group = "Sif Free Radio"
	cost = 5

/datum/map_template/virgo2/Boombase
	name = "Boombase"
	desc = "What happens when you don't follow SOP."
	mappath = "maps/submaps/pois_vr/aerostat/Boombase.dmm"
	cost = 5

/*
/datum/map_template/virgo2/BSD
	name = "Black Shuttle Down"
	desc = "You REALLY shouldn't be near this."
	mappath = "maps/submaps/pois_vr/aerostat/Blackshuttledown.dmm"
	cost = 30
*/

/datum/map_template/virgo2/Rockybase
	name = "Rocky Base"
	desc = "A guide to upsetting Icarus and the EIO"
	mappath = "maps/submaps/pois_vr/aerostat/Rockybase.dmm"
	cost = 35

/datum/map_template/virgo2/MHR
	name = "Manhack Rock"
	desc = "A rock filled with nasty Synthetics."
	mappath = "maps/submaps/pois_vr/aerostat/MHR.dmm"
	cost = 15

/datum/map_template/virgo2/GovPatrol
	name = "Government Patrol"
	desc = "A long lost SifGuard ground survey patrol. Now they have you guys!"
	mappath = "maps/submaps/pois_vr/aerostat/GovPatrol.dmm"
	cost = 5

/datum/map_template/virgo2/DecoupledEngine
	name = "Decoupled Engine"
	desc = "A damaged fission engine jettisoned from a starship long ago."
	mappath = "maps/submaps/pois_vr/aerostat/DecoupledEngine.dmm"
	cost = 15

/*
/datum/map_template/virgo2/DoomP
	name = "DoomP"
	desc = "Witty description here."
	mappath = "maps/submaps/pois_vr/aerostat/DoomP.dmm"
	cost = 30
*/

/datum/map_template/virgo2/Cave
	name = "CaveS"
	desc = "Chitter chitter!"
	mappath = "maps/submaps/pois_vr/aerostat/CaveS.dmm"
	cost = 20

/datum/map_template/virgo2/Drugden
	name = "Drugden"
	desc = "The remains of ill thought out whims."
	mappath = "maps/submaps/pois_vr/aerostat/Drugden.dmm"
	cost = 20

/datum/map_template/virgo2/Musk
	name = "Musk"
	desc = "0 to 60 in 1.9 seconds."
	mappath = "maps/submaps/pois_vr/aerostat/Musk.dmm"
	cost = 10

/datum/map_template/virgo2/Manor1
	name = "Manor1"
	desc = "Whodunit"
	mappath = "maps/submaps/pois_vr/aerostat/Manor1.dmm"
	cost = 20

/datum/map_template/virgo2/Epod3
	name = "Emergency Pod 3"
	desc = "A webbed Emergency pod in the middle of nowhere."
	mappath = "maps/submaps/pois_vr/aerostat/Epod3.dmm"
	cost = 5

/datum/map_template/virgo2/Epod4
	name = "Emergency Pod 4"
	desc = "A flooded Emergency pod in the middle of nowhere."
	mappath = "maps/submaps/pois_vr/aerostat/Epod4.dmm"
	cost = 5

/datum/map_template/virgo2/ButcherShack
	name = "Butcher Shack"
	desc = "An old, bloody butcher's shack. Get your meat here!"
	mappath = "maps/submaps/pois_vr/aerostat/butchershack.dmm"
	cost = 5
