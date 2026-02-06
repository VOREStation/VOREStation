// robot_upgrades.dm
// Contains various borg upgrades.

/obj/item/borg/upgrade
	name = "borg upgrade module."
	desc = "Protected by FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	///	Bitflags listing module compatibility. Used in the exosuit fabricator for creating sub-categories.
	var/list/module_flags = NONE
	var/locked = FALSE
	var/require_module = FALSE
	var/installed = FALSE

/obj/item/borg/upgrade/proc/action(mob/user, mob/living/silicon/robot/R)
	if(R.stat == DEAD)
		to_chat(user, span_warning("The [src] will not function on a deceased robot."))
		return TRUE
	return FALSE

/obj/item/borg/upgrade/proc/generic_error(mob/user, mob/living/silicon/robot/R, obj/item/borg/type)
	type = lowertext(initial(type.name))
	to_chat(R, span_warning("Upgrade mounting error! No suitable hardpoint for \the \"[type]\" detected!"))
	to_chat(user, span_warning("There's no mounting point for \the \"[type]\" module!"))

/obj/item/borg/upgrade/proc/software_error(mob/user, mob/living/silicon/robot/R, obj/item/borg/type)
	type = lowertext(initial(type.name))
	to_chat(R, span_warning("Upgrade installation error! Incompatibility with \the \"[type]\" detected!"))
	to_chat(user, span_warning("\The \"[type]\" upgrade is not compatibile!"))

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
	require_module = TRUE

/obj/item/borg/upgrade/utility/reset/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	R.module_reset()
	return TRUE

/obj/item/borg/upgrade/utility/rename
	name = "robot reclassification board"
	desc = "Used to rename a cyborg."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"
	var/heldname = "default name"

/obj/item/borg/upgrade/utility/rename/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	var/new_name = tgui_input_text(user, "Enter new robot name", "Robot Reclassification", heldname, MAX_NAME_LEN)
	if(new_name)
		heldname = new_name

/obj/item/borg/upgrade/utility/rename/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE
	if(isshell(R)) return FALSE
	R.notify_ai(ROBOT_NOTIFICATION_NEW_NAME, R.name, heldname)
	R.name = heldname
	R.custom_name = heldname
	R.real_name = heldname

	return TRUE

/obj/item/borg/upgrade/utility/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"


/obj/item/borg/upgrade/utility/restart/action(mob/user, mob/living/silicon/robot/R)
	if(R.stat == CONSCIOUS)
		return FALSE

	if(R.health < 0)
		to_chat(user, span_warning("You have to repair the robot before using this module!"))
		return FALSE

	if(!R.key)
		for(var/mob/observer/dead/ghost in GLOB.player_list)
			if(ghost.mind && ghost.mind.current == R)
				R.key = ghost.key

	R.set_stat(CONSCIOUS)
	R.add_robot_verbs()
	GLOB.dead_mob_list -= R
	GLOB.living_mob_list |= R
	R.notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
	return TRUE

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
	require_module = TRUE

/obj/item/borg/upgrade/basic/vtec/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(R.has_basic_upgrade(type))
		to_chat(R,span_warning("Actuator already running on overdrive mode!"))
		to_chat(user, span_warning("It'd be unwise to plug another vtec module in!"))
		return FALSE

	add_verb(R, /mob/living/silicon/robot/proc/toggle_vtec)
	R.vtec_active = TRUE
	R.hud_used.toggle_vtec_control()
	to_chat(R, span_notice("Actuator overdrive enabled!"))
	return TRUE

/obj/item/borg/upgrade/basic/sizeshift
	name = "robot size alteration module"
	desc = "Using technology similar to one used in sizeguns, allows cyborgs to adjust their own size as neccesary."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/basic/sizeshift/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(R.has_basic_upgrade(type))
		to_chat(R, span_warning("Size alteration module already applied!"))
		to_chat(user, span_warning("There's no space for another size alteration module!"))
		return FALSE

	add_verb(R, /mob/living/proc/set_size)
	to_chat(R, span_notice("Size adjustments active!"))
	return TRUE

/obj/item/borg/upgrade/basic/syndicate
	name = "scrambled equipment module"
	desc = "Unlocks new and often deadly module specific items of a robot"
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/basic/syndicate/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(R.has_basic_upgrade(type))
		to_chat(R, span_warning("Secret modules already unlocked!"))
		to_chat(user, span_warning("Plugging another scambled module would be useless!"))
		return FALSE

	R.emag_items = TRUE
	R.robotact.update_static_data_for_all_viewers()
	return TRUE

