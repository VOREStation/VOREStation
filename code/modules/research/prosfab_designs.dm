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
	materials = list(MAT_STEEL = 30000, MAT_GLASS = 7500)
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
	materials = list(MAT_STEEL = 18750, MAT_GLASS = 3750)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 3, TECH_DATA = 3)	//Saving the values just in case

/datum/design/item/prosfab/pros/l_arm
	name = "Prosthetic Left Arm"
	id = "pros_l_arm"
	build_path = /obj/item/organ/external/arm
	time = 20
	materials = list(MAT_STEEL = 10125)

/datum/design/item/prosfab/pros/l_hand
	name = "Prosthetic Left Hand"
	id = "pros_l_hand"
	build_path = /obj/item/organ/external/hand
	time = 15
	materials = list(MAT_STEEL = 3375)

/datum/design/item/prosfab/pros/r_arm
	name = "Prosthetic Right Arm"
	id = "pros_r_arm"
	build_path = /obj/item/organ/external/arm/right
	time = 20
	materials = list(MAT_STEEL = 10125)

/datum/design/item/prosfab/pros/r_hand
	name = "Prosthetic Right Hand"
	id = "pros_r_hand"
	build_path = /obj/item/organ/external/hand/right
	time = 15
	materials = list(MAT_STEEL = 3375)

/datum/design/item/prosfab/pros/l_leg
	name = "Prosthetic Left Leg"
	id = "pros_l_leg"
	build_path = /obj/item/organ/external/leg
	time = 20
	materials = list(MAT_STEEL = 8437)

/datum/design/item/prosfab/pros/l_foot
	name = "Prosthetic Left Foot"
	id = "pros_l_foot"
	build_path = /obj/item/organ/external/foot
	time = 15
	materials = list(MAT_STEEL = 2813)

/datum/design/item/prosfab/pros/r_leg
	name = "Prosthetic Right Leg"
	id = "pros_r_leg"
	build_path = /obj/item/organ/external/leg/right
	time = 20
	materials = list(MAT_STEEL = 8437)

/datum/design/item/prosfab/pros/r_foot
	name = "Prosthetic Right Foot"
	id = "pros_r_foot"
	build_path = /obj/item/organ/external/foot/right
	time = 15
	materials = list(MAT_STEEL = 2813)

/datum/design/item/prosfab/pros/internal
	category = list("Prosthetics, Internal")

/datum/design/item/prosfab/pros/internal/cell
	name = "Prosthetic Powercell"
	id = "pros_cell"
	build_path = /obj/item/organ/internal/cell
	time = 15
	materials = list(MAT_STEEL = 7500, MAT_GLASS = 3000)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/design/item/prosfab/pros/internal/eyes
	name = "Prosthetic Eyes"
	id = "pros_eyes"
	build_path = /obj/item/organ/internal/eyes/robot
	time = 15
	materials = list(MAT_STEEL = 5625, MAT_GLASS = 5625)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/design/item/prosfab/pros/internal/hydraulic
	name = "Hydraulic Hub"
	id = "pros_hydraulic"
	build_path = /obj/item/organ/internal/heart/machine
	time = 15
	materials = list(MAT_STEEL = 7500, MAT_PLASTIC = 3000)

/datum/design/item/prosfab/pros/internal/reagcycler
	name = "Reagent Cycler"
	id = "pros_reagcycler"
	build_path = /obj/item/organ/internal/stomach/machine
	time = 15
	materials = list(MAT_STEEL = 7500, MAT_PLASTIC = 3000)

/datum/design/item/prosfab/pros/internal/heatsink
	name = "Heatsink"
	id = "pros_heatsink"
	build_path = /obj/item/organ/internal/robotic/heatsink
	time = 15
	materials = list(MAT_STEEL = 7500, MAT_PLASTIC = 3000)

/datum/design/item/prosfab/pros/internal/diagnostic
	name = "Diagnostic Controller"
	id = "pros_diagnostic"
	build_path = /obj/item/organ/internal/robotic/diagnostic
	time = 15
	materials = list(MAT_STEEL = 7500, MAT_PLASTIC = 3000)

