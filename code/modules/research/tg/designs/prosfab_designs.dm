/datum/design_techweb/prosfab
	build_type = PROSFAB
	category = list(
		RND_CATEGORY_PROSFAB + RND_SUBCATEGORY_PROSFAB_MISC
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/prosfab/pros
	category = list(
		RND_CATEGORY_PROSFAB + RND_SUBCATEGORY_PROSFAB_EXTERNAL
	)

//////////////////// Prosthetics ////////////////////
/datum/design_techweb/prosfab/pros/torso
	materials = list(MAT_STEEL = 30000, MAT_GLASS = 7500)
	var/gender = MALE

/datum/design_techweb/prosfab/pros/torso/male
	name = "FBP Torso (M)"
	id = "pros_torso_m"
	build_path = /obj/item/organ/external/chest
	gender = MALE
	research_icon = 'icons/mob/human_races/robotic.dmi'
	research_icon_state = "torso_m"

/obj/item/organ/external/chest/f //To satisfy CI. :|

/datum/design_techweb/prosfab/pros/torso/female
	name = "FBP Torso (F)"
	id = "pros_torso_f"
	build_path = /obj/item/organ/external/chest/f
	gender = FEMALE
	research_icon = 'icons/mob/human_races/robotic.dmi'
	research_icon_state = "torso_f"

/datum/design_techweb/prosfab/pros/head
	name = "Prosthetic Head"
	id = "pros_head"
	build_path = /obj/item/organ/external/head
	materials = list(MAT_STEEL = 18750, MAT_GLASS = 3750)
	research_icon = 'icons/mob/human_races/robotic.dmi'
	research_icon_state = "head_m"

/datum/design_techweb/prosfab/pros/l_arm
	name = "Prosthetic Left Arm"
	id = "pros_l_arm"
	build_path = /obj/item/organ/external/arm
	materials = list(MAT_STEEL = 10125)
	research_icon = 'icons/mob/human_races/robotic.dmi'
	research_icon_state = "l_arm"

/datum/design_techweb/prosfab/pros/l_hand
	name = "Prosthetic Left Hand"
	id = "pros_l_hand"
	build_path = /obj/item/organ/external/hand
	materials = list(MAT_STEEL = 3375)
	research_icon = 'icons/mob/human_races/robotic.dmi'
	research_icon_state = "l_hand"

/datum/design_techweb/prosfab/pros/r_arm
	name = "Prosthetic Right Arm"
	id = "pros_r_arm"
	build_path = /obj/item/organ/external/arm/right
	materials = list(MAT_STEEL = 10125)
	research_icon = 'icons/mob/human_races/robotic.dmi'
	research_icon_state = "r_arm"

/datum/design_techweb/prosfab/pros/r_hand
	name = "Prosthetic Right Hand"
	id = "pros_r_hand"
	build_path = /obj/item/organ/external/hand/right
	materials = list(MAT_STEEL = 3375)
	research_icon = 'icons/mob/human_races/robotic.dmi'
	research_icon_state = "r_hand"

/datum/design_techweb/prosfab/pros/l_leg
	name = "Prosthetic Left Leg"
	id = "pros_l_leg"
	build_path = /obj/item/organ/external/leg
	materials = list(MAT_STEEL = 8437)
	research_icon = 'icons/mob/human_races/robotic.dmi'
	research_icon_state = "l_leg"

/datum/design_techweb/prosfab/pros/l_foot
	name = "Prosthetic Left Foot"
	id = "pros_l_foot"
	build_path = /obj/item/organ/external/foot
	materials = list(MAT_STEEL = 2813)
	research_icon = 'icons/mob/human_races/robotic.dmi'
	research_icon_state = "l_foot"

/datum/design_techweb/prosfab/pros/r_leg
	name = "Prosthetic Right Leg"
	id = "pros_r_leg"
	build_path = /obj/item/organ/external/leg/right
	materials = list(MAT_STEEL = 8437)
	research_icon = 'icons/mob/human_races/robotic.dmi'
	research_icon_state = "r_leg"

/datum/design_techweb/prosfab/pros/r_foot
	name = "Prosthetic Right Foot"
	id = "pros_r_foot"
	build_path = /obj/item/organ/external/foot/right
	materials = list(MAT_STEEL = 2813)
	research_icon = 'icons/mob/human_races/robotic.dmi'
	research_icon_state = "r_foot"

/datum/design_techweb/prosfab/pros/internal
	category = list(
		RND_CATEGORY_PROSFAB + RND_SUBCATEGORY_PROSFAB_INTERNAL
	)

/datum/design_techweb/prosfab/pros/internal/cell
	name = "Prosthetic Powercell"
	id = "pros_cell"
	build_path = /obj/item/organ/internal/cell
	materials = list(MAT_STEEL = 7500, MAT_GLASS = 3000)

/datum/design_techweb/prosfab/pros/internal/eyes
	name = "Prosthetic Eyes"
	id = "pros_eyes"
	build_path = /obj/item/organ/internal/eyes/robot
	materials = list(MAT_STEEL = 5625, MAT_GLASS = 5625)

/datum/design_techweb/prosfab/pros/internal/hydraulic
	name = "Hydraulic Hub"
	id = "pros_hydraulic"
	build_path = /obj/item/organ/internal/heart/machine
	materials = list(MAT_STEEL = 7500, MAT_PLASTIC = 3000)

/datum/design_techweb/prosfab/pros/internal/reagcycler
	name = "Reagent Cycler"
	id = "pros_reagcycler"
	build_path = /obj/item/organ/internal/stomach/machine
	materials = list(MAT_STEEL = 7500, MAT_PLASTIC = 3000)

/datum/design_techweb/prosfab/pros/internal/heatsink
	name = "Heatsink"
	id = "pros_heatsink"
	build_path = /obj/item/organ/internal/robotic/heatsink
	materials = list(MAT_STEEL = 7500, MAT_PLASTIC = 3000)

/datum/design_techweb/prosfab/pros/internal/diagnostic
	name = "Diagnostic Controller"
	id = "pros_diagnostic"
	build_path = /obj/item/organ/internal/robotic/diagnostic
	materials = list(MAT_STEEL = 7500, MAT_PLASTIC = 3000)

/datum/design_techweb/prosfab/pros/internal/heart
	name = "Prosthetic Heart"
	id = "pros_heart"
	build_path = /obj/item/organ/internal/heart
	materials = list(MAT_STEEL = 5625, MAT_GLASS = 1000)

/datum/design_techweb/prosfab/pros/internal/lungs
	name = "Prosthetic Lungs"
	id = "pros_lung"
	build_path = /obj/item/organ/internal/lungs
	materials = list(MAT_STEEL = 5625, MAT_GLASS = 1000)

/datum/design_techweb/prosfab/pros/internal/liver
	name = "Prosthetic Liver"
	id = "pros_liver"
	build_path = /obj/item/organ/internal/liver
	materials = list(MAT_STEEL = 5625, MAT_GLASS = 1000)

/datum/design_techweb/prosfab/pros/internal/kidneys
	name = "Prosthetic Kidneys"
	id = "pros_kidney"
	build_path = /obj/item/organ/internal/kidneys
	materials = list(MAT_STEEL = 5625, MAT_GLASS = 1000)

/datum/design_techweb/prosfab/pros/internal/spleen
	name = "Prosthetic Spleen"
	id = "pros_spleen"
	build_path = /obj/item/organ/internal/spleen
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 750)