/obj/item/borg/upgrade/basic/language
	name = "language module"
	desc = "Used to let cyborgs other than clerical or service speak a variety of languages."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"

/obj/item/borg/upgrade/basic/language/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(R.has_basic_upgrade(type))
		to_chat(R, span_warning("All possible languages already uploaded!"))
		to_chat(user, span_warning("The language database is up to date!"))
		return FALSE

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

	to_chat(R, span_notice("Language database updated!"))
	return TRUE

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
	require_module = TRUE

/obj/item/borg/upgrade/advanced/bellysizeupgrade/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	var/obj/T = R.has_upgrade_module(/obj/item/dogborg/sleeper)
	if(!T)
		to_chat(user, span_warning("This robot has had its processor removed!"))
		return FALSE

	if(R.has_advanced_upgrade(type))
		to_chat(R, span_warning("Maximum capacity achieved for this hardpoint!"))
		to_chat(user, span_warning("There's no room for another capacity upgrade!"))
		return FALSE

	var/obj/item/dogborg/sleeper/B = T
	var/X = B.max_item_count*2
	B.max_item_count = X	//I couldn't do T = maxitem*2 for some reason.
	to_chat(R, span_notice("Internal capacity doubled."))
	to_chat(user, span_notice("Internal capacity doubled."))
	B.upgraded_capacity = TRUE
	return TRUE

/obj/item/borg/upgrade/advanced/jetpack
	name = "robot jetpack"
	desc = "A carbon dioxide jetpack suitable for low-gravity operations."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/advanced/jetpack/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(R.has_advanced_upgrade(type))
		generic_error(user, R, type)
		return FALSE

	R.module.modules += new/obj/item/tank/jetpack/carbondioxide(R.module)
	for(var/obj/item/tank/jetpack/carbondioxide in R.module.modules)
		R.internals = src
	return TRUE

/obj/item/borg/upgrade/advanced/advhealth
	name = "advanced health analyzer module"
	desc = "An Advanced Health Analyzer, optimized for borg mounting."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/advanced/advhealth/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(R.has_advanced_upgrade(type))
		generic_error(user, R, type)
		return FALSE

	R.module.modules += new/obj/item/healthanalyzer/advanced(R.module)
	to_chat(R, span_notice("Advanced health analyzer initialized!"))
	return TRUE

//Robot size gun
/obj/item/borg/upgrade/advanced/sizegun
	name = "robot mounted size gun"
	desc = "A size gun adapted for installation in cyborgs, allows them to turn people pocket-sized among other uses. What could go wrong?"
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/advanced/sizegun/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(R.has_advanced_upgrade(type))
		generic_error(user, R, type)
		return FALSE

	R.module.modules += new/obj/item/gun/energy/sizegun/mounted(R.module)
	return TRUE

/*	##############################################################################
	# Restricted section. All upgrades which only work on specific modules go here.#
	##############################################################################*/

//adds the capability to ingest items to the sleeper modules as optional upgrade
/obj/item/borg/upgrade/restricted/bellycapupgrade
	name = "robohound capability expansion module"
	desc = "Used to enable a robohound's sleeper to ingest items. This only affects sleepers, and has no effect on compactor bellies. Can only be applied once."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = TRUE
	module_flags = BORG_MODULE_SECURITY | BORG_MODULE_MEDICAL | BORG_MODULE_COMBAT

/obj/item/borg/upgrade/restricted/bellycapupgrade/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(!R.supports_upgrade(type))
		generic_error(user, R, type)
		return FALSE

	var/obj/T = R.has_upgrade_module(/obj/item/dogborg/sleeper)
	if(!T)
		to_chat(user, span_warning("This robot has had its processor removed!"))
		return FALSE

	if(R.has_restricted_upgrade(type))
		to_chat(R, span_warning("Maximum capability achieved for this hardpoint!"))
		to_chat(user, span_warning("There's no room for another capability upgrade!"))
		return FALSE

	var/obj/item/dogborg/sleeper/B = T
	var/X = B.max_item_count*2 //double the capacity from 1 to 2 to allow sleepers to store some items, at most 4 with both upgrades
	B.max_item_count = X	//I couldn't do T = maxitem*2 for some reason.
	to_chat(R, span_notice("Internal capability upgraded."))
	to_chat(user, span_notice("Internal capability upgraded."))
	B.compactor = TRUE
	return TRUE

