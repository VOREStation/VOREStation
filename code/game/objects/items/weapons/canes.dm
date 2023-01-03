/obj/item/weapon/cane
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

/obj/item/weapon/cane/crutch
	name ="crutch"
	desc = "A long stick with a crosspiece at the top, used to help with walking."
	icon_state = "crutch"
	item_state = "crutch"

<<<<<<< HEAD
/obj/item/weapon/cane/concealed
=======
/obj/item/cane/telescopic
	name = "telescopic cane"
	desc = "A compact cane which can be collapsed for storage."
	icon_state = "telecanein"
	force = 3
	var/on = 0

//Code for Telescopic Cane writen by Gozulio

/obj/item/cane/telescopic/attack_self(mob/user as mob)
	on = !on
	if(on)
		user.visible_message("<span class='notice'>\The [user] extends the cane.</span>",\
				"<span class='warning'>You extend the cane.</span>",\
				"You hear an ominous click.")
		icon_state = "telecaneout"
		item_state_slots = list(slot_r_hand_str = "telecane", slot_l_hand_str = "telecane")
		w_class = ITEMSIZE_NORMAL
		force = 5
		attack_verb = list("smacked", "struck", "cracked", "beaten")
	else
		user.visible_message("<span class='notice'>\The [user] retracts the  cane.</span>",\
		"<span class='notice'>You retract the cane.</span>",\
		"You hear a click.")
		icon_state = "telecanein"
		item_state_slots = list(slot_r_hand_str = null, slot_l_hand_str = null)
		w_class = ITEMSIZE_SMALL
		force = 3
		attack_verb = list("hit", "poked", "prodded")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	playsound(src, 'sound/weapons/empty.ogg', 50, 1)
	add_fingerprint(user)
	return TRUE

/obj/item/cane/concealed
>>>>>>> 2903c367bdb... Alternative communicator and cane sprites (#8864)
	var/concealed_blade

/obj/item/weapon/cane/concealed/Initialize()
	. = ..()
	var/obj/item/weapon/material/sword/katana/caneblade/temp_blade = new(src)
	concealed_blade = temp_blade
	temp_blade.attack_self()

/obj/item/weapon/cane/concealed/attack_self(var/mob/user)
	var/datum/gender/T = gender_datums[user.get_visible_gender()]
	if(concealed_blade)
		user.visible_message("<span class='warning'>[user] has unsheathed \a [concealed_blade] from [T.his] [src]!</span>", "You unsheathe \the [concealed_blade] from \the [src].")
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

/obj/item/weapon/cane/concealed/attackby(var/obj/item/weapon/material/sword/katana/caneblade/W, var/mob/user)
	if(!src.concealed_blade && istype(W))
		var/datum/gender/T = gender_datums[user.get_visible_gender()]
		user.visible_message("<span class='warning'>[user] has sheathed \a [W] into [T.his] [src]!</span>", "You sheathe \the [W] into \the [src].")
		playsound(src, 'sound/weapons/holster/sheathin.ogg', 50, 1)
		user.drop_from_inventory(W)
		W.loc = src
		src.concealed_blade = W
		update_icon()
	else
		..()

/obj/item/weapon/cane/concealed/update_icon()
	if(concealed_blade)
		name = initial(name)
		icon_state = initial(icon_state)
		item_state = initial(icon_state)
	else
		name = "cane shaft"
		icon_state = "caneshaft"
		item_state = "foldcane"

/obj/item/weapon/cane/white
	name = "white cane"
	desc = "A white cane. They are commonly used by the blind or visually impaired as a mobility tool or as a courtesy to others."
	icon_state = "whitecane"

/obj/item/weapon/cane/white/attack(mob/M as mob, mob/user as mob)
    if(user.a_intent == I_HELP)
        user.visible_message("<span class='notice'>\The [user] has lightly tapped [M] on the ankle with their white cane!</span>")
        return TRUE
    else
        . = ..()


//Code for Telescopic White Cane writen by Gozulio

/obj/item/weapon/cane/white/collapsible
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
	var/unfoldverb = "extend"
	var/foldverb = "collapse"
	var/unfoldicon = "whitecane1out"
	var/foldicon = "whitecane1in"

/obj/item/weapon/cane/white/collapsible/attack_self(mob/user as mob)
	on = !on
	if(on)
<<<<<<< HEAD
		user.visible_message("<b>\The [user]</b> extends the white cane.",\
				"<span class='warning'>You extend the white cane.</span>",\
=======
		user.visible_message("<span class='notice'>\The [user] [unfoldverb]s the white cane.</span>",\
				"<span class='warning'>You [unfoldverb] the white cane.</span>",\
>>>>>>> 2903c367bdb... Alternative communicator and cane sprites (#8864)
				"You hear an ominous click.")
		icon_state = "[unfoldicon]"
		item_state_slots = list(slot_r_hand_str = "whitecane", slot_l_hand_str = "whitecane")
		w_class = ITEMSIZE_NORMAL
		force = 5
		attack_verb = list("smacked", "struck", "cracked", "beaten")
	else
<<<<<<< HEAD
		user.visible_message("<b>\The [user]</b> collapses the white cane.",\
		"<span class='notice'>You collapse the white cane.</span>",\
=======
		user.visible_message("<span class='notice'>\The [user] [foldverb]s the white cane.</span>",\
		"<span class='notice'>You [foldverb] the white cane.</span>",\
>>>>>>> 2903c367bdb... Alternative communicator and cane sprites (#8864)
		"You hear a click.")
		icon_state = "[foldicon]"
		item_state_slots = list(slot_r_hand_str = null, slot_l_hand_str = null)
		w_class = ITEMSIZE_SMALL
		force = 3
		attack_verb = list("hit", "poked", "prodded")

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	playsound(src, 'sound/weapons/empty.ogg', 50, 1)
	add_fingerprint(user)
	return TRUE
<<<<<<< HEAD
=======

/obj/item/cane/white/collapsible/folding
	name = "folding white cane"
	desc = "A folding white cane. They are commonly used by the blind or visually impaired as a mobility tool or as a courtesy to others."
	icon_state = "whitecane2in"
	unfoldverb = "unfold"
	foldverb = "fold"
	unfoldicon = "whitecane2out"
	foldicon = "whitecane2in"
>>>>>>> 2903c367bdb... Alternative communicator and cane sprites (#8864)