/datum/design_techweb/prosfab/pros/internal/larynx
	name = "Prosthetic Larynx"
	id = "pros_larynx"
	build_path = /obj/item/organ/internal/voicebox
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 750, MAT_PLASTIC = 500)

/datum/design_techweb/prosfab/pros/internal/stomach
	name = "Prosthetic Stomach"
	id = "pros_stomach"
	build_path = /obj/item/organ/internal/stomach
	materials = list(MAT_STEEL = 5625, MAT_GLASS = 1000)

//////////////////// Cyborg Parts ////////////////////
/datum/design_techweb/prosfab/cyborg
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_COMPONENTS
	)
	materials = list(MAT_STEEL = 3750)

/datum/design_techweb/prosfab/cyborg/exoskeleton
	name = "Robot Exoskeleton"
	id = "robot_exoskeleton"
	build_path = /obj/item/robot_parts/robot_suit
	materials = list(MAT_STEEL = 37500)

/datum/design_techweb/prosfab/cyborg/torso
	name = "Robot Torso"
	id = "robot_torso"
	build_path = /obj/item/robot_parts/chest
	materials = list(MAT_STEEL = 30000)

/datum/design_techweb/prosfab/cyborg/head
	name = "Robot Head"
	id = "robot_head"
	build_path = /obj/item/robot_parts/head
	materials = list(MAT_STEEL = 18750)

