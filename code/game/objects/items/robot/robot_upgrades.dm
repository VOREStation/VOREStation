// robot_upgrades.dm
// Contains various borg upgrades.

/obj/item/borg/upgrade
	name = "borg upgrade module."
	desc = "Protected by FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	///	Bitflags listing module compatibility. Used in the exosuit fabricator for creating sub-categories.
	var/list/module_flags = NONE
	var/locked = 0
	var/require_module = 0
	var/installed = 0

/obj/item/borg/upgrade/proc/action(var/mob/living/silicon/robot/R)
	if(R.stat == DEAD)
		to_chat(usr, "<span class='warning'>The [src] will not function on a deceased robot.</span>")
		return 1
	return 0

/obj/item/borg/upgrade/proc/generic_error(var/mob/living/silicon/robot/R, var/obj/item/borg/type)
	type = lowertext(initial(type.name))
	to_chat(R, "Upgrade mounting error! No suitable hardpoint for \the \"[type]\" detected!")
	to_chat(usr, "There's no mounting point for \the \"[type]\" module!")

/obj/item/borg/upgrade/proc/software_error(var/mob/living/silicon/robot/R, var/obj/item/borg/type)
	type = lowertext(initial(type.name))
	to_chat(R, "Upgrade installation error! Incompatibility with \the \"[type]\" detected!")
	to_chat(usr, "\The \"[type]\" upgrade is not compatibile!")

/*	######################################################################################################
	# Utility section. All reusable upgrades without lasting effects, like renaming, reset, etc. go here.#
	######################################################################################################*/

/obj/item/borg/upgrade/utility
	module_flags = BORG_UTILITY

/obj/item/borg/upgrade/utility/reset
	name = "robotic module reset board"
	desc = "Used to reset a cyborg's module. Destroys any higher than basic upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/utility/reset/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	R.module_reset()
	return 1

/obj/item/borg/upgrade/utility/rename
	name = "robot reclassification board"
	desc = "Used to rename a cyborg."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"
	var/heldname = "default name"

/obj/item/borg/upgrade/utility/rename/attack_self(mob/user as mob)
	var/new_name = sanitizeSafe(tgui_input_text(user, "Enter new robot name", "Robot Reclassification", heldname, MAX_NAME_LEN), MAX_NAME_LEN)
	if(new_name)
		heldname = new_name

/obj/item/borg/upgrade/utility/rename/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
	if(isshell(R)) return 0
	R.notify_ai(ROBOT_NOTIFICATION_NEW_NAME, R.name, heldname)
	R.name = heldname
	R.custom_name = heldname
	R.real_name = heldname

	return 1

/obj/item/borg/upgrade/utility/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"


/obj/item/borg/upgrade/utility/restart/action(var/mob/living/silicon/robot/R)
	if(R.stat == CONSCIOUS)
		return 0

	if(R.health < 0)
		to_chat(usr, "You have to repair the robot before using this module!")
		return 0

	if(!R.key)
		for(var/mob/observer/dead/ghost in player_list)
			if(ghost.mind && ghost.mind.current == R)
				R.key = ghost.key

	R.set_stat(CONSCIOUS)
	R.add_robot_verbs()
	dead_mob_list -= R
	living_mob_list |= R
	R.notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
	return 1

/*	###################################################################################
	# Basic section. All upgrades which effect the robot's variables directly go here.#
	###################################################################################*/

/obj/item/borg/upgrade/basic
	module_flags = BORG_BASIC

/obj/item/borg/upgrade/basic/vtec
	name = "robotic VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/basic/vtec/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.has_basic_upgrade(type))
		to_chat(R, "Actuator already running on overdrive mode!")
		to_chat(usr, "It'd be unwise to plug another vtec module in!")
		return 0

	R.verbs += /mob/living/silicon/robot/proc/toggle_vtec
	R.vtec_active = TRUE
	R.hud_used.toggle_vtec_control()
	return 1

/obj/item/borg/upgrade/basic/sizeshift
	name = "robot size alteration module"
	desc = "Using technology similar to one used in sizeguns, allows cyborgs to adjust their own size as neccesary."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/basic/sizeshift/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.has_basic_upgrade(type))
		to_chat(R, "Size alteration module already applied!")
		to_chat(usr, "There's no space for another size alteration module!")
		return 0

	R.verbs += /mob/living/proc/set_size
	return 1

