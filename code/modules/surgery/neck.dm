//Procedures in this file: Brain-stem reattachment surgery.
//////////////////////////////////////////////////////////////////////
//						BRAINSTEM SURGERY							//
//////////////////////////////////////////////////////////////////////

/datum/surgery_step/brainstem
	surgery_name = "Brainstem"
	priority = 2
	req_open = 1
	can_infect = 1

/datum/surgery_step/brainstem/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected || (affected.robotic >= ORGAN_ROBOT) || !(affected.open >= 3))
		return 0
	if(coverage_check(user, target, affected, tool))
		return 0
	return target_zone == BP_HEAD

/////////////////////////////
// Blood Vessel Mending
/////////////////////////////

/datum/surgery_step/brainstem/mend_vessels
	surgery_name = "Mend Vessels"
	priority = 1
	allowed_tools = list(
		/obj/item/surgical/FixOVein = 100,
		/obj/item/stack/cable_coil = 40,
		/obj/item/assembly/mousetrap = 5)

	min_duration = 80
	max_duration = 100

/datum/surgery_step/brainstem/mend_vessels/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_HEAD && target.op_stage.brainstem == 0

/datum/surgery_step/brainstem/mend_vessels/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_filter_notice("[user] starts to mend the blood vessels on [target]'s brainstem with \the [tool]."), \
	span_filter_notice("You start to mend the blood vessels on [target]'s brainstem with \the [tool]."))
	user.balloon_alert_visible("starts mending blood vessels on [target]'s brainstem", "mending blood vessels on the brainstem.")
	..()

/datum/surgery_step/brainstem/mend_vessels/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] has mended the blood vessels on [target]'s brainstem with \the [tool].") , \
	span_notice(" You have mended the blood vessels on [target]'s brainstem with \the [tool]."),)
	user.balloon_alert_visible("mended the blood vessels on [target]'s brainstem", "mended the blood vessels on the brainstem.")
	target.op_stage.brainstem = 1

/datum/surgery_step/brainstem/mend_vessels/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, tearing at [target]'s brainstem with \the [tool]!") , \
	span_danger("Your hand slips, tearing at [target]'s brainstem with \the [tool]!") )
	user.balloon_alert_visible("slips, tearing at [target]'s brainstem", "your hand slips, tearing at the brainstem")
	affected.createwound(PIERCE, 10)
	target.AdjustParalysis(10)

/////////////////////////////
// Bone Drilling
/////////////////////////////

/datum/surgery_step/brainstem/drill_vertebrae
	surgery_name = "Drill Vertebrae"
	priority = 3 //Do this instead of expanding the skull cavity
	allowed_tools = list(
		/obj/item/surgical/surgicaldrill = 100,
		/obj/item/melee/changeling/arm_blade = 15,
		/obj/item/pickaxe = 5
	)

	allowed_procs = list(IS_SCREWDRIVER = 75)

	min_duration = 200 //Very. Very. Carefully.
	max_duration = 300

/datum/surgery_step/brainstem/drill_vertebrae/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_HEAD && target.op_stage.brainstem == 1

/datum/surgery_step/brainstem/drill_vertebrae/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_filter_notice("[user] starts to drill around [target]'s brainstem with \the [tool]."), \
	span_filter_notice("You start to drill around [target]'s brainstem with \the [tool]."))
	user.balloon_alert_visible("starts drilling around [target]'s brainstem", "drilling around the brainstem")
	..()

/datum/surgery_step/brainstem/drill_vertebrae/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] has drilled around [target]'s brainstem with \the [tool].") , \
	span_notice(" You have drilled around [target]'s brainstem with \the [tool]."),)
	user.balloon_alert_visible("drilled around [target]'s brainstem", "drilled around the brainstem")
	target.AdjustParalysis(10) //We're getting Invasive here. This only ticks down when the person is alive, so it's a good side-effect for this step. Rattling the braincase with a drill is not optimal.
	target.op_stage.brainstem = 2
	affected.fracture() //Does not apply damage, simply breaks it if it wasn't already. Doesn't stop a defib on its own.

