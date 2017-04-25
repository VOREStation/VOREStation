#define HUMAN_EATING_NO_ISSUE		0
#define HUMAN_EATING_NO_MOUTH		1
#define HUMAN_EATING_BLOCKED_MOUTH	2

/mob/living/carbon/human/can_eat(var/food, var/feedback = 1)
	var/list/status = can_eat_status()
	if(status[1] == HUMAN_EATING_NO_ISSUE)
		return 1
	if(feedback)
		if(status[1] == HUMAN_EATING_NO_MOUTH)
			src << "Where do you intend to put \the [food]? You don't have a mouth!"
		else if(status[1] == HUMAN_EATING_BLOCKED_MOUTH)
			src << "<span class='warning'>\The [status[2]] is in the way!</span>"
	return 0

/mob/living/carbon/human/can_force_feed(var/feeder, var/food, var/feedback = 1)
	var/list/status = can_eat_status()
	if(status[1] == HUMAN_EATING_NO_ISSUE)
		return 1
	if(feedback)
		if(status[1] == HUMAN_EATING_NO_MOUTH)
			feeder << "Where do you intend to put \the [food]? \The [src] doesn't have a mouth!"
		else if(status[1] == HUMAN_EATING_BLOCKED_MOUTH)
			feeder << "<span class='warning'>\The [status[2]] is in the way!</span>"
	return 0

/mob/living/carbon/human/proc/can_eat_status()
	if(!check_has_mouth())
		return list(HUMAN_EATING_NO_MOUTH)
	var/obj/item/blocked = check_mouth_coverage()
	if(blocked)
		return list(HUMAN_EATING_BLOCKED_MOUTH, blocked)
	return list(HUMAN_EATING_NO_ISSUE)

//This is called when we want different types of 'cloaks' to stop working, e.g. when attacking.
/mob/living/carbon/human/break_cloak()
	if(mind && mind.changeling) //Changeling visible camo
		mind.changeling.cloaked = 0
	if(istype(back, /obj/item/weapon/rig)) //Ninja cloak
		var/obj/item/weapon/rig/suit = back
		for(var/obj/item/rig_module/stealth_field/cloaker in suit.installed_modules)
			if(cloaker.active)
				cloaker.deactivate()

/mob/living/carbon/human/get_ear_protection()
	var/sum = 0
	if(istype(l_ear, /obj/item/clothing/ears))
		var/obj/item/clothing/ears/L = l_ear
		sum += L.ear_protection
	if(istype(r_ear, /obj/item/clothing/ears))
		var/obj/item/clothing/ears/R = r_ear
		sum += R.ear_protection
	if(istype(head, /obj/item/clothing/head))
		var/obj/item/clothing/head/H = head
		sum += H.ear_protection
	return sum

/mob/living/carbon/human/get_gender()
	return identifying_gender ? identifying_gender : gender

// This is the 'mechanical' check for synthetic-ness, not appearance
// Returns the company that made the synthetic
/mob/living/carbon/human/isSynthetic()
	if(synthetic) return synthetic //Your synthetic-ness is not going away
	var/obj/item/organ/external/T = organs_by_name[BP_TORSO]
	if(T && T.robotic >= ORGAN_ROBOT)
		src.verbs += /mob/living/carbon/human/proc/self_diagnostics
		var/datum/robolimb/R = all_robolimbs[T.model]
		synthetic = R
		return synthetic

	return 0

// Would an onlooker know this person is synthetic?
// Based on sort of logical reasoning, 'Look at head, look at torso'
/mob/living/carbon/human/proc/looksSynthetic()
	var/obj/item/organ/external/T = organs_by_name[BP_TORSO]
	var/obj/item/organ/external/H = organs_by_name[BP_HEAD]

	//Look at their head
	if(!head || !(head && (head.flags_inv & HIDEFACE)))
		if(H && H.robotic == ORGAN_ROBOT) //Exactly robotic, not higher as lifelike is higher
			return 1

	//Look at their torso
	if(!wear_suit || (wear_suit && !(wear_suit.flags_inv & HIDEJUMPSUIT)))
		if(!w_uniform || (w_uniform && !(w_uniform.body_parts_covered & UPPER_TORSO)))
			if(T && T.robotic == ORGAN_ROBOT)
				return 1

	return 0

// Returns a string based on what kind of brain the FBP has.
/mob/living/carbon/human/proc/get_FBP_type()
	if(!isSynthetic())
		return FBP_NONE
	var/obj/item/organ/internal/brain/B
	B = internal_organs_by_name[O_BRAIN]
	if(B) // Incase we lost our brain for some reason, like if we got decapped.
		if(istype(B, /obj/item/organ/internal/mmi_holder))
			var/obj/item/organ/internal/mmi_holder/mmi_holder = B
			if(istype(mmi_holder.stored_mmi, /obj/item/device/mmi/digital/posibrain))
				return FBP_POSI
			else if(istype(mmi_holder.stored_mmi, /obj/item/device/mmi/digital/robot))
				return FBP_DRONE
			else if(istype(mmi_holder.stored_mmi, /obj/item/device/mmi)) // This needs to come last because inheritence.
				return FBP_CYBORG

	return FBP_NONE

#undef HUMAN_EATING_NO_ISSUE
#undef HUMAN_EATING_NO_MOUTH
#undef HUMAN_EATING_BLOCKED_MOUTH