/datum/design_techweb/prosfab/cyborg/l_arm
	name = "Robot Left Arm"
	id = "robot_l_arm"
	build_path = /obj/item/robot_parts/l_arm
	materials = list(MAT_STEEL = 13500)

/datum/design_techweb/prosfab/cyborg/r_arm
	name = "Robot Right Arm"
	id = "robot_r_arm"
	build_path = /obj/item/robot_parts/r_arm
	materials = list(MAT_STEEL = 13500)

/datum/design_techweb/prosfab/cyborg/l_leg
	name = "Robot Left Leg"
	id = "robot_l_leg"
	build_path = /obj/item/robot_parts/l_leg
	materials = list(MAT_STEEL = 11250)

/datum/design_techweb/prosfab/cyborg/r_leg
	name = "Robot Right Leg"
	id = "robot_r_leg"
	build_path = /obj/item/robot_parts/r_leg
	materials = list(MAT_STEEL = 11250)


//////////////////// Cyborg Internals ////////////////////
/datum/design_techweb/prosfab/cyborg/component
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG + RND_SUBCATEGORY_MECHFAB_CYBORG_INTERNALS
	)
	build_type = PROSFAB
	materials = list(MAT_STEEL = 7500)

/datum/design_techweb/prosfab/cyborg/component/binary_communication_device
	name = "Binary Communication Device"
	id = "binary_communication_device"
	build_path = /obj/item/robot_parts/robot_component/binary_communication_device

/datum/design_techweb/prosfab/cyborg/component/radio
	name = "Radio"
	id = "radio"
	build_path = /obj/item/robot_parts/robot_component/radio

/datum/design_techweb/prosfab/cyborg/component/actuator
	name = "Actuator"
	id = "actuator"
	build_path = /obj/item/robot_parts/robot_component/actuator

/datum/design_techweb/prosfab/cyborg/component/diagnosis_unit
	name = "Diagnosis Unit"
	id = "diagnosis_unit"
	build_path = /obj/item/robot_parts/robot_component/diagnosis_unit

/datum/design_techweb/prosfab/cyborg/component/camera
	name = "Camera"
	id = "camera"
	build_path = /obj/item/robot_parts/robot_component/camera

/datum/design_techweb/prosfab/cyborg/component/armour
	name = "Armour Plating (Robot)"
	id = "armour"
	build_path = /obj/item/robot_parts/robot_component/armour

/datum/design_techweb/prosfab/cyborg/component/armour_heavy
	name = "Armour Plating (Platform)"
	id = "platform_armour"
	build_path = /obj/item/robot_parts/robot_component/armour_platform

/datum/design_techweb/prosfab/cyborg/component/ai_shell
	name = "AI Remote Interface"
	id = "mmi_ai_shell"
	build_path = /obj/item/mmi/inert/ai_remote

//////////////////// Advanced Components ////////////////////
/datum/design_techweb/prosfab/cyborg/component/radio_upgraded
	name = "Improved Radio"
	id = "improved_radio"
	build_path = /obj/item/robot_parts/robot_component/radio/upgraded
	// req_tech = list(TECH_MAGNET = 7, TECH_MATERIAL = 5, TECH_PRECURSOR = 1)
	materials = list(MAT_STEEL = 10000, MAT_DIAMOND = 2000, MAT_PLASTEEL = 3000, MAT_GLASS = 6500, MAT_SILVER = 3000, MAT_MORPHIUM = 560, MAT_DURASTEEL = 800)

/datum/design_techweb/prosfab/cyborg/component/actuator_upgraded
	name = "Improved Actuator"
	id = "improved_actuator"
	build_path = /obj/item/robot_parts/robot_component/actuator/upgraded
	// req_tech = list(TECH_MAGNET = 7, TECH_MATERIAL = 5, TECH_PRECURSOR = 1)
	materials = list(MAT_STEEL = 10000, MAT_PLASTEEL = 2500, MAT_MORPHIUM = 500, MAT_DURASTEEL = 500)