/obj/item/borg/upgrade/restricted/tasercooler
	name = "robotic Rapid Taser Cooling Module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_SECURITY
	require_module = TRUE


/obj/item/borg/upgrade/restricted/tasercooler/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(!R.supports_upgrade(type))
		generic_error(user, R, type)
		return FALSE

	var/obj/T = R.has_upgrade_module(/obj/item/gun/energy/robotic/taser)
	if(!T)
		to_chat(user, span_warning("This robot has had its taser removed!"))
		return FALSE

	if(R.has_restricted_upgrade(type))
		to_chat(R, span_warning("Maximum cooling achieved for this hardpoint!"))
		to_chat(user, span_warning("There's no room for another cooling unit!"))
		return FALSE

	var/obj/item/gun/energy/robotic/taser/B = T
	B.recharge_time = max(2 , B.recharge_time - 4)
	to_chat(R, span_notice("Taser cooling upgraded!"))
	return TRUE

//Advanced RPED
/obj/item/borg/upgrade/restricted/advrped
	name = "Advanced Rapid Part Exchange Device"
	desc = "An ARPED, now in borg size!"
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_SCIENCE
	require_module = TRUE

/obj/item/borg/upgrade/restricted/advrped/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(!R.supports_upgrade(type))
		generic_error(user, R, type)
		return FALSE

	if(R.has_restricted_upgrade(type))
		generic_error(user, R, type)
		return FALSE

	R.module.modules += new/obj/item/storage/part_replacer/adv(R.module)
	return TRUE

//Diamond Drill
/obj/item/borg/upgrade/restricted/diamonddrill
	name = "Mounted Diamond Drill"
	desc = "An advanced drill, optimized for borg use."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_MINER
	require_module = TRUE

/obj/item/borg/upgrade/restricted/diamonddrill/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(!R.supports_upgrade(type))
		generic_error(user, R, type)
		return FALSE

	if(R.has_restricted_upgrade(type))
		generic_error(user, R, type)
		return FALSE

	R.module.modules += new/obj/item/pickaxe/diamonddrill(R.module)
	return TRUE

//PKA
/obj/item/borg/upgrade/restricted/pka
	name = "Protokenetic Accelerator Upgrade"
	desc = "A borg mounted PKA Rifle for use in mining and wildlife defense."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_MINER
	require_module = TRUE

/obj/item/borg/upgrade/restricted/pka/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(!R.supports_upgrade(type))
		generic_error(user, R, type)
		return FALSE

	if(R.has_restricted_upgrade(type))
		generic_error(user, R, type)
		return FALSE

	R.module.modules += new/obj/item/gun/energy/kinetic_accelerator/cyborg(R.module)
	return TRUE

/obj/item/borg/upgrade/restricted/adv_scanner
	name = "robotic Ore Scanning Upgrade Module"
	desc = "Used to improve the integrated robot scanning module, allowing for larger more fine-tuned scan ranges."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_MINER
	require_module = TRUE

/obj/item/borg/upgrade/restricted/adv_scanner/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(!R.supports_upgrade(type))
		generic_error(user, R, type)
		return FALSE

	var/obj/target_module = R.has_upgrade_module(/obj/item/mining_scanner/robot)
	if(!target_module)
		to_chat(user, span_warning("This robot has had its scanner removed!"))
		return FALSE

	if(R.has_restricted_upgrade(type))
		to_chat(R, span_warning("Scanner was already upgraded!"))
		to_chat(user, span_warning("There's no room for another scanning upgrade!"))
		return FALSE

	var/obj/item/mining_scanner/robot/robot_scanner = target_module
	robot_scanner.upgrade()
	to_chat(R, span_notice("Mining scanner upgraded!"))
	return TRUE


/obj/item/borg/upgrade/restricted/adv_snatcher
	name = "robotic Sheet Capacity Module"
	desc = "Used to expand the robot sheet storage."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_MINER
	require_module = TRUE

