// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so CI can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#ifdef MAP_TEST
#include "farm1.dmm"
#include "construction1.dmm"
#include "camp1.dmm"
#include "house1.dmm"
#include "beacons.dmm"
#include "Epod.dmm"
#include "Epod2.dmm"
#include "PascalB.dmm"
#include "bonfire.dmm"
#include "Rocky5.dmm"
#include "Field1.dmm"
#include "Thiefc.dmm"
#include "smol2.dmm"
#include "Mechpt.dmm"
#include "Boathouse.dmm"
#include "PooledR.dmm"
#include "Smol3.dmm"
#include "Diner.dmm"
#include "Snow1.dmm"
#include "Snow2.dmm"
#include "Snow3.dmm"
#include "Snow4.dmm"
#include "Snow5.dmm"
#include "SupplyDrop2.dmm"
#include "RationCache.dmm"
#include "Oldhouse.dmm"
#include "PlainsKururak.dmm"
#include "BuriedTreasure.dmm"
#include "BuriedTreasure2.dmm"
#include "BuriedTreasure3.dmm"
#include "methlab.dmm"
#include "hotspring.dmm"
#include "lonehome.dmm"
#include "priderock.dmm"
#include "oldhotel.dmm"
#include "VRDen.dmm"
#include "leopardmanderden.dmm"
#include "greatwolfden.dmm"
#include "syndisniper.dmm"
#include "otieshelter.dmm"
#include "lonewolf.dmm"
#include "emptycabin.dmm"
#include "dogbase.dmm"
#include "drgnplateu.dmm"
#endif


// The 'plains' is the area outside the immediate perimeter of the big outpost.
// POIs here should not be dangerous, be mundane, and be somewhat conversative on the loot. Some of the loot can be useful, but it shouldn't trivialize the Wilderness.

/datum/map_template/surface/plains
	name = "Surface Content - Plains"
	desc = "Used to make the surface outside the outpost be 16% less boring."

// To be added: Templates for surface exploration when they are made.

/datum/map_template/surface/plains/farm1
	name = "Farm 1"
	desc = "A small farm tended by a farmbot."
	mappath = 'maps/submaps/surface_submaps/plains/farm1_vr.dmm' //VOREStation Edit
	cost = 10

/datum/map_template/surface/plains/construction1
	name = "Construction Site 1"
	desc = "A structure being built. It seems laziness is not limited to engineers."
	mappath = 'maps/submaps/surface_submaps/plains/construction1.dmm'
	cost = 10

/datum/map_template/surface/plains/camp1
	name = "Camp Site 1"
	desc = "A small campsite, complete with housing and bonfire."
	mappath = 'maps/submaps/surface_submaps/plains/camp1_vr.dmm' //VOREStation Edit
	cost = 10

/datum/map_template/surface/plains/house1
	name = "House 1"
	desc = "A fair sized house out in the frontier, that belonged to a well-traveled explorer."
	mappath = 'maps/submaps/surface_submaps/plains/house1_vr.dmm' //VOREStation Edit
	cost = 10

/datum/map_template/surface/plains/beacons
	name = "Collection of Marker Beacons"
	desc = "A bunch of marker beacons, scattered in a strange pattern."
	mappath = 'maps/submaps/surface_submaps/plains/beacons.dmm'
	cost = 5
	fixed_orientation = TRUE

/datum/map_template/surface/plains/Epod
	name = "Emergency Pod"
	desc = "A vacant Emergency pod in the middle of nowhere."
	mappath = 'maps/submaps/surface_submaps/plains/Epod.dmm'
	cost = 5

/datum/map_template/surface/plains/Epod2
	name = "Emergency Pod 2"
	desc = "A locked Emergency pod in the middle of nowhere."
	mappath = 'maps/submaps/surface_submaps/plains/Epod2.dmm'
	cost = 5

/datum/map_template/surface/plains/normal/Rocky2
	name =  "Rocky 2"
	desc = "More rocks."
	mappath = 'maps/submaps/surface_submaps/plains/Rocky2.dmm'
	allow_duplicates = TRUE
	cost = 5

/datum/map_template/surface/plains/PascalB
	name = "Irradiated Manhole Cover"
	desc = "How did this old thing get all the way out here?"
	mappath = 'maps/submaps/surface_submaps/plains/PascalB.dmm'
	cost = 5

/datum/map_template/surface/plains/bonfire
	name = "Abandoned Bonfire"
	desc = "Someone seems to enjoy orange juice a bit too much."
	mappath = 'maps/submaps/surface_submaps/plains/bonfire.dmm'
	cost = 5

