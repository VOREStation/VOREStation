//////////////////////////////////////////////////////////////////
//					INTERNAL WOUND PATCHING						//
//////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////
// Internal Bleeding Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/fix_vein
	surgery_name = "Fix Vein"
	priority = 2
	allowed_tools = list(
	/obj/item/surgical/FixOVein = 100, \
	/obj/item/stack/cable_coil = 75
	)
	can_infect = 1
	blood_level = 1

	min_duration = 70
	max_duration = 90

/datum/surgery_step/fix_vein/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return 0

	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected) return
	if(coverage_check(user, target, affected, tool))
		return 0
	var/internal_bleeding = 0
	for(var/datum/wound/W in affected.wounds) if(W.internal)
		internal_bleeding = 1
		break

	return affected.open == (affected.encased ? 3 : 2) && internal_bleeding

/datum/surgery_step/fix_vein/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_filter_notice("[user] starts patching the damaged vein in [target]'s [affected.name] with \the [tool].") , \
	span_filter_notice("You start patching the damaged vein in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("starts patching the damaged ven in [target]'s [affected.name]", "patching the damaged vein in \the [affected.name]")
	target.custom_pain("The pain in [affected.name] is unbearable!", 100)
	..()

/datum/surgery_step/fix_vein/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] has patched the damaged vein in [target]'s [affected.name] with \the [tool]."), \
		span_notice("You have patched the damaged vein in [target]'s [affected.name] with \the [tool]."))
	user.balloon_alert_visible("patches the damaged vein in [target]'s [affected.name]", "patched the damaged vein in \the [affected.name]")

	for(var/datum/wound/W in affected.wounds) if(W.internal)
		affected.wounds -= W
		affected.update_damages()
	if (ishuman(user) && prob(40)) user:bloody_hands(target, 0)

/datum/surgery_step/fix_vein/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, smearing [tool] in the incision in [target]'s [affected.name]!") , \
	span_danger("Your hand slips, smearing [tool] in the incision in [target]'s [affected.name]!"))
	user.balloon_alert_visible("slips, smearing [tool] in the incision in [target]'s [affected.name]", "your hand slips, smearing [tool] in the incisiom in [affected.name]")
	affected.take_damage(5, 0)

/datum/surgery_step/internal/detoxify
	surgery_name = "Detoxify"
	blood_level = 1
	allowed_tools = list(/obj/item/surgical/bioregen=100)
	min_duration = 90
	max_duration = 120

/datum/surgery_step/internal/detoxify/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	return ..() && target_zone == BP_TORSO && (target.toxloss || target.oxyloss || target.cloneloss)

/datum/surgery_step/internal/detoxify/begin_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] begins to pull toxins from, and restore oxygen to [target]'s musculature and organs with \the [tool]."), \
	span_notice("You begin to pull toxins from, and restore oxygen to [target]'s musculature and organs with \the [tool]."))
	user.balloon_alert_visible("begins pulling from, and restoring oxygen to [target]'s organs", "pulling toxins from and restoring oxygen to the organs")
	..()

/datum/surgery_step/internal/detoxify/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] finishes pulling toxins from, and restoring oxygen to [target]'s musculature and organs with \the [tool]."), \
	span_notice("You finish pulling toxins from, and restoring oxygen to [target]'s musculature and organs with \the [tool]."))
	user.balloon_alert_visible("finishes pulling toxins and restoring oxygen to [target]'s organs", "pulled toxins from and restored oxygen to the organs")
	target.adjustToxLoss(-20)
	target.adjustOxyLoss(-20)
	target.adjustCloneLoss(-20)
	..()

/datum/surgery_step/internal/detoxify/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, failing to finish the surgery, and damaging [target] with \the [tool]."), \
	span_danger("Your hand slips, failing to finish the surgery, and damaging [target] with \the [tool]."))
	user.balloon_alert_visible("slips, failing to finish the surgery and damaging [target]", "your hand slips, failing to finish the surgery and damaging [target]")
	affected.createwound(CUT, 15)
	affected.createwound(BRUISE, 10)
	..()
