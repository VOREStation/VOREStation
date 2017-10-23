//Procedures in this file: Robotic limbs attachment, meat limbs attachment
//////////////////////////////////////////////////////////////////
//						LIMB SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/limb/
	priority = 3 // Must be higher than /datum/surgery_step/internal
	req_open = 0
	can_infect = 0
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (affected)
			return 0
		var/list/organ_data = target.species.has_limbs["[target_zone]"]
		return !isnull(organ_data)

/datum/surgery_step/limb/attach
	allowed_tools = list(/obj/item/organ/external = 100)

	min_duration = 50
	max_duration = 70

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = tool
		var/obj/item/organ/external/P = target.organs_by_name[E.parent_organ]
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (affected)
			to_chat(user, "<span class='warning'>Something is in the way! You can't attach [E] here!</span>")
			return 0
		if(!P)
			to_chat(user, "<span class='warning'>There's nothing to attach [E] to!</span>")
			return 0
		else if((P.robotic >= ORGAN_ROBOT) && (E.robotic < ORGAN_ROBOT))
			to_chat(user, "<span class='warning'>Attaching [E] to [P] wouldn't work well.</span>")
			return 0
		else if(istype(E, /obj/item/organ/external/head) && E.robotic >= ORGAN_ROBOT && P.robotic < ORGAN_ROBOT)
			to_chat(user, "<span class='warning'>Attaching [E] to [P] might break [E].</span>")
			return 0
		else
			return 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = tool
		user.visible_message("[user] starts attaching [E.name] to [target]'s [E.amputation_point].", \
		"You start attaching [E.name] to [target]'s [E.amputation_point].")

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = tool
		user.visible_message("<span class='notice'>[user] has attached [target]'s [E.name] to the [E.amputation_point].</span>",	\
		"<span class='notice'>You have attached [target]'s [E.name] to the [E.amputation_point].</span>")
		user.drop_from_inventory(E)
		E.replaced(target)
		target.update_body()
		target.updatehealth()
		target.UpdateDamageIcon()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = tool
		user.visible_message("<span class='warning'> [user]'s hand slips, damaging [target]'s [E.amputation_point]!</span>", \
		"<span class='warning'> Your hand slips, damaging [target]'s [E.amputation_point]!</span>")
		target.apply_damage(10, BRUTE, null, sharp=1)

/datum/surgery_step/limb/connect
	allowed_tools = list(
	/obj/item/weapon/surgical/hemostat = 100,	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 20
	)
	can_infect = 1

	min_duration = 100
	max_duration = 120

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = target.get_organ(target_zone)
		return E && !E.is_stump() && (E.status & ORGAN_DESTROYED)

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = target.get_organ(target_zone)
		user.visible_message("[user] starts connecting tendons and muscles in [target]'s [E.amputation_point] with [tool].", \
		"You start connecting tendons and muscle in [target]'s [E.amputation_point].")

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = target.get_organ(target_zone)
		user.visible_message("<span class='notice'>[user] has connected tendons and muscles in [target]'s [E.amputation_point] with [tool].</span>",	\
		"<span class='notice'>You have connected tendons and muscles in [target]'s [E.amputation_point] with [tool].</span>")
		E.status &= ~ORGAN_DESTROYED
		if(E.children)
			for(var/obj/item/organ/external/C in E.children)
				C.status &= ~ORGAN_DESTROYED
		target.update_body()
		target.updatehealth()
		target.UpdateDamageIcon()

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/external/E = tool
		user.visible_message("<span class='warning'> [user]'s hand slips, damaging [target]'s [E.amputation_point]!</span>", \
		"<span class='warning'> Your hand slips, damaging [target]'s [E.amputation_point]!</span>")
		target.apply_damage(10, BRUTE, null, sharp=1)

/datum/surgery_step/limb/mechanize
	allowed_tools = list(/obj/item/robot_parts = 100)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if(..())
			var/obj/item/robot_parts/p = tool
			if (p.part)
				if (!(target_zone in p.part))
					return 0
			return isnull(target.get_organ(target_zone))

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts attaching \the [tool] to [target].", \
		"You start attaching \the [tool] to [target].")

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/robot_parts/L = tool
		user.visible_message("<span class='notice'>[user] has attached \the [tool] to [target].</span>",	\
		"<span class='notice'>You have attached \the [tool] to [target].</span>")

		if(L.part)
			for(var/part_name in L.part)
				if(!isnull(target.get_organ(part_name)))
					continue
				var/list/organ_data = target.species.has_limbs["[part_name]"]
				if(!organ_data)
					continue
				var/new_limb_type = organ_data["path"]
				var/obj/item/organ/external/new_limb = new new_limb_type(target)
				new_limb.robotize(L.model_info)
				if(L.sabotaged)
					new_limb.sabotaged = 1

		target.update_body()
		target.updatehealth()
		target.UpdateDamageIcon()

		qdel(tool)

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='warning'> [user]'s hand slips, damaging [target]'s flesh!</span>", \
		"<span class='warning'> Your hand slips, damaging [target]'s flesh!</span>")
		target.apply_damage(10, BRUTE, null, sharp=1)
