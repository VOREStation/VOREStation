/obj/item/clothing/gloves/arm_guard
	name = "arm guards"
	desc = "These arm guards will protect your hands and arms."
	body_parts_covered = HANDS|ARMS
	overgloves = 1
	w_class = ITEMSIZE_NORMAL

/obj/item/clothing/gloves/arm_guard/mob_can_equip(var/mob/living/carbon/human/H, slot, disable_warning = 0)
	if(..()) //This will only run if no other problems occured when equiping.
		if(H.wear_suit)
			if(H.wear_suit.body_parts_covered & ARMS)
				H << "<span class='warning'>You can't wear \the [src] with \the [H.wear_suit], it's in the way.</span>"
				return 0
		return 1

/obj/item/clothing/gloves/arm_guard/laserproof
	name = "ablative arm guards"
	desc = "These arm guards will protect your hands and arms from energy weapons."
	icon_state = "arm_guards_laser"
	item_state_slots = list(slot_r_hand_str = "swat", slot_l_hand_str = "swat")
	siemens_coefficient = 0.4 //This is worse than the other ablative pieces, to avoid this from becoming the poor warden's insulated gloves.
	armor = list(melee = 10, bullet = 10, laser = 80, energy = 50, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/gloves/arm_guard/bulletproof
	name = "bullet resistant arm guards"
	desc = "These arm guards will protect your hands and arms from ballistic weapons."
	icon_state = "arm_guards_bullet"
	item_state_slots = list(slot_r_hand_str = "swat", slot_l_hand_str = "swat")
	siemens_coefficient = 0.7
	armor = list(melee = 10, bullet = 80, laser = 10, energy = 50, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/gloves/arm_guard/riot
	name = "riot arm guards"
	desc = "These arm guards will protect your hands and arms from close combat weapons."
	icon_state = "arm_guards_riot"
	item_state_slots = list(slot_r_hand_str = "swat", slot_l_hand_str = "swat")
	siemens_coefficient = 0.5
	armor = list(melee = 80, bullet = 10, laser = 10, energy = 50, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/gloves/arm_guard/combat
	name = "combat arm guards"
	desc = "These arm guards will protect your hands and arms from a variety of weapons."
	icon_state = "arm_guards_combat"
	item_state_slots = list(slot_r_hand_str = "swat", slot_l_hand_str = "swat")
	siemens_coefficient = 0.6
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 30, bomb = 30, bio = 0, rad = 0)