/obj/item/borg/upgrade/basic/syndicate
	name = "scrambled equipment module"
	desc = "Unlocks new and often deadly module specific items of a robot"
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/basic/syndicate/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.has_basic_upgrade(type))
		to_chat(R, "Secret modules already unlocked!")
		to_chat(usr, "Plugging another scambled module would be useless!")
		return 0

	R.emag_items = 1
	return 1

/obj/item/borg/upgrade/basic/language
	name = "language module"
	desc = "Used to let cyborgs other than clerical or service speak a variety of languages."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"

/obj/item/borg/upgrade/basic/language/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.has_basic_upgrade(type))
		to_chat(R, "All possible languages already uploaded!")
		to_chat(usr, "The language database is up to date!")
		return 0

	R.add_language(LANGUAGE_SOL_COMMON, 	1)
	R.add_language(LANGUAGE_TRADEBAND, 		1)
	R.add_language(LANGUAGE_UNATHI,			1)
	R.add_language(LANGUAGE_SIIK, 			1)
	R.add_language(LANGUAGE_AKHANI, 		1)
	R.add_language(LANGUAGE_SKRELLIAN, 		1)
	R.add_language(LANGUAGE_GUTTER, 		1)
	R.add_language(LANGUAGE_SCHECHI, 		1)
	R.add_language(LANGUAGE_ROOTLOCAL, 		1)
	R.add_language(LANGUAGE_TERMINUS, 		1)
	R.add_language(LANGUAGE_ZADDAT, 		1)
	R.add_language(LANGUAGE_BIRDSONG,		1)
	R.add_language(LANGUAGE_SAGARU,			1)
	R.add_language(LANGUAGE_CANILUNZT,		1)
	R.add_language(LANGUAGE_ECUREUILIAN,	1)
	R.add_language(LANGUAGE_DAEMON,			1)
	R.add_language(LANGUAGE_ENOCHIAN,		1)
	R.add_language(LANGUAGE_DRUDAKAR, 		1)
	R.add_language(LANGUAGE_TAVAN,			1)
	R.add_language(LANGUAGE_SIGN, 			1)
	R.add_language(LANGUAGE_VOX, 			1)
	R.add_language(LANGUAGE_ALAI, 			1)
	R.add_language(LANGUAGE_PROMETHEAN,		1)
	R.add_language(LANGUAGE_GIBBERISH, 		1)
	R.add_language(LANGUAGE_VESPINAE, 		1)
	R.add_language(LANGUAGE_SPACER, 		1)
	R.add_language(LANGUAGE_MOUSE, 			1)
	R.add_language(LANGUAGE_ANIMAL, 		1)
	R.add_language(LANGUAGE_TEPPI, 			1)
	/* Admin Stuff
	R.add_language(LANGUAGE_CULT, 			1)
	R.add_language(LANGUAGE_SWARMBOT, 		1)
	R.add_language(LANGUAGE_MINBUS, 		1)
	R.add_language(LANGUAGE_EVENT1, 		1)
	*/
	/* We don't want telepathy, but want to mark it that it's not been oversighted
	R.add_language(LANGUAGE_CHANGELING,		1)
	R.add_language(LANGUAGE_ROOTGLOBAL,		1)
	R.add_language(LANGUAGE_SHADEKIN, 		1)
	*/

	return 1

/*	###########################################################################
	# Advanced section. All upgrades which effect the robot's modules go here.#
	###########################################################################*/

/obj/item/borg/upgrade/advanced
	module_flags = BORG_ADVANCED

/obj/item/borg/upgrade/advanced/bellysizeupgrade
	name = "robohound capacity expansion module"
	desc = "Used to double a robohound's belly capacity. This only affects total volume, and won't allow support of more than one patient in case of sleeper bellies. Can only be applied once."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/advanced/bellysizeupgrade/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	var/obj/T = R.has_upgrade_module(/obj/item/device/dogborg/sleeper)
	if(!T)
		to_chat(usr, "<span class='warning'>This robot has had its processor removed!</span>")
		return 0

	if(R.has_advanced_upgrade(type))
		to_chat(R, "Maximum capacity achieved for this hardpoint!")
		to_chat(usr, "There's no room for another capacity upgrade!")
		return 0

	var/obj/item/device/dogborg/sleeper/B = T
	var/X = B.max_item_count*2
	B.max_item_count = X	//I couldn't do T = maxitem*2 for some reason.
	to_chat(R, "Internal capacity doubled.")
	to_chat(usr, "Internal capacity doubled.")
	B.upgraded_capacity = TRUE
	return 1

