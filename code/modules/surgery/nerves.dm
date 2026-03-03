//Surgery that allows you to 'staple the nerves' of limbs, rendering them immune to pain.
//Bioregen is used as a placeholder tool. Don't enable this file until we have an actual tool.

/obj/item/organ/external
	var/rewire_nerves = 0	//Surgical stage for nerve stapling surgery.

/datum/surgery_step/stapled_nerves
	surgery_name = "Staple Nerves"
	can_infect = TRUE
	blood_level = 1
	req_open = TRUE

/datum/surgery_step/stapled_nerves/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!ishuman(target))
		return FALSE
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(!affected || (affected.robotic >= ORGAN_ROBOT))
		return FALSE
	if(coverage_check(user,target,affected,tool))
		return FALSE
	return affected.open >= FLESH_RETRACTED //You can do this at any time as long as the flesh is retracted.

/datum/surgery_step/stapled_nerves/step_one
	surgery_name = "Rearrange nerves"
	allowed_tools = list(
		/obj/item/surgical/bioregen = 100
	)
	min_duration = 300
	max_duration = 300

/datum/surgery_step/stapled_nerves/step_one/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.rewire_nerves == 0

/datum/surgery_step/stapled_nerves/step_one/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] begins to rearrange the nerves in [target]'s flesh with \the [tool]."), \
	span_notice("You begin to rearrange the nerves in [target]'s flesh with \the [tool]."))
	user.balloon_alert_visible("begins to rearrange the nerves in [target]'s flesh.", "rearranging nerves")
	..()

/datum/surgery_step/stapled_nerves/step_one/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] rearranges the nerves in [target]'s flesh with \the [tool]."), \
	span_notice("You rearrange the nerves in [target]'s flesh with \the [tool]."))
	user.balloon_alert_visible("rearranges the nerves in [target]'s flesh", "rearranged nerves")
	affected.rewire_nerves = 1
	..()

/datum/surgery_step/stapled_nerves/step_one/fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, and the misaligns the nerves with \the [tool]!"), \
	span_danger("Your hand slips, and you misalign the nerves with \the [tool]!"))
	user.balloon_alert_visible("slips, nerves being misaligned!", "your hand slips, misaligning nerves!")
	affected.createwound(CUT, 15)
	target.shock_stage += 100 //OUCH
	target.halloss += 200
	..()

/datum/surgery_step/stapled_nerves/step_two
	surgery_name = "Splice nerves"
	allowed_tools = list(
		/obj/item/surgical/bioregen = 100
	)
	min_duration = 300
	max_duration = 300

/datum/surgery_step/stapled_nerves/step_two/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.rewire_nerves == 1

/datum/surgery_step/stapled_nerves/step_two/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] begins to splice the nerves in [target]'s flesh with \the [tool]."), \
	span_notice("You begin to splice the nerves in [target]'s flesh with \the [tool]."))
	user.balloon_alert_visible("begins to splice the nerves in [target]'s flesh.", "rearranging nerves")
	..()

/datum/surgery_step/stapled_nerves/step_two/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] splices the nerves in [target]'s flesh with \the [tool]."), \
	span_notice("You splice the nerves in [target]'s flesh with \the [tool]."))
	user.balloon_alert_visible("splices the nerves in [target]'s flesh", "spliced nerves")
	affected.rewire_nerves = 2
	..()

/datum/surgery_step/stapled_nerves/step_two/fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, and the butchers the nerves with \the [tool]!"), \
	span_danger("Your hand slips, and you butcher the nerves with \the [tool]!"))
	user.balloon_alert_visible("slips, nerves being butchered!", "your hand slips, butchering nerves!")
	affected.createwound(CUT, 20)
	target.shock_stage += 50 //OUCH
	target.halloss += 200
	..()

/datum/surgery_step/stapled_nerves/step_three
	surgery_name = "Rewire nerves"
	allowed_tools = list(
		/obj/item/surgical/bioregen = 100
	)
	min_duration = 300
	max_duration = 300

/datum/surgery_step/stapled_nerves/step_three/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	return ..() && affected.rewire_nerves == 2

/datum/surgery_step/stapled_nerves/step_three/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	user.visible_message(span_notice("[user] begins to rewire the nerves in [target]'s flesh with \the [tool]."), \
	span_notice("You begin to rewire the nerves in [target]'s flesh with \the [tool]."))
	user.balloon_alert_visible("begins to rewire the nerves in [target]'s flesh.", "rearranging nerves")
	..()

/datum/surgery_step/stapled_nerves/step_three/end_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] rewires the nerves in [target]'s flesh with \the [tool]."), \
	span_notice("You rewire the nerves in [target]'s flesh with \the [tool]."))
	user.balloon_alert_visible("rewires the nerves in [target]'s flesh", "rewired nerves")
	affected.rewire_nerves = 0
	affected.stapled_nerves = TRUE
	..()

/datum/surgery_step/stapled_nerves/step_three/fail_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, and the improperly reroutes the nerves with \the [tool]!"), \
	span_danger("Your hand slips, and you improperly reroute the nerves with \the [tool]!"))
	user.balloon_alert_visible("slips, nerves being misaligned!", "your hand slips, misaligning nerves!")
	target.halloss += 50
	affected.rewire_nerves = 0 //Insult to injury. Go back to stage 1.
	..()
