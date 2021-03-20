/datum/design/item/prosfab
	build_type = PROSFAB
	category = list("Misc")
	req_tech = list(TECH_MATERIAL = 1)

/datum/design/item/prosfab/pros
	category = list("Prosthetics")

// Make new external organs and make 'em robotish
/datum/design/item/prosfab/pros/Fabricate(var/newloc, var/fabricator)
	if(istype(fabricator, /obj/machinery/mecha_part_fabricator/pros))
		var/obj/machinery/mecha_part_fabricator/pros/prosfab = fabricator
		var/obj/item/organ/O = new build_path(newloc)
		if(prosfab.manufacturer)
			var/datum/robolimb/manf = all_robolimbs[prosfab.manufacturer]

			if(!(O.organ_tag in manf.parts))	// Make sure we're using an actually present icon.
				manf = all_robolimbs["Unbranded"]

			if(prosfab.species in manf.species_alternates)	// If the prosthetics fab is set to say, Unbranded, and species set to 'Tajaran', it will make the Taj variant of Unbranded, if it exists.
				manf = manf.species_alternates[prosfab.species]

			if(!prosfab.species || (prosfab.species in manf.species_cannot_use))	// Fabricator ensures the manufacturer can make parts for the species we're set to.
				O.species = GLOB.all_species["[manf.suggested_species]"]
			else
				O.species = GLOB.all_species[prosfab.species]
		else
			O.species = GLOB.all_species["Human"]
		O.robotize(prosfab.manufacturer)
		O.dna = new/datum/dna() //Uuughhhh... why do I have to do this?
		O.dna.ResetUI()
		O.dna.ResetSE()
		spawn(10) //Limbs love to flop around. Who am I to deny them?
			O.dir = 2
		return O
	return ..()

// Deep Magic for the torso since it needs to be a new mob
/datum/design/item/prosfab/pros/torso/Fabricate(var/newloc, var/fabricator)
	if(istype(fabricator, /obj/machinery/mecha_part_fabricator/pros))
		var/obj/machinery/mecha_part_fabricator/pros/prosfab = fabricator
		var/newspecies = "Human"

		var/datum/robolimb/manf = all_robolimbs[prosfab.manufacturer]

		if(manf)
			if(prosfab.species in manf.species_alternates)	// If the prosthetics fab is set to say, Unbranded, and species set to 'Tajaran', it will make the Taj variant of Unbranded, if it exists.
				manf = manf.species_alternates[prosfab.species]

			if(!prosfab.species || (prosfab.species in manf.species_cannot_use))
				newspecies = manf.suggested_species
			else
				newspecies = prosfab.species

		var/mob/living/carbon/human/H = new(newloc,newspecies)
		H.set_stat(DEAD)
		H.gender = gender
		for(var/obj/item/organ/external/EO in H.organs)
			if(EO.organ_tag == BP_TORSO || EO.organ_tag == BP_GROIN)
				continue //Roboticizing a torso does all the children and wastes time, do it later
			else
				EO.remove_rejuv()

		for(var/obj/item/organ/external/O in H.organs)
			O.species = GLOB.all_species[newspecies]

			if(!(O.organ_tag in manf.parts))	// Make sure we're using an actually present icon.
				manf = all_robolimbs["Unbranded"]

			O.robotize(manf.company)
			O.dna = new/datum/dna()
			O.dna.ResetUI()
			O.dna.ResetSE()

			// Skincolor weirdness.
			O.s_col[1] = 0
			O.s_col[2] = 0
			O.s_col[3] = 0

		// Resetting the UI does strange things for the skin of a non-human robot, which should be controlled by a whole different thing.
		H.r_skin = 0
		H.g_skin = 0
		H.b_skin = 0
		H.dna.ResetUIFrom(H)

		H.real_name = "Synthmorph #[rand(100,999)]"
		H.name = H.real_name
		H.dir = 2
		H.add_language(LANGUAGE_EAL)
		return H

//////////////////// Prosthetics ////////////////////
/datum/design/item/prosfab/pros/torso
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 30000, "glass" = 7500)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 3, TECH_DATA = 3)	//Saving the values just in case
	var/gender = MALE

/datum/design/item/prosfab/pros/torso/male
	name = "FBP Torso (M)"
	id = "pros_torso_m"
	build_path = /obj/item/organ/external/chest
	gender = MALE

/obj/item/organ/external/chest/f //To satisfy CI. :|

/datum/design/item/prosfab/pros/torso/female
	name = "FBP Torso (F)"
	id = "pros_torso_f"
	build_path = /obj/item/organ/external/chest/f
	gender = FEMALE

/datum/design/item/prosfab/pros/head
	name = "Prosthetic Head"
	id = "pros_head"
	build_path = /obj/item/organ/external/head
	time = 30
	materials = list(DEFAULT_WALL_MATERIAL = 18750, "glass" = 3750)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 3, TECH_DATA = 3)	//Saving the values just in case

