//Procedures in this file: Putting items in body cavity. Implant removal. Items removal.

//////////////////////////////////////////////////////////////////
//					ITEM PLACEMENT SURGERY						//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/cavity
	surgery_name = "Cavity"
	priority = 1

/datum/surgery_step/cavity/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!hasorgans(target))
		return 0
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(coverage_check(user, target, affected, tool))
		return 0
	return affected && affected.open == (affected.encased ? 3 : 2) && !(affected.status & ORGAN_BLEEDING)

/datum/surgery_step/cavity/proc/get_max_wclass(var/obj/item/organ/external/affected)
	switch (affected.organ_tag)
		if (BP_HEAD)
			return ITEMSIZE_TINY
		if (BP_TORSO)
			return ITEMSIZE_NORMAL
		if (BP_GROIN)
			return ITEMSIZE_SMALL
	return 0

/datum/surgery_step/cavity/proc/get_cavity(var/obj/item/organ/external/affected)
	switch (affected.organ_tag)
		if (BP_HEAD)
			return "cranial"
		if (BP_TORSO)
			return "thoracic"
		if (BP_GROIN)
			return "abdominal"
	return ""

/datum/surgery_step/cavity/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(span_danger("[user]'s hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!"), \
	span_danger("Your hand slips, scraping around inside [target]'s [affected.name] with \the [tool]!"))
	affected.createwound(CUT, 20)

///////////////////////////////////////////////////////////////
// Space Making Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/cavity/make_space
	surgery_name = "Create Cavity"
	allowed_tools = list(
		/obj/item/surgical/surgicaldrill = 100,	\
		/obj/item/pen = 75,	\
		/obj/item/stack/rods = 50
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/cavity/make_space/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && !affected.cavity

/datum/surgery_step/cavity/make_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_filter_notice("[user] starts making some space inside [target]'s [get_cavity(affected)] cavity with \the [tool]."), \
	span_filter_notice("You start making some space inside [target]'s [get_cavity(affected)] cavity with \the [tool].") )
	target.custom_pain("The pain in your chest is living hell!",1)
	affected.cavity = 1
	..()

/datum/surgery_step/cavity/make_space/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] makes some space inside [target]'s [get_cavity(affected)] cavity with \the [tool]."), \
	span_notice("You make some space inside [target]'s [get_cavity(affected)] cavity with \the [tool].") )

///////////////////////////////////////////////////////////////
// Cavity Closing Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/cavity/close_space
	surgery_name = "Close Cavity"
	priority = 2
	allowed_tools = list(
		/obj/item/surgical/cautery = 100,			\
		/obj/item/clothing/mask/smokable/cigarette = 75,	\
		/obj/item/flame/lighter = 50,			\
		/obj/item/weldingtool = 25
	)

	min_duration = 60
	max_duration = 80

/datum/surgery_step/cavity/close_space/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		return affected && affected.cavity

/datum/surgery_step/cavity/close_space/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_filter_notice("[user] starts mending [target]'s [get_cavity(affected)] cavity wall with \the [tool]."), \
	span_filter_notice("You start mending [target]'s [get_cavity(affected)] cavity wall with \the [tool].") )
	target.custom_pain("The pain in your chest is living hell!",1)
	affected.cavity = 0
	..()

/datum/surgery_step/cavity/close_space/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] mends [target]'s [get_cavity(affected)] cavity walls with \the [tool]."), \
	span_notice(" You mend[target]'s [get_cavity(affected)] cavity walls with \the [tool].") )

///////////////////////////////////////////////////////////////
// Item Implantation Surgery
///////////////////////////////////////////////////////////////

/datum/surgery_step/cavity/place_item
	surgery_name = "Implant Object"
	priority = 0
	allowed_tools = list(/obj/item = 100)

	min_duration = 80
	max_duration = 100

/datum/surgery_step/cavity/place_item/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	if(!istype(tool))
		return 0
	if(..())
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if(istype(user,/mob/living/silicon/robot))
			if(istype(tool, /obj/item/gripper))
				var/obj/item/gripper/Gripper = tool
				if(Gripper.wrapped)
					tool = Gripper.wrapped
				else
					return
			else
				return
		if(affected && affected.cavity)
			var/total_volume = tool.w_class
			for(var/obj/item/I in affected.implants)
				if(istype(I,/obj/item/implant))
					continue
				total_volume += I.w_class
			return total_volume <= get_max_wclass(affected)

/datum/surgery_step/cavity/place_item/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(isrobot(user) && istype(tool, /obj/item/gripper))
		var/obj/item/gripper/G = tool
		tool = G.wrapped
	user.visible_message(span_notice("[user] starts putting \the [tool] inside [target]'s [get_cavity(affected)] cavity."), \
	span_notice("You start putting \the [tool] inside [target]'s [get_cavity(affected)] cavity.") ) //Nobody will probably ever see this, but I made these two blue. ~CK
	target.custom_pain("The pain in your chest is living hell!",1)
	..()

