#define HUMAN_EATING_NO_ISSUE		0
#define HUMAN_EATING_NO_MOUTH		1
#define HUMAN_EATING_BLOCKED_MOUTH	2

/mob/living/carbon/human/can_eat(var/food, var/feedback = 1)
	var/list/status = can_eat_status()
	if(status[1] == HUMAN_EATING_NO_ISSUE)
		return 1
	if(feedback)
		if(status[1] == HUMAN_EATING_NO_MOUTH)
			to_chat(src, "Where do you intend to put [food]? You don't have a mouth!")
		else if(status[1] == HUMAN_EATING_BLOCKED_MOUTH)
			to_chat(src, "<span class='warning'>\The [status[2]] is in the way!</span>")
	return 0

/mob/living/carbon/human/can_force_feed(var/feeder, var/food, var/feedback = 1)
	var/list/status = can_eat_status()
	if(status[1] == HUMAN_EATING_NO_ISSUE)
		return 1
	if(feedback)
		if(status[1] == HUMAN_EATING_NO_MOUTH)
			to_chat(feeder, "Where do you intend to put [food]? \The [src] doesn't have a mouth!")
		else if(status[1] == HUMAN_EATING_BLOCKED_MOUTH)
			to_chat(feeder, "<span class='warning'>\The [status[2]] is in the way!</span>")
	return 0

/mob/living/carbon/human/proc/can_eat_status()
	if(!check_has_mouth())
		return list(HUMAN_EATING_NO_MOUTH)
	var/obj/item/blocked = check_mouth_coverage()
	if(blocked)
		return list(HUMAN_EATING_BLOCKED_MOUTH, blocked)
	return list(HUMAN_EATING_NO_ISSUE)

/mob/living/carbon/human/proc/get_coverage()
	var/list/coverage = list()
	for(var/obj/item/clothing/C in src)
		if(item_is_in_hands(C))
			continue
		if(C.body_parts_covered & HEAD)
			coverage += list(organs_by_name[BP_HEAD])
		if(C.body_parts_covered & UPPER_TORSO)
			coverage += list(organs_by_name[BP_TORSO])
		if(C.body_parts_covered & LOWER_TORSO)
			coverage += list(organs_by_name[BP_GROIN])
		if(C.body_parts_covered & LEGS)
			coverage += list(organs_by_name[BP_L_LEG], organs_by_name[BP_R_LEG])
		if(C.body_parts_covered & ARMS)
			coverage += list(organs_by_name[BP_R_ARM], organs_by_name[BP_L_ARM])
		if(C.body_parts_covered & FEET)
			coverage += list(organs_by_name[BP_L_FOOT], organs_by_name[BP_R_FOOT])
		if(C.body_parts_covered & HANDS)
			coverage += list(organs_by_name[BP_L_HAND], organs_by_name[BP_R_HAND])
	return coverage


//This is called when we want different types of 'cloaks' to stop working, e.g. when attacking.
/mob/living/carbon/human/break_cloak()
	if(mind && mind.changeling) //Changeling visible camo
		mind.changeling.cloaked = 0
	if(istype(back, /obj/item/rig)) //Ninja cloak
		var/obj/item/rig/suit = back
		for(var/obj/item/rig_module/stealth_field/cloaker in suit.installed_modules)
			if(cloaker.active)
				cloaker.deactivate()
	for(var/obj/item/deadringer/dr in src)
		dr.uncloak()

/mob/living/carbon/human/is_cloaked()
	if(mind && mind.changeling && mind.changeling.cloaked) // Ling camo.
		return TRUE
	else if(istype(back, /obj/item/rig)) //Ninja cloak
		var/obj/item/rig/suit = back
		for(var/obj/item/rig_module/stealth_field/cloaker in suit.installed_modules)
			if(cloaker.active)
				return TRUE
	for(var/obj/item/deadringer/dr in src)
		if(dr.timer > 20)
			return TRUE
	return ..()

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

/mob/living/carbon/human/name_gender() /// Returns proper names for gender identites
	if(identifying_gender == "plural")
		return "other"
	if(identifying_gender == "neuter")
		return "none"
	else
		return get_gender()

// This is the 'mechanical' check for synthetic-ness, not appearance
// Returns the company that made the synthetic
/mob/living/carbon/human/isSynthetic()
	return synthetic

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
			if(istype(mmi_holder.stored_mmi, /obj/item/mmi/digital/posibrain))
				return FBP_POSI
			else if(istype(mmi_holder.stored_mmi, /obj/item/mmi/digital/robot))
				return FBP_DRONE
			else if(istype(mmi_holder.stored_mmi, /obj/item/mmi)) // This needs to come last because inheritence.
				return FBP_CYBORG

	return FBP_NONE