/datum/design_techweb/prosfab/cyborg/component/diagnosis_unit_upgraded
	name = "Improved Diagnosis Unit"
	id = "improved_diagnosis_unit"
	build_path = /obj/item/robot_parts/robot_component/diagnosis_unit/upgraded
	// req_tech = list(TECH_MAGNET = 7, TECH_MATERIAL = 5, TECH_PRECURSOR = 1)
	materials = list(MAT_STEEL = 10000, MAT_DIAMOND = 2000, MAT_URANIUM = 4000, MAT_PLASTEEL = 1000, MAT_GLASS = 400, MAT_SILVER = 1000, MAT_MORPHIUM = 420, MAT_DURASTEEL = 600)

/datum/design_techweb/prosfab/cyborg/component/camera_upgraded
	name = "Improved Camera"
	id = "improved_camera"
	build_path = /obj/item/robot_parts/robot_component/camera/upgraded
	// req_tech = list(TECH_MAGNET = 7, TECH_MATERIAL = 5, TECH_PRECURSOR = 1)
	materials = list(MAT_STEEL = 10000, MAT_DIAMOND = 2000, MAT_PLASTEEL = 3000, MAT_GLASS = 6500, MAT_SILVER = 3000, MAT_MORPHIUM = 560, MAT_DURASTEEL = 800)

/datum/design_techweb/prosfab/cyborg/component/binary_communication_device/upgraded
	name = "Improved Binary Communication Device"
	id = "improved_binary_communication_device"
	build_path = /obj/item/robot_parts/robot_component/binary_communication_device/upgraded
	// req_tech = list(TECH_MAGNET = 7, TECH_MATERIAL = 5, TECH_PRECURSOR = 1)
	materials = list(MAT_STEEL = 10000, MAT_DIAMOND = 2000, MAT_PLASTEEL = 3000, MAT_GLASS = 6500, MAT_GOLD = 3000, MAT_DURASTEEL = 800)

/datum/design_techweb/prosfab/cyborg/component/armour_very_heavy
	name = "Armour Plating (Prototype)"
	id = "titan_armour"
	build_path = /obj/item/robot_parts/robot_component/armour/armour_titan
	// req_tech = list(TECH_MATERIAL = 9, TECH_PRECURSOR = 3)
	materials = list(MAT_STEEL = 12000, MAT_MORPHIUM = 3000, MAT_DURASTEEL = 5000)


//////////////////// Cyborg Modules ////////////////////
/datum/design_techweb/prosfab/robot_upgrade
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_UTILITY
	)
	build_type = PROSFAB
	materials = list(MAT_STEEL = 7500)

// Section for utility upgrades

/datum/design_techweb/prosfab/robot_upgrade/utility/rename
	name = "Rename Module"
	desc = "Used to rename a cyborg."
	id = "borg_rename_module"
	build_path = /obj/item/borg/upgrade/utility/rename

/datum/design_techweb/prosfab/robot_upgrade/utility/reset
	name = "Reset Module"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	id = "borg_reset_module"
	build_path = /obj/item/borg/upgrade/utility/reset

/datum/design_techweb/prosfab/robot_upgrade/utility/restart
	name = "Emergency Restart Module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	id = "borg_restart_module"
	materials = list(MAT_STEEL = 45000, MAT_GLASS = 3750)
	build_path = /obj/item/borg/upgrade/utility/restart

// Section for basic upgrades for all cyborgs
/datum/design_techweb/prosfab/robot_upgrade/basic
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_BASIC
	)

/datum/design_techweb/prosfab/robot_upgrade/basic/sizeshift
	name = "Size Alteration Module"
	id = "borg_sizeshift_module"
	// req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/borg/upgrade/basic/sizeshift

/datum/design_techweb/prosfab/robot_upgrade/basic/vtec
	name = "VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	id = "borg_vtec_module"
	materials = list(MAT_STEEL = 60000, MAT_GLASS = 4500, MAT_GOLD = 3750)
	build_path = /obj/item/borg/upgrade/basic/vtec

