// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so CI can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
#include "spider1.dmm"
#include "Flake.dmm"
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
#include "Blueshuttledown.dmm"
#include "Lab1.dmm"
#include "Rocky4.dmm"
#include "DJOutpost1.dmm"
#include "DJOutpost2.dmm"
#include "Rockybase.dmm"
#include "MHR.dmm"
#include "GovPatrol.dmm"
#include "kururakden.dmm"
#include "DecoupledEngine.dmm"
#include "DoomP.dmm"
#include "CaveS.dmm"
#include "Drugden.dmm"
#include "Musk.dmm"
#include "Manor1.dmm"
#include "Epod3.dmm"
#include "Epod4.dmm"
#include "ButcherShack.dmm"
#include "Chapel.dmm"
#include "Shelter.dmm"
#include "derelictengine.dmm"
#include "wolfden.dmm"
#include "demonpool.dmm"
#include "frostoasis.dmm"
#include "xenohive.dmm"
#include "borglab.dmm"
#include "chasm.dmm"
#include "deathden.dmm"
#include "leopardmanderden.dmm"
#include "greatwolfden.dmm"
#include "syndisniper.dmm"
#include "otieshelter.dmm"
#include "lonewolf.dmm"
#include "emptycabin.dmm"
#include "dogbase.dmm"
#include "drgnplateu.dmm"
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
	name = "Rocky 1"
	desc = "DununanununanununuNAnana"
	mappath = 'maps/submaps/surface_submaps/wilderness/Rocky1.dmm'
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/surface/wilderness/normal/Rocky2
	name =  "Rocky 2"
	desc = "More rocks."
	mappath = 'maps/submaps/surface_submaps/wilderness/Rocky2.dmm'
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/surface/wilderness/normal/Rocky3
	name = "Rocky 3"
	desc = "More and more and more rocks."
	mappath = 'maps/submaps/surface_submaps/wilderness/Rocky3.dmm'
	desc = "DununanununanununuNAnana"
	cost = 5

/datum/map_template/surface/wilderness/normal/Shack1
	name = "Shack 1"
	desc = "A small shack in the middle of nowhere, Your halloween murder happens here"
	mappath = 'maps/submaps/surface_submaps/wilderness/Shack1.dmm'
	cost = 5

/datum/map_template/surface/wilderness/normal/Smol1
	name = "Smol 1"
	desc = "A tiny grove of trees, The Nemesis of thicc"
	mappath = 'maps/submaps/surface_submaps/wilderness/Smol1.dmm'
	cost = 5

/datum/map_template/surface/wilderness/normal/Snowrock1
	name = "Snowrock 1"
	desc = "A rocky snow covered area"
	mappath = 'maps/submaps/surface_submaps/wilderness/Snowrock1.dmm'
	cost = 5

/datum/map_template/surface/wilderness/normal/Cragzone1
	name = "Cragzone 1"
	desc = "Rocks and more rocks."
	mappath = 'maps/submaps/surface_submaps/wilderness/Cragzone1.dmm'
	cost = 5
	allow_duplicates = TRUE

/datum/map_template/surface/wilderness/normal/Lab1
	name = "Lab 1"
	desc = "An isolated small robotics lab."
	mappath = 'maps/submaps/surface_submaps/wilderness/Lab1.dmm'
	cost = 5

/datum/map_template/surface/wilderness/normal/Rocky4
	name = "Rocky 4"
	desc = "An interesting geographic formation."
	mappath = 'maps/submaps/surface_submaps/wilderness/Rocky4.dmm'
	cost = 5

/datum/map_template/surface/wilderness/deep/DJOutpost1
	name = "DJOutpost 1"
	desc = "Home of Sif Free Radio, the best - and only - radio station for miles around."
	mappath = 'maps/submaps/surface_submaps/wilderness/DJOutpost1.dmm'
	template_group = "Sif Free Radio"
	cost = 5

/datum/map_template/surface/wilderness/deep/DJOutpost2
	name = "DJOutpost 2"
	desc = "The cratered remains of Sif Free Radio, the best - and only - radio station for miles around."
	mappath = 'maps/submaps/surface_submaps/wilderness/DJOutpost2.dmm'
	template_group = "Sif Free Radio"
	cost = 5

/datum/map_template/surface/wilderness/deep/DJOutpost3
	name = "DJOutpost 3"
	desc = "The surprisingly high-tech home of Sif Free Radio, the best - and only - radio station for miles around."
	mappath = 'maps/submaps/surface_submaps/wilderness/DJOutpost3.dmm'
	template_group = "Sif Free Radio"
	cost = 10