/datum/surgery_step/brainstem/drill_vertebrae/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, shredding [target]'s brainstem with \the [tool]!") , \
	span_danger("Your hand slips, shredding [target]'s brainstem with \the [tool]!") )
	user.balloon_alert_visible("slips, shredding [target]'s brainstem", "your hand slips, shredding the brainstem.")
	affected.createwound(PIERCE, 10)
	target.AdjustParalysis(15)
	spawn()
		for(var/obj/item/organ/internal/brain/O in affected.internal_organs)
			O.take_damage(rand(5,10))

/////////////////////////////
// Bone Cleaning
/////////////////////////////

/datum/surgery_step/brainstem/clean_chips
	surgery_name = "Remove Bone Chips"
	priority = 3 //Do this instead of picking around for implants.
	allowed_tools = list(
		/obj/item/surgical/hemostat = 100,
		/obj/item/melee/changeling/claw = 40) //Surprisingly, claws are kind of okay at picking things out.

	allowed_procs = list(IS_WIRECUTTER = 60)

	min_duration = 90
	max_duration = 120

/datum/surgery_step/brainstem/clean_chips/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_HEAD && target.op_stage.brainstem == 2

/datum/surgery_step/brainstem/clean_chips/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_filter_notice("[user] starts to pick around [target]'s brainstem for bone chips with \the [tool]."), \
	span_filter_notice("You start to pick around [target]'s brainstem for bone chips with \the [tool]."))
	user.balloon_alert_visible("starts to pick around [target]'s brainstem for bone chips.", "picking around the brainstem for bone chips.")
	..()

/datum/surgery_step/brainstem/clean_chips/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] has cleaned around [target]'s brainstem with \the [tool].") , \
	span_notice(" You have cleaned around [target]'s brainstem with \the [tool]."),)
	user.balloon_alert_visible("cleaned around [target]'s brainstem")
	target.AdjustParalysis(10) //Still invasive.
	target.op_stage.brainstem = 3

/datum/surgery_step/brainstem/clean_chips/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, gouging [target]'s brainstem with \the [tool]!") , \
	span_danger("Your hand slips, gouging [target]'s brainstem with \the [tool]!") )
	user.balloon_alert_visible("slips, gouging [target]'s brainstem", "your hand slips, gouging the brainstem")
	affected.createwound(CUT, 5)
	target.AdjustParalysis(10)
	spawn()
		for(var/obj/item/organ/internal/brain/O in affected.internal_organs) //If there's more than one...
			O.take_damage(rand(1,10))

/////////////////////////////
// Spinal Cord Repair
/////////////////////////////

/datum/surgery_step/brainstem/mend_cord
	surgery_name = "Mend Spinal Cord"
	priority = 1 //Do this after IB.
	allowed_tools = list(
		/obj/item/surgical/FixOVein = 100,
		/obj/item/stack/nanopaste = 50,
		/obj/item/stack/cable_coil = 40,
		/obj/item/assembly/mousetrap = 5)

	min_duration = 100
	max_duration = 200

/datum/surgery_step/brainstem/mend_cord/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_HEAD && target.op_stage.brainstem == 3

/datum/surgery_step/brainstem/mend_cord/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_filter_notice("[user] starts to fuse [target]'s spinal cord with \the [tool]."), \
	span_filter_notice("You start to fuse [target]'s spinal cord with \the [tool]."))
	user.balloon_alert_visible("starts fusing [target]'s spinal cord", "fusing the spinal cord")
	..()

/datum/surgery_step/brainstem/mend_cord/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] has fused [target]'s spinal cord with \the [tool].") , \
	span_notice(" You have fused [target]'s spinal cord with \the [tool]."),)
	user.balloon_alert_visible("fused [target]'s spinal cord", "fused the spinal cord")
	target.op_stage.brainstem = 4
	target.AdjustParalysis(5)
	target.add_modifier(/datum/modifier/franken_sickness, 20 MINUTES)

/datum/surgery_step/brainstem/mend_cord/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, tearing at [target]'s spinal cord with \the [tool]!") , \
	span_danger("Your hand slips, tearing at [target]'s spinal cord with \the [tool]!") )
	user.balloon_alert_visible("slips, tearing [target]'s spinal cord", "your hand slips, tearing at the spinal cord")
	affected.createwound(PIERCE, 5)
	target.AdjustParalysis(20)
	spawn()
		for(var/obj/item/organ/internal/brain/O in affected.internal_organs)
			O.take_damage(rand(5,15)) //Down to the wire. Or rather, the cord.

