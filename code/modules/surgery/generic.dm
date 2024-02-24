//Procedures in this file: Gneric surgery steps
//////////////////////////////////////////////////////////////////
//						COMMON STEPS							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/generic/
	can_infect = 1

/datum/surgery_step/generic/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (isslime(target))
		return 0
	if (target_zone == O_EYES)	//there are specific steps for eye surgery
		return 0
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected == null)
		return 0
	if (affected.is_stump())
		return 0
	if (affected.robotic >= ORGAN_ROBOT)
		return 0
	if(coverage_check(user, target, affected, tool))
		return 0
	return 1

///////////////////////////////////////////////////////////////
// Scalpel Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/cut_open
	surgery_name = "Create Incision"
	allowed_tools = list(
		/obj/item/weapon/surgical/scalpel = 100,		\
		/obj/item/weapon/material/knife = 75,	\
		/obj/item/weapon/material/shard = 50, 		\
	)
	req_open = 0

	min_duration = 90
	max_duration = 110

/datum/surgery_step/generic/cut_open/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 0 && target_zone != O_MOUTH

/datum/surgery_step/generic/cut_open/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='filter_notice'>[user] starts the incision on [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='filter_notice'>You start the incision on [target]'s [affected.name] with \the [tool].</span>")
	target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected.name]!", 40)
	..()

