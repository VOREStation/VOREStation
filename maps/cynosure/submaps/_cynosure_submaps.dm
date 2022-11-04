// This causes PoI maps to get 'checked' and compiled, when undergoing a unit test.
// This is so CI can validate PoIs, and ensure future changes don't break PoIs, as PoIs are loaded at runtime and the compiler can't catch errors.
// When adding a new PoI, please add it to this list.
#if MAP_TEST
#include "5x7/MedicalBreakRoom.dmm"
#include "5x7/MedicalWasteStorage.dmm"
#include "5x7/SurgeryTrainingRoom.dmm"
#include "7x7/FightClub.dmm"
#include "7x7/JanitorCloset.dmm"
#include "7x7/PartyRoom.dmm"
#include "9x8/GamesRoom.dmm"
#include "9x8/ServerRoom.dmm"
#include "9x8/HotTub.dmm"
#endif

// The PoIs below, unlike other randomly placed Points of Interest, are placed in fixed positions inside the station,
// in pre-determined locations. One PoI in each 'group' will always be spawned.

/datum/map_template/cynosure_fixed
	name = "Cynosure Specific Content"
	desc = "New Map New Shiny"

/obj/effect/landmark/submap_position/random_subtype/cynosure_medical_basement
	name = "5x7 Medical Submap Loader"
	submap_path = /datum/map_template/cynosure_fixed/medical_basement

/datum/map_template/cynosure_fixed/medical_basement

/datum/map_template/cynosure_fixed/medical_basement/break_room
	name = "Medical Break Room"
	mappath = 'maps/cynosure/submaps/5x7/MedicalBreakRoom.dmm'

/datum/map_template/cynosure_fixed/medical_basement/waste_storage
	name = "Medical Waste Storage"
	mappath = 'maps/cynosure/submaps/5x7/MedicalWasteStorage.dmm'

/datum/map_template/cynosure_fixed/medical_basement/training_room
	name = "Medical Surgery Training Room"
	mappath = 'maps/cynosure/submaps/5x7/SurgeryTrainingRoom.dmm'



/obj/effect/landmark/submap_position/random_subtype/cynosure_seven_by_seven_maint
	name = "7x7 Maintenance Submap Loader"
	submap_path = /datum/map_template/cynosure_fixed/seven_by_seven_maint

/datum/map_template/cynosure_fixed/seven_by_seven_maint

/datum/map_template/cynosure_fixed/seven_by_seven_maint/fight_club
	name = "Fight Club"
	mappath = 'maps/cynosure/submaps/7x7/FightClub.dmm'

/datum/map_template/cynosure_fixed/seven_by_seven_maint/janitor_closet
	name = "Janitor Closet"
	mappath = 'maps/cynosure/submaps/7x7/JanitorCloset.dmm'

/datum/map_template/cynosure_fixed/seven_by_seven_maint/server_room
	name = "Party Room"
	mappath = 'maps/cynosure/submaps/7x7/PartyRoom.dmm'



/obj/effect/landmark/submap_position/random_subtype/cynosure_eight_by_five_maint
	name = "8x5 Maintenance Submap Loader"
	submap_path = /datum/map_template/cynosure_fixed/eight_by_five_maint

/datum/map_template/cynosure_fixed/eight_by_five_maint

/datum/map_template/cynosure_fixed/eight_by_five_maint/growers_den
	name = "Grower's Den"
	mappath = 'maps/cynosure/submaps/8x5/GrowersDen.dmm'

/datum/map_template/cynosure_fixed/eight_by_five_maint/hidden_bar
	name = "Hidden Bar"
	mappath = 'maps/cynosure/submaps/8x5/HiddenBar.dmm'

/datum/map_template/cynosure_fixed/eight_by_five_maint/restroom
	name = "Restroom"
	mappath = 'maps/cynosure/submaps/8x5/Restroom.dmm'

/datum/map_template/cynosure_fixed/eight_by_five_maint/squatters_den
	name = "Squatter's Den"
	mappath = 'maps/cynosure/submaps/8x5/SquattersDen.dmm'



/obj/effect/landmark/submap_position/random_subtype/cynosure_eight_by_nine_maint
	name = "8x9 Maintenance Submap Loader"
	submap_path = /datum/map_template/cynosure_fixed/eight_by_nine_maint

/datum/map_template/cynosure_fixed/eight_by_nine_maint

/datum/map_template/cynosure_fixed/eight_by_nine_maint/meeting_room
	name = "Meeting Room"
	mappath = 'maps/cynosure/submaps/8x9/MeetingRoom.dmm'

/datum/map_template/cynosure_fixed/eight_by_nine_maint/mouse_house
	name = "Mouse House"
	mappath = 'maps/cynosure/submaps/8x9/MouseHouse.dmm'