/obj/item/borg/upgrade/restricted/adv_snatcher/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(!R.supports_upgrade(type))
		generic_error(user, R, type)
		return FALSE

	var/obj/target_module = R.has_upgrade_module(/obj/item/storage/bag/sheetsnatcher/borg)
	if(!target_module)
		to_chat(user, span_warning("This robot has had its sheet snatcher removed!"))
		return FALSE

	if(R.has_restricted_upgrade(type))
		to_chat(R, span_warning("Sheet capacity was already upgraded!"))
		to_chat(user, span_warning("There's no room for another sheet capacity upgrade!"))
		return FALSE

	var/obj/item/storage/bag/sheetsnatcher/borg/robot_snatcher = target_module
	robot_snatcher.upgrade()
	to_chat(R, span_notice("Sheet snatcher upgraded!"))
	return TRUE

/*	###############################################
	# Unsorted section. All cargo modules go here.#
	###############################################*/

/obj/item/borg/upgrade/no_prod
	var/hidden_from_scan = FALSE//use this for unproduceable modules you want to hide from scanning (e.g. event tools / admeme)

//cyborg foam dart gun
/obj/item/borg/upgrade/no_prod/toygun
	name = "Donk-Soft " + JOB_CYBORG + " Blaster module" //Cyborg Blaster is capitalized because it's the brand name
	desc = "A foam dart gun designed for mounting into cyborgs. It's Donk or Don't! DISCLAIMER: Donk-Soft bears no responsibility for incidents relating to cyborgs becoming too accustomed to shooting at crew. Installation of the Donk-Soft Cyborg Blaster must be performed only by a licensed roboticist."
	icon_state = "cyborg_upgrade5"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/no_prod/toygun/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(R.has_no_prod_upgrade(type))
		generic_error(user, R, type)
		return FALSE

	R.module.modules += new/obj/item/gun/projectile/cyborgtoy(R.module)
	return TRUE

/obj/item/borg/upgrade/no_prod/vision_xray
	name = "Robot x-ray vision module"
	desc = "Vision alterantion software to add x-ray sight capabilities."
	icon_state = "cyborg_upgrade5"
	item_state = "cyborg_upgrade"
	require_module = TRUE
	hidden_from_scan = TRUE

/obj/item/borg/upgrade/no_prod/vision_xray/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(R.has_no_prod_upgrade(type))
		software_error(user, R, type)
		return FALSE

	R.module.modules += new/obj/item/borg/sight/xray(R.module)
	return TRUE

/obj/item/borg/upgrade/no_prod/vision_thermal
	name = "Robot thermal vision module"
	desc = "Vision alterantion software to add thermal sight capabilities."
	icon_state = "cyborg_upgrade5"
	item_state = "cyborg_upgrade"
	require_module = TRUE
	hidden_from_scan = TRUE

/obj/item/borg/upgrade/no_prod/vision_thermal/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(R.has_no_prod_upgrade(type))
		software_error(user, R, type)
		return FALSE

	R.module.modules += new/obj/item/borg/sight/thermal(R.module)
	return TRUE

/obj/item/borg/upgrade/no_prod/vision_meson
	name = "Robot meson vision module"
	desc = "Vision alterantion software to add meson sight capabilities."
	icon_state = "cyborg_upgrade5"
	item_state = "cyborg_upgrade"
	require_module = TRUE
	hidden_from_scan = TRUE

/obj/item/borg/upgrade/no_prod/vision_meson/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(R.has_no_prod_upgrade(type))
		software_error(user, R, type)
		return FALSE

	R.module.modules += new/obj/item/borg/sight/meson(R.module)
	return TRUE

/obj/item/borg/upgrade/no_prod/vision_material
	name = "Robot material vision module"
	desc = "Vision alterantion software to add material sight capabilities."
	icon_state = "cyborg_upgrade5"
	item_state = "cyborg_upgrade"
	require_module = TRUE
	hidden_from_scan = TRUE

/obj/item/borg/upgrade/no_prod/vision_material/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(R.has_no_prod_upgrade(type))
		software_error(user, R, type)
		return FALSE

	R.module.modules += new/obj/item/borg/sight/material(R.module)
	return TRUE

/obj/item/borg/upgrade/no_prod/vision_anomalous
	name = "Robot anomalous vision module"
	desc = "Vision alterantion software to add anomalous sight capabilities."
	icon_state = "cyborg_upgrade5"
	item_state = "cyborg_upgrade"
	require_module = TRUE
	hidden_from_scan = TRUE

/obj/item/borg/upgrade/no_prod/vision_anomalous/action(mob/user, mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(R.has_no_prod_upgrade(type))
		software_error(user, R, type)
		return FALSE

	R.module.modules += new/obj/item/borg/sight/anomalous(R.module)
	return TRUE
