/obj/item/cane
	name = "cane"
	desc = "A cane used by a true gentleman."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_melee.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_melee.dmi',
			)
	force = 5.0
	throwforce = 7.0
	w_class = ITEMSIZE_NORMAL
	matter = list(MAT_STEEL = 50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")

/obj/item/cane/crutch
	name ="crutch"
	desc = "A long stick with a crosspiece at the top, used to help with walking."
	icon_state = "crutch"
	item_state = "crutch"

/obj/item/cane/concealed
	var/concealed_blade

/obj/item/cane/concealed/Initialize(mapload)
	. = ..()
	var/obj/item/material/sword/katana/caneblade/temp_blade = new(src)
	concealed_blade = temp_blade
	temp_blade.attack_self()

/obj/item/cane/concealed/attack_self(var/mob/user)
	var/datum/gender/T = GLOB.gender_datums[user.get_visible_gender()]
	if(concealed_blade)
		user.visible_message(span_warning("[user] has unsheathed \a [concealed_blade] from [T.his] [src]!"), "You unsheathe \the [concealed_blade] from \the [src].")
		// Calling drop/put in hands to properly call item drop/pickup procs
		playsound(src, 'sound/weapons/holster/sheathout.ogg', 50, 1)
		user.drop_from_inventory(src)
		user.put_in_hands(concealed_blade)
		user.put_in_hands(src)
		user.update_inv_l_hand(0)
		user.update_inv_r_hand()
		concealed_blade = null
		update_icon()
	else
		..()

/obj/item/cane/concealed/attackby(var/obj/item/material/sword/katana/caneblade/W, var/mob/user)
	if(!src.concealed_blade && istype(W))
		var/datum/gender/T = GLOB.gender_datums[user.get_visible_gender()]
		user.visible_message(span_warning("[user] has sheathed \a [W] into [T.his] [src]!"), "You sheathe \the [W] into \the [src].")
		playsound(src, 'sound/weapons/holster/sheathin.ogg', 50, 1)
		user.drop_from_inventory(W)
		W.loc = src
		src.concealed_blade = W
		update_icon()
	else
		..()

/obj/item/cane/concealed/update_icon()
	if(concealed_blade)
		name = initial(name)
		icon_state = initial(icon_state)
		item_state = initial(icon_state)
	else
		name = "cane shaft"
		icon_state = "caneshaft"
		item_state = "foldcane"

/obj/item/cane/white
	name = "white cane"
	desc = "A white cane. They are commonly used by the blind or visually impaired as a mobility tool or as a courtesy to others."
	icon_state = "whitecane"

/obj/item/cane/white/attack(mob/M as mob, mob/user as mob)
	if(user.a_intent == I_HELP)
		user.visible_message(span_notice("\The [user] has lightly tapped [M] on the ankle with their white cane!"))
		return TRUE
	else
		. = ..()


//Code for Telescopic White Cane writen by Gozulio

/obj/item/cane/white/collapsible
	name = "telescopic white cane"
	desc = "A telescopic white cane. They are commonly used by the blind or visually impaired as a mobility tool or as a courtesy to others."
	icon_state = "whitecane1in"
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_melee.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_melee.dmi',
		)
	slot_flags = SLOT_BELT
	w_class = ITEMSIZE_SMALL
	force = 3
	var/on = 0

/obj/item/cane/white/collapsible/attack_self(mob/user as mob)
	on = !on
	if(on)
		user.visible_message(span_infoplain(span_bold("\The [user]") + " extends the white cane."),\
				span_warning("You extend the white cane."),\
				"You hear an ominous click.")
		icon_state = "whitecane1out"
		item_state_slots = list(slot_r_hand_str = "whitecane", slot_l_hand_str = "whitecane")
		w_class = ITEMSIZE_NORMAL
		force = 5
		attack_verb = list("smacked", "struck", "cracked", "beaten")
	else
		user.visible_message(span_infoplain(span_bold("\The [user]") + " collapses the white cane."),\
		span_notice("You collapse the white cane."),\
		"You hear a click.")
		icon_state = "whitecane1in"
		item_state_slots = list(slot_r_hand_str = null, slot_l_hand_str = null)
		w_class = ITEMSIZE_SMALL
		force = 3
		attack_verb = list("hit", "poked", "prodded")

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	playsound(src, 'sound/weapons/empty.ogg', 50, 1)
	add_fingerprint(user)
	return TRUE
