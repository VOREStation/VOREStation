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
	if(coverage_check(user, target, affected, tool))
		return 0
	return affected && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2 && affected.stage == 0

/datum/surgery_step/glue_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected.stage == 0)
		user.visible_message("<span class='notice'>[user] starts applying medication to the damaged bones in [target]'s [affected.name] with \the [tool].</span>" , \
		"<span class='notice'>You start applying medication to the damaged bones in [target]'s [affected.name] with \the [tool].</span>")
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!", 50)
	..()

/datum/surgery_step/glue_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] applies some [tool] to [target]'s bone in [affected.name]</span>", \
		"<span class='notice'>You apply some [tool] to [target]'s bone in [affected.name] with \the [tool].</span>")
	affected.stage = 1

/datum/surgery_step/glue_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>" , \
	"<span class='danger'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>")

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
	if(coverage_check(user, target, affected, tool))
		return 0
	return affected && affected.organ_tag != BP_HEAD && !(affected.robotic >= ORGAN_ROBOT) && affected.open >= 2 && affected.stage == 1

/datum/surgery_step/set_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] is beginning to set the bone in [target]'s [affected.name] in place with \the [tool].</span>" , \
		"<span class='notice'>You are beginning to set the bone in [target]'s [affected.name] in place with \the [tool].</span>")
	target.custom_pain("The pain in your [affected.name] is going to make you pass out!", 50)
	..()

/datum/surgery_step/set_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected.status & ORGAN_BROKEN)
		user.visible_message("<span class='notice'>[user] sets the bone in [target]'s [affected.name] in place with \the [tool].</span>", \
			"<span class='notice'>You set the bone in [target]'s [affected.name] in place with \the [tool].</span>")
		affected.stage = 2
	else
		user.visible_message("[user] sets the bone in [target]'s [affected.name]<span class='danger'> in the WRONG place with \the [tool].</span>", \
			"You set the bone in [target]'s [affected.name]<span class='danger'> in the WRONG place with \the [tool].</span>")
		affected.fracture()

/datum/surgery_step/set_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!</span>" , \
		"<span class='danger'>Your hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!</span>")
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
	if(coverage_check(user, target, affected, tool))
		return 0
	return affected && affected.organ_tag == BP_HEAD && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2 && affected.stage == 1

/datum/surgery_step/mend_skull/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] is beginning to piece together [target]'s skull with \the [tool].</span>"  , \
		"<span class='notice'>You are beginning to piece together [target]'s skull with \the [tool].</span>")
	..()

/datum/surgery_step/mend_skull/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] sets [target]'s skull with \the [tool].</span>" , \
		"<span class='notice'>You set [target]'s skull with \the [tool].</span>")
	affected.stage = 2

/datum/surgery_step/mend_skull/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, damaging [target]'s face with \the [tool]!</span>"  , \
		"<span class='danger'>Your hand slips, damaging [target]'s face with \the [tool]!</span>")
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
	if(coverage_check(user, target, affected, tool))
		return 0
	return affected && affected.open >= 2 && !(affected.robotic >= ORGAN_ROBOT) && affected.stage == 2

/datum/surgery_step/finish_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] starts to finish mending the damaged bones in [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You start to finish mending the damaged bones in [target]'s [affected.name] with \the [tool].</span>")
	..()

/datum/surgery_step/finish_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has mended the damaged bones in [target]'s [affected.name] with \the [tool].</span>"  , \
		"<span class='notice'>You have mended the damaged bones in [target]'s [affected.name] with \the [tool].</span>" )
	affected.status &= ~ORGAN_BROKEN
	affected.stage = 0

/datum/surgery_step/finish_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>" , \
	"<span class='danger'>Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!</span>")

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
	if(coverage_check(user, target, affected, tool))
		return 0
	return affected && (affected.robotic < ORGAN_ROBOT) && affected.open >= 2 && affected.stage == 0

/datum/surgery_step/clamp_bone/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected.stage == 0)
		user.visible_message("<span class='notice'>[user] starts repairing the damaged bones in [target]'s [affected.name] with \the [tool].</span>" , \
		"<span class='notice'>You starts repairing the damaged bones in [target]'s [affected.name] with \the [tool].</span>")
	target.custom_pain("Something in your [affected.name] is causing you a lot of pain!", 50)
	..()

/datum/surgery_step/clamp_bone/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] sets the bone in [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You sets [target]'s bone in [affected.name] with \the [tool].</span>")
	affected.status &= ~ORGAN_BROKEN

/datum/surgery_step/clamp_bone/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!</span>" , \
		"<span class='danger'>Your hand slips, damaging the bone in [target]'s [affected.name] with \the [tool]!</span>")
	affected.createwound(BRUISE, 5)