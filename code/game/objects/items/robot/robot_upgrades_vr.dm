/obj/item/borg/upgrade/language/action(var/mob/living/silicon/robot/R)
	if(..())
		R.add_language(LANGUAGE_BIRDSONG,		1)
		R.add_language(LANGUAGE_SAGARU,			1)
		R.add_language(LANGUAGE_CANILUNZT,		1)
		R.add_language(LANGUAGE_ECUREUILIAN,	1)
		R.add_language(LANGUAGE_DAEMON,			1)
		R.add_language(LANGUAGE_ENOCHIAN,		1)
		R.add_language(LANGUAGE_SLAVIC,			1)
		R.add_language(LANGUAGE_DRUDAKAR, 		1)
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

/obj/item/borg/upgrade/bellysizeupgrade
	name = "robohound capacity expansion module"
	desc = "Used to double a robohound's belly capacity. This only affects total volume, and won't allow support of more than one patient in case of sleeper bellies. Can only be applied once."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/bellysizeupgrade/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.module || R.dogborg == FALSE)//can work
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module! Try upgrading another model.")
		return 0

	var/obj/item/device/dogborg/sleeper/T = locate() in R.module
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		to_chat(usr, "<span class='warning'>This robot has had its processor removed!</span>")
		return 0

	if(T.upgraded_capacity)// == TRUE
		to_chat(R, "Maximum capacity achieved for this hardpoint!")
		to_chat(usr, "There's no room for another capacity upgrade!")
		return 0
	else
		var/X = T.max_item_count*2
		T.max_item_count = X	//I couldn't do T = maxitem*2 for some reason.
		to_chat(R, "Internal capacity doubled.")
		to_chat(usr, "Internal capacity doubled.")
		T.upgraded_capacity = TRUE
	return 1
