///////////////////////////////////////////////////////////////
// Hardsuit Removal Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/hardsuit
	surgery_name = "Remove Hardsuit"
	allowed_tools = list(
		/obj/item/pickaxe/plasmacutter = 100,
		/obj/item/weldingtool = 80,
		/obj/item/surgical/circular_saw = 60,
		)
	req_open = 0

	can_infect = 0
	blood_level = 0

	min_duration = 120
	max_duration = 180

/datum/surgery_step/hardsuit/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!istype(target))
		return 0
	if(istype(tool,/obj/item/weldingtool))
		var/obj/item/weldingtool/welder = tool
		if(!welder.isOn() || !welder.remove_fuel(1,user))
			return 0
	return (target_zone == BP_TORSO) && ((istype(target.back, /obj/item/rig) && !(target.back.canremove)) || (istype(target.belt, /obj/item/rig) && !(target.belt.canremove)))

/datum/surgery_step/hardsuit/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/rig/rig = target.back
	if(!istype(rig))
		rig = target.belt
		if(!istype(rig))
			return
	user.visible_message(span_filter_notice("[user] starts cutting through the support systems of \the [rig] on [target] with \the [tool].") , \
	span_filter_notice("You start cutting through the support systems of \the [rig] on [target] with \the [tool]."))
	user.balloon_alert_visible("starts cutting through the support systems of \the [rig] on [target]", "cutting through the support systems of \the [rig] on [target]")
	..()

/datum/surgery_step/hardsuit/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/rig/rig = target.back
	if(!istype(rig))
		rig = target.belt
		if(!istype(rig))
			return
	rig.cut_suit()
	user.visible_message(span_notice("[user] has cut through the support systems of \the [rig] on [target] with \the [tool]."), \
		span_notice("You have cut through the support systems of \the [rig] on [target] with \the [tool]."))
	user.balloon_alert_visible("cuts through the support systems of \the [rig] on [target]", "cut through the support systems of \the [rig]")

/datum/surgery_step/hardsuit/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_danger("[user]'s [tool] can't quite seem to get through the metal..."), \
	span_danger("\The [tool] can't quite seem to get through the metal. It's weakening, though - try again."))
	user.balloon_alert_visible("[tool] can't quite seem to get through the metal", "\the [tool] can't quite seem to get through the metal.")