/datum/map_template/cynosure_fixed/eight_by_nine_maint/reptile_room
	name = "Reptile Room"
	mappath = 'maps/cynosure/submaps/8x9/ReptileRoom.dmm'

/datum/map_template/cynosure_fixed/eight_by_nine_maint/ritual_room
	name = "Ritual Room"
	mappath = 'maps/cynosure/submaps/8x9/RitualRoom.dmm'



/obj/effect/landmark/submap_position/random_subtype/cynosure_nine_by_eight_maint
	name = "9x8 Maint Submap Loader"
	submap_path = /datum/map_template/cynosure_fixed/nine_by_eight_maint

/datum/map_template/cynosure_fixed/nine_by_eight_maint

/datum/map_template/cynosure_fixed/nine_by_eight_maint/games_room
	name = "Games Room"
	mappath = 'maps/cynosure/submaps/9x8/GamesRoom.dmm'

/datum/map_template/cynosure_fixed/nine_by_eight_maint/server_room
	name = "Server Room"
	mappath = 'maps/cynosure/submaps/9x8/ServerRoom.dmm'

/datum/map_template/cynosure_fixed/nine_by_eight_maint/hot_tub
	name = "Hot Tub"
	mappath = 'maps/cynosure/submaps/9x8/HotTub.dmm'



/obj/effect/landmark/submap_position/random_subtype/cynosure_nine_by_ten_maint
	name = "9x10 Maint Submap Loader"
	submap_path = /datum/map_template/cynosure_fixed/nine_by_ten_maint

/datum/map_template/cynosure_fixed/nine_by_ten_maint

/datum/map_template/cynosure_fixed/nine_by_ten_maint/pressure_chamber
	name = "Pressure Chamber"
	mappath = 'maps/cynosure/submaps/9x10/PressureChamber.dmm'

/datum/map_template/cynosure_fixed/nine_by_ten_maint/sauna
	name = "Sauna"
	mappath = 'maps/cynosure/submaps/9x10/Sauna.dmm'

/datum/map_template/cynosure_fixed/nine_by_ten_maint/shooting_range
	name = "Shooting Range"
	mappath = 'maps/cynosure/submaps/9x10/ShootingRange.dmm'

/datum/map_template/cynosure_fixed/nine_by_ten_maint/theater
	name = "Theater"
	mappath = 'maps/cynosure/submaps/9x10/Theater.dmm'



/obj/effect/landmark/submap_position/random_subtype/cynosure_ten_by_nine_maint
	name = "10x9 Maint Submap Loader"
	submap_path = /datum/map_template/cynosure_fixed/ten_by_nine_maint

/datum/map_template/cynosure_fixed/ten_by_nine_maint

/datum/map_template/cynosure_fixed/ten_by_nine_maint/shop
	name = "Shop"
	mappath = 'maps/cynosure/submaps/10x9/Shop.dmm'

/datum/map_template/cynosure_fixed/ten_by_nine_maint/treasure_hoard
	name = "Treasure Hoard"
	mappath = 'maps/cynosure/submaps/10x9/TreasureHoard.dmm'

/datum/map_template/cynosure_fixed/ten_by_nine_maint/warehouse_one
	name = "Warehouse One"
	mappath = 'maps/cynosure/submaps/10x9/Warehouse1.dmm'

/datum/map_template/cynosure_fixed/ten_by_nine_maint/warehouse_two
	name = "Warehouse Two"
	mappath = 'maps/cynosure/submaps/10x9/Warehouse2.dmm'

/datum/map_template/cynosure_fixed/ten_by_nine_maint/warehouse_three
	name = "Warehouse Three"
	mappath = 'maps/cynosure/submaps/10x9/Warehouse3.dmm'


/obj/effect/landmark/submap_position/random_subtype/cynosure_sixteen_by_eleven_maint
	name = "16x11 Maint Submap Loader"
	submap_path = /datum/map_template/cynosure_fixed/sixteen_by_eleven_maint

/datum/map_template/cynosure_fixed/sixteen_by_eleven_maint

/datum/map_template/cynosure_fixed/sixteen_by_eleven_maint/laser_tag
	name = "Laser Tag"
	mappath = 'maps/cynosure/submaps/16x11/LaserTag.dmm'

/datum/map_template/cynosure_fixed/sixteen_by_eleven_maint/nightclub
	name = "Nightclub"
	mappath = 'maps/cynosure/submaps/16x11/Nightclub.dmm'

/datum/map_template/cynosure_fixed/sixteen_by_eleven_maint/old_dorms
	name = "Old Dorms"
	mappath = 'maps/cynosure/submaps/16x11/OldDorms.dmm'