#define FISHING_RARE     "rare"
#define FISHING_UNCOMMON "uncommon"
#define FISHING_COMMON   "common"
#define FISHING_JUNK     "junk"
#define FISHING_NOTHING  "nothing"

GLOBAL_LIST_INIT(indoor_fishing_chance_list, list(FISHING_RARE = 5, FISHING_UNCOMMON = 20, FISHING_COMMON = 30, FISHING_JUNK = 5, FISHING_NOTHING = 50))
GLOBAL_LIST_INIT(indoor_fishing_junk_list, list(
		/obj/random/junk = 15,
		/obj/random/maintenance/clean = 1
		))

/turf/simulated/floor/water/indoors
	min_fishing_time = 33
	max_fishing_time = 99

/turf/simulated/floor/water/indoors/handle_fish()
	if(has_fish)
		rare_fish_list = GLOB.generic_fishing_rare_list
		uncommon_fish_list = GLOB.generic_fishing_uncommon_list
		common_fish_list = GLOB.generic_fishing_common_list
		junk_list = GLOB.indoor_fishing_junk_list
		fishing_loot = GLOB.indoor_fishing_chance_list

/turf/simulated/floor/water/deep/indoors
	min_fishing_time = 33
	max_fishing_time = 99

/turf/simulated/floor/water/deep/indoors/handle_fish()
	if(has_fish)
		rare_fish_list = GLOB.generic_fishing_rare_list
		uncommon_fish_list = GLOB.generic_fishing_uncommon_list
		common_fish_list = GLOB.generic_fishing_common_list
		junk_list = GLOB.indoor_fishing_junk_list
		fishing_loot = GLOB.indoor_fishing_chance_list

// Ocean fishing
GLOBAL_LIST_INIT(ocean_fishing_chance_list, list(FISHING_RARE = 5, FISHING_UNCOMMON = 20, FISHING_COMMON = 30, FISHING_JUNK = 40, FISHING_NOTHING = 5)) // the ocean is teeming with life... and junk
GLOBAL_LIST_INIT(ocean_fishing_rare_list, list(
		/mob/living/simple_mob/animal/passive/fish/solarfish = 1,
		/mob/living/simple_mob/animal/passive/fish/measelshark = 10
		))

GLOBAL_LIST_INIT(ocean_fishing_uncommon_list, list(
		/mob/living/simple_mob/animal/passive/crab/sif = 1,
		/obj/item/reagent_containers/food/snacks/sliceable/monkfish = 10
		))

GLOBAL_LIST_INIT(ocean_fishing_common_list, list(
		/mob/living/simple_mob/animal/passive/fish/rockfish = 5,
		/mob/living/simple_mob/animal/passive/crab = 1,
		/obj/item/reagent_containers/food/snacks/cuttlefish = 10,
		/obj/item/reagent_containers/food/snacks/lobster = 8
		))

/turf/simulated/floor/water/ocean
	min_fishing_time = 30
	max_fishing_time = 90

/turf/simulated/floor/water/ocean/handle_fish()
	if(has_fish)
		rare_fish_list = GLOB.ocean_fishing_rare_list
		uncommon_fish_list = GLOB.ocean_fishing_uncommon_list
		common_fish_list = GLOB.ocean_fishing_common_list
		junk_list = GLOB.generic_fishing_junk_list
		fishing_loot = GLOB.ocean_fishing_chance_list

/turf/simulated/floor/water/deep/ocean
	min_fishing_time = 20
	max_fishing_time = 80

/turf/simulated/floor/water/deep/ocean/handle_fish()
	if(has_fish)
		rare_fish_list = GLOB.ocean_fishing_rare_list
		uncommon_fish_list = GLOB.ocean_fishing_uncommon_list
		common_fish_list = GLOB.ocean_fishing_common_list
		junk_list = GLOB.generic_fishing_junk_list
		fishing_loot = GLOB.ocean_fishing_chance_list



#undef FISHING_RARE
#undef FISHING_UNCOMMON
#undef FISHING_COMMON
#undef FISHING_JUNK
#undef FISHING_NOTHING