/datum/design/item/prosfab/pros/l_arm
	name = "Prosthetic Left Arm"
	id = "pros_l_arm"
	build_path = /obj/item/organ/external/arm
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 10125)

/datum/design/item/prosfab/pros/l_hand
	name = "Prosthetic Left Hand"
	id = "pros_l_hand"
	build_path = /obj/item/organ/external/hand
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 3375)

/datum/design/item/prosfab/pros/r_arm
	name = "Prosthetic Right Arm"
	id = "pros_r_arm"
	build_path = /obj/item/organ/external/arm/right
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 10125)

/datum/design/item/prosfab/pros/r_hand
	name = "Prosthetic Right Hand"
	id = "pros_r_hand"
	build_path = /obj/item/organ/external/hand/right
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 3375)

/datum/design/item/prosfab/pros/l_leg
	name = "Prosthetic Left Leg"
	id = "pros_l_leg"
	build_path = /obj/item/organ/external/leg
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 8437)

/datum/design/item/prosfab/pros/l_foot
	name = "Prosthetic Left Foot"
	id = "pros_l_foot"
	build_path = /obj/item/organ/external/foot
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 2813)

/datum/design/item/prosfab/pros/r_leg
	name = "Prosthetic Right Leg"
	id = "pros_r_leg"
	build_path = /obj/item/organ/external/leg/right
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 8437)

/datum/design/item/prosfab/pros/r_foot
	name = "Prosthetic Right Foot"
	id = "pros_r_foot"
	build_path = /obj/item/organ/external/foot/right
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 2813)

/datum/design/item/prosfab/pros/internal
	category = list("Prosthetics, Internal")

/datum/design/item/prosfab/pros/internal/cell
	name = "Prosthetic Powercell"
	id = "pros_cell"
	build_path = /obj/item/organ/internal/cell
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 7500, "glass" = 3000)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/design/item/prosfab/pros/internal/eyes
	name = "Prosthetic Eyes"
	id = "pros_eyes"
	build_path = /obj/item/organ/internal/eyes/robot
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 5625, "glass" = 5625)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/design/item/prosfab/pros/internal/hydraulic
	name = "Hydraulic Hub"
	id = "pros_hydraulic"
	build_path = /obj/item/organ/internal/heart/machine
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 7500, MAT_PLASTIC = 3000)

/datum/design/item/prosfab/pros/internal/reagcycler
	name = "Reagent Cycler"
	id = "pros_reagcycler"
	build_path = /obj/item/organ/internal/stomach/machine
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 7500, MAT_PLASTIC = 3000)

/datum/design/item/prosfab/pros/internal/heatsink
	name = "Heatsink"
	id = "pros_heatsink"
	build_path = /obj/item/organ/internal/robotic/heatsink
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 7500, MAT_PLASTIC = 3000)

/datum/design/item/prosfab/pros/internal/diagnostic
	name = "Diagnostic Controller"
	id = "pros_diagnostic"
	build_path = /obj/item/organ/internal/robotic/diagnostic
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 7500, MAT_PLASTIC = 3000)

/datum/design/item/prosfab/pros/internal/heart
	name = "Prosthetic Heart"
	id = "pros_heart"
	build_path = /obj/item/organ/internal/heart
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 5625, "glass" = 1000)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/design/item/prosfab/pros/internal/lungs
	name = "Prosthetic Lungs"
	id = "pros_lung"
	build_path = /obj/item/organ/internal/lungs
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 5625, "glass" = 1000)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/design/item/prosfab/pros/internal/liver
	name = "Prosthetic Liver"
	id = "pros_liver"
	build_path = /obj/item/organ/internal/liver
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 5625, "glass" = 1000)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/design/item/prosfab/pros/internal/kidneys
	name = "Prosthetic Kidneys"
	id = "pros_kidney"
	build_path = /obj/item/organ/internal/kidneys
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 5625, "glass" = 1000)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/design/item/prosfab/pros/internal/spleen
	name = "Prosthetic Spleen"
	id = "pros_spleen"
	build_path = /obj/item/organ/internal/spleen
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 3000, MAT_GLASS = 750)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/design/item/prosfab/pros/internal/larynx
	name = "Prosthetic Larynx"
	id = "pros_larynx"
	build_path = /obj/item/organ/internal/voicebox
	time = 15
	materials = list(DEFAULT_WALL_MATERIAL = 2000, MAT_GLASS = 750, MAT_PLASTIC = 500)

//////////////////// Cyborg Parts ////////////////////
/datum/design/item/prosfab/cyborg
	category = list("Cyborg Parts")
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 3750)