/datum/map_template/surface/wilderness/deep/DJOutpost4
	name = "DJOutpost 4"
	desc = "The surprisingly high-tech home of Sif Free Radio, the only radio station run by mindless clones."
	mappath = 'maps/submaps/surface_submaps/wilderness/DJOutpost4.dmm'
	template_group = "Sif Free Radio"
	cost = 10

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
	template_group = "Shuttle Down"

/datum/map_template/surface/wilderness/deep/BluSD
	name = "Blue Shuttle Down"
	desc = "You REALLY shouldn't be near this. Mostly because they're SolGov."
	mappath = 'maps/submaps/surface_submaps/wilderness/Blueshuttledown.dmm'
	cost = 50
	template_group = "Shuttle Down"

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

/datum/map_template/surface/wilderness/normal/GovPatrol
	name = "Government Patrol"
	desc = "A long lost SifGuard ground survey patrol. Now they have you guys!"
	mappath = 'maps/submaps/surface_submaps/wilderness/GovPatrol.dmm'
	cost = 5

/datum/map_template/surface/wilderness/normal/KururakDen
	name = "Kururak Den"
	desc = "The den of a Kururak pack. May contain hibernating members."
	mappath = 'maps/submaps/surface_submaps/wilderness/kururakden.dmm'
	cost = 5

/datum/map_template/surface/wilderness/normal/DecoupledEngine
	name = "Decoupled Engine"
	desc = "A damaged fission engine jettisoned from a starship long ago."
	mappath = 'maps/submaps/surface_submaps/wilderness/DecoupledEngine.dmm'
	cost = 15

/datum/map_template/surface/wilderness/deep/DoomP
	name = "DoomP"
	desc = "Witty description here."
	mappath = 'maps/submaps/surface_submaps/wilderness/DoomP.dmm'
	cost = 30

/datum/map_template/surface/wilderness/deep/Cave
	name = "CaveS"
	desc = "Chitter chitter!"
	mappath = 'maps/submaps/surface_submaps/wilderness/CaveS.dmm'
	cost = 20

/datum/map_template/surface/wilderness/normal/Drugden
	name = "Drug Den"
	desc = "The remains of ill thought out whims."
	mappath = 'maps/submaps/surface_submaps/wilderness/Drugden.dmm'
	cost = 20

/datum/map_template/surface/wilderness/normal/Musk
	name = "Musk"
	desc = "0 to 60 in 1.9 seconds."
	mappath = 'maps/submaps/surface_submaps/wilderness/Musk.dmm'
	cost = 10

/datum/map_template/surface/wilderness/deep/Manor1
	name = "Manor 1"
	desc = "Whodunit"
	mappath = 'maps/submaps/surface_submaps/wilderness/Manor1.dmm'
	cost = 20

/datum/map_template/surface/wilderness/deep/Epod3
	name = "Emergency Pod 3"
	desc = "A webbed Emergency pod in the middle of nowhere."
	mappath = 'maps/submaps/surface_submaps/wilderness/Epod3.dmm'
	cost = 5

/datum/map_template/surface/wilderness/normal/Epod4
	name = "Emergency Pod 4"
	desc = "A flooded Emergency pod in the middle of nowhere."
	mappath = 'maps/submaps/surface_submaps/wilderness/Epod4.dmm'
	cost = 5

/datum/map_template/surface/wilderness/normal/ButcherShack
	name = "Butcher Shack"
	desc = "An old, bloody butcher's shack. Get your meat here!"
	mappath = 'maps/submaps/surface_submaps/wilderness/ButcherShack.dmm'
	cost = 5

/datum/map_template/surface/wilderness/deep/Chapel1
	name = "Chapel 1"
	desc = "The chapel of lights and a robot."
	mappath = 'maps/submaps/surface_submaps/wilderness/Chapel.dmm'
	cost = 20

/datum/map_template/surface/wilderness/normal/Shelter1
	name = "Shelter 1"
	desc = "The remains of a resourceful, but prideful explorer."
	mappath = 'maps/submaps/surface_submaps/wilderness/Shelter.dmm'
	cost = 10

/datum/map_template/surface/wilderness/normal/ChemSpill2
	name = "Acrid Lake"
	desc = "A pool of water contaminated with highly dangerous chemicals."
	mappath = 'maps/submaps/surface_submaps/wilderness/chemspill2.dmm'
	cost = 10

