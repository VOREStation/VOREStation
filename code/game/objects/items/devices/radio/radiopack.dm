/obj/item/device/bluespaceradio
	name = "bluespace radio"
	desc = "A powerful radio that uses a tiny bluespace wormhole to send signals directly to subspace receivers and transmitters, bypassing the limitations of subspace."
	icon = 'icons/obj/device_vr.dmi' // VOREStation Edit
	icon_override = 'icons/inventory/back/mob_vr.dmi' // VOREStation Edit
	icon_state = "radiopack"
	item_state = "radiopack"
	slot_flags = SLOT_BACK
	force = 5
	throwforce = 6
	preserve_item = 1
	w_class = ITEMSIZE_LARGE
	action_button_name = "Remove/Replace Handset"

	var/obj/item/device/radio/bluespacehandset/linked/handset = /obj/item/device/radio/bluespacehandset/linked

/obj/item/device/bluespaceradio/Initialize()
	. = ..()
	if(ispath(handset))
		handset = new handset(src, src)

/obj/item/device/bluespaceradio/Destroy()
	. = ..()
	QDEL_NULL(handset)

/obj/item/device/bluespaceradio/ui_action_click()
	toggle_handset()

/obj/item/device/bluespaceradio/attack_hand(var/mob/user)
	if(loc == user)
		toggle_handset()
	else
		..()

/obj/item/device/bluespaceradio/MouseDrop()
	if(ismob(loc))
		if(!CanMouseDrop(src))
			return
		var/mob/M = loc
		if(!M.unEquip(src))
			return
		add_fingerprint(usr)
		M.put_in_any_hand_if_possible(src)

/obj/item/device/bluespaceradio/attackby(var/obj/item/weapon/W, var/mob/user, var/params)
	if(W == handset)
		reattach_handset(user)
	else
		return ..()

/obj/item/device/bluespaceradio/verb/toggle_handset()
	set name = "Toggle Handset"
	set category = "Object"

	var/mob/living/human/user = usr
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
/obj/item/device/bluespaceradio/proc/slot_check()
	var/mob/M = loc
	if(!istype(M))
		return 0 //not equipped

	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_back) == src)
		return 1
	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_s_store) == src)
		return 1

	return 0

/obj/item/device/bluespaceradio/dropped(var/mob/user)
	..()
	reattach_handset(user) //handset attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/device/bluespaceradio/proc/reattach_handset(var/mob/user)
	if(!handset) return

	if(ismob(handset.loc))
		var/mob/M = handset.loc
		if(M.drop_from_inventory(handset, src))
			to_chat(user, "<span class='notice'>\The [handset] snaps back into the main unit.</span>")
	else
		handset.forceMove(src)

//Subspace Radio Handset
/obj/item/device/radio/bluespacehandset
	name = "bluespace radio handset"
	desc = "A large walkie talkie attached to the bluespace radio by a retractable cord. It sits comfortably on a slot in the radio when not in use."
	bluespace_radio = TRUE
	icon = 'icons/obj/device_vr.dmi' //VOREStation Edit
	icon_state = "handset" //VOREStation Edit
	slot_flags = null
	w_class = ITEMSIZE_LARGE
	canhear_range = 1

/obj/item/device/radio/bluespacehandset/linked
	var/obj/item/device/bluespaceradio/base_unit

/obj/item/device/radio/bluespacehandset/linked/Initialize(mapload, var/obj/item/device/bluespaceradio/radio)
	base_unit = radio
	. = ..()

/obj/item/device/radio/bluespacehandset/linked/Destroy()
	if(base_unit)
		//ensure the base unit's icon updates
		if(base_unit.handset == src)
			base_unit.handset = null
		base_unit = null
	return ..()

/obj/item/device/radio/bluespacehandset/linked/dropped(var/mob/user)
	..() //update twohanding
	if(base_unit)
		base_unit.reattach_handset(user) //handset attached to a base unit should never exist outside of their base unit or the mob equipping the base unit

/obj/item/device/radio/bluespacehandset/linked/receive_range(var/freq, var/list/level)
	//Only care about megabroadcasts or things that are targeted at us
	if(!(0 in level))
		return -1
	if(wires.is_cut(WIRE_RADIO_RECEIVER))
		return -1
	if(!listening)
		return -1
	if(!on)
		return -1
	if(!freq)
		return -1
	
	//Only listen on main freq
	if(freq == frequency)
		return canhear_range
	else
		return -1