/datum/surgery_step/cavity/place_item/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	if(isrobot(user) && istype(tool, /obj/item/gripper))
		var/obj/item/gripper/G = tool
		tool = G.wrapped
		G.drop_item()
	else
		user.drop_item()
	user.visible_message(span_notice("[user] puts \the [tool] inside [target]'s [get_cavity(affected)] cavity."), \
	span_notice("You put \the [tool] inside [target]'s [get_cavity(affected)] cavity.") )
	if (tool.w_class > get_max_wclass(affected)/2 && prob(50) && (affected.robotic < ORGAN_ROBOT))
		to_chat(user, span_danger(" You tear some blood vessels trying to fit such a big object in this cavity."))
		var/datum/wound/internal_bleeding/I = new (10)
		affected.wounds += I
		affected.owner.custom_pain("You feel something rip in your [affected.name]!", 1)
	affected.implants += tool
	tool.loc = affected
	if(istype(tool,/obj/item/nif)){var/obj/item/nif/N = tool;N.implant(target)} //VOREStation Add - NIF support
	affected.cavity = 0

//////////////////////////////////////////////////////////////////
//					IMPLANT/ITEM REMOVAL SURGERY
//////////////////////////////////////////////////////////////////

/datum/surgery_step/cavity/implant_removal
	surgery_name = "Remove Implant"
	allowed_tools = list(
		/obj/item/surgical/hemostat = 100,	\
		/obj/item/material/kitchen/utensil/fork = 20
	)

	allowed_procs = list(IS_WIRECUTTER = 75)

	min_duration = 80
	max_duration = 100

/datum/surgery_step/cavity/implant_removal/can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	if(affected.organ_tag == BP_HEAD)
		var/obj/item/organ/internal/brain/sponge = target.internal_organs_by_name["brain"]
		return ..() && (!sponge || !sponge.damage)
	else
		return ..()

/datum/surgery_step/cavity/implant_removal/begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/affected = target.get_organ(target_zone)
	user.visible_message(span_notice("[user] starts poking around inside [target]'s [affected.name] with \the [tool]."), \
	span_notice("You start poking around inside [target]'s [affected.name] with \the [tool].") )
	target.custom_pain("The pain in your [affected.name] is living hell!",1)
	..()

/datum/surgery_step/cavity/implant_removal/end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)

	if (affected.implants.len)

		var/obj/item/obj = tgui_input_list(user, "Which embedded item do you wish to remove?", "Surgery Select", affected.implants)
		if(isnull(obj)) //They clicked cancel.
			user.visible_message(span_notice("[user] takes \the [tool] out of [target]'s [affected.name]."), \
			span_notice("You take \the [tool] out of the incision on [target]'s [affected.name].") )
			return
		if(!do_mob(user, target, 1)) //They moved away
			to_chat(user, span_warning("You must remain close to and keep focused on your patient to conduct surgery."))
			user.visible_message(span_notice("[user] fails to remove anything from [target]'s [affected.name] with \the [tool]!"), \
			span_notice("You fail to remove the [obj] from [target]'s [affected.name]s with \the [tool]!") )
			return

		if(istype(obj,/obj/item/implant))
			var/obj/item/implant/imp = obj
			if (!imp.islegal()) //ILLEGAL IMPLANT ALERT!!!!!!!!!!
				user.visible_message(span_notice("[user] seems to be intently working on something within [target]'s [affected.name] with \the [tool]!"), \
				span_notice("You intently begin to take [obj] out of the incision on [target]'s [affected.name]s with \the [tool]!") )
				if(!do_after(user, min_duration, target))
					user.visible_message(span_notice("[user] fails to remove anything from [target]'s [affected.name] with \the [tool]!"), \
					span_notice("You fail to remove the [obj] from [target]'s [affected.name]s with \the [tool]!") )
					return


		user.visible_message(span_notice("[user] takes something out of the incision on [target]'s [affected.name] with \the [tool]!"), \
		span_notice("You take [obj] out of the incision on [target]'s [affected.name]s with \the [tool]!") )
		affected.implants -= obj
		if(!target.has_embedded_objects())
			target.clear_alert("embeddedobject")

		BITSET(target.hud_updateflag, IMPLOYAL_HUD)

		//Handle possessive brain borers.
		if(istype(obj,/mob/living/simple_mob/animal/borer))
			var/mob/living/simple_mob/animal/borer/worm = obj
			if(worm.controlling)
				target.release_control()
			worm.detatch()
			worm.leave_host()
		else
			obj.loc = get_turf(target)
			obj.add_blood(target)
			obj.update_icon()
			if(istype(obj,/obj/item/implant))
				var/obj/item/implant/imp = obj
				imp.imp_in = null
				imp.implanted = 0
			else if(istype(tool,/obj/item/nif)){var/obj/item/nif/N = tool;N.unimplant(target)} //VOREStation Add - NIF support
	else
		user.visible_message(span_notice("[user] could not find anything inside [target]'s [affected.name], and pulls \the [tool] out."), \
		span_notice("You could not find anything inside [target]'s [affected.name].") )

/datum/surgery_step/cavity/implant_removal/fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
	..()
	var/obj/item/organ/external/chest/affected = target.get_organ(target_zone)
	if (affected.implants.len)
		var/fail_prob = 10
		fail_prob += 100 - tool_quality(tool)
		if (prob(fail_prob))
			var/obj/item/implant/imp = affected.implants[1]
			user.visible_message(span_danger(" Something beeps inside [target]'s [affected.name]!"))
			playsound(imp, 'sound/items/countdown.ogg', 75, 1, -3)
			spawn(25)
				imp.activate()