/datum/map_template/surface/plains/Rocky5
	name = "Rocky 5"
	desc = "More rocks, Less Stalone"
	mappath = 'maps/submaps/surface_submaps/plains/Rocky5.dmm'
	cost = 5

/datum/map_template/surface/plains/Shakden
	name = "Shantak Den"
	desc = "Not to be confused with Shaq Den"
	mappath = 'maps/submaps/surface_submaps/plains/Shakden_vr.dmm' //VOREStation Edit
	cost = 10

/datum/map_template/surface/plains/Field1
	name = "Field 1"
	desc = "A regular field with a tug on it"
	mappath = 'maps/submaps/surface_submaps/plains/Field1.dmm'
	cost = 20

/datum/map_template/surface/plains/Thiefc
	name = "Thieves Cave"
	desc = "A thieves stash"
	mappath = 'maps/submaps/surface_submaps/plains/Thiefc_vr.dmm' //VOREStation Edit
	cost = 20

/datum/map_template/surface/plains/smol2
	name = "Small 2"
	desc = "A small formation of mishaped surgery"
	mappath = 'maps/submaps/surface_submaps/plains/smol2.dmm'
	cost = 10

/datum/map_template/surface/plains/Mechpt
	name = "Mechpit"
	desc = "A illmade Mech brawling ring"
	mappath = 'maps/submaps/surface_submaps/plains/Mechpt.dmm'
	cost = 15

/datum/map_template/surface/plains/Boathouse
	name = "Boathouse"
	desc = "A fance house on a lake."
	mappath = 'maps/submaps/surface_submaps/plains/Boathouse_vr.dmm' //VOREStation Edit
	cost = 30

/datum/map_template/surface/plains/PooledR
	name = "Pooled Rocks"
	desc = "An intresting rocky location"
	mappath = 'maps/submaps/surface_submaps/plains/PooledR_vr.dmm' //VOREStation Edit
	cost = 15

/datum/map_template/surface/plains/Smol3
	name = "Small 3"
	desc = "A small stand"
	mappath = 'maps/submaps/surface_submaps/plains/Smol3.dmm'
	cost = 10

/datum/map_template/surface/plains/Diner
	name = "Diner"
	desc = "Old Timey Tasty"
	mappath = 'maps/submaps/surface_submaps/plains/Diner_vr.dmm' //VOREStation Edit
	cost = 25

/datum/map_template/surface/plains/snow1
	name = "Snow 1"
	desc = "Snow"
	mappath = 'maps/submaps/surface_submaps/plains/snow1.dmm'
	cost = 5

/datum/map_template/surface/plains/snow2
	name = "Snow 2"
	desc = "More snow"
	mappath = 'maps/submaps/surface_submaps/plains/snow2.dmm'
	cost = 5

/datum/map_template/surface/plains/snow3
	name = "Snow 3"
	desc = "Snow Snow Snow"
	mappath = 'maps/submaps/surface_submaps/plains/snow3.dmm'
	cost = 5

/datum/map_template/surface/plains/snow4
	name = "Snow 4"
	desc = "Too much snow"
	mappath = 'maps/submaps/surface_submaps/plains/snow4.dmm'
	cost = 5

/datum/map_template/surface/plains/snow5
	name = "Snow 5"
	desc = "Please stop the snow"
	mappath = 'maps/submaps/surface_submaps/plains/snow5.dmm'
	cost = 5

/datum/map_template/surface/plains/RationCache
	name = "Ration Cache"
	desc = "A forgotten cache of emergency rations."
	mappath = 'maps/submaps/surface_submaps/plains/RationCache_vr.dmm' //VOREStation Edit
	cost = 5

/datum/map_template/surface/plains/SupplyDrop2
	name = "Old Supply Drop"
	desc = "A drop pod that's clearly been here a while, most of the things inside are rusted and worthless."
	mappath = 'maps/submaps/surface_submaps/plains/SupplyDrop2.dmm'
	cost = 8

/datum/map_template/surface/plains/Oldhouse
	name = "Old House"
	desc = "Someones old library it seems.."
	mappath = 'maps/submaps/surface_submaps/plains/Oldhouse_vr.dmm' //VOREStation Edit
	cost = 15

/datum/map_template/surface/plains/ChemSpill1
	name = "Ruptured Canister"
	desc = "A dumped chemical canister. Looks dangerous."
	mappath = 'maps/submaps/surface_submaps/plains/chemspill1_vr.dmm' //VOREStation Edit
	cost = 10

/datum/map_template/surface/plains/PlainsKururak
	name = "Lone Kururak"
	desc = "A lone Kururak's den."
	mappath = 'maps/submaps/surface_submaps/plains/PlainsKururak.dmm'
	cost = 10