/datum/design/item/prosfab/pros/internal/heart
	name = "Prosthetic Heart"
	id = "pros_heart"
	build_path = /obj/item/organ/internal/heart
	time = 15
	materials = list(MAT_STEEL = 5625, MAT_GLASS = 1000)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/design/item/prosfab/pros/internal/lungs
	name = "Prosthetic Lungs"
	id = "pros_lung"
	build_path = /obj/item/organ/internal/lungs
	time = 15
	materials = list(MAT_STEEL = 5625, MAT_GLASS = 1000)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/design/item/prosfab/pros/internal/liver
	name = "Prosthetic Liver"
	id = "pros_liver"
	build_path = /obj/item/organ/internal/liver
	time = 15
	materials = list(MAT_STEEL = 5625, MAT_GLASS = 1000)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/design/item/prosfab/pros/internal/kidneys
	name = "Prosthetic Kidneys"
	id = "pros_kidney"
	build_path = /obj/item/organ/internal/kidneys
	time = 15
	materials = list(MAT_STEEL = 5625, MAT_GLASS = 1000)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/design/item/prosfab/pros/internal/spleen
	name = "Prosthetic Spleen"
	id = "pros_spleen"
	build_path = /obj/item/organ/internal/spleen
	time = 15
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 750)
//	req_tech = list(TECH_ENGINEERING = 2, TECH_MATERIAL = 2)

/datum/design/item/prosfab/pros/internal/larynx
	name = "Prosthetic Larynx"
	id = "pros_larynx"
	build_path = /obj/item/organ/internal/voicebox
	time = 15
	materials = list(MAT_STEEL = 2000, MAT_GLASS = 750, MAT_PLASTIC = 500)

/datum/design/item/prosfab/pros/internal/stomach
	name = "Prosthetic Stomach"
	id = "pros_stomach"
	build_path = /obj/item/organ/internal/stomach
	time = 15
	materials = list(MAT_STEEL = 5625, MAT_GLASS = 1000)

//////////////////// Cyborg Parts ////////////////////
/datum/design/item/prosfab/cyborg
	category = list("Cyborg Parts")
	time = 20
	materials = list(MAT_STEEL = 3750)

/datum/design/item/prosfab/cyborg/exoskeleton
	name = "Robot Exoskeleton"
	id = "robot_exoskeleton"
	build_path = /obj/item/robot_parts/robot_suit
	time = 50
	materials = list(MAT_STEEL = 37500)

/datum/design/item/prosfab/cyborg/torso
	name = "Robot Torso"
	id = "robot_torso"
	build_path = /obj/item/robot_parts/chest
	time = 35
	materials = list(MAT_STEEL = 30000)

/datum/design/item/prosfab/cyborg/head
	name = "Robot Head"
	id = "robot_head"
	build_path = /obj/item/robot_parts/head
	time = 35
	materials = list(MAT_STEEL = 18750)

/datum/design/item/prosfab/cyborg/l_arm
	name = "Robot Left Arm"
	id = "robot_l_arm"
	build_path = /obj/item/robot_parts/l_arm
	time = 20
	materials = list(MAT_STEEL = 13500)

/datum/design/item/prosfab/cyborg/r_arm
	name = "Robot Right Arm"
	id = "robot_r_arm"
	build_path = /obj/item/robot_parts/r_arm
	time = 20
	materials = list(MAT_STEEL = 13500)

/datum/design/item/prosfab/cyborg/l_leg
	name = "Robot Left Leg"
	id = "robot_l_leg"
	build_path = /obj/item/robot_parts/l_leg
	time = 20
	materials = list(MAT_STEEL = 11250)

/datum/design/item/prosfab/cyborg/r_leg
	name = "Robot Right Leg"
	id = "robot_r_leg"
	build_path = /obj/item/robot_parts/r_leg
	time = 20
	materials = list(MAT_STEEL = 11250)


//////////////////// Cyborg Internals ////////////////////
/datum/design/item/prosfab/cyborg/component
	category = list("Cyborg Internals")
	build_type = PROSFAB
	time = 12
	materials = list(MAT_STEEL = 7500)

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
	materials = list(MAT_STEEL = 7500)

// Section for utility upgrades

/datum/design/item/prosfab/robot_upgrade/utility/rename
	name = "Rename Module"
	desc = "Used to rename a cyborg."
	id = "borg_rename_module"
	build_path = /obj/item/borg/upgrade/utility/rename