/datum/design/item/prosfab/cyborg/exoskeleton
	name = "Robot Exoskeleton"
	id = "robot_exoskeleton"
	build_path = /obj/item/robot_parts/robot_suit
	time = 50
	materials = list(DEFAULT_WALL_MATERIAL = 37500)

/datum/design/item/prosfab/cyborg/torso
	name = "Robot Torso"
	id = "robot_torso"
	build_path = /obj/item/robot_parts/chest
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 30000)

/datum/design/item/prosfab/cyborg/head
	name = "Robot Head"
	id = "robot_head"
	build_path = /obj/item/robot_parts/head
	time = 35
	materials = list(DEFAULT_WALL_MATERIAL = 18750)

/datum/design/item/prosfab/cyborg/l_arm
	name = "Robot Left Arm"
	id = "robot_l_arm"
	build_path = /obj/item/robot_parts/l_arm
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 13500)

/datum/design/item/prosfab/cyborg/r_arm
	name = "Robot Right Arm"
	id = "robot_r_arm"
	build_path = /obj/item/robot_parts/r_arm
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 13500)

/datum/design/item/prosfab/cyborg/l_leg
	name = "Robot Left Leg"
	id = "robot_l_leg"
	build_path = /obj/item/robot_parts/l_leg
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 11250)

/datum/design/item/prosfab/cyborg/r_leg
	name = "Robot Right Leg"
	id = "robot_r_leg"
	build_path = /obj/item/robot_parts/r_leg
	time = 20
	materials = list(DEFAULT_WALL_MATERIAL = 11250)


//////////////////// Cyborg Internals ////////////////////
/datum/design/item/prosfab/cyborg/component
	category = list("Cyborg Internals")
	build_type = PROSFAB
	time = 12
	materials = list(DEFAULT_WALL_MATERIAL = 7500)

/datum/design/item/prosfab/cyborg/component/binary_communication_device
	name = "Binary Communication Device"
	id = "binary_communication_device"
	build_path = /obj/item/robot_parts/robot_component/binary_communication_device

/datum/design/item/prosfab/cyborg/component/radio
	name = "Radio"
	id = "radio"
	build_path = /obj/item/robot_parts/robot_component/radio

/datum/design/item/prosfab/cyborg/component/actuator
	name = "Actuator"
	id = "actuator"
	build_path = /obj/item/robot_parts/robot_component/actuator

/datum/design/item/prosfab/cyborg/component/diagnosis_unit
	name = "Diagnosis Unit"
	id = "diagnosis_unit"
	build_path = /obj/item/robot_parts/robot_component/diagnosis_unit

/datum/design/item/prosfab/cyborg/component/camera
	name = "Camera"
	id = "camera"
	build_path = /obj/item/robot_parts/robot_component/camera

/datum/design/item/prosfab/cyborg/component/armour
	name = "Armour Plating (Robot)"
	id = "armour"
	build_path = /obj/item/robot_parts/robot_component/armour

/datum/design/item/prosfab/cyborg/component/armour_heavy
	name = "Armour Plating (Platform)"
	id = "platform_armour"
	build_path = /obj/item/robot_parts/robot_component/armour_platform

/datum/design/item/prosfab/cyborg/component/ai_shell
	name = "AI Remote Interface"
	id = "mmi_ai_shell"
	build_path = /obj/item/device/mmi/inert/ai_remote

//////////////////// Cyborg Modules ////////////////////
/datum/design/item/prosfab/robot_upgrade
	category = list("Cyborg Modules")
	build_type = PROSFAB
	time = 12
	materials = list(DEFAULT_WALL_MATERIAL = 7500)

/datum/design/item/prosfab/robot_upgrade/rename
	name = "Rename Module"
	desc = "Used to rename a cyborg."
	id = "borg_rename_module"
	build_path = /obj/item/borg/upgrade/rename

/datum/design/item/prosfab/robot_upgrade/reset
	name = "Reset Module"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	id = "borg_reset_module"
	build_path = /obj/item/borg/upgrade/reset

/datum/design/item/prosfab/robot_upgrade/restart
	name = "Emergency Restart Module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	id = "borg_restart_module"
	materials = list(DEFAULT_WALL_MATERIAL = 45000, "glass" = 3750)
	build_path = /obj/item/borg/upgrade/restart

/datum/design/item/prosfab/robot_upgrade/vtec
	name = "VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	id = "borg_vtec_module"
	materials = list(DEFAULT_WALL_MATERIAL = 60000, "glass" = 4500, "gold" = 3750)
	build_path = /obj/item/borg/upgrade/vtec

/datum/design/item/prosfab/robot_upgrade/tasercooler
	name = "Rapid Taser Cooling Module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	id = "borg_taser_module"
	materials = list(DEFAULT_WALL_MATERIAL = 60000, "glass" = 4500, "gold" = 1500, "diamond" = 375)
	build_path = /obj/item/borg/upgrade/tasercooler

