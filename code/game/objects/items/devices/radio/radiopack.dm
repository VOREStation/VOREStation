/obj/item/bluespaceradio
	name = "bluespace radio"
	desc = "A powerful radio that uses a tiny bluespace wormhole to send signals directly to subspace receivers and transmitters, bypassing the limitations of subspace."
	icon = 'icons/obj/device.dmi'
	icon_override = 'icons/inventory/back/mob.dmi'
	icon_state = "radiopack"
	item_state = "radiopack"
	slot_flags = SLOT_BACK
	force = 5
	throwforce = 6
	preserve_item = 1
	w_class = ITEMSIZE_LARGE
	var/obj/item/radio/bluespacehandset/linked/handset_path = /obj/item/radio/bluespacehandset/linked

/obj/item/bluespaceradio/Initialize(mapload)
	AddComponent(/datum/component/tethered_item, handset_path)
	. = ..()

/obj/item/bluespaceradio/attack_hand(mob/living/user)
	// See important note in tethered_item.dm
	if(SEND_SIGNAL(src,COMSIG_ITEM_ATTACK_SELF,user) & COMPONENT_NO_INTERACT)
		return TRUE
	. = ..()

/obj/item/bluespaceradio/MouseDrop()
	if(ismob(loc))
		if(!CanMouseDrop(src))
			return
		var/mob/M = loc
		if(!M.unEquip(src))
			return
		add_fingerprint(usr)
		M.put_in_any_hand_if_possible(src)

//Subspace Radio Handset
/obj/item/radio/bluespacehandset
	name = "bluespace radio handset"
	desc = "A large walkie talkie attached to the bluespace radio by a retractable cord. It sits comfortably on a slot in the radio when not in use."
	bluespace_radio = TRUE
	icon = 'icons/obj/device.dmi'
	icon_state = "handset"
	slot_flags = null
	w_class = ITEMSIZE_LARGE
	canhear_range = 1
	item_flags = NOSTRIP

/obj/item/radio/bluespacehandset/linked/receive_range(var/freq, var/list/level)
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
