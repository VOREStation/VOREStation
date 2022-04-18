//Procedures in this file: Facial reconstruction surgery
//////////////////////////////////////////////////////////////////
//						FACE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/face
	priority = 2
	req_open = 0
	can_infect = 0

/datum/surgery_step/face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected || (affected.robotic >= ORGAN_ROBOT))
		return 0
	if(coverage_check(user, target, affected, tool))
		return 0
	return target_zone == O_MOUTH

///////////////////////////////////////////////////////////////
// Face Opening Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/cut_face
	allowed_tools = list(
	/obj/item/surgical/scalpel = 100,		\
	/obj/item/material/knife = 75,	\
	/obj/item/material/shard = 50, 		\
	)

	min_duration = 90
	max_duration = 110

/datum/surgery_step/generic/cut_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == O_MOUTH && target.op_stage.face == 0

/datum/surgery_step/generic/cut_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts to cut open [target]'s face and neck with \the [tool].", \
	"You start to cut open [target]'s face and neck with \the [tool].")
	..()

/datum/surgery_step/generic/cut_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] has cut open [target]'s face and neck with \the [tool].</span>" , \
	"<span class='notice'> You have cut open[target]'s face and neck with \the [tool].</span>",)
	target.op_stage.face = 1

/datum/surgery_step/generic/cut_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, slicing [target]'s throat wth \the [tool]!</span>" , \
	"<span class='danger'>Your hand slips, slicing [target]'s throat wth \the [tool]!</span>" )
	affected.createwound(CUT, 60)
	target.AdjustLosebreath(10)

///////////////////////////////////////////////////////////////
// Vocal Cord/Face Repair Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/face/mend_vocal
	allowed_tools = list(
	/obj/item/surgical/hemostat = 100, 	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/assembly/mousetrap = 10	//I don't know. Don't ask me. But I'm leaving it because hilarity.
	)

	min_duration = 70
	max_duration = 90

/datum/surgery_step/face/mend_vocal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face == 1

/datum/surgery_step/face/mend_vocal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts mending [target]'s vocal cords with \the [tool].", \
	"You start mending [target]'s vocal cords with \the [tool].")
	..()

/datum/surgery_step/face/mend_vocal/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] mends [target]'s vocal cords with \the [tool].</span>", \
	"<span class='notice'>You mend [target]'s vocal cords with \the [tool].</span>")
	target.op_stage.face = 2

/datum/surgery_step/face/mend_vocal/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='danger'>[user]'s hand slips, clamping [target]'s trachea shut for a moment with \the [tool]!</span>", \
	"<span class='danger'>Your hand slips, clamping [user]'s trachea shut for a moment with \the [tool]!</span>")
	target.AdjustLosebreath(10)

///////////////////////////////////////////////////////////////
// Face Fixing Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/face/fix_face
	allowed_tools = list(
		/obj/item/surgical/retractor = 100, 	\
		/obj/item/material/kitchen/utensil/fork = 75
	)

	allowed_procs = list(IS_CROWBAR = 55)

	min_duration = 80
	max_duration = 100

/datum/surgery_step/face/fix_face/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face == 2

/datum/surgery_step/face/fix_face/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("[user] starts pulling the skin on [target]'s face back in place with \the [tool].", \
	"You start pulling the skin on [target]'s face back in place with \the [tool].")
	..()

/datum/surgery_step/face/fix_face/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] pulls the skin on [target]'s face back in place with \the [tool].</span>",	\
	"<span class='notice'>You pull the skin on [target]'s face back in place with \the [tool].</span>")
	target.op_stage.face = 3

/datum/surgery_step/face/fix_face/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, tearing skin on [target]'s face with \the [tool]!</span>", \
	"<span class='danger'>Your hand slips, tearing skin on [target]'s face with \the [tool]!</span>")
	target.apply_damage(10, BRUTE, affected, sharp = TRUE, sharp = TRUE)

///////////////////////////////////////////////////////////////
// Face Cauterizing Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/face/cauterize
	allowed_tools = list(
	/obj/item/surgical/cautery = 100,			\
	/obj/item/clothing/mask/smokable/cigarette = 75,	\
	/obj/item/flame/lighter = 50,			\
	/obj/item/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

/datum/surgery_step/face/cauterize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.face > 0

/datum/surgery_step/face/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message("<span class='notice'>[user] is beginning to cauterize the incision on [target]'s face and neck with \the [tool].</span>" , \
	"<span class='notice'>You are beginning to cauterize the incision on [target]'s face and neck with \the [tool].</span>")
	..()

/datum/surgery_step/face/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] cauterizes the incision on [target]'s face and neck with \the [tool].</span>", \
	"<span class='notice'>You cauterize the incision on [target]'s face and neck with \the [tool].</span>")
	affected.open = 0
	affected.status &= ~ORGAN_BLEEDING
	if (target.op_stage.face == 3)
		var/obj/item/organ/external/head/h = affected
		h.disfigured = 0
	target.op_stage.face = 0

/datum/surgery_step/face/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, leaving a small burn on [target]'s face with \the [tool]!</span>", \
	"<span class='danger'>Your hand slips, leaving a small burn on [target]'s face with \the [tool]!</span>")
	target.apply_damage(4, BURN, affected)