/mob/living/carbon/human/make_hud_overlays()
	hud_list[HEALTH_HUD]      = gen_hud_image(ingame_hud_med, src, "100", plane = PLANE_CH_HEALTH)
	if(isSynthetic())
		hud_list[STATUS_HUD]  = gen_hud_image(ingame_hud, src, "hudrobo", plane = PLANE_CH_STATUS)
		hud_list[LIFE_HUD]	  = gen_hud_image(ingame_hud, src, "hudrobo", plane = PLANE_CH_LIFE)
	else
		hud_list[STATUS_HUD]  = gen_hud_image(ingame_hud, src, "hudhealthy", plane = PLANE_CH_STATUS)
		hud_list[LIFE_HUD]    = gen_hud_image(ingame_hud, src, "hudhealthy", plane = PLANE_CH_LIFE)
	hud_list[ID_HUD]          = gen_hud_image(using_map.id_hud_icons, src, "hudunknown", plane = PLANE_CH_ID)
	hud_list[WANTED_HUD]      = gen_hud_image(ingame_hud, src, "hudblank", plane = PLANE_CH_WANTED)
	hud_list[IMPLOYAL_HUD]    = gen_hud_image(ingame_hud, src, "hudblank", plane = PLANE_CH_IMPLOYAL)
	hud_list[IMPCHEM_HUD]     = gen_hud_image(ingame_hud, src, "hudblank", plane = PLANE_CH_IMPCHEM)
	hud_list[IMPTRACK_HUD]    = gen_hud_image(ingame_hud, src, "hudblank", plane = PLANE_CH_IMPTRACK)
	hud_list[SPECIALROLE_HUD] = gen_hud_image(ingame_hud, src, "hudblank", plane = PLANE_CH_SPECIAL)
	hud_list[STATUS_HUD_OOC]  = gen_hud_image(ingame_hud, src, "hudhealthy", plane = PLANE_CH_STATUS_OOC)
	add_overlay(hud_list)

/mob/living/carbon/human/recalculate_vis()
	if(!vis_enabled || !plane_holder)
		return

	//These things are allowed to add vision flags.
	//If you code some crazy item that goes on your feet that lets you see ghosts, you need to add a slot here.
	var/list/slots = list(slot_glasses,slot_head)
	var/list/compiled_vis = list()

	if(CE_DARKSIGHT in chem_effects) //Putting this near the beginning so it can be overwritten by equipment
		compiled_vis += VIS_FULLBRIGHT

	for(var/slot in slots)
		var/obj/item/clothing/O = get_equipped_item(slot) //Change this type if you move the vision stuff to item or something.
		if(istype(O) && O.enables_planes && (slot in O.plane_slots))
			compiled_vis |= O.enables_planes

	//Check to see if we have a rig (ugh, blame rigs, desnowflake this)
	var/obj/item/rig/rig = get_rig()
	if(istype(rig) && rig.visor)
		if(!rig.helmet || (head && rig.helmet == head))
			if(rig.visor && rig.visor.vision && rig.visor.active && rig.visor.vision.glasses)
				var/obj/item/clothing/glasses/V = rig.visor.vision.glasses
				compiled_vis |= V.enables_planes

	//VOREStation Add - NIF Support
	if(nif)
		compiled_vis |= nif.planes_visible()
	//event hud
	if(vantag_hud)
		compiled_vis |= VIS_CH_VANTAG
	//VOREStation Add End

	//Vore Stomach addition start. This goes here.
	if(stomach_vision)
		compiled_vis += VIS_CH_STOMACH
	//Vore Stomach addition end

	if(!compiled_vis.len && !vis_enabled.len)
		return //Nothin' doin'.

	var/list/oddities = vis_enabled ^ compiled_vis
	if(!oddities.len)
		return //Same thing in both lists!

	var/list/to_enable = oddities - vis_enabled
	var/list/to_disable = oddities - compiled_vis

	for(var/vis in to_enable)
		plane_holder.set_vis(vis,TRUE)
		vis_enabled += vis
	for(var/vis in to_disable)
		plane_holder.set_vis(vis,FALSE)
		vis_enabled -= vis

/mob/living/carbon/human/get_restraining_bolt()
	var/obj/item/implant/restrainingbolt/RB

	for(var/obj/item/organ/external/EX in organs)
		RB = locate() in EX
		if(istype(RB) && !(RB.malfunction))
			break

	if(RB)
		if(!RB.malfunction)
			return TRUE

	return FALSE

#undef HUMAN_EATING_NO_ISSUE
#undef HUMAN_EATING_NO_MOUTH
#undef HUMAN_EATING_BLOCKED_MOUTH