/datum/design/item/prosfab/robot_upgrade/utility/reset
	name = "Reset Module"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	id = "borg_reset_module"
	build_path = /obj/item/borg/upgrade/utility/reset

/datum/design/item/prosfab/robot_upgrade/utility/restart
	name = "Emergency Restart Module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	id = "borg_restart_module"
	materials = list(MAT_STEEL = 45000, MAT_GLASS = 3750)
	build_path = /obj/item/borg/upgrade/utility/restart

// Section for basic upgrades for all cyborgs

/datum/design/item/prosfab/robot_upgrade/basic/sizeshift
	name = "Size Alteration Module"
	id = "borg_sizeshift_module"
	req_tech = list(TECH_BLUESPACE = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/borg/upgrade/basic/sizeshift

/datum/design/item/prosfab/robot_upgrade/basic/vtec
	name = "VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	id = "borg_vtec_module"
	materials = list(MAT_STEEL = 60000, MAT_GLASS = 4500, MAT_GOLD = 3750)
	build_path = /obj/item/borg/upgrade/basic/vtec

/datum/design/item/prosfab/robot_upgrade/basic/syndicate
	name = "Scrambled Equipment Module"
	desc = "Allows for the construction of lethal upgrades for cyborgs."
	id = "borg_syndicate_module"
	req_tech = list(TECH_COMBAT = 4, TECH_ILLEGAL = 3)
	materials = list(MAT_STEEL = 7500, MAT_GLASS = 11250, MAT_DIAMOND = 7500)
	build_path = /obj/item/borg/upgrade/basic/syndicate

/datum/design/item/prosfab/robot_upgrade/basic/language
	name = "Language Module"
	desc = "Used to let cyborgs other than clerical or service speak a variety of languages."
	id = "borg_language_module"
	req_tech = list(TECH_DATA = 6, TECH_MATERIAL = 6)
	materials = list(MAT_STEEL = 25000, MAT_GLASS = 3000, MAT_GOLD = 350)
	build_path = /obj/item/borg/upgrade/basic/language

// Section for advanced upgrades for all cyborgs

/datum/design/item/prosfab/robot_upgrade/advanced/bellysizeupgrade
	name = "Robohound Capacity Expansion Module"
	id = "borg_hound_capacity_module"
	req_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2)
	materials = list(MAT_STEEL = 4000, MAT_GLASS = 4000)
	build_path = /obj/item/borg/upgrade/advanced/bellysizeupgrade

/datum/design/item/prosfab/robot_upgrade/advanced/sizegun
	name = "Size Gun Module"
	id = "borg_sizegun_module"
	req_tech = list(TECH_COMBAT = 3, TECH_BLUESPACE = 3, TECH_MATERIAL = 3, TECH_POWER = 2)
	materials = list(MAT_STEEL = 6000, MAT_GLASS = 4000)
	build_path = /obj/item/borg/upgrade/advanced/sizegun

/datum/design/item/prosfab/robot_upgrade/advanced/jetpack
	name = "Jetpack Module"
	desc = "A carbon dioxide jetpack suitable for low-gravity mining operations."
	id = "borg_jetpack_module"
	materials = list(MAT_STEEL = 7500, MAT_PHORON = 11250, MAT_URANIUM = 15000)
	build_path = /obj/item/borg/upgrade/advanced/jetpack

/datum/design/item/prosfab/robot_upgrade/advanced/advhealth
	name = "Advanced Health Analyzer Module"
	desc = "An advanced health analyzer suitable for diagnosing more serious injuries."
	id = "borg_advhealth_module"
	materials = list(MAT_STEEL = 10000, MAT_GLASS = 6500, MAT_DIAMOND = 350)
	build_path = /obj/item/borg/upgrade/advanced/advhealth

/*
	Some job related borg upgrade modules, adding useful items for puppers.
*/

/datum/design/item/prosfab/robot_upgrade/restricted/bellycapupgrade
	name = "Robohound Capability Expansion Module"
	id = "borg_hound_capability_module"
	req_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4)
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 6000)
	build_path = /obj/item/borg/upgrade/restricted/bellycapupgrade