/obj/item/borg/upgrade/advanced/jetpack
	name = "robot jetpack"
	desc = "A carbon dioxide jetpack suitable for low-gravity operations."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/advanced/jetpack/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.has_advanced_upgrade(type))
		generic_error(R, type)
		return 0

	R.module.modules += new/obj/item/weapon/tank/jetpack/carbondioxide(R.module)
	for(var/obj/item/weapon/tank/jetpack/carbondioxide in R.module.modules)
		R.internals = src
	return 1

/obj/item/borg/upgrade/advanced/advhealth
	name = "advanced health analyzer module"
	desc = "An Advanced Health Analyzer, optimized for borg mounting."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/advanced/advhealth/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.has_advanced_upgrade(type))
		generic_error(R, type)
		return 0

	R.module.modules += new/obj/item/device/healthanalyzer/advanced(R.module)
	return 1

//Robot size gun
/obj/item/borg/upgrade/advanced/sizegun
	name = "robot mounted size gun"
	desc = "A size gun adapted for installation in cyborgs, allows them to turn people pocket-sized among other uses. What could go wrong?"
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/advanced/sizegun/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.has_advanced_upgrade(type))
		generic_error(R, type)
		return 0

	R.module.modules += new/obj/item/weapon/gun/energy/sizegun/mounted(R.module)
	return 1

/*	##############################################################################
	# Restricted section. All upgrades which only work on specific modules go here.#
	##############################################################################*/

//adds the capability to ingest items to the sleeper modules as optional upgrade
/obj/item/borg/upgrade/restricted/bellycapupgrade
	name = "robohound capability expansion module"
	desc = "Used to enable a robohound's sleeper to ingest items. This only affects sleepers, and has no effect on compactor bellies. Can only be applied once."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = 1
	module_flags = BORG_MODULE_SECURITY | BORG_MODULE_MEDICAL | BORG_MODULE_COMBAT

/obj/item/borg/upgrade/restricted/bellycapupgrade/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.supports_upgrade(type))
		generic_error(R, type)
		return 0

	var/obj/T = R.has_upgrade_module(/obj/item/device/dogborg/sleeper)
	if(!T)
		to_chat(usr, "<span class='warning'>This robot has had its processor removed!</span>")
		return 0

	if(R.has_restricted_upgrade(type))
		to_chat(R, "Maximum capability achieved for this hardpoint!")
		to_chat(usr, "There's no room for another capability upgrade!")
		return 0

	var/obj/item/device/dogborg/sleeper/B = T
	var/X = B.max_item_count*2 //double the capacity from 1 to 2 to allow sleepers to store some items, at most 4 with both upgrades
	B.max_item_count = X	//I couldn't do T = maxitem*2 for some reason.
	to_chat(R, "Internal capability upgraded.")
	to_chat(usr, "Internal capability upgraded.")
	B.compactor = TRUE
	return 1

/obj/item/borg/upgrade/restricted/tasercooler
	name = "robotic Rapid Taser Cooling Module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_SECURITY
	require_module = 1


/obj/item/borg/upgrade/restricted/tasercooler/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.supports_upgrade(type))
		generic_error(R, type)
		return 0

	var/obj/T = R.has_upgrade_module(/obj/item/weapon/gun/energy/taser/mounted/cyborg)
	if(!T)
		to_chat(usr, "<span class='warning'>This robot has had its taser removed!</span>")
		return 0

	if(R.has_restricted_upgrade(type))
		to_chat(R, "Maximum cooling achieved for this hardpoint!")
		to_chat(usr, "There's no room for another cooling unit!")
		return 0

	var/obj/item/weapon/gun/energy/taser/mounted/cyborg/B = T
	B.recharge_time = max(2 , B.recharge_time - 4)
	return 1

//Advanced RPED
/obj/item/borg/upgrade/restricted/advrped
	name = "Advanced Rapid Part Exchange Device"
	desc = "An ARPED, now in borg size!"
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_SCIENCE
	require_module = 1

/obj/item/borg/upgrade/restricted/advrped/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.supports_upgrade(type))
		generic_error(R, type)
		return 0

	if(R.has_restricted_upgrade(type))
		generic_error(R, type)
		return 0

	R.module.modules += new/obj/item/weapon/storage/part_replacer/adv(R.module)
	return 1

//Diamond Drill
/obj/item/borg/upgrade/restricted/diamonddrill
	name = "Mounted Diamond Drill"
	desc = "An advanced drill, optimized for borg use."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_MINER
	require_module = 1

