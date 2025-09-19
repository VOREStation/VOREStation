// Behaves similar to straight jackets but the effects can be varied easily.
#define SHIBARI_NONE "None"
#define SHIBARI_ARMS "Arms"
#define SHIBARI_LEGS "Legs"
#define SHIBARI_BOTH "Arms and Legs"

/obj/item/clothing/suit/shibari
	name = "shibari bindings"
	desc = "A set of ropes that designed to be tied around another person to restrain them."
	icon_state = "shibari_None"

	var/resist_time = 1 MINUTE

	var/rope_mode = SHIBARI_NONE


/obj/item/clothing/suit/shibari/attack_hand(mob/living/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(src == H.wear_suit)
			to_chat(H, span_notice("You need help taking this off!"))
			return
	..()

/obj/item/clothing/suit/shibari/attack_self(mob/living/user)
	rope_mode = tgui_input_list(user, "Which limbs would you like to restrain with the bindings?", "Shibari", list(SHIBARI_NONE, SHIBARI_ARMS, SHIBARI_LEGS, SHIBARI_BOTH))
	if(!rope_mode)
		rope_mode = SHIBARI_NONE
	if(rope_mode == SHIBARI_BOTH)
		icon_state = "shibari_Both"
	else
		icon_state = "shibari_[rope_mode]"

/obj/item/clothing/suit/shibari/equipped(var/mob/living/user,var/slot)
	. = ..()
	if((rope_mode == SHIBARI_ARMS) || (rope_mode == SHIBARI_BOTH))
		if(slot == slot_wear_suit)
			if(user.get_left_hand() != src)
				user.drop_l_hand()
			if(user.get_right_hand() != src)
				user.drop_r_hand()
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.drop_from_inventory(H.handcuffed)
	if((rope_mode == SHIBARI_LEGS) || (rope_mode == SHIBARI_BOTH))
		if(slot == slot_wear_suit)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.drop_from_inventory(H.legcuffed)
				H.legcuffed = src
				if(user.m_intent != I_WALK)
					user.m_intent = I_WALK
					if(user.hud_used && user.hud_used.move_intent)
						user.hud_used.move_intent.icon_state = "walking"

/obj/item/clothing/suit/shibari/dropped(var/mob/living/user)
	..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.legcuffed == src)
			H.legcuffed = FALSE

/obj/item/clothing/suit/shibari/red
	color = "#ff0000"

/obj/item/clothing/suit/shibari/blue
	color = "#006aff"

/obj/item/clothing/suit/shibari/green
	color = "#00ff0d"

/obj/item/clothing/suit/shibari/yellow
	color = "#f6ff00"

/obj/item/clothing/suit/shibari/black
	color = "#000000"

/obj/item/clothing/suit/shibari/pink
	color = "#ff00bf"

#undef SHIBARI_NONE
#undef SHIBARI_ARMS
#undef SHIBARI_LEGS
#undef SHIBARI_BOTH