/datum/design/item/prosfab/robot_upgrade/restricted/advrped
	name = "Advanced Rapid Part Exchange Device"
	desc = "Exactly the same as a standard Advanced RPED, but this one has mounting hardware for a Science Borg."
	id = "borg_advrped_module"
	req_tech = list(TECH_ENGINEERING = 6, TECH_MATERIAL = 6)
	materials = list(MAT_STEEL = 30000, MAT_GLASS = 10000)
	build_path = /obj/item/borg/upgrade/restricted/advrped

/datum/design/item/prosfab/robot_upgrade/restricted/diamonddrill
	name = "Diamond Drill"
	desc = "A mining drill with a diamond tip, made for use by Mining Borgs."
	id = "borg_ddrill_module"
	req_tech = list(TECH_MATERIAL = 6, TECH_POWER = 5, TECH_ENGINEERING = 5)
	materials = list(MAT_STEEL = 3000, MAT_GLASS = 1000, MAT_DIAMOND = 2000)
	build_path = /obj/item/borg/upgrade/restricted/diamonddrill

/datum/design/item/prosfab/robot_upgrade/restricted/pka
	name = "Proto-Kinetic Accelerator"
	desc = "A mining weapon designed for clearing rocks and hostile wildlife. This model is equiped with a self upgrade system, allowing it to attach modules hands free."
	id = "borg_pka_module"
	req_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 5, TECH_POWER = 4)
	materials = list(MAT_PLASTEEL = 5000, MAT_GLASS = 1000, MAT_URANIUM = 500, MAT_PLATINUM = 350)
	build_path = /obj/item/borg/upgrade/restricted/pka

/datum/design/item/prosfab/robot_upgrade/restricted/tasercooler
	name = "Rapid Taser Cooling Module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	id = "borg_taser_module"
	materials = list(MAT_STEEL = 60000, MAT_GLASS = 4500, MAT_GOLD = 1500, MAT_DIAMOND = 375)
	build_path = /obj/item/borg/upgrade/restricted/tasercooler

// Section for quick access for admins, events and such, but can't be produced.

/datum/design/item/prosfab/robot_upgrade/no_prod
	category = list()		// We simply do not sort them in

/datum/design/item/prosfab/robot_upgrade/no_prod/cyborgtoy
	name = "Donk-Soft Cyborg Blaster"
	id = "borg_hound_cyborg_blaster"
	build_path = /obj/item/borg/upgrade/no_prod/toygun

/datum/design/item/prosfab/robot_upgrade/no_prod/vision_xray
	name = "X-ray vision"
	id = "borg_hound_vision_xray"
	build_path = /obj/item/borg/upgrade/no_prod/vision_xray

/datum/design/item/prosfab/robot_upgrade/no_prod/vision_thermal
	name = "Thermal vision"
	id = "borg_hound_vision_thermal"
	build_path = /obj/item/borg/upgrade/no_prod/vision_thermal

/datum/design/item/prosfab/robot_upgrade/no_prod/vision_meson
	name = "Meson vision"
	id = "borg_hound_vision_meson"
	build_path = /obj/item/borg/upgrade/no_prod/vision_meson

/datum/design/item/prosfab/robot_upgrade/no_prod/vision_material
	name = "Material vision"
	id = "borg_hound_vision_material"
	build_path = /obj/item/borg/upgrade/no_prod/vision_material

/datum/design/item/prosfab/robot_upgrade/no_prod/vision_anomalous
	name = "Anomalous vision"
	id = "borg_hound_vision_anomalous"
	build_path = /obj/item/borg/upgrade/no_prod/vision_anomalous

// Synthmorph Bags.

/datum/design/item/prosfab/synthmorphbag
	name = "Synthmorph Storage Bag"
	desc = "Used to store or slowly defragment an FBP."
	id = "misc_synth_bag"
	materials = list(MAT_STEEL = 250, MAT_GLASS = 250, MAT_PLASTIC = 2000)
	build_path = /obj/item/bodybag/cryobag/robobag

/datum/design/item/prosfab/badge_nt
	name = "NanoTrasen Tag"
	desc = "Used to identify an empty NanoTrasen FBP."
	id = "misc_synth_bag_tag_nt"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag

/datum/design/item/prosfab/badge_morph
	name = "Morpheus Tag"
	desc = "Used to identify an empty Morpheus FBP."
	id = "misc_synth_bag_tag_morph"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/morpheus

/datum/design/item/prosfab/badge_wardtaka
	name = "Ward-Takahashi Tag"
	desc = "Used to identify an empty Ward-Takahashi FBP."
	id = "misc_synth_bag_tag_wardtaka"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/wardtaka