/obj/item/borg/upgrade/restricted/diamonddrill/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.supports_upgrade(type))
		generic_error(R, type)
		return 0

	if(R.has_restricted_upgrade(type))
		generic_error(R, type)
		return 0

	R.module.modules += new/obj/item/weapon/pickaxe/diamonddrill(R.module)
	return 1

//PKA
/obj/item/borg/upgrade/restricted/pka
	name = "Protokenetic Accelerator Upgrade"
	desc = "A borg mounted PKA Rifle for use in mining and wildlife defense."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_MINER
	require_module = 1

/obj/item/borg/upgrade/restricted/pka/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.supports_upgrade(type))
		generic_error(R, type)
		return 0

	if(R.has_restricted_upgrade(type))
		generic_error(R, type)
		return 0

	R.module.modules += new/obj/item/weapon/gun/energy/kinetic_accelerator/cyborg(R.module)
	return 1

/*	###############################################
	# Unsorted section. All cargo modules go here.#
	###############################################*/

/obj/item/borg/upgrade/no_prod
	var/hidden_from_scan = 0//use this for unproduceable modules you want to hide from scanning (e.g. event tools / admeme)

//cyborg foam dart gun
/obj/item/borg/upgrade/no_prod/toygun
	name = "Donk-Soft Cyborg Blaster module" //Cyborg Blaster is capitalized because it's the brand name
	desc = "A foam dart gun designed for mounting into cyborgs. It's Donk or Don't! DISCLAIMER: Donk-Soft bears no responsibility for incidents relating to cyborgs becoming too accustomed to shooting at crew. Installation of the Donk-Soft Cyborg Blaster must be performed only by a licensed roboticist."
	icon_state = "cyborg_upgrade5"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/no_prod/toygun/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.has_no_prod_upgrade(type))
		generic_error(R, type)
		return 0

	R.module.modules += new/obj/item/weapon/gun/projectile/cyborgtoy(R.module)
	return 1

/obj/item/borg/upgrade/no_prod/vision_xray
	name = "Robot x-ray vision module"
	desc = "Vision alterantion software to add x-ray sight capabilities."
	icon_state = "cyborg_upgrade5"
	item_state = "cyborg_upgrade"
	require_module = 1
	hidden_from_scan = 1

/obj/item/borg/upgrade/no_prod/vision_xray/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.has_no_prod_upgrade(type))
		software_error(R, type)
		return 0

	R.module.modules += new/obj/item/borg/sight/xray(R.module)
	return 1

/obj/item/borg/upgrade/no_prod/vision_thermal
	name = "Robot thermal vision module"
	desc = "Vision alterantion software to add thermal sight capabilities."
	icon_state = "cyborg_upgrade5"
	item_state = "cyborg_upgrade"
	require_module = 1
	hidden_from_scan = 1

/obj/item/borg/upgrade/no_prod/vision_thermal/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.has_no_prod_upgrade(type))
		software_error(R, type)
		return 0

	R.module.modules += new/obj/item/borg/sight/thermal(R.module)
	return 1

/obj/item/borg/upgrade/no_prod/vision_meson
	name = "Robot meson vision module"
	desc = "Vision alterantion software to add meson sight capabilities."
	icon_state = "cyborg_upgrade5"
	item_state = "cyborg_upgrade"
	require_module = 1
	hidden_from_scan = 1

/obj/item/borg/upgrade/no_prod/vision_meson/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.has_no_prod_upgrade(type))
		software_error(R, type)
		return 0

	R.module.modules += new/obj/item/borg/sight/meson(R.module)
	return 1

/obj/item/borg/upgrade/no_prod/vision_material
	name = "Robot material vision module"
	desc = "Vision alterantion software to add material sight capabilities."
	icon_state = "cyborg_upgrade5"
	item_state = "cyborg_upgrade"
	require_module = 1
	hidden_from_scan = 1

/obj/item/borg/upgrade/no_prod/vision_material/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.has_no_prod_upgrade(type))
		software_error(R, type)
		return 0

	R.module.modules += new/obj/item/borg/sight/material(R.module)
	return 1

/obj/item/borg/upgrade/no_prod/vision_anomalous
	name = "Robot anomalous vision module"
	desc = "Vision alterantion software to add anomalous sight capabilities."
	icon_state = "cyborg_upgrade5"
	item_state = "cyborg_upgrade"
	require_module = 1
	hidden_from_scan = 1

/obj/item/borg/upgrade/no_prod/vision_anomalous/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.has_no_prod_upgrade(type))
		software_error(R, type)
		return 0

	R.module.modules += new/obj/item/borg/sight/anomalous(R.module)
	return 1
