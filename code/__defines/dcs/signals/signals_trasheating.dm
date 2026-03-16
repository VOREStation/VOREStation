// /obj/item signals for trasheater

/// item eaten by a mob, called by /obj/proc/after_trash_eaten(var/mob/living/user) : (obj/item/thing, mob/eater)
#define COMSIG_GLOB_ITEM_TRASH_EATEN "!trash_eaten_by_mob"

///called when an item is attempted to be eaten by a mob: (mob/living/user)
#define COMSIG_ITEM_TRASH_EATEN "item_trash_eaten"
	#define COMSIG_ITEM_TRASH_EAT_DENY  (1<<0)
	#define COMSIG_ITEM_TRASH_EAT_FORCED  (1<<1)
///called when a mob attempts to eat an item: (obj/item/thing)
#define COMSIG_MOB_TRASH_EATING "mob_trash_eating"
///called after the item is eaten: (mob/living/user)
#define COMSIG_ITEM_AFTER_TRASH_EAT "item_after_trash_eaten"
	#define COMSIG_ITEM_AFTER_TRASH_EAT_HIDE_MESSAGE  (1<<0)
///called after mob eats item: (obj/item/thing)
#define COMSIG_MOB_AFTER_TRASH_EATING "mob_after_trash_eating"
