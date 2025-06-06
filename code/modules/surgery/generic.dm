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
		/obj/item/surgical/scalpel = 100,		\
		/obj/item/material/knife = 75,	\
		/obj/item/material/shard = 50, 		\
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
	user.visible_message(span_filter_notice("[user] starts the incision on [target]'s [affected.name] with \the [tool]."), \
	span_filter_notice("You start the incision on [target]'s [affected.name] with \the [tool]."))
	target.custom_pain("You feel a horrible pain as if from a sharp knife in your [affected.name]!", 40)
	user.balloon_alert_visible("starts to open an incision on [target]", "opening incision on \the [affected.name]")
	..()

/datum/surgery_step/generic/cut_open/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] has made an incision on [target]'s [affected.name] with \the [tool]."), \
	span_notice("You have made an incision on [target]'s [affected.name] with \the [tool]."),)
	user.balloon_alert_visible("opens an incision on [target]'s [affected.name]", "incision open on \the [affected.name]")
	affected.open = 1

	if(istype(target) && target.should_have_organ(O_HEART))
		affected.status |= ORGAN_BLEEDING

	affected.createwound(CUT, 1)

/datum/surgery_step/generic/cut_open/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!"), \
	span_danger("Your hand slips, slicing open [target]'s [affected.name] in the wrong place with \the [tool]!"))
	user.balloon_alert_visible("slips, slicing open \the [affected.name]", "your hand slips, slicing open [affected.name] in the wrong place.")
	affected.createwound(CUT, 10)