/datum/design_techweb/prosfab/robot_upgrade/basic/syndicate
	name = "Scrambled Equipment Module"
	desc = "Allows for the construction of lethal upgrades for cyborgs."
	id = "borg_syndicate_module"
	// req_tech = list(TECH_COMBAT = 4, TECH_ILLEGAL = 3)
	materials = list(MAT_STEEL = 7500, MAT_GLASS = 11250, MAT_DIAMOND = 7500)
	build_path = /obj/item/borg/upgrade/basic/syndicate

/datum/design_techweb/prosfab/robot_upgrade/basic/language
	name = "Language Module"
	desc = "Used to let cyborgs other than clerical or service speak a variety of languages."
	id = "borg_language_module"
	// req_tech = list(TECH_DATA = 6, TECH_MATERIAL = 6)
	materials = list(MAT_STEEL = 25000, MAT_GLASS = 3000, MAT_GOLD = 350)
	build_path = /obj/item/borg/upgrade/basic/language

// Section for advanced upgrades for all cyborgs
/datum/design_techweb/prosfab/robot_upgrade/advanced
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_ADVANCED
	)

/datum/design_techweb/prosfab/robot_upgrade/advanced/bellysizeupgrade
	name = "Robohound Capacity Expansion Module"
	id = "borg_hound_capacity_module"
	// req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/borg/upgrade/advanced/bellysizeupgrade

/datum/design_techweb/prosfab/robot_upgrade/advanced/sizegun
	name = "Size Gun Module"
	id = "borg_sizegun_module"
	// req_tech = list(TECH_COMBAT = 3, TECH_BLUESPACE = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 4000)
	build_path = /obj/item/borg/upgrade/advanced/sizegun

/datum/design_techweb/prosfab/robot_upgrade/advanced/jetpack
	name = "Jetpack Module"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	id = "borg_jetpack_module"
	materials = list(MAT_STEEL = 7500, MAT_PHORON = 11250, MAT_URANIUM = 15000)
	build_path = /obj/item/borg/upgrade/advanced/jetpack

/datum/design_techweb/prosfab/robot_upgrade/advanced/advhealth
	name = "Advanced Health Analyzer Module"
	desc = "An advanced health analyzer suitable for diagnosing more serious injuries."
	id = "borg_advhealth_module"
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 6500, MAT_DIAMOND = 350)
	build_path = /obj/item/borg/upgrade/advanced/advhealth

/*
	Some job related borg upgrade modules, adding useful items for puppers.
*/
/datum/design_techweb/prosfab/robot_upgrade/restricted
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_RESTRICTED
	)

/datum/design_techweb/prosfab/robot_upgrade/restricted/bellycapupgrade
	name = "Robohound Capability Expansion Module"
	id = "borg_hound_capability_module"
	// req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 6000)
	build_path = /obj/item/borg/upgrade/restricted/bellycapupgrade

/datum/design_techweb/prosfab/robot_upgrade/restricted/advrped
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_RESTRICTED + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_SCIENCE
	)
	name = "Advanced Rapid Part Exchange Device"
	desc = "Exactly the same as a standard Advanced RPED, but this one has mounting hardware for a Science Borg."
	id = "borg_advrped_module"
	// req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6)
	materials = list(MAT_STEEL = 30000, MAT_GLASS = 10000)
	build_path = /obj/item/borg/upgrade/restricted/advrped

/datum/design_techweb/prosfab/robot_upgrade/restricted/diamonddrill
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_RESTRICTED + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MINING
	)
	name = "Diamond Drill"
	desc = "A mining drill with a diamond tip, made for use by Mining Borgs."
	id = "borg_ddrill_module"
	// req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 5, TECH_ENGINEERING = 5)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/borg/upgrade/restricted/diamonddrill

/datum/design_techweb/prosfab/robot_upgrade/restricted/pka
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_RESTRICTED + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MINING
	)
	name = "Proto-Kinetic Accelerator"
	desc = "A mining weapon designed for clearing rocks and hostile wildlife. This model is equiped with a self upgrade system, allowing it to attach modules hands free."
	id = "borg_pka_module"
	// req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 5000, MAT_GLASS = 1000, MAT_URANIUM = 500, MAT_PLATINUM = 350)
	build_path = /obj/item/borg/upgrade/restricted/pka