/datum/design/item/prosfab/robot_upgrade/jetpack
	name = "Jetpack Module"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	id = "borg_jetpack_module"
	materials = list(DEFAULT_WALL_MATERIAL = 7500, "phoron" = 11250, "uranium" = 15000)
	build_path = /obj/item/borg/upgrade/jetpack

/datum/design/item/prosfab/robot_upgrade/advhealth
	name = "Advanced Health Analyzer Module"
	desc = "An advanced health analyzer suitable for diagnosing more serious injuries."
	id = "borg_advhealth_module"
	materials = list(DEFAULT_WALL_MATERIAL = 10000, "glass" = 6500, "diamond" = 350)
	build_path = /obj/item/borg/upgrade/advhealth

/datum/design/item/prosfab/robot_upgrade/syndicate
	name = "Scrambled Equipment Module"
	desc = "Allows for the construction of lethal upgrades for cyborgs."
	id = "borg_syndicate_module"
	req_tech = list(TECH_COMBAT = 4, TECH_ILLEGAL = 3)
	materials = list(DEFAULT_WALL_MATERIAL = 7500, "glass" = 11250, "diamond" = 7500)
	build_path = /obj/item/borg/upgrade/syndicate

/datum/design/item/prosfab/robot_upgrade/language
	name = "Language Module"
	desc = "Used to let cyborgs other than clerical or service speak a variety of languages."
	id = "borg_language_module"
	req_tech = list(TECH_DATA = 6, TECH_MATERIAL = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 25000, "glass" = 3000, "gold" = 350)
	build_path = /obj/item/borg/upgrade/language

// Synthmorph Bags.

/datum/design/item/prosfab/synthmorphbag
	name = "Synthmorph Storage Bag"
	desc = "Used to store or slowly defragment an FBP."
	id = "misc_synth_bag"
	materials = list(DEFAULT_WALL_MATERIAL = 250, "glass" = 250, "plastic" = 2000)
	build_path = /obj/item/bodybag/cryobag/robobag

/datum/design/item/prosfab/badge_nt
	name = "NanoTrasen Tag"
	desc = "Used to identify an empty NanoTrasen FBP."
	id = "misc_synth_bag_tag_nt"
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "plastic" = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag

/datum/design/item/prosfab/badge_morph
	name = "Morpheus Tag"
	desc = "Used to identify an empty Morpheus FBP."
	id = "misc_synth_bag_tag_morph"
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "plastic" = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/morpheus

/datum/design/item/prosfab/badge_wardtaka
	name = "Ward-Takahashi Tag"
	desc = "Used to identify an empty Ward-Takahashi FBP."
	id = "misc_synth_bag_tag_wardtaka"
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "plastic" = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/wardtaka

/datum/design/item/prosfab/badge_zenghu
	name = "Zeng-Hu Tag"
	desc = "Used to identify an empty Zeng-Hu FBP."
	id = "misc_synth_bag_tag_zenghu"
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "plastic" = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/zenghu

/datum/design/item/prosfab/badge_gilthari
	name = "Gilthari Tag"
	desc = "Used to identify an empty Gilthari FBP."
	id = "misc_synth_bag_tag_gilthari"
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "gold" = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/gilthari
	req_tech = list(TECH_MATERIAL = 4, TECH_ILLEGAL = 2, TECH_PHORON = 2)

/datum/design/item/prosfab/badge_veymed
	name = "Vey-Medical Tag"
	desc = "Used to identify an empty Vey-Medical FBP."
	id = "misc_synth_bag_tag_veymed"
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "plastic" = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/veymed
	req_tech = list(TECH_MATERIAL = 3, TECH_ILLEGAL = 1, TECH_BIO = 4)

/datum/design/item/prosfab/badge_hephaestus
	name = "Hephaestus Tag"
	desc = "Used to identify an empty Hephaestus FBP."
	id = "misc_synth_bag_tag_heph"
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "plastic" = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/hephaestus

/datum/design/item/prosfab/badge_grayson
	name = "Grayson Tag"
	desc = "Used to identify an empty Grayson FBP."
	id = "misc_synth_bag_tag_grayson"
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "plastic" = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/grayson

/datum/design/item/prosfab/badge_xion
	name = "Xion Tag"
	desc = "Used to identify an empty Xion FBP."
	id = "misc_synth_bag_tag_xion"
	materials = list(DEFAULT_WALL_MATERIAL = 1000, "glass" = 500, "plastic" = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/xion

/datum/design/item/prosfab/badge_bishop
	name = "Bishop Tag"
	desc = "Used to identify an empty Bishop FBP."
	id = "misc_synth_bag_tag_bishop"
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 2000, "plastic" = 500)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/bishop
