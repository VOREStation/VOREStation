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


#undef FISHING_RARE
#undef FISHING_UNCOMMON
#undef FISHING_COMMON
#undef FISHING_JUNK
#undef FISHING_NOTHING