/datum/design_techweb/prosfab/robot_upgrade/restricted/adv_scanner
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_RESTRICTED + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MINING
	)
	name = "Ore Scanning Upgrade"
	desc = "An upgrade module to improve the potency of the integrated ore scanner."
	id = "borg_adv_scanner_module"
	// req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 5, TECH_POWER = 4)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 4000, MAT_GOLD = 2000, MAT_VERDANTIUM = 1500, MAT_DIAMOND = 350)
	build_path = /obj/item/borg/upgrade/restricted/adv_scanner

/datum/design_techweb/prosfab/robot_upgrade/restricted/adv_snatcher
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_RESTRICTED + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_MINING
	)
	name = "Sheet Snatcher Upgrade"
	desc = "An upgrade module to expand the robot's sheet storage capacity."
	id = "borg_adv_snatcher_module"
	// req_tech = list(TECH_ENGINEERING = 7, TECH_MATERIAL = 8, TECH_POWER = 6)
	materials = list(MAT_STEEL = 12000, MAT_GLASS = 8000, MAT_PLASTEEL = 2000, MAT_DURASTEEL = 500, MAT_DIAMOND = 700)
	build_path = /obj/item/borg/upgrade/restricted/adv_snatcher

/datum/design_techweb/prosfab/robot_upgrade/restricted/tasercooler
	category = list(
		RND_CATEGORY_MECHFAB_CYBORG_MODULES + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_RESTRICTED + RND_SUBCATEGORY_MECHFAB_CYBORG_MODULES_SECURITY
	)
	name = "Rapid Taser Cooling Module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	id = "borg_taser_module"
	materials = list(MAT_STEEL = 60000, MAT_GLASS = 4500, MAT_GOLD = 1500, MAT_DIAMOND = 375)
	build_path = /obj/item/borg/upgrade/restricted/tasercooler

// Synthmorph Bags.
/datum/design_techweb/prosfab/synthmorphbag
	name = "Synthmorph Storage Bag"
	desc = "Used to store or slowly defragment an FBP."
	id = "misc_synth_bag"
	materials = list(MAT_STEEL = 250, MAT_GLASS = 250, MAT_PLASTIC = 2000)
	build_path = /obj/item/bodybag/cryobag/robobag

/datum/design_techweb/prosfab/badge_nt
	name = "NanoTrasen Tag"
	desc = "Used to identify an empty NanoTrasen FBP."
	id = "misc_synth_bag_tag_nt"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag

/datum/design_techweb/prosfab/badge_morph
	name = "Morpheus Tag"
	desc = "Used to identify an empty Morpheus FBP."
	id = "misc_synth_bag_tag_morph"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/morpheus

/datum/design_techweb/prosfab/badge_wardtaka
	name = "Ward-Takahashi Tag"
	desc = "Used to identify an empty Ward-Takahashi FBP."
	id = "misc_synth_bag_tag_wardtaka"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/wardtaka

/datum/design_techweb/prosfab/badge_zenghu
	name = "Zeng-Hu Tag"
	desc = "Used to identify an empty Zeng-Hu FBP."
	id = "misc_synth_bag_tag_zenghu"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/zenghu

/datum/design_techweb/prosfab/badge_gilthari
	name = "Gilthari Tag"
	desc = "Used to identify an empty Gilthari FBP."
	id = "misc_synth_bag_tag_gilthari"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_GOLD = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/gilthari
	// req_tech = list(TECH_MATERIAL = 4, TECH_ILLEGAL = 2, TECH_PHORON = 2)

/datum/design_techweb/prosfab/badge_veymed
	name = "Vey-Medical Tag"
	desc = "Used to identify an empty Vey-Medical FBP."
	id = "misc_synth_bag_tag_veymed"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/veymed
	// req_tech = list(TECH_MATERIAL = 3, TECH_ILLEGAL = 1, TECH_BIO = 4)

/datum/design_techweb/prosfab/badge_hephaestus
	name = "Hephaestus Tag"
	desc = "Used to identify an empty Hephaestus FBP."
	id = "misc_synth_bag_tag_heph"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/hephaestus