/datum/surgery_step/generic/cut_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has made an incision on [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You have made an incision on [target]'s [affected.name] with \the [tool].</span>",)
	affected.open = 1

	if(istype(target) && target.should_have_organ(O_HEART))
		affected.status |= ORGAN_BLEEDING

	affected.createwound(CUT, 1)

/datum/surgery_step/generic/cut_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!</span>", \
	"<span class='danger'>Your hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!</span>")
	affected.createwound(CUT, 10)

///////////////////////////////////////////////////////////////
// Laser Scalpel Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/cut_with_laser
	surgery_name = "Create Bloodless Incision"
	allowed_tools = list(
		/obj/item/weapon/surgical/scalpel/laser3 = 100, \
		/obj/item/weapon/surgical/scalpel/laser2 = 100, \
		/obj/item/weapon/surgical/scalpel/laser1 = 100, \
		/obj/item/weapon/melee/energy/sword = 5
	)
	priority = 2
	req_open = 0
	min_duration = 90
	max_duration = 110
	excludes_steps = list(/datum/surgery_step/generic/cut_open)

/datum/surgery_step/generic/cut_with_laser/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 0 && target_zone != O_MOUTH

/datum/surgery_step/generic/cut_with_laser/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='filter_notice'>[user] starts the bloodless incision on [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='filter_notice'>You start the bloodless incision on [target]'s [affected.name] with \the [tool].</span>")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name]!", 50)
	..()

/datum/surgery_step/generic/cut_with_laser/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	affected.open = 1

	affected.createwound(CUT, 1)
	var/clamp_chance = 0 //I hate this. Make all laser scalpels a /laser subtype and give them a clamp_chance var???
	if(istype(tool,/obj/item/weapon/surgical/scalpel/laser1))
		clamp_chance = 75
	if(istype(tool,/obj/item/weapon/surgical/scalpel/laser2))
		clamp_chance = 85
	if(istype(tool,/obj/item/weapon/surgical/scalpel/laser3))
		clamp_chance = 95
	if(clamp_chance)
		affected.organ_clamp()
		user.visible_message("<span class='notice'>[user] has made a bloodless incision on [target]'s [affected.name] with \the [tool].</span>", \
		"<span class='notice'>You have made a bloodless incision on [target]'s [affected.name] with \the [tool].</span>",)
	else
		user.visible_message("<span class='notice'>[user] has made an incision on [target]'s [affected.name] with \the [tool], but blood is still escaping from the wound.</span>", \
		"<span class='notice'>You have made an incision on [target]'s [affected.name] with \the [tool], but blood is still coming from the wound..</span>",)
		//Could be cleaner ...

	spread_germs_to_organ(affected, user)

/datum/surgery_step/generic/cut_with_laser/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='danger'>Your hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!</span>")
	affected.createwound(CUT, 7.5)
	affected.createwound(BURN, 12.5)

///////////////////////////////////////////////////////////////
// Incision Management Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/incision_manager
	surgery_name = "Create Prepared Incision"
	allowed_tools = list(
		/obj/item/weapon/surgical/scalpel/manager = 100
	)

	priority = 2
	req_open = 0
	min_duration = 80
	max_duration = 120
	excludes_steps = list(/datum/surgery_step/generic/cut_open)

/datum/surgery_step/generic/incision_manager/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 0 && target_zone != O_MOUTH

/datum/surgery_step/generic/incision_manager/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='filter_notice'>[user] starts to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='filter_notice'>You start to construct a prepared incision on and within [target]'s [affected.name] with \the [tool].</span>")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name] as it is pushed apart!", 50)
	..()

/datum/surgery_step/generic/incision_manager/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] has constructed a prepared incision on and within [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You have constructed a prepared incision on and within [target]'s [affected.name] with \the [tool].</span>",)
	affected.open = 1

	if(istype(target) && target.should_have_organ(O_HEART))
		affected.status |= ORGAN_BLEEDING

	affected.createwound(CUT, 1)
	affected.organ_clamp()
	affected.open = 2

/datum/surgery_step/generic/incision_manager/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='danger'>Your hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!</span>")
	affected.createwound(CUT, 20)
	affected.createwound(BURN, 15)

///////////////////////////////////////////////////////////////
// Hemostat Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/clamp_bleeders
	surgery_name = "Clamp Bleeders"
	allowed_tools = list(
		/obj/item/weapon/surgical/hemostat = 100,	\
		/obj/item/stack/cable_coil = 75, 	\
		/obj/item/device/assembly/mousetrap = 20
	)

	min_duration = 40
	max_duration = 60

/datum/surgery_step/generic/clamp_bleeders/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open && (affected.status & ORGAN_BLEEDING)

/datum/surgery_step/generic/clamp_bleeders/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='filter_notice'>[user] starts clamping bleeders in [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='filter_notice'>You start clamping bleeders in [target]'s [affected.name] with \the [tool].</span>")
	target.custom_pain("The pain in your [affected.name] is maddening!", 40)
	..()

/datum/surgery_step/generic/clamp_bleeders/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] clamps bleeders in [target]'s [affected.name] with \the [tool].</span>",	\
	"<span class='notice'>You clamp bleeders in [target]'s [affected.name] with \the [tool].</span>")
	affected.organ_clamp()
	spread_germs_to_organ(affected, user)

/datum/surgery_step/generic/clamp_bleeders/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, tearing blood vessals and causing massive bleeding in [target]'s [affected.name] with \the [tool]!</span>",	\
	"<span class='danger'>Your hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.name] with \the [tool]!</span>",)
	affected.createwound(CUT, 10)

///////////////////////////////////////////////////////////////
// Retractor Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/retract_skin
	surgery_name = "Retract Skin"
	allowed_tools = list(
		/obj/item/weapon/surgical/retractor = 100,	\
		/obj/item/weapon/material/kitchen/utensil/fork = 50
	)

	allowed_procs = list(IS_CROWBAR = 75)

	min_duration = 30
	max_duration = 40

/datum/surgery_step/generic/retract_skin/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open == 1 //&& !(affected.status & ORGAN_BLEEDING)

/datum/surgery_step/generic/retract_skin/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "[user] starts to pry open the incision on [target]'s [affected.name] with \the [tool]."
	var/self_msg = "You start to pry open the incision on [target]'s [affected.name] with \the [tool]."
	if (target_zone == BP_TORSO)
		msg = "[user] starts to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
		self_msg = "You start to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
	if (target_zone == BP_GROIN)
		msg = "[user] starts to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
		self_msg = "You start to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
	user.visible_message("<span class='filter_notice'>[msg]</span>", "<span class='filter_notice'>[self_msg]</span>")
	target.custom_pain("It feels like the skin on your [affected.name] is on fire!", 40)
	..()

/datum/surgery_step/generic/retract_skin/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "<span class='notice'>[user] keeps the incision open on [target]'s [affected.name] with \the [tool].</span>"
	var/self_msg = "<span class='notice'>You keep the incision open on [target]'s [affected.name] with \the [tool].</span>"
	if (target_zone == BP_TORSO)
		msg = "<span class='notice'>[user] keeps the ribcage open on [target]'s torso with \the [tool].</span>"
		self_msg = "<span class='notice'>You keep the ribcage open on [target]'s torso with \the [tool].</span>"
	if (target_zone == BP_GROIN)
		msg = "<span class='notice'>[user] keeps the incision open on [target]'s lower abdomen with \the [tool].</span>"
		self_msg = "<span class='notice'>You keep the incision open on [target]'s lower abdomen with \the [tool].</span>"
	user.visible_message(msg, self_msg)
	affected.open = 2

/datum/surgery_step/generic/retract_skin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = "<span class='danger'>[user]'s hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!</span>"
	var/self_msg = "<span class='danger'>Your hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!</span>"
	if (target_zone == BP_TORSO)
		msg = "<span class='danger'>[user]'s hand slips, damaging several organs in [target]'s torso with \the [tool]!</span>"
		self_msg = "<span class='danger'>Your hand slips, damaging several organs in [target]'s torso with \the [tool]!</span>"
	if (target_zone == BP_GROIN)
		msg = "<span class='danger'>[user]'s hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]!</span>"
		self_msg = "<span class='danger'>Your hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]!</span>"
	user.visible_message(msg, self_msg)
	target.apply_damage(12, BRUTE, affected, sharp = TRUE)

///////////////////////////////////////////////////////////////
// Cauterize Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/cauterize
	surgery_name = "Cauterize Incision"
	allowed_tools = list(
		/obj/item/weapon/surgical/cautery = 100,			\
		/obj/item/clothing/mask/smokable/cigarette = 75,	\
		/obj/item/weapon/flame/lighter = 50,			\
		/obj/item/weapon/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

/datum/surgery_step/generic/cauterize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open && target_zone != O_MOUTH

/datum/surgery_step/generic/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='filter_notice'>[user] is beginning to cauterize the incision on [target]'s [affected.name] with \the [tool].</span>" , \
	"<span class='filter_notice'>You are beginning to cauterize the incision on [target]'s [affected.name] with \the [tool].</span>")
	target.custom_pain("Your [affected.name] is being burned!", 40)
	..()

/datum/surgery_step/generic/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] cauterizes the incision on [target]'s [affected.name] with \the [tool].</span>", \
	"<span class='notice'>You cauterize the incision on [target]'s [affected.name] with \the [tool].</span>")
	affected.open = 0
	affected.germ_level = 0
	affected.status &= ~ORGAN_BLEEDING

/datum/surgery_step/generic/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, leaving a small burn on [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='danger'>Your hand slips, leaving a small burn on [target]'s [affected.name] with \the [tool]!</span>")
	target.apply_damage(3, BURN, affected)

///////////////////////////////////////////////////////////////
// Amputation Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/amputate
	surgery_name = "Amputate Limb"
	allowed_tools = list(
		/obj/item/weapon/surgical/circular_saw = 100, \
		/obj/item/weapon/material/knife/machete/hatchet = 75
	)
	req_open = 0

	min_duration = 110
	max_duration = 160

/datum/surgery_step/generic/amputate/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if (target_zone == O_EYES)	//there are specific steps for eye surgery
		return 0
	if (!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (affected == null)
		return 0
	return !affected.cannot_amputate

/datum/surgery_step/generic/amputate/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='filter_notice'>[user] is beginning to amputate [target]'s [affected.name] with \the [tool].</span>" , \
	"<span class='filter_notice'>You are beginning to cut through [target]'s [affected.amputation_point] with \the [tool].</span>")
	target.custom_pain("Your [affected.amputation_point] is being ripped apart!", 100)
	..()

/datum/surgery_step/generic/amputate/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='notice'>[user] amputates [target]'s [affected.name] at the [affected.amputation_point] with \the [tool].</span>", \
	"<span class='notice'>You amputate [target]'s [affected.name] with \the [tool].</span>")
	affected.droplimb(1,DROPLIMB_EDGE)

/datum/surgery_step/generic/amputate/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message("<span class='danger'>[user]'s hand slips, sawing through the bone in [target]'s [affected.name] with \the [tool]!</span>", \
	"<span class='danger'>Your hand slips, sawwing through the bone in [target]'s [affected.name] with \the [tool]!</span>")
	affected.createwound(CUT, 30)
	affected.fracture()
