//Procedures in this file: Fracture repair surgery
//////////////////////////////////////////////////////////////////
//						BONE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/bones

/datum/surgery_step/bones/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!(affected.status & ORGAN_BROKEN))
		return FALSE
	if(coverage_check(user, target, affected, tool))
		return FALSE
	if(affected.cannot_break && !affected.encased)
		return FALSE
	if(affected.robotic >= ORGAN_ROBOT)
		return FALSE
	return TRUE

///////////////////////////////////////////////////////////////
// Bone Glue Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/bones/glue_bone
	surgery_name = "Glue Bone"
	allowed_tools = list(
		/obj/item/surgical/bonegel = 100
	)

	allowed_procs = list(IS_SCREWDRIVER = 75)

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/bones/glue_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.open >= FLESH_RETRACTED && affected.stage == 0

/datum/surgery_step/bones/glue_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected.stage == 0)
		user.visible_message(span_notice("[user] starts applying medication to the damaged bones in [target]'s [affected.name] with \the [tool].") , \
		span_notice("You start applying medication to the damaged bones in [target]'s [affected.name] with \the [tool]."))
		user.balloon_alert_visible("applies medication to the damaged bones.", "applying medication to the damaged bones.")
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!", 50)
	..()

/datum/surgery_step/bones/glue_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] applies some [tool] to [target]'s bone in [affected.name]"), \
		span_notice("You apply some [tool] to [target]'s bone in [affected.name] with \the [tool]."))
	user.balloon_alert_visible("applies [tool] to [target]'s bone.", "applying [tool] to [target]'s bone.")
	affected.stage = 1

/datum/surgery_step/bones/glue_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!") , \
	span_danger("Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!"))
	user.balloon_alert_visible("slips, damaging [target]'s [affected.name]", "your hand slips.")

///////////////////////////////////////////////////////////////
// Bone Setting Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/bones/set_bone
	surgery_name = "Set Bone"
	allowed_tools = list(
		/obj/item/surgical/bonesetter = 100
	)

	allowed_procs = list(IS_WRENCH = 75)

	min_duration = 60
	max_duration = 60

/datum/surgery_step/bones/set_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.organ_tag != BP_HEAD && affected.open >= FLESH_RETRACTED && affected.stage == 1

/datum/surgery_step/bones/set_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] is beginning to set the bone in [target]'s [affected.name] in place with \the [tool].") , \
		span_notice("You are beginning to set the bone in [target]'s [affected.name] in place with \the [tool]."))
	user.balloon_alert_visible("begins to set the bone in place.", "setting the bone in place.")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!", 50)
	..()

/datum/surgery_step/bones/set_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] sets the bone in [target]'s [affected.name] in place with \the [tool]."), \
		span_notice("You set the bone in [target]'s [affected.name] in place with \the [tool]."))
	user.balloon_alert_visible("sets the bone in place.", "bone set in place.")
	affected.stage = 2

/datum/surgery_step/bones/set_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!") , \
		span_danger("Your hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!"))
	user.balloon_alert_visible("slips, damaging the bone.", "your hand slips, damaging the bone")
	affected.createwound(BRUISE, 5)

///////////////////////////////////////////////////////////////
// Skull Mending Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/bones/mend_skull
	surgery_name = "Mend Skull"
	allowed_tools = list(
		/obj/item/surgical/bonesetter = 100
	)

	allowed_procs = list(IS_WRENCH = 75)

	min_duration = 60
	max_duration = 60

/datum/surgery_step/bones/mend_skull/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.organ_tag == BP_HEAD && affected.open >= FLESH_RETRACTED && affected.stage == 1

/datum/surgery_step/bones/mend_skull/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] is beginning to piece together [target]'s skull with \the [tool].")  , \
		span_notice("You are beginning to piece together [target]'s skull with \the [tool]."))
	user.balloon_alert_visible("pieces the skull together", "piecing skull together.")
	..()

/datum/surgery_step/bones/mend_skull/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] sets [target]'s skull with \the [tool].") , \
		span_notice("You set [target]'s skull with \the [tool]."))
	user.balloon_alert_visible("sets the skull back.", "skull set back.")
	affected.stage = 2

/datum/surgery_step/bones/mend_skull/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, damaging [target]'s face with \the [tool]!")  , \
		span_danger("Your hand slips, damaging [target]'s face with \the [tool]!"))
	user.balloon_alert_visible("slips, damaging [target]'s face", "your hand slips, damaging [target]'s face")
	var/obj/item/organ/external/head/h = affected
	h.createwound(BRUISE, 10)
	h.disfigure()

///////////////////////////////////////////////////////////////
// Bone Fixing Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/bones/finish_bone
	surgery_name = "Finish Mending Bone"
	allowed_tools = list(
		/obj/item/surgical/bonegel = 100
	)

	allowed_procs = list(IS_SCREWDRIVER = 90) //this is what we actually use irl!

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 50

/datum/surgery_step/bones/finish_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.open >= FLESH_RETRACTED && affected.stage == 2

/datum/surgery_step/bones/finish_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] starts to finish mending the damaged bones in [target]'s [affected.name] with \the [tool]."), \
	span_notice("You start to finish mending the damaged bones in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("begins mending damaged bones.", "mending damaged bones.")
	..()

/datum/surgery_step/bones/finish_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] has mended the damaged bones in [target]'s [affected.name] with \the [tool].")  , \
		span_notice("You have mended the damaged bones in [target]'s [affected.name] with \the [tool].") )
	user.balloon_alert_visible("mends damaged bones.", "mended damaged bones.")
	affected.status &= ~ORGAN_BROKEN
	affected.open = FLESH_RETRACTED
	affected.stage = 0

/datum/surgery_step/bones/finish_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!") , \
	span_danger("Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!"))
	user.balloon_alert_visible("slips, smearing [tool] in the incision.", "your hand slips, smearing [tool].")

///////////////////////////////////////////////////////////////
// Bone Clamp Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/bones/clamp_bone
	surgery_name = "Clamp Bone"
	allowed_tools = list(
		/obj/item/surgical/bone_clamp = 100
		)

	can_infect = 1
	blood_level = 1

	min_duration = 70
	max_duration = 70

/datum/surgery_step/bones/clamp_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.open >= FLESH_RETRACTED && affected.stage == 0

/datum/surgery_step/bones/clamp_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected.stage == 0)
		user.visible_message(span_notice("[user] starts repairing the damaged bones in [target]'s [affected.name] with \the [tool].") , \
		span_notice("You starts repairing the damaged bones in [target]'s [affected.name] with \the [tool]."))
		user.balloon_alert_visible("begins repairing damaged bones.", "repairing damaged bones.")
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!", 50)
	..()

/datum/surgery_step/bones/clamp_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] sets the bone in [target]'s [affected.name] with \the [tool]."), \
		span_notice("You sets [target]'s bone in [affected.name] with \the [tool]."))
	user.balloon_alert_visible("sets the bone back in.", "bone set in.")
	affected.status &= ~ORGAN_BROKEN
	affected.open = FLESH_RETRACTED

/datum/surgery_step/bones/clamp_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!") , \
		span_danger("Your hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!"))
	user.balloon_alert_visible("slips, damaging [target]'s [affected.name]", "your hand slips, damaging the bone.")
	affected.createwound(BRUISE, 5)
