///////////////////////////////////////////
//			De-Husking Surgery			//
/////////////////////////////////////////

/datum/surgery_status
	var/dehusk = 0

/datum/surgery_step/dehusk
	surgery_name = "Dehusk"
	priority = 1
	can_infect = 0
	blood_level = 1

/datum/surgery_step/dehusk/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if (!affected || (affected.robotic >= ORGAN_ROBOT))
		return 0
	if(coverage_check(user,target,affected,tool))
		return 0
	return target_zone == BP_TORSO && (HUSK in target.mutations)

/datum/surgery_step/dehusk/structinitial
	surgery_name = "Create Structure"
	allowed_tools = list(
		/obj/item/surgical/bioregen = 100,
		/obj/item/tape_roll = 25
	)
	min_duration = 90
	max_duration = 120

/datum/surgery_step/dehusk/structinitial/can_use(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.dehusk == 0

/datum/surgery_step/dehusk/structinitial/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] begins to create a fleshy but rigid looking mesh over gaps in [target]'s flesh with \the [tool]."), \
	span_notice("You begin to create a fleshy but rigid looking mesh over gaps in [target]'s flesh with \the [tool]."))
	user.balloon_alert_visible("begins to create a fleshy mesh over gaps in [target]'s flesh.", "creating a flesh mesh over gaps")
	..()

/datum/surgery_step/dehusk/structinitial/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] creates a fleshy but rigid looking mesh over gaps in [target]'s flesh with \the [tool]."), \
	span_notice("You create a fleshy but rigid looking mesh over gaps in [target]'s flesh with \the [tool]."))
	user.balloon_alert_visible("creates a fleshy mesh over gaps in [target]'s flesh", "created a fleshy mesh over gaps in the flesh")
	target.op_stage.dehusk = 1
	..()

/datum/surgery_step/dehusk/structinitial/fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, and the mesh falls, with \the [tool] scraping [target]'s body."), \
	span_danger("Your hand slips, and the mesh falls, with \the [tool] scraping [target]'s body."))
	user.balloon_alert_visible("slips, the mesh falls and scrapes [target]'s body", "your hand slips, the mesh falls and scrapes the body")
	affected.createwound(CUT, 15)
	affected.createwound(BRUISE, 10)
	..()

/datum/surgery_step/dehusk/relocateflesh
	surgery_name = "Relocate Flesh"
	allowed_tools = list(
		/obj/item/surgical/hemostat = 100,	\
		/obj/item/stack/cable_coil = 75, 	\
		/obj/item/assembly/mousetrap = 20
	)
	min_duration = 90
	max_duration = 120

/datum/surgery_step/dehusk/relocateflesh/can_use(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.dehusk == 1

/datum/surgery_step/dehusk/relocateflesh/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] begins to relocate some of [target]'s flesh with \the [tool], using it to fill in gaps."), \
	span_notice("You begin to relocate some of [target]'s flesh with \the [tool], using it to fill in gaps."))
	user.balloon_alert_visible("begins relocating [target]'s flesh", "relocating the flesh")
	..()

/datum/surgery_step/dehusk/relocateflesh/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] relocates some of [target]'s flesh with \the [tool], using it to fill in gaps."), \
	span_notice("You relocate some of [target]'s flesh with \the [tool], using it to fill in gaps."))
	user.balloon_alert_visible("relocates [target]'s flesh", "relocated the flesh")
	target.op_stage.dehusk = 2
	..()

/datum/surgery_step/dehusk/relocateflesh/fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user] accidentally rips a massive chunk out of [target]'s flesh with \the [tool], causing massive damage."), \
	span_danger("You accidentally rip a massive chunk out of [target]'s flesh with \the [tool], causing massive damage."))
	user.balloon_alert_visible("accidentally rips a massive chunk out of [target]'s flesh, causing massive damage",
	"you accidentally rip a massive chunk out of the flesh, causing massive damage")
	affected.createwound(CUT, 25)
	affected.createwound(BRUISE, 10)
	..()

/datum/surgery_step/dehusk/structfinish
	surgery_name = "Finish Structure"
	allowed_tools = list(
		/obj/item/surgical/bioregen = 100, \
		/obj/item/surgical/FixOVein = 100, \
		/obj/item/stack/cable_coil = 75
	)
	min_duration = 90
	max_duration = 120

/datum/surgery_step/dehusk/structfinish/can_use(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target.op_stage.dehusk == 2

/datum/surgery_step/dehusk/structfinish/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(istype(tool,/obj/item/surgical/bioregen))
		user.visible_message(span_notice("[user] begins to recreate blood vessels and fill in the gaps in [target]'s flesh with \the [tool]."), \
	span_notice("You begin to recreate blood vessels and fill in the gaps in [target]'s flesh with \the [tool]."))
		user.balloon_alert_visible("begins recreating blood vessels and filing gaps in [target]'s flesh", "recreating blood vessels and filling gaps in the flesh")
	else if(istype(tool,/obj/item/surgical/FixOVein))
		user.visible_message(span_notice("[user] attempts to recreate blood vessels and fill in the gaps in [target]'s flesh with \the [tool]."), \
	span_notice("You attempt to recreate blood vessels and fill in the gaps in [target]'s flesh with \the [tool]."))
		user.balloon_alert_visible("attempts to recreate blood vessesl and fill the gaps in [target]'s flesh", "attempting to recreate blood vessels and fill gaps in the flesh")
	..()

/datum/surgery_step/dehusk/structfinish/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] finishes recreating the missing biological structures and filling in gaps in [target]'s flesh with \the [tool]."), \
	span_notice("You finish recreating the missing biological structures and filling in gaps in [target]'s flesh with \the [tool]."))
	user.balloon_alert_visible("recreates the missing biological structures and gaps in [target]'s flesh", "recreated the missing bological structures and gaps in the flesh")
	target.op_stage.dehusk = 0
	target.mutations.Remove(HUSK)
	target.status_flags &= ~DISFIGURED
	target.update_icons_body()
	..()

/datum/surgery_step/dehusk/structfinish/fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(istype(tool,/obj/item/surgical/bioregen))
		user.visible_message(span_danger("[user]'s hand slips, causing \the [tool] to scrape [target]'s body."), \
	span_danger("Your hand slips, causing \the [tool] to scrape [target]'s body."))
		user.balloon_alert_visible("slips, scraping [target]'s body", "you slip, scraping the body.")
	else if(istype(tool,/obj/item/surgical/FixOVein))
		user.visible_message(span_danger("[user] fails to finish the structure over the gaps in [target]'s flesh, doing more damage than good."), \
	span_danger("You fail to finish the structure over the gaps in [target]'s flesh, doing more damage than good."))
		user.balloon_alert_visible("fails to finish the structure in [target]'s flesh, doing more damage", "you fail to finish the structur, doing more damage")

	affected.createwound(CUT, 15)
	affected.createwound(BRUISE, 10)
	..()