///////////////////////////////////////////////////////////////
// Laser Scalpel Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/cut_with_laser
	surgery_name = "Create Bloodless Incision"
	allowed_tools = list(
		/obj/item/surgical/scalpel/laser3 = 100, \
		/obj/item/surgical/scalpel/laser2 = 100, \
		/obj/item/surgical/scalpel/laser1 = 100, \
		/obj/item/melee/energy/sword = 5
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
	user.visible_message(span_filter_notice("[user] starts the bloodless incision on [target]'s [affected.name] with \the [tool]."), \
	span_filter_notice("You start the bloodless incision on [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("starts to open a bloodless incision on [target]", "opening a blodless incision on \the [affected.name]")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name]!", 50)
	..()

/datum/surgery_step/generic/cut_with_laser/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	affected.open = 1

	affected.createwound(CUT, 1)
	var/clamp_chance = 0 //I hate this. Make all laser scalpels a /laser subtype and give them a clamp_chance var???
	if(istype(tool,/obj/item/surgical/scalpel/laser1))
		clamp_chance = 75
	if(istype(tool,/obj/item/surgical/scalpel/laser2))
		clamp_chance = 85
	if(istype(tool,/obj/item/surgical/scalpel/laser3))
		clamp_chance = 95
	if(clamp_chance)
		affected.organ_clamp()
		user.visible_message(span_notice("[user] has made a bloodless incision on [target]'s [affected.name] with \the [tool]."), \
		span_notice("You have made a bloodless incision on [target]'s [affected.name] with \the [tool]."),)
		user.balloon_alert_visible("opens a bloodless incision on [target]'s [affected.name]", "bloodless incision open on \the [affected.name]")
	else
		user.visible_message(span_notice("[user] has made an incision on [target]'s [affected.name] with \the [tool], but blood is still escaping from the wound."), \
		span_notice("You have made an incision on [target]'s [affected.name] with \the [tool], but blood is still coming from the wound.."),)
		user.balloon_alert_visible("opens an incision on [target]'s [affected.name], blood still flowing", "incision open on \the [affected.name], but blood still flows")
		//Could be cleaner ...

	spread_germs_to_organ(affected, user)

/datum/surgery_step/generic/cut_with_laser/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!"), \
	span_danger("Your hand slips as the blade sputters, searing a long gash in [target]'s [affected.name] with \the [tool]!"))
	user.balloon_alert_visible("slips, searing a long gash on \the [affected.name]", "your hand slips, searing a long gash on [affected.name].")
	affected.createwound(CUT, 7.5)
	affected.createwound(BURN, 12.5)

///////////////////////////////////////////////////////////////
// Incision Management Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/incision_manager
	surgery_name = "Create Prepared Incision"
	allowed_tools = list(
		/obj/item/surgical/scalpel/manager = 100
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
	user.visible_message(span_filter_notice("[user] starts to construct a prepared incision on and within [target]'s [affected.name] with \the [tool]."), \
	span_filter_notice("You start to construct a prepared incision on and within [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("begins constructing a prepared incsion on [target]'s [affected.name]", "contructing prepared incision on \the [affected.name]")
	target.custom_pain("You feel a horrible, searing pain in your [affected.name] as it is pushed apart!", 50)
	..()

/datum/surgery_step/generic/incision_manager/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] has constructed a prepared incision on and within [target]'s [affected.name] with \the [tool]."), \
	span_notice("You have constructed a prepared incision on and within [target]'s [affected.name] with \the [tool]."),)
	user.balloon_alert_visible("constructs a prepared incision", "constructed prepared incision")
	affected.open = 1

	if(istype(target) && target.should_have_organ(O_HEART))
		affected.status |= ORGAN_BLEEDING

	affected.createwound(CUT, 1)
	affected.organ_clamp()
	affected.open = 2

/datum/surgery_step/generic/incision_manager/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!"), \
	span_danger("Your hand jolts as the system sparks, ripping a gruesome hole in [target]'s [affected.name] with \the [tool]!"))
	user.balloon_alert_visible("hand slips as the system sparks, ripping a gruesome hole in [target]'s [affected.name]", "your hand jolts as the system sparks, ripping a gruesome hole in \the [affected.name]")
	affected.createwound(CUT, 20)
	affected.createwound(BURN, 15)

///////////////////////////////////////////////////////////////
// Hemostat Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/clamp_bleeders
	surgery_name = "Clamp Bleeders"
	allowed_tools = list(
		/obj/item/surgical/hemostat = 100,	\
		/obj/item/stack/cable_coil = 75, 	\
		/obj/item/assembly/mousetrap = 20
	)

	min_duration = 40
	max_duration = 60

/datum/surgery_step/generic/clamp_bleeders/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open && (affected.status & ORGAN_BLEEDING)

/datum/surgery_step/generic/clamp_bleeders/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_filter_notice("[user] starts clamping bleeders in [target]'s [affected.name] with \the [tool]."), \
	span_filter_notice("You start clamping bleeders in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("starts clamping bleeders", "clamping bleders")
	target.custom_pain("The pain in your [affected.name] is maddening!", 40)
	..()

/datum/surgery_step/generic/clamp_bleeders/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] clamps bleeders in [target]'s [affected.name] with \the [tool]."),	\
	span_notice("You clamp bleeders in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("clamps bleeders", "clamped bleeders")
	affected.organ_clamp()
	spread_germs_to_organ(affected, user)

/datum/surgery_step/generic/clamp_bleeders/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.name] with \the [tool]!"),	\
	span_danger("Your hand slips, tearing blood vessels and causing massive bleeding in [target]'s [affected.name] with \the [tool]!"),)
	user.balloon_alert_visible("slips, tearing blood vessels and causing massive bleedings in [target]'s [affected.name]", "your hand slips, tearing blood vessels and causing massive bleedings in \the [affected.name]")
	affected.createwound(CUT, 10)

///////////////////////////////////////////////////////////////
// Retractor Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/retract_skin
	surgery_name = "Retract Skin"
	allowed_tools = list(
		/obj/item/surgical/retractor = 100,	\
		/obj/item/material/kitchen/utensil/fork = 50
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
	var/msgBall = "starts to pry open the incision on [target]'s [affected.name]"
	var/self_msgBall = "prying open the incision on [affected.name]"
	if (target_zone == BP_TORSO)
		msg = "[user] starts to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
		self_msg = "You start to separate the ribcage and rearrange the organs in [target]'s torso with \the [tool]."
		msgBall = "Starts to separate the ribcage and rearrange the organs in [target]'s torso."
		self_msgBall = "Separating ribcage and rearranging organs."
	if (target_zone == BP_GROIN)
		msg = "[user] starts to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
		self_msg = "you start to pry open the incision and rearrange the organs in [target]'s lower abdomen with \the [tool]."
		msgBall = "starts to pry open the incison and rearrange the organs in [target]'s lower abdomen"
	user.visible_message(span_filter_notice("[msg]"), span_filter_notice("[self_msg]"))
	user.balloon_alert_visible(msgBall, self_msgBall)
	target.custom_pain("It feels like the skin on your [affected.name] is on fire!", 40)
	..()

/datum/surgery_step/generic/retract_skin/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = span_notice("[user] keeps the incision open on [target]'s [affected.name] with \the [tool].")
	var/self_msg = span_notice("You keep the incision open on [target]'s [affected.name] with \the [tool].")
	var/msgBall = "keeps the incision open on [target]'s [affected.name]"
	var/self_msgBall = "keeping the incision open on \the [affected.name]"
	if (target_zone == BP_TORSO)
		msg = span_notice("[user] keeps the ribcage open on [target]'s torso with \the [tool].")
		self_msg = span_notice("You keep the ribcage open on [target]'s torso with \the [tool].")
		msgBall = "keeps the ribcage open on [target]'s torso."
		self_msgBall = "keeping the ribcage open."
	if (target_zone == BP_GROIN)
		msg = span_notice("[user] keeps the incision open on [target]'s lower abdomen with \the [tool].")
		self_msg = span_notice("You keep the incision open on [target]'s lower abdomen with \the [tool].")
		msgBall = "keeps the incision open on [target]'s lower abdomen."
		self_msgBall = "keeping the incision open on the lower abdomen."
	user.visible_message(msg, self_msg)
	user.balloon_alert_visible(msgBall, self_msgBall)
	affected.open = 2

/datum/surgery_step/generic/retract_skin/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	var/msg = span_danger("[user]'s hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!")
	var/self_msg = span_danger("Your hand slips, tearing the edges of the incision on [target]'s [affected.name] with \the [tool]!")
	var/msgBall = "slips, tearing the edges of the incision."
	var/self_msgBall = "your hand slips, tearing the edges of the incision."
	if (target_zone == BP_TORSO)
		msg = span_danger("[user]'s hand slips, damaging several organs in [target]'s torso with \the [tool]!")
		self_msg = span_danger("Your hand slips, damaging several organs in [target]'s torso with \the [tool]!")
		msgBall = "slips, damaging several organs in [target]'s torso."
		self_msgBall = "your hand slips, damaging several organs in the torso."
	if (target_zone == BP_GROIN)
		msg = span_danger("[user]'s hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]!")
		self_msg = span_danger("Your hand slips, damaging several organs in [target]'s lower abdomen with \the [tool]!")
		msgBall = "slips, damaging several organs in [target]'s lower abdomen."
		self_msgBall = "your hand slips, damaging several organs in the torso."
	user.visible_message(msg, self_msg)
	user.balloon_alert_visible(msgBall, self_msgBall)
	target.apply_damage(12, BRUTE, affected, sharp = TRUE)

///////////////////////////////////////////////////////////////
// Cauterize Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/cauterize
	surgery_name = "Cauterize Incision"
	allowed_tools = list(
		/obj/item/surgical/cautery = 100,			\
		/obj/item/clothing/mask/smokable/cigarette = 75,	\
		/obj/item/flame/lighter = 50,			\
		/obj/item/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

/datum/surgery_step/generic/cauterize/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.open && target_zone != O_MOUTH

/datum/surgery_step/generic/cauterize/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_filter_notice("[user] is beginning to cauterize the incision on [target]'s [affected.name] with \the [tool].") , \
	span_filter_notice("You are beginning to cauterize the incision on [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("begins to cauterize the incision on [target]'s [affected.name]", "cauterizing \the [affected.name]")
	target.custom_pain("Your [affected.name] is being burned!", 40)
	..()

/datum/surgery_step/generic/cauterize/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] cauterizes the incision on [target]'s [affected.name] with \the [tool]."), \
	span_notice("You cauterize the incision on [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("cauterizes the incision on [target]'s [affected.name]", "incison cauterized on \the [affected.name]")
	affected.open = 0
	affected.germ_level = 0
	affected.status &= ~ORGAN_BLEEDING

/datum/surgery_step/generic/cauterize/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, leaving a small burn on [target]'s [affected.name] with \the [tool]!"), \
	span_danger("Your hand slips, leaving a small burn on [target]'s [affected.name] with \the [tool]!"))
	user.balloon_alert_visible("slips, leaving a small burn on [target]'s [affected.name]", "your hand slips, leaving a small burn on \the [affected.name]")
	target.apply_damage(3, BURN, affected)

///////////////////////////////////////////////////////////////
// Amputation Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/generic/amputate
	surgery_name = "Amputate Limb"
	allowed_tools = list(
		/obj/item/surgical/circular_saw = 100, \
		/obj/item/material/knife/machete/hatchet = 75
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
	user.visible_message(span_filter_notice("[user] is beginning to amputate [target]'s [affected.name] with \the [tool].") , \
	span_filter_notice("You are beginning to cut through [target]'s [affected.amputation_point] with \the [tool]."))
	user.balloon_alert_visible("begins to amputate [target]'s [affected.name]", "amputating \the [affected.name]")
	target.custom_pain("Your [affected.amputation_point] is being ripped apart!", 100)
	..()

/datum/surgery_step/generic/amputate/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] amputates [target]'s [affected.name] at the [affected.amputation_point] with \the [tool]."), \
	span_notice("You amputate [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("amputates [target]'s [affected.name] at the [affected.amputation_point]", "amputated \the [affected.name]")
	affected.droplimb(1,DROPLIMB_EDGE)

/datum/surgery_step/generic/amputate/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, sawing through the bone in [target]'s [affected.name] with \the [tool]!"), \
	span_danger("Your hand slips, sawwing through the bone in [target]'s [affected.name] with \the [tool]!"))
	user.balloon_alert_visible("slips, sawing through the bone in [target]'s [affected.name]", "your hand slips, sawng through the bone in \the [affected.name]")
	affected.createwound(CUT, 30)
	affected.fracture()
