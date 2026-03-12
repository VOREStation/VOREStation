// Micro Holders - Extends /obj/item/holder

/obj/item/holder/micro
	name = "micro"
	desc = "Another crewmember, small enough to fit in your hand."
	icon_state = "micro"
	icon_override = 'icons/inventory/head/mob.dmi'
	slot_flags = SLOT_FEET | SLOT_HEAD | SLOT_ID | SLOT_HOLSTER | SLOT_BACK
	w_class = ITEMSIZE_SMALL
	item_icons = null // No in-hand sprites (for now, anyway, we could totally add some)
	pixel_y = 0		  // Override value from parent.

/obj/item/holder/micro/Initialize(mapload, mob/held)
	. = ..()
	var/mob/living/carbon/human/H = held_mob
	if(istype(H) && H.species.get_bodytype() == SPECIES_TESHARI)
		item_icons = list(
					slot_l_hand_str = 'icons/mob/items/lefthand_toys.dmi',
					slot_r_hand_str = 'icons/mob/items/righthand_toys.dmi',
					slot_back_str = 'icons/mob/toy_worn.dmi',
					slot_head_str = 'icons/mob/toy_worn.dmi')

		// Leaving the following two set makes the sprite not visible
		icon_override = null
		sprite_sheets = null
		icon_state = "teshariplushie_white"
		item_state = "teshariplushie_white"

/obj/item/holder/micro/make_worn_icon(var/body_type,var/slot_name,var/inhands,var/default_icon,var/default_layer,var/icon/clip_mask = null)
	var/mob/living/carbon/human/H = held_mob
	// Only proceed if dealing with a tesh (or something shaped like a tesh)
	if(istype(H) && H.species.get_bodytype() == SPECIES_TESHARI)
		var/colortemp = color //save original color var to a temp var
		//convert numerical RGB to Hex #000000 format - is this necessary?
		//then 'inject' changed color (from skin color) into original proc call
		color = addtext("#", num2hex(H.r_skin, 2), num2hex(H.g_skin, 2), num2hex(H.b_skin, 2))
		. = ..()
		color = colortemp //reset color var to it's old value after original proc call before proceeding - otherwise we change hand-slot icon color too!
	else
		. = ..()

/obj/item/holder/examine(mob/user)
	SHOULD_CALL_PARENT(FALSE)
	. = list()
	for(var/mob/living/M in contents)
		. += M.examine(user)

/obj/item/holder/MouseDrop(mob/M)
	..()
	if(M != usr) return
	if(usr == src) return
	if(!Adjacent(usr)) return
	if(isAI(M)) return
	for(var/mob/living/carbon/human/O in contents)
		O.show_inventory_panel(usr, state = GLOB.tgui_deep_inventory_state)

/obj/item/holder/micro/attack_self(mob/living/carbon/user) //reworked so it works w/ nonhumans
	. = ..(user)
	if(.)
		return TRUE
	user.setClickCooldown(user.get_attack_speed())
	for(var/L in contents)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.help_shake_act(user)
		if(isanimal(L))
			var/mob/living/simple_mob/S = L
			user.visible_message(span_notice("[user] [S.response_help] \the [S]."))

//Egg features.
/obj/item/holder/attack_hand(mob/living/user as mob)
	if(istype(src.loc, /obj/item/storage/vore_egg)) //Don't scoop up the egged mob
		src.pickup(user)
		user.drop_from_inventory(src)
		return
	..()

/obj/item/holder/container_resist(mob/living/held)
	if(!istype(src.loc, /obj/item/storage/vore_egg))
		..()
	else
		var/obj/item/storage/vore_egg/E = src.loc
		if(isbelly(E.loc))
			var/obj/belly/B = E.loc
			B.relay_resist(held, E)
			return
		E.hatch(held)
		return