/////////////////////////////
// Vertebrae repair
/////////////////////////////

/datum/surgery_step/brainstem/mend_vertebrae
	surgery_name = "Mend Vertebrae"
	priority = 3 //Do this instead of fixing bones.
	allowed_tools = list(
		/obj/item/surgical/bonegel = 100,
		/obj/item/stack/nanopaste = 50,
		/obj/item/tape_roll = 5)

	min_duration = 100
	max_duration = 160

/datum/surgery_step/brainstem/mend_vertebrae/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_HEAD && target.op_stage.brainstem == 4

/datum/surgery_step/brainstem/mend_vertebrae/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_filter_notice("[user] starts to mend [target]'s opened vertebrae with \the [tool]."), \
	span_filter_notice("You start to mend [target]'s opened vertebrae with \the [tool]."))
	user.balloon_alert_visible("starts mending [target]'s opened vertebrae", "mending opened vertebrae")
	..()

/datum/surgery_step/brainstem/mend_vertebrae/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] has mended [target]'s vertebrae with \the [tool].") , \
	span_notice(" You have mended [target]'s vertebrae with \the [tool]."),)
	user.balloon_alert_visible("mended [target]'s vertebrae", "mended the vertebrae")
	target.can_defib = 1
	target.op_stage.brainstem = 5

/datum/surgery_step/brainstem/mend_vertebrae/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, tearing at [target]'s spinal cord with \the [tool]!") , \
	span_danger("Your hand slips, tearing at [target]'s spinal cord with \the [tool]!") )
	user.balloon_alert_visible("slips, tearing at [target]'s spinal cord", "your hand slips, tearing at the spinal cord")
	affected.createwound(PIERCE, 5)
	target.AdjustParalysis(15)
	spawn()
		for(var/obj/item/organ/internal/brain/O in affected.internal_organs)
			O.take_damage(rand(1,10))

/////////////////////////////
// Realign tissues
/////////////////////////////

/datum/surgery_step/brainstem/realign_tissue
	surgery_name = "Realign Tissue"
	priority = 3 //Do this instead of searching for objects in the skull.
	allowed_tools = list(
		/obj/item/surgical/hemostat = 100,
		/obj/item/melee/changeling/claw = 20) //Claws. Good for digging, not so much for moving.

	allowed_procs = list(IS_WIRECUTTER = 60)

	min_duration = 90
	max_duration = 120

/datum/surgery_step/brainstem/realign_tissue/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_HEAD && target.op_stage.brainstem == 5

/datum/surgery_step/brainstem/realign_tissue/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_filter_notice("[user] starts to realign the tissues in [target]'s skull with \the [tool]."), \
	span_filter_notice("You start to realign the tissues in [target]'s skull with \the [tool]."))
	user.balloon_alert_visible("starts to realign the tissues in [target]'s skull", "realigning the tissues in the skull")
	..()

/datum/surgery_step/brainstem/realign_tissue/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] has realigned the tissues in [target]'s skull back into place with \the [tool].") , \
	span_notice(" You have realigned the tissues in [target]'s skull back into place with \the [tool]."),)
	user.balloon_alert_visible("realigned the tissues in [target]'s skull back in place", "realigned the tissues in the skull back into place")
	target.AdjustParalysis(5) //I n v a s i v e
	target.op_stage.brainstem = 0 //The cycle begins anew.

/datum/surgery_step/brainstem/realign_tissue/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, gouging [target]'s brainstem with \the [tool]!") , \
	span_danger("Your hand slips, gouging [target]'s brainstem with \the [tool]!"))
	user.balloon_alert_visible("slips, gounging at [target]'s brainstem", "your hand slips, gouging at the brainstem")
	affected.createwound(CUT, 5)
	target.AdjustParalysis(30)
	spawn()
		for(var/obj/item/organ/internal/brain/O in affected.internal_organs)
			O.take_damage(rand(1,10))
