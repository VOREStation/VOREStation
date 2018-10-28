//Pathfinder's Subspace Radio
/obj/item/device/subspaceradio
	name = "subspace radio"
	desc = "A powerful new radio recently gifted to Nanotrasen from KHI, this communications device has the ability to send and recieve transmissions from anywhere."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "radiopack"
	item_state = "parachute"
	slot_flags = SLOT_BACK
	force = 5
	throwforce = 6
	preserve_item = 1
	w_class = ITEMSIZE_LARGE
	action_button_name = "Remove/Replace Headset"

	var/obj/item/device/radio/subspaceradio/linked/headset

/obj/item/device/subspaceradio/New() //starts without a cell for rnd
	..()
	if(ispath(headset))
		headset = new headset(src, src)
	else
		headset = new(src, src)

/obj/item/device/subspaceradio/Destroy()
	. = ..()
	QDEL_NULL(headset)

/obj/item/device/subspaceradio/ui_action_click()
	toggle_headset()

/obj/item/device/subspaceradio/attack_hand(mob/user)
	if(loc == user)
		toggle_headset()
	else
		..()

/obj/item/device/subspaceradio/MouseDrop()
	if(ismob(src.loc))
		if(!CanMouseDrop(src))
			return
		var/mob/M = src.loc
		if(!M.unEquip(src))
			return
		src.add_fingerprint(usr)
		M.put_in_any_hand_if_possible(src)

/obj/item/device/subspaceradio/attackby(obj/item/weapon/W, mob/user, params)
	if(W == headset)
		reattach_headset(user)
	else
		return ..()

/obj/item/device/subspaceradio/verb/toggle_headset()
	set name = "Toggle Headset"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(!headset)
		to_chat(user, "<span class='warning'>The headset is missing!</span>")
		return

	if(headset.loc != src)
		reattach_headset(user) //Remove from their hands and back onto the defib unit
		return

	if(!slot_check())
		to_chat(user, "<span class='warning'>You need to equip [src] before taking out [headset].</span>")
	else
		if(!usr.put_in_hands(headset)) //Detach the headset into the user's hands
			to_chat(user, "<span class='warning'>You need a free hand to hold the headset!</span>")
		update_icon() //success

//checks that the base unit is in the correct slot to be used
/obj/item/device/subspaceradio/proc/slot_check()
	var/mob/M = loc
	if(!istype(M))
		return 0 //not equipped

	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_back) == src)
		return 1
	if((slot_flags & SLOT_BELT) && M.get_equipped_item(slot_belt) == src)
		return 1

	return 0

/obj/item/device/subspaceradio/dropped(mob/user)
	..()
	reattach_headset(user) //headset attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/device/subspaceradio/proc/reattach_headset(mob/user)
	if(!headset) return

	if(ismob(headset.loc))
		var/mob/M = headset.loc
		if(M.drop_from_inventory(headset, src))
			to_chat(user, "<span class='notice'>\The [headset] snap back into the main unit.</span>")
	else
		headset.forceMove(src)

//Subspace Radio Headset
/obj/item/device/radio/subspaceradio
	name = "subspace radio headset"
	desc = "A large walkie talkie attached to the subspace radio by a retractable cord. It sits comfortably on a slot in the radio when not in use."
	bluespace_radio = TRUE
	icon_state = "signaller"
	slot_flags = null
	w_class = ITEMSIZE_LARGE

/obj/item/device/radio/subspaceradio/linked
	var/obj/item/device/subspaceradio/base_unit

/obj/item/device/radio/subspaceradio/linked/New(newloc, obj/item/device/subspaceradio/radio)
	base_unit = radio
	..(newloc)

/obj/item/device/radio/subspaceradio/linked/Destroy()
	if(base_unit)
		//ensure the base unit's icon updates
		if(base_unit.headset == src)
			base_unit.headset = null
		base_unit = null
	return ..()

/obj/item/device/radio/subspaceradio/linked/dropped(mob/user)
	..() //update twohanding
	if(base_unit)
		base_unit.reattach_headset(user) //headset attached to a base unit should never exist outside of their base unit or the mob equipping the base unit