/datum/design_techweb/prosfab/badge_grayson
	name = "Grayson Tag"
	desc = "Used to identify an empty Grayson FBP."
	id = "misc_synth_bag_tag_grayson"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/grayson

/datum/design_techweb/prosfab/badge_xion
	name = "Xion Tag"
	desc = "Used to identify an empty Xion FBP."
	id = "misc_synth_bag_tag_xion"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/xion

/datum/design_techweb/prosfab/badge_bishop
	name = "Bishop Tag"
	desc = "Used to identify an empty Bishop FBP."
	id = "misc_synth_bag_tag_bishop"
	materials = list(MAT_STEEL = 500, MAT_GLASS = 2000, MAT_PLASTIC = 500)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/bishop

// Replacement protean bits

/datum/design_techweb/prosfab/orchestrator
	name = "Protean Orchestrator"
	id = "prot_orch"
	build_path = /obj/item/organ/internal/nano/orchestrator
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000, MAT_SILVER = 2000, MAT_GOLD = 2000)
	// req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)

/datum/design_techweb/prosfab/refactory
	name = "Protean Refactory"
	id = "prot_refact"
	build_path = /obj/item/organ/internal/nano/refactory
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000, MAT_SILVER = 2000, MAT_GOLD = 2000)
	// req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)

///// pAI parts!!!

//////////////////// Cyborg Parts ////////////////////
/datum/design_techweb/prosfab/paiparts
	category = list(
		RND_CATEGORY_PROSFAB_PAI
	)
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000)

/datum/design_techweb/prosfab/paiparts/cell
	name = "pAI Cell"
	id = "pai_cell"
	build_path = /obj/item/paiparts/cell

/datum/design_techweb/prosfab/paiparts/processor
	name = "pAI Processor"
	id = "pai_processor"
	build_path = /obj/item/paiparts/processor

/datum/design_techweb/prosfab/paiparts/board
	name = "pAI Board"
	id = "pai_board"
	build_path = /obj/item/paiparts/board

/datum/design_techweb/prosfab/paiparts/capacitor
	name = "pAI capacitor"
	id = "pai_capacitor"
	build_path = /obj/item/paiparts/capacitor

/datum/design_techweb/prosfab/paiparts/projector
	name = "pAI Projector"
	id = "pai_projector"
	build_path = /obj/item/paiparts/projector

/datum/design_techweb/prosfab/paiparts/emitter
	name = "pAI Emitter"
	id = "pai_emitter"
	build_path = /obj/item/paiparts/emitter

/datum/design_techweb/prosfab/paiparts/speech_synthesizer
	name = "pAI Speech Synthesizer"
	id = "pai_speech_synthesizer"
	build_path = /obj/item/paiparts/speech_synthesizer

/datum/design_techweb/disk
	build_type = IMPRINTER
	materials = list(MAT_PLASTIC = 2000, MAT_GLASS = 1000)
	lathe_time_factor = 1.5
	category = list(
		RND_CATEGORY_PROSFAB
	)
	departmental_flags = DEPARTMENT_BITFLAG_SCIENCE

/datum/design_techweb/disk/New()
	. = ..()
	if(build_path)
		var/obj/item/disk/D = build_path
		if(istype(D, /obj/item/disk/species))
			name = "Species Prosthetic design ([name])"
		else if(istype(D, /obj/item/disk/limb))
			name = "Transtellar Prosthetic design ([name])"
		else
			name = "Disk design ([name])"

/datum/design_techweb/disk/skrellprint
	name = SPECIES_SKRELL
	id = "prosthetic_skrell"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/disk/species/skrell

/datum/design_techweb/disk/tajprint
	name = SPECIES_TAJARAN
	id = "prosthetic_tajaran"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 3)
	build_path = /obj/item/disk/species/tajaran

/datum/design_techweb/disk/unathiprint
	name = SPECIES_UNATHI
	id = "prosthetic_unathi"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 4)
	build_path = /obj/item/disk/species/unathi

/datum/design_techweb/disk/teshariprint
	name = SPECIES_TESHARI
	id = "prosthetic_teshari"
	// req_tech = list(TECH_DATA = 3, TECH_BIO = 4)
	build_path = /obj/item/disk/species/teshari
