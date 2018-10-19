//Procedures in this file: Fracture repair surgery
//////////////////////////////////////////////////////////////////
//						BONE SURGERY							//
//////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////
// Bone Glue Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/glue_bone
	allowed_tools = list(
		/obj/item/weapon/surgical/bonegel = 100
	)

	allowed_procs = list(IS_SCREWDRIVER = 75)

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/glue_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2 && affected.stage == 0

/datum/surgery_step/glue_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected.stage == 0)
		user.visible_message("<font color='blue'>[user] starts applying medication to the damaged bones in [target]'s [affected.name] with \the [tool].</font>" , \
		"<font color='blue'>You start applying medication to the damaged bones in [target]'s [affected.name] with \the [tool].</font>")
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!", 50)
	..()

/datum/surgery_step/glue_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='blue'>[user] applies some [tool] to [target]'s bone in [affected.name]</font>", \
		"<font color='blue'>You apply some [tool] to [target]'s bone in [affected.name] with \the [tool].</font>")
	affected.stage = 1

/datum/surgery_step/glue_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</font>" , \
	"<font color='red'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</font>")

///////////////////////////////////////////////////////////////
// Bone Setting Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/set_bone
	allowed_tools = list(
		/obj/item/weapon/surgical/bonesetter = 100
	)

	allowed_procs = list(IS_WRENCH = 75)

	min_duration = 60
	max_duration = 70

/datum/surgery_step/set_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.organ_tag != BP_HEAD && !(affected.robotic >= ORGAN_ROBOT) && affected.open >= 2 && affected.stage == 1

/datum/surgery_step/set_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='blue'>[user] is beginning to set the bone in [target]'s [affected.name] in place with \the [tool].</font>" , \
		"<font color='blue'>You are beginning to set the bone in [target]'s [affected.name] in place with \the [tool].</font>")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!", 50)
	..()

/datum/surgery_step/set_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected.status & ORGAN_BROKEN)
		user.visible_message("<font color='blue'>[user] sets the bone in [target]'s [affected.name] in place with \the [tool].</font>", \
			"<font color='blue'>You set the bone in [target]'s [affected.name] in place with \the [tool].</font>")
		affected.stage = 2
	else
		user.visible_message("[user] sets the bone in [target]'s [affected.name]<font color='red'> in the WRONG place with \the [tool].</font>", \
			"You set the bone in [target]'s [affected.name]<font color='red'> in the WRONG place with \the [tool].</font>")
		affected.fracture()

/datum/surgery_step/set_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!</font>" , \
		"<font color='red'>Your hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!</font>")
	affected.createwound(BRUISE, 5)

///////////////////////////////////////////////////////////////
// Skull Mending Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/mend_skull
	allowed_tools = list(
		/obj/item/weapon/surgical/bonesetter = 100
	)

	allowed_procs = list(IS_WRENCH = 75)

	min_duration = 60
	max_duration = 70

/datum/surgery_step/mend_skull/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.organ_tag == BP_HEAD && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2 && affected.stage == 1

/datum/surgery_step/mend_skull/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<font color='blue'>[user] is beginning to piece together [target]'s skull with \the [tool].</font>"  , \
		"<font color='blue'>You are beginning to piece together [target]'s skull with \the [tool].</font>")
	..()

/datum/surgery_step/mend_skull/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='blue'>[user] sets [target]'s skull with \the [tool].</font>" , \
		"<font color='blue'>You set [target]'s skull with \the [tool].</font>")
	affected.stage = 2

/datum/surgery_step/mend_skull/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, damaging [target]'s face with \the [tool]!</font>"  , \
		"<font color='red'>Your hand slips, damaging [target]'s face with \the [tool]!</font>")
	var/obj/item/organ/external/head/h = affected
	h.createwound(BRUISE, 10)
	h.disfigured = 1

///////////////////////////////////////////////////////////////
// Bone Fixing Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/finish_bone
	allowed_tools = list(
		/obj/item/weapon/surgical/bonegel = 100
	)

	allowed_procs = list(IS_SCREWDRIVER = 75)

	can_infect = 1
	blood_level = 1

	min_duration = 50
	max_duration = 60

/datum/surgery_step/finish_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && affected.open >= 2 && !(affected.robotic >= ORGAN_ROBOT) && affected.stage == 2

/datum/surgery_step/finish_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='blue'>[user] starts to finish mending the damaged bones in [target]'s [affected.name] with \the [tool].</font>", \
	"<font color='blue'>You start to finish mending the damaged bones in [target]'s [affected.name] with \the [tool].</font>")
	..()

/datum/surgery_step/finish_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='blue'>[user] has mended the damaged bones in [target]'s [affected.name] with \the [tool].</font>"  , \
		"<font color='blue'>You have mended the damaged bones in [target]'s [affected.name] with \the [tool].</font>" )
	affected.status &= ~ORGAN_BROKEN
	affected.stage = 0

/datum/surgery_step/finish_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</font>" , \
	"<font color='red'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</font>")

///////////////////////////////////////////////////////////////
// Bone Clamp Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/clamp_bone
	allowed_tools = list(
		/obj/item/weapon/surgical/bone_clamp = 100
		)

	can_infect = 1
	blood_level = 1

	min_duration = 70
	max_duration = 90

/datum/surgery_step/clamp_bone/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return affected && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2 && affected.stage == 0

/datum/surgery_step/clamp_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected.stage == 0)
		user.visible_message("<font color='blue'>[user] starts repairing the damaged bones in [target]'s [affected.name] with \the [tool].</font>" , \
		"<font color='blue'>You starts repairing the damaged bones in [target]'s [affected.name] with \the [tool].</font>")
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!", 50)
	..()

/datum/surgery_step/clamp_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='blue'>[user] sets the bone in [target]'s [affected.name] with \the [tool].</font>", \
		"<font color='blue'>You sets [target]'s bone in [affected.name] with \the [tool].</font>")
	affected.status &= ~ORGAN_BROKEN

/datum/surgery_step/clamp_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<font color='red'>[user]'s hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!</font>" , \
		"<font color='red'>Your hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!</font>")
	affected.createwound(BRUISE, 5)