/datum/map_template/surface/wilderness/normal/FrostflyNest
	name = "Frostfly Nest"
	desc = "The nest of a Frostfly, or more."
	mappath = 'maps/submaps/surface_submaps/wilderness/FrostflyNest.dmm'
	cost = 20

/datum/map_template/surface/wilderness/deep/DerelictEngine
	name = "Derelict Engine"
	desc = "An crashed alien ship, something went wrong inside."
	mappath = 'maps/submaps/surface_submaps/wilderness/derelictengine.dmm'
	cost = 45

/datum/map_template/surface/wilderness/normal/WolfDen
	name = "Wolf Den"
	desc = "Small wolf den and their hunt spoils."
	mappath = 'maps/submaps/surface_submaps/wilderness/wolfden.dmm'
	cost = 10

/datum/map_template/surface/wilderness/normal/DemonPool
	name = "Demon Pool"
	desc = "A cult ritual gone horribly wrong."
	mappath = 'maps/submaps/surface_submaps/wilderness/demonpool.dmm'
	cost = 15

/datum/map_template/surface/wilderness/normal/FrostOasis
	name = "Frost Oasis"
	desc = "A strange oasis with a gathering of wild animals."
	mappath = 'maps/submaps/surface_submaps/wilderness/frostoasis.dmm'
	cost = 15

/datum/map_template/surface/wilderness/deep/XenoHive
	name = "Xeno Hive"
	desc = "A containment experiment gone wrong."
	mappath = 'maps/submaps/surface_submaps/wilderness/xenohive.dmm'
	cost = 25

/datum/map_template/surface/wilderness/deep/BorgLab
	name = "Borg Lab"
	desc = "Production of experimental combat robots gone rogue."
	mappath = 'maps/submaps/surface_submaps/wilderness/borglab.dmm'
	cost = 30

/datum/map_template/surface/wilderness/normal/Chasm
	name = "Chasm"
	desc = "An inconspicuous looking cave, watch your step."
	mappath = 'maps/submaps/surface_submaps/wilderness/chasm.dmm'
	cost = 20

/datum/map_template/surface/wilderness/deep/DeathDen
	name = "Death Den"
	desc = "Gathering of acolytes gone wrong."
	mappath = 'maps/submaps/surface_submaps/wilderness/deathden.dmm'
	cost = 15

/datum/map_template/surface/wilderness/deep/leopardmanderden
	name = "Leopardmander Den"
	desc = "Den of a voracious but very rare beast."
	mappath = 'maps/submaps/surface_submaps/wilderness/leopardmanderden.dmm'
	cost = 10

/datum/map_template/surface/wilderness/deep/greatwolfden
	name = "Great Wolf Den"
	desc = "Den hosted by the biggest alpha wolf of the wilderness"
	mappath = 'maps/submaps/surface_submaps/wilderness/greatwolfden.dmm'
	cost = 15

/datum/map_template/surface/wilderness/deep/dogbase
	name = "Dog Base"
	desc = "A highly secured base with hungry trained canines"
	mappath = 'maps/submaps/surface_submaps/wilderness/dogbase.dmm'
	cost = 20

/datum/map_template/surface/wilderness/normal/emptycabin
	name = "Empty Cabin"
	desc = "An inconspicuous looking den hosted by a hungry otie"
	mappath = 'maps/submaps/surface_submaps/wilderness/emptycabin.dmm'
	cost = 10

/datum/map_template/surface/wilderness/deep/lonewolf
	name = "Lone Wolf"
	desc = "A large oppressing wolf, supervising from above its cliff"
	mappath = 'maps/submaps/surface_submaps/wilderness/lonewolf.dmm'
	cost = 5

/datum/map_template/surface/wilderness/deep/otieshelter
	name = "Otie Shelter"
	desc = "A experimental lab of various breeds of oties"
	mappath = 'maps/submaps/surface_submaps/wilderness/otieshelter.dmm'
	cost = 15

/datum/map_template/surface/wilderness/deep/syndisniper
	name = "Syndi Sniper"
	desc = "Syndicate watch tower, deadly but secluded"
	mappath = 'maps/submaps/surface_submaps/wilderness/syndisniper.dmm'
	cost = 5

/datum/map_template/surface/wilderness/deep/drgnplateu
	name = "Dragon Plateu"
	desc = "A dangerous plateu of cliffs home to a rampant gold hoarding dragon"
	mappath = 'maps/submaps/surface_submaps/wilderness/drgnplateu.dmm'
	cost = 15
