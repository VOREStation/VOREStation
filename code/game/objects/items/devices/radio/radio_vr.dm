/obj/item/device/radio
	var/bluespace_radio = FALSE

/obj/item/device/radio/phone
	subspace_transmission = 1
	canhear_range = 0
	adhoc_fallback = TRUE

/obj/item/device/radio/emergency
	name = "Medbay Emergency Radio Link"
	icon_state = "med_walkietalkie"
	frequency = MED_I_FREQ
	subspace_transmission = 1
	adhoc_fallback = TRUE

/obj/item/device/radio/emergency/New()
	..()
	internal_channels = default_medbay_channels.Copy()

//Pathfinder's Subspace Radio
/obj/item/device/subspaceradio
	name = "subspace radio"
	desc = "A powerful new radio recently gifted to Nanotrasen from KHI, this communications device has the ability to send and recieve transmissions from anywhere."
	catalogue_data = list(/datum/category_item/catalogue/information/organization/khi)
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_override = 'icons/mob/back_vr.dmi'
	icon_state = "radiopack"
	item_state = "radiopack"
	slot_flags = SLOT_BACK
	force = 5
	throwforce = 6
	preserve_item = 1
	w_class = ITEMSIZE_LARGE
	action_button_name = "Remove/Replace Handset"

	var/obj/item/device/radio/subspacehandset/linked/handset

/obj/item/device/subspaceradio/New() //starts without a cell for rnd
	..()
	if(ispath(handset))
		handset = new handset(src, src)
	else
		handset = new(src, src)

/obj/item/device/subspaceradio/Destroy()
	. = ..()
	QDEL_NULL(handset)

/obj/item/device/subspaceradio/ui_action_click()
	toggle_handset()

/obj/item/device/subspaceradio/attack_hand(mob/user)
	if(loc == user)
		toggle_handset()
	else
		..()

/obj/item/device/subspaceradio/MouseDrop()
	if(ismob(loc))
		if(!CanMouseDrop(src))
			return
		var/mob/M = loc
		if(!M.unEquip(src))
			return
		add_fingerprint(usr)
		M.put_in_any_hand_if_possible(src)

/obj/item/device/subspaceradio/attackby(obj/item/weapon/W, mob/user, params)
	if(W == handset)
		reattach_handset(user)
	else
		return ..()

/obj/item/device/subspaceradio/verb/toggle_handset()
	set name = "Toggle Handset"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(!handset)
		to_chat(user, "<span class='warning'>The handset is missing!</span>")
		return

	if(handset.loc != src)
		reattach_handset(user) //Remove from their hands and back onto the defib unit
		return

	if(!slot_check())
		to_chat(user, "<span class='warning'>You need to equip [src] before taking out [handset].</span>")
	else
		if(!usr.put_in_hands(handset)) //Detach the handset into the user's hands
			to_chat(user, "<span class='warning'>You need a free hand to hold the handset!</span>")
		update_icon() //success

//checks that the base unit is in the correct slot to be used
/obj/item/device/subspaceradio/proc/slot_check()
	var/mob/M = loc
	if(!istype(M))
		return 0 //not equipped

	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_back) == src)
		return 1
	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_s_store) == src)
		return 1

	return 0

/obj/item/device/subspaceradio/dropped(mob/user)
	..()
	reattach_handset(user) //handset attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/device/subspaceradio/proc/reattach_handset(mob/user)
	if(!handset) return

	if(ismob(handset.loc))
		var/mob/M = handset.loc
		if(M.drop_from_inventory(handset, src))
			to_chat(user, "<span class='notice'>\The [handset] snaps back into the main unit.</span>")
	else
		handset.forceMove(src)

//Subspace Radio Handset
/obj/item/device/radio/subspacehandset
	name = "subspace radio handset"
	desc = "A large walkie talkie attached to the subspace radio by a retractable cord. It sits comfortably on a slot in the radio when not in use."
	bluespace_radio = TRUE
	icon_state = "signaller"
	slot_flags = null
	w_class = ITEMSIZE_LARGE

/obj/item/device/radio/subspacehandset/linked
	var/obj/item/device/subspaceradio/base_unit

/obj/item/device/radio/subspacehandset/linked/New(newloc, obj/item/device/subspaceradio/radio)
	base_unit = radio
	..(newloc)

/obj/item/device/radio/subspacehandset/linked/Destroy()
	if(base_unit)
		//ensure the base unit's icon updates
		if(base_unit.handset == src)
			base_unit.handset = null
		base_unit = null
	return ..()

/obj/item/device/radio/subspacehandset/linked/dropped(mob/user)
	..() //update twohanding
	if(base_unit)
		base_unit.reattach_handset(user) //handset attached to a base unit should never exist outside of their base unit or the mob equipping the base unit
