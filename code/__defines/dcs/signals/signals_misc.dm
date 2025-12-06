//MISC SIGNALS THAT NEED TO BE ASSIGNED TO PROPER FILES STILL

// base /decl/emote/proc/do_emote() : (mob/user, extra_params)
#define COMSIG_GLOB_EMOTE_PERFORMED "!emote_performed"
// base /proc/say_dead_direct() : (message)
#define COMSIG_GLOB_DEAD_SAY "!dead_say"
// base /turf/wash() : ()
#define COMSIG_GLOB_WASHED_FLOOR "!washed_floor"
// base /obj/machinery/artifact_harvester/proc/harvest() : (obj/item/anobattery/inserted_battery, mob/user)
#define COMSIG_GLOB_HARVEST_ARTIFACT "!harvest_artifact"
// upon harvesting a slime's extract : (obj/item/slime_extract/newly_made_core)
#define COMSIG_GLOB_HARVEST_SLIME_CORE "!harvest_slime_core"
// base /datum/recipe/proc/make_food() : (obj/container, list/results)
#define COMSIG_GLOB_FOOD_PREPARED "!recipe_food_completed"
// base /datum/construction/proc/spawn_result() : (/obj/mecha/result_mech)
#define COMSIG_GLOB_MECH_CONSTRUCTED "!mecha_constructed"
// when trashpiles are successfully searched : (mob/living/user, list/searched_by)
#define COMSIG_GLOB_TRASHPILE_SEARCHED "!trash_pile_searched"
// upon forensics swap or sample kit forensics collection : (atom/target, mob/user)
#define COMSIG_GLOB_FORENSICS_COLLECTED "!performed_forensics_collection"
