/obj/item/borg/upgrade/language/action(var/mob/living/silicon/robot/R)
	if(..())
		R.add_language(LANGUAGE_BIRDSONG,		1)
		R.add_language(LANGUAGE_SAGARU,			1)
		R.add_language(LANGUAGE_CANILUNZT,		1)
		R.add_language(LANGUAGE_ECUREUILIAN,	1)
		R.add_language(LANGUAGE_DAEMON,			1)
		R.add_language(LANGUAGE_ENOCHIAN,		1)
		R.add_language(LANGUAGE_DRUDAKAR, 		1)
		R.add_language(LANGUAGE_TAVAN,			1)
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

//Robot size gun
/obj/item/borg/upgrade/sizegun
	name = "robot mounted size gun"
	desc = "A size gun adapted for installation in cyborgs, allows them to turn people pocket-sized among other uses. What could go wrong?"
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/sizegun/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	var/obj/item/weapon/gun/energy/sizegun/mounted/T = locate() in R.module
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		R.module.modules += new/obj/item/weapon/gun/energy/sizegun/mounted(R.module)
		return 1
	if(T)
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0

/obj/item/borg/upgrade/bellysizeupgrade
	name = "robohound capacity expansion module"
	desc = "Used to double a robohound's belly capacity. This only affects total volume, and won't allow support of more than one patient in case of sleeper bellies. Can only be applied once."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/bellysizeupgrade/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.module)//can work
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
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

//adds the capability to ingest items to the sleeper modules as optional upgrade
/obj/item/borg/upgrade/bellycapupgrade
	name = "robohound capability expansion module"
	desc = "Used to enable a robohound's sleeper to ingest items. This only affects sleepers, and has no effect on compactor bellies. Can only be applied once."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/bellycapupgrade/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.module)//can work
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0

	var/obj/item/device/dogborg/sleeper/T = locate() in R.module
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		to_chat(usr, "<span class='warning'>This robot has had its processor removed!</span>")
		return 0

	if(T.compactor)// == TRUE, the belly unit is a compactor and no sleeper unit already
		to_chat(R, "Maximum capability achieved for this hardpoint!")
		to_chat(usr, "There's no room for another capability upgrade!")
		return 0
	else
		var/X = T.max_item_count*2 //double the capacity from 1 to 2 to allow sleepers to store some items, at most 4 with both upgrades
		T.max_item_count = X	//I couldn't do T = maxitem*2 for some reason.
		to_chat(R, "Internal capability upgraded.")
		to_chat(usr, "Internal capability upgraded.")
		T.compactor = TRUE
	return 1

//Advanced RPED
/obj/item/borg/upgrade/advrped
	name = "Advanced Rapid Part Exchange Device"
	desc = "An ARPED, now in borg size!"
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_SCIENCE
	require_module = 1

/obj/item/borg/upgrade/advrped/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	var/obj/item/weapon/storage/part_replacer/adv/T = locate() in R.module

	if(!R.module || !(type in R.module.supported_upgrades))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		R.module.modules += new/obj/item/weapon/storage/part_replacer/adv(R.module)
		return 1
	if(T)
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0

//Diamond Drill
/obj/item/borg/upgrade/diamonddrill
	name = "Mounted Diamond Drill"
	desc = "An advanced drill, optimized for borg use."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_MINER
	require_module = 1

/obj/item/borg/upgrade/diamonddrill/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	var/obj/item/weapon/pickaxe/diamonddrill/T = locate() in R.module

	if(!R.module || !(type in R.module.supported_upgrades))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		R.module.modules += new/obj/item/weapon/pickaxe/diamonddrill(R.module)
		return 1
	if(T)
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0

//PKA
/obj/item/borg/upgrade/pka
	name = "Protokenetic Accelerator Upgrade"
	desc = "A borg mounted PKA Rifle for use in mining and wildlife defense."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_MINER
	require_module = 1

/obj/item/borg/upgrade/pka/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	var/obj/item/weapon/gun/energy/kinetic_accelerator/cyborg/T = locate() in R.module

	if(!R.module || !(type in R.module.supported_upgrades))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		R.module.modules += new/obj/item/weapon/gun/energy/kinetic_accelerator/cyborg(R.module)
		return 1
	if(T)
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0

//cyborg foam dart gun
/obj/item/borg/upgrade/toygun
	name = "Donk-Soft Cyborg Blaster module" //Cyborg Blaster is capitalized because it's the brand name
	desc = "A foam dart gun designed for mounting into cyborgs. It's Donk or Don't! DISCLAIMER: Donk-Soft bears no responsibility for incidents relating to cyborgs becoming too accustomed to shooting at crew. Installation of the Donk-Soft Cyborg Blaster must be performed only by a licensed roboticist."
	icon_state = "cyborg_upgrade5"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/toygun/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	var/obj/item/weapon/gun/projectile/cyborgtoy/T = locate() in R.module
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		R.module.modules += new/obj/item/weapon/gun/projectile/cyborgtoy(R.module)
		return 1
	if(T)
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return 0