/datum/design/item/prosfab/badge_zenghu
	name = "Zeng-Hu Tag"
	desc = "Used to identify an empty Zeng-Hu FBP."
	id = "misc_synth_bag_tag_zenghu"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/zenghu

/datum/design/item/prosfab/badge_gilthari
	name = "Gilthari Tag"
	desc = "Used to identify an empty Gilthari FBP."
	id = "misc_synth_bag_tag_gilthari"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_GOLD = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/gilthari
	req_tech = list(TECH_MATERIAL = 4, TECH_ILLEGAL = 2, TECH_PHORON = 2)

/datum/design/item/prosfab/badge_veymed
	name = "Vey-Medical Tag"
	desc = "Used to identify an empty Vey-Medical FBP."
	id = "misc_synth_bag_tag_veymed"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/veymed
	req_tech = list(TECH_MATERIAL = 3, TECH_ILLEGAL = 1, TECH_BIO = 4)

/datum/design/item/prosfab/badge_hephaestus
	name = "Hephaestus Tag"
	desc = "Used to identify an empty Hephaestus FBP."
	id = "misc_synth_bag_tag_heph"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/hephaestus

/datum/design/item/prosfab/badge_grayson
	name = "Grayson Tag"
	desc = "Used to identify an empty Grayson FBP."
	id = "misc_synth_bag_tag_grayson"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/grayson

/datum/design/item/prosfab/badge_xion
	name = "Xion Tag"
	desc = "Used to identify an empty Xion FBP."
	id = "misc_synth_bag_tag_xion"
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 500, MAT_PLASTIC = 1000)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/xion

/datum/design/item/prosfab/badge_bishop
	name = "Bishop Tag"
	desc = "Used to identify an empty Bishop FBP."
	id = "misc_synth_bag_tag_bishop"
	materials = list(MAT_STEEL = 500, MAT_GLASS = 2000, MAT_PLASTIC = 500)
	build_path = /obj/item/clothing/accessory/badge/corporate_tag/bishop

// Replacement protean bits

/datum/design/item/prosfab/orchestrator
	name = "Protean Orchestrator"
	id = "prot_orch"
	build_path = /obj/item/organ/internal/nano/orchestrator
	time = 30
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000, MAT_SILVER = 2000, MAT_GOLD = 2000)
	//req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)

/datum/design/item/prosfab/refactory
	name = "Protean Refactory"
	id = "prot_refact"
	build_path = /obj/item/organ/internal/nano/refactory
	time = 30
	materials = list(MAT_STEEL = 8000, MAT_GLASS = 2000, MAT_SILVER = 2000, MAT_GOLD = 2000)
	//req_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5, TECH_MATERIAL = 5, TECH_ENGINEERING = 5, TECH_DATA = 5)

///// pAI parts!!!

//////////////////// Cyborg Parts ////////////////////
/datum/design/item/prosfab/paiparts
	category = list("pAI Parts")
	time = 20
	materials = list(MAT_STEEL = 1000, MAT_GLASS = 1000)

/datum/design/item/prosfab/paiparts/cell
	name = "pAI Cell"
	id = "pai_cell"
	build_path = /obj/item/paiparts/cell

/datum/design/item/prosfab/paiparts/processor
	name = "pAI Processor"
	id = "pai_processor"
	build_path = /obj/item/paiparts/processor

/datum/design/item/prosfab/paiparts/board
	name = "pAI Board"
	id = "pai_board"
	build_path = /obj/item/paiparts/board

/datum/design/item/prosfab/paiparts/capacitor
	name = "pAI capacitor"
	id = "pai_capacitor"
	build_path = /obj/item/paiparts/capacitor

/datum/design/item/prosfab/paiparts/projector
	name = "pAI Projector"
	id = "pai_projector"
	build_path = /obj/item/paiparts/projector

/datum/design/item/prosfab/paiparts/emitter
	name = "pAI Emitter"
	id = "pai_emitter"
	build_path = /obj/item/paiparts/emitter

/datum/design/item/prosfab/paiparts/speech_synthesizer
	name = "pAI Speech Synthesizer"
	id = "pai_speech_synthesizer"
	build_path = /obj/item/paiparts/speech_synthesizer
