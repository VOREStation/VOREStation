/****************************************************
			   ORGAN DEFINES
****************************************************/

//Make sure that w_class is set as if the parent mob was medium sized! This is because w_class is adjusted automatically for mob_size in New()

/obj/item/organ/external/chest
	name = "upper body"
	organ_tag = BP_TORSO
	icon_name = "torso"
	max_damage = 100
	min_broken_damage = 35
	w_class = 5
	body_part = UPPER_TORSO
	vital = 1
	amputation_point = "spine"
	joint = "neck"
	dislocated = -1
	gendered_icon = 1
	cannot_amputate = 1
	parent_organ = null
	encased = "ribcage"
	organ_rel_size = 70
	base_miss_chance = 10

/obj/item/organ/external/chest/robotize()
	if(..())
		// Give them a new cell.
		owner.internal_organs_by_name["cell"] = new /obj/item/organ/internal/cell(owner,1)

/obj/item/organ/external/groin
	name = "lower body"
	organ_tag = BP_GROIN
	icon_name = "groin"
	max_damage = 100
	min_broken_damage = 35
	w_class = 4
	body_part = LOWER_TORSO
	vital = 1
	parent_organ = BP_TORSO
	amputation_point = "lumbar"
	joint = "hip"
	dislocated = -1
	gendered_icon = 1
	organ_rel_size = 30

/obj/item/organ/external/arm
	organ_tag = "l_arm"
	name = "left arm"
	icon_name = "l_arm"
	max_damage = 80
	min_broken_damage = 30
	w_class = 3
	body_part = ARM_LEFT
	parent_organ = BP_TORSO
	joint = "left elbow"
	amputation_point = "left shoulder"
	can_grasp = 1

/obj/item/organ/external/arm/right
	organ_tag = "r_arm"
	name = "right arm"
	icon_name = "r_arm"
	body_part = ARM_RIGHT
	joint = "right elbow"
	amputation_point = "right shoulder"

/obj/item/organ/external/leg
	organ_tag = "l_leg"
	name = "left leg"
	icon_name = "l_leg"
	max_damage = 80
	min_broken_damage = 30
	w_class = 3
	body_part = LEG_LEFT
	icon_position = LEFT
	parent_organ = BP_GROIN
	joint = "left knee"
	amputation_point = "left hip"
	can_stand = 1

/obj/item/organ/external/leg/right
	organ_tag = "r_leg"
	name = "right leg"
	icon_name = "r_leg"
	body_part = LEG_RIGHT
	icon_position = RIGHT
	joint = "right knee"
	amputation_point = "right hip"

/obj/item/organ/external/foot
	organ_tag = "l_foot"
	name = "left foot"
	icon_name = "l_foot"
	max_damage = 50
	min_broken_damage = 15
	w_class = 2
	body_part = FOOT_LEFT
	icon_position = LEFT
	parent_organ = "l_leg"
	joint = "left ankle"
	amputation_point = "left ankle"
	can_stand = 1

/obj/item/organ/external/foot/removed()
	if(owner)
		owner.drop_from_inventory(owner.shoes)
	..()

/obj/item/organ/external/foot/right
	organ_tag = "r_foot"
	name = "right foot"
	icon_name = "r_foot"
	body_part = FOOT_RIGHT
	icon_position = RIGHT
	parent_organ = "r_leg"
	joint = "right ankle"
	amputation_point = "right ankle"

/obj/item/organ/external/hand
	organ_tag = "l_hand"
	name = "left hand"
	icon_name = "l_hand"
	max_damage = 50
	min_broken_damage = 15
	w_class = 2
	body_part = HAND_LEFT
	parent_organ = "l_arm"
	joint = "left wrist"
	amputation_point = "left wrist"
	can_grasp = 1
	organ_rel_size = 10
	base_miss_chance = 50

/obj/item/organ/external/hand/removed()
	if(owner)
		owner.drop_from_inventory(owner.gloves)
	..()

/obj/item/organ/external/hand/right
	organ_tag = "r_hand"
	name = "right hand"
	icon_name = "r_hand"
	body_part = HAND_RIGHT
	parent_organ = "r_arm"
	joint = "right wrist"
	amputation_point = "right wrist"

/obj/item/organ/external/head
	organ_tag = BP_HEAD
	icon_name = "head"
	name = "head"
	slot_flags = SLOT_BELT
	max_damage = 75
	min_broken_damage = 35
	w_class = 3
	body_part = HEAD
	vital = 1
	parent_organ = BP_TORSO
	joint = "jaw"
	amputation_point = "neck"
	gendered_icon = 1
	cannot_gib = 1
	encased = "skull"
	base_miss_chance = 40
	var/can_intake_reagents = 1
	var/eye_icon = "eyes_s"

/obj/item/organ/external/head/robotize(var/company, var/skip_prosthetics, var/keep_organs)
	return ..(company, skip_prosthetics, 1)

/obj/item/organ/external/head/removed()
	if(owner)
		name = "[owner.real_name]'s head"
		owner.drop_from_inventory(owner.glasses)
		owner.drop_from_inventory(owner.head)
		owner.drop_from_inventory(owner.l_ear)
		owner.drop_from_inventory(owner.r_ear)
		owner.drop_from_inventory(owner.wear_mask)
		spawn(1)
			owner.update_hair()
	get_icon()
	..()

/obj/item/organ/external/head/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list())
	..(brute, burn, sharp, edge, used_weapon, forbidden_limbs)
	if (!disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")

/obj/item/organ/external/head/skrell
	eye_icon = "skrell_eyes_s"

/obj/item/organ/external/head/seromi
	eye_icon = "eyes_seromi"

/obj/item/organ/external/head/no_eyes
	eye_icon = "blank_eyes"