/datum/map_template/surface/plains/BuriedTreasure1
	name = "Buried Treasure 1"
	desc = "A hole in the ground, who knows what might be inside!"
	mappath = 'maps/submaps/surface_submaps/plains/BuriedTreasure.dmm'
	cost = 10
	template_group = "Shallow Grave"

/datum/map_template/surface/plains/BuriedTreasure2
	name = "Buried Treasure 2"
	desc = "A hole in the ground, who knows what might be inside!"
	mappath = 'maps/submaps/surface_submaps/plains/BuriedTreasure2.dmm'
	cost = 10
	template_group = "Shallow Grave"

/datum/map_template/surface/plains/BuriedTreasure3
	name = "Buried Treasure 3"
	desc = "A hole in the ground, who knows what might be inside!"
	mappath = 'maps/submaps/surface_submaps/plains/BuriedTreasure3.dmm'
	cost = 10
	template_group = "Shallow Grave"

/datum/map_template/surface/plains/oldhotel
	name = "Old Hotel"
	desc = "A abandoned hotel of sort, wonder why it was left behind."
	mappath = 'maps/submaps/surface_submaps/plains/oldhotel.dmm'
	cost = 15

/datum/map_template/surface/plains/priderock
	name = "Pride Rock"
	desc = "A quite steep petruding rock from the earth, looks like a good hike."
	mappath = 'maps/submaps/surface_submaps/plains/priderock.dmm'
	cost = 10

/datum/map_template/surface/plains/lonehome
	name = "Lone Home"
	desc = "A quite inoffensive looking home, damaged but still holding up."
	mappath = 'maps/submaps/surface_submaps/plains/lonehome_vr.dmm' //VOREStation Edit
	cost = 15

/datum/map_template/surface/plains/hotspring
	name = "Hot Spring"
	desc = "Wait what, a hotspring in a frost planet?"
	mappath = 'maps/submaps/surface_submaps/plains/hotspring.dmm'
	cost = 5

/datum/map_template/surface/plains/methlab
	name = "Meth Lab"
	desc = "A broken down greenhouse lab?, this does not look safe."
	mappath = 'maps/submaps/surface_submaps/plains/methlab.dmm'
	cost = 15

/datum/map_template/surface/plains/VRDen
	name = "VR Den"
	desc = "A temporarily abandoned VR den, still functional."
	mappath = 'maps/submaps/surface_submaps/plains/VRDen.dmm'
	cost = 10

/datum/map_template/surface/plains/leopardmanderden
	name = "Leopardmander Den"
	desc = "Den of a voracious but very rare beast."
	mappath = 'maps/submaps/surface_submaps/plains/leopardmanderden.dmm'
	cost = 10

/datum/map_template/surface/plains/greatwolfden
	name = "Great Wolf Den"
	desc = "Den hosted by the biggest alpha wolf of the wilderness"
	mappath = 'maps/submaps/surface_submaps/plains/greatwolfden.dmm'
	cost = 15

/datum/map_template/surface/plains/dogbase
	name = "Dog Base"
	desc = "A highly secured base with hungry trained canines"
	mappath = 'maps/submaps/surface_submaps/plains/dogbase.dmm'
	cost = 20
	allow_duplicates = FALSE

/datum/map_template/surface/wilderness/normal/emptycabin
	name = "Empty Cabin"
	desc = "An inconspicuous looking den hosted by a hungry otie"
	mappath = 'maps/submaps/surface_submaps/plains/emptycabin.dmm'
	cost = 10

/datum/map_template/surface/plains/lonewolf
	name = "Lone Wolf"
	desc = "A large oppressing wolf, supervising from above its cliff"
	mappath = 'maps/submaps/surface_submaps/plains/lonewolf.dmm'
	cost = 5

/datum/map_template/surface/plains/otieshelter
	name = "Otie Shelter"
	desc = "A experimental lab of various breeds of oties"
	mappath = 'maps/submaps/surface_submaps/plains/otieshelter.dmm'
	cost = 15

/datum/map_template/surface/plains/syndisniper
	name = "Syndi Sniper"
	desc = "Syndicate watch tower, deadly but secluded"
	mappath = 'maps/submaps/surface_submaps/plains/syndisniper.dmm'

	cost = 5

/datum/map_template/surface/plains/drgnplateu
	name = "Dragon Plateu"
	desc = "A dangerous plateu of cliffs home to a rampant gold hoarding dragon"
	mappath = 'maps/submaps/surface_submaps/plains/drgnplateu.dmm'
	cost = 15
	allow_duplicates = FALSE
