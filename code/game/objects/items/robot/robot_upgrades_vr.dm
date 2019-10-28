/obj/item/borg/upgrade/language/action(var/mob/living/silicon/robot/R)
	if(..())
		R.add_language(LANGUAGE_BIRDSONG,		1)
		R.add_language(LANGUAGE_SAGARU,			1)
		R.add_language(LANGUAGE_CANILUNZT,		1)
		R.add_language(LANGUAGE_ECUREUILIAN,	1)
		R.add_language(LANGUAGE_DAEMON,			1)
		R.add_language(LANGUAGE_ENOCHIAN,		1)
		R.add_language(LANGUAGE_SLAVIC,		1)
		return 1
	else
		return 0

//Robot resizing module

/obj/item/borg/upgrade/sizeshift
	name = "robot size alteration module"
	desc = "Using technology similar to one used in sizeguns, allows cyborgs to adjust their own size as neccesary."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/sizeshift/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(/mob/living/proc/set_size in R.verbs)
		return 0

	R.verbs += /mob/living/proc/set_size
